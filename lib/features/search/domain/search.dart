import 'package:flutter/foundation.dart';

import '../../articles/data/articles_repository.dart';
import '../../categories/presentation/categories_view_model.dart';
import '../../legal_updates/data/legal_updates_repository.dart';

/// Kinds of content search covers.
enum SearchContentType { categories, articles, legalUpdates }

/// What the learner searched for. Empty [types] means every kind; empty
/// [categoryIds] means any category.
@immutable
class SearchQuery {
  const SearchQuery({
    this.text = '',
    this.types = const {},
    this.categoryIds = const {},
  });

  final String text;
  final Set<SearchContentType> types;
  final Set<int> categoryIds;

  /// Filters picked in the sheet (not the text).
  int get filterCount => types.length + categoryIds.length;

  SearchQuery withText(String text) =>
      SearchQuery(text: text, types: types, categoryIds: categoryIds);

  SearchQuery withFilters({
    required Set<SearchContentType> types,
    required Set<int> categoryIds,
  }) => SearchQuery(text: text, types: types, categoryIds: categoryIds);

  /// The same text with every filter off.
  SearchQuery clearFilters() => SearchQuery(text: text);

  bool includes(SearchContentType type) =>
      types.isEmpty || types.contains(type);

  @override
  bool operator ==(Object other) =>
      other is SearchQuery &&
      other.text == text &&
      setEquals(other.types, types) &&
      setEquals(other.categoryIds, categoryIds);

  @override
  int get hashCode => Object.hash(
    text,
    Object.hashAllUnordered(types),
    Object.hashAllUnordered(categoryIds),
  );
}

/// Everything search looks through.
class SearchSources {
  const SearchSources({
    this.categories = const [],
    this.articles = const [],
    this.legalUpdates = const [],
  });

  final List<CategoryData> categories;
  final List<Article> articles;
  final List<LegalUpdate> legalUpdates;
}

/// What matched, by kind.
class SearchResults {
  const SearchResults({
    required this.categories,
    required this.articles,
    required this.legalUpdates,
  });

  final List<CategoryData> categories;
  final List<Article> articles;
  final List<LegalUpdate> legalUpdates;

  bool get isEmpty =>
      categories.isEmpty && articles.isEmpty && legalUpdates.isEmpty;
}

/// Matches [query] against [sources] (spec 033).
///
/// Text matches names, titles and descriptions, ignoring case. A picked
/// category keeps itself, and articles and updates that mention one of
/// its key words (e.g. "criminal" for "Criminal Law"); the backend has no
/// category on articles or updates.
SearchResults search(SearchSources sources, SearchQuery query) {
  final text = query.text.trim().toLowerCase();
  final picked = [
    for (final category in sources.categories)
      if (query.categoryIds.contains(category.id)) category,
  ];
  final keywords = {for (final category in picked) ..._keywords(category)};

  bool matchesText(List<String> fields) =>
      text.isEmpty || fields.any((f) => f.toLowerCase().contains(text));

  bool mentionsPicked(List<String> fields) =>
      picked.isEmpty ||
      fields.any((f) => keywords.any(f.toLowerCase().contains));

  return SearchResults(
    categories: [
      if (query.includes(SearchContentType.categories))
        for (final category in sources.categories)
          if (matchesText([category.label]) &&
              (picked.isEmpty || query.categoryIds.contains(category.id)))
            category,
    ],
    articles: [
      if (query.includes(SearchContentType.articles))
        for (final article in sources.articles)
          if (matchesText(_articleText(article)) &&
              mentionsPicked(_articleText(article)))
            article,
    ],
    legalUpdates: [
      if (query.includes(SearchContentType.legalUpdates))
        for (final update in sources.legalUpdates)
          if (matchesText(_updateText(update)) &&
              mentionsPicked(_updateText(update)))
            update,
    ],
  );
}

List<String> _articleText(Article article) => [
  article.title,
  article.description,
  article.partTitle,
  article.articleRange,
];

List<String> _updateText(LegalUpdate update) => [
  update.title,
  update.summary,
  update.category,
];

/// Words that identify a category: longer than 3 letters, minus "law".
Set<String> _keywords(CategoryData category) => {
  for (final word in category.label.toLowerCase().split(RegExp(r'[^a-z]+')))
    if (word.length > 3 && word != 'laws') word,
};
