
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:animate_do/animate_do.dart';
import 'package:lottie/lottie.dart';
import 'aboutus.dart';
import 'chatbot.dart';
import 'community.dart';
import 'housing.dart';
import 'articles.dart';
import 'theme.dart';
import '_trending_articles_slideshow.dart';

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
      const HousingPageContent(),
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
        title: ElasticIn(
          child: Text(
            _pageTitles[_selectedIndex],
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w700,
              fontSize: 24,
              color: darkSlateGray,
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: CircleAvatar(
              radius: 20,
              backgroundColor: emeraldGreen,
              child: supabase.auth.currentUser == null
                  ? const Icon(Icons.person, color: Colors.white)
                  : ClipOval(
                      child: CachedNetworkImage(
                        imageUrl: 'https://cdn-icons-png.flaticon.com/512/64/64572.png',
                        width: 40,
                        height: 40,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => const Icon(Icons.person, color: darkSlateGray),
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
      floatingActionButton: Pulse(
        duration: const Duration(milliseconds: 1500),
        child: SizedBox(
          width: 100,
          height: 100,
          child: RawMaterialButton(
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
            fillColor: Colors.transparent,
            elevation: 0,
            shape: const CircleBorder(),
            child: Lottie.asset(
              'lib/assets/animations/chat.json',
              width: 100,
              height: 100,
              fit: BoxFit.contain,
            ),
            constraints: const BoxConstraints.tightFor(width: 100, height: 100),
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: whiteColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          boxShadow: [
            BoxShadow(
              color: darkSlateGray.withOpacity(0.1),
              blurRadius: 20,
              spreadRadius: 5,
            ),
          ],
        ),
        child: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
              icon: const Icon(Icons.home_outlined, size: 28),
              activeIcon: Icon(Icons.home, size: 28, color: emeraldGreen),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.house_outlined, size: 28),
              activeIcon: Icon(Icons.house, size: 28, color: emeraldGreen),
              label: 'Housing',
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.people_outline, size: 28),
              activeIcon: Icon(Icons.people, size: 28, color: emeraldGreen),
              label: 'Community',
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.info_outline, size: 28),
              activeIcon: Icon(Icons.info, size: 28, color: emeraldGreen),
              label: 'About',
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.article_outlined, size: 28),
              activeIcon: Icon(Icons.article, size: 28, color: emeraldGreen),
              label: 'Articles',
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          selectedLabelStyle: GoogleFonts.inter(fontWeight: FontWeight.w600),
          unselectedLabelStyle: GoogleFonts.inter(fontWeight: FontWeight.w400),
          selectedItemColor: emeraldGreen,
          unselectedItemColor: darkSlateGray.withOpacity(0.5),
        ),
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
      backgroundColor: whiteColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(right: Radius.circular(24)),
      ),
      child: Column(
        children: [
          Container(
            height: 200,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [emeraldGreen, warmGold.withOpacity(0.7)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
            ),
            child: Center(
              child: ZoomIn(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.white,
                      child: ClipOval(
                        child: CachedNetworkImage(
                          imageUrl: profileImageUrl,
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => const Icon(Icons.person, color: darkSlateGray),
                          errorWidget: (context, url, error) => const Icon(Icons.error),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      userName,
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      user?.email ?? 'Not signed in',
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          ListTile(
            leading: const Icon(Icons.logout, color: darkSlateGray),
            title: Text('Sign Out', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
            onTap: () {
              onSignOut();
              Navigator.pop(context);
            },
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'EZMove v2.0.0',
              style: GoogleFonts.inter(
                color: darkSlateGray.withOpacity(0.6),
                fontWeight: FontWeight.w500,
              ),
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
          // Hero Section with Parallax
          Stack(
            children: [
              Container(
                height: 350,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [emeraldGreen.withOpacity(0.8), warmGold.withOpacity(0.6)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Lottie.asset(
                  'lib/assets/animations/hero_background.json',
                  fit: BoxFit.cover,
                ),
              ),
              Positioned.fill(
                child: FadeInDown(
                  duration: const Duration(milliseconds: 800),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Discover Your New Home',
                            style: GoogleFonts.inter(
                              fontSize: 36,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              shadows: [
                                Shadow(
                                  color: darkSlateGray.withOpacity(0.4),
                                  blurRadius: 10,
                                  offset: const Offset(2, 2),
                                ),
                              ],
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            user == null
                                ? 'Join EZMove to start your journey'
                                : 'Welcome back, ${user.userMetadata?['name'] ?? 'Explorer'}!',
                            style: GoogleFonts.inter(
                              fontSize: 18,
                              color: Colors.white.withOpacity(0.9),
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          if (user == null) ...[
                            const SizedBox(height: 20),
                            BounceInUp(
                              child: ElevatedButton(
                                onPressed: () => Navigator.pushNamed(context, '/signup'),
                                child: const Text('Get Started'),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          // Trending Articles Slideshow
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: TrendingArticlesSlideshow(
              onNavigateToIndex: widget.onNavigateToIndex,
            ),
          ),
          // Feature Carousel
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FadeInUp(
                  duration: const Duration(milliseconds: 700),
                  child: Text(
                    'Explore EZMove',
                    style: GoogleFonts.inter(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: darkSlateGray,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 200,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      _buildFeatureCard(
                        context,
                        'Find Housing',
                        Icons.house,
                        '/housing',
                        emeraldGreen,
                        routeToIndexMap,
                      ),
                      const SizedBox(width: 12),
                      _buildFeatureCard(
                        context,
                        'Join Community',
                        Icons.people,
                        '/community',
                        warmGold,
                        routeToIndexMap,
                      ),
                      const SizedBox(width: 12),
                      _buildFeatureCard(
                        context,
                        'About Us',
                        Icons.info,
                        '/aboutus',
                        emeraldGreen,
                        routeToIndexMap,
                      ),
                      const SizedBox(width: 12),
                      _buildFeatureCard(
                        context,
                        'Articles',
                        Icons.article,
                        '/articles',
                        warmGold,
                        routeToIndexMap,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Auth Prompt
          if (user == null)
            BounceInDown(
              duration: const Duration(milliseconds: 1200),
              child: Container(
                margin: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: whiteColor,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: darkSlateGray.withOpacity(0.1),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      Text(
                        'Unlock EZMove',
                        style: GoogleFonts.inter(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: darkSlateGray,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Sign in or create an account to access all features.',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          color: darkSlateGray.withOpacity(0.7),
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () => Navigator.pushNamed(context, '/signin'),
                            child: const Text('Sign In'),
                          ),
                          const SizedBox(width: 12),
                          OutlinedButton(
                            onPressed: () => Navigator.pushNamed(context, '/signup'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: emeraldGreen,
                              side: const BorderSide(color: emeraldGreen),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                            ),
                            child: Text(
                              'Sign Up',
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.w600,
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
      borderRadius: BorderRadius.circular(24),
      onTap: () {
        final targetIndex = routeMap[route];
        if (targetIndex != null) {
          widget.onNavigateToIndex(targetIndex);
        } else {
          Navigator.pushNamed(context, route);
        }
      },
      child: Container(
        width: 160,
        decoration: BoxDecoration(
          color: whiteColor,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.2),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: color.withOpacity(0.1),
              child: Icon(icon, size: 32, color: color),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w600,
                fontSize: 16,
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