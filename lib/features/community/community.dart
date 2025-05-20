import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../theme.dart';
import 'events_page.dart';
import 'buddy_system_page.dart';
import 'interest_groups_page.dart';
import 'community_forum.dart';
import 'group_chat_page.dart'; // Add this import

// Initialize Supabase client
final supabase = Supabase.instance.client;

// Class to manage group storage
class GroupManager {
  static Future<List<Map<String, dynamic>>> getGroups() async {
    final response = await supabase.from('groups').select();
    return response as List<Map<String, dynamic>>;
  }

  static Future<void> addGroup(String name, String type, bool isPrivate, String adminId) async {
    await supabase.from('groups').insert({
      'name': name,
      'members': 1,
      'admin_id': adminId,
      'type': type,
      'is_private': isPrivate,
    });
  }

  static Future<void> removeGroup(String name) async {
    await supabase.from('groups').delete().eq('name', name);
  }
}

class CommunityPage extends StatelessWidget {
  const CommunityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Community'),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: premiumGradient,
        ),
        child: const CommunityPageContent(),
      ),
    );
  }
}

class CommunityPageContent extends StatelessWidget {
  const CommunityPageContent({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          WelcomeSection(),
          SizedBox(height: 24),
          FeaturesSection(),
          SizedBox(height: 24),
          InterestGroupsSection(),
          SizedBox(height: 24),
          ContactUsSection(),
        ],
      ),
    );
  }
}

class WelcomeSection extends StatelessWidget {
  const WelcomeSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: whiteColor.withOpacity(0.9),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: darkSlateGray.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Welcome to Our Community! 👋',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'Connect with like-minded people, join groups, and explore events.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}

class FeaturesSection extends StatelessWidget {
  const FeaturesSection({super.key});

  Widget _buildFeatureCard(
      String title, IconData icon, BuildContext context, VoidCallback? onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: whiteColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: darkSlateGray.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: emeraldGreen),
            const SizedBox(height: 12),
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Explore Features',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 16),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.0, // Reduce aspect ratio for better fit
          children: [
            _buildFeatureCard('Buddy System', Icons.people_alt_outlined, context, () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const BuddySystemPage()),
              );
            }),
            _buildFeatureCard('Local Events', Icons.event_available_outlined, context, () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const EventsPage()),
              );
            }),
            _buildFeatureCard('Interest Groups', Icons.interests_outlined, context, () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const InterestGroupsPage()),
              );
            }),
            _buildFeatureCard('Community Forum', Icons.forum_outlined, context, () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CommunityForumPage()),
              );
            }),
          ],
        ),
        const SizedBox(height: 16), // Add space after grid
      ],
    );
  }
}

class InterestGroupsSection extends StatelessWidget {
  const InterestGroupsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: GroupManager.getGroups(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return const Center(child: Text('Error loading groups'));
        }
        final interestGroups = snapshot.data ?? [];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Interest Groups',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const InterestGroupsPage()),
                    );
                  },
                  child: const Text('View All'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: interestGroups.length,
                itemBuilder: (context, index) {
                  final group = interestGroups[index];
                  return Container(
                    width: 160,
                    margin: const EdgeInsets.only(right: 16),
                    child: GroupCard(group: group),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

class GroupCard extends StatelessWidget {
  final Map<String, dynamic> group;

  const GroupCard({super.key, required this.group});

  @override
  Widget build(BuildContext context) {
    final groupName = group['name'] as String;
    final membersCount = group['members'] as int;
    final isPrivate = group['is_private'] as bool;
    final groupType = group['type'] as String;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GroupChatPage(
              groupName: groupName,
              openChat: true,
            ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: whiteColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: darkSlateGray.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              groupName,
              style: Theme.of(context).textTheme.titleMedium,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Text(
              '$membersCount Members',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: mediumGrey),
            ),
            Text(
              groupType,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: mediumGrey),
            ),
            if (isPrivate)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Chip(
                  label: const Text('Private', style: TextStyle(fontSize: 12, color: whiteColor)),
                  backgroundColor: emeraldGreen,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class ContactUsSection extends StatelessWidget {
  const ContactUsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: whiteColor.withOpacity(0.9),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: darkSlateGray.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Get in Touch 📧',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: () async {
              final Uri emailUri = Uri(
                scheme: 'mailto',
                path: 'teamsustainx@gmail.com',
                queryParameters: {'subject': 'Community Page Inquiry'},
              );
              if (await canLaunchUrl(emailUri)) {
                await launchUrl(emailUri);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Could not launch email')),
                );
              }
            },
            icon: const Icon(Icons.email),
            label: const Text('Email Support'),
            style: ElevatedButton.styleFrom(
              backgroundColor: emeraldGreen,
              foregroundColor: whiteColor,
              minimumSize: const Size(double.infinity, 50),
            ),
          ),
        ],
      ),
    );
  }
}