import 'dart:convert';
import 'package:http/http.dart' as http;

class ChatbotService {
  final String apiUrl = 'http://localhost:5000/query'; // Matches your curl command

  // Map of casual phrases to responses
  final Map<String, String> _casualResponses = {
    r'^(hi|hello|hey)$': 'Hey there! How can I assist you today?',
    r'^(good morning|morning)$': 'Good morning! Ready to tackle your immigration questions?',
    r'^(good afternoon|afternoon)$': 'Good afternoon! What’s on your mind?',
    r'^(good evening|evening)$': 'Good evening! How can I help you tonight?',
    r'^(thanks|thank you|ty)$': 'You’re very welcome!',
    r'^(bye|goodbye|see you)$': 'Catch you later! Have a great day!',
    r'^(ok|okay)$': 'Alright, what’s next?',
    r'^(how are you|you okay)$': 'I’m doing great, thanks for asking! How about you?',
  };

  // Check if query matches a casual phrase and return response
  String? handleCasualQuery(String query) {
    query = query.toLowerCase().trim();
    for (var pattern in _casualResponses.keys) {
      if (RegExp(pattern, caseSensitive: false).hasMatch(query)) {
        return _casualResponses[pattern];
      }
    }
    return null;
  }

  // Test network connectivity
  Future<void> testNetwork() async {
    try {
      print('Testing network connectivity...');
      final response = await http.get(
        Uri.parse('https://jsonplaceholder.typicode.com/posts'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: 5), onTimeout: () {
        throw Exception('Network test timed out');
      });
      print('Network Test Status: ${response.statusCode}, Body: ${response.body.substring(0, 100)}...');
    } catch (e) {
      print('Network Test Exception: $e');
    }
  }

  // Send query to Flask server
  Future<Map<String, dynamic>> sendQuery(String query) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'question': query}),
      ).timeout(const Duration(seconds: 10), onTimeout: () {
        throw Exception('Request timed out');
      });

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        print('Flask Response: $result');
        return result;
      } else {
        throw Exception('Failed to get response: ${response.statusCode}');
      }
    } catch (e) {
      print('Query Exception: $e');
      throw Exception('Error communicating with server: $e');
    }
  }
}