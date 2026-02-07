import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../models/transaction.dart';

/// System Notification Service for FinPulse
/// Handles system tray notifications with deep-link support
class SystemNotificationService {
  static final SystemNotificationService instance = SystemNotificationService._();
  SystemNotificationService._();

  final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();
  
  // Callback for handling notification taps - set by MainShell
  static void Function(String transactionId)? onNotificationTap;
  
  // Queue for pending notification tap when callback not yet set
  static String? _pendingNotificationTransactionId;
  
  /// Check if there's a pending notification to handle
  static String? consumePendingNotification() {
    final pending = _pendingNotificationTransactionId;
    _pendingNotificationTransactionId = null;
    if (pending != null) {
      debugPrint('[SystemNotificationService] 🔄 Consuming pending notification: $pending');
    }
    return pending;
  }

  /// Initialize the notification service
  Future<void> init() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(
      settings,
      onDidReceiveNotificationResponse: _onNotificationTap,
    );
    
    // Check if app was launched from notification
    final launchDetails = await _notifications.getNotificationAppLaunchDetails();
    if (launchDetails?.didNotificationLaunchApp == true) {
      final payload = launchDetails?.notificationResponse?.payload;
      if (payload != null && payload.isNotEmpty) {
        debugPrint('[SystemNotificationService] 🚀 App launched from notification');
        _handlePayload(payload);
      }
    }

    // Request permissions on Android 13+
    await _requestPermissions();

    debugPrint('[SystemNotificationService] ✅ Initialized');
  }

  Future<void> _requestPermissions() async {
    final androidPlugin = _notifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    if (androidPlugin != null) {
      await androidPlugin.requestNotificationsPermission();
    }
  }

  /// Handle notification tap
  static void _onNotificationTap(NotificationResponse response) {
    final payload = response.payload;
    debugPrint('[SystemNotificationService] 📲 NOTIFICATION TAPPED!');
    if (payload != null && payload.isNotEmpty) {
      debugPrint('[SystemNotificationService] 📲 Payload: $payload');
      _handlePayload(payload);
    } else {
      debugPrint('[SystemNotificationService] ⚠️ No payload in notification');
    }
  }
  
  /// Parse payload and trigger callback or queue
  static void _handlePayload(String payload) {
    try {
      final data = jsonDecode(payload);
      final transactionId = data['transactionId'] as String?;
      
      if (transactionId != null) {
        debugPrint('[SystemNotificationService] 🔍 Transaction ID: $transactionId');
        
        // Try callback first
        if (onNotificationTap != null) {
          debugPrint('[SystemNotificationService] ✅ Calling tap callback');
          onNotificationTap!(transactionId);
        } else {
          // Callback not set yet (app starting), queue for later
          debugPrint('[SystemNotificationService] ⏳ Callback not set, queueing for later');
          _pendingNotificationTransactionId = transactionId;
        }
      } else {
        debugPrint('[SystemNotificationService] ⚠️ No transactionId in payload');
      }
    } catch (e) {
      debugPrint('[SystemNotificationService] ❌ Failed to parse payload: $e');
    }
  }

  /// Show a transaction notification
  Future<void> showTransactionNotification(Transaction transaction) async {
    final id = transaction.hashCode.abs() % 100000; // Unique notification ID
    
    // Format notification content
    final typeEmoji = transaction.type == TransactionType.credit ? '💰' : '💸';
    final typeText = transaction.type == TransactionType.credit ? 'Received' : 'Spent';
    final title = '$typeEmoji $typeText ₹${transaction.amount.toStringAsFixed(0)}';
    final body = transaction.merchantName ?? transaction.rawMerchantId ?? 'Transaction detected';

    // Create payload with transaction ID for deep-linking
    final payload = jsonEncode({
      'transactionId': transaction.id,
      'amount': transaction.amount,
      'type': transaction.type.name,
    });

    const androidDetails = AndroidNotificationDetails(
      'finpulse_transactions',
      'Transaction Alerts',
      channelDescription: 'Alerts for detected transactions',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
      enableVibration: true,
      playSound: true,
      icon: '@mipmap/ic_launcher',
      color: Color(0xFF29D6C7),
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.show(
      id,
      title,
      body,
      details,
      payload: payload,
    );

    debugPrint('[SystemNotificationService] 📱 Notification shown: $title');
    debugPrint('[SystemNotificationService] 📦 Payload: $payload');
  }

  /// Cancel all notifications
  Future<void> cancelAll() async {
    await _notifications.cancelAll();
  }
}
