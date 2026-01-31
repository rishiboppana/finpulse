import 'package:flutter/services.dart';

import '../models/transaction.dart';
import 'transaction_parser.dart';
import 'gemini_service.dart';
import 'notification_service.dart';
import 'merchant_learning_service.dart';
import 'transaction_storage_service.dart';

/// Native Detection Service for FinPulse
/// 
/// Bridges native Android services (NotificationListener, Accessibility, SMS)
/// with the Flutter parsing pipeline.
class NativeDetectionService {
  static const _channel = MethodChannel('com.finpulse/transaction_detection');
  static NativeDetectionService? _instance;
  
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
    
    // Extract raw text based on source
    switch (source) {
      case 'notification':
        rawText = '${data['title'] ?? ''} ${data['text'] ?? ''}'.trim();
        break;
      case 'accessibility':
        rawText = data['rawText'] as String? ?? '';
        break;
      case 'sms':
        rawText = data['body'] as String? ?? '';
        break;
      default:
        return;
    }
    
    if (rawText.isEmpty) return;
    
    // Determine detection source
    final detectionSource = switch (source) {
      'notification' => DetectionSource.notification,
      'accessibility' => DetectionSource.accessibility,
      'sms' => DetectionSource.sms,
      _ => DetectionSource.manual,
    };
    
    // Parse the transaction using our Universal Parser
    ParseResult result;
    
    // Try regex first, then Gemini if needed
    result = TransactionParser.parse(rawText, source: detectionSource);
    
    if (!result.success) {
      // Fallback to mock AI parsing for demo
      result = GeminiService.mockParseWithAI(rawText, source: detectionSource);
    }
    
    if (result.success && result.transaction != null) {
      final transaction = result.transaction!;
      
      // Save to local storage
      await TransactionStorageService.instance.addTransaction(transaction);
      
      // Check if merchant is already learned
      final merchantId = transaction.rawMerchantId;
      if (merchantId != null) {
        final mapping = MerchantLearningService.instance.getMapping(merchantId);
        if (mapping != null) {
          // Auto-categorize using learned mapping!
          // In a full implementation, we could attach the category here
        }
      }
      
      // Trigger Golden Window notification
      NotificationService.instance.triggerGoldenWindow(transaction);
      
      // Notify listeners
      for (final listener in _listeners) {
        listener(transaction);
      }
    }
  }

  // === Status Check Methods ===

  /// Check if Notification Listener is enabled
  Future<bool> isNotificationListenerEnabled() async {
    try {
      final result = await _channel.invokeMethod<bool>('isNotificationListenerEnabled');
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
      final result = await _channel.invokeMethod<bool>('isAccessibilityEnabled');
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
        'notificationListener': result?['notificationListener'] as bool? ?? false,
        'accessibility': result?['accessibility'] as bool? ?? false,
      };
    } catch (e) {
      return {
        'notificationListener': false,
        'accessibility': false,
      };
    }
  }
}
