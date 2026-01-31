import 'package:flutter/foundation.dart';
import '../models/transaction.dart';

/// Verification status for transactions detected by multiple layers
enum VerificationStatus {
  pending,       // Only detected by one layer
  dualVerified,  // Confirmed by 2 layers (e.g., Notification + SMS)
  tripleVerified, // Confirmed by 3 layers (Accessibility + Notification + SMS)
  official,      // Verified by AA Framework (coming soon)
}

/// Transaction with deduplication metadata
class DeduplicatedTransaction {
  final Transaction transaction;
  final VerificationStatus status;
  final List<DetectionSource> detectedBy;
  final String fingerprint;
  final DateTime firstDetected;
  final DateTime lastUpdated;

  DeduplicatedTransaction({
    required this.transaction,
    required this.status,
    required this.detectedBy,
    required this.fingerprint,
    required this.firstDetected,
    required this.lastUpdated,
  });

  DeduplicatedTransaction copyWith({
    Transaction? transaction,
    VerificationStatus? status,
    List<DetectionSource>? detectedBy,
    String? fingerprint,
    DateTime? firstDetected,
    DateTime? lastUpdated,
  }) {
    return DeduplicatedTransaction(
      transaction: transaction ?? this.transaction,
      status: status ?? this.status,
      detectedBy: detectedBy ?? this.detectedBy,
      fingerprint: fingerprint ?? this.fingerprint,
      firstDetected: firstDetected ?? this.firstDetected,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  /// Status badge for UI
  String get statusBadge {
    switch (status) {
      case VerificationStatus.pending:
        return '⏳ Pending';
      case VerificationStatus.dualVerified:
        return '✓✓ Verified';
      case VerificationStatus.tripleVerified:
        return '✓✓✓ Confirmed';
      case VerificationStatus.official:
        return '🏦 Official';
    }
  }

  /// Status color for UI
  int get statusColorValue {
    switch (status) {
      case VerificationStatus.pending:
        return 0xFFF59E0B; // Amber
      case VerificationStatus.dualVerified:
        return 0xFF10B981; // Green
      case VerificationStatus.tripleVerified:
        return 0xFF3B82F6; // Blue
      case VerificationStatus.official:
        return 0xFF8B5CF6; // Purple
    }
  }
}

/// Service for deduplicating transactions across multiple detection layers
class DeduplicationService {
  static final DeduplicationService instance = DeduplicationService._();
  DeduplicationService._();

  // Store of deduplicated transactions by fingerprint
  final Map<String, DeduplicatedTransaction> _transactionStore = {};

  // Time window for matching transactions (5 minutes)
  static const Duration matchWindow = Duration(minutes: 5);

  // Amount tolerance for matching (handles rounding differences)
  static const double amountTolerance = 2.0;

  /// Get all deduplicated transactions
  List<DeduplicatedTransaction> get transactions => 
      _transactionStore.values.toList()
        ..sort((a, b) => b.lastUpdated.compareTo(a.lastUpdated));

  /// Process a new transaction and either create or merge it
  DeduplicatedTransaction processTransaction(Transaction newTxn) {
    // Generate fingerprint
    final fingerprint = _generateFingerprint(newTxn);
    
    // Look for existing match
    final existingMatch = _findMatch(newTxn);
    
    if (existingMatch != null) {
      // Merge with existing transaction
      return _mergeTransaction(existingMatch, newTxn);
    } else {
      // Create new deduplicated transaction
      final dedupTxn = DeduplicatedTransaction(
        transaction: newTxn,
        status: VerificationStatus.pending,
        detectedBy: [newTxn.source],
        fingerprint: fingerprint,
        firstDetected: DateTime.now(),
        lastUpdated: DateTime.now(),
      );
      
      _transactionStore[fingerprint] = dedupTxn;
      debugPrint('DeduplicationService: New transaction created ($fingerprint)');
      return dedupTxn;
    }
  }

  /// Find a matching transaction within the time window
  DeduplicatedTransaction? _findMatch(Transaction newTxn) {
    final now = DateTime.now();
    
    for (final entry in _transactionStore.entries) {
      final existingTxn = entry.value.transaction;
      
      // Check time window
      final timeDiff = now.difference(entry.value.firstDetected);
      if (timeDiff > matchWindow) continue;
      
      // Check amount (with tolerance)
      if ((existingTxn.amount - newTxn.amount).abs() > amountTolerance) continue;
      
      // Check if merchant matches (normalized)
      if (!_merchantMatches(existingTxn.rawMerchantId, newTxn.rawMerchantId)) continue;
      
      // Check if not already detected by this source
      if (entry.value.detectedBy.contains(newTxn.source)) continue;
      
      // Match found!
      return entry.value;
    }
    
    return null;
  }

  /// Merge a new detection into an existing transaction
  DeduplicatedTransaction _mergeTransaction(
    DeduplicatedTransaction existing,
    Transaction newTxn,
  ) {
    // Update detection sources
    final updatedSources = [...existing.detectedBy, newTxn.source];
    
    // Calculate new verification status
    final newStatus = _calculateStatus(updatedSources);
    
    // Use the most detailed transaction data
    final mergedTxn = _mergeTransactionData(existing.transaction, newTxn);
    
    final updated = existing.copyWith(
      transaction: mergedTxn,
      status: newStatus,
      detectedBy: updatedSources,
      lastUpdated: DateTime.now(),
    );
    
    _transactionStore[existing.fingerprint] = updated;
    
    debugPrint(
      'DeduplicationService: Transaction merged (${existing.fingerprint}), '
      'status: ${newStatus.name}, sources: ${updatedSources.map((s) => s.name).join(", ")}'
    );
    
    return updated;
  }

  /// Generate a fingerprint for deduplication
  String _generateFingerprint(Transaction txn) {
    // Round timestamp to nearest 5 minutes
    final roundedTime = DateTime(
      txn.timestamp.year,
      txn.timestamp.month,
      txn.timestamp.day,
      txn.timestamp.hour,
      (txn.timestamp.minute ~/ 5) * 5,
    );
    
    // Normalize amount (round to nearest rupee)
    final roundedAmount = txn.amount.round();
    
    // Normalize merchant
    final normalizedMerchant = _normalizeMerchant(txn.rawMerchantId ?? 'unknown');
    
    return '${roundedAmount}_${normalizedMerchant}_${roundedTime.millisecondsSinceEpoch}';
  }

  /// Normalize merchant name for comparison
  String _normalizeMerchant(String merchant) {
    return merchant
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]'), '')
        .substring(0, merchant.length.clamp(0, 10));
  }

  /// Check if two merchants match
  bool _merchantMatches(String? merchant1, String? merchant2) {
    if (merchant1 == null || merchant2 == null) return true; // Assume match if unknown
    
    final norm1 = _normalizeMerchant(merchant1);
    final norm2 = _normalizeMerchant(merchant2);
    
    // Check if one contains the other
    return norm1.contains(norm2) || norm2.contains(norm1) || norm1 == norm2;
  }

  /// Calculate verification status based on detection sources
  VerificationStatus _calculateStatus(List<DetectionSource> sources) {
    final uniqueSources = sources.toSet();
    
    if (uniqueSources.length >= 3) {
      return VerificationStatus.tripleVerified;
    } else if (uniqueSources.length >= 2) {
      return VerificationStatus.dualVerified;
    } else {
      return VerificationStatus.pending;
    }
  }

  /// Merge transaction data, preferring more detailed information
  Transaction _mergeTransactionData(Transaction existing, Transaction newTxn) {
    return Transaction(
      id: existing.id,
      amount: existing.amount, // Keep first detected amount
      timestamp: existing.timestamp, // Keep first timestamp
      accountLastDigits: existing.accountLastDigits ?? newTxn.accountLastDigits,
      rawMerchantId: existing.rawMerchantId ?? newTxn.rawMerchantId,
      transactionId: existing.transactionId ?? newTxn.transactionId,
      type: existing.type,
      source: existing.source, // Keep original source
      rawText: '${existing.rawText}\n---\n${newTxn.rawText}', // Combine raw texts
      categoryId: existing.categoryId ?? newTxn.categoryId,
      displayMerchant: existing.displayMerchant ?? newTxn.displayMerchant,
      isParsedByAI: existing.isParsedByAI || newTxn.isParsedByAI,
    );
  }

  /// Clear old transactions (older than 24 hours)
  void clearOldTransactions() {
    final cutoff = DateTime.now().subtract(const Duration(hours: 24));
    
    _transactionStore.removeWhere((key, value) => 
      value.lastUpdated.isBefore(cutoff)
    );
  }

  /// Get transaction by fingerprint
  DeduplicatedTransaction? getByFingerprint(String fingerprint) {
    return _transactionStore[fingerprint];
  }

  /// Get all pending (unverified) transactions
  List<DeduplicatedTransaction> get pendingTransactions {
    return transactions
        .where((t) => t.status == VerificationStatus.pending)
        .toList();
  }

  /// Get verified transactions
  List<DeduplicatedTransaction> get verifiedTransactions {
    return transactions
        .where((t) => t.status != VerificationStatus.pending)
        .toList();
  }
}
