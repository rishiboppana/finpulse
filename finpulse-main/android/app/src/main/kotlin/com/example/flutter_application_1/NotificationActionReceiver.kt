package com.example.flutter_application_1

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.util.Log
import androidx.core.app.NotificationManagerCompat
import androidx.core.app.RemoteInput

/**
 * NotificationActionReceiver - Handles notification button taps and replies
 * 
 * This receiver processes:
 * - Quick category button taps (Food, Groceries, etc.)
 * - Direct reply text input
 * 
 * It forwards the categorization to Flutter via MethodChannel when the app is available,
 * or stores it locally for sync later.
 */
class NotificationActionReceiver : BroadcastReceiver() {
    
    companion object {
        private const val TAG = "FinPulseActionReceiver"
        private const val KEY_TEXT_REPLY = "key_text_reply"
    }
    
    override fun onReceive(context: Context?, intent: Intent?) {
        context ?: return
        intent ?: return
        
        val notificationId = intent.getIntExtra("notification_id", 0)
        val rawText = intent.getStringExtra("transaction_raw") ?: ""
        
        // Dismiss the notification
        NotificationManagerCompat.from(context).cancel(notificationId)
        
        when (intent.action) {
            "com.finpulse.ACTION_CATEGORY" -> {
                val category = intent.getStringExtra("category") ?: "Other"
                handleCategorySelection(context, category, rawText)
            }
            
            "com.finpulse.ACTION_REPLY" -> {
                val replyText = getReplyText(intent)
                if (replyText != null) {
                    handleReplyInput(context, replyText, rawText)
                }
            }
        }
    }
    
    /**
     * Handle quick category button tap
     */
    private fun handleCategorySelection(context: Context, category: String, rawText: String) {
        Log.d(TAG, "Category selected: $category for transaction: $rawText")
        
        // Store the categorization locally using SharedPreferences
        // This will be synced to Flutter when app opens
        val prefs = context.getSharedPreferences("finpulse_pending", Context.MODE_PRIVATE)
        val pendingJson = """{"category":"$category","rawText":"$rawText","timestamp":${System.currentTimeMillis()}}"""
        
        // Append to pending list
        val existing = prefs.getString("pending_categorizations", "[]") ?: "[]"
        val updated = if (existing == "[]") {
            "[$pendingJson]"
        } else {
            existing.dropLast(1) + ",$pendingJson]"
        }
        
        prefs.edit().putString("pending_categorizations", updated).apply()
        
        // Try to send to Flutter if available
        MainActivity.methodChannel?.invokeMethod(
            "onCategorySelected",
            mapOf(
                "category" to category,
                "rawText" to rawText,
                "timestamp" to System.currentTimeMillis()
            )
        )
        
        Log.d(TAG, "Saved categorization: $category")
    }
    
    /**
     * Handle direct reply text input
     */
    private fun handleReplyInput(context: Context, replyText: String, rawText: String) {
        Log.d(TAG, "User replied: $replyText for transaction: $rawText")
        
        // Store the reply for Gemini processing
        val prefs = context.getSharedPreferences("finpulse_pending", Context.MODE_PRIVATE)
        val pendingJson = """{"replyText":"$replyText","rawText":"$rawText","timestamp":${System.currentTimeMillis()}}"""
        
        val existing = prefs.getString("pending_replies", "[]") ?: "[]"
        val updated = if (existing == "[]") {
            "[$pendingJson]"
        } else {
            existing.dropLast(1) + ",$pendingJson]"
        }
        
        prefs.edit().putString("pending_replies", updated).apply()
        
        // Try to send to Flutter for Gemini processing if available
        MainActivity.methodChannel?.invokeMethod(
            "onReplyReceived",
            mapOf(
                "replyText" to replyText,
                "rawText" to rawText,
                "timestamp" to System.currentTimeMillis()
            )
        )
        
        Log.d(TAG, "Saved reply for Gemini processing: $replyText")
    }
    
    /**
     * Extract reply text from RemoteInput
     */
    private fun getReplyText(intent: Intent): String? {
        val remoteInput = RemoteInput.getResultsFromIntent(intent)
        return remoteInput?.getCharSequence(KEY_TEXT_REPLY)?.toString()
    }
}
