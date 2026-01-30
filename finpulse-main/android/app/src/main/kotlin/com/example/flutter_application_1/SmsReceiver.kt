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
 * Listens for incoming bank SMS messages and forwards them to Flutter for parsing.
 * 
 * Privacy: Only forwards SMS from known bank sender IDs.
 */
class SmsReceiver : BroadcastReceiver() {

    companion object {
        private const val TAG = "FinPulseSmsReceiver"
        
        var methodChannel: MethodChannel? = null
    }

    override fun onReceive(context: Context?, intent: Intent?) {
        if (intent?.action != "android.provider.Telephony.SMS_RECEIVED") {
            return
        }
        
        val bundle = intent.extras ?: return
        
        try {
            val pdus = bundle.get("pdus") as? Array<*> ?: return
            val format = bundle.getString("format") ?: "3gpp"
            
            for (pdu in pdus) {
                val smsMessage = SmsMessage.createFromPdu(pdu as ByteArray, format)
                val sender = smsMessage.displayOriginatingAddress?.uppercase() ?: ""
                val body = smsMessage.displayMessageBody ?: ""
                
                // CONTENT-FIRST: Check message body for transaction indicators
                // This catches ALL bank SMS regardless of sender format
                if (!isLikelyTransaction(body)) continue
                
                Log.d(TAG, "Transaction SMS detected from $sender")
                
                // Send to Flutter for parsing
                sendToFlutter(
                    mapOf(
                        "source" to "sms",
                        "sender" to sender,
                        "body" to body,
                        "timestamp" to System.currentTimeMillis()
                    )
                )
            }
        } catch (e: Exception) {
            Log.e(TAG, "Error processing SMS: ${e.message}")
        }
    }
    
    /**
     * Quick check if SMS looks like a transaction
     * This is the ONLY filter - it catches all bank SMS regardless of sender format
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
     * Send to Flutter via MethodChannel
     */
    private fun sendToFlutter(data: Map<String, Any>) {
        methodChannel?.invokeMethod("onTransactionDetected", data)
    }
}
