import 'package:flutter/foundation.dart';

import '../../articles/data/articles_repository.dart';
import '../../categories/presentation/categories_view_model.dart';
import '../../legal_updates/data/legal_updates_repository.dart';

/// Kinds of content search covers.
enum SearchContentType { quizTopics, articles, legalUpdates }

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

/// An article with its number in the Articles tab list.
typedef NumberedArticle = ({Article article, int number});

/// What matched, by kind.
class SearchResults {
  const SearchResults({
    required this.categories,
    required this.articles,
    required this.legalUpdates,
  });

  final List<CategoryData> categories;
  final List<NumberedArticle> articles;
  final List<LegalUpdate> legalUpdates;

  bool get isEmpty =>
      categories.isEmpty && articles.isEmpty && legalUpdates.isEmpty;
}

/// Matches [query] against [sources] (spec 033).
///
/// Text matches names, titles and descriptions, ignoring case. A picked
/// category keeps itself, and articles and updates that contain one of its
/// key words as a whole word (e.g. "criminal" for "Criminal Law"); the
/// backend has no category on articles or updates.
SearchResults search(SearchSources sources, SearchQuery query) {
  final text = query.text.trim().toLowerCase();
  final picked = [
    for (final category in sources.categories)
      if (query.categoryIds.contains(category.id)) category,
  ];
  final keywords = {for (final category in picked) ..._keywords(category)};

  bool matchesText(List<String> fields) =>
      text.isEmpty || fields.any((f) => f.toLowerCase().contains(text));

  bool mentionsPicked(List<String> fields) {
    if (picked.isEmpty) {
      return true;
    }
    final joined = fields.join(' ').toLowerCase();
    final words = _words(joined).toSet();
    return keywords.any(
      (keyword) => keyword.contains(' ')
          ? joined.contains(keyword)
          : words.contains(keyword),
    );
  }

  return SearchResults(
    categories: [
      if (query.includes(SearchContentType.quizTopics))
        for (final category in sources.categories)
          if (matchesText([category.label]) &&
              (picked.isEmpty || query.categoryIds.contains(category.id)))
            category,
    ],
    articles: [
      if (query.includes(SearchContentType.articles))
        for (final (index, article) in sources.articles.indexed)
          if (matchesText(_articleText(article)) &&
              mentionsPicked(_articleText(article)))
            (article: article, number: index + 1),
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

/// Words too common to identify a category.
const _stopWords = {'law', 'laws', 'act', 'acts', 'and', 'the', 'of'};

/// Words split on spaces and punctuation, in any script.
Iterable<String> _words(String text) =>
    text.split(RegExp(r'[\s\p{P}]+', unicode: true)).where((w) => w.isNotEmpty);

/// A category's identifying words (3+ characters, not [_stopWords]); the
/// whole label when none are left, e.g. "IT Act".
Set<String> _keywords(CategoryData category) {
  final label = category.label.toLowerCase();
  final words = {
    for (final word in _words(label))
      if (word.runes.length >= 3 && !_stopWords.contains(word)) word,
  };
  return words.isEmpty ? {label.trim()} : words;
}
