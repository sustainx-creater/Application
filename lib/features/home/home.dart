import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:animate_do/animate_do.dart';
import 'package:lottie/lottie.dart';
import '../about/aboutus.dart';
import '../chatbot/chatbot.dart';
import '../community/community.dart';
import '../housing/housing.dart';
import '../articles/articles.dart';
import '../../theme.dart';
import '../articles/_trending_articles_slideshow.dart';
import '../housing/filtered_accommodations.dart';
import '../housing/utils/csv_reader.dart';
import '../profile/profile.dart';

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
    'Articles',
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
      const ArticlesPageContent(),
      const AboutUsPageContent()
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
          child: Flexible(
            child: Text(
              _pageTitles[_selectedIndex],
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w700,
                fontSize: 26,
                color: darkSlateGray,
                letterSpacing: -0.5,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: CircleAvatar(
              radius: 20,
              backgroundColor: emeraldGreen.withOpacity(0.1),
              child: supabase.auth.currentUser == null
                  ? const Icon(Icons.person, color: darkSlateGray, size: 24)
                  : ClipOval(
                      child: CachedNetworkImage(
                        imageUrl: 'https://cdn-icons-png.flaticon.com/512/64/64572.png',
                        width: 40,
                        height: 40,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => const Icon(Icons.person, color: darkSlateGray, size: 24),
                        errorWidget: (context, url, error) => const Icon(Icons.error, size: 24),
                      ),
                    ),
            ),
            onPressed: () {
              if (supabase.auth.currentUser == null) {
                Navigator.pushNamed(context, '/signin');
              } else {
                Scaffold.of(context).openDrawer(); // Open drawer instead of navigating directly
              }
            },
          ),
        ),
        actions: [
          _buildStylishMenu(_selectedIndex, context),
        ],
      ),
      drawer: ProfileDrawer(onSignOut: _signOut),
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      floatingActionButton: Pulse(
        duration: const Duration(milliseconds: 1500),
        child: SizedBox(
          width: 80,
          height: 80,
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
            constraints: const BoxConstraints.tightFor(width: 80, height: 80),
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            child: Lottie.asset(
              'lib/assets/animations/chat.json',
              width: 60,
              height: 60,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: whiteColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
          boxShadow: [
            BoxShadow(
              color: darkSlateGray.withOpacity(0.05),
              blurRadius: 15,
              spreadRadius: 2,
            ),
          ],
        ),
        child: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined, size: 30),
              activeIcon: Icon(Icons.home, size: 30, color: emeraldGreen),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.house_outlined, size: 30),
              activeIcon: Icon(Icons.house, size: 30, color: emeraldGreen),
              label: 'Housing',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.people_outline, size: 30),
              activeIcon: Icon(Icons.people, size: 30, color: emeraldGreen),
              label: 'Community',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.article_outlined, size: 30),
              activeIcon: Icon(Icons.article, size: 30, color: emeraldGreen),
              label: 'Articles',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.info_outline, size: 30),
              activeIcon: Icon(Icons.info, size: 30, color: emeraldGreen),
              label: 'About',
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          selectedLabelStyle: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 12),
          unselectedLabelStyle: GoogleFonts.inter(fontWeight: FontWeight.w400, fontSize: 12),
          selectedItemColor: emeraldGreen,
          unselectedItemColor: darkSlateGray.withOpacity(0.4),
          elevation: 0,
          backgroundColor: Colors.transparent,
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

  Widget _buildStylishMenu(int pageIndex, BuildContext context) {
    final List<Map<String, dynamic>> menuItems = switch (pageIndex) {
      1 => [
          {'title': 'Show Listings', 'icon': Icons.list_alt},
          {'title': 'Add Listing', 'icon': Icons.add_home_work},
        ],
      3 => [
          {'title': 'Write Article', 'icon': Icons.edit_note},
          {'title': 'Your Articles', 'icon': Icons.article},
          {'title': 'Delete Article', 'icon': Icons.delete_forever, 'color': Colors.redAccent},
        ],
      _ => [
          {'title': 'More Options', 'icon': Icons.more_horiz},
        ],
    };

    return MenuAnchor(
      style: MenuStyle(
        backgroundColor: const WidgetStatePropertyAll(whiteColor),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
        elevation: const WidgetStatePropertyAll(12),
        padding: const WidgetStatePropertyAll(EdgeInsets.all(12)),
      ),
      builder: (context, controller, child) {
        return InkWell(
          onTap: () {
            if (controller.isOpen) {
              controller.close();
            } else {
              controller.open();
            }
          },
          borderRadius: BorderRadius.circular(30),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [emeraldGreen.withOpacity(0.15), warmGold.withOpacity(0.1)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: emeraldGreen.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: Icon(
                controller.isOpen ? Icons.close : Icons.menu_rounded,
                key: ValueKey<bool>(controller.isOpen),
                color: emeraldGreen,
                size: 28,
              ),
            ),
          ),
        );
      },
      menuChildren: menuItems.map((item) {
        return MenuItemButton(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('${item['title']} Clicked'),
                backgroundColor: emeraldGreen,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              ),
            );
          },
          child: Row(
            children: [
              Icon(
                item['icon'],
                color: item['color'] ?? emeraldGreen,
                size: 22,
              ),
              const SizedBox(width: 12),
              Text(
                item['title'],
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  color: item['color'] ?? darkSlateGray,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
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
        borderRadius: BorderRadius.horizontal(right: Radius.circular(30)),
      ),
      child: Column(
        children: [
          Container(
            height: 220,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [emeraldGreen, warmGold.withOpacity(0.6)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(30)),
            ),
            child: Center(
              child: ZoomIn(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundColor: whiteColor.withOpacity(0.9),
                      child: ClipOval(
                        child: CachedNetworkImage(
                          imageUrl: profileImageUrl,
                          width: 120,
                          height: 120,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => const Icon(Icons.person, color: darkSlateGray),
                          errorWidget: (context, url, error) => const Icon(Icons.error),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      userName,
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w700,
                        fontSize: 22,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      user?.email ?? 'Not signed in',
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          ListTile(
            leading: const Icon(Icons.account_circle, color: darkSlateGray, size: 26),
            title: Text('Account', style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 16)),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfilePage()),
              ); // Navigate to ProfilePage
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout, color: darkSlateGray, size: 26),
            title: Text('Sign Out', style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 16)),
            onTap: () {
              onSignOut();
              Navigator.pop(context);
            },
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              'EZMove v2.0.0',
              style: GoogleFonts.inter(
                color: darkSlateGray.withOpacity(0.5),
                fontWeight: FontWeight.w500,
                fontSize: 12,
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
      '/articles': 3,
      '/aboutus': 4,
    };

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hero Section
          LayoutBuilder(
            builder: (context, constraints) {
              final screenHeight = MediaQuery.of(context).size.height;
              final screenWidth = MediaQuery.of(context).size.width;
              final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
              final isLargeScreen = screenWidth > 600;
              final heroHeight = isLandscape ? screenHeight * 0.65 : screenHeight * 0.5;
              final clampedHeight = heroHeight.clamp(280.0, 450.0);

              return ConstrainedBox(
                constraints: BoxConstraints(maxWidth: screenWidth),
                child: Stack(
                  children: [
                    Container(
                      height: clampedHeight,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [emeraldGreen.withOpacity(0.7), warmGold.withOpacity(0.5)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Opacity(
                        opacity: 0.3,
                        child: SizedBox(
                          width: screenWidth,
                          height: clampedHeight,
                          child: Lottie.asset(
                            'lib/assets/animations/hero_background.json',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    Positioned.fill(
                      child: FadeInDown(
                        duration: const Duration(milliseconds: 1000),
                        child: Center(
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              maxWidth: isLargeScreen ? 800 : screenWidth * 0.9,
                              maxHeight: clampedHeight * 0.9,
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: isLargeScreen ? 40.0 : 20.0,
                                vertical: isLandscape ? 20.0 : 30.0,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Flexible(
                                    child: Text(
                                      'New Place, New Possibilities',
                                      style: GoogleFonts.inter(
                                        fontSize: isLargeScreen
                                            ? (isLandscape ? 36 : 48)
                                            : (isLandscape ? 32 : 40),
                                        fontWeight: FontWeight.w900,
                                        color: Colors.white,
                                        letterSpacing: -1,
                                        shadows: [
                                          Shadow(
                                            color: darkSlateGray.withOpacity(0.3),
                                            blurRadius: 12,
                                            offset: const Offset(0, 4),
                                          ),
                                        ],
                                      ),
                                      textAlign: TextAlign.center,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Flexible(
                                    child: Text(
                                      'Housing, Local Insights & Human-Like Chat Support for Students, Expats & Tourists',
                                      style: GoogleFonts.inter(
                                        fontSize: isLargeScreen
                                            ? (isLandscape ? 16 : 18)
                                            : (isLandscape ? 14 : 16),
                                        fontWeight: FontWeight.w400,
                                        color: Colors.white.withOpacity(0.9),
                                        height: 1.5,
                                      ),
                                      textAlign: TextAlign.center,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  if (user == null)
                                    BounceInUp(
                                      child: ElevatedButton(
                                        onPressed: () => Navigator.pushNamed(context, '/signup'),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: emeraldGreen,
                                          foregroundColor: whiteColor,
                                          padding: EdgeInsets.symmetric(
                                            horizontal: isLargeScreen ? 40 : 24,
                                            vertical: isLandscape ? 12 : 16,
                                          ),
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                          elevation: 4,
                                        ),
                                        child: Text(
                                          'Start Your Journey',
                                          style: GoogleFonts.inter(
                                            fontWeight: FontWeight.w600,
                                            fontSize: isLandscape ? 14 : 16,
                                          ),
                                        ),
                                      ),
                                    ),
                                  if (user != null)
                                    Flexible(
                                      child: Text(
                                        'Welcome back, ${user.userMetadata?['name'] ?? 'Explorer'}!',
                                        style: GoogleFonts.inter(
                                          fontSize: isLargeScreen
                                              ? (isLandscape ? 18 : 20)
                                              : (isLandscape ? 16 : 18),
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white,
                                        ),
                                        textAlign: TextAlign.center,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          // Trending Articles
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24.0),
            child: TrendingArticlesSlideshow(
              onNavigateToIndex: widget.onNavigateToIndex,
            ),
          ),
          // Featured Housing
          FutureBuilder<List<Map<String, dynamic>>>(
            future: loadAccommodationsFromCsv(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              final allHousing = snapshot.data!;
              if (allHousing.isEmpty) {
                return const Center(child: Text('No featured housing found.'));
              }
              allHousing.shuffle();
              final featured = allHousing.take(3).toList();
              return _FeaturedHousingSlideshow(
                featured: featured,
                onNavigateToDetail: (house) async {
                  widget.onNavigateToIndex(1);
                  await Future.delayed(const Duration(milliseconds: 300));
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => FilteredAccommodationsPage(
                        accommodations: [house],
                      ),
                    ),
                  );
                },
              );
            },
          ),
          // Feature Carousel
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FadeInUp(
                  duration: const Duration(milliseconds: 700),
                  child: Text(
                    'Explore EZMove',
                    style: GoogleFonts.inter(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: darkSlateGray,
                      letterSpacing: -0.5,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: 220,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    children: [
                      _buildFeatureCard(
                        context,
                        'Find Housing',
                        Icons.house,
                        '/housing',
                        emeraldGreen,
                        routeToIndexMap,
                      ),
                      const SizedBox(width: 16),
                      _buildFeatureCard(
                        context,
                        'Join Community',
                        Icons.people,
                        '/community',
                        warmGold,
                        routeToIndexMap,
                      ),
                      const SizedBox(width: 16),
                      _buildFeatureCard(
                        context,
                        'Articles',
                        Icons.article,
                        '/articles',
                        warmGold,
                        routeToIndexMap,
                      ),
                      const SizedBox(width: 16),
                      _buildFeatureCard(
                        context,
                        'About Us',
                        Icons.info,
                        '/aboutus',
                        emeraldGreen,
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
                margin: const EdgeInsets.all(24.0),
                decoration: BoxDecoration(
                  color: whiteColor,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: darkSlateGray.withOpacity(0.05),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    children: [
                      Text(
                        'Unlock Your Journey',
                        style: GoogleFonts.inter(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: darkSlateGray,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Sign in or create an account to access exclusive features and personalized insights.',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          color: darkSlateGray.withOpacity(0.7),
                          fontWeight: FontWeight.w400,
                          height: 1.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () => Navigator.pushNamed(context, '/signin'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: emeraldGreen,
                              foregroundColor: whiteColor,
                              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                              elevation: 4,
                            ),
                            child: Text(
                              'Sign In',
                              style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 16),
                            ),
                          ),
                          const SizedBox(width: 16),
                          OutlinedButton(
                            onPressed: () => Navigator.pushNamed(context, '/signup'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: emeraldGreen,
                              side: BorderSide(color: emeraldGreen.withOpacity(0.5)),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
                            ),
                            child: Text(
                              'Sign Up',
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
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
      borderRadius: BorderRadius.circular(30),
      onTap: () {
        final targetIndex = routeMap[route];
        if (targetIndex != null) {
          widget.onNavigateToIndex(targetIndex);
        } else {
          Navigator.pushNamed(context, route);
        }
      },
      child: Container(
        width: 180,
        decoration: BoxDecoration(
          color: whiteColor,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.1),
              blurRadius: 15,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: color.withOpacity(0.1),
              child: Icon(icon, size: 40, color: color),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w600,
                fontSize: 18,
                color: darkSlateGray,
              ),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ],
        ),
      ),
    );
  }
}

class _FeaturedHousingSlideshow extends StatefulWidget {
  final List<Map<String, dynamic>> featured;
  final Function(Map<String, dynamic>) onNavigateToDetail;

  const _FeaturedHousingSlideshow({
    required this.featured,
    required this.onNavigateToDetail,
  });

  @override
  State<_FeaturedHousingSlideshow> createState() => _FeaturedHousingSlideshowState();
}

class _FeaturedHousingSlideshowState extends State<_FeaturedHousingSlideshow> with SingleTickerProviderStateMixin {
  int _current = 0;
  late final PageController _controller;
  late final int _length;
  late final Duration _autoSlideDuration;
  late final Duration _animationDuration;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _controller = PageController(viewportFraction: 0.85);
    _length = widget.featured.length;
    _autoSlideDuration = const Duration(seconds: 4);
    _animationDuration = const Duration(milliseconds: 600);
    _startAutoSlide();
  }

  void _startAutoSlide() {
    _timer?.cancel();
    _timer = Timer.periodic(_autoSlideDuration, (_) {
      if (!mounted) return;
      int next = (_current + 1) % _length;
      _controller.animateToPage(
        next,
        duration: _animationDuration,
        curve: Curves.easeInOutCubic,
      );
      setState(() => _current = next);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
          child: Text(
            'Featured Housing',
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w700,
              fontSize: 28,
              color: darkSlateGray,
              letterSpacing: -0.5,
            ),
          ),
        ),
        SizedBox(
          height: 260,
          child: PageView.builder(
            controller: _controller,
            itemCount: widget.featured.length,
            onPageChanged: (i) {
              setState(() => _current = i);
              _startAutoSlide();
            },
            itemBuilder: (context, i) {
              final house = widget.featured[i];
              return GestureDetector(
                onTap: () => widget.onNavigateToDetail(house),
                child: AnimatedScale(
                  duration: const Duration(milliseconds: 300),
                  scale: _current == i ? 1.0 : 0.95,
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: whiteColor,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: emeraldGreen.withOpacity(0.1),
                          blurRadius: 15,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: Stack(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 140,
                                width: double.infinity,
                                decoration: const BoxDecoration(
                                  image: DecorationImage(
                                    image: NetworkImage(
                                      'https://images.pexels.com/photos/106399/pexels-photo-106399.jpeg',
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      (house['propertyType'] ?? 'Property'),
                                      style: GoogleFonts.inter(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 16,
                                        color: darkSlateGray,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      (house['address'] ?? house['location'] ?? 'No address'),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.inter(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 13,
                                        color: mediumGrey.withOpacity(0.8),
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      '€${house['price'] ?? 'N/A'}',
                                      style: GoogleFonts.inter(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15,
                                        color: emeraldGreen,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Positioned(
                            top: 8,
                            right: 8,
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: warmGold.withOpacity(0.9),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.favorite_border,
                                color: whiteColor,
                                size: 18,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              widget.featured.length,
              (i) => AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: _current == i ? 12 : 8,
                height: 8,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _current == i ? emeraldGreen : mediumGrey.withOpacity(0.3),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}