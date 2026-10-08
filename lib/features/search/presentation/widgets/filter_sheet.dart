import 'package:flutter/material.dart';

import '../../../../app/theme/app_typography.dart';

import '../../../../core/localization/l10n.dart';
import '../../../../core/presentation/widgets/detail_scaffold.dart';
import '../../../categories/presentation/categories_view_model.dart';
import '../search.dart';

/// A content type's name, e.g. "Articles".
String searchTypeLabel(AppLocalizations l10n, SearchContentType type) =>
    switch (type) {
      SearchContentType.quizTopics => l10n.searchTypeQuizTopics,
      SearchContentType.articles => l10n.navArticles,
      SearchContentType.legalUpdates => l10n.legalUpdatesTitle,
    };

/// Content type and category filters (spec 033). Pops the picked filters
/// as a [SearchQuery] on Apply; closing it any other way changes nothing.
class FilterSheet extends StatefulWidget {
  const FilterSheet({
    super.key,
    required this.categories,
    required this.initial,
  });

  /// The backend's categories.
  final List<CategoryData> categories;
  final SearchQuery initial;

  @override
  State<FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<FilterSheet> {
  late final _types = {...widget.initial.types};
  late final _categoryIds = {...widget.initial.categoryIds};

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return SafeArea(
      child: SingleChildScrollView(
        key: const ValueKey('filter.sheet'),
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.filterTitle,
              style: const TextStyle(
                fontSize: 26,
                fontFamily: NyayaFonts.display,
                fontWeight: FontWeight.w700,
                color: brandNavy,
              ),
            ),
            DetailHeading(l10n.filterContentType),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final type in SearchContentType.values)
                  FilterChip(
                    key: ValueKey('filter.type.${type.name}'),
                    label: Text(searchTypeLabel(l10n, type)),
                    selected: _types.contains(type),
                    onSelected: (on) => setState(
                      () => on ? _types.add(type) : _types.remove(type),
                    ),
                  ),
              ],
            ),
            if (widget.categories.isNotEmpty) ...[
              DetailHeading(l10n.filterCategory),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final category in widget.categories)
                    FilterChip(
                      key: ValueKey('filter.category.${category.id}'),
                      label: Text(category.label),
                      selected: _categoryIds.contains(category.id),
                      onSelected: (on) => setState(
                        () => on
                            ? _categoryIds.add(category.id)
                            : _categoryIds.remove(category.id),
                      ),
                    ),
                ],
              ),
            ],
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    key: const ValueKey('filter.clearAll'),
                    onPressed: () => setState(() {
                      _types.clear();
                      _categoryIds.clear();
                    }),
                    child: Text(l10n.filterClearAll),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton(
                    key: const ValueKey('filter.apply'),
                    style: FilledButton.styleFrom(backgroundColor: brandNavy),
                    onPressed: () => Navigator.of(context).pop(
                      SearchQuery(
                        types: {..._types},
                        categoryIds: {..._categoryIds},
                      ),
                    ),
                    child: Text(l10n.filterApply),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
