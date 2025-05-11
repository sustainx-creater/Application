import 'dart:convert';
import 'package:http/http.dart' as http;

class ChatbotService {
  static const String supabaseUrl = 'https://amfomxmqoeyfuwkqlzyk.supabase.co';
  static const String supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImFtZm9teG1xb2V5ZnV3a3FsenlrIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDYwMDgyMDEsImV4cCI6MjA2MTU4NDIwMX0.erme360AeqVMShEVDXJadwZ0wJQP7Wb3-X_QRlsRsRk';

  // Normalize query for better matching
  String preprocessQuery(String query) {
    query = query.toLowerCase().trim();
    // Remove punctuation
    query = query.replaceAll(RegExp(r'[^\w\s]'), '');
    // Synonym mapping based on Supabase data
    Map<String, String> synonyms = {
      'visa': 'visa',
      'permit': 'visa',
      'required': 'need',
      'mandatory': 'need',
      'work': 'employment',
      'study': 'study',
      'retire': 'retirement',
      'invest': 'investor',
      'job': 'employment',
      'family': 'family reunification',
      'need': 'required',
      'can': 'able',
    };
    List<String> words = query.split(' ');
    query = words.map((word) => synonyms[word] ?? word).join(' ');
    return query;
  }

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

  Future<List<double>> generateEmbedding(String query) async {
    query = preprocessQuery(query); // Preprocess query
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
      ).timeout(const Duration(seconds: 10), onTimeout: () {
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
          'apikey': supabaseAnonKey,
          'Authorization': 'Bearer $supabaseAnonKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'query_embedding': embedding,
          'match_threshold': 0.6, // Lowered for flexibility
          'match_count': 3, // Get up to 3 matches
        }),
      ).timeout(const Duration(seconds: 10), onTimeout: () {
        throw Exception('Request timed out');
      });

      print('Match QA Response Status: ${response.statusCode}');
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data.isNotEmpty) {
          // Select the best match (highest similarity)
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