package com.example.flutter_application_1

import android.app.Notification
import android.content.Intent
import android.service.notification.NotificationListenerService
import android.service.notification.StatusBarNotification
import android.util.Log
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

/**
 * FinPulse Transaction Notification Listener Service
 * 
 * Monitors notifications from financial apps (PhonePe, GPay, Paytm, etc.)
 * and bank SMS notifications to detect transactions in real-time.
 * 
 * Privacy Guardrails:
 * - Only monitors specific package names (financial apps)
 * - Only extracts transaction-related data
 * - No persistent logging of personal information
 */
class TransactionNotificationListener : NotificationListenerService() {

    companion object {
        private const val TAG = "FinPulseNotifListener"
        private const val FLUTTER_CHANNEL = "com.finpulse/transaction_detection"
        
        // Financial apps to monitor (Indian market focus)
        private val MONITORED_PACKAGES = setOf(
            // UPI Apps
            "com.phonepe.app",                          // PhonePe
            "com.google.android.apps.nbu.paisa.user",  // Google Pay
            "net.one97.paytm",                          // Paytm
            "in.amazon.mShop.android.shopping",        // Amazon Pay
            "com.whatsapp",                             // WhatsApp Pay (notifications)
            
            // Bank Apps
            "com.csam.icici.bank.imobile",             // ICICI iMobile
            "com.snapwork.hdfc",                        // HDFC Mobile
            "com.sbi.SBIFreedomPlus",                  // SBI YONO
            "com.axis.mobile",                          // Axis Mobile
            "com.kotak.mobile.banking",                // Kotak
            
            // SMS Apps (for bank SMS)
            "com.google.android.apps.messaging",       // Google Messages
            "com.samsung.android.messaging",           // Samsung Messages
            "com.android.mms"                          // Default SMS
        )
        
        // Instance reference for Flutter communication
        var instance: TransactionNotificationListener? = null
        var methodChannel: MethodChannel? = null
    }

    override fun onCreate() {
        super.onCreate()
        instance = this
        Log.d(TAG, "TransactionNotificationListener created")
    }

    override fun onDestroy() {
        instance = null
        super.onDestroy()
        Log.d(TAG, "TransactionNotificationListener destroyed")
    }

    override fun onNotificationPosted(sbn: StatusBarNotification?) {
        sbn?.let { notification ->
            val packageName = notification.packageName
            
            // Only process notifications from monitored apps
            if (!MONITORED_PACKAGES.contains(packageName)) {
                return
            }
            
            try {
                processNotification(notification)
            } catch (e: Exception) {
                Log.e(TAG, "Error processing notification: ${e.message}")
            }
        }
    }

    private fun processNotification(sbn: StatusBarNotification) {
        val notification = sbn.notification
        val extras = notification.extras
        
        // Extract notification content
        val title = extras.getCharSequence(Notification.EXTRA_TITLE)?.toString() ?: ""
        val text = extras.getCharSequence(Notification.EXTRA_TEXT)?.toString() ?: ""
        val bigText = extras.getCharSequence(Notification.EXTRA_BIG_TEXT)?.toString() ?: text
        val packageName = sbn.packageName
        val timestamp = sbn.postTime
        
        // Skip empty notifications
        if (title.isBlank() && text.isBlank()) return
        
        // Quick transaction keyword check (performance optimization)
        val content = "$title $bigText".lowercase()
        if (!isLikelyTransaction(content)) return
        
        Log.d(TAG, "Transaction detected from $packageName: $title")
        
        // Send to Flutter
        sendToFlutter(
            mapOf(
                "source" to "notification",
                "packageName" to packageName,
                "title" to title,
                "text" to bigText,
                "timestamp" to timestamp
            )
        )
    }
    
    /**
     * Quick check if notification content looks like a transaction
     */
    private fun isLikelyTransaction(content: String): Boolean {
        val transactionKeywords = listOf(
            "paid", "received", "sent", "debited", "credited", 
            "transfer", "₹", "rs.", "inr", "payment",
            "upi", "neft", "imps", "successful", "failed",
            "withdrawn", "deposited", "balance"
        )
        return transactionKeywords.any { content.contains(it, ignoreCase = true) }
    }

    /**
     * Send transaction data to Flutter via MethodChannel
     */
    private fun sendToFlutter(data: Map<String, Any>) {
        methodChannel?.invokeMethod("onTransactionDetected", data)
    }

    override fun onNotificationRemoved(sbn: StatusBarNotification?) {
        // Not needed for transaction detection
    }
    
    override fun onListenerConnected() {
        super.onListenerConnected()
        Log.d(TAG, "NotificationListener connected")
    }
    
    override fun onListenerDisconnected() {
        super.onListenerDisconnected()
        Log.d(TAG, "NotificationListener disconnected")
    }
}
