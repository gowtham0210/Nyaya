import 'package:flutter/material.dart';

import '../localization/app_strings.dart';
import '../models/article.dart';
import '../models/legal_update.dart';
import '../repositories/articles_repository.dart';
import '../repositories/legal_updates_repository.dart';
import '../theme/app_colors.dart';
import '../widgets/filter_sheet.dart';
import 'article_detail_screen.dart';

/// Shows real articles / legal updates narrowed by the Filter sheet choices.
class FilterResultsScreen extends StatefulWidget {
  const FilterResultsScreen({super.key, required this.criteria});

  final FilterCriteria criteria;

  @override
  State<FilterResultsScreen> createState() => _FilterResultsScreenState();
}

class _FilterResultsScreenState extends State<FilterResultsScreen> {
  bool _loading = true;
  bool _failed = false;
  List<Article> _articles = [];
  List<LegalUpdate> _updates = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _failed = false;
    });
    final type = widget.criteria.contentType;
    try {
      final articles = type == FilterContentType.legalUpdates ? <Article>[] : await ArticlesRepository().getArticles();
      final updates = (type == FilterContentType.all || type == FilterContentType.legalUpdates)
          ? await LegalUpdatesRepository().getUpdates()
          : <LegalUpdate>[];
      if (!mounted) return;
      setState(() {
        final c = widget.criteria;
        // Nothing ticked for a group = don't narrow it. In "All", an item shows
        // if it matches any ticked law category, article path or update title.
        final none = !c.hasSelection;
        _articles = articles.where((a) {
          if (none) return true;
          if (type == FilterContentType.articles) return c.parts.isEmpty || c.parts.contains(a.partTitle);
          if (type == FilterContentType.lawsActs) return c.matches(a.title, a.description, isConstitution: true);
          return c.parts.contains(a.partTitle) || (c.categories.isNotEmpty && c.matches(a.title, a.description, isConstitution: true));
        }).toList();
        _updates = updates.where((u) {
          if (none) return true;
          if (type == FilterContentType.legalUpdates) return c.updateTitles.isEmpty || c.updateTitles.contains(u.category);
          return c.updateTitles.contains(u.category) || (c.categories.isNotEmpty && c.matches(u.title, u.summary));
        }).toList();
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _failed = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.cardBackground,
        foregroundColor: AppColors.navy,
        elevation: 0,
        title: Text(tr('filter_results_title'), style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 18)),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _failed
              ? Center(
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    Text(tr('filter_load_failed')),
                    TextButton(onPressed: _load, child: Text(tr('button_retry'))),
                  ]),
                )
              : (_articles.isEmpty && _updates.isEmpty)
                  ? Center(child: Text(tr('filter_no_results'), style: const TextStyle(color: AppColors.muted)))
                  : ListView(
                      padding: const EdgeInsets.all(16),
                      children: [
                        for (var i = 0; i < _articles.length; i++)
                          _ResultTile(
                            tag: tr('filter_articles'),
                            title: _articles[i].title,
                            body: _articles[i].description,
                            onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => ArticleDetailScreen(number: _articles[i].displayOrder, article: _articles[i])),
                            ),
                          ),
                        for (final u in _updates) _ResultTile(tag: u.category, title: u.title, body: u.summary),
                      ],
                    ),
    );
  }
}

class _ResultTile extends StatelessWidget {
  const _ResultTile({required this.tag, required this.title, required this.body, this.onTap});

  final String tag;
  final String title;
  final String body;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.beigeBorder)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(tag, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.gold)),
                const SizedBox(height: 4),
                Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.navy)),
                const SizedBox(height: 4),
                Text(body, maxLines: 3, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 13, color: AppColors.muted)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
