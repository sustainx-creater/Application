import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'aboutus.dart';
import 'chatbot.dart';
import 'community.dart';
import 'housing.dart';
import 'theme.dart';

// Initialize Supabase client
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
  static const List<String> _pageTitles = <String>[
    'EZMove Home',
    'Housing',
    'Community',
    'Chatbot',
    'About Us',
  ];

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
    _pages = <Widget>[
      HomePageContent(
        onNavigateToIndex: (index) => _onItemTapped(index),
      ),
      const HousingPageContent(),
      const CommunityPageContent(),
      const ChatbotPageContent(),
      const AboutUsPageContent(),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _signOut() async {
    try {
      await supabase.auth.signOut();
      if (!mounted) return;
      Navigator.pushNamedAndRemoveUntil(
          context, '/signin', (route) => false);
    } on AuthException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Logout failed: ${e.message}'),
          backgroundColor: Colors.redAccent,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An unexpected error occurred during logout: $e'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_pageTitles[_selectedIndex]),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Sign Out',
            onPressed: _signOut,
          ),
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
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
            icon: Icon(Icons.chat_bubble_outline),
            activeIcon: Icon(Icons.chat_bubble),
            label: 'Chatbot',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info_outline),
            activeIcon: Icon(Icons.info),
            label: 'About Us',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

class HomePageContent extends StatelessWidget {
  final Function(int) onNavigateToIndex;

  const HomePageContent({super.key, required this.onNavigateToIndex});

  @override
  Widget build(BuildContext context) {
    final Map<String, int> routeToIndexMap = {
      '/housing': 1,
      '/community': 2,
      '/chatbot': 3,
      '/aboutus': 4,
    };

    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            height: 280,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [emeraldGreen, darkGreen],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'EZMove',
                      style: Theme.of(context)
                          .textTheme
                          .displayMedium
                          ?.copyWith(color: whiteColor, fontSize: 40),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 15),
                    Text(
                      'Your one-stop solution for settling into a new country',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(
                              color: whiteColor.withOpacity(0.9), fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: () {
                        if (supabase.auth.currentUser == null) {
                          Navigator.pushNamed(context, '/signup');
                        } else {
                          onNavigateToIndex(2);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: warmGold,
                        foregroundColor: darkSlateGray,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 18),
                        textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(supabase.auth.currentUser == null
                          ? 'Get Started'
                          : 'Explore Community'),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Text(
                  'Explore EZMove',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 20),
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  children: [
                    _buildFeatureCard(context, 'Find Housing',
                        Icons.house_outlined, '/housing', emeraldGreen, routeToIndexMap),
                    _buildFeatureCard(context, 'Join Community',
                        Icons.people_outline, '/community', emeraldGreen, routeToIndexMap),
                    _buildFeatureCard(context, 'Chat with Us',
                        Icons.chat_bubble_outline, '/chatbot', emeraldGreen, routeToIndexMap),
                    _buildFeatureCard(context, 'About Us',
                        Icons.info_outline, '/aboutus', emeraldGreen, routeToIndexMap),
                  ],
                ),
              ],
            ),
          ),
          if (supabase.auth.currentUser == null)
            Container(
              color: mintGreen,
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                  vertical: 30.0, horizontal: 20.0),
              child: Column(
                children: [
                  Text(
                    'Ready to Start Your Journey?',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(color: darkGreen),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Sign up today and connect with our vibrant community!',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: darkSlateGray),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/signup');
                        },
                        child: const Text('Sign Up'),
                      ),
                      const SizedBox(width: 15),
                      OutlinedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/signin');
                        },
                        child: const Text('Sign In'),
                      ),
                    ],
                  ),
                ],
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
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          int? targetIndex = routeMap[route];
          if (targetIndex != null) {
            onNavigateToIndex(targetIndex);
          } else {
            print("Error: Route $route not found in index map.");
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(icon, size: 45, color: color),
              const SizedBox(height: 15),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: darkSlateGray,
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}