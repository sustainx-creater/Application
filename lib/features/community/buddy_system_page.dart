import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme.dart';

class BuddySystemPage extends StatelessWidget {
  const BuddySystemPage({super.key});

  @override
  Widget build(BuildContext context) {
    final buddies = List.generate(3, (index) => {
          'name': 'Buddy ${index + 1}',
          'location': 'Dublin, Ireland',
          'profession': 'IT Professional',
          'rate': '€10/hour'
        });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Buddy System'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: buddies.length,
        itemBuilder: (context, index) {
          final buddy = buddies[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: emeraldGreen,
                    child: Icon(Icons.person, color: whiteColor, size: 30),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          buddy['name']!,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        Text(
                          buddy['profession']!,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: mediumGrey),
                        ),
                        Text(
                          buddy['location']!,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: mediumGrey),
                        ),
                        Text(
                          'Rate: ${buddy['rate']}',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: emeraldGreen),
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('Connect with ${buddy['name']}'),
                          content: const Text('To connect, please make payment of €10/hour.'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Cancel'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Payment initiated!')),
                                );
                              },
                              child: const Text('Pay & Connect'),
                            ),
                          ],
                        ),
                      );
                    },
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      textStyle: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600),
                    ),
                    child: const Text('Request'),
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