import 'package:flutter/foundation.dart';

import '../../../core/presentation/load_state.dart';
import '../../../core/presentation/load_state_notifier.dart';
import '../../articles/presentation/articles_view_model.dart';
import '../../categories/presentation/categories_view_model.dart';
import '../../legal_updates/presentation/legal_updates_view_model.dart';
import 'search.dart';

export 'search.dart';

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

  /// [results] as a load state for `LoadStateView`: the first failure (so
  /// Retry shows even while another source loads), loading, empty when
  /// nothing matches, or the results.
  LoadState<SearchResults> get resultsState {
    for (final source in _sources) {
      if (source.state case Failed(:final error)) {
        return Failed(error);
      }
    }
    if (_sources.any((source) => source.state is Loading)) {
      return const Loading();
    }
    final found = results;
    return found.isEmpty ? const Empty() : Loaded(found);
  }

  /// The backend's categories, for the filter sheet.
  List<CategoryData> get availableCategories => _data(_categories.state);

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
