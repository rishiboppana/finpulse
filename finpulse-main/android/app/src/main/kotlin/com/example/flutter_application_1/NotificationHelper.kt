package com.example.flutter_application_1

import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.os.Build
import androidx.core.app.NotificationCompat
import androidx.core.app.NotificationManagerCompat
import androidx.core.app.RemoteInput

/**
 * NotificationHelper - Creates system-level notifications for transaction detection
 * 
 * This helper shows rich notifications even when the Flutter app is closed.
 * Features:
 * - Transaction details (amount, merchant)
 * - Quick action buttons for common categories
 * - Direct reply for custom input
 */
object NotificationHelper {
    
    private const val CHANNEL_ID = "finpulse_transactions"
    private const val CHANNEL_NAME = "Transaction Alerts"
    private const val CHANNEL_DESC = "Instant alerts for detected transactions"
    
    private const val KEY_TEXT_REPLY = "key_text_reply"
    private const val REQUEST_CODE_REPLY = 100
    
    // Category action request codes
    private const val ACTION_FOOD = 1001
    private const val ACTION_GROCERIES = 1002
    private const val ACTION_TRANSPORT = 1003
    private const val ACTION_SHOPPING = 1004
    
    /**
     * Initialize notification channel (required for Android 8.0+)
     */
    fun createNotificationChannel(context: Context) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val importance = NotificationManager.IMPORTANCE_HIGH
            val channel = NotificationChannel(CHANNEL_ID, CHANNEL_NAME, importance).apply {
                description = CHANNEL_DESC
                enableVibration(true)
                enableLights(true)
            }
            
            val notificationManager = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
            notificationManager.createNotificationChannel(channel)
        }
    }
    
    /**
     * Show a transaction notification with quick category actions
     */
    fun showTransactionNotification(
        context: Context,
        notificationId: Int,
        amount: String,
        merchant: String,
        rawText: String
    ) {
        // Ensure channel exists
        createNotificationChannel(context)
        
        // Intent to open app when notification is tapped
        val openAppIntent = Intent(context, MainActivity::class.java).apply {
            flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP
            putExtra("transaction_amount", amount)
            putExtra("transaction_merchant", merchant)
            putExtra("transaction_raw", rawText)
        }
        
        val openAppPendingIntent = PendingIntent.getActivity(
            context,
            0,
            openAppIntent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )
        
        // Quick category action intents
        val foodIntent = createCategoryIntent(context, notificationId, "Food", rawText)
        val groceriesIntent = createCategoryIntent(context, notificationId, "Groceries", rawText)
        val transportIntent = createCategoryIntent(context, notificationId, "Transport", rawText)
        val shoppingIntent = createCategoryIntent(context, notificationId, "Shopping", rawText)
        
        // Direct reply action
        val remoteInput = RemoteInput.Builder(KEY_TEXT_REPLY)
            .setLabel("What was this for?")
            .build()
        
        val replyIntent = Intent(context, NotificationActionReceiver::class.java).apply {
            action = "com.finpulse.ACTION_REPLY"
            putExtra("notification_id", notificationId)
            putExtra("transaction_raw", rawText)
        }
        
        val replyPendingIntent = PendingIntent.getBroadcast(
            context,
            REQUEST_CODE_REPLY,
            replyIntent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_MUTABLE
        )
        
        val replyAction = NotificationCompat.Action.Builder(
            android.R.drawable.ic_menu_edit,
            "Reply",
            replyPendingIntent
        )
            .addRemoteInput(remoteInput)
            .build()
        
        // Build notification
        val notification = NotificationCompat.Builder(context, CHANNEL_ID)
            .setSmallIcon(android.R.drawable.ic_dialog_info)
            .setContentTitle("₹$amount spent")
            .setContentText(if (merchant.isNotEmpty()) "at $merchant" else "Transaction detected")
            .setStyle(NotificationCompat.BigTextStyle()
                .bigText("₹$amount ${if (merchant.isNotEmpty()) "at $merchant" else ""}\n\nTap to categorize or reply with details"))
            .setPriority(NotificationCompat.PRIORITY_HIGH)
            .setAutoCancel(true)
            .setContentIntent(openAppPendingIntent)
            .addAction(android.R.drawable.ic_menu_today, "🍕 Food", foodIntent)
            .addAction(android.R.drawable.ic_menu_agenda, "🛒 Groceries", groceriesIntent)
            .addAction(android.R.drawable.ic_menu_directions, "🚗 Transport", transportIntent)
            .addAction(replyAction)
            .build()
        
        try {
            NotificationManagerCompat.from(context).notify(notificationId, notification)
        } catch (e: SecurityException) {
            // Notification permission not granted
            android.util.Log.e("NotificationHelper", "Notification permission denied: ${e.message}")
        }
    }
    
    /**
     * Create a PendingIntent for category quick action
     */
    private fun createCategoryIntent(
        context: Context,
        notificationId: Int,
        category: String,
        rawText: String
    ): PendingIntent {
        val intent = Intent(context, NotificationActionReceiver::class.java).apply {
            action = "com.finpulse.ACTION_CATEGORY"
            putExtra("notification_id", notificationId)
            putExtra("category", category)
            putExtra("transaction_raw", rawText)
        }
        
        return PendingIntent.getBroadcast(
            context,
            category.hashCode(),
            intent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )
    }
}
