import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'theme.dart';

class ArticlesPageContent extends StatefulWidget {
  final int? initialArticleIndex;
  const ArticlesPageContent({super.key, this.initialArticleIndex});

  static Future<List<Map<String, dynamic>>> loadArticlesFromJson({bool forceRefresh = false}) async {
    final prefs = await SharedPreferences.getInstance();
    const String cacheKey = 'articles_cache';
    
    // Load from cache if not forcing a refresh
    if (!forceRefresh) {
      final cachedData = prefs.getString(cacheKey);
      if (cachedData != null) {
        debugPrint('Loading articles from cache');
        return json.decode(cachedData).cast<Map<String, dynamic>>();
      }
    }

    // Fetch from JSONBin.io
    const String apiKey = r'$2a$10$bBJtbASA47x.LTUAe6sUAuXcyr5u8zZ1PQHFNu70xX9hMM/rK5Zw2';
    const String binId = '6825a1828960c979a599e646';

    final response = await http.get(
      Uri.parse('https://api.jsonbin.io/v3/b/$binId/latest'),
      headers: {'X-Master-Key': apiKey},
    );

    if (response.statusCode != 200) {
      debugPrint('Failed to load bin: ${response.statusCode} ${response.body}');
      throw Exception('Failed to load articles');
    }

    final data = json.decode(response.body);
    final record = data['record'];

    if (record == null) {
      debugPrint('No data found in bin $binId');
      return [];
    }

    // Handle both single article and list of articles
    final List<Map<String, dynamic>> articles = record is List
        ? record.whereType<Map<String, dynamic>>().toList()
        : [record as Map<String, dynamic>];

    // Cache the articles
    await prefs.setString(cacheKey, json.encode(articles));
    debugPrint('Total articles loaded and cached: ${articles.length}');
    return articles;
  }

  @override
  State<ArticlesPageContent> createState() => _ArticlesPageContentState();
}

class _ArticlesPageContentState extends State<ArticlesPageContent> {
  List<Map<String, dynamic>> _articles = [];
  String _searchQuery = '';
  String _sortOption = 'Date (Newest)';
  bool _loading = true;
  List<String> _selectedTags = [];

  static const List<String> _topTags = [
    'Visa',
    'Public Transport',
    'Healthcare',
    'Part-Time Jobs',
    'Travel',
    'Housing Scam',
    'Employment',
    'International Students',
    'Ireland',
    'Work'
  ];

  @override
  void initState() {
    super.initState();
    _loadArticles();
  }

  void _loadArticles() async {
    try {
      // Load cached articles first
      final cachedData = await ArticlesPageContent.loadArticlesFromJson();
      if (!mounted) return;
      setState(() {
        _articles = cachedData;
        _loading = false;
      });

      // Fetch fresh data in the background
      final freshData = await ArticlesPageContent.loadArticlesFromJson(forceRefresh: true);
      if (!mounted) return;
      if (freshData != cachedData) {
        setState(() {
          _articles = freshData;
        });
      }

      if (widget.initialArticleIndex != null &&
          widget.initialArticleIndex! >= 0 &&
          widget.initialArticleIndex! < _articles.length) {
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
      if (_articles.isEmpty) {
        setState(() {
          _loading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Failed to load articles'),
            backgroundColor: Colors.redAccent,
            action: SnackBarAction(
              label: 'Retry',
              textColor: warmGold,
              onPressed: () => _loadArticles(),
            ),
          ),
        );
      }
    }
  }

  List<Map<String, dynamic>> _getFilteredAndSortedArticles() {
    var filtered = _articles.where((article) {
      final tags = (article['tags'] as List<dynamic>?)?.cast<String>() ?? [];
      final isTagSearch = _searchQuery.startsWith('#');
      final query = isTagSearch ? _searchQuery.substring(1).toLowerCase() : _searchQuery.toLowerCase();

      if (isTagSearch) {
        return tags.any((tag) => tag.toLowerCase().contains(query)) &&
            (_selectedTags.isEmpty || _selectedTags.every((tag) => tags.contains(tag)));
      }

      final title = (article['title'] ?? '').toString().toLowerCase();
      final summary = (article['summary'] ?? '').toString().toLowerCase();
      final content = (article['content'] ?? '').toString().toLowerCase();
      final matchesSearch = title.contains(query) || summary.contains(query) || content.contains(query);
      final matchesTags = _selectedTags.isEmpty || _selectedTags.every((tag) => tags.contains(tag));
      return matchesSearch && matchesTags;
    }).toList();

    if (_sortOption == 'Author (A-Z)') {
      filtered.sort((a, b) => (a['author'] ?? '').toString().toLowerCase().compareTo((b['author'] ?? '').toString().toLowerCase()));
    } else if (_sortOption == 'Author (Z-A)') {
      filtered.sort((a, b) => (b['author'] ?? '').toString().toLowerCase().compareTo((a['author'] ?? '').toString().toLowerCase()));
    } else if (_sortOption == 'Date (Newest)') {
      filtered.sort((a, b) => DateTime.parse(_parseDate(b['date'] ?? '')).compareTo(DateTime.parse(_parseDate(a['date'] ?? ''))));
    } else if (_sortOption == 'Date (Oldest)') {
      filtered.sort((a, b) => DateTime.parse(_parseDate(a['date'] ?? '')).compareTo(DateTime.parse(_parseDate(b['date'] ?? ''))));
    }
    return filtered;
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
      return const Center(child: CircularProgressIndicator(color: emeraldGreen));
    }
    final sortedArticles = _getFilteredAndSortedArticles();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                decoration: InputDecoration(
                  hintText: 'Search or use #tag for tags...',
                  prefixIcon: Icon(
                    _searchQuery.startsWith('#') ? Icons.tag : Icons.search,
                    color: emeraldGreen,
                  ),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: Icon(Icons.clear, color: mediumGrey),
                          onPressed: () => setState(() => _searchQuery = ''),
                        )
                      : null,
                ),
                style: TextStyle(fontFamily: GoogleFonts.inter().fontFamily, fontSize: 16),
                onChanged: (value) => setState(() => _searchQuery = value),
              ),
              const SizedBox(height: 20),
              Text(
                'Top Hashtags',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontFamily: GoogleFonts.inter().fontFamily,
                      color: darkSlateGray,
                    ),
              ),
              const SizedBox(height: 12),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _topTags.map((tag) {
                    final isSelected = _selectedTags.contains(tag);
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        label: Text(
                          tag,
                          style: TextStyle(
                            fontFamily: GoogleFonts.inter().fontFamily,
                            fontSize: 14,
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                            color: isSelected ? emeraldGreen : darkSlateGray,
                          ),
                        ),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            if (selected) {
                              _selectedTags.add(tag);
                            } else {
                              _selectedTags.remove(tag);
                            }
                          });
                        },
                        selectedColor: warmGold.withOpacity(0.2),
                        checkmarkColor: warmGold,
                        backgroundColor: lightGrey,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: BorderSide(color: warmGold.withOpacity(0.3)),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Sort by',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontFamily: GoogleFonts.inter().fontFamily,
                          color: darkSlateGray,
                    ),
                  ),
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
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontFamily: GoogleFonts.inter().fontFamily,
                          color: darkSlateGray,
                        ),
                    dropdownColor: whiteColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: sortedArticles.isEmpty
              ? Center(
                  child: Text(
                    'No articles found.',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontFamily: GoogleFonts.inter().fontFamily,
                          color: mediumGrey,
                        ),
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  itemCount: sortedArticles.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final article = sortedArticles[index];
                    return GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ArticleDetailPage(article: article),
                        ),
                      ),
                      child: Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(color: mintGreen.withOpacity(0.3)),
                        ),
                        color: whiteColor,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                radius: 24,
                                backgroundImage: AssetImage((article['image'] ?? 'lib/assets/images/aditya.jpg').toString()),
                                backgroundColor: lightGrey,
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      (article['title'] ?? 'Untitled').toString(),
                                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                            fontFamily: GoogleFonts.inter().fontFamily,
                                            color: darkSlateGray,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w700,
                                          ),
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Text(
                                          (article['author'] ?? 'Unknown').toString(),
                                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                                fontFamily: GoogleFonts.inter().fontFamily,
                                                color: mediumGrey,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 14,
                                              ),
                                        ),
                                        const SizedBox(width: 12),
                                        Icon(Icons.access_time, size: 16, color: mediumGrey),
                                        const SizedBox(width: 4),
                                        Text(
                                          (article['date'] ?? '').toString(),
                                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                                fontFamily: GoogleFonts.inter().fontFamily,
                                                color: mediumGrey,
                                                fontSize: 14,
                                              ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      (article['summary'] ?? '').toString(),
                                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                            fontFamily: GoogleFonts.inter().fontFamily,
                                            color: darkSlateGray.withOpacity(0.9),
                                            fontSize: 15,
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
    final tags = (article['tags'] as List<dynamic>?)?.cast<String>() ?? [];
    return Scaffold(
      appBar: AppBar(
        title: Text(
          (article['title'] ?? 'Untitled').toString(),
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontFamily: GoogleFonts.inter().fontFamily,
                fontWeight: FontWeight.w700,
              ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage((article['image'] ?? 'lib/assets/images/aditya.jpg').toString()),
                  backgroundColor: lightGrey,
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      (article['author'] ?? 'Unknown').toString(),
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontFamily: GoogleFonts.inter().fontFamily,
                            color: darkSlateGray,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      (article['date'] ?? '').toString(),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontFamily: GoogleFonts.inter().fontFamily,
                            color: mediumGrey,
                            fontSize: 14,
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
                    fontFamily: GoogleFonts.inter().fontFamily,
                    color: darkSlateGray,
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: 24),
            MarkdownBody(
              data: (article['content'] ?? '').toString(),
              styleSheet: MarkdownStyleSheet(
                p: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontFamily: GoogleFonts.inter().fontFamily,
                      color: darkSlateGray,
                      fontSize: 16,
                    ),
                strong: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontFamily: GoogleFonts.inter().fontFamily,
                      color: darkSlateGray,
                      fontWeight: FontWeight.w700,
                    ),
                h1: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontFamily: GoogleFonts.inter().fontFamily,
                      color: darkSlateGray,
                      fontWeight: FontWeight.w700,
                    ),
                h2: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontFamily: GoogleFonts.inter().fontFamily,
                      color: darkSlateGray,
                      fontWeight: FontWeight.w700,
                    ),
                h3: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontFamily: GoogleFonts.inter().fontFamily,
                      color: darkSlateGray,
                      fontWeight: FontWeight.w700,
                    ),
                listBullet: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontFamily: GoogleFonts.inter().fontFamily,
                      color: darkSlateGray,
                      fontSize: 16,
                    ),
                a: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontFamily: GoogleFonts.inter().fontFamily,
                      color: emeraldGreen,
                      decoration: TextDecoration.underline,
                      decorationColor: emeraldGreen,
                    ),
              ),
            ),
            const SizedBox(height: 24),
            if (tags.isNotEmpty) ...[
              Divider(color: warmGold.withOpacity(0.3)),
              const SizedBox(height: 16),
              Text(
                'Hashtags',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontFamily: GoogleFonts.inter().fontFamily,
                      color: darkSlateGray,
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: tags.map((tag) => ActionChip(
                  label: Text(
                    tag,
                    style: TextStyle(
                      fontFamily: GoogleFonts.inter().fontFamily,
                      color: emeraldGreen,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  backgroundColor: mintGreen.withOpacity(0.2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(color: warmGold.withOpacity(0.5)),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  onPressed: () {
                    Navigator.pop(context);
                    (context.findAncestorStateOfType<_ArticlesPageContentState>())?.setState(() {
                      (context.findAncestorStateOfType<_ArticlesPageContentState>())?._searchQuery = '#$tag';
                    });
                  },
                )).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}