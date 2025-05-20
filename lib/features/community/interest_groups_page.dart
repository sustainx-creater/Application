import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme.dart';
import 'group_chat_page.dart';
import 'create_group_page.dart';
import 'community.dart'; // Import GroupManager

class InterestGroupsPage extends StatefulWidget {
  const InterestGroupsPage({super.key});

  @override
  State<InterestGroupsPage> createState() => _InterestGroupsPageState();
}

class _InterestGroupsPageState extends State<InterestGroupsPage> {
  late Future<List<Map<String, dynamic>>> _groupsFuture;
  final supabase = Supabase.instance.client;

  @override
  void initState() {
    super.initState();
    _groupsFuture = GroupManager.getGroups();
  }

  void _refreshGroups() {
    setState(() {
      _groupsFuture = GroupManager.getGroups();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Interest Groups'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CreateGroupPage()),
              );
              _refreshGroups(); // Refresh after returning from create group
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _groupsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Error loading groups'));
          }
          final interestGroups = snapshot.data ?? [];
          final userId = supabase.auth.currentUser?.id;
          final joinedGroups = interestGroups.where((g) => (g['membersList'] ?? []).contains(userId)).toList();
          final otherGroups = interestGroups.where((g) => !(g['membersList'] ?? []).contains(userId)).toList();

          Widget buildGroupCard(Map<String, dynamic> group, {bool joined = false, bool isAdmin = false}) {
            final groupName = group['name'] as String;
            final membersCount = group['members'] as int;
            final isPrivate = group['is_private'] as bool;
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
                          Text(
                            groupName,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          if (isAdmin)
                            Padding(
                              padding: const EdgeInsets.only(top: 2.0),
                              child: Text('Admin', style: TextStyle(fontSize: 11, color: emeraldGreen, fontWeight: FontWeight.w600)),
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
                    if (!joined)
                      TextButton(
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
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          textStyle: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600),
                        ),
                        child: const Text('Join'),
                      ),
                  ],
                ),
              ),
            );
          }

          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              if (joinedGroups.isNotEmpty) ...[
                Text('Groups You Joined', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                ...joinedGroups.map((g) => buildGroupCard(g, joined: true, isAdmin: g['admin_id'] == userId)),
                const SizedBox(height: 24),
              ],
              if (otherGroups.isNotEmpty) ...[
                Text('Other Groups', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                ...otherGroups.map((g) => buildGroupCard(g, joined: false, isAdmin: g['admin_id'] == userId)),
              ],
            ],
          );
        },
      ),
    );
  }
}