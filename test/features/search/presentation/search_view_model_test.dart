import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:nyaya/core/network/api_client.dart';
import 'package:nyaya/core/presentation/load_state.dart';
import 'package:nyaya/features/articles/data/articles_repository.dart';
import 'package:nyaya/features/articles/presentation/articles_view_model.dart';
import 'package:nyaya/features/categories/data/categories_repository.dart';
import 'package:nyaya/features/categories/presentation/categories_view_model.dart';
import 'package:nyaya/features/legal_updates/data/legal_updates_repository.dart';
import 'package:nyaya/features/legal_updates/presentation/legal_updates_view_model.dart';
import 'package:nyaya/features/search/presentation/search_view_model.dart';

import '../../../support/fake_backend.dart';
import '../../../support/search_backend.dart';

SearchViewModel viewModelWith(ApiClient client) => SearchViewModel(
  categories: CategoriesViewModel(repository: CategoriesRepository(client)),
  articles: ArticlesViewModel(repository: ArticlesRepository(client)),
  legalUpdates: LegalUpdatesViewModel(
    repository: LegalUpdatesRepository(client),
  ),
);

void main() {
  test('loads every source, then searches them', () async {
    final viewModel = viewModelWith(fakeBackend(searchRoutes()));
    expect(viewModel.resultsState, isA<Loading<SearchResults>>());

    await viewModel.load();

    expect(viewModel.resultsState, isA<Loaded<SearchResults>>());
    viewModel.setText('criminal');
    expect(viewModel.results.categories.map((c) => c.label), ['Criminal Law']);
    expect(viewModel.results.articles.map((a) => a.article.id), [2]);
    expect(viewModel.results.legalUpdates.map((u) => u.id), [7]);
  });

  test('filters apply and clear in one step', () async {
    final viewModel = viewModelWith(fakeBackend(searchRoutes()));
    await viewModel.load();

    viewModel.applyFilters(
      types: {SearchContentType.articles},
      categoryIds: {1},
    );
    expect(viewModel.query.filterCount, 2);
    expect(viewModel.results.categories, isEmpty);
    expect(viewModel.results.articles.map((a) => a.article.id), [2]);

    viewModel.clearFilters();
    expect(viewModel.query.filterCount, 0);
    expect(viewModel.results.articles, hasLength(2));
  });

  test('a failed source fails; retry reloads only that one', () async {
    final routes = searchRoutes()
      ..['/articles'] = http.Response('{"message":"x"}', 500);
    final calls = <String>[];
    final viewModel = viewModelWith(
      ApiClient(httpClient: fakeBackendClient(routes, onRequest: calls.add)),
    );

    await viewModel.load();
    expect(viewModel.resultsState, isA<Failed<SearchResults>>());

    routes.addAll(searchRoutes());
    calls.clear();
    await viewModel.retry();
    expect(calls, ['/articles']);
    expect(viewModel.resultsState, isA<Loaded<SearchResults>>());
    expect(viewModel.results.articles, hasLength(2));
  });

  test('shares data with the tabs: no refetch when already loaded', () async {
    var articleCalls = 0;
    final routes = searchRoutes();
    final client = fakeBackend(routes);
    final articles = ArticlesViewModel(
      repository: ArticlesRepository(
        ApiClient(
          httpClient: fakeBackendClient(
            routes,
            onRequest: (path) {
              if (path == '/articles') {
                articleCalls++;
              }
            },
          ),
        ),
      ),
    );
    await articles.ensureLoaded();
    final viewModel = SearchViewModel(
      categories: CategoriesViewModel(repository: CategoriesRepository(client)),
      articles: articles,
      legalUpdates: LegalUpdatesViewModel(
        repository: LegalUpdatesRepository(client),
      ),
    );

    await viewModel.load();

    expect(articleCalls, 1);
  });
}
