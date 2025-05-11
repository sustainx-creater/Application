import 'package:flutter/material.dart';
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
        'image': 'lib/assets/images/georgii.jpg',
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

    return CustomScrollView(
      slivers: [
        // Hero Section
        SliverToBoxAdapter(
          child: Stack(
            children: [
              Container(
                height: 300,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage('https://images.unsplash.com/photo-1516321310768-61f0f2b7c0e2?ixlib=rb-4.0.3&auto=format&fit=crop&w=1350&q=80'),
                    fit: BoxFit.cover,
                    opacity: 0.7,
                  ),
                ),
              ),
              Container(
                height: 300,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [emeraldGreen.withOpacity(0.8), darkGreen.withOpacity(0.8)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Center(
                  child: AnimatedOpacity(
                    opacity: 1.0,
                    duration: const Duration(seconds: 2),
                    child: Text(
                      'About EZMove',
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(
                            color: whiteColor,
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(
                                blurRadius: 10.0,
                                color: Colors.black.withOpacity(0.5),
                                offset: const Offset(2, 2),
                              ),
                            ],
                          ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        // Mission Section
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
              transform: Matrix4.translationValues(0, 0, 0),
              decoration: BoxDecoration(
                color: whiteColor,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(20.0),
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
                    'EZMove is a student-led initiative dedicated to simplifying the transition for students, tourists, and newcomers in a new country. '
                    'We provide a seamless platform offering guidance on housing, local services, safety, and community engagement, ensuring a stress-free experience.',
                    textAlign: TextAlign.justify,
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
        // Team Section
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
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
                const SizedBox(height: 20),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                    childAspectRatio: 0.75,
                  ),
                  itemCount: teamMembers.length,
                  itemBuilder: (context, index) {
                    final member = teamMembers[index];
                    return AnimatedScale(
                      scale: 1.0,
                      duration: const Duration(milliseconds: 300),
                      child: Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                              child: Image.asset(
                                member['image']!,
                                height: 120,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                children: [
                                  Text(
                                    member['name']!,
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: darkGreen,
                                        ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    member['role']!,
                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                          color: Colors.grey[600],
                                        ),
                                  ),
                                  const SizedBox(height: 10),
                                  IconButton(
                                    icon: const Icon(Icons.link, color: emeraldGreen),
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
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        // Contact Section
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                AnimatedOpacity(
                  opacity: 1.0,
                  duration: const Duration(seconds: 1),
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.email_outlined, size: 18),
                    label: const Text('Contact Us'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: emeraldGreen,
                      foregroundColor: whiteColor,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () => _contactUs(context),
                  ),
                ),
                const SizedBox(height: 15),
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
      ],
    );
  }
}
