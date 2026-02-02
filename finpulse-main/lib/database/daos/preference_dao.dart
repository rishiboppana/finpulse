import 'package:drift/drift.dart';
import '../database.dart';

part 'preference_dao.g.dart';

/// Data Access Object for Preferences table
/// Key-value store for app settings
@DriftAccessor(tables: [Preferences])
class PreferenceDao extends DatabaseAccessor<AppDatabase> with _$PreferenceDaoMixin {
  PreferenceDao(super.db);

  // ============================================================================
  // KNOWN PREFERENCE KEYS
  // ============================================================================
  
  static const String keyTheme = 'theme';
  static const String keyLanguage = 'language';
  static const String keyBilingual = 'bilingual_enabled';
  static const String keyHaptic = 'haptic_enabled';
  static const String keyNotifications = 'notifications_enabled';
  static const String keyOnboardingComplete = 'onboarding_complete';
  static const String keyMigrationV1Complete = 'migration_v1_complete';
  static const String keySmsDetection = 'sms_detection_enabled';
  static const String keyNotificationDetection = 'notification_detection_enabled';
  static const String keyAccessibilityDetection = 'accessibility_detection_enabled';

  // ============================================================================
  // GENERIC GET/SET
  // ============================================================================

  /// Get a preference value by key
  Future<String?> get(String key) async {
    final pref = await (select(preferences)..where((p) => p.key.equals(key)))
        .getSingleOrNull();
    return pref?.value;
  }

  /// Set a preference value
  Future<void> set(String key, String value) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    
    await into(preferences).insertOnConflictUpdate(PreferencesCompanion.insert(
      key: key,
      value: value,
      updatedAt: now,
    ));
  }

  /// Get bool preference
  Future<bool> getBool(String key, {bool defaultValue = false}) async {
    final value = await get(key);
    if (value == null) return defaultValue;
    return value == 'true';
  }

  /// Set bool preference
  Future<void> setBool(String key, bool value) async {
    await set(key, value.toString());
  }

  /// Delete a preference
  Future<void> remove(String key) async {
    await (delete(preferences)..where((p) => p.key.equals(key))).go();
  }

  // ============================================================================
  // SPECIFIC PREFERENCES
  // ============================================================================

  // Theme
  Future<String> getTheme() async => await get(keyTheme) ?? 'system';
  Future<void> setTheme(String theme) => set(keyTheme, theme);

  // Language
  Future<String> getLanguage() async => await get(keyLanguage) ?? 'en';
  Future<void> setLanguage(String lang) => set(keyLanguage, lang);

  // Bilingual
  Future<bool> isBilingualEnabled() => getBool(keyBilingual, defaultValue: false);
  Future<void> setBilingualEnabled(bool enabled) => setBool(keyBilingual, enabled);

  // Haptic Feedback
  Future<bool> isHapticEnabled() => getBool(keyHaptic, defaultValue: true);
  Future<void> setHapticEnabled(bool enabled) => setBool(keyHaptic, enabled);

  // Notifications
  Future<bool> areNotificationsEnabled() => getBool(keyNotifications, defaultValue: true);
  Future<void> setNotificationsEnabled(bool enabled) => setBool(keyNotifications, enabled);

  // Onboarding
  Future<bool> isOnboardingComplete() => getBool(keyOnboardingComplete, defaultValue: false);
  Future<void> setOnboardingComplete(bool complete) => setBool(keyOnboardingComplete, complete);

  // Migration
  Future<bool> isMigrationComplete() => getBool(keyMigrationV1Complete, defaultValue: false);
  Future<void> setMigrationComplete(bool complete) => setBool(keyMigrationV1Complete, complete);

  // Detection Settings
  Future<bool> isSmsDetectionEnabled() => getBool(keySmsDetection, defaultValue: true);
  Future<void> setSmsDetectionEnabled(bool enabled) => setBool(keySmsDetection, enabled);

  Future<bool> isNotificationDetectionEnabled() => getBool(keyNotificationDetection, defaultValue: true);
  Future<void> setNotificationDetectionEnabled(bool enabled) => setBool(keyNotificationDetection, enabled);

  Future<bool> isAccessibilityDetectionEnabled() => getBool(keyAccessibilityDetection, defaultValue: true);
  Future<void> setAccessibilityDetectionEnabled(bool enabled) => setBool(keyAccessibilityDetection, enabled);

  // ============================================================================
  // BULK OPERATIONS
  // ============================================================================

  /// Get all preferences as a map
  Future<Map<String, String>> getAll() async {
    final all = await select(preferences).get();
    return Map.fromEntries(all.map((p) => MapEntry(p.key, p.value)));
  }

  /// Clear all preferences
  Future<void> clearAll() async {
    await delete(preferences).go();
  }

  // ============================================================================
  // WATCH
  // ============================================================================

  /// Watch a specific preference
  Stream<String?> watchPreference(String key) {
    return (select(preferences)..where((p) => p.key.equals(key)))
        .watchSingleOrNull()
        .map((p) => p?.value);
  }

  /// Watch theme changes
  Stream<String> watchTheme() {
    return watchPreference(keyTheme).map((v) => v ?? 'system');
  }

  /// Watch all preferences
  Stream<Map<String, String>> watchAll() {
    return select(preferences).watch().map(
      (prefs) => Map.fromEntries(prefs.map((p) => MapEntry(p.key, p.value))),
    );
  }
}
