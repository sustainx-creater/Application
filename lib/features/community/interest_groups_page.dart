import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
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

          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: interestGroups.length,
            itemBuilder: (context, index) {
              final group = interestGroups[index];
              final groupName = group['name'] as String;
              final membersCount = group['members'] as int;
              final isAdmin = group['admin_id'] == supabase.auth.currentUser?.id;
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
                          onSelected: (value) async {
                            if (value == 'delete') {
                              await GroupManager.removeGroup(groupName);
                              _refreshGroups(); // Refresh after deleting group
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
          );
        },
      ),
    );
  }
}