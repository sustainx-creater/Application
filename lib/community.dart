import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'theme.dart';

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
      'members': 1, // Creator is the first member
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
      appBar: AppBar(
        title: const Text('Community'),
        backgroundColor: emeraldGreen,
        foregroundColor: Colors.white,
      ),
      body: const CommunityPageContent(),
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
          SizedBox(height: 20),
          HeroSection(),
          SizedBox(height: 20),
          FeaturesSection(),
          SizedBox(height: 20),
          FAQsSection(),
          SizedBox(height: 20),
          RecentQuestionsSection(),
          SizedBox(height: 20),
          AskQuestionSection(),
          SizedBox(height: 20),
          ContactUsSection(),
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
    return const Text("👋 Welcome to the Community!");
  }
}

class HeroSection extends StatelessWidget {
  const HeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: mintGreen,
      child: const Text(
        "Explore groups, events, and meet people!",
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class FAQsSection extends StatelessWidget {
  const FAQsSection({super.key});

  final List<Map<String, String>> faqs = const [
    {
      'question': 'What is the Community page about?',
      'answer': 'The Community page connects people with shared interests through groups, events, and the Buddy System.'
    },
    {
      'question': 'How can I join a group?',
      'answer': 'Navigate to Interest Groups, select a group, and click "Join" to participate in the group chat.'
    },
    {
      'question': 'Is there a cost to use the Buddy System?',
      'answer': 'Yes, buddies charge a rate (e.g., €10/hour). You need to make a payment to connect.'
    },
    {
      'question': 'Can I create a private group?',
      'answer': 'Yes, when creating a group, you can toggle the "Private Group" option to make it private.'
    },
    {
      'question': 'How do I contact support?',
      'answer': 'Use the "Contact Us" section to send an email to our support team.'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '❓ Frequently Asked Questions',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 10),
        ...faqs.map((faq) => ExpansionTile(
              title: Text(
                faq['question']!,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(faq['answer']!),
                ),
              ],
            )),
      ],
    );
  }
}

class RecentQuestionsSection extends StatelessWidget {
  const RecentQuestionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text("📝 Recent questions will appear here.");
  }
}

class AskQuestionSection extends StatefulWidget {
  const AskQuestionSection({super.key});

  @override
  State<AskQuestionSection> createState() => _AskQuestionSectionState();
}

class _AskQuestionSectionState extends State<AskQuestionSection> {
  final TextEditingController _questionController = TextEditingController();
  final List<Map<String, dynamic>> _questions = [];
  final Map<int, TextEditingController> _answerControllers = {};

  void _submitQuestion() {
    if (_questionController.text.trim().isEmpty) return;
    setState(() {
      _questions.add({
        'question': _questionController.text.trim(),
        'answers': <String>[],
      });
      _questionController.clear();
    });
  }

  void _submitAnswer(int questionIndex) {
    final controller = _answerControllers[questionIndex];
    if (controller == null || controller.text.trim().isEmpty) return;
    setState(() {
      _questions[questionIndex]['answers'].add(controller.text.trim());
      controller.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '💬 Ask a Question',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _questionController,
                decoration: const InputDecoration(
                  hintText: 'Type your question...',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: _submitQuestion,
              style: ElevatedButton.styleFrom(
                backgroundColor: emeraldGreen,
                foregroundColor: Colors.white,
              ),
              child: const Icon(Icons.send),
            ),
          ],
        ),
        const SizedBox(height: 10),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _questions.length,
          itemBuilder: (context, index) {
            final question = _questions[index];
            _answerControllers[index] ??= TextEditingController();
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              child: ExpansionTile(
                title: Text(
                  question['question'],
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        ...question['answers'].map<Widget>((answer) => Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(Icons.comment, color: emeraldGreen, size: 20),
                                  const SizedBox(width: 8),
                                  Expanded(child: Text(answer)),
                                ],
                              ),
                            )),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _answerControllers[index],
                                decoration: const InputDecoration(
                                  hintText: 'Type your answer...',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton(
                              onPressed: () => _submitAnswer(index),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: emeraldGreen,
                                foregroundColor: Colors.white,
                              ),
                              child: const Icon(Icons.reply),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  @override
  void dispose() {
    _questionController.dispose();
    for (var controller in _answerControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }
}

class ContactUsSection extends StatelessWidget {
  const ContactUsSection({super.key});

  Future<void> _launchEmail() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'teamsustainx@gmail.com',
      queryParameters: {'subject': 'Community Page Inquiry'},
    );
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      // Handle error (e.g., show a snackbar)
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '📧 Contact Us',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 10),
        ElevatedButton.icon(
          onPressed: _launchEmail,
          icon: const Icon(Icons.email),
          label: const Text('Email Support'),
          style: ElevatedButton.styleFrom(
            backgroundColor: emeraldGreen,
            foregroundColor: Colors.white,
          ),
        ),
      ],
    );
  }
}

class FeaturesSection extends StatelessWidget {
  const FeaturesSection({super.key});

  Widget _buildCard(String title, IconData icon, BuildContext context, VoidCallback? onTapAction) {
    return Card(
      child: InkWell(
        onTap: onTapAction ?? () {},
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
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
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
              _buildCard('Buddy System', Icons.people_alt_outlined, context, () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const BuddySystemPage()),
                );
              }),
              _buildCard('Local Events', Icons.event_available_outlined, context, null),
              _buildCard('Interest Groups', Icons.interests_outlined, context, () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const InterestGroupsPage()),
                );
              }),
              _buildCard('Create Group', Icons.add_circle_outline, context, () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CreateGroupPage()),
                );
              }),
            ],
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
  final List<String> messages = [
    '👋 Welcome to group!',
    '📢 Admin: Please be respectful to everyone.',
    '📆 Upcoming event on Saturday, don’t miss it!'
  ];
  final TextEditingController _controller = TextEditingController();

  void _sendMessage() {
    if (_controller.text.trim().isEmpty) return;
    setState(() {
      messages.add(_controller.text.trim());
      _controller.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.groupName),
        backgroundColor: emeraldGreen,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12.0),
              itemCount: messages.length,
              itemBuilder: (context, index) => Align(
                alignment: index % 2 == 0 ? Alignment.centerLeft : Alignment.centerRight,
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: index % 2 == 0 ? mintGreen : emeraldGreen.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(messages[index], style: const TextStyle(color: Colors.black)),
                ),
              ),
            ),
          ),
          if (widget.openChat)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: const InputDecoration(
                        hintText: 'Type a message...',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _sendMessage,
                    child: const Icon(Icons.send),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
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
        backgroundColor: emeraldGreen,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Group Title'),
            ),
            DropdownButton<String>(
              value: groupType,
              isExpanded: true,
              onChanged: (value) => setState(() => groupType = value!),
              items: ['Entertainment', 'Education', 'Fashion', 'Other']
                  .map((type) => DropdownMenuItem(value: type, child: Text(type)))
                  .toList(),
            ),
            SwitchListTile(
              title: const Text('Private Group'),
              value: isPrivate,
              onChanged: (val) => setState(() => isPrivate = val),
            ),
            const SizedBox(height: 20),
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
        backgroundColor: emeraldGreen,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        itemCount: buddies.length,
        itemBuilder: (context, index) {
          final buddy = buddies[index];
          return Card(
            child: ListTile(
              leading: const Icon(Icons.person, color: emeraldGreen),
              title: Text(buddy['name']!),
              subtitle: Text('${buddy['profession']}\n${buddy['location']}\nRate: ${buddy['rate']}'),
              trailing: ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Connect with ${buddy['name']}'),
                      content: const Text('To connect, please make payment of €10/hour.'),
                      actions: [
                        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
                        ElevatedButton(onPressed: () {}, child: const Text('Pay & Connect')),
                      ],
                    ),
                  );
                },
                child: const Text('Request'),
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
        backgroundColor: emeraldGreen,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        itemCount: interestGroups.length,
        itemBuilder: (context, index) {
          final group = interestGroups[index];
          final groupName = group['name'] as String;
          final membersCount = group['members'] as int;
          final isAdmin = group['adminId'] == currentUserId;
          final isPrivate = group['isPrivate'] as bool;
          final groupType = group['type'] as String;

          return Card(
            child: ListTile(
              leading: const Icon(Icons.group, color: emeraldGreen),
              title: Row(
                children: [
                  Text(groupName),
                  if (isAdmin)
                    const Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Chip(
                        label: Text('Admin', style: TextStyle(fontSize: 12, color: Colors.white)),
                        backgroundColor: emeraldGreen,
                        padding: EdgeInsets.zero,
                      ),
                    ),
                ],
              ),
              subtitle: Text('Type: $groupType\nMembers: $membersCount${isPrivate ? '\nPrivate' : ''}'),
              trailing: isAdmin
                  ? PopupMenuButton<String>(
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
                  : ElevatedButton(
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
            ),
          );
        },
      ),
    );
  }
}