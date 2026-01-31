import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/gemini_service.dart';
import '../services/transaction_storage_service.dart';
import '../models/transaction.dart';

/// Receipt Scanning Screen
/// Uses camera/gallery to capture receipts and Gemini Vision to extract data
class ReceiptScanScreen extends StatefulWidget {
  const ReceiptScanScreen({super.key});

  @override
  State<ReceiptScanScreen> createState() => _ReceiptScanScreenState();
}

class _ReceiptScanScreenState extends State<ReceiptScanScreen> {
  final ImagePicker _picker = ImagePicker();
  File? _selectedImage;
  bool _isProcessing = false;
  ReceiptData? _extractedData;
  String? _error;

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 1200,
        maxHeight: 1600,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
          _extractedData = null;
          _error = null;
        });
        
        await _processReceipt();
      }
    } catch (e) {
      setState(() => _error = 'Failed to pick image: $e');
    }
  }

  Future<void> _processReceipt() async {
    if (_selectedImage == null) return;

    setState(() {
      _isProcessing = true;
      _error = null;
    });

    try {
      // Read image bytes
      final imageBytes = await _selectedImage!.readAsBytes();
      
      // Call Gemini Vision API
      final result = await GeminiService.instance.analyzeReceiptImage(imageBytes);
      
      if (result != null) {
        // Parse the result into ReceiptData
        final items = (result['items'] as List<dynamic>?)?.map((item) {
          return ReceiptItem(
            name: item['name']?.toString() ?? 'Item',
            price: (item['price'] as num?)?.toDouble() ?? 0.0,
            quantity: (item['quantity'] as num?)?.toInt() ?? 1,
          );
        }).toList() ?? [];

        DateTime? parsedDate;
        if (result['date'] != null) {
          parsedDate = DateTime.tryParse(result['date'].toString());
        }

        setState(() {
          _extractedData = ReceiptData(
            merchant: result['merchant_name']?.toString() ?? 'Unknown Store',
            date: parsedDate ?? DateTime.now(),
            total: (result['total'] as num?)?.toDouble() ?? 0.0,
            items: items.isEmpty ? [ReceiptItem(name: 'Purchase', price: (result['total'] as num?)?.toDouble() ?? 0.0)] : items,
            suggestedCategory: result['category']?.toString() ?? 'Other',
            confidence: (result['confidence'] as num?)?.toDouble() ?? 0.8,
          );
          _isProcessing = false;
        });
      } else {
        setState(() {
          _error = 'Could not analyze receipt. Please try a clearer image.';
          _isProcessing = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Failed to process receipt: $e';
        _isProcessing = false;
      });
    }
  }

  void _saveTransaction() async {
    if (_extractedData == null) return;

    // Create a transaction from the extracted receipt data
    final transaction = Transaction(
      id: 'receipt_${DateTime.now().millisecondsSinceEpoch}',
      amount: _extractedData!.total,
      timestamp: _extractedData!.date,
      rawMerchantId: _extractedData!.merchant,
      merchantName: _extractedData!.merchant,
      category: _extractedData!.suggestedCategory,
      type: TransactionType.debit,
      source: DetectionSource.manual,
      rawText: 'Receipt scan: ${_extractedData!.merchant} - ₹${_extractedData!.total}',
    );

    // Save to local storage
    await TransactionStorageService.instance.addTransaction(transaction);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Saved: ₹${_extractedData!.total.toStringAsFixed(2)} at ${_extractedData!.merchant}'),
          backgroundColor: const Color(0xFF10B981),
        ),
      );
      Navigator.pop(context, _extractedData);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Scan Receipt',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          if (_extractedData != null)
            TextButton(
              onPressed: _saveTransaction,
              child: const Text(
                'Save',
                style: TextStyle(
                  color: Color(0xFF6366F1),
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Image preview or picker
            if (_selectedImage != null)
              _buildImagePreview()
            else
              _buildImagePicker(),

            const SizedBox(height: 24),

            // Processing indicator
            if (_isProcessing)
              _buildProcessingIndicator(),

            // Error message
            if (_error != null)
              _buildErrorMessage(),

            // Extracted data
            if (_extractedData != null && !_isProcessing)
              _buildExtractedData(),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePicker() {
    return Container(
      height: 300,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFFE2E8F0),
          width: 2,
          style: BorderStyle.solid,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF6366F1).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.receipt_long_rounded,
              size: 48,
              color: Color(0xFF6366F1),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Scan a Receipt',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Take a photo or select from gallery',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildPickerButton(
                icon: Icons.camera_alt_rounded,
                label: 'Camera',
                onTap: () => _pickImage(ImageSource.camera),
              ),
              const SizedBox(width: 16),
              _buildPickerButton(
                icon: Icons.photo_library_rounded,
                label: 'Gallery',
                onTap: () => _pickImage(ImageSource.gallery),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPickerButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF6366F1).withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePreview() {
    return Stack(
      children: [
        Container(
          height: 250,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Image.file(
              _selectedImage!,
              fit: BoxFit.cover,
              width: double.infinity,
            ),
          ),
        ),
        Positioned(
          top: 12,
          right: 12,
          child: GestureDetector(
            onTap: () {
              setState(() {
                _selectedImage = null;
                _extractedData = null;
              });
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.close,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProcessingIndicator() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        children: [
          const SizedBox(
            width: 48,
            height: 48,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              valueColor: AlwaysStoppedAnimation(Color(0xFF6366F1)),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Analyzing Receipt...',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Gemini Vision is extracting items and total',
            style: TextStyle(
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorMessage() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFEF2F2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFFECACA)),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: Color(0xFFEF4444)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              _error!,
              style: const TextStyle(color: Color(0xFFDC2626)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExtractedData() {
    final data = _extractedData!;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with merchant and badge
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
              ),
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.store_rounded,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data.merchant,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${data.date.day}/${data.date.month}/${data.date.year}',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.auto_awesome, color: Colors.white, size: 14),
                      const SizedBox(width: 4),
                      Text(
                        '${(data.confidence * 100).toInt()}%',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Items list
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Items (${data.items.length})',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF10B981).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '🛒 ${data.suggestedCategory}',
                        style: const TextStyle(
                          color: Color(0xFF10B981),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                
                ...data.items.map((item) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          item.name,
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                      ),
                      if (item.quantity > 1)
                        Text(
                          'x${item.quantity}  ',
                          style: TextStyle(color: Colors.grey[500]),
                        ),
                      Text(
                        '₹${item.price.toStringAsFixed(2)}',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                )),

                const Divider(height: 32),

                // Total
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '₹${data.total.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF6366F1),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Data model for extracted receipt
class ReceiptData {
  final String merchant;
  final DateTime date;
  final double total;
  final List<ReceiptItem> items;
  final String suggestedCategory;
  final double confidence;

  ReceiptData({
    required this.merchant,
    required this.date,
    required this.total,
    required this.items,
    required this.suggestedCategory,
    required this.confidence,
  });
}

class ReceiptItem {
  final String name;
  final double price;
  final int quantity;

  ReceiptItem({
    required this.name,
    required this.price,
    this.quantity = 1,
  });
}
