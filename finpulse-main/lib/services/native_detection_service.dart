import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../models/transaction.dart';
import 'transaction_parser.dart';
import 'gemini_service.dart';
import 'notification_service.dart';
import 'system_notification_service.dart';
import 'merchant_learning_service.dart';
import 'transaction_storage_service.dart';
import 'service_initializer.dart';
import 'app_logger.dart';

/// Result of local transaction check (before calling Gemini)
enum _LocalCheckResult {
  definitelyYes,  // Clear transaction - skip Gemini
  definitelyNot,  // Clear non-transaction - reject without Gemini
  ambiguous,      // Uncertain - call Gemini for final decision
}

/// Local regex-based transaction check to reduce Gemini API calls
_LocalCheckResult _localTransactionCheck(String text) {
  final textLower = text.toLowerCase();
  
  // === DEFINITE REJECTION PATTERNS (no API call needed) ===
  final rejectPatterns = [
    'otp', 'one time password', 'verification code',
    'login attempt', 'sign in', 'sign up',
    'offer', 'cashback available', 'earn up to', 'get flat',
    'recharge expiring', 'pack expiring', 'validity',
    'bill due', 'pay before', 'reminder',
    'will be debited', 'will be charged', 'auto-debit scheduled',
    'if balance is maintained', 'mandate', 'standing instruction',
  ];
  
  for (final pattern in rejectPatterns) {
    if (textLower.contains(pattern)) {
      return _LocalCheckResult.definitelyNot;
    }
  }
  
  // === DEFINITE TRANSACTION PATTERNS (no API call needed) ===
  // Check for amount patterns (Rs., ₹, INR followed by number)
  final hasAmount = RegExp(r'(?:rs\.?|₹|inr)\s*[\d,]+(?:\.\d{2})?', caseSensitive: false).hasMatch(text);
  
  // Past-tense transaction verbs
  final confirmedVerbs = [
    'debited', 'credited', 'sent', 'received', 'paid', 
    'transferred', 'withdrawn', 'deposited', 'deducted',
    'is credited', 'is debited', 'has been credited', 'has been debited',
    'was credited', 'was debited', 'credit of', 'debit of'
  ];
  
  final hasConfirmedVerb = confirmedVerbs.any((verb) => textLower.contains(verb));
  
  // Account pattern (A/c, Ac, Account followed by digits or X's)
  final hasAccountPattern = RegExp(r'(?:a/c|ac|account)\s*[x\d]+', caseSensitive: false).hasMatch(text);
  
  // UPI transaction indicators
  final upiIndicators = ['upi ref', 'ref no', 'txn id', 'transaction id'];
  final hasUpiRef = upiIndicators.any((u) => textLower.contains(u));
  
  if (hasAmount && hasConfirmedVerb) {
    // Also check it's not future-tense
    final futureIndicators = ['will be', 'will ', 'scheduled for', 'upcoming'];
    final isFuture = futureIndicators.any((f) => textLower.contains(f));
    
    if (!isFuture) {
      return _LocalCheckResult.definitelyYes;
    }
  }
  
  // Account + amount is very likely a transaction
  if (hasAmount && hasAccountPattern) {
    return _LocalCheckResult.definitelyYes;
  }
  
  // UPI ref with amount is definitely a transaction
  if (hasAmount && hasUpiRef) {
    return _LocalCheckResult.definitelyYes;
  }
  
  // === AMBIGUOUS - needs Gemini ===
  // Has some transaction keywords but not clear
  final transactionKeywords = ['payment', 'upi', 'neft', 'imps', 'transaction', 'a/c', 'balance'];
  final hasKeywords = transactionKeywords.any((k) => textLower.contains(k));
  
  if (hasAmount || hasKeywords) {
    return _LocalCheckResult.ambiguous;
  }
  
  // No transaction indicators at all
  return _LocalCheckResult.definitelyNot;
}

/// Native Detection Service for FinPulse
///
/// Bridges native Android services (NotificationListener, Accessibility, SMS)
/// with the Flutter parsing pipeline.
class NativeDetectionService {
  static const _channel = MethodChannel('com.finpulse/transaction_detection');
  static NativeDetectionService? _instance;

  /// Toggle between mock and real Gemini API
  /// Set to true to use real Gemini API for complex SMS parsing
  /// Set to false to use mock/regex-only parsing (for testing)
  static bool useRealGemini = true;

  final List<void Function(Transaction)> _listeners = [];
  bool _isInitialized = false;

  static NativeDetectionService get instance {
    _instance ??= NativeDetectionService._();
    return _instance!;
  }

  NativeDetectionService._();

  /// Initialize the service and set up method call handler
  Future<void> init() async {
    if (_isInitialized) return;

    _channel.setMethodCallHandler(_handleMethodCall);
    _isInitialized = true;
  }

  /// Add a listener for transaction detections
  void addListener(void Function(Transaction) listener) {
    _listeners.add(listener);
  }

  /// Remove a listener
  void removeListener(void Function(Transaction) listener) {
    _listeners.remove(listener);
  }

  /// Handle method calls from native side
  Future<dynamic> _handleMethodCall(MethodCall call) async {
    if (call.method == 'onTransactionDetected') {
      final data = Map<String, dynamic>.from(call.arguments as Map);
      await _processDetection(data);
    }
    return null;
  }

  /// Process a detection from native services
  Future<void> _processDetection(Map<String, dynamic> data) async {
    final source = data['source'] as String;
    String rawText = '';
    final logger = AppLogger.instance;

    // Extract raw text based on source and log data collection
    switch (source) {
      case 'notification':
        rawText = '${data['title'] ?? ''} ${data['text'] ?? ''}'.trim();
        logger.logNotificationReceived(
          packageName: data['packageName'] as String? ?? 'unknown',
          title: data['title'] as String?,
          text: data['text'] as String?,
        );
        break;
      case 'accessibility':
        rawText = data['rawText'] as String? ?? '';
        logger.logAccessibilityEvent(
          packageName: data['packageName'] as String? ?? 'unknown',
          eventType: data['eventType'] as String? ?? 'unknown',
          rawText: rawText,
        );
        break;
      case 'sms':
        rawText = data['body'] as String? ?? '';
        logger.logSmsReceived(
          sender: data['sender'] as String? ?? 'unknown',
          body: rawText,
          timestamp: DateTime.now(),
        );
        break;
      default:
        return;
    }

    if (rawText.isEmpty) return;

    // Log data flow stage
    logger.logDataFlowStage(
      stage: 'PARSING_START',
      description: 'Starting transaction parsing',
      data: {'source': source, 'textLength': rawText.length},
    );

    // Determine detection source
    final detectionSource = switch (source) {
      'notification' => DetectionSource.notification,
      'accessibility' => DetectionSource.accessibility,
      'sms' => DetectionSource.sms,
      _ => DetectionSource.manual,
    };

    // ========== LOCAL PRE-FILTER (Save API Quota) ==========
    // Quick regex-based check before calling Gemini
    final localCheckResult = _localTransactionCheck(rawText);
    
    if (localCheckResult == _LocalCheckResult.definitelyNot) {
      // Obvious non-transaction - skip without calling Gemini
      logger.logDataFlowStage(
        stage: 'LOCAL_FILTER_REJECTED',
        description: 'Rejected by local filter (no transaction indicators)',
      );
      debugPrint('[NativeDetectionService] ❌ Local filter: definitely NOT a transaction');
      return;
    }
    
    if (localCheckResult == _LocalCheckResult.definitelyYes) {
      // Obvious transaction - proceed without calling Gemini
      logger.logDataFlowStage(
        stage: 'LOCAL_FILTER_PASSED',
        description: 'Passed local filter (clear transaction indicators)',
      );
      debugPrint('[NativeDetectionService] ✅ Local filter: definitely a transaction, skipping Gemini');
    } else {
      // Ambiguous - GEMINI PAUSED, proceed anyway
      // (Previously called Gemini, now proceeding without API call)
      logger.logDataFlowStage(
        stage: 'AMBIGUOUS_PASSTHROUGH',
        description: 'Ambiguous message, proceeding without Gemini (API paused)',
        data: {'source': source},
      );
      debugPrint('[NativeDetectionService] ⏭️ Ambiguous message, proceeding without Gemini (paused)');
    }

    debugPrint('[NativeDetectionService] ✅ Proceeding to parse transaction');

    // Parse the transaction using our Universal Parser
    ParseResult result;

    // Try regex first, then Gemini if needed
    result = TransactionParser.parse(rawText, source: detectionSource);

    if (!result.success) {
      // Try real Gemini AI if enabled, otherwise use mock
      if (useRealGemini) {
        try {
          logger.logDataFlowStage(
            stage: 'GEMINI_FALLBACK',
            description: 'Regex failed, calling Gemini API',
          );
          debugPrint(
            '[NativeDetectionService] Regex failed, trying Gemini API...',
          );
          result = await GeminiService.parseWithAI(
            rawText,
            source: detectionSource,
          );
          debugPrint(
            '[NativeDetectionService] Gemini result: ${result.success}',
          );
        } catch (e) {
          debugPrint(
            '[NativeDetectionService] Gemini API error: $e, falling back to mock',
          );
          logger.logError(AppLogger.categoryGemini, 'Gemini fallback to mock', {
            'error': e.toString(),
          });
          result = GeminiService.mockParseWithAI(
            rawText,
            source: detectionSource,
          );
        }
      } else {
        // Use mock for testing (no API call)
        logger.logDataFlowStage(
          stage: 'MOCK_PARSING',
          description: 'Using mock parser (Gemini disabled)',
        );
        result = GeminiService.mockParseWithAI(
          rawText,
          source: detectionSource,
        );
      }
    }

    if (result.success && result.transaction != null) {
      // Link transaction to dummy bank account for unified tracking
      final transaction = result.transaction!.copyWith(
        accountLastDigits: '4521', // Link all detected transactions to demo account
      );

      // Log transaction storage
      logger.logDataFlowStage(
        stage: 'STORAGE',
        description: 'Saving parsed transaction to database',
        data: {'amount': transaction.amount, 'parsedByAI': result.usedAI},
      );

      // Save to SQLite database (unified storage)
      // Returns true if inserted (new), false if duplicate
      final wasInserted = await ServiceInitializer.transactions.addTransaction(transaction);

      if (wasInserted) {
        // ========== ONLY TRIGGER NOTIFICATIONS FOR NEW TRANSACTIONS ==========
        debugPrint('[NativeDetectionService] 🆕 NEW transaction - will trigger notifications');
        
        logger.logTransactionSaved(
          transactionId: transaction.id,
          amount: transaction.amount,
          source: source,
          parsedByAI: result.usedAI,
        );

        // Check if merchant is already learned
        final merchantId = transaction.rawMerchantId;
        if (merchantId != null) {
          final mapping = MerchantLearningService.instance.getMapping(merchantId);
          if (mapping != null) {
            // Auto-categorize using learned mapping!
            // In a full implementation, we could attach the category here
          }
        }

        // Trigger Golden Window notification (ONLY for new transactions)
        debugPrint('[NativeDetectionService] 🪟 Triggering Golden Window');
        NotificationService.instance.triggerGoldenWindow(transaction);
        
        // Also show system tray notification (visible when app minimized)
        debugPrint('[NativeDetectionService] 📱 Showing system notification');
        await SystemNotificationService.instance.showTransactionNotification(transaction);
        
        debugPrint('[NativeDetectionService] ✅ New transaction saved, notifications triggered');

        // Notify listeners (ONLY for new transactions)
        for (final listener in _listeners) {
          listener(transaction);
        }
      } else {
        // DUPLICATE - NO NOTIFICATIONS SHOULD BE TRIGGERED
        debugPrint('[NativeDetectionService] ⏭️ DUPLICATE transaction - NO notifications');
        logger.logDataFlowStage(
          stage: 'DUPLICATE_SKIPPED',
          description: 'Transaction was a duplicate, skipping notification',
          data: {'amount': transaction.amount},
        );
      }
    }
  }

  // === Status Check Methods ===

  /// Check if Notification Listener is enabled
  Future<bool> isNotificationListenerEnabled() async {
    try {
      final result = await _channel.invokeMethod<bool>(
        'isNotificationListenerEnabled',
      );
      return result ?? false;
    } catch (e) {
      return false;
    }
  }

  /// Open Notification Listener settings
  Future<void> openNotificationListenerSettings() async {
    try {
      await _channel.invokeMethod('openNotificationListenerSettings');
    } catch (e) {
      // Ignore if not supported
    }
  }

  /// Check if Accessibility Service is enabled
  Future<bool> isAccessibilityEnabled() async {
    try {
      final result = await _channel.invokeMethod<bool>(
        'isAccessibilityEnabled',
      );
      return result ?? false;
    } catch (e) {
      return false;
    }
  }

  /// Open Accessibility settings
  Future<void> openAccessibilitySettings() async {
    try {
      await _channel.invokeMethod('openAccessibilitySettings');
    } catch (e) {
      // Ignore if not supported
    }
  }

  /// Get overall service status
  Future<Map<String, bool>> getServiceStatus() async {
    try {
      final result = await _channel.invokeMethod<Map>('getServiceStatus');
      return {
        'notificationListener':
            result?['notificationListener'] as bool? ?? false,
        'accessibility': result?['accessibility'] as bool? ?? false,
      };
    } catch (e) {
      return {'notificationListener': false, 'accessibility': false};
    }
  }
}
