import 'package:flutter/material.dart';
import 'package:drift/drift.dart';

import '../models/transaction.dart';
import '../database/database.dart' hide Transaction;
import 'merchant_learning_service.dart';
import 'app_logger.dart';

/// Notification Service for FinPulse.
/// Handles the "Golden Window" notification flow.
///
/// Note: This is a UI-based notification system using in-app overlays.
/// For system-level notifications, add flutter_local_notifications package.
class NotificationService {
  static NotificationService? _instance;

  final List<PendingNotification> _pendingNotifications = [];
  final List<VoidCallback> _listeners = [];

  static NotificationService get instance {
    _instance ??= NotificationService._();
    return _instance!;
  }

  NotificationService._();

  /// Get all pending notifications
  List<PendingNotification> get pendingNotifications =>
      List.unmodifiable(_pendingNotifications);

  /// Add a listener for notification changes
  void addListener(VoidCallback listener) {
    _listeners.add(listener);
  }

  /// Remove a listener
  void removeListener(VoidCallback listener) {
    _listeners.remove(listener);
  }

  void _notifyListeners() {
    debugPrint('[NotificationService] 📢 Notifying ${_listeners.length} listeners');
    for (final listener in _listeners) {
      listener();
    }
  }

  /// Trigger a Golden Window notification for a detected transaction
  void triggerGoldenWindow(Transaction transaction) {
    debugPrint('[NotificationService] 🪟 triggerGoldenWindow called for amount: ${transaction.amount}');
    
    // Check if we already know this merchant
    final learning = MerchantLearningService.instance;
    final existingMapping = transaction.rawMerchantId != null
        ? learning.getMapping(transaction.rawMerchantId!)
        : null;

    final notification = PendingNotification(
      id: 'notif_${DateTime.now().millisecondsSinceEpoch}',
      transaction: transaction,
      suggestedCategory: existingMapping?.category,
      suggestedName: existingMapping?.friendlyName,
      createdAt: DateTime.now(),
    );

    _pendingNotifications.insert(0, notification);
    debugPrint('[NotificationService] 📋 Added notification, total pending: ${_pendingNotifications.length}');
    _notifyListeners();
  }

  /// Handle user response to a notification
  Future<void> handleResponse({
    required String notificationId,
    required String category,
    String? friendlyName,
    String? inputMethod, // 'tap', 'voice', 'text'
    String? rawInput, // What user typed/spoke
  }) async {
    final index = _pendingNotifications.indexWhere(
      (n) => n.id == notificationId,
    );
    if (index == -1) return;

    final notification = _pendingNotifications[index];
    final transaction = notification.transaction;
    final now = DateTime.now().millisecondsSinceEpoch;
    final responseTimeMs = DateTime.now()
        .difference(notification.createdAt)
        .inMilliseconds;

    // Learn the merchant mapping
    if (transaction.rawMerchantId != null) {
      await MerchantLearningService.instance.learnMerchant(
        rawMerchantId: transaction.rawMerchantId!,
        category: category,
        friendlyName: friendlyName,
      );
    }

    // Record user response for Gemini learning
    try {
      final db = AppDatabase.instance;
      final userCorrection =
          notification.suggestedCategory != null &&
              notification.suggestedCategory != category
          ? category
          : null;

      await db.userResponseDao.insertResponse(
        UserResponsesCompanion.insert(
          transactionId: transaction.id,
          inputMethod: inputMethod ?? 'tap',
          finalCategory: category,
          createdAt: now,
          aiSuggestions: Value(notification.suggestedCategory),
          rawInput: Value(rawInput),
          userConfirmed: Value(userCorrection == null),
          userCorrection: Value(userCorrection),
          merchantAtTime: Value(transaction.rawMerchantId),
          amountAtTime: Value(transaction.amount),
          responseTimeMs: Value(responseTimeMs),
          confirmedAt: Value(now),
        ),
      );

      // Log feedback loop interaction
      AppLogger.instance.logUserCategorySelection(
        transactionId: transaction.id,
        selectedCategory: category,
        suggestedCategory: notification.suggestedCategory,
        inputMethod: inputMethod ?? 'tap',
        responseTimeMs: responseTimeMs,
      );

      debugPrint('[NotificationService] Recorded user response for learning');
    } catch (e) {
      debugPrint('[NotificationService] Failed to record user response: $e');
    }

    // Mark as handled
    _pendingNotifications[index] = notification.copyWith(
      isHandled: true,
      selectedCategory: category,
    );

    _notifyListeners();
  }

  /// Dismiss a notification without learning
  void dismiss(String notificationId) {
    _pendingNotifications.removeWhere((n) => n.id == notificationId);
    _notifyListeners();
  }

  /// Snooze a notification for later
  void snooze(String notificationId) {
    final index = _pendingNotifications.indexWhere(
      (n) => n.id == notificationId,
    );
    if (index == -1) return;

    _pendingNotifications[index] = _pendingNotifications[index].copyWith(
      snoozedUntil: DateTime.now().add(const Duration(hours: 1)),
    );

    _notifyListeners();
  }

  /// Clear all handled notifications
  void clearHandled() {
    _pendingNotifications.removeWhere((n) => n.isHandled);
    _notifyListeners();
  }

  /// Get count of unhandled notifications
  int get unhandledCount =>
      _pendingNotifications.where((n) => !n.isHandled && !n.isSnoozed).length;
}

/// A pending notification waiting for user response
class PendingNotification {
  final String id;
  final Transaction transaction;
  final String? suggestedCategory; // Pre-filled if merchant is learned
  final String? suggestedName;
  final DateTime createdAt;
  final bool isHandled;
  final String? selectedCategory;
  final DateTime? snoozedUntil;

  const PendingNotification({
    required this.id,
    required this.transaction,
    this.suggestedCategory,
    this.suggestedName,
    required this.createdAt,
    this.isHandled = false,
    this.selectedCategory,
    this.snoozedUntil,
  });

  /// Check if notification is currently snoozed
  bool get isSnoozed =>
      snoozedUntil != null && DateTime.now().isBefore(snoozedUntil!);

  /// Time since notification was created
  Duration get age => DateTime.now().difference(createdAt);

  /// Check if still in "Golden Window" (<10 seconds)
  bool get isInGoldenWindow => age.inSeconds <= 10;

  PendingNotification copyWith({
    String? id,
    Transaction? transaction,
    String? suggestedCategory,
    String? suggestedName,
    DateTime? createdAt,
    bool? isHandled,
    String? selectedCategory,
    DateTime? snoozedUntil,
  }) {
    return PendingNotification(
      id: id ?? this.id,
      transaction: transaction ?? this.transaction,
      suggestedCategory: suggestedCategory ?? this.suggestedCategory,
      suggestedName: suggestedName ?? this.suggestedName,
      createdAt: createdAt ?? this.createdAt,
      isHandled: isHandled ?? this.isHandled,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      snoozedUntil: snoozedUntil ?? this.snoozedUntil,
    );
  }
}

/// Standard expense categories for quick selection
class ExpenseCategories {
  static const List<CategoryItem> all = [
    CategoryItem(emoji: '🍕', name: 'Food', color: 0xFFF97316),
    CategoryItem(emoji: '🛒', name: 'Groceries', color: 0xFF10B981),
    CategoryItem(emoji: '🚗', name: 'Transport', color: 0xFF3B82F6),
    CategoryItem(emoji: '🎬', name: 'Entertainment', color: 0xFF8B5CF6),
    CategoryItem(emoji: '💊', name: 'Health', color: 0xFFEC4899),
    CategoryItem(emoji: '🛍️', name: 'Shopping', color: 0xFFF59E0B),
    CategoryItem(emoji: '📱', name: 'Bills', color: 0xFF6366F1),
    CategoryItem(emoji: '🏠', name: 'Rent', color: 0xFF14B8A6),
    CategoryItem(emoji: '☕', name: 'Coffee', color: 0xFF78350F),
    CategoryItem(emoji: '💰', name: 'Other', color: 0xFF64748B),
  ];

  /// Get category by name
  static CategoryItem? getByName(String name) {
    try {
      return all.firstWhere((c) => c.name.toLowerCase() == name.toLowerCase());
    } catch (_) {
      return null;
    }
  }
}

/// A category item with emoji and color
class CategoryItem {
  final String emoji;
  final String name;
  final int color;

  const CategoryItem({
    required this.emoji,
    required this.name,
    required this.color,
  });

  /// Get display label with emoji
  String get label => '$emoji $name';

  /// Get Color object
  Color get colorValue => Color(color);
}
