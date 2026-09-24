import 'package:flutter/material.dart';

import '../localization/app_strings.dart';
import '../repositories/articles_repository.dart';
import '../theme/app_colors.dart';

enum FilterContentType { all, lawsActs, articles, legalUpdates }

/// Category groups offered in the sheet, with the keywords used to match
/// real content text (there is no per-item category tag for these groups).
class FilterCategory {
  const FilterCategory(this.key, this.icon, this.keywords);
  final String key;
  final IconData icon;
  final List<String> keywords;
}

const filterCategories = <FilterCategory>[
  FilterCategory('filter_cat_constitution', Icons.account_balance_outlined,
      ['constitution', 'fundamental', 'right', 'article', 'directive', 'citizen', 'equality', 'liberty']),
  FilterCategory('filter_cat_criminal', Icons.shield_outlined,
      ['criminal', 'crime', 'offence', 'offense', 'arrest', 'bail', 'police', 'murder', 'ipc', 'bns', 'punish', 'prison']),
  FilterCategory('filter_cat_civil', Icons.groups_outlined,
      ['civil', 'contract', 'marriage', 'divorce', 'family', 'inherit', 'succession', 'tort']),
  FilterCategory('filter_cat_consumer', Icons.home_outlined,
      ['consumer', 'property', 'land', 'tenant', 'rent', 'real estate', 'rera', 'ownership']),
  FilterCategory('filter_cat_women', Icons.person_outline,
      ['women', 'woman', 'child', 'minor', 'pocso', 'domestic', 'harassment', 'dowry', 'maternity']),
  FilterCategory('filter_cat_cyber', Icons.laptop_mac_outlined,
      ['cyber', 'online', 'internet', 'digital', 'data', 'privacy', 'electronic', 'it act', 'hacking']),
  FilterCategory('filter_cat_employment', Icons.work_outline,
      ['employ', 'labour', 'labor', 'worker', 'wage', 'workplace', 'industrial', 'salary', 'service']),
  FilterCategory('filter_cat_others', Icons.more_horiz, []),
];

class FilterCriteria {
  const FilterCriteria({
    this.contentType = FilterContentType.all,
    this.categories = const {},
    this.parts = const {},
    this.updateTitles = const {},
  });

  final FilterContentType contentType;
  final Set<String> categories;

  /// Selected article path names (real `partTitle` values) and legal update titles.
  final Set<String> parts;
  final Set<String> updateTitles;

  bool get hasSelection => categories.isNotEmpty || parts.isNotEmpty || updateTitles.isNotEmpty;

  bool get isDefault => contentType == FilterContentType.all && !hasSelection;

  /// True when text matches any selected category. No categories = no narrowing.
  /// Constitution articles always count under the Constitution group.
  bool matches(String title, String body, {bool isConstitution = false}) {
    if (categories.isEmpty) return true;
    final text = '$title $body'.toLowerCase();
    bool hit(FilterCategory c) => c.keywords.any(text.contains);
    for (final c in filterCategories) {
      if (!categories.contains(c.key)) continue;
      if (c.key == 'filter_cat_constitution' && isConstitution) return true;
      if (c.key == 'filter_cat_others') {
        if (!filterCategories.where((o) => o.keywords.isNotEmpty).any(hit) && !isConstitution) return true;
      } else if (hit(c)) {
        return true;
      }
    }
    return false;
  }
}

Future<FilterCriteria?> showFilterSheet(BuildContext context, FilterCriteria initial) {
  return showModalBottomSheet<FilterCriteria>(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.cardBackground,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
    builder: (_) => _FilterSheet(initial: initial),
  );
}

class _FilterSheet extends StatefulWidget {
  const _FilterSheet({required this.initial});
  final FilterCriteria initial;

  @override
  State<_FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<_FilterSheet> {
  late FilterContentType _type = widget.initial.contentType;
  late final Set<String> _cats = {...widget.initial.categories};
  late final Set<String> _parts = {...widget.initial.parts};
  late final Set<String> _titles = {...widget.initial.updateTitles};

  // Real article paths / legal update titles, loaded once from the backend.
  List<String>? _partOptions;
  static const _updateCategories = ['Judgements', 'Legislation', 'Reforms', 'Notices'];
  static const _updateCategoryKeys = {
    'Judgements': 'cat_judgements',
    'Legislation': 'cat_legislation',
    'Reforms': 'cat_reforms',
    'Notices': 'cat_notices',
  };
  bool _optionsFailed = false;

  bool get _showLaws => _type == FilterContentType.all || _type == FilterContentType.lawsActs;
  bool get _showParts => _type == FilterContentType.all || _type == FilterContentType.articles;
  bool get _showTitles => _type == FilterContentType.all || _type == FilterContentType.legalUpdates;

  @override
  void initState() {
    super.initState();
    _loadOptions();
  }

  Future<void> _loadOptions() async {
    try {
      final articles = await ArticlesRepository().getArticles();
      if (!mounted) return;
      setState(() {
        _partOptions = articles.map((a) => a.partTitle).where((t) => t.trim().isNotEmpty).toSet().toList();
      });
    } catch (_) {
      if (mounted) setState(() => _optionsFailed = true);
    }
  }

  Widget _section(String titleKey, List<String>? options, Set<String> selected, {IconData icon = Icons.label_outline, Map<String, String>? labels}) {
    if (options == null) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Center(
          child: _optionsFailed
              ? Text(tr('filter_load_failed'), style: const TextStyle(color: AppColors.muted, fontSize: 13))
              : const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)),
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 12, bottom: 2),
          child: Text(tr(titleKey), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.goldDark)),
        ),
        for (final o in options)
          CheckboxListTile(
            value: selected.contains(o),
            onChanged: (v) => setState(() => v == true ? selected.add(o) : selected.remove(o)),
            activeColor: AppColors.navy,
            controlAffinity: ListTileControlAffinity.trailing,
            contentPadding: EdgeInsets.zero,
            dense: true,
            secondary: Icon(icon, color: AppColors.navy),
            title: Text(labels == null ? o : tr(labels[o]!), style: const TextStyle(fontSize: 14, color: AppColors.navy)),
          ),
      ],
    );
  }

  static const _types = [
    (FilterContentType.all, 'filter_all'),
    (FilterContentType.lawsActs, 'filter_laws_acts'),
    (FilterContentType.articles, 'filter_articles'),
    (FilterContentType.legalUpdates, 'filter_legal_updates'),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.9),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 18, 12, 8),
              child: Row(children: [
                const Icon(Icons.tune_rounded, color: AppColors.navy),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(tr('filter_title'), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.navy)),
                ),
                IconButton(onPressed: () => Navigator.of(context).pop(), icon: const Icon(Icons.close_rounded, color: AppColors.navy)),
              ]),
            ),
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    Text(tr('filter_content_type'), style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.navy)),
                    const SizedBox(height: 10),
                    Wrap(spacing: 8, runSpacing: 8, children: [
                      for (final t in _types)
                        ChoiceChip(
                          label: Text(tr(t.$2)),
                          selected: _type == t.$1,
                          showCheckmark: true,
                          checkmarkColor: Colors.white,
                          selectedColor: AppColors.navy,
                          backgroundColor: AppColors.cardBackground,
                          side: const BorderSide(color: AppColors.beigeBorder),
                          labelStyle: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: _type == t.$1 ? Colors.white : AppColors.navy,
                          ),
                          onSelected: (_) => setState(() => _type = t.$1),
                        ),
                    ]),
                    const SizedBox(height: 20),
                    Text(tr('filter_category'), style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.navy)),
                    const SizedBox(height: 4),
                    if (_showLaws)
                    for (final c in filterCategories)
                      CheckboxListTile(
                        value: _cats.contains(c.key),
                        onChanged: (v) => setState(() => v == true ? _cats.add(c.key) : _cats.remove(c.key)),
                        activeColor: AppColors.navy,
                        controlAffinity: ListTileControlAffinity.trailing,
                        contentPadding: EdgeInsets.zero,
                        dense: true,
                        secondary: Icon(c.icon, color: AppColors.navy),
                        title: Text(tr(c.key), style: const TextStyle(fontSize: 14, color: AppColors.navy)),
                      ),
                    if (_showParts) _section('filter_group_article_paths', _partOptions, _parts, icon: Icons.menu_book_outlined),
                    if (_showTitles) _section('filter_group_legal_updates', _updateCategories, _titles, icon: Icons.gavel_outlined, labels: _updateCategoryKeys),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
              child: Row(children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => setState(() {
                      _type = FilterContentType.all;
                      _cats.clear();
                      _parts.clear();
                      _titles.clear();
                    }),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.navy,
                      side: const BorderSide(color: AppColors.beigeBorder),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text(tr('filter_clear_all')),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(FilterCriteria(
                      contentType: _type,
                      categories: _showLaws ? {..._cats} : {},
                      parts: _showParts ? {..._parts} : {},
                      updateTitles: _showTitles ? {..._titles} : {},
                    )),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.navy,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text(tr('filter_apply')),
                  ),
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
