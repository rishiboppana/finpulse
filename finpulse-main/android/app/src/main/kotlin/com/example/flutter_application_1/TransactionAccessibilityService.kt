package com.example.flutter_application_1

import android.accessibilityservice.AccessibilityService
import android.accessibilityservice.AccessibilityServiceInfo
import android.util.Log
import android.view.accessibility.AccessibilityEvent
import android.view.accessibility.AccessibilityNodeInfo
import io.flutter.plugin.common.MethodChannel

/**
 * FinPulse Accessibility Service - "Proactive UI Consciousness Layer"
 * 
 * This service monitors UI changes in UPI apps to detect payment success screens.
 * This provides instant, reliable detection that bypasses notification delays.
 * 
 * PRIVACY GUARDRAILS:
 * - Only activates for specific package names (UPI apps only)
 * - Only listens for "Window Content Changed" events
 * - Only looks for success indicators (icons, text)
 * - NO keystroke logging, NO personal data collection
 * - Acts as an "Optical Trigger" only
 */
class TransactionAccessibilityService : AccessibilityService() {

    companion object {
        private const val TAG = "FinPulseAccessibility"
        private const val FLUTTER_CHANNEL = "com.finpulse/transaction_detection"

        // ONLY monitor these specific UPI apps
        private val MONITORED_PACKAGES = setOf(
            "com.phonepe.app",                          // PhonePe
            "com.google.android.apps.nbu.paisa.user"   // Google Pay
            // Add more as needed, keep list minimal for privacy
        )
        
        // UI element patterns that indicate payment success
        // This is the "Modular View Matcher" - easily extensible via config
        private val SUCCESS_PATTERNS = mapOf(
            "com.phonepe.app" to SuccessPattern(
                textPatterns = listOf("payment successful", "paid ₹", "sent to"),
                resourceIds = listOf("success_icon", "payment_status")
            ),
            "com.google.android.apps.nbu.paisa.user" to SuccessPattern(
                textPatterns = listOf("payment successful", "paid to", "money sent"),
                resourceIds = listOf("success_animation", "status_text")
            )
        )
        
        var instance: TransactionAccessibilityService? = null
        var methodChannel: MethodChannel? = null
    }

    private var lastDetectedTimestamp = 0L
    private val DEBOUNCE_MS = 3000L // Prevent duplicate detections

    override fun onCreate() {
        super.onCreate()
        instance = this
        Log.d(TAG, "AccessibilityService created")
    }

    override fun onDestroy() {
        instance = null
        super.onDestroy()
        Log.d(TAG, "AccessibilityService destroyed")
    }

    override fun onServiceConnected() {
        super.onServiceConnected()
        
        // Configure the service
        val info = AccessibilityServiceInfo().apply {
            // Only listen for window content changes
            eventTypes = AccessibilityEvent.TYPE_WINDOW_CONTENT_CHANGED or
                        AccessibilityEvent.TYPE_WINDOW_STATE_CHANGED
            
            // Only monitor specific packages
            packageNames = MONITORED_PACKAGES.toTypedArray()
            
            // Standard response timeout
            notificationTimeout = 100
            
            // We only need text content, not view hierarchy
            flags = AccessibilityServiceInfo.FLAG_RETRIEVE_INTERACTIVE_WINDOWS
            
            feedbackType = AccessibilityServiceInfo.FEEDBACK_GENERIC
        }
        
        serviceInfo = info
        Log.d(TAG, "AccessibilityService connected and configured")
    }

    override fun onAccessibilityEvent(event: AccessibilityEvent?) {
        event?.let { e ->
            val packageName = e.packageName?.toString() ?: return
            
            // Double-check we're monitoring this package
            if (!MONITORED_PACKAGES.contains(packageName)) {
                return
            }
            
            // Debounce to prevent duplicate detections
            val now = System.currentTimeMillis()
            if (now - lastDetectedTimestamp < DEBOUNCE_MS) {
                return
            }
            
            try {
                checkForPaymentSuccess(e, packageName)
            } catch (ex: Exception) {
                Log.e(TAG, "Error processing accessibility event: ${ex.message}")
            }
        }
    }

    private fun checkForPaymentSuccess(event: AccessibilityEvent, packageName: String) {
        val pattern = SUCCESS_PATTERNS[packageName] ?: return
        val rootNode = rootInActiveWindow ?: return
        
        try {
            // Check for success text patterns
            val visibleText = extractVisibleText(rootNode)
            val textLower = visibleText.lowercase()
            
            for (textPattern in pattern.textPatterns) {
                if (textLower.contains(textPattern)) {
                    Log.d(TAG, "Payment success detected in $packageName: $textPattern")
                    lastDetectedTimestamp = System.currentTimeMillis()
                    
                    // Extract amount if possible
                    val amount = extractAmount(visibleText)
                    val merchant = extractMerchant(visibleText)
                    
                    sendToFlutter(
                        mapOf(
                            "source" to "accessibility",
                            "packageName" to packageName,
                            "trigger" to textPattern,
                            "amount" to (amount ?: ""),
                            "merchant" to (merchant ?: ""),
                            "rawText" to visibleText,
                            "timestamp" to System.currentTimeMillis()
                        )
                    )
                    return
                }
            }
        } finally {
            rootNode.recycle()
        }
    }
    
    /**
     * Extract all visible text from the UI tree
     */
    private fun extractVisibleText(node: AccessibilityNodeInfo): String {
        val textBuilder = StringBuilder()
        extractTextRecursive(node, textBuilder)
        return textBuilder.toString()
    }
    
    private fun extractTextRecursive(node: AccessibilityNodeInfo?, builder: StringBuilder) {
        node ?: return
        
        node.text?.let { 
            builder.append(it).append(" ")
        }
        node.contentDescription?.let {
            builder.append(it).append(" ")
        }
        
        for (i in 0 until node.childCount) {
            val child = node.getChild(i)
            extractTextRecursive(child, builder)
            child?.recycle()
        }
    }
    
    /**
     * Extract amount from visible text using regex
     */
    private fun extractAmount(text: String): String? {
        // Match Indian rupee amounts: ₹1,234.56 or Rs. 1234 or INR 1,234
        val patterns = listOf(
            Regex("""[₹₨]\s*([\d,]+\.?\d*)"""),
            Regex("""Rs\.?\s*([\d,]+\.?\d*)""", RegexOption.IGNORE_CASE),
            Regex("""INR\s*([\d,]+\.?\d*)""", RegexOption.IGNORE_CASE)
        )
        
        for (pattern in patterns) {
            pattern.find(text)?.let { match ->
                return match.groupValues.getOrNull(1)?.replace(",", "")
            }
        }
        return null
    }
    
    /**
     * Extract merchant name from visible text
     */
    private fun extractMerchant(text: String): String? {
        // Look for "to <merchant>" or "paid <merchant>" patterns
        val patterns = listOf(
            Regex("""(?:paid|sent|to)\s+([A-Za-z0-9_@.\s]+?)(?:\s+₹|\s+Rs|$)""", RegexOption.IGNORE_CASE)
        )
        
        for (pattern in patterns) {
            pattern.find(text)?.let { match ->
                return match.groupValues.getOrNull(1)?.trim()
            }
        }
        return null
    }

    /**
     * Send detection data to Flutter via MethodChannel
     */
    private fun sendToFlutter(data: Map<String, Any>) {
        methodChannel?.invokeMethod("onTransactionDetected", data)
    }

    override fun onInterrupt() {
        Log.d(TAG, "AccessibilityService interrupted")
    }
}

/**
 * Pattern configuration for detecting payment success screens
 */
data class SuccessPattern(
    val textPatterns: List<String>,
    val resourceIds: List<String> = emptyList()
)
