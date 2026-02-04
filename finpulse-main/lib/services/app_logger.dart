import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';

/// Centralized logging service for FinPulse
/// Tracks data collection, Gemini interactions, and data flow
class AppLogger {
  static AppLogger? _instance;
  static AppLogger get instance {
    _instance ??= AppLogger._();
    return _instance!;
  }

  AppLogger._();

  File? _logFile;
  final List<LogEntry> _memoryLogs = [];
  bool _isInitialized = false;

  /// Maximum logs to keep in memory
  static const int maxMemoryLogs = 500;

  /// Log categories
  static const String categoryDataCollection = 'DATA_COLLECTION';
  static const String categoryGemini = 'GEMINI_API';
  static const String categoryStorage = 'STORAGE';
  static const String categoryFeedback = 'FEEDBACK_LOOP';
  static const String categoryDataFlow = 'DATA_FLOW';
  static const String categoryError = 'ERROR';

  /// Initialize the logger
  Future<void> init() async {
    if (_isInitialized) return;

    try {
      final dir = await getApplicationDocumentsDirectory();
      final logDir = Directory('${dir.path}/finpulse_logs');
      if (!await logDir.exists()) {
        await logDir.create(recursive: true);
      }

      final dateStr = DateFormat('yyyy-MM-dd').format(DateTime.now());
      _logFile = File('${logDir.path}/finpulse_$dateStr.log');

      _isInitialized = true;
      logInfo(categoryDataFlow, 'Logger initialized', {
        'logFile': _logFile!.path,
      });
    } catch (e) {
      debugPrint('[AppLogger] Failed to initialize: $e');
      _isInitialized = true; // Continue with memory-only logging
    }
  }

  // ===========================================================================
  // DATA COLLECTION LOGGING
  // ===========================================================================

  /// Log SMS received
  void logSmsReceived({
    required String sender,
    required String body,
    required DateTime timestamp,
  }) {
    logInfo(categoryDataCollection, 'SMS Received', {
      'source': 'sms',
      'sender': sender,
      'bodyLength': body.length,
      'bodyPreview': body.substring(0, body.length > 50 ? 50 : body.length),
      'timestamp': timestamp.toIso8601String(),
    });
  }

  /// Log notification received
  void logNotificationReceived({
    required String packageName,
    required String? title,
    required String? text,
  }) {
    logInfo(categoryDataCollection, 'Notification Received', {
      'source': 'notification',
      'packageName': packageName,
      'title': title,
      'textLength': text?.length ?? 0,
      'textPreview':
          text?.substring(0, (text.length > 50 ? 50 : text.length)) ?? '',
    });
  }

  /// Log accessibility event
  void logAccessibilityEvent({
    required String packageName,
    required String eventType,
    required String? rawText,
  }) {
    logInfo(categoryDataCollection, 'Accessibility Event', {
      'source': 'accessibility',
      'packageName': packageName,
      'eventType': eventType,
      'textLength': rawText?.length ?? 0,
    });
  }

  // ===========================================================================
  // GEMINI API LOGGING
  // ===========================================================================

  /// Log Gemini API request
  void logGeminiRequest({
    required String operation,
    required String promptPreview,
    Map<String, dynamic>? metadata,
  }) {
    logInfo(categoryGemini, 'Gemini Request', {
      'operation': operation,
      'promptLength': promptPreview.length,
      'promptPreview': promptPreview.substring(
        0,
        promptPreview.length > 100 ? 100 : promptPreview.length,
      ),
      ...?metadata,
    });
  }

  /// Log Gemini API response
  void logGeminiResponse({
    required String operation,
    required bool success,
    String? responsePreview,
    int? latencyMs,
    String? errorMessage,
  }) {
    final data = <String, dynamic>{
      'operation': operation,
      'success': success,
      'latencyMs': latencyMs,
    };

    if (success && responsePreview != null) {
      data['responseLength'] = responsePreview.length;
      data['responsePreview'] = responsePreview.substring(
        0,
        responsePreview.length > 100 ? 100 : responsePreview.length,
      );
    } else if (!success) {
      data['error'] = errorMessage;
    }

    if (success) {
      logInfo(categoryGemini, 'Gemini Response', data);
    } else {
      logError(categoryGemini, 'Gemini Failed', data);
    }
  }

  // ===========================================================================
  // STORAGE LOGGING
  // ===========================================================================

  /// Log transaction saved
  void logTransactionSaved({
    required String transactionId,
    required double amount,
    required String source,
    required bool parsedByAI,
  }) {
    logInfo(categoryStorage, 'Transaction Saved', {
      'transactionId': transactionId,
      'amount': amount,
      'source': source,
      'parsedByAI': parsedByAI,
    });
  }

  /// Log transaction updated
  void logTransactionUpdated({
    required String transactionId,
    required String field,
    required String? oldValue,
    required String? newValue,
  }) {
    logInfo(categoryStorage, 'Transaction Updated', {
      'transactionId': transactionId,
      'field': field,
      'oldValue': oldValue,
      'newValue': newValue,
    });
  }

  /// Log database query
  void logDatabaseQuery({
    required String operation,
    required String table,
    int? resultCount,
  }) {
    logInfo(categoryStorage, 'Database Query', {
      'operation': operation,
      'table': table,
      'resultCount': resultCount,
    });
  }

  // ===========================================================================
  // FEEDBACK LOOP LOGGING
  // ===========================================================================

  /// Log user category selection
  void logUserCategorySelection({
    required String transactionId,
    required String selectedCategory,
    String? suggestedCategory,
    required String inputMethod,
    required int responseTimeMs,
  }) {
    final wasCorrection =
        suggestedCategory != null && suggestedCategory != selectedCategory;

    logInfo(categoryFeedback, 'User Category Selection', {
      'transactionId': transactionId,
      'selectedCategory': selectedCategory,
      'suggestedCategory': suggestedCategory,
      'wasCorrection': wasCorrection,
      'inputMethod': inputMethod,
      'responseTimeMs': responseTimeMs,
    });
  }

  /// Log learning context used
  void logLearningContextUsed({
    required String merchantId,
    required Map<String, dynamic> context,
  }) {
    logInfo(categoryFeedback, 'Learning Context Used', {
      'merchantId': merchantId,
      'contextKeys': context.keys.toList(),
      'hasMerchantHistory': context.containsKey('merchant_history'),
      'hasPhrasePatterns': context.containsKey('phrase_patterns'),
    });
  }

  // ===========================================================================
  // DATA FLOW LOGGING
  // ===========================================================================

  /// Log data flow stage
  void logDataFlowStage({
    required String stage,
    required String description,
    Map<String, dynamic>? data,
  }) {
    logInfo(categoryDataFlow, 'Data Flow: $stage', {
      'description': description,
      ...?data,
    });
  }

  // ===========================================================================
  // CORE LOGGING METHODS
  // ===========================================================================

  /// Log info level message
  void logInfo(String category, String message, [Map<String, dynamic>? data]) {
    _log(LogLevel.info, category, message, data);
  }

  /// Log warning level message
  void logWarning(
    String category,
    String message, [
    Map<String, dynamic>? data,
  ]) {
    _log(LogLevel.warning, category, message, data);
  }

  /// Log error level message
  void logError(String category, String message, [Map<String, dynamic>? data]) {
    _log(LogLevel.error, category, message, data);
  }

  void _log(
    LogLevel level,
    String category,
    String message,
    Map<String, dynamic>? data,
  ) {
    final entry = LogEntry(
      timestamp: DateTime.now(),
      level: level,
      category: category,
      message: message,
      data: data,
    );

    // Add to memory
    _memoryLogs.add(entry);
    if (_memoryLogs.length > maxMemoryLogs) {
      _memoryLogs.removeAt(0);
    }

    // Print to debug console
    final prefix = '[${entry.levelString}] [${entry.category}]';
    debugPrint('$prefix ${entry.message}');
    if (data != null && data.isNotEmpty) {
      debugPrint('  → ${jsonEncode(data)}');
    }

    // Write to file asynchronously
    _writeToFile(entry);
  }

  Future<void> _writeToFile(LogEntry entry) async {
    if (_logFile == null) return;

    try {
      final line = '${entry.toLogLine()}\n';
      await _logFile!.writeAsString(line, mode: FileMode.append);
    } catch (e) {
      // Silently fail file writes
    }
  }

  // ===========================================================================
  // LOG RETRIEVAL & EXPORT
  // ===========================================================================

  /// Get logs from memory
  List<LogEntry> getLogs({String? category, LogLevel? minLevel, int? limit}) {
    var logs = _memoryLogs.toList();

    if (category != null) {
      logs = logs.where((l) => l.category == category).toList();
    }

    if (minLevel != null) {
      logs = logs.where((l) => l.level.index >= minLevel.index).toList();
    }

    if (limit != null && logs.length > limit) {
      logs = logs.sublist(logs.length - limit);
    }

    return logs;
  }

  /// Get logs as formatted string
  String getLogsAsString({String? category, int? limit}) {
    final logs = getLogs(category: category, limit: limit);
    return logs.map((l) => l.toLogLine()).join('\n');
  }

  /// Export logs to file and return path
  Future<String?> exportLogs() async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
      final exportFile = File('${dir.path}/finpulse_export_$timestamp.log');

      final content = _memoryLogs.map((l) => l.toLogLine()).join('\n');
      await exportFile.writeAsString(content);

      logInfo(categoryDataFlow, 'Logs Exported', {
        'path': exportFile.path,
        'entryCount': _memoryLogs.length,
      });
      return exportFile.path;
    } catch (e) {
      logError(categoryError, 'Log Export Failed', {'error': e.toString()});
      return null;
    }
  }

  /// Get log file path
  String? get logFilePath => _logFile?.path;

  /// Get statistics
  Map<String, dynamic> getStats() {
    final categoryCount = <String, int>{};
    for (final log in _memoryLogs) {
      categoryCount[log.category] = (categoryCount[log.category] ?? 0) + 1;
    }

    return {
      'totalLogs': _memoryLogs.length,
      'byCategory': categoryCount,
      'logFilePath': _logFile?.path,
    };
  }

  /// Clear memory logs
  void clearMemoryLogs() {
    _memoryLogs.clear();
  }
}

/// Log level enum
enum LogLevel { info, warning, error }

/// Log entry model
class LogEntry {
  final DateTime timestamp;
  final LogLevel level;
  final String category;
  final String message;
  final Map<String, dynamic>? data;

  LogEntry({
    required this.timestamp,
    required this.level,
    required this.category,
    required this.message,
    this.data,
  });

  String get levelString {
    switch (level) {
      case LogLevel.info:
        return 'INFO';
      case LogLevel.warning:
        return 'WARN';
      case LogLevel.error:
        return 'ERROR';
    }
  }

  String toLogLine() {
    final ts = DateFormat('yyyy-MM-dd HH:mm:ss.SSS').format(timestamp);
    final dataStr = data != null ? ' | ${jsonEncode(data)}' : '';
    return '[$ts] [$levelString] [$category] $message$dataStr';
  }

  Map<String, dynamic> toJson() => {
    'timestamp': timestamp.toIso8601String(),
    'level': levelString,
    'category': category,
    'message': message,
    'data': data,
  };
}
