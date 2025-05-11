import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'aboutus.dart';
import 'chatbot.dart';
import 'community.dart';
import 'housing.dart';
import 'theme.dart';

final supabase = Supabase.instance.client;

class MyHomePage extends StatefulWidget {
  final int initialIndex;

  const MyHomePage({super.key, this.initialIndex = 0});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late int _selectedIndex;
  late final List<Widget> _pages;
  static const List<String> _pageTitles = [
    'EZMove',
    'Housing',
    'Community',
    'About Us',
  ];

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
    _pages = [
      HomePageContent(
        onNavigateToIndex: (index) => _onItemTapped(index),
      ),
      const HousingPageContent(),
      const CommunityPageContent(),
      const AboutUsPageContent(),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _pageTitles[_selectedIndex],
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: darkSlateGray,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: CircleAvatar(
              radius: 18,
              backgroundColor: emeraldGreen,
              child: supabase.auth.currentUser == null
                  ? const Icon(Icons.person, color: whiteColor)
                  : ClipOval(
                      child: CachedNetworkImage(
                        imageUrl: 'https://cdn-icons-png.flaticon.com/512/64/64572.png', // Replace with user profile URL
                        width: 36,
                        height: 36,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => const Icon(Icons.person, color: whiteColor),
                        errorWidget: (context, url, error) => const Icon(Icons.error),
                      ),
                    ),
            ),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      drawer: ProfileDrawer(onSignOut: _signOut),
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      floatingActionButton: FloatingActionButton(
  onPressed: () async {
    try {
      await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ChatbotPageContent()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to open chat: $e'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  },
  backgroundColor: warmGold,
  child: const Icon(Icons.chat_bubble, color: darkSlateGray),
  tooltip: 'Chat with EZMove',
),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.house_outlined),
            activeIcon: Icon(Icons.house),
            label: 'Housing',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_outline),
            activeIcon: Icon(Icons.people),
            label: 'Community',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info_outline),
            activeIcon: Icon(Icons.info),
            label: 'About',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: emeraldGreen,
        unselectedItemColor: darkSlateGray.withValues(alpha: 0.6),
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        elevation: 10,
      ),
    );
  }

  Future<void> _signOut() async {
    try {
      await supabase.auth.signOut();
      if (!mounted) return;
      Navigator.pushNamedAndRemoveUntil(context, '/signin', (route) => false);
    } on AuthException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Logout failed: ${e.message}'), backgroundColor: Colors.redAccent),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Unexpected error: $e'), backgroundColor: Colors.redAccent),
      );
    }
  }
}

class ProfileDrawer extends StatelessWidget {
  final VoidCallback onSignOut;

  const ProfileDrawer({super.key, required this.onSignOut});

  @override
  Widget build(BuildContext context) {
    final user = supabase.auth.currentUser;
    final userName = user?.userMetadata?['name'] ?? 'Guest';
    final profileImageUrl = user?.userMetadata?['avatar_url'] ?? 'https://cdn-icons-png.flaticon.com/512/64/64572.png';

    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(
              userName,
              style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: whiteColor),
            ),
            accountEmail: Text(
              user?.email ?? 'Not signed in',
              style: GoogleFonts.poppins(color: whiteColor.withValues(alpha: 0.8)),
            ),
            currentAccountPicture: CircleAvatar(
              radius: 40,
              backgroundColor: whiteColor,
              child: ClipOval(
                child: CachedNetworkImage(
                  imageUrl: profileImageUrl,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => const Icon(Icons.person, color: darkSlateGray),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
            ),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [emeraldGreen, darkGreen],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.logout, color: darkSlateGray),
            title: Text('Sign Out', style: GoogleFonts.poppins()),
            onTap: () {
              onSignOut();
              Navigator.pop(context);
            },
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'EZMove v1.0.0',
              style: GoogleFonts.poppins(color: darkSlateGray.withValues(alpha: 0.6)),
            ),
          ),
        ],
      ),
    );
  }
}

class HomePageContent extends StatefulWidget {
  final Function(int) onNavigateToIndex;

  const HomePageContent({super.key, required this.onNavigateToIndex});

  @override
  State<HomePageContent> createState() => _HomePageContentState();
}

class _HomePageContentState extends State<HomePageContent> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = supabase.auth.currentUser;
    final routeToIndexMap = {
      '/housing': 1,
      '/community': 2,
      '/aboutus': 3,
    };

    return FadeTransition(
      opacity: _fadeAnimation,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Section with Parallax Effect
            Container(
              height: 300,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [emeraldGreen.withValues(alpha: 0.9), darkGreen],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Opacity(
                      opacity: 0.2,
                      child: Image.network(
                        'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?fit=crop&w=1350&q=80',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Welcome to EZMove',
                            style: GoogleFonts.poppins(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            color: whiteColor,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            user == null
                                ? 'Sign in to explore your new home'
                                : 'Your journey starts here',
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              color: whiteColor.withValues(alpha: 0.9),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Feature Cards
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Discover EZMove',
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: darkSlateGray,
                    ),
                  ),
                  const SizedBox(height: 16),
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    children: [
                      _buildFeatureCard(
                        context,
                        'Find Housing',
                        Icons.house,
                        '/housing',
                        emeraldGreen,
                        routeToIndexMap,
                      ),
                      _buildFeatureCard(
                        context,
                        'Join Community',
                        Icons.people,
                        '/community',
                        warmGold,
                        routeToIndexMap,
                      ),
                      _buildFeatureCard(
                        context,
                        'About Us',
                        Icons.info,
                        '/aboutus',
                        darkGreen,
                        routeToIndexMap,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Auth Prompt for Unauthenticated Users
            if (user == null)
              Container(
                padding: const EdgeInsets.all(16.0),
                color: Colors.grey[100],
                child: Column(
                  children: [
                    Text(
                      'Get Started with EZMove',
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: darkSlateGray,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Sign in or create an account to unlock all features.',
                      style: GoogleFonts.poppins(color: darkSlateGray),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () => Navigator.pushNamed(context, '/signin'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: emeraldGreen,
                            foregroundColor: whiteColor,
                            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: Text('Sign In', style: GoogleFonts.poppins()),
                        ),
                        const SizedBox(width: 10),
                        OutlinedButton(
                          onPressed: () => Navigator.pushNamed(context, '/signup'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: emeraldGreen,
                            side: const BorderSide(color: emeraldGreen),
                            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: Text('Sign Up', style: GoogleFonts.poppins()),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureCard(
    BuildContext context,
    String title,
    IconData icon,
    String route,
    Color color,
    Map<String, int> routeMap,
  ) {
    return GestureDetector(
      onTap: () {
        final targetIndex = routeMap[route];
        if (targetIndex != null) {
          widget.onNavigateToIndex(targetIndex);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Route $route unavailable'), backgroundColor: Colors.redAccent),
          );
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(height: 10),
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: darkSlateGray,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}