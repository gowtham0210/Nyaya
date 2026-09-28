import 'package:flutter/material.dart';

import '../../../../core/localization/l10n.dart';
import '../../../../core/presentation/widgets/detail_scaffold.dart';
import '../../../categories/presentation/categories_view_model.dart';
import '../../domain/search.dart';

/// What the filter sheet returns on Apply.
class FilterChoice {
  const FilterChoice({required this.types, required this.categoryIds});

  final Set<SearchContentType> types;
  final Set<int> categoryIds;
}

/// Content type and category filters (spec 033). Pops a [FilterChoice] on
/// Apply; closing it any other way changes nothing.
class FilterSheet extends StatefulWidget {
  const FilterSheet({
    super.key,
    required this.categories,
    required this.initial,
  });

  /// The backend's categories.
  final List<CategoryData> categories;
  final FilterChoice initial;

  @override
  State<FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<FilterSheet> {
  late final _types = {...widget.initial.types};
  late final _categoryIds = {...widget.initial.categoryIds};

  static String typeLabel(AppLocalizations l10n, SearchContentType type) =>
      switch (type) {
        SearchContentType.categories => l10n.searchTypeCategories,
        SearchContentType.articles => l10n.navArticles,
        SearchContentType.legalUpdates => l10n.legalUpdatesTitle,
      };

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
                fontSize: 20,
                fontWeight: FontWeight.w800,
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
                    label: Text(typeLabel(l10n, type)),
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
                      FilterChoice(
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
