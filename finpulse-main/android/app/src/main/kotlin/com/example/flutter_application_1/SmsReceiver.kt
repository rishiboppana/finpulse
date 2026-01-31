package com.example.flutter_application_1

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.telephony.SmsMessage
import android.util.Log
import io.flutter.plugin.common.MethodChannel

/**
 * SMS Receiver for Bank Transaction Alerts
 * 
 * Listens for incoming bank SMS messages and:
 * 1. If Flutter is running: forwards to Flutter for Golden Window
 * 2. If Flutter is NOT running: shows system notification with quick actions
 * 
 * Privacy: Uses content-first detection (checks message body, not sender).
 */
class SmsReceiver : BroadcastReceiver() {

    companion object {
        private const val TAG = "FinPulseSmsReceiver"
        
        var methodChannel: MethodChannel? = null
        
        // Track if Flutter engine is alive
        var isFlutterEngineActive: Boolean = false
    }

    override fun onReceive(context: Context?, intent: Intent?) {
        if (intent?.action != "android.provider.Telephony.SMS_RECEIVED") {
            return
        }
        
        context ?: return
        val bundle = intent.extras ?: return
        
        try {
            val pdus = bundle.get("pdus") as? Array<*> ?: return
            val format = bundle.getString("format") ?: "3gpp"
            
            for (pdu in pdus) {
                val smsMessage = SmsMessage.createFromPdu(pdu as ByteArray, format)
                val sender = smsMessage.displayOriginatingAddress?.uppercase() ?: ""
                val body = smsMessage.displayMessageBody ?: ""
                
                // CONTENT-FIRST: Check message body for transaction indicators
                if (!isLikelyTransaction(body)) continue
                
                Log.d(TAG, "Transaction SMS detected from $sender")
                
                // Extract amount for notification
                val amount = extractAmount(body) ?: "?"
                val merchant = extractMerchant(body) ?: ""
                
                // Check if Flutter engine is alive
                if (isFlutterEngineActive && methodChannel != null) {
                    // Flutter is running - send via MethodChannel for Golden Window
                    Log.d(TAG, "Forwarding to Flutter (app active)")
                    sendToFlutter(
                        mapOf(
                            "source" to "sms",
                            "sender" to sender,
                            "body" to body,
                            "timestamp" to System.currentTimeMillis()
                        )
                    )
                } else {
                    // Flutter NOT running - show system notification
                    Log.d(TAG, "Showing system notification (app inactive)")
                    val notificationId = System.currentTimeMillis().toInt()
                    NotificationHelper.showTransactionNotification(
                        context,
                        notificationId,
                        amount,
                        merchant,
                        body
                    )
                }
            }
        } catch (e: Exception) {
            Log.e(TAG, "Error processing SMS: ${e.message}")
        }
    }
    
    /**
     * Quick check if SMS looks like a transaction
     */
    private fun isLikelyTransaction(body: String): Boolean {
        val keywords = listOf(
            "debited", "credited", "transferred", "received",
            "withdrawn", "deposited", "payment", "upi",
            "neft", "imps", "₹", "rs.", "rs ", "inr", "balance",
            "paid", "sent to", "received from"
        )
        val bodyLower = body.lowercase()
        return keywords.any { bodyLower.contains(it) }
    }
    
    /**
     * Extract amount from SMS body
     */
    private fun extractAmount(body: String): String? {
        val patterns = listOf(
            Regex("""[₹₨]\s*([\d,]+\.?\d*)"""),
            Regex("""Rs\.?\s*([\d,]+\.?\d*)""", RegexOption.IGNORE_CASE),
            Regex("""INR\s*([\d,]+\.?\d*)""", RegexOption.IGNORE_CASE)
        )
        
        for (pattern in patterns) {
            pattern.find(body)?.let { match ->
                return match.groupValues.getOrNull(1)?.replace(",", "")
            }
        }
        return null
    }
    
    /**
     * Extract merchant name from SMS body
     */
    private fun extractMerchant(body: String): String? {
        val patterns = listOf(
            Regex("""(?:to|at|@)\s+([A-Za-z0-9_@.\s]+?)(?:\s+₹|\s+Rs|\s+on|$)""", RegexOption.IGNORE_CASE)
        )
        
        for (pattern in patterns) {
            pattern.find(body)?.let { match ->
                return match.groupValues.getOrNull(1)?.trim()?.take(20)
            }
        }
        return null
    }
    
    /**
     * Send to Flutter via MethodChannel
     */
    private fun sendToFlutter(data: Map<String, Any>) {
        methodChannel?.invokeMethod("onTransactionDetected", data)
    }
}
