import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:animate_do/animate_do.dart';
import 'aboutus.dart';
import 'chatbot.dart';
import 'community.dart';
import 'housing.dart';
import 'theme.dart';
import 'articles.dart';
import 'dart:ui';

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
    'Articles',
  ];

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
    _pages = [
      HomePageContent(
        onNavigateToIndex: (index) => _onItemTapped(index),
      ),
      HousingPageContent(),
      const CommunityPageContent(),
      const AboutUsPageContent(),
      const ArticlesPageContent(),
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
        backgroundColor: whiteColor,
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
                        imageUrl: 'https://cdn-icons-png.flaticon.com/512/64/64572.png',
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
        tooltip: 'Chat with EZMove',
        child: const Icon(Icons.chat_bubble, color: darkSlateGray),
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
          BottomNavigationBarItem(
            icon: Icon(Icons.article_outlined),
            activeIcon: Icon(Icons.article),
            label: 'Articles',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: emeraldGreen,
        unselectedItemColor: darkSlateGray.withOpacity(0.6),
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        backgroundColor: whiteColor,
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
              style: GoogleFonts.poppins(color: whiteColor.withOpacity(0.8)),
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
              style: GoogleFonts.poppins(color: darkSlateGray.withOpacity(0.6)),
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

class _HomePageContentState extends State<HomePageContent> {
  @override
  Widget build(BuildContext context) {
    final user = supabase.auth.currentUser;
    final routeToIndexMap = {
      '/housing': 1,
      '/community': 2,
      '/aboutus': 3,
      '/articles': 4,
    };

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hero Section with Glassmorphism
          FadeInDown(
            duration: const Duration(milliseconds: 600),
            child: Container(
              height: 300,
              decoration: BoxDecoration(
                color: whiteColor.withOpacity(0.8),
                border: Border.all(color: mintGreen.withOpacity(0.5)),
                boxShadow: [
                  BoxShadow(
                    color: mediumGrey.withOpacity(0.1),
                    blurRadius: 15,
                    spreadRadius: 2,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Image.network(
                      'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?fit=crop&w=1350&q=80',
                      fit: BoxFit.cover,
                      color: Colors.black.withOpacity(0.3),
                      colorBlendMode: BlendMode.darken,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          emeraldGreen.withOpacity(0.2),
                          mintGreen.withOpacity(0.1),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
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
                              shadows: [
                                Shadow(
                                  color: darkSlateGray.withOpacity(0.3),
                                  blurRadius: 5,
                                  offset: const Offset(2, 2),
                                ),
                              ],
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            user == null
                                ? 'Sign in to explore your new home'
                                : 'Your journey starts here',
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              color: whiteColor.withOpacity(0.9),
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
          ),
          // Feature Cards
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FadeInUp(
                  duration: const Duration(milliseconds: 700),
                  child: Text(
                    'Discover EZMove',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontFamily: GoogleFonts.poppins().fontFamily,
                          color: darkSlateGray,
                        ),
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
                    FadeInUp(
                      duration: const Duration(milliseconds: 800),
                      child: _buildFeatureCard(
                        context,
                        'Find Housing',
                        Icons.house,
                        '/housing',
                        emeraldGreen,
                        routeToIndexMap,
                      ),
                    ),
                    FadeInUp(
                      duration: const Duration(milliseconds: 900),
                      child: _buildFeatureCard(
                        context,
                        'Join Community',
                        Icons.people,
                        '/community',
                        warmGold,
                        routeToIndexMap,
                      ),
                    ),
                    FadeInUp(
                      duration: const Duration(milliseconds: 1000),
                      child: _buildFeatureCard(
                        context,
                        'About Us',
                        Icons.info,
                        '/aboutus',
                        darkGreen,
                        routeToIndexMap,
                      ),
                    ),
                    FadeInUp(
                      duration: const Duration(milliseconds: 1100),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const ArticlesPageContent()),
                          );
                        },
                        child: _buildFeatureCard(
                          context,
                          'Articles',
                          Icons.article,
                          '/articles',
                          warmGold,
                          routeToIndexMap,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Auth Prompt for Unauthenticated Users
          if (user == null)
            BounceInDown(
              duration: const Duration(milliseconds: 1200),
              child: Container(
                margin: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: lightGrey.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: mintGreen.withOpacity(0.5)),
                  boxShadow: [
                    BoxShadow(
                      color: mediumGrey.withOpacity(0.1),
                      blurRadius: 15,
                      spreadRadius: 2,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text(
                          'Get Started with EZMove',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontFamily: GoogleFonts.poppins().fontFamily,
                                color: darkSlateGray,
                              ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Sign in or create an account to unlock all features.',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                fontFamily: GoogleFonts.poppins().fontFamily,
                                color: darkSlateGray,
                              ),
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
                              child: Text(
                                'Sign In',
                                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                      fontFamily: GoogleFonts.poppins().fontFamily,
                                      color: whiteColor,
                                    ),
                              ),
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
                              child: Text(
                                'Sign Up',
                                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                      fontFamily: GoogleFonts.poppins().fontFamily,
                                      color: emeraldGreen,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
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
    return InkWell(
      borderRadius: BorderRadius.circular(16),
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
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.18), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 38, color: color),
            const SizedBox(height: 12),
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: darkSlateGray,
                    fontSize: 16,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}