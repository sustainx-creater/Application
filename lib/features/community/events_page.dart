import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme.dart';

class EventsPage extends StatelessWidget {
  const EventsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final events = List.generate(3, (index) => {
          'title': 'Event ${index + 1}',
          'date': 'May ${20 + index}, 2025',
          'location': 'Dublin, Ireland',
          'description': 'A fun community event to connect with others.'
        });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Local Events'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: events.length,
        itemBuilder: (context, index) {
          final event = events[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event['title']!,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Date: ${event['date']}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: mediumGrey),
                  ),
                  Text(
                    'Location: ${event['location']}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: mediumGrey),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    event['description']!,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Registering for event...')),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: emeraldGreen,
                      foregroundColor: whiteColor,
                    ),
                    child: const Text('Register'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}