import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'theme.dart';
import 'community_forum.dart';

// Simulated logged-in user ID
const String currentUserId = 'user123';

// Class to manage group storage
class GroupManager {
  static final List<Map<String, dynamic>> _groups = [
    {'name': 'Fitness Enthusiasts', 'members': 54, 'adminId': 'system', 'type': 'Fitness', 'isPrivate': false},
    {'name': 'Book Lovers', 'members': 38, 'adminId': 'system', 'type': 'Literature', 'isPrivate': false},
    {'name': 'Tech Geeks', 'members': 62, 'adminId': 'system', 'type': 'Technology', 'isPrivate': false},
    {'name': 'Travel Buddies', 'members': 41, 'adminId': 'system', 'type': 'Travel', 'isPrivate': false},
  ];

  static List<Map<String, dynamic>> getGroups() => _groups;

  static void addGroup(String name, String type, bool isPrivate, String adminId) {
    _groups.add({
      'name': name,
      'members': 1,
      'adminId': adminId,
      'type': type,
      'isPrivate': isPrivate,
    });
  }

  static void removeGroup(String name) {
    _groups.removeWhere((group) => group['name'] == name);
  }
}

void main() {
  runApp(const MaterialApp(
    home: CommunityPage(),
    debugShowCheckedModeBanner: false,
  ));
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
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 80),
          const WelcomeSection(),
          const SizedBox(height: 24),
          const FeaturesSection(),
          const SizedBox(height: 24),
          const InterestGroupsSection(),
          const SizedBox(height: 24),
          const ContactUsSection(),
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
            r"Welcome to Our Community!",
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
          childAspectRatio: 1.2,
          children: [
            _buildFeatureCard('Buddy System', Icons.people_alt_outlined, context, () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const BuddySystemPage()),
              );
            }),
            _buildFeatureCard('Local Events', Icons.event_available_outlined, context, null),
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
      ],
    );
  }
}

class InterestGroupsSection extends StatelessWidget {
  const InterestGroupsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final interestGroups = GroupManager.getGroups();

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
  }
}

class GroupCard extends StatelessWidget {
  final Map<String, dynamic> group;

  const GroupCard({super.key, required this.group});

  @override
  Widget build(BuildContext context) {
    final groupName = group['name'] as String;
    final membersCount = group['members'] as int;
    final isPrivate = group['isPrivate'] as bool;
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

  Future<void> _launchEmail(BuildContext context) async {
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
  }

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
            onPressed: () => _launchEmail(context),
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

class GroupChatPage extends StatefulWidget {
  final String groupName;
  final bool openChat;

  const GroupChatPage({super.key, required this.groupName, required this.openChat});

  @override
  State<GroupChatPage> createState() => _GroupChatPageState();
}

class _GroupChatPageState extends State<GroupChatPage> {
  final List<Map<String, String>> messages = [
    {'text': '👋 Welcome to group!', 'sender': 'system'},
    {'text': '📢 Admin: Please be respectful.', 'sender': 'admin'},
    {'text': '📆 Event on Saturday!', 'sender': 'admin'},
  ];
  final TextEditingController _controller = TextEditingController();

  void _sendMessage() {
    if (_controller.text.trim().isEmpty) return;
    setState(() {
      messages.add({'text': _controller.text.trim(), 'sender': currentUserId});
      _controller.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.groupName),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                final isMe = message['sender'] == currentUserId;
                return Align(
                  alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isMe ? emeraldGreen : lightGrey,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      message['text']!,
                      style: TextStyle(color: isMe ? whiteColor : darkSlateGray),
                    ),
                  ),
                );
              },
            ),
          ),
          if (widget.openChat)
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: whiteColor,
                boxShadow: [
                  BoxShadow(
                    color: darkSlateGray.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: 'Type a message...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: _sendMessage,
                    icon: const Icon(Icons.send, color: emeraldGreen),
                    style: IconButton.styleFrom(
                      backgroundColor: lightGrey,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class CreateGroupPage extends StatefulWidget {
  const CreateGroupPage({super.key});

  @override
  State<CreateGroupPage> createState() => _CreateGroupPageState();
}

class _CreateGroupPageState extends State<CreateGroupPage> {
  final TextEditingController _titleController = TextEditingController();
  String groupType = 'Entertainment';
  bool isPrivate = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Group'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Create a New Group',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Group Title',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: groupType,
              decoration: InputDecoration(
                labelText: 'Group Type',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              items: ['Entertainment', 'Education', 'Fashion', 'Other']
                  .map((type) => DropdownMenuItem(value: type, child: Text(type)))
                  .toList(),
              onChanged: (value) => setState(() => groupType = value!),
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Private Group'),
              value: isPrivate,
              onChanged: (val) => setState(() => isPrivate = val),
              activeColor: emeraldGreen,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                if (_titleController.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter a group title')),
                  );
                  return;
                }
                GroupManager.addGroup(
                  _titleController.text.trim(),
                  groupType,
                  isPrivate,
                  currentUserId,
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Group created!')),
                );
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('Create Group'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }
}

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
                  ElevatedButton(
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

class InterestGroupsPage extends StatelessWidget {
  const InterestGroupsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final interestGroups = GroupManager.getGroups();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Interest Groups'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CreateGroupPage()),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: interestGroups.length,
        itemBuilder: (context, index) {
          final group = interestGroups[index];
          final groupName = group['name'] as String;
          final membersCount = group['members'] as int;
          final isAdmin = group['adminId'] == currentUserId;
          final isPrivate = group['isPrivate'] as bool;
          final groupType = group['type'] as String;

          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: emeraldGreen,
                    child: Icon(Icons.group, color: whiteColor, size: 30),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              groupName,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            if (isAdmin)
                              const Padding(
                                padding: EdgeInsets.only(left: 8.0),
                                child: Chip(
                                  label: Text('Admin', style: TextStyle(fontSize: 12, color: whiteColor)),
                                  backgroundColor: emeraldGreen,
                                  padding: EdgeInsets.zero,
                                ),
                              ),
                          ],
                        ),
                        Text(
                          'Type: $groupType',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: mediumGrey),
                        ),
                        Text(
                          'Members: $membersCount${isPrivate ? ' • Private' : ''}',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: mediumGrey),
                        ),
                      ],
                    ),
                  ),
                  if (isAdmin)
                    PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == 'delete') {
                          GroupManager.removeGroup(groupName);
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => const InterestGroupsPage()),
                          );
                        } else if (value == 'manage') {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text('Manage Members: $groupName'),
                              content: const Text('Here you can add or remove members (placeholder).'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Close'),
                                ),
                              ],
                            ),
                          );
                        }
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: 'delete',
                          child: Text('Delete Group'),
                        ),
                        const PopupMenuItem(
                          value: 'manage',
                          child: Text('Manage Members'),
                        ),
                      ],
                    )
                  else
                    ElevatedButton(
                      onPressed: () {
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
                      child: const Text('Join'),
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