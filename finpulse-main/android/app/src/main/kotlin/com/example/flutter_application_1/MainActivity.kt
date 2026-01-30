package com.example.flutter_application_1

import android.content.Intent
import android.provider.Settings
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

/**
 * MainActivity with Flutter MethodChannel bridge for native transaction detection.
 */
class MainActivity : FlutterActivity() {
    
    companion object {
        private const val CHANNEL = "com.finpulse/transaction_detection"
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        val channel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
        
        // Share the channel with native services
        TransactionNotificationListener.methodChannel = channel
        TransactionAccessibilityService.methodChannel = channel
        SmsReceiver.methodChannel = channel
        
        channel.setMethodCallHandler { call, result ->
            when (call.method) {
                "isNotificationListenerEnabled" -> {
                    result.success(isNotificationListenerEnabled())
                }
                "openNotificationListenerSettings" -> {
                    openNotificationListenerSettings()
                    result.success(true)
                }
                "isAccessibilityEnabled" -> {
                    result.success(isAccessibilityEnabled())
                }
                "openAccessibilitySettings" -> {
                    openAccessibilitySettings()
                    result.success(true)
                }
                "getServiceStatus" -> {
                    result.success(mapOf(
                        "notificationListener" to isNotificationListenerEnabled(),
                        "accessibility" to isAccessibilityEnabled()
                    ))
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }
    
    /**
     * Check if our NotificationListenerService is enabled
     */
    private fun isNotificationListenerEnabled(): Boolean {
        val enabledNotificationListeners = Settings.Secure.getString(
            contentResolver,
            "enabled_notification_listeners"
        )
        return enabledNotificationListeners?.contains(packageName) == true
    }
    
    /**
     * Open the Notification Access settings page
     */
    private fun openNotificationListenerSettings() {
        val intent = Intent(Settings.ACTION_NOTIFICATION_LISTENER_SETTINGS)
        startActivity(intent)
    }
    
    /**
     * Check if our AccessibilityService is enabled
     */
    private fun isAccessibilityEnabled(): Boolean {
        val enabledServices = Settings.Secure.getString(
            contentResolver,
            Settings.Secure.ENABLED_ACCESSIBILITY_SERVICES
        )
        return enabledServices?.contains(packageName) == true
    }
    
    /**
     * Open the Accessibility settings page
     */
    private fun openAccessibilitySettings() {
        val intent = Intent(Settings.ACTION_ACCESSIBILITY_SETTINGS)
        startActivity(intent)
    }
}
