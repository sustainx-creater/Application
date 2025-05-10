
import 'package:flutter/material.dart';
import 'chatbot_service.dart'; // Adjust path if needed

class ChatbotPageContent extends StatefulWidget {
  const ChatbotPageContent({super.key});

  @override
  _ChatbotPageContentState createState() => _ChatbotPageContentState();
}

class _ChatbotPageContentState extends State<ChatbotPageContent> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Test network on startup
    ChatbotService().testNetwork();
  }

  Future<void> _askQuestion() async {
    final query = _controller.text.trim();
    if (query.isEmpty) {
      return;
    }

    setState(() {
      _messages.add({'sender': 'user', 'text': query});
      _isLoading = true;
    });
    _controller.clear();

    try {
      final service = ChatbotService();
      // Generate embedding
      final embedding = await service.generateEmbedding(query);
      // Get matching Q&A
      final result = await service.matchQA(embedding);
      setState(() {
        _messages.add({'sender': 'bot', 'text': result['answer']});
      });
    } catch (e) {
      setState(() {
        _messages.add({'sender': 'bot', 'text': 'Error: $e'});
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: _messages.length,
            itemBuilder: (context, index) {
              final message = _messages[index];
              final isUser = message['sender'] == 'user';
              return Align(
                alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 4.0),
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    color: isUser ? Colors.blue[100] : Colors.grey[200],
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Text(
                    message['text']!,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  decoration: const InputDecoration(
                    hintText: 'Ask about immigration...',
                    border: OutlineInputBorder(),
                  ),
                  onSubmitted: (_) => _askQuestion(),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: _isLoading ? null : _askQuestion,
                icon: Icon(_isLoading ? Icons.hourglass_empty : Icons.send),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
