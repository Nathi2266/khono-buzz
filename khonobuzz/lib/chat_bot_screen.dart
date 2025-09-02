import 'package:flutter/material.dart';
import 'package:firebase_ai/firebase_ai.dart'; // Import firebase_ai

class ChatMessage {
  final String text;
  final bool isUser;

  ChatMessage({required this.text, required this.isUser});
}

class ChatBotScreen extends StatefulWidget {
  final GenerativeModel geminiModel; // Add this line back

  const ChatBotScreen({super.key, required this.geminiModel}); // Fix constructor

  @override
  ChatBotScreenState createState() => ChatBotScreenState(); // Fix state class name
}

class ChatBotScreenState extends State<ChatBotScreen> with SingleTickerProviderStateMixin {
  final TextEditingController _textController = TextEditingController();
  final List<ChatMessage> _messages = []; // Ensure this is List<ChatMessage>

  static const String _greetingMessagePart1 = 'Hello! I\'m Khonobot, your personal assistant.';
  static const String _greetingMessagePart2 = 'How can I help you today?';

  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(-1.0, 0.0), // Start from left
      end: Offset.zero, // End at original position
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    // Add the greeting messages with staggered animation
    Future.delayed(const Duration(milliseconds: 200), () {
      setState(() {
        _messages.add(ChatMessage(text: _greetingMessagePart1, isUser: false));
      });
      _animationController.forward();
    });

    Future.delayed(const Duration(milliseconds: 1000), () {
      setState(() {
        _messages.add(ChatMessage(text: _greetingMessagePart2, isUser: false));
      });
    });
  }

  void _handleSubmitted(String text) {
    if (text.isEmpty) return;
    _textController.clear();
    setState(() {
      _messages.add(ChatMessage(text: text, isUser: true));
    });
    _generateGeminiResponse(text);
  }

  Future<void> _generateGeminiResponse(String userMessage) async {
    String botResponse = 'Khonobot is thinking...'; // Updated placeholder
    setState(() {
      _messages.add(ChatMessage(text: botResponse, isUser: false));
    });

    try {
      final response = await widget.geminiModel.generateContent([Content.text(userMessage)]);
      botResponse = response.text ?? 'No response from Khonobot.'; // Updated error message
    } catch (e) {
      botResponse = 'Khonobot encountered an error: $e'; // Updated error message
    }

    setState(() {
      _messages[_messages.length - 1] = ChatMessage(text: botResponse, isUser: false);
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    _animationController.dispose(); // Dispose the animation controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Khonobot',
          style: TextStyle(color: Colors.white), // Set title text color to white
        ), // Updated title
        centerTitle: true,
        backgroundColor: Colors.transparent, // Make app bar transparent
        elevation: 0, // Remove app bar shadow
        iconTheme: const IconThemeData(color: Colors.white), // Set back button color to white
      ),
      extendBodyBehindAppBar: true, // Extend body behind app bar
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/002 1.png', // Background image
              fit: BoxFit.cover,
            ),
          ),
          Column(
            children: <Widget>[
              // Chat messages list
              Flexible(
                child: ListView.builder(
                  padding: const EdgeInsets.all(8.0),
                  reverse: true, // New messages appear at the bottom
                  itemCount: _messages.length,
                  itemBuilder: (_, int index) {
                    final chatMessage = _messages[_messages.length - 1 - index];
                    // Apply animation only to the greeting messages
                    if (!chatMessage.isUser && (chatMessage.text == _greetingMessagePart1 || chatMessage.text == _greetingMessagePart2)) {
                      return SlideTransition(
                        key: ValueKey(chatMessage.text), // Add a unique key for the animation
                        position: _slideAnimation,
                        child: _buildMessage(chatMessage),
                      );
                    } else {
                      return _buildMessage(chatMessage);
                    }
                  },
                ),
              ),
              Container( // Replaced ClipRect and BackdropFilter with a solid Container
                decoration: BoxDecoration(color: Color.fromARGB((255 * 0.7).round(), 0xE9, 0x1E, 0x63)), // Red color with opacity for input
                child: _buildTextComposer(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMessage(ChatMessage message) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        mainAxisAlignment: message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12.0),
            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
            decoration: BoxDecoration(
              color: message.isUser ? const Color(0xFFe91e63) : Colors.grey[300], // Apply red color for user, grey for bot
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(15.0),
                topRight: const Radius.circular(15.0),
                bottomLeft: message.isUser ? const Radius.circular(15.0) : const Radius.circular(0),
                bottomRight: message.isUser ? const Radius.circular(0) : const Radius.circular(15.0),
              ),
            ),
            child: Text(
              message.text,
              style: TextStyle(
                color: message.isUser ? Colors.white : Colors.black87, // White text for user, black for bot
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextComposer() {
    return IconTheme(
      data: const IconThemeData(color: Colors.white), // Set icon color to white
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: <Widget>[
            Flexible(
              child: TextField(
                controller: _textController,
                onSubmitted: _handleSubmitted,
                style: const TextStyle(color: Colors.white), // Set input text color to white
                decoration: InputDecoration.collapsed(
                  hintText: 'Send a message...',
                  hintStyle: TextStyle(color: Color.fromARGB((255 * 0.7).round(), 255, 255, 255)), // Set hint text color to white with opacity
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.send),
              onPressed: () => _handleSubmitted(_textController.text),
            ),
          ],
        ),
      ),
    );
  }
}

// To use this screen, you would navigate to it from your app's main flow.
// Example:
//
// ElevatedButton(
//   onPressed: () {
//     Navigator.push(
//       context,
//       MaterialPageRoute(builder: (context) => const ChatBotScreen()),
//     );
//   },
//   child: const Text('Open Chatbot'),
// );