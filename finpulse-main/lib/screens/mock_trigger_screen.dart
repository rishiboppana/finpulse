import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:permission_handler/permission_handler.dart';

import '../models/transaction.dart';
import '../services/transaction_parser.dart';
import '../services/gemini_service.dart';
import '../services/merchant_learning_service.dart';
import '../services/notification_service.dart';
import '../services/transaction_storage_service.dart';

/// Mock Trigger Screen for Hackathon Demo
/// Allows triggering simulated payment notifications to test the AI pipeline.
class MockTriggerScreen extends StatefulWidget {
  const MockTriggerScreen({super.key});

  @override
  State<MockTriggerScreen> createState() => _MockTriggerScreenState();
}

class _MockTriggerScreenState extends State<MockTriggerScreen> {
  final _smsController = TextEditingController();
  ParseResult? _lastResult;
  bool _isLoading = false;
  int _selectedTemplateIndex = -1;

  @override
  void dispose() {
    _smsController.dispose();
    super.dispose();
  }

  Future<void> _parseMessage() async {
    if (_smsController.text.trim().isEmpty) return;

    setState(() => _isLoading = true);

    // Use mock AI for demo (no API key needed)
    final result = GeminiService.mockParseWithAI(
      _smsController.text,
      source: DetectionSource.manual,
    );

    setState(() {
      _lastResult = result;
      _isLoading = false;
    });

    if (result.success && mounted) {
      _showGoldenWindowNotification(result.transaction!);
    }
  }

  void _showGoldenWindowNotification(Transaction transaction) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => GoldenWindowSheet(transaction: transaction),
    );
  }

  void _selectTemplate(int index) {
    setState(() {
      _selectedTemplateIndex = index;
      _smsController.text = SampleSmsTemplates.templates[index];
    });
  }

  @override
  Widget build(BuildContext context) {
    const teal = Color(0xFF29D6C7);
    const textDark = Color(0xFF0F172A);
    const muted = Color(0xFF64748B);

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        title: const Text(
          'Mock Payment Trigger',
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
        backgroundColor: Colors.white,
        foregroundColor: textDark,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: teal.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: teal.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Icon(Icons.science_rounded, color: teal, size: 32),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hackathon Demo Bench',
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          'Simulate payments to test the AI pipeline',
                          style: TextStyle(
                            color: muted,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Template selector
            const Text(
              'Quick Templates',
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 16,
                color: textDark,
              ),
            ),
            const SizedBox(height: 12),

            SizedBox(
              height: 44,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _templateLabels.length,
                itemBuilder: (ctx, index) {
                  final isSelected = _selectedTemplateIndex == index;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(_templateLabels[index]),
                      selected: isSelected,
                      onSelected: (_) => _selectTemplate(index),
                      selectedColor: teal,
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.black : muted,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 24),

            // SMS Input
            const Text(
              'SMS / Notification Text',
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 16,
                color: textDark,
              ),
            ),
            const SizedBox(height: 12),

            TextField(
              controller: _smsController,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: 'Paste a bank SMS or notification...',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: teal, width: 2),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Parse Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton.icon(
                onPressed: _isLoading ? null : _parseMessage,
                icon: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.black,
                        ),
                      )
                    : const Icon(Icons.bolt_rounded),
                label: Text(
                  _isLoading ? 'Parsing...' : 'Trigger Golden Window',
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 16,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: teal,
                  foregroundColor: Colors.black,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Result Display
            if (_lastResult != null) ...[
              const Text(
                'Parse Result',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                  color: textDark,
                ),
              ),
              const SizedBox(height: 12),
              _buildResultCard(_lastResult!),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildResultCard(ParseResult result) {
    if (!result.success) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFFEE2E2),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            const Icon(Icons.error_outline, color: Color(0xFFDC2626)),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                result.errorMessage ?? 'Unknown error',
                style: const TextStyle(color: Color(0xFFDC2626)),
              ),
            ),
          ],
        ),
      );
    }

    final txn = result.transaction!;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // AI Badge
          if (txn.isParsedByAI)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF8B5CF6).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.auto_awesome, size: 14, color: Color(0xFF8B5CF6)),
                  SizedBox(width: 4),
                  Text(
                    'Parsed by Gemini AI',
                    style: TextStyle(
                      color: Color(0xFF8B5CF6),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 12),

          // Amount
          Text(
            txn.formattedAmount,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w900,
              color: Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 8),

          // Details
          _buildDetailRow('Type', txn.type.name.toUpperCase()),
          _buildDetailRow('Merchant', txn.rawMerchantId ?? 'Unknown'),
          _buildDetailRow('Account', 'XXXX${txn.accountLastDigits ?? '----'}'),
          _buildDetailRow('Time', _formatTime(txn.timestamp)),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: const TextStyle(
                color: Color(0xFF64748B),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Color(0xFF0F172A),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime dt) {
    final hour = dt.hour.toString().padLeft(2, '0');
    final min = dt.minute.toString().padLeft(2, '0');
    return '${dt.day}/${dt.month}/${dt.year} $hour:$min';
  }

  static const _templateLabels = [
    'HDFC',
    'ICICI',
    'SBI',
    'PhonePe',
    'GPay',
    'Paytm',
    'Zomato',
    'Swiggy',
  ];
}

/// The "Golden Window" Bottom Sheet
/// Appears immediately after a payment is detected.
class GoldenWindowSheet extends StatefulWidget {
  final Transaction transaction;

  const GoldenWindowSheet({required this.transaction});

  @override
  State<GoldenWindowSheet> createState() => GoldenWindowSheetState();
}

class GoldenWindowSheetState extends State<GoldenWindowSheet> {
  final _tagController = TextEditingController();
  String? _selectedCategory;
  
  // Speech to text
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;
  bool _speechAvailable = false;

  static const _categories = [
    '🍕 Food',
    '🛒 Groceries',
    '🚗 Transport',
    '🎬 Entertainment',
    '💊 Health',
    '🛍️ Shopping',
    '📱 Bills',
    '💰 Other',
  ];

  @override
  void initState() {
    super.initState();
    _checkLearnedMerchant();
    _initSpeech();
  }

  Future<void> _initSpeech() async {
    final status = await Permission.microphone.request();
    if (status.isGranted) {
      _speechAvailable = await _speech.initialize(
        onStatus: (status) {
          if (status == 'done' || status == 'notListening') {
            if (mounted) setState(() => _isListening = false);
          }
        },
        onError: (error) {
          if (mounted) setState(() => _isListening = false);
        },
      );
    }
    if (mounted) setState(() {});
  }

  void _startListening() async {
    if (!_speechAvailable) {
      await _initSpeech();
      if (!_speechAvailable) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Please grant microphone permission'),
              action: SnackBarAction(label: 'Settings', onPressed: openAppSettings),
            ),
          );
        }
        return;
      }
    }

    setState(() => _isListening = true);
    
    await _speech.listen(
      onResult: (result) {
        if (mounted) {
          setState(() {
            _tagController.text = result.recognizedWords;
          });
        }
        if (result.finalResult) {
          setState(() => _isListening = false);
        }
      },
      listenFor: const Duration(seconds: 10),
      pauseFor: const Duration(seconds: 3),
      localeId: 'en_IN',
    );
  }

  void _stopListening() {
    _speech.stop();
    setState(() => _isListening = false);
  }

  void _checkLearnedMerchant() {
    final merchantId = widget.transaction.rawMerchantId;
    if (merchantId != null) {
      final mapping = MerchantLearningService.instance.getMapping(merchantId);
      if (mapping != null) {
        setState(() {
          // Pre-fill friendly name if available
          if (mapping.friendlyName != null) {
            _tagController.text = mapping.friendlyName!;
          }
          
          // Match category from list
          final categoryName = mapping.category;
          _selectedCategory = _categories.firstWhere(
            (c) => c.contains(categoryName),
            orElse: () => _categories.last, // Fallback to 'Other'
          );
        });
      }
    }
  }

  @override
  void dispose() {
    _tagController.dispose();
    _speech.stop();
    super.dispose();
  }

  Future<void> _submitTag() async {
    final tag = _tagController.text.trim().isNotEmpty
        ? _tagController.text.trim()
        : _selectedCategory;

    if (tag != null) {
      // Save to merchant learning DB
      final merchantId = widget.transaction.rawMerchantId;
      // Extract category name (remove emoji)
      final categoryName = tag.replaceAll(RegExp(r'[^\w\s]'), '').trim();
      
      if (merchantId != null) {
        await MerchantLearningService.instance.learnMerchant(
          rawMerchantId: merchantId,
          category: categoryName,
          friendlyName: _tagController.text.trim().isNotEmpty 
              ? _tagController.text.trim() 
              : null,
        );
      }
      
      // Save/Update transaction with category to storage
      final updatedTransaction = widget.transaction.copyWith(
        category: categoryName,
        merchantName: _tagController.text.trim().isNotEmpty 
            ? _tagController.text.trim() 
            : widget.transaction.merchantName,
      );
      await TransactionStorageService.instance.addTransaction(updatedTransaction);
      
      if (!mounted) return;
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Saved ₹${widget.transaction.amount.toStringAsFixed(0)} as "$categoryName"'),
          backgroundColor: const Color(0xFF10B981),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const teal = Color(0xFF29D6C7);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFE5E7EB),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: teal.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.bolt_rounded, color: teal, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Payment Detected!',
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      widget.transaction.formattedAmount,
                      style: TextStyle(
                        color: teal,
                        fontWeight: FontWeight.w800,
                        fontSize: 24,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),
          Text(
            'To: ${widget.transaction.rawMerchantId ?? 'Unknown Merchant'}',
            style: const TextStyle(
              color: Color(0xFF64748B),
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 24),

          // Quick categories
          const Text(
            'Quick Tag',
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _categories.map((cat) {
              final isSelected = _selectedCategory == cat;
              return ChoiceChip(
                label: Text(cat),
                selected: isSelected,
                onSelected: (sel) {
                  setState(() => _selectedCategory = sel ? cat : null);
                },
                selectedColor: teal,
                labelStyle: TextStyle(
                  color: isSelected ? Colors.black : const Color(0xFF64748B),
                  fontWeight: FontWeight.w600,
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 20),

          // Text input for custom tag
          TextField(
            controller: _tagController,
            decoration: InputDecoration(
              hintText: 'Or type: "doodh aur bread 150"',
              filled: true,
              fillColor: const Color(0xFFF7F8FA),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              suffixIcon: const Icon(Icons.edit_note, color: Colors.grey),
            ),
          ),

          const SizedBox(height: 24),

          // Voice Input Section (Hackathon Highlight)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _isListening 
                  ? const Color(0xFF29D6C7).withOpacity(0.1)
                  : const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: _isListening 
                    ? const Color(0xFF29D6C7)
                    : const Color(0xFFE2E8F0),
                width: _isListening ? 2 : 1,
              ),
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTapDown: (_) => _startListening(),
                  onTapUp: (_) => _stopListening(),
                  onTapCancel: () => _stopListening(),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: _isListening ? const Color(0xFF29D6C7) : Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _isListening ? Icons.mic : Icons.mic_rounded,
                      color: _isListening ? Colors.white : const Color(0xFF29D6C7),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _isListening ? 'Listening...' : 'Speak in Hinglish',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                          color: _isListening ? const Color(0xFF29D6C7) : Colors.black,
                        ),
                      ),
                      Text(
                        _isListening 
                            ? 'Release to stop' 
                            : 'Hold mic: "Chai stall pe bhai"',
                        style: const TextStyle(
                          color: Color(0xFF64748B),
                          fontSize: 12,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: _isListening ? _stopListening : _startListening,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isListening 
                        ? Colors.red 
                        : const Color(0xFF29D6C7),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text(_isListening ? 'Stop' : '🎤 Speak'),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Submit
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: _submitTag,
              style: ElevatedButton.styleFrom(
                backgroundColor: teal,
                foregroundColor: Colors.black,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                _selectedCategory != null || _tagController.text.isNotEmpty
                    ? 'Update & Save'
                    : 'Save & Learn',
                style: const TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 16,
                ),
              ),
            ),
          ),

          SizedBox(height: MediaQuery.of(context).padding.bottom + 8),
        ],
      ),
    );
  }
}
