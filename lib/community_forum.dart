import 'package:flutter/material.dart';
import 'theme.dart';

// Simulated logged-in user ID
const String currentUserId = 'user123';

// Simulated forum posts data
class ForumManager {
  static final List<Map<String, dynamic>> _posts = [
    {
      'id': '1',
      'userId': 'user1',
      'username': 'TechGuru',
      'title': 'Best IDE for Flutter Development?',
      'content': 'Looking for recommendations on the best IDE for Flutter. Currently using VS Code but wondering if there are better options out there.',
      'timestamp': DateTime.now().subtract(const Duration(days: 1)),
      'upvotes': 25,
      'downvotes': 2,
      'replies': [
        {
          'id': '1.1',
          'userId': 'user2',
          'username': 'CodeNinja',
          'content': 'VS Code is solid, but try IntelliJ IDEA for advanced features like better refactoring tools.',
          'timestamp': DateTime.now().subtract(const Duration(hours: 12)),
          'upvotes': 10,
          'downvotes': 0,
        },
        {
          'id': '1.2',
          'userId': 'user3',
          'username': 'FlutterFan',
          'content': 'Stick with VS Code. The Flutter and Dart plugins are top-notch!',
          'timestamp': DateTime.now().subtract(const Duration(hours: 10)),
          'upvotes': 8,
          'downvotes': 1,
        },
      ],
    },
    {
      'id': '2',
      'userId': 'user4',
      'username': 'DesignPro',
      'title': 'Tips for Creating a Premium UI in Flutter',
      'content': 'Any tips or resources for designing a modern, premium-looking UI in Flutter? Looking for inspiration and best practices.',
      'timestamp': DateTime.now().subtract(const Duration(hours: 5)),
      'upvotes': 15,
      'downvotes': 0,
      'replies': [],
    },
  ];

  static List<Map<String, dynamic>> getPosts() => _posts;

  static void addPost(String title, String content, String userId, String username) {
    _posts.add({
      'id': '${_posts.length + 1}',
      'userId': userId,
      'username': username,
      'title': title,
      'content': content,
      'timestamp': DateTime.now(),
      'upvotes': 0,
      'downvotes': 0,
      'replies': [],
    });
  }

  static void addReply(String postId, String content, String userId, String username) {
    final post = _posts.firstWhere((p) => p['id'] == postId);
    post['replies'].add({
      'id': '$postId.${post['replies'].length + 1}',
      'userId': userId,
      'username': username,
      'content': content,
      'timestamp': DateTime.now(),
      'upvotes': 0,
      'downvotes': 0,
    });
  }

  static void upvotePost(String postId, String userId) {
    final post = _posts.firstWhere((p) => p['id'] == postId);
    post['upvotes'] = (post['upvotes'] as int) + 1;
  }

  static void downvotePost(String postId, String userId) {
    final post = _posts.firstWhere((p) => p['id'] == postId);
    post['downvotes'] = (post['downvotes'] as int) + 1;
  }

  static void upvoteReply(String postId, String replyId, String userId) {
    final post = _posts.firstWhere((p) => p['id'] == postId);
    final reply = post['replies'].firstWhere((r) => r['id'] == replyId);
    reply['upvotes'] = (reply['upvotes'] as int) + 1;
  }

  static void downvoteReply(String postId, String replyId, String userId) {
    final post = _posts.firstWhere((p) => p['id'] == postId);
    final reply = post['replies'].firstWhere((r) => r['id'] == replyId);
    reply['downvotes'] = (reply['downvotes'] as int) + 1;
  }
}

class CommunityForumPage extends StatelessWidget {
  const CommunityForumPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Community Forum'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CreatePostPage()),
              );
            },
          ),
        ],
      ),
      body: Container(
        color: whiteColor,
        child: ForumPostsList(),
      ),
    );
  }
}

class ForumPostsList extends StatelessWidget {
  const ForumPostsList({super.key});

  @override
  Widget build(BuildContext context) {
    final posts = ForumManager.getPosts();

    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: posts.length,
      itemBuilder: (context, index) {
        final post = posts[index];
        return PostCard(post: post);
      },
    );
  }
}

class PostCard extends StatelessWidget {
  final Map<String, dynamic> post;

  const PostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    final timestamp = post['timestamp'] as DateTime;
    final timeAgo = _formatTimeAgo(timestamp);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: emeraldGreen,
                  child: Text(
                    post['username'][0],
                    style: const TextStyle(color: whiteColor),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post['username'],
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        timeAgo,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: mediumGrey),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              post['title'],
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              post['content'],
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_upward, color: emeraldGreen),
                  onPressed: () {
                    ForumManager.upvotePost(post['id'], currentUserId);
                    (context as Element).markNeedsBuild();
                  },
                ),
                Text(
                  '${post['upvotes'] - post['downvotes']}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_downward, color: mediumGrey),
                  onPressed: () {
                    ForumManager.downvotePost(post['id'], currentUserId);
                    (context as Element).markNeedsBuild();
                  },
                ),
                const Spacer(),
                TextButton.icon(
                  icon: const Icon(Icons.comment, color: emeraldGreen),
                  label: Text(
                    '${post['replies'].length} Replies',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: emeraldGreen),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PostDetailPage(post: post),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatTimeAgo(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}

class PostDetailPage extends StatelessWidget {
  final Map<String, dynamic> post;

  const PostDetailPage({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Post Details'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PostCard(post: post),
              const SizedBox(height: 16),
              Text(
                'Replies',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 12),
              ...post['replies'].map<Widget>((reply) => ReplyCard(postId: post['id'], reply: reply)).toList(),
              const SizedBox(height: 16),
              CreateReplyWidget(postId: post['id']),
            ],
          ),
        ),
      ),
    );
  }
}

class ReplyCard extends StatelessWidget {
  final String postId;
  final Map<String, dynamic> reply;

  const ReplyCard({super.key, required this.postId, required this.reply});

  @override
  Widget build(BuildContext context) {
    final timestamp = reply['timestamp'] as DateTime;
    final timeAgo = _formatTimeAgo(timestamp);

    return Container(
      margin: const EdgeInsets.only(left: 16, bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: lightGrey.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: emeraldGreen,
                child: Text(
                  reply['username'][0],
                  style: const TextStyle(color: whiteColor, fontSize: 12),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      reply['username'],
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 16),
                    ),
                    Text(
                      timeAgo,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: mediumGrey),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            reply['content'],
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_upward, color: emeraldGreen, size: 20),
                onPressed: () {
                  ForumManager.upvoteReply(postId, reply['id'], currentUserId);
                  (context as Element).markNeedsBuild();
                },
              ),
              Text(
                '${reply['upvotes'] - reply['downvotes']}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              IconButton(
                icon: const Icon(Icons.arrow_downward, color: mediumGrey, size: 20),
                onPressed: () {
                  ForumManager.downvoteReply(postId, reply['id'], currentUserId);
                  (context as Element).markNeedsBuild();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatTimeAgo(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}

class CreateReplyWidget extends StatefulWidget {
  final String postId;

  const CreateReplyWidget({super.key, required this.postId});

  @override
  State<CreateReplyWidget> createState() => _CreateReplyWidgetState();
}

class _CreateReplyWidgetState extends State<CreateReplyWidget> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: darkSlateGray.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Add a Reply',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _controller,
            maxLines: 4,
            decoration: InputDecoration(
              hintText: 'Type your reply...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              onPressed: () {
                if (_controller.text.trim().isEmpty) return;
                ForumManager.addReply(
                  widget.postId,
                  _controller.text.trim(),
                  currentUserId,
                  'CurrentUser', // Replace with actual username
                );
                _controller.clear();
                setState(() {});
              },
              child: const Text('Post Reply'),
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

class CreatePostPage extends StatefulWidget {
  const CreatePostPage({super.key});

  @override
  State<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Post'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Create a New Post',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Post Title',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _contentController,
              maxLines: 6,
              decoration: InputDecoration(
                labelText: 'Post Content',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                if (_titleController.text.trim().isEmpty || _contentController.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please fill in all fields')),
                  );
                  return;
                }
                ForumManager.addPost(
                  _titleController.text.trim(),
                  _contentController.text.trim(),
                  currentUserId,
                  'CurrentUser', // Replace with actual username
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Post created!')),
                );
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('Create Post'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }
}