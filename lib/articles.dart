import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'theme.dart';

class ArticlesPageContent extends StatefulWidget {
  final int? initialArticleIndex;
  const ArticlesPageContent({super.key, this.initialArticleIndex});

  static Future<List<Map<String, dynamic>>> loadArticlesFromJson() async {
    final jsonString = await rootBundle.loadString('lib/assets/files/articles.json');
    final List<dynamic> jsonList = json.decode(jsonString);
    return jsonList.cast<Map<String, dynamic>>();
  }

  static Future<List<Map<String, dynamic>>> articlesForHome() async {
    return await loadArticlesFromJson();
  }

  @override
  State<ArticlesPageContent> createState() => _ArticlesPageContentState();
}

class _ArticlesPageContentState extends State<ArticlesPageContent> {
  List<Map<String, dynamic>> _articles = [];
  String _searchQuery = '';
  String _sortOption = 'Date (Newest)';
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadArticles();
  }

  void _loadArticles() async {
    try {
      final data = await ArticlesPageContent.loadArticlesFromJson();
      if (!mounted) return;
      setState(() {
        _articles = data;
        _loading = false;
      });
      if (widget.initialArticleIndex != null && widget.initialArticleIndex! >= 0 && widget.initialArticleIndex! < _articles.length) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ArticleDetailPage(article: _articles[widget.initialArticleIndex!]),
            ),
          );
        });
      }
    } catch (e) {
      debugPrint('Error loading articles: $e');
      if (!mounted) return;
      setState(() {
        _loading = false;
      });
    }
  }

  List<Map<String, dynamic>> _getSortedArticles(List<Map<String, dynamic>> articles) {
    List<Map<String, dynamic>> sorted = List.from(articles);
    if (_sortOption == 'Author (A-Z)') {
      sorted.sort((a, b) => (a['author'] ?? '').toString().toLowerCase().compareTo((b['author'] ?? '').toString().toLowerCase()));
    } else if (_sortOption == 'Author (Z-A)') {
      sorted.sort((a, b) => (b['author'] ?? '').toString().toLowerCase().compareTo((a['author'] ?? '').toString().toLowerCase()));
    } else if (_sortOption == 'Date (Newest)') {
      sorted.sort((a, b) => DateTime.parse(_parseDate(b['date'] ?? '')).compareTo(DateTime.parse(_parseDate(a['date'] ?? ''))));
    } else if (_sortOption == 'Date (Oldest)') {
      sorted.sort((a, b) => DateTime.parse(_parseDate(a['date'] ?? '')).compareTo(DateTime.parse(_parseDate(b['date'] ?? ''))));
    }
    return sorted;
  }

  String _parseDate(String dateStr) {
    try {
      return DateTime.parse(dateStr).toIso8601String();
    } catch (_) {
      try {
        final parts = dateStr.split(' ');
        if (parts.length == 3) {
          final month = parts[0];
          final day = parts[1].replaceAll(',', '');
          final year = parts[2];
          return DateTime.parse('$year-${_monthToNum(month)}-$day').toIso8601String();
        }
      } catch (_) {}
    }
    return DateTime.now().toIso8601String();
  }

  String _monthToNum(String month) {
    const months = {
      'January': '01', 'February': '02', 'March': '03', 'April': '04', 'May': '05', 'June': '06',
      'July': '07', 'August': '08', 'September': '09', 'October': '10', 'November': '11', 'December': '12',
    };
    return months[month] ?? '01';
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    final filteredArticles = _articles.where((article) {
      final query = _searchQuery.toLowerCase();
      final title = (article['title'] ?? '').toString().toLowerCase();
      final summary = (article['summary'] ?? '').toString().toLowerCase();
      final content = (article['content'] ?? '').toString().toLowerCase();
      return title.contains(query) || summary.contains(query) || content.contains(query);
    }).toList();
    final sortedArticles = _getSortedArticles(filteredArticles);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search articles...',
                    prefixIcon: Icon(Icons.search, color: emeraldGreen),
                    filled: true,
                    fillColor: lightGrey,
                    contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 18),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onChanged: (value) => setState(() => _searchQuery = value),
                ),
              ),
              const SizedBox(width: 12),
              DropdownButton<String>(
                value: _sortOption,
                items: const [
                  DropdownMenuItem(value: 'Date (Newest)', child: Text('Newest')),
                  DropdownMenuItem(value: 'Date (Oldest)', child: Text('Oldest')),
                  DropdownMenuItem(value: 'Author (A-Z)', child: Text('Author A-Z')),
                  DropdownMenuItem(value: 'Author (Z-A)', child: Text('Author Z-A')),
                ],
                onChanged: (value) {
                  if (value != null) setState(() => _sortOption = value);
                },
                underline: const SizedBox(),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: darkSlateGray),
                borderRadius: BorderRadius.circular(10),
              ),
            ],
          ),
        ),
        Expanded(
          child: sortedArticles.isEmpty
              ? Center(
                  child: Text(
                    'No articles found.',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: mediumGrey),
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemCount: sortedArticles.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 18),
                  itemBuilder: (context, index) {
                    final article = sortedArticles[index];
                    return GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ArticleDetailPage(article: article),
                        ),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
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
                        child: Padding(
                          padding: const EdgeInsets.all(18),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                radius: 22,
                                backgroundImage: AssetImage((article['image'] ?? 'lib/assets/images/aditya.jpg').toString()),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      (article['title'] ?? 'Untitled').toString(),
                                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                            color: darkGreen,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 17,
                                          ),
                                    ),
                                    const SizedBox(height: 6),
                                    Row(
                                      children: [
                                        Text(
                                          (article['author'] ?? 'Unknown').toString(),
                                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                                color: mediumGrey,
                                                fontWeight: FontWeight.w600,
                                              ),
                                        ),
                                        const SizedBox(width: 10),
                                        Icon(Icons.access_time, size: 15, color: mediumGrey),
                                        const SizedBox(width: 2),
                                        Text(
                                          (article['date'] ?? '').toString(),
                                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                                color: mediumGrey,
                                              ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      (article['summary'] ?? '').toString(),
                                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                            color: darkSlateGray.withOpacity(0.85),
                                          ),
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
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
      ],
    );
  }
}

class ArticleDetailPage extends StatelessWidget {
  final Map<String, dynamic> article;
  const ArticleDetailPage({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        title: Text(
          (article['title'] ?? 'Untitled').toString(),
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontFamily: GoogleFonts.poppins().fontFamily,
                color: darkSlateGray,
              ),
        ),
        backgroundColor: whiteColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: darkSlateGray),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundImage: AssetImage((article['image'] ?? 'lib/assets/images/aditya.jpg').toString()),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      (article['author'] ?? 'Unknown').toString(),
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: darkGreen,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    Text(
                      (article['date'] ?? '').toString(),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: mediumGrey,
                          ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              (article['title'] ?? 'Untitled').toString(),
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: emeraldGreen,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 18),
            MarkdownBody(
              data: (article['content'] ?? '').toString(),
              styleSheet: MarkdownStyleSheet(
                p: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: darkSlateGray,
                      fontSize: 17,
                    ),
                strong: const TextStyle(fontWeight: FontWeight.bold),
                h1: Theme.of(context).textTheme.titleLarge,
                h2: Theme.of(context).textTheme.titleMedium,
                h3: Theme.of(context).textTheme.titleSmall,
                listBullet: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
