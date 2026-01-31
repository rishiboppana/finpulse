package com.example.flutter_application_1

import android.Manifest
import android.content.Intent
import android.content.pm.PackageManager
import android.os.Build
import android.provider.Settings
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

/**
 * MainActivity with Flutter MethodChannel bridge for native transaction detection.
 */
class MainActivity : FlutterActivity() {
    
    companion object {
        private const val CHANNEL = "com.finpulse/transaction_detection"
        private const val PERMISSION_CHANNEL = "com.finpulse/permissions"
        
        private const val SMS_PERMISSION_REQUEST = 1001
        private const val NOTIFICATION_PERMISSION_REQUEST = 1002
        
        // Static reference for NotificationActionReceiver
        var methodChannel: MethodChannel? = null
    }
    
    private var permissionResult: MethodChannel.Result? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        val channel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
        methodChannel = channel  // Store static reference
        
        // Share the channel with native services
        TransactionNotificationListener.methodChannel = channel
        TransactionAccessibilityService.methodChannel = channel
        SmsReceiver.methodChannel = channel
        
        // Mark Flutter engine as active
        SmsReceiver.isFlutterEngineActive = true
        
        // Initialize notification channel
        NotificationHelper.createNotificationChannel(this)
        
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
        
        // Permission channel for onboarding
        val permChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, PERMISSION_CHANNEL)
        permChannel.setMethodCallHandler { call, result ->
            when (call.method) {
                "requestSmsPermission" -> {
                    permissionResult = result
                    requestSmsPermission()
                }
                "requestNotificationPermission" -> {
                    permissionResult = result
                    requestNotificationPermission()
                }
                "openAccessibilitySettings" -> {
                    openAccessibilitySettings()
                    result.success(true)
                }
                "isAccessibilityEnabled" -> {
                    result.success(isAccessibilityEnabled())
                }
                "isSmsPermissionGranted" -> {
                    result.success(checkSmsPermission())
                }
                "isNotificationPermissionGranted" -> {
                    result.success(checkNotificationPermission())
                }
                "getAllPermissionStatus" -> {
                    result.success(mapOf(
                        "sms" to checkSmsPermission(),
                        "notification" to checkNotificationPermission(),
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
    
    override fun onDestroy() {
        // Mark Flutter engine as inactive when app is destroyed
        SmsReceiver.isFlutterEngineActive = false
        methodChannel = null
        super.onDestroy()
    }
    
    // ============ SMS Permission ============
    private fun checkSmsPermission(): Boolean {
        return ContextCompat.checkSelfPermission(this, Manifest.permission.RECEIVE_SMS) == 
            PackageManager.PERMISSION_GRANTED &&
            ContextCompat.checkSelfPermission(this, Manifest.permission.READ_SMS) == 
            PackageManager.PERMISSION_GRANTED
    }
    
    private fun requestSmsPermission() {
        if (checkSmsPermission()) {
            permissionResult?.success(true)
            permissionResult = null
            return
        }
        
        ActivityCompat.requestPermissions(
            this,
            arrayOf(
                Manifest.permission.RECEIVE_SMS,
                Manifest.permission.READ_SMS
            ),
            SMS_PERMISSION_REQUEST
        )
    }
    
    // ============ Notification Permission ============
    private fun checkNotificationPermission(): Boolean {
        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            ContextCompat.checkSelfPermission(this, Manifest.permission.POST_NOTIFICATIONS) == 
                PackageManager.PERMISSION_GRANTED
        } else {
            true // Not required for API < 33
        }
    }
    
    private fun requestNotificationPermission() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            if (checkNotificationPermission()) {
                permissionResult?.success(true)
                permissionResult = null
                return
            }
            
            ActivityCompat.requestPermissions(
                this,
                arrayOf(Manifest.permission.POST_NOTIFICATIONS),
                NOTIFICATION_PERMISSION_REQUEST
            )
        } else {
            // For older Android, open notification listener settings instead
            openNotificationListenerSettings()
            permissionResult?.success(true)
            permissionResult = null
        }
    }
    
    // ============ Permission Result Callback ============
    override fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<out String>,
        grantResults: IntArray
    ) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
        
        when (requestCode) {
            SMS_PERMISSION_REQUEST -> {
                val granted = grantResults.isNotEmpty() && 
                    grantResults.all { it == PackageManager.PERMISSION_GRANTED }
                permissionResult?.success(granted)
                permissionResult = null
            }
            NOTIFICATION_PERMISSION_REQUEST -> {
                val granted = grantResults.isNotEmpty() && 
                    grantResults[0] == PackageManager.PERMISSION_GRANTED
                permissionResult?.success(granted)
                permissionResult = null
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
