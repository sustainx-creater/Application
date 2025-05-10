import 'package:flutter/material.dart';

class DocumentationPage extends StatelessWidget {
  const DocumentationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Documentation'),
      ),
      body: const Center(child: Text('Welcome to Documentation')),
    );
  }
}