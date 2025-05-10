import 'dart:convert';
import 'package:http/http.dart' as http;

class ChatbotService {
  static const String supabaseUrl = 'https://amfomxmqoeyfuwkqlzyk.supabase.co';
  static const String supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImFtZm9teG1xb2V5ZnV3a3FsenlrIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDYwMDgyMDEsImV4cCI6MjA2MTU4NDIwMX0.erme360AeqVMShEVDXJadwZ0wJQP7Wb3-X_QRlsRsRk'; // Ensure this is Anon Public Key

  // Test network connectivity
  Future<void> testNetwork() async {
    try {
      print('Testing network connectivity...');
      final response = await http.get(
        Uri.parse('https://jsonplaceholder.typicode.com/posts'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(Duration(seconds: 5), onTimeout: () {
        throw Exception('Network test timed out');
      });
      print('Network Test Status: ${response.statusCode}, Body: ${response.body.substring(0, 100)}...');
    } catch (e) {
      print('Network Test Exception: $e');
    }
  }

  Future<List<double>> generateEmbedding(String query) async {
    final url = '$supabaseUrl/functions/v1/quick-worker';
    try {
      print('Attempting to fetch embedding from: $url');
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $supabaseAnonKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'text': query}),
      ).timeout(Duration(seconds: 10), onTimeout: () {
        throw Exception('Request timed out');
      });

      print('Embedding Response Status: ${response.statusCode}');
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['embedding'] != null) {
          print('Embedding received, length: ${data['embedding'].length}');
          return List<double>.from(data['embedding']);
        } else {
          print('No embedding in response: ${response.body}');
          throw Exception('No embedding in response: ${response.body}');
        }
      } else {
        print('Embedding Error: Status ${response.statusCode}, Body: ${response.body}');
        throw Exception('Failed to generate embedding: ${response.body}');
      }
    } catch (e) {
      print('Embedding Fetch Exception: $e');
      if (e.toString().contains('XMLHttpRequest')) {
        print('Possible CORS issue detected. Try running on a mobile device/emulator.');
      }
      rethrow;
    }
  }


  Future<Map<String, dynamic>> matchQA(List<double> embedding) async {
  final url = '$supabaseUrl/rest/v1/rpc/match_qa';
  try {
    print('Attempting to fetch match_qa from: $url');
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'apikey': supabaseAnonKey, // ✅ REQUIRED for Supabase RPCs
        'Authorization': 'Bearer $supabaseAnonKey',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'query_embedding': embedding,
        'match_threshold': 0.7,
        'match_count': 1,
      }),
    ).timeout(Duration(seconds: 10), onTimeout: () {
      throw Exception('Request timed out');
    });

    print('Match QA Response Status: ${response.statusCode}');
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data.isNotEmpty) {
        print('Match QA result: ${data[0]}');
        return data[0];
      } else {
        print('No matching Q&A found in response');
        throw Exception('No matching Q&A found');
      }
    } else {
      print('Match QA Error: Status ${response.statusCode}, Body: ${response.body}');
      throw Exception('Failed to call match_qa: ${response.body}');
    }
  } catch (e) {
    print('Match QA Fetch Exception: $e');
    if (e.toString().contains('XMLHttpRequest')) {
      print('Possible CORS issue detected. Try running on a mobile device/emulator.');
    }
    rethrow;
}

  }
}