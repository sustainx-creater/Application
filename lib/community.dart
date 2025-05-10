import 'package:flutter/material.dart';
import 'theme.dart';

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
          SizedBox(height: 20),
          HeroSection(),
          SizedBox(height: 20),
          FeaturesSection(),
          SizedBox(height: 20),
          CommunityGroupsSection(),
          SizedBox(height: 20),
          FAQsSection(),
          SizedBox(height: 20),
          RecentQuestionsSection(),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}

class WelcomeSection extends StatelessWidget {
  const WelcomeSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: mintGreen.withOpacity(0.7),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome to the Community!',
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(color: darkGreen),
            ),
            const SizedBox(height: 10),
            Text(
              'Connect, share experiences, ask questions, and find support from fellow newcomers and locals.',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: darkSlateGray),
            ),
          ],
        ),
      ),
    );
  }
}

class HeroSection extends StatelessWidget {
  const HeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: emeraldGreen.withOpacity(0.15),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Helping You Settle In',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(color: darkSlateGray),
            ),
            const SizedBox(height: 8),
            Text(
              'Find local buddies, join groups based on interests or nationality, and attend community events.',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: darkSlateGray),
            ),
            const SizedBox(height: 15),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: warmGold,
                foregroundColor: darkSlateGray,
              ),
              onPressed: () {
                print("Community Get Started tapped");
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Group feature coming soon!')),
                );
              },
              icon: const Icon(Icons.groups_outlined, size: 20),
              label: const Text('Explore Groups'),
            ),
          ],
        ),
      ),
    );
  }
}

class FeaturesSection extends StatelessWidget {
  const FeaturesSection({super.key});

  Widget _buildCard(String title, IconData icon, BuildContext context,
      VoidCallback? onTapAction) {
    return Card(
      child: InkWell(
        onTap: onTapAction ??
            () {
              print("$title tapped - Action TBD");
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('$title feature coming soon!')),
              );
            },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: emeraldGreen),
              const SizedBox(height: 10),
              Text(
                title,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Community Features',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 15),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            children: [
              _buildCard(
                  'Buddy System', Icons.people_alt_outlined, context, null),
              _buildCard(
                  'Local Events', Icons.event_available_outlined, context, null),
              _buildCard(
                  'Interest Groups', Icons.interests_outlined, context, null),
              _buildCard(
                  'Get Support', Icons.support_agent_outlined, context, null),
            ],
          ),
        ],
      ),
    );
  }
}

class CommunityGroupsSection extends StatelessWidget {
  const CommunityGroupsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: mintGreen.withOpacity(0.7),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Featured Community Groups',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(color: darkGreen),
            ),
            const SizedBox(height: 15),
            Text(
              'Groups feature coming soon...',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: darkSlateGray),
            ),
            const SizedBox(height: 10),
            OutlinedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Groups feature coming soon!')),
                );
              },
              child: const Text("Browse All Groups"),
            ),
          ],
        ),
      ),
    );
  }
}

class FAQsSection extends StatelessWidget {
  const FAQsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: emeraldGreen.withOpacity(0.15),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Community FAQs',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(color: darkSlateGray),
            ),
            const SizedBox(height: 15),
            Text(
              'Frequently asked questions will appear here.',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: darkSlateGray),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('FAQs feature coming soon!')),
                );
              },
              child: const Text("View All FAQs"),
            ),
          ],
        ),
      ),
    );
  }
}

class RecentQuestionsSection extends StatelessWidget {
  const RecentQuestionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Recent Questions',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(color: darkSlateGray),
            ),
            const SizedBox(height: 15),
            ListTile(
              leading: Icon(Icons.help_outline, color: emeraldGreen),
              title: Text("How to find shared accommodation near city center?"),
              subtitle: Text("Asked by Alex - 2 hours ago"),
              trailing: Icon(Icons.chevron_right),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Question details view coming soon!')),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.help_outline, color: emeraldGreen),
              title: Text("Best way to get a local SIM card?"),
              subtitle: Text("Asked by Priya - 5 hours ago"),
              trailing: Icon(Icons.chevron_right),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Question details view coming soon!')),
                );
              },
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Viewing more questions coming soon!')),
                  );
                },
                child: const Text("See More Questions"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}