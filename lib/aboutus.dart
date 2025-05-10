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
        print('Could not launch $emailLaunchUri');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open email app.')),
        );
      }
    } catch (e) {
      print('Error launching URL: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error contacting us.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final teamMembers = [
      'Aditya Pandey',
      'Georgii Korenkov',
      'Lohit Uchil',
      'Shivansh Bhatnagar',
      'Vrinda Sharma',
    ];

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Container(
            padding: const EdgeInsets.symmetric(
              vertical: 40.0,
              horizontal: 20.0,
            ),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [emeraldGreen, darkGreen],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Text(
              'About EZMove',
              style: Theme.of(context)
                  .textTheme
                  .displaySmall
                  ?.copyWith(color: whiteColor),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Text(
                  'Our Mission',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 10),
                Text(
                  'EZMove is a student-led initiative aimed at supporting students, tourists, and newcomers settling in a new country. '
                  'Our goal is to make transitions smoother by providing guidance on housing, local services, safety, and community engagement — all in one accessible platform.',
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(color: Colors.black87, height: 1.5),
                ),
                const SizedBox(height: 30),
                Text(
                  'Meet Our Team',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 15),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: teamMembers.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final member = teamMembers[index];
                    return Card(
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: mintGreen,
                          child: Text(
                            member.isNotEmpty ? member[0] : '?',
                            style: const TextStyle(
                              color: darkGreen,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        title: Text(
                          member,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 30),
                Center(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.email_outlined, size: 18),
                    label: const Text('Contact Us'),
                    onPressed: () => _contactUs(context),
                  ),
                ),
                const SizedBox(height: 15),
                const Center(
                  child: Text(
                    'teamsustainx@gmail.com\nhttps://sustainax.netlify.app/',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                      height: 1.4,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ],
    );
  }
}