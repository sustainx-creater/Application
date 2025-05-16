import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import 'package:url_launcher/url_launcher.dart';
import 'theme.dart';

class AboutUsPageContent extends StatelessWidget {
  const AboutUsPageContent({super.key});

  Future<void> _launchUrl(BuildContext context, String url) async {
    final uri = Uri.parse(url);
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open link.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error opening link.')),
      );
    }
  }

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

  void _showContactForm(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: whiteColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Get in Touch',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w700,
                fontSize: 24,
                color: darkSlateGray,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                filled: true,
                fillColor: mediumGrey.withOpacity(0.1),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                filled: true,
                fillColor: mediumGrey.withOpacity(0.1),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              decoration: InputDecoration(
                labelText: 'Message',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                filled: true,
                fillColor: mediumGrey.withOpacity(0.1),
              ),
              maxLines: 4,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Message sent!'),
                    backgroundColor: emeraldGreen,
                  ),
                );
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: emeraldGreen,
                foregroundColor: whiteColor,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                minimumSize: const Size(double.infinity, 50),
              ),
              child: Text(
                'Send Message',
                style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final teamMembers = [
      {
        'name': 'Aditya Pandey',
        'role': 'Developer',
        'bio': 'Passionate about seamless UX.',
        'image': 'lib/assets/images/aditya.jpg',
        'linkedin': 'https://linkedin.com/in/aditya-pa',
        'website': 'https://aditya-pandey.me/',
      },
      {
        'name': 'Georgii Korenkov',
        'role': 'Developer',
        'bio': 'Focused on scalable backends.',
        'image': 'lib/assets/images/georgii.png',
        'linkedin': 'https://www.linkedin.com/in/georgii-korenkov/',
      },
      {
        'name': 'Lohit Uchil',
        'role': 'Developer',
        'bio': 'Crafts intuitive interfaces.',
        'image': 'lib/assets/images/lohit.jpg',
        'linkedin': 'https://www.linkedin.com/in/lohit-uchil/',
      },
      {
        'name': 'Shivansh Bhatnagar',
        'role': 'Developer',
        'bio': 'Driven by mobile innovation.',
        'image': 'lib/assets/images/shivansh.jpg',
        'linkedin': 'https://linkedin.com/in/shivanshbhatnagar',
      },
      {
        'name': 'Vrinda Sharma',
        'role': 'Developer',
        'bio': 'Expert in engaging UI designs.',
        'image': 'lib/assets/images/vrinda.jpg',
        'linkedin': 'https://linkedin.com/in/vrindasharma',
      },
    ];

    final values = [
      {'title': 'Innovation', 'icon': Icons.lightbulb, 'description': 'Pushing boundaries with cutting-edge solutions.'},
      {'title': 'Inclusivity', 'icon': Icons.group, 'description': 'Welcoming everyone to a global community.'},
      {'title': 'Reliability', 'icon': Icons.verified, 'description': 'Trusted support for your journey abroad.'},
    ];

    final testimonials = [
      {
        'quote': 'EZMove made my relocation seamless and stress-free!',
        'author': 'Anna S., Expat',
        'image': 'lib/assets/images/testimonial1.jpg',
      },
      {
        'quote': 'The community feature helped me connect with locals instantly.',
        'author': 'Mark T., Student',
        'image': 'lib/assets/images/testimonial2.jpg',
      },
      {
        'quote': 'A must-have app for anyone moving abroad.',
        'author': 'Priya R., Tourist',
        'image': 'lib/assets/images/testimonial3.jpg',
      },
    ];

    final milestones = [
      {'year': 'Sep 2024', 'event': 'Conceived EZMove, won Citi Upstart spot'},
      {'year': 'Nov 2024', 'event': 'Conducted 100+ user interviews'},
      {'year': 'Jun/Jul 2025', 'event': 'Planned app release in Ireland'},
      {'year': '2026', 'event': 'Expand to USA, EU, Australia'},
    ];

    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.only(
          top: 20,
          bottom: MediaQuery.of(context).padding.bottom + 80,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Section
            Container(
              height: 280,
              width: double.infinity,
              decoration: BoxDecoration(
                color: emeraldGreen,
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(30)),
                boxShadow: [
                  BoxShadow(
                    color: darkSlateGray.withOpacity(0.2),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FadeInDown(
                      duration: const Duration(milliseconds: 1000),
                      child: Text(
                        'About EZMove',
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w900,
                          fontSize: 36,
                          color: whiteColor,
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
                      ),
                    ),
                    const SizedBox(height: 12),
                    FadeInUp(
                      duration: const Duration(milliseconds: 1000),
                      child: Text(
                        'Proudly Built in Ireland',
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                          color: whiteColor.withOpacity(0.9),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Our Story Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: FadeInUp(
                duration: const Duration(milliseconds: 800),
                child: Container(
                  decoration: BoxDecoration(
                    color: whiteColor,
                    border: Border.all(color: emeraldGreen.withOpacity(0.2)),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: darkSlateGray.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Our Story',
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w700,
                          fontSize: 24,
                          color: darkSlateGray,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'EZMove was born in September 2024 as part of the Citi Upstart Initiative, a prestigious competition by the National College of Ireland and Citi Group. Our team of five students in Ireland won a spot to develop a startup idea to simplify relocation. Guided by mentors Suvendu Chatterjee, Kirti Dhemre, Tom Cullen, and Halima Chukur, we refined our concept through feedback at Citi’s office. Proudly built in Ireland, EZMove is set to launch in June/July 2025, helping newcomers settle with ease.',
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                          color: darkSlateGray.withOpacity(0.8),
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () => _launchUrl(context, 'https://www.ncirl.ie/'),
                              child: FadeInUp(
                                duration: const Duration(milliseconds: 1000),
                                child: Image.asset(
                                  'lib/assets/images/nci.png',
                                  height: screenWidth > 600 ? 50 : 40,
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) => Text(
                                    'NCI',
                                    style: GoogleFonts.inter(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                      color: darkSlateGray,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: GestureDetector(
                              onTap: () => _launchUrl(context, 'https://www.citigroup.com/'),
                              child: FadeInUp(
                                duration: const Duration(milliseconds: 1200),
                                child: Image.asset(
                                  'lib/assets/images/citi.png',
                                  height: screenWidth > 600 ? 50 : 40,
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) => Text(
                                    'Citi',
                                    style: GoogleFonts.inter(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                      color: darkSlateGray,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
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
            const SizedBox(height: 20),
            // Mission & Vision Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: FadeInUp(
                duration: const Duration(milliseconds: 800),
                child: Container(
                  decoration: BoxDecoration(
                    color: whiteColor,
                    border: Border.all(color: emeraldGreen.withOpacity(0.2)),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: darkSlateGray.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Our Mission',
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w700,
                          fontSize: 24,
                          color: darkSlateGray,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'EZMove supports tourists, students, and professionals relocating to Ireland by providing housing options, community connections, and verified articles. Based on interviews with 100+ users from 10 fields, we guide you from the decision to move until you’re settled, fostering inclusive communities where users become mentors.',
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                          color: darkSlateGray.withOpacity(0.8),
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Our Vision',
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w700,
                          fontSize: 24,
                          color: darkSlateGray,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'To build a global platform, starting with Ireland, that makes relocation effortless, expanding to the USA, EU, and Australia, while creating vibrant, inclusive communities worldwide.',
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                          color: darkSlateGray.withOpacity(0.8),
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Milestones Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FadeInUp(
                    child: Text(
                      'Our Journey',
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w700,
                        fontSize: 24,
                        color: darkSlateGray,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: milestones.length,
                    itemBuilder: (context, index) {
                      final milestone = milestones[index];
                      return FadeInLeft(
                        duration: Duration(milliseconds: 600 + index * 200),
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                children: [
                                  Container(
                                    width: 16,
                                    height: 16,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: emeraldGreen,
                                    ),
                                  ),
                                  if (index < milestones.length - 1)
                                    Container(
                                      width: 2,
                                      height: 60,
                                      color: emeraldGreen.withOpacity(0.3),
                                    ),
                                ],
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      milestone['year']!,
                                      style: GoogleFonts.inter(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 18,
                                        color: darkSlateGray,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      milestone['event']!,
                                      style: GoogleFonts.inter(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 16,
                                        color: mediumGrey,
                                      ),
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
            const SizedBox(height: 20),
            // Values Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FadeInUp(
                    child: Text(
                      'Our Values',
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w700,
                        fontSize: 24,
                        color: darkSlateGray,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 180,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      clipBehavior: Clip.hardEdge,
                      itemCount: values.length,
                      itemBuilder: (context, index) {
                        final value = values[index];
                        return FadeInRight(
                          duration: Duration(milliseconds: 600 + index * 200),
                          child: Container(
                            width: screenWidth > 600 ? 180 : screenWidth * 0.45,
                            margin: const EdgeInsets.only(right: 12),
                            decoration: BoxDecoration(
                              color: whiteColor,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: emeraldGreen.withOpacity(0.1),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                  radius: 24,
                                  backgroundColor: emeraldGreen.withOpacity(0.1),
                                  child: Icon(value['icon'] as IconData, color: emeraldGreen, size: 28),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  value['title'] as String,
                                  style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18,
                                    color: darkSlateGray,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  value['description'] as String,
                                  style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                    color: mediumGrey,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
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
            // Team Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FadeInUp(
                    child: Text(
                      'Meet Our Team',
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w700,
                        fontSize: 24,
                        color: darkSlateGray,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ConstrainedBox(
                    constraints: const BoxConstraints(), // Remove maxHeight constraint
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      clipBehavior: Clip.hardEdge,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: screenWidth > 600 ? 3 : 2,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                        childAspectRatio: 0.85,
                      ),
                      itemCount: teamMembers.length,
                      itemBuilder: (context, index) {
                        final member = teamMembers[index];
                        return ZoomIn(
                          duration: Duration(milliseconds: 600 + index * 100),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            decoration: BoxDecoration(
                              color: whiteColor,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: emeraldGreen.withOpacity(0.1),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Container(
                                  height: 80,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                                    image: DecorationImage(
                                      image: AssetImage(member['image']!),
                                      fit: BoxFit.cover,
                                      onError: (exception, stackTrace) => const AssetImage('lib/assets/images/placeholder.jpg'),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(4),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        member['name']!,
                                        style: GoogleFonts.inter(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 14,
                                          color: darkSlateGray,
                                        ),
                                        textAlign: TextAlign.center,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        member['role']!,
                                        style: GoogleFonts.inter(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 12,
                                          color: mediumGrey,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        member['bio']!,
                                        style: GoogleFonts.inter(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 10,
                                          color: darkSlateGray.withOpacity(0.7),
                                        ),
                                        textAlign: TextAlign.center,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          IconButton(
                                            icon: Image.asset(
                                              'lib/assets/icons/linkedin.png',
                                              width: 16,
                                              height: 16,
                                              errorBuilder: (context, error, stackTrace) => const Icon(
                                                Icons.link,
                                                color: emeraldGreen,
                                                size: 16,
                                              ),
                                            ),
                                            onPressed: () => _launchUrl(context, member['linkedin']!),
                                            padding: EdgeInsets.zero,
                                            constraints: const BoxConstraints(),
                                          ),
                                          if (member['website'] != null)
                                            IconButton(
                                              icon: const Icon(Icons.language, color: emeraldGreen, size: 16),
                                              onPressed: () => _launchUrl(context, member['website']!),
                                              padding: EdgeInsets.zero,
                                              constraints: const BoxConstraints(),
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
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Community Impact Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: FadeInUp(
                duration: const Duration(milliseconds: 800),
                child: Container(
                  decoration: BoxDecoration(
                    color: whiteColor,
                    border: Border.all(color: emeraldGreen.withOpacity(0.2)),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: darkSlateGray.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Community Impact',
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w700,
                          fontSize: 24,
                          color: darkSlateGray,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'EZMove builds inclusive communities where newcomers become mentors. Once settled, users can guide others from their home countries, sharing insights on housing, culture, and more, creating a cycle of support.',
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                          color: darkSlateGray.withOpacity(0.8),
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => Navigator.pushNamed(context, '/community'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: emeraldGreen,
                          foregroundColor: whiteColor,
                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          minimumSize: const Size(double.infinity, 50),
                        ),
                        child: Text(
                          'Join Our Community',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Testimonials Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FadeInUp(
                    child: Text(
                      'What Our Users Say',
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w700,
                        fontSize: 24,
                        color: darkSlateGray,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 220,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      clipBehavior: Clip.hardEdge,
                      itemCount: testimonials.length,
                      itemBuilder: (context, index) {
                        final testimonial = testimonials[index];
                        return FadeInRight(
                          duration: Duration(milliseconds: 600 + index * 200),
                          child: Container(
                            width: screenWidth > 600 ? 280 : screenWidth * 0.7,
                            margin: const EdgeInsets.only(right: 12),
                            decoration: BoxDecoration(
                              color: whiteColor,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: darkSlateGray.withOpacity(0.05),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                  radius: 24,
                                  backgroundImage: AssetImage(testimonial['image']!),
                                  onBackgroundImageError: (exception, stackTrace) =>
                                      const AssetImage('lib/assets/images/placeholder.jpg'),
                                ),
                                const SizedBox(height: 12),
                                const Icon(Icons.format_quote, color: emeraldGreen, size: 28),
                                const SizedBox(height: 8),
                                Text(
                                  testimonial['quote']!,
                                  style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                    color: darkSlateGray,
                                    height: 1.5,
                                  ),
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const Spacer(),
                                Text(
                                  '— ${testimonial['author']}',
                                  style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                    color: emeraldGreen,
                                  ),
                                ),
                              ],
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
              child: FadeInUp(
                duration: const Duration(milliseconds: 800),
                child: Container(
                  decoration: BoxDecoration(
                    color: whiteColor,
                    border: Border.all(color: emeraldGreen.withOpacity(0.2)),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: darkSlateGray.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Text(
                        'Connect With Us',
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w700,
                          fontSize: 24,
                          color: darkSlateGray,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Pulse(
                        duration: const Duration(milliseconds: 2000),
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.email_outlined, size: 20),
                          label: const Text('Contact Us'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: emeraldGreen,
                            foregroundColor: whiteColor,
                            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            minimumSize: const Size(double.infinity, 56),
                          ),
                          onPressed: () => _contactUs(context),
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.message_outlined, size: 20),
                        label: const Text('Send a Message'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: warmGold,
                          foregroundColor: whiteColor,
                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          minimumSize: const Size(double.infinity, 56),
                        ),
                        onPressed: () => _showContactForm(context),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.email, color: emeraldGreen),
                            onPressed: () => _contactUs(context),
                          ),
                          IconButton(
                            icon: const Icon(Icons.language, color: emeraldGreen),
                            onPressed: () => _launchUrl(context, 'https://sustainax.netlify.app/'),
                          ),
                          IconButton(
                            icon: Image.asset(
                              'lib/assets/icons/linkedin.png',
                              width: 20,
                              height: 20,
                              errorBuilder: (context, error, stackTrace) => const Icon(
                                Icons.link,
                                color: emeraldGreen,
                                size: 20,
                              ),
                            ),
                            onPressed: () => _launchUrl(context, 'https://linkedin.com/company/sustainax'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'teamsustainx@gmail.com\nhttps://sustainax.netlify.app/',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: mediumGrey,
                          height: 1.5,
                        ),
                      ),
                    ],
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