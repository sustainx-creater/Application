import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../main.dart';

// Manages forum posts and replies with Supabase
class ForumManager {
  // Fetch all posts with their replies
  static Future<List<Map<String, dynamic>>> getPosts() async {
    try {
      final response = await supabase
          .from('posts')
          .select('id, user_id, username, title, content, upvotes, downvotes, created_at, replies (id, user_id, username, content, upvotes, downvotes, created_at)')
          .order('created_at', ascending: false);
      return response as List<Map<String, dynamic>>;
    } catch (e) {
      throw Exception('Failed to fetch posts: $e');
    }
  }

  // Add a new post
  static Future<void> addPost(String title, String content, String userId, String username) async {
    try {
      await supabase.from('posts').insert({
        'user_id': userId,
        'username': username,
        'title': title,
        'content': content,
        'upvotes': 0,
        'downvotes': 0,
      });
    } catch (e) {
      throw Exception('Failed to add post: $e');
    }
  }

  // Add a reply to a post
  static Future<void> addReply(String postId, String content, String userId, String username) async {
    try {
      await supabase.from('replies').insert({
        'post_id': postId,
        'user_id': userId,
        'username': username,
        'content': content,
        'upvotes': 0,
        'downvotes': 0,
      });
    } catch (e) {
      throw Exception('Failed to add reply: $e');
    }
  }

  // Upvote a post
  static Future<void> upvotePost(String postId, String userId) async {
    try {
      final response = await supabase
          .from('posts')
          .select('upvotes')
          .eq('id', postId)
          .single();
      final currentUpvotes = response['upvotes'] as int;
      await supabase
          .from('posts')
          .update({'upvotes': currentUpvotes + 1})
          .eq('id', postId);
    } catch (e) {
      print('Upvote exception: $e');
      throw Exception('Failed to upvote post: $e');
    }
  }

  // Downvote a post
  static Future<void> downvotePost(String postId, String userId) async {
    try {
      final response = await supabase
          .from('posts')
          .select('downvotes')
          .eq('id', postId)
          .single();
      final currentDownvotes = response['downvotes'] as int;
      await supabase
          .from('posts')
          .update({'downvotes': currentDownvotes + 1})
          .eq('id', postId);
    } catch (e) {
      print('Downvote exception: $e');
      throw Exception('Failed to downvote post: $e');
    }
  }

  // Upvote a reply
  static Future<void> upvoteReply(String replyId, String userId) async {
    try {
      final response = await supabase
          .from('replies')
          .select('upvotes')
          .eq('id', replyId)
          .single();
      final currentUpvotes = response['upvotes'] as int;
      await supabase
          .from('replies')
          .update({'upvotes': currentUpvotes + 1})
          .eq('id', replyId);
    } catch (e) {
      print('Upvote reply exception: $e');
      throw Exception('Failed to upvote reply: $e');
    }
  }

  // Downvote a reply
  static Future<void> downvoteReply(String replyId, String userId) async {
    try {
      final response = await supabase
          .from('replies')
          .select('downvotes')
          .eq('id', replyId)
          .single();
      final currentDownvotes = response['downvotes'] as int;
      await supabase
          .from('replies')
          .update({'downvotes': currentDownvotes + 1})
          .eq('id', replyId);
    } catch (e) {
      print('Downvote reply exception: $e');
      throw Exception('Failed to downvote reply: $e');
    }
  }
}

class CommunityForumPage extends StatefulWidget {
  const CommunityForumPage({super.key});

  @override
  State<CommunityForumPage> createState() => _CommunityForumPageState();
}

class _CommunityForumPageState extends State<CommunityForumPage> {
  final GlobalKey<_ForumPostsListState> _forumPostsKey = GlobalKey<_ForumPostsListState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Community Forum'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              if (supabase.auth.currentUser == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please sign in to create a post')),
                );
                Navigator.pushNamed(context, '/signin');
                return;
              }
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CreatePostPage()),
              );
              if (result == true) {
                _forumPostsKey.currentState?.refresh();
              }
            },
          ),
        ],
      ),
      body: ForumPostsList(key: _forumPostsKey),
    );
  }
}

class ForumPostsList extends StatefulWidget {
  const ForumPostsList({super.key});

  @override
  State<ForumPostsList> createState() => _ForumPostsListState();
}

class _ForumPostsListState extends State<ForumPostsList> {
  late Stream<List<Map<String, dynamic>>> _postsStream;
  Map<String, int> replyCountOverrides = {};

  @override
  void initState() {
    super.initState();
    _initStream();
  }

  void _updateReplyCount(String postId, int count) {
    setState(() {
      replyCountOverrides[postId] = count;
    });
  }

  void _initStream() {
    _postsStream = supabase
        .from('posts')
        .stream(primaryKey: ['id'])
        .order('created_at', ascending: false)
        .map((data) => data as List<Map<String, dynamic>>);
  }

  void refresh() {
    setState(() {
      _initStream();
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: _postsStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return const Center(child: Text('Error loading posts'));
        }
        final posts = snapshot.data ?? [];
        if (posts.isEmpty) {
          return const Center(child: Text('No posts yet'));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: posts.length,
          itemBuilder: (context, index) {
            final post = posts[index];
            final postId = post['id'] as String;
            return PostCard(
              post: post,
              fetchReplyCount: true,
              replyCountOverride: replyCountOverrides[postId],
              onVoted: refresh,
              onTap: () async {
                final latestPost = await supabase
                    .from('posts')
                    .select('id, user_id, username, title, content, upvotes, downvotes, created_at')
                    .eq('id', post['id'])
                    .single();
                final newReplyCount = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PostDetailPage(post: latestPost),
                  ),
                );
                if (newReplyCount is int) {
                  _updateReplyCount(postId, newReplyCount);
                }
              },
            );
          },
        );
      },
    );
  }
}

class PostCard extends StatefulWidget {
  final Map<String, dynamic> post;
  final VoidCallback? onVoted;
  final VoidCallback? onTap;
  final bool fetchReplyCount;
  final VoidCallback? onRefresh;
  final int? replyCountOverride;

  const PostCard({super.key, required this.post, this.onVoted, this.onTap, this.fetchReplyCount = false, this.onRefresh, this.replyCountOverride});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  int? replyCount;
  int upvotes = 0;
  int downvotes = 0;

  @override
  void initState() {
    super.initState();
    upvotes = widget.post['upvotes'] ?? 0;
    downvotes = widget.post['downvotes'] ?? 0;
    if (widget.replyCountOverride != null) {
      replyCount = widget.replyCountOverride;
    } else if (widget.fetchReplyCount) {
      _fetchReplyCount();
    }
  }

  @override
  void didUpdateWidget(PostCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.replyCountOverride != null && widget.replyCountOverride != replyCount) {
      setState(() {
        replyCount = widget.replyCountOverride;
      });
    }
  }

  Future<void> _fetchReplyCount() async {
    final response = await supabase
        .from('replies')
        .select('id')
        .eq('post_id', widget.post['id']);
    setState(() {
      replyCount = (response as List).length;
    });
  }

  @override
  Widget build(BuildContext context) {
    final post = widget.post;
    final timestamp = DateTime.parse(post['created_at']);
    final timeAgo = _formatTimeAgo(timestamp);

    return GestureDetector(
      onTap: widget.onTap,
      child: Card(
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
                    backgroundColor: Colors.green,
                    child: Text(
                      post['username'][0],
                      style: const TextStyle(color: Colors.white),
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
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                post['title'],
                style: Theme.of(context).textTheme.titleLarge,
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
                    icon: const Icon(Icons.arrow_upward, color: Colors.green),
                    onPressed: () async {
                      if (supabase.auth.currentUser == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Please sign in to vote')),
                        );
                        Navigator.pushNamed(context, '/signin');
                        return;
                      }
                      try {
                        await ForumManager.upvotePost(post['id'], supabase.auth.currentUser!.id);
                        setState(() {
                          upvotes += 1;
                        });
                        if (widget.fetchReplyCount) _fetchReplyCount();
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error upvoting: $e')),
                        );
                      }
                    },
                  ),
                  Text(
                    '${upvotes - downvotes}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  IconButton(
                    icon: const Icon(Icons.arrow_downward, color: Colors.grey),
                    onPressed: () async {
                      if (supabase.auth.currentUser == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Please sign in to vote')),
                        );
                        Navigator.pushNamed(context, '/signin');
                        return;
                      }
                      try {
                        await ForumManager.downvotePost(post['id'], supabase.auth.currentUser!.id);
                        setState(() {
                          downvotes += 1;
                        });
                        if (widget.fetchReplyCount) _fetchReplyCount();
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error downvoting: $e')),
                        );
                      }
                    },
                  ),
                  const Spacer(),
                  TextButton.icon(
                    icon: const Icon(Icons.comment, color: Colors.green),
                    label: Text(
                      replyCount != null ? '$replyCount Replies' : 'Replies',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.green),
                    ),
                    onPressed: widget.onTap,
                  ),
                ],
              ),
            ],
          ),
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

class PostDetailPage extends StatefulWidget {
  final Map<String, dynamic> post;

  const PostDetailPage({super.key, required this.post});

  @override
  State<PostDetailPage> createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
  late Map<String, dynamic> post;
  List<Map<String, dynamic>> replies = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    post = widget.post;
    _fetchReplies();
  }

  Future<void> _fetchReplies() async {
    setState(() => loading = true);
    final response = await supabase
        .from('replies')
        .select('id, user_id, username, content, upvotes, downvotes, created_at')
        .eq('post_id', post['id'])
        .order('created_at', ascending: true);
    setState(() {
      replies = List<Map<String, dynamic>>.from(response);
      loading = false;
    });
  }

  Future<void> _refreshPost() async {
    final response = await supabase
        .from('posts')
        .select('id, user_id, username, title, content, upvotes, downvotes, created_at')
        .eq('id', post['id'])
        .single();
    setState(() {
      post = response;
    });
  }

  void _onReplyPosted() async {
    await _fetchReplies();
    setState(() {}); // Triggers rebuild to update PostCard replyCountOverride
  }

  @override
  void dispose() {
    // When popping, return the latest reply count
    Navigator.pop(context, replies.length);
    super.dispose();
  }

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
              PostCard(
                post: post,
                onVoted: () async {
                  await _refreshPost();
                },
                replyCountOverride: replies.length,
              ),
              const SizedBox(height: 16),
              Text(
                'Replies',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              if (loading)
                const Center(child: CircularProgressIndicator())
              else if (replies.isNotEmpty)
                ...replies.map((reply) => ReplyCard(postId: post['id'], reply: reply, onVoted: _fetchReplies)).toList()
              else
                const Text('No replies yet'),
              const SizedBox(height: 16),
              CreateReplyWidget(
                postId: post['id'],
                onReplyPosted: _onReplyPosted,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ReplyCard extends StatefulWidget {
  final String postId;
  final Map<String, dynamic> reply;
  final VoidCallback? onVoted;

  const ReplyCard({super.key, required this.postId, required this.reply, this.onVoted});

  @override
  State<ReplyCard> createState() => _ReplyCardState();
}

class _ReplyCardState extends State<ReplyCard> {
  late int upvotes;
  late int downvotes;

  @override
  void initState() {
    super.initState();
    upvotes = widget.reply['upvotes'] ?? 0;
    downvotes = widget.reply['downvotes'] ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    final reply = widget.reply;
    final timestamp = DateTime.parse(reply['created_at']);
    final timeAgo = _formatTimeAgo(timestamp);

    return Container(
      margin: const EdgeInsets.only(left: 16, bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: Colors.green,
                child: Text(
                  reply['username'][0],
                  style: const TextStyle(color: Colors.white, fontSize: 12),
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
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      timeAgo,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey),
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
                icon: const Icon(Icons.arrow_upward, color: Colors.green, size: 20),
                onPressed: () async {
                  if (supabase.auth.currentUser == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please sign in to vote')),
                    );
                    Navigator.pushNamed(context, '/signin');
                    return;
                  }
                  try {
                    await ForumManager.upvoteReply(reply['id'], supabase.auth.currentUser!.id);
                    setState(() {
                      upvotes += 1;
                    });
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error upvoting reply: $e')),
                    );
                  }
                },
              ),
              Text(
                '${upvotes - downvotes}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              IconButton(
                icon: const Icon(Icons.arrow_downward, color: Colors.grey, size: 20),
                onPressed: () async {
                  if (supabase.auth.currentUser == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please sign in to vote')),
                    );
                    Navigator.pushNamed(context, '/signin');
                    return;
                  }
                  try {
                    await ForumManager.downvoteReply(reply['id'], supabase.auth.currentUser!.id);
                    setState(() {
                      downvotes += 1;
                    });
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error downvoting reply: $e')),
                    );
                  }
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
  final VoidCallback? onReplyPosted;

  const CreateReplyWidget({super.key, required this.postId, this.onReplyPosted});

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
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
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
              onPressed: () async {
                if (_controller.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Reply cannot be empty')),
                  );
                  return;
                }
                final user = supabase.auth.currentUser;
                if (user == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please sign in to reply')),
                  );
                  Navigator.pushNamed(context, '/signin');
                  return;
                }
                try {
                  await ForumManager.addReply(
                    widget.postId,
                    _controller.text.trim(),
                    user.id,
                    user.userMetadata?['username'] ?? user.email?.split('@')[0] ?? 'User',
                  );
                  _controller.clear();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Reply posted')),
                  );
                  if (widget.onReplyPosted != null) widget.onReplyPosted!();
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error posting reply: $e')),
                  );
                }
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
              style: Theme.of(context).textTheme.titleLarge,
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
              onPressed: () async {
                if (_titleController.text.trim().isEmpty || _contentController.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please fill in all fields')),
                  );
                  return;
                }
                final user = supabase.auth.currentUser;
                if (user == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please sign in to create a post')),
                  );
                  Navigator.pushNamed(context, '/signin');
                  return;
                }
                try {
                  await ForumManager.addPost(
                    _titleController.text.trim(),
                    _contentController.text.trim(),
                    user.id,
                    user.userMetadata?['username'] ?? user.email?.split('@')[0] ?? 'User',
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Post created')),
                  );
                  Navigator.pop(context, true); // Return true to trigger refresh
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error creating post: $e')),
                  );
                }
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