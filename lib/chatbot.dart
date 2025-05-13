import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'chatbot_service.dart'; // Adjust path if needed
import 'theme.dart';

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
    // Add greeting on startup
    _messages.add({
      'sender': 'bot',
      'text': 'Hi! I’m here to help with immigration questions. Ask away!'
    });
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
      // Check for casual query first
      final casualResponse = service.handleCasualQuery(query);
      if (casualResponse != null) {
        setState(() {
          _messages.add({
            'sender': 'bot',
            'text': casualResponse,
          });
        });
      } else {
        // Send query to Flask server
        final result = await service.sendQuery(query);
        final similarity = result['similarity'] as double;
        if (similarity >= 0.7) {
          setState(() {
            _messages.add({
              'sender': 'bot',
              'text': result['response'],
            });
          });
        } else {
          setState(() {
            _messages.add({
              'sender': 'bot',
              'text': 'Sorry, I’m not sure about that. Could you ask about visas, work, housing, or Irish culture?',
            });
          });
        }
      }
    } catch (e) {
      const errorMessage = 'Sorry, I don’t have an answer for this question. '
          'Please rephrase or contact teamsustainx+queries@gmail.com. '
          'We’ll be happy to help and reply as soon as possible.';
      setState(() {
        _messages.add({'sender': 'bot', 'text': errorMessage});
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'EZMove Chatbot',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: darkSlateGray,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: darkSlateGray),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: _messages.length + (_isLoading ? 1 : 0),
              itemBuilder: (context, index) {
                if (_isLoading && index == _messages.length) {
                  return Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                        'Typing...',
                        style: GoogleFonts.poppins(
                          color: darkSlateGray.withValues(alpha: 0.6),
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  );
                }
                final message = _messages[index];
                final isUser = message['sender'] == 'user';
                return Align(
                  alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4.0),
                    padding: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      color: isUser ? emeraldGreen : Colors.grey[200],
                      borderRadius: BorderRadius.circular(12.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      message['text']!,
                      style: GoogleFonts.poppins(
                        color: isUser ? whiteColor : darkSlateGray,
                        fontSize: 16,
                      ),
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
                    decoration: InputDecoration(
                      hintText: 'Ask about immigration...',
                      hintStyle: GoogleFonts.poppins(
                        color: darkSlateGray.withValues(alpha: 0.6),
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    style: GoogleFonts.poppins(color: darkSlateGray),
                    onSubmitted: (_) => _askQuestion(),
                  ),
                ),
                const SizedBox(width: 8),
                FloatingActionButton(
                  onPressed: _isLoading ? null : _askQuestion,
                  backgroundColor: warmGold,
                  mini: true,
                  child: Icon(
                    _isLoading ? Icons.hourglass_empty : Icons.send,
                    color: darkSlateGray,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}