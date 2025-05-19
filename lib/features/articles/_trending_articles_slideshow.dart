import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'articles.dart';
import '../../theme.dart';

class TrendingArticlesSlideshow extends StatefulWidget {
  final Function(int)? onNavigateToIndex;

  const TrendingArticlesSlideshow({super.key, this.onNavigateToIndex});

  @override
  State<TrendingArticlesSlideshow> createState() => _TrendingArticlesSlideshowState();
}

class _TrendingArticlesSlideshowState extends State<TrendingArticlesSlideshow> {
  final PageController _pageController = PageController(viewportFraction: 0.85);
  int _currentPage = 0;
  List<Map<String, dynamic>> trending = [];
  bool _loading = true;
  final Duration autoSlideDuration = const Duration(seconds: 5);

  @override
  void initState() {
    super.initState();
    _loadRandomArticles();
  }

  void _loadRandomArticles() async {
    try {
      final data = await ArticlesPageContent.loadArticlesFromJson();
      if (!mounted) return;
      final random = Random();
      final List<Map<String, dynamic>> shuffled = List.from(data)..shuffle(random);
      setState(() {
        trending = shuffled.take(3).toList();
        _loading = false;
      });
      if (trending.isNotEmpty) {
        _startAutoSlide();
      }
    } catch (e) {
      debugPrint('Error loading articles for slideshow: $e');
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  void _startAutoSlide() {
    if (_loading || trending.isEmpty) return;
    Future.delayed(autoSlideDuration, () {
      if (!mounted || trending.isEmpty) return;
      setState(() {
        _currentPage = (_currentPage + 1) % trending.length;
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      });
      _startAutoSlide();
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (trending.isEmpty) {
      return const Center(child: Text('No trending articles found.'));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Text(
            "Trending Articles",
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w700,
              fontSize: 22,
              color: darkSlateGray, // optional: theme.textTheme.displaySmall?.color
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 210,
          child: PageView.builder(
            controller: _pageController,
            itemCount: trending.length,
            onPageChanged: (i) => setState(() => _currentPage = i),
            itemBuilder: (context, i) {
              final article = trending[i];
              return GestureDetector(
                onTap: () {
                  widget.onNavigateToIndex?.call(4);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ArticleDetailPage(article: article),
                    ),
                  );
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: EdgeInsets.symmetric(horizontal: 8, vertical: _currentPage == i ? 0 : 16),
                  decoration: BoxDecoration(
                    color: whiteColor, // or theme.scaffoldBackgroundColor
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: darkSlateGray.withOpacity(0.08),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                    border: Border.all(
                      color: emeraldGreen.withOpacity(_currentPage == i ? 0.5 : 0.15),
                      width: 2,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          (article['headline'] ?? article['title'] ?? 'Untitled').toString(),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                            color: darkSlateGray,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          (article['summary'] ?? article['content'] ?? '')
                                  .toString()
                                  .replaceAll(RegExp(r'[#*\-\n]'), '')
                                  .substring(
                                    0,
                                    (article['summary'] ?? article['content'] ?? '')
                                                .toString()
                                                .length >
                                            80
                                        ? 80
                                        : (article['summary'] ?? article['content'] ?? '')
                                            .toString()
                                            .length,
                                  ) +
                              ((article['summary'] ?? article['content'] ?? '')
                                          .toString()
                                          .length >
                                      80
                                  ? '...'
                                  : ''),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w400,
                            fontSize: 13,
                            color: mediumGrey.withOpacity(0.9),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'By ${article['author'] ?? 'Unknown'}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                            color: darkSlateGray,
                          ),
                        ),
                        Text(
                          (article['date'] ?? '').toString(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w400,
                            fontSize: 12,
                            color: mediumGrey,
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
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            trending.length,
            (i) => Container(
              width: 10,
              height: 10,
              margin: const EdgeInsets.symmetric(horizontal: 3),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: i == _currentPage
                    ? emeraldGreen
                    : mediumGrey.withOpacity(0.3),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
