import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:nyaya/core/network/api_client.dart';
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
    expect(viewModel.status, SearchStatus.loading);

    await viewModel.load();

    expect(viewModel.status, SearchStatus.ready);
    viewModel.setText('criminal');
    expect(viewModel.results.categories.map((c) => c.label), ['Criminal Law']);
    expect(viewModel.results.articles.map((a) => a.id), [2]);
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
    expect(viewModel.results.articles.map((a) => a.id), [2]);

    viewModel.clearFilters();
    expect(viewModel.query.filterCount, 0);
    expect(viewModel.results.articles, hasLength(2));
  });

  test('a failed source is the failed status; retry reloads it', () async {
    final routes = searchRoutes()
      ..['/articles'] = http.Response('{"message":"x"}', 500);
    final viewModel = viewModelWith(fakeBackend(routes));

    await viewModel.load();
    expect(viewModel.status, SearchStatus.failed);

    routes.addAll(searchRoutes());
    await viewModel.retry();
    expect(viewModel.status, SearchStatus.ready);
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
