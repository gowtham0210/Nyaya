import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:nyaya/features/articles/data/articles_repository.dart';
import 'package:nyaya/features/articles/presentation/articles_view_model.dart';
import 'package:nyaya/features/categories/data/categories_repository.dart';
import 'package:nyaya/features/categories/presentation/categories_view_model.dart';
import 'package:nyaya/features/legal_updates/data/legal_updates_repository.dart';
import 'package:nyaya/features/legal_updates/presentation/legal_updates_view_model.dart';
import 'package:nyaya/features/search/presentation/search_page.dart';
import 'package:nyaya/features/search/presentation/search_view_model.dart';

import '../../../support/fake_backend.dart';
import '../../../support/localized_app.dart';
import '../../../support/search_backend.dart';

void main() {
  late List<String> picked;

  Future<void> pumpPage(
    WidgetTester tester,
    Map<String, Object> routes, {
    Locale locale = const Locale('en'),
  }) async {
    final client = fakeBackend(routes);
    final categories = CategoriesViewModel(
      repository: CategoriesRepository(client),
    );
    final articles = ArticlesViewModel(repository: ArticlesRepository(client));
    final updates = LegalUpdatesViewModel(
      repository: LegalUpdatesRepository(client),
    );
    final viewModel = SearchViewModel(
      categories: categories,
      articles: articles,
      legalUpdates: updates,
    );
    addTearDown(() {
      viewModel.dispose();
      categories.dispose();
      articles.dispose();
      updates.dispose();
    });
    picked = [];
    await pumpLocalized(
      tester,
      SearchPage(
        viewModel: viewModel,
        onCategorySelected: (c) => picked.add('category ${c.label}'),
        onArticleOpened: (a, _) => picked.add('article ${a.title}'),
      ),
      locale: locale,
    );
  }

  Finder resultsList() => find.byKey(const ValueKey('search.results'));

  testWidgets('shows everything, grouped, before typing', (tester) async {
    await pumpPage(tester, searchRoutes());

    expect(find.text('Criminal Law'), findsOneWidget);
    expect(find.text('Right to Equality'), findsOneWidget);
    expect(find.text('Quiz topics'), findsOneWidget);
    expect(find.text('Articles'), findsOneWidget);
  });

  testWidgets('typing narrows the results', (tester) async {
    await pumpPage(tester, searchRoutes());

    await tester.enterText(find.byKey(const ValueKey('search.field')), 'bail');
    await tester.pumpAndSettle();

    expect(find.text('Bail is the rule in criminal cases'), findsOneWidget);
    expect(find.text('Criminal Law'), findsNothing);
    expect(find.text('Right to Equality'), findsNothing);
  });

  testWidgets('the filter sheet lists real categories and content types; '
      'applying narrows and clearing resets in one tap', (tester) async {
    await pumpPage(tester, searchRoutes());

    await tester.tap(find.byKey(const ValueKey('search.filters')));
    await tester.pumpAndSettle();
    final sheet = find.byKey(const ValueKey('filter.sheet'));
    for (final label in ['Quiz topics', 'Articles', 'Legal Updates']) {
      expect(
        find.descendant(of: sheet, matching: find.text(label)),
        findsOneWidget,
      );
    }
    expect(
      find.descendant(of: sheet, matching: find.text('Tax Law')),
      findsOneWidget,
    );

    await tester.tap(find.byKey(const ValueKey('filter.type.articles')));
    await tester.tap(find.byKey(const ValueKey('filter.category.1')));
    await tester.tap(find.byKey(const ValueKey('filter.apply')));
    await tester.pumpAndSettle();

    expect(find.text('2 filters'), findsOneWidget);
    expect(find.text('Protection against arrest'), findsOneWidget);
    expect(find.text('Right to Equality'), findsNothing);
    expect(find.text('Criminal Law'), findsNothing);

    await tester.tap(find.byKey(const ValueKey('search.clearFilters')));
    await tester.pumpAndSettle();

    expect(find.text('Right to Equality'), findsOneWidget);
    expect(find.byKey(const ValueKey('search.clearFilters')), findsNothing);
  });

  testWidgets('Clear all in the sheet resets its choices', (tester) async {
    await pumpPage(tester, searchRoutes());
    await tester.tap(find.byKey(const ValueKey('search.filters')));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey('filter.type.articles')));
    await tester.tap(find.byKey(const ValueKey('filter.clearAll')));
    await tester.tap(find.byKey(const ValueKey('filter.apply')));
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('search.clearFilters')), findsNothing);
  });

  testWidgets('no match shows the empty state', (tester) async {
    await pumpPage(tester, searchRoutes());

    await tester.enterText(find.byKey(const ValueKey('search.field')), 'zzz');
    await tester.pumpAndSettle();

    expect(
      find.text('Nothing matches. Try other words or clear the filters.'),
      findsOneWidget,
    );
  });

  testWidgets('tapping results reports them', (tester) async {
    await pumpPage(tester, searchRoutes());

    await tester.tap(find.text('Criminal Law'));
    await tester.tap(find.text('Right to Equality'));

    expect(picked, ['category Criminal Law', 'article Right to Equality']);
  });

  testWidgets('a failed source shows Retry, which reloads', (tester) async {
    final routes = searchRoutes()
      ..['/legal-updates'] = http.Response('{"message":"x"}', 500);
    await pumpPage(tester, routes);
    expect(resultsList(), findsNothing);

    routes.addAll(searchRoutes());
    await tester.tap(find.byKey(const ValueKey('loadState.retry')));
    await tester.pumpAndSettle();

    expect(resultsList(), findsOneWidget);
  });

  testWidgets('strings are in Hindi', (tester) async {
    await pumpPage(tester, searchRoutes(), locale: const Locale('hi'));

    expect(find.text('कानून, अधिकार और नवीनतम अपडेट खोजें'), findsOneWidget);
  });
}
