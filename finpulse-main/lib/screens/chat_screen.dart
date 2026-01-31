import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:permission_handler/permission_handler.dart';
import '../services/gemini_service.dart';

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
    // Build context with spending data
    final prompt = '''
You are FinPulse AI, a friendly personal finance assistant. The user is asking about their spending.

User query: "$query"

Respond in a helpful, conversational way. If the query is about spending:
- Provide specific amounts when possible
- Give insights and suggestions
- Use emojis sparingly for friendliness
- Keep responses concise but informative

If you don't have actual data, provide a helpful example response that shows what the answer would look like if you had the data.

Example response format for spending queries:
"You spent ₹3,240 on Food this week 🍔

Top spending:
• Zomato: ₹1,200 (3 orders)
• Swiggy: ₹890 (2 orders)
• Starbucks: ₹450 (2 visits)

💡 Tip: Your food spending is 15% higher than last week. Consider setting a weekly budget!"
''';

    try {
      // Use generateContent for chat queries
      final result = await GeminiService.instance.generateContent(prompt);
      
      if (result != null && result.isNotEmpty) {
        return result;
      }
      
      // Fallback to mock response
      return await _generateChatResponse(query);
    } catch (e) {
      return _generateChatResponse(query);
    }
  }

  Future<String> _generateChatResponse(String query) async {
    // Simplified response generation
    final lowerQuery = query.toLowerCase();
    
    if (lowerQuery.contains('food') || lowerQuery.contains('eat')) {
      return "📊 **Food Spending This Week**\n\nYou spent ₹3,240 on Food & Drinks\n\n**Top Merchants:**\n• Zomato: ₹1,200\n• Swiggy: ₹890\n• Starbucks: ₹450\n\n💡 *Tip: That's 15% more than last week!*";
    } else if (lowerQuery.contains('transport') || lowerQuery.contains('uber') || lowerQuery.contains('ola')) {
      return "🚗 **Transport Spending**\n\nYou spent ₹1,850 on Transport this month\n\n**Breakdown:**\n• Uber: ₹980\n• Ola: ₹620\n• Metro: ₹250\n\n💡 *Insight: Weekday rides are 40% of your transport budget*";
    } else if (lowerQuery.contains('biggest') || lowerQuery.contains('top') || lowerQuery.contains('most')) {
      return "💰 **Your Biggest Expenses This Month**\n\n1. Rent: ₹15,000\n2. Groceries: ₹5,200\n3. Food Delivery: ₹4,100\n4. Shopping: ₹3,800\n5. Transport: ₹1,850\n\n📈 *Total: ₹29,950*";
    } else if (lowerQuery.contains('trend') || lowerQuery.contains('chart') || lowerQuery.contains('graph')) {
      return "📈 **Spending Trends**\n\nYour spending pattern this month:\n\n• Week 1: ₹7,200\n• Week 2: ₹8,500 (+18%)\n• Week 3: ₹6,900 (-19%)\n• Week 4: ₹7,350\n\n💡 *You tend to spend more mid-month. Try spreading purchases evenly!*";
    } else if (lowerQuery.contains('budget') || lowerQuery.contains('limit') || lowerQuery.contains('set')) {
      return "✅ **Budget Settings**\n\nI can help you set budgets! Just say:\n\n• \"Set ₹5,000 budget for Food\"\n• \"Limit Shopping to ₹3,000 this month\"\n• \"Alert me when Transport exceeds ₹2,000\"\n\nWhat would you like to set?";
    } else if (lowerQuery.contains('hello') || lowerQuery.contains('hi') || lowerQuery.contains('hey')) {
      return "Hey there! 👋\n\nI'm your FinPulse AI assistant. I can help you:\n\n• Track spending by category\n• Find your biggest expenses\n• Show spending trends\n• Set budgets and alerts\n\nWhat would you like to know?";
    } else if (lowerQuery.contains('save') || lowerQuery.contains('saving')) {
      return "💵 **Saving Opportunities**\n\nBased on your spending, here's how you could save ₹3,500/month:\n\n• 🍔 Cook 2 more meals at home: ₹1,200\n• 🚗 Use metro for short trips: ₹800\n• ☕ Reduce coffee shop visits: ₹600\n• 📦 Cancel unused subscriptions: ₹900\n\n*Small changes, big impact!*";
    } else {
      return "I'd be happy to help with that! 🤔\n\nHere are some things I can tell you:\n\n• \"How much did I spend on [category]?\"\n• \"What's my biggest expense?\"\n• \"Show my spending trends\"\n• \"Help me save money\"\n\nTry asking one of these!";
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
              child: Text(
                message.text,
                style: TextStyle(
                  color: isUser ? Colors.white : Colors.black87,
                  fontSize: 15,
                  height: 1.5,
                ),
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

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
  });
}
