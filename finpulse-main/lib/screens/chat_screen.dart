import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:permission_handler/permission_handler.dart';
import '../services/gemini_service.dart';
import '../models/transaction.dart';
import '../services/service_initializer.dart';
import '../services/transaction_parser.dart';

/// Full-screen Chat UI for conversational AI queries
/// Supports text input and voice commands
class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  final List<ChatMessage> _messages = [];
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final stt.SpeechToText _speech = stt.SpeechToText();
  
  bool _isListening = false;
  bool _isProcessing = false;
  bool _speechAvailable = false;
  String _lastWords = '';

  @override
  void initState() {
    super.initState();
    _initSpeech();
    _addWelcomeMessage();
  }

  Future<void> _initSpeech() async {
    // Request microphone permission first
    final status = await Permission.microphone.request();
    
    if (status.isGranted) {
      try {
        _speechAvailable = await _speech.initialize(
          onStatus: (status) {
            debugPrint('Speech status: $status');
            if (status == 'done' || status == 'notListening') {
              if (mounted) setState(() => _isListening = false);
            }
          },
          onError: (error) {
            debugPrint('Speech error: ${error.errorMsg}');
            if (mounted) {
              setState(() => _isListening = false);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Voice error: ${error.errorMsg}')),
              );
            }
          },
        );
        debugPrint('Speech available: $_speechAvailable');
      } catch (e) {
        debugPrint('Failed to initialize speech: $e');
        _speechAvailable = false;
      }
    } else {
      _speechAvailable = false;
      debugPrint('Microphone permission denied');
    }
    
    if (mounted) setState(() {});
  }

  void _addWelcomeMessage() {
    _messages.add(ChatMessage(
      text: "Hi! I'm your FinPulse AI assistant 💰\n\nAsk me anything about your spending, like:\n• \"How much did I spend on food this week?\"\n• \"What's my biggest expense this month?\"\n• \"Show my spending trends\"",
      isUser: false,
      timestamp: DateTime.now(),
    ));
  }

  void _startListening() async {
    // Try to initialize if not already done
    if (!_speechAvailable) {
      await _initSpeech();
      
      if (!_speechAvailable) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Please grant microphone permission to use voice'),
              action: SnackBarAction(
                label: 'Open Settings',
                onPressed: openAppSettings,
              ),
            ),
          );
        }
        return;
      }
    }

    setState(() => _isListening = true);
    
    try {
      await _speech.listen(
        onResult: (result) {
          debugPrint('Speech result: ${result.recognizedWords}');
          if (mounted) {
            setState(() {
              _lastWords = result.recognizedWords;
              _textController.text = _lastWords;
            });
          }
          
          if (result.finalResult && result.recognizedWords.isNotEmpty) {
            _stopListening();
            _sendMessage();
          }
        },
        listenFor: const Duration(seconds: 30),
        pauseFor: const Duration(seconds: 3),
        localeId: 'en_IN',
        cancelOnError: true,
        partialResults: true,
      );
    } catch (e) {
      debugPrint('Listen error: $e');
      if (mounted) {
        setState(() => _isListening = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to start voice: $e')),
        );
      }
    }
  }

  void _stopListening() async {
    await _speech.stop();
    setState(() => _isListening = false);
  }

  void _sendMessage() async {
    final text = _textController.text.trim();
    if (text.isEmpty || _isProcessing) return;

    // Add user message
    setState(() {
      _messages.add(ChatMessage(
        text: text,
        isUser: true,
        timestamp: DateTime.now(),
      ));
      _isProcessing = true;
    });
    
    _textController.clear();
    _scrollToBottom();

    try {
      // Get AI response
      final response = await _getAIResponse(text);
      
      setState(() {
        _messages.add(ChatMessage(
          text: response,
          isUser: false,
          timestamp: DateTime.now(),
          isAiGenerated: !response.contains("trouble connecting"),
        ));
        _isProcessing = false;
      });
      
      _scrollToBottom();
    } catch (e) {
      setState(() {
        _messages.add(ChatMessage(
          text: "Sorry, I couldn't process that request. Please try again.",
          isUser: false,
          timestamp: DateTime.now(),
        ));
        _isProcessing = false;
      });
    }
  }

  Future<String> _getAIResponse(String query) async {
    // 1. Fetch real context from database
    final txService = ServiceInitializer.transactions;
    final todaySpend = await txService.getTodaySpendingAsync();
    final recentTxs = await txService.watchAllTransactions().first; // Get latest snapshot
    final categories = await txService.getSpendingByCategoryAsync();
    
    // Sort transactions by date descending and take top 10
    recentTxs.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    final last10Txs = recentTxs.take(10).toList();

    // 2. Build context string
    final contextBuffer = StringBuffer();
    contextBuffer.writeln("Current Date: ${DateTime.now().toLocal()}");
    contextBuffer.writeln("Today's Total Spending: ₹${todaySpend.toStringAsFixed(2)}");
    
    contextBuffer.writeln("\nSpending by Category:");
    categories.forEach((cat, amount) {
      contextBuffer.writeln("- $cat: ₹${amount.toStringAsFixed(2)}");
    });
    
    contextBuffer.writeln("\nRecent Transactions (Last 10):");
    for (final tx in last10Txs) {
      contextBuffer.writeln("- ${tx.timestamp.toLocal().toString().split('.')[0]}: ${tx.merchantName ?? tx.rawMerchantId} - ₹${tx.amount.toStringAsFixed(2)} (${tx.category ?? 'Uncategorized'})");
    }

    // 3. Construct Prompt
    final prompt = '''
You are FinPulse AI, a smart personal finance assistant.
Use the following REAL user data to answer the query accurately.

CONTEXT DATA:
${contextBuffer.toString()}

User Query: "$query"

Guidelines:
- Answer based ONLY on the provided data.
- If the answer isn't in the data, say you don't have that info yet.
- Be concise, friendly, and helpful.
- Use Indian Rupee symbol (₹) for currency.
- If asked about "recent" or "last", refer to the Recent Transactions list.
- If asked about "summary" or "breakdown", refer to Spending by Category.
''';

    try {
      // Use generateContent for chat queries
      final result = await GeminiService.instance.generateContent(prompt);
      
      if (result != null && result.isNotEmpty) {
        return result;
      }
      
      throw Exception('Gemini returned empty response');
    } catch (e) {
      return "I'm having trouble connecting to my Gemini AI core right now. 🛰️\n\nPlease check your internet connection or try again in a moment.";
    }
  }


  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    _speech.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.auto_awesome, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 12),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'FinPulse AI',
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                Text(
                  'Your finance assistant',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.history, color: Colors.grey),
            onPressed: () {
              // TODO: Show chat history
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Messages list
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: _messages.length + (_isProcessing ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _messages.length && _isProcessing) {
                  return _buildTypingIndicator();
                }
                return _buildMessage(_messages[index]);
              },
            ),
          ),
          
          // Input area
          Container(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                // Voice button
                GestureDetector(
                  onTap: _isListening ? _stopListening : _startListening,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: _isListening 
                          ? const Color(0xFFEF4444) 
                          : const Color(0xFF6366F1),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: _isListening ? [
                        BoxShadow(
                          color: const Color(0xFFEF4444).withOpacity(0.4),
                          blurRadius: 12,
                          spreadRadius: 2,
                        ),
                      ] : null,
                    ),
                    child: Icon(
                      _isListening ? Icons.stop_rounded : Icons.mic_rounded,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                
                // Text input
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: InputDecoration(
                      hintText: _isListening ? 'Listening...' : 'Ask about your spending...',
                      hintStyle: TextStyle(color: Colors.grey[400]),
                      filled: true,
                      fillColor: const Color(0xFFF1F5F9),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 12),
                
                // Send button
                GestureDetector(
                  onTap: _sendMessage,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(
                      Icons.send_rounded,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessage(ChatMessage message) {
    final isUser = message.isUser;
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) ...[
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.auto_awesome, color: Colors.white, size: 16),
            ),
            const SizedBox(width: 8),
          ],
          
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isUser ? const Color(0xFF6366F1) : Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(20),
                  topRight: const Radius.circular(20),
                  bottomLeft: Radius.circular(isUser ? 20 : 4),
                  bottomRight: Radius.circular(isUser ? 4 : 20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message.text,
                    style: TextStyle(
                      color: isUser ? Colors.white : Colors.black87,
                      fontSize: 15,
                      height: 1.5,
                    ),
                  ),
                  if (!isUser && message.isAiGenerated) ...[
                    const SizedBox(height: 8),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.auto_awesome, 
                          size: 12, 
                          color: const Color(0xFF6366F1).withOpacity(0.7)
                        ),
                        const SizedBox(width: 4),
                        Text(
                          "Powered by Gemini 2.5 Flash",
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF6366F1).withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
          
          if (isUser) const SizedBox(width: 8),
        ],
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.auto_awesome, color: Colors.white, size: 16),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildDot(0),
                _buildDot(1),
                _buildDot(2),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDot(int index) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 600 + (index * 200)),
      curve: Curves.easeInOut,
      builder: (context, value, child) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 3),
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: Color.lerp(
              Colors.grey[300],
              const Color(0xFF6366F1),
              (1 + (index * 0.3)) * 0.5,
            ),
            shape: BoxShape.circle,
          ),
        );
      },
    );
  }
}

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;
  final bool isAiGenerated;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.isAiGenerated = false,
  });
}
