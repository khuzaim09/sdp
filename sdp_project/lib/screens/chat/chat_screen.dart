import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:provider/provider.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import '../../core/theme.dart';
import '../../providers/language_provider.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, dynamic>> _messages = [
    {'text': 'Hello! I am your AI Marketing Assistant. How can I help you today?', 'isUser': false},
  ];
  
  late stt.SpeechToText _speech;
  bool _isListening = false;
  late FlutterTts _flutterTts;
  bool _isSpeaking = false;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _flutterTts = FlutterTts();
    _initTts();
  }

  void _initTts() async {
    await _flutterTts.setLanguage("en-US");
    await _flutterTts.setPitch(1.0);
    _flutterTts.setCompletionHandler(() {
      setState(() => _isSpeaking = false);
    });
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize();
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(onResult: (val) {
          setState(() {
            _controller.text = val.recognizedWords;
          });
        });
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  void _speak(String text) async {
    setState(() => _isSpeaking = true);
    await _flutterTts.speak(text);
  }

  void _sendMessage() async {
    if (_controller.text.isEmpty) return;

    final userText = _controller.text;
    setState(() {
      _messages.add({'text': userText, 'isUser': true});
      _controller.clear();
    });

    // Simulate AI thinking
    await Future.delayed(const Duration(seconds: 1));

    String aiResponse = "That's a great question about $userText! I recommend focusing on consistent content creation and using targeted ads to reach your audience.";
    
    setState(() {
      _messages.add({'text': aiResponse, 'isUser': false});
    });
    
    // Auto speak if wanted or provide button
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(
      builder: (context, langProvider, child) {
        final tr = langProvider.tr;

        return Scaffold(
          body: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    final msg = _messages[index];
                    return _buildChatBubble(msg['text'], msg['isUser']);
                  },
                ),
              ),
              _buildInputArea(tr),
            ],
          ),
        );
      },
    );
  }

  Widget _buildChatBubble(String text, bool isUser) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        decoration: BoxDecoration(
          color: isUser ? AppTheme.primaryColor : Theme.of(context).cardColor,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(20),
            topRight: const Radius.circular(20),
            bottomLeft: Radius.circular(isUser ? 20 : 0),
            bottomRight: Radius.circular(isUser ? 0 : 20),
          ),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 10)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              text,
              style: TextStyle(color: isUser ? Colors.white : Theme.of(context).textTheme.bodyLarge?.color),
            ),
            if (!isUser) ...[
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () => _speak(text),
                child: Icon(
                  Icons.volume_up,
                  size: 16,
                  color: _isSpeaking ? AppTheme.primaryColor : Theme.of(context).textTheme.bodySmall?.color,
                ),
              ),
            ],
          ],
        ),
      ).animate().fadeIn().slideX(begin: isUser ? 0.1 : -0.1),
    );
  }

  Widget _buildInputArea(String Function(String) tr) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 20, offset: const Offset(0, -5))],
      ),
      child: SafeArea(
        child: Row(
          children: [
            IconButton(
              icon: Icon(_isListening ? Icons.mic : Icons.mic_none, color: _isListening ? Colors.red : AppTheme.primaryColor),
              onPressed: _listen,
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: TextField(
                  controller: _controller,
                  decoration: const InputDecoration(
                    hintText: 'Ask anything...',
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: _sendMessage,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: AppTheme.primaryGradient,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.send, color: Colors.white, size: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
