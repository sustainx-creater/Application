import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:url_launcher/url_launcher.dart';
import 'theme.dart';

class AboutUsPageContent extends StatelessWidget {
  const AboutUsPageContent({super.key});

  Future<void> _contactUs(BuildContext context) async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'teamsustainx@gmail.com',
      queryParameters: {'subject': 'Inquiry via EZMove App'},
    );
    try {
      if (await canLaunchUrl(emailLaunchUri)) {
        await launchUrl(emailLaunchUri);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open email app.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error contacting us.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final teamMembers = [
      {
        'name': 'Aditya Pandey',
        'role': 'Developer',
        'image': 'lib/assets/images/aditya.jpg',
        'linkedin': 'https://linkedin.com/in/aditya-pa',
      },
      {
        'name': 'Georgii Korenkov',
        'role': 'Developer',
        'image': 'lib/assets/images/georgii.png',
        'linkedin': 'https://www.linkedin.com/in/georgii-korenkov/',
      },
      {
        'name': 'Lohit Uchil',
        'role': 'Developer',
        'image': 'lib/assets/images/lohit.jpg',
        'linkedin': 'https://www.linkedin.com/in/lohit-uchil/',
      },
      {
        'name': 'Shivansh Bhatnagar',
        'role': 'Developer',
        'image': 'lib/assets/images/male.jpg',
        'linkedin': 'https://linkedin.com/in/shivanshbhatnagar',
      },
      {
        'name': 'Vrinda Sharma',
        'role': 'Developer',
        'image': 'lib/assets/images/female.jpg',
        'linkedin': 'https://linkedin.com/in/vrindasharma',
      },
    ];

    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.only(
          top: 20,
          bottom: MediaQuery.of(context).padding.bottom + 60, // Account for navigation bar
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Section
            Container(
              height: 250,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [emeraldGreen.withOpacity(0.8), darkGreen.withOpacity(0.8)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
              ),
              child: Center(
                child: AnimationConfiguration.synchronized(
                  duration: const Duration(milliseconds: 1000),
                  child: FadeInAnimation(
                    child: Text(
                      'About EZMove',
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(
                            color: whiteColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 40,
                            letterSpacing: 1.5,
                          ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Mission Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: AnimationConfiguration.staggeredList(
                position: 0,
                duration: const Duration(milliseconds: 800),
                child: SlideAnimation(
                  verticalOffset: 50,
                  child: FadeInAnimation(
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Our Mission',
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                    color: darkGreen,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'EZMove is a student-led initiative dedicated to simplifying the transition for students, tourists, and newcomers in a new country. We provide a seamless platform offering guidance on housing, local services, safety, and community engagement, ensuring a stress-free experience.',
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    color: Colors.black87,
                                    height: 1.5,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Team Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Meet Our Team',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: darkGreen,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 15),
                  AnimationLimiter(
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 0.75, // Increased to give more vertical space
                      ),
                      itemCount: teamMembers.length,
                      itemBuilder: (context, index) {
                        final member = teamMembers[index];
                        return AnimationConfiguration.staggeredGrid(
                          position: index,
                          duration: const Duration(milliseconds: 600),
                          columnCount: MediaQuery.of(context).size.width > 600 ? 3 : 2,
                          child: SlideAnimation(
                            verticalOffset: 50,
                            child: FadeInAnimation(
                              child: Card(
                                elevation: 6,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    ClipRRect(
                                      borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                                      child: Image.asset(
                                        member['image']!,
                                        height: 110, // Reduced height to fit content
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) => Container(
                                          height: 110,
                                          color: Colors.grey[300],
                                          child: Icon(Icons.person, size: 50, color: Colors.grey[600]),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6), // Reduced padding
                                      child: Column(
                                        children: [
                                          Text(
                                            member['name']!,
                                            textAlign: TextAlign.center,
                                            overflow: TextOverflow.ellipsis, // Handle long names
                                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                  color: darkGreen,
                                                  fontSize: 16, // Slightly smaller font
                                                ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            member['role']!,
                                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                                  color: Colors.grey[600],
                                                  fontSize: 14, // Slightly smaller font
                                                ),
                                          ),
                                          const SizedBox(height: 6),
                                          IconButton(
                                            icon: const Icon(Icons.link, color: emeraldGreen, size: 20), // Smaller icon
                                            onPressed: () async {
                                              final url = Uri.parse(member['linkedin']!);
                                              if (await canLaunchUrl(url)) {
                                                await launchUrl(url);
                                              }
                                            },
                                          ),
                                        ],
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
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Contact Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: AnimationConfiguration.staggeredList(
                position: 0,
                duration: const Duration(milliseconds: 800),
                child: SlideAnimation(
                  verticalOffset: 50,
                  child: FadeInAnimation(
                    child: Column(
                      children: [
                        ElevatedButton.icon(
                          icon: const Icon(Icons.email_outlined, size: 18),
                          label: const Text('Contact Us'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: emeraldGreen,
                            foregroundColor: whiteColor,
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            minimumSize: const Size(double.infinity, 50),
                          ),
                          onPressed: () => _contactUs(context),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'teamsustainx@gmail.com\nhttps://sustainax.netlify.app/',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Colors.grey,
                                height: 1.4,
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}