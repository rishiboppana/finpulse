import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../database/database.dart' hide Transaction;
import 'gemini_service.dart';
import 'service_initializer.dart';
import 'app_logger.dart';
import '../models/transaction.dart';
import 'transaction_parser.dart';

/// Service to generate financial insights and nudges (The "Deep Brain")
/// 
/// Analyzes transactions in context of goals and history to provide 
/// actionable advice and "conscience" nudges.
class InsightService {
  static final InsightService instance = InsightService._();
  InsightService._();

  final _gemini = GeminiService.instance;
  final _db = ServiceInitializer.database;

  /// Analyze a new transaction for potential nudges
  Future<void> analyzeTransaction(Transaction transaction) async {
    // Only analyze debits (spending)
    if (transaction.type != TransactionType.debit) return;
    
    final merchantId = transaction.rawMerchantId;
    if (merchantId == null) return;

    // 1. Gather Context
    final intelligence = await _db.merchantIntelligenceDao.get(
      TransactionParser.normalizeMerchantId(merchantId)
    );
    
    final activeGoals = await _db.goalDao.getActiveGoals();
    
    // If no intelligence or goals, maybe skip or do simple check
    if (intelligence == null && activeGoals.isEmpty) return;

    // 2. Build Prompt
    final prompt = _buildNudgePrompt(transaction, intelligence, activeGoals);
    
    // 3. Call Gemini (Deep Brain)
    final aiResponse = await _gemini.generateContent(prompt);
    
    if (aiResponse != null) {
      try {
        final parsed = _parseJson(aiResponse);
        
        // 4. If Nudge generated, save it
        if (parsed['should_nudge'] == true) {
          await _db.insightDao.createInsight(
            type: 'spending_alert',
            title: parsed['title'] ?? 'Spending Alert',
            subtitle: parsed['message'] ?? 'Check your spending',
            icon: parsed['icon'] ?? '⚠️',
            category: transaction.category,
            dataJson: jsonEncode(parsed),
          );
          
          // TODO: Also trigger local notification if urgent
        }
      } catch (e) {
        debugPrint('[InsightService] Error parsing nudge: $e');
      }
    }
  }

  String _buildNudgePrompt(
    Transaction t,
    MerchantIntelligenceData? history,
    List<Goal> goals,
  ) {
    // Format goals for context
    final goalsContext = goals.map((g) => 
      "- ${g.name}: Target ₹${g.targetAmount}, Saved ₹${g.currentAmount} (Priority: ${g.priority})"
    ).join('\n');

    // Format history
    final historyContext = history != null
        ? "- Typical Spend: ₹${history.typicalAmount ?? 'Unknown'}\n- Summary: ${history.historySummary ?? 'None'}"
        : "- No history for this merchant";

    return '''
You are FinPulse, a financial conscience.
Analyze this transaction:
- Merchant: ${t.merchantName ?? t.rawMerchantId}
- Amount: ₹${t.amount}
- Time: ${t.timestamp.toString()}

Context:
$historyContext

Active Goals:
$goalsContext

Task: Decide if a "Nudge" is needed.
Triggers for Nudge:
1. Significant deviation from typical spend (e.g. 3x normal).
2. Spending that impacts a high-priority goal (e.g. buying expensive coffee when saving for a trip).
3. Unusual time or frequency.

Output JSON ONLY:
{
  "should_nudge": true,
  "title": "Bali Trip Alert ✈️",
  "message": "This ₹${t.amount} dinner is 1% of your Bali fund. Worth it?",
  "icon": "✈️",
  "severity": "medium"
}

If no nudge needed, set "should_nudge": false.
''';
  }

  Map<String, dynamic> _parseJson(String text) {
    String jsonStr = text;
    if (text.contains('```json')) {
      jsonStr = text.split('```json')[1].split('```')[0].trim();
    } else if (text.contains('```')) {
      jsonStr = text.split('```')[1].split('```')[0].trim();
    }
    return jsonDecode(jsonStr);
  }
  
  /// Generate weekly summary insight
  Future<void> generateWeeklySummary() async {
    // Placeholder for periodic insight generation
  }
}
