import 'package:flutter/foundation.dart';

import '../../../core/presentation/load_state.dart';
import '../../../core/presentation/load_state_notifier.dart';
import '../../articles/presentation/articles_view_model.dart';
import '../../categories/presentation/categories_view_model.dart';
import '../../legal_updates/presentation/legal_updates_view_model.dart';
import '../domain/search.dart';

export '../domain/search.dart';

enum SearchStatus { loading, ready, failed }

/// Search and filters (spec 033) over the data the tabs already load; it
/// shares their view models, so nothing is fetched twice.
class SearchViewModel extends ChangeNotifier {
  SearchViewModel({
    required CategoriesViewModel categories,
    required ArticlesViewModel articles,
    required LegalUpdatesViewModel legalUpdates,
  }) : _categories = categories,
       _articles = articles,
       _legalUpdates = legalUpdates {
    for (final source in _sources) {
      source.addListener(notifyListeners);
    }
  }

  final CategoriesViewModel _categories;
  final ArticlesViewModel _articles;
  final LegalUpdatesViewModel _legalUpdates;

  List<LoadStateNotifier<Object?>> get _sources => [
    _categories,
    _articles,
    _legalUpdates,
  ];

  SearchQuery get query => _query;
  var _query = const SearchQuery();

  /// Loading while any source loads; failed if any failed; else ready.
  SearchStatus get status {
    final states = [for (final source in _sources) source.state];
    if (states.any((s) => s is Loading)) {
      return SearchStatus.loading;
    }
    return states.any((s) => s is Failed)
        ? SearchStatus.failed
        : SearchStatus.ready;
  }

  /// [results] as a load state for `LoadStateView`: the first failure,
  /// loading, empty when nothing matches, or the results.
  LoadState<SearchResults> get resultsState {
    for (final source in _sources) {
      if (source.state case Failed(:final error)) {
        return Failed(error);
      }
    }
    if (status == SearchStatus.loading) {
      return const Loading();
    }
    final found = results;
    return found.isEmpty ? const Empty() : Loaded(found);
  }

  /// The backend's categories, for the filter sheet.
  List<CategoryData> get availableCategories => _data(_categories.state);

  /// An article's number in the Articles tab (1-based, list order).
  int articleNumber(Article article) =>
      _data(_articles.state).indexOf(article) + 1;

  SearchResults get results => search(
    SearchSources(
      categories: _data(_categories.state),
      articles: _data(_articles.state),
      legalUpdates: _data(_legalUpdates.state),
    ),
    _query,
  );

  /// Loads any source not loaded yet.
  Future<void> load() =>
      Future.wait([for (final source in _sources) source.ensureLoaded()]);

  /// Reloads the sources that failed.
  Future<void> retry() => Future.wait([
    for (final source in _sources)
      if (source.state is Failed) source.load(),
  ]);

  void setText(String text) => _set(_query.withText(text));

  void applyFilters({
    required Set<SearchContentType> types,
    required Set<int> categoryIds,
  }) => _set(_query.withFilters(types: types, categoryIds: categoryIds));

  void clearFilters() => _set(_query.clearFilters());

  void _set(SearchQuery query) {
    _query = query;
    notifyListeners();
  }

  static List<T> _data<T>(LoadState<List<T>> state) =>
      state is Loaded<List<T>> ? state.data : const [];

  @override
  void dispose() {
    for (final source in _sources) {
      source.removeListener(notifyListeners);
    }
    super.dispose();
  }
}
