import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/localization/l10n.dart';
import '../../../core/presentation/widgets/detail_scaffold.dart';
import '../../../core/presentation/widgets/load_state_view.dart';
import '../../articles/presentation/articles_view_model.dart';
import '../../categories/presentation/categories_view_model.dart';
import '../../legal_updates/presentation/widgets/legal_update_card.dart';
import 'search_view_model.dart';
import 'widgets/filter_sheet.dart';

/// Search and filters (spec 033): type to search quiz topics, articles and
/// legal updates; narrow by content type and category.
class SearchPage extends StatefulWidget {
  const SearchPage({
    super.key,
    required this.viewModel,
    required this.onCategorySelected,
    required this.onArticleOpened,
  });

  final SearchViewModel viewModel;
  final ValueChanged<CategoryData> onCategorySelected;

  /// An article tapped, with its number in the Articles tab list.
  final void Function(Article article, int number) onArticleOpened;

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  void initState() {
    super.initState();
    widget.viewModel.load();
  }

  Future<void> _openFilters(List<CategoryData> categories) async {
    final query = widget.viewModel.query;
    final picked = await showModalBottomSheet<SearchQuery>(
      context: context,
      isScrollControlled: true,
      builder: (_) => FilterSheet(categories: categories, initial: query),
    );
    if (picked != null) {
      widget.viewModel.applyFilters(
        types: picked.types,
        categoryIds: picked.categoryIds,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return ListenableBuilder(
      listenable: widget.viewModel,
      builder: (context, _) {
        final viewModel = widget.viewModel;
        final filterCount = viewModel.query.filterCount;
        return Scaffold(
          backgroundColor: brandBackground,
          appBar: AppBar(
            backgroundColor: brandBackground,
            foregroundColor: brandNavy,
            surfaceTintColor: Colors.transparent,
            titleSpacing: 0,
            title: TextField(
              key: const ValueKey('search.field'),
              autofocus: true,
              textInputAction: TextInputAction.search,
              onChanged: viewModel.setText,
              decoration: InputDecoration(
                hintText: l10n.searchHint,
                border: InputBorder.none,
              ),
            ),
            actions: [
              IconButton(
                key: const ValueKey('search.filters'),
                tooltip: l10n.searchFilters,
                onPressed: () => _openFilters(viewModel.availableCategories),
                icon: Badge(
                  isLabelVisible: filterCount > 0,
                  label: Text(
                    NumberFormat.decimalPattern(
                      Localizations.localeOf(context).toLanguageTag(),
                    ).format(filterCount),
                  ),
                  child: const Icon(Icons.tune_rounded),
                ),
              ),
            ],
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (filterCount > 0)
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 4, 24, 0),
                  child: Wrap(
                    spacing: 8,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(
                        l10n.searchFiltersActive(filterCount),
                        style: const TextStyle(color: brandSupportText),
                      ),
                      ActionChip(
                        key: const ValueKey('search.clearFilters'),
                        avatar: const Icon(Icons.close_rounded, size: 16),
                        label: Text(l10n.searchClearFilters),
                        onPressed: viewModel.clearFilters,
                      ),
                    ],
                  ),
                ),
              Expanded(
                child: LoadStateView<SearchResults>(
                  state: viewModel.resultsState,
                  onRetry: viewModel.retry,
                  emptyMessage: l10n.searchNoResults,
                  emptyIcon: Icons.search_off_rounded,
                  builder: (context, results) => _Results(
                    results: results,
                    onCategorySelected: widget.onCategorySelected,
                    onArticleOpened: widget.onArticleOpened,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _Results extends StatelessWidget {
  const _Results({
    required this.results,
    required this.onCategorySelected,
    required this.onArticleOpened,
  });

  final SearchResults results;
  final ValueChanged<CategoryData> onCategorySelected;
  final void Function(Article article, int number) onArticleOpened;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return ListView(
      key: const ValueKey('search.results'),
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
      children: [
        if (results.categories.isNotEmpty) ...[
          DetailHeading(searchTypeLabel(l10n, SearchContentType.quizTopics)),
          DetailCard(
            children: [
              for (final category in results.categories)
                ListTile(
                  leading: const Icon(Icons.quiz_outlined),
                  title: Text(category.label),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () => onCategorySelected(category),
                ),
            ],
          ),
        ],
        if (results.articles.isNotEmpty) ...[
          DetailHeading(searchTypeLabel(l10n, SearchContentType.articles)),
          DetailCard(
            children: [
              for (final (:article, :number) in results.articles)
                ListTile(
                  leading: const Icon(Icons.menu_book_outlined),
                  title: Text(article.title),
                  subtitle: Text(article.articleRange),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () => onArticleOpened(article, number),
                ),
            ],
          ),
        ],
        if (results.legalUpdates.isNotEmpty) ...[
          DetailHeading(searchTypeLabel(l10n, SearchContentType.legalUpdates)),
          for (final update in results.legalUpdates) ...[
            LegalUpdateCard(update: update),
            const SizedBox(height: 12),
          ],
        ],
      ],
    );
  }
}
