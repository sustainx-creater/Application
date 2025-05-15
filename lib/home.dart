import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:animate_do/animate_do.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter/scheduler.dart';
import 'aboutus.dart';
import 'chatbot.dart';
import 'community.dart';
import 'housing.dart';
import 'articles.dart';
import 'theme.dart';
import '_trending_articles_slideshow.dart';
import 'filtered_accommodations.dart';
import 'utils/csv_reader.dart';

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
        actions: [
          _buildPageHamburgerMenu(_selectedIndex, context),
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
            constraints: const BoxConstraints.tightFor(width: 100, height: 100),
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            child: Lottie.asset(
              'lib/assets/animations/chat.json',
              width: 100,
              height: 100,
              fit: BoxFit.contain,
            ),
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

  Widget _buildPageHamburgerMenu(int pageIndex, BuildContext context) {
    Color menuColor = emeraldGreen;
    List<PopupMenuEntry<String>> items;
    IconData iconData = Icons.menu_rounded;
    switch (pageIndex) {
      case 1: // Housing
        items = [
          PopupMenuItem(
            value: 'Show Listings',
            child: Row(
              children: [
                Icon(Icons.list_alt, color: menuColor),
                const SizedBox(width: 10),
                const Text('Show Listings'),
              ],
            ),
          ),
          PopupMenuItem(
            value: 'Add Listing',
            child: Row(
              children: [
                Icon(Icons.add_home_work, color: menuColor),
                const SizedBox(width: 10),
                const Text('Add Listing'),
              ],
            ),
          ),
        ];
        break;
      case 4: // Articles
        items = [
          PopupMenuItem(
            value: 'Write Article',
            child: Row(
              children: [
                Icon(Icons.edit_note, color: menuColor),
                const SizedBox(width: 10),
                const Text('Write Article'),
              ],
            ),
          ),
          PopupMenuItem(
            value: 'Your Articles',
            child: Row(
              children: [
                Icon(Icons.article, color: menuColor),
                const SizedBox(width: 10),
                const Text('Your Articles'),
              ],
            ),
          ),
          PopupMenuItem(
            value: 'Delete Article',
            child: Row(
              children: [
                Icon(Icons.delete_forever, color: Colors.redAccent),
                const SizedBox(width: 10),
                const Text('Delete Article'),
              ],
            ),
          ),
        ];
        break;
      default:
        items = [
          PopupMenuItem(
            value: 'Dummy Option',
            child: Row(
              children: [
                Icon(Icons.more_horiz, color: menuColor),
                const SizedBox(width: 10),
                const Text('Dummy Option'),
              ],  
            ),
          ),
        ];
    }
    return Theme(
      data: Theme.of(context).copyWith(
        cardColor: whiteColor,
        iconTheme: IconThemeData(color: menuColor),
        popupMenuTheme: PopupMenuThemeData(
          color: whiteColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          elevation: 8,
        ),
      ),
      child: PopupMenuButton<String>(
        icon: Container(
          decoration: BoxDecoration(
            color: menuColor.withOpacity(0.13),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: menuColor.withOpacity(0.08),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          padding: const EdgeInsets.all(8),
          child: Icon(iconData, color: menuColor, size: 28),
        ),
        onSelected: (value) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('$value Clicked'),
              backgroundColor: menuColor.withOpacity(0.9),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          );
        },
        itemBuilder: (context) => items,
      ),
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
              Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: 600, // Prevents excessive stretching on large screens
                  ),
                  child: Container(
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
          // Featured Housing Section as Slideshow
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
                  widget.onNavigateToIndex(1); // Switch to Housing tab
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
    _controller = PageController(viewportFraction: 0.88);
    _length = widget.featured.length;
    _autoSlideDuration = const Duration(seconds: 4);
    _animationDuration = const Duration(milliseconds: 500);
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
        curve: Curves.easeInOut,
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
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
          child: Text(
            'Featured Housing',
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w700,
              fontSize: 22,
              color: darkSlateGray,
            ),
          ),
        ),
        SizedBox(
          height: 180,
          child: PageView.builder(
            controller: _controller,
            itemCount: widget.featured.length,
            onPageChanged: (i) {
              setState(() => _current = i);
              _startAutoSlide(); // Reset timer on manual swipe
            },
            itemBuilder: (context, i) {
              final house = widget.featured[i];
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: EdgeInsets.symmetric(horizontal: _current == i ? 8 : 16, vertical: _current == i ? 0 : 12),
                child: GestureDetector(
                  onTap: () => widget.onNavigateToDetail(house),
                  child: Container(
                    width: 260,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: whiteColor,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: emeraldGreen.withOpacity(0.07),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                      border: Border.all(color: emeraldGreen.withOpacity(0.13)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          (house['propertyType'] ?? 'Property'),
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                            color: darkSlateGray,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          (house['address'] ?? house['location'] ?? 'No address'),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w400,
                            fontSize: 13,
                            color: mediumGrey.withOpacity(0.9),
                          ),
                        ),
                        const SizedBox(height: 8),
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
                ),
              );
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            widget.featured.length,
            (i) => Container(
              width: 10,
              height: 10,
              margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _current == i ? emeraldGreen : mediumGrey.withOpacity(0.3),
              ),
            ),
          ),
        ),
      ],
    );
  }
}