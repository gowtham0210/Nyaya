import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:nyaya/core/network/api_client.dart';
import 'package:nyaya/features/articles/data/articles_repository.dart';
import 'package:nyaya/features/articles/presentation/articles_page.dart';
import 'package:nyaya/features/articles/presentation/articles_view_model.dart';

import '../../../support/fake_backend.dart';
import '../../../support/localized_app.dart';

final twoArticles = <String, Object>{
  '/articles': {
    'items': [
      {
        'id': 1,
        'part': 'I',
        'partTitle': 'The Union',
        'title': 'Name of the Union',
        'articleRange': 'Article 1',
        'description': 'India, that is Bharat.',
        'displayOrder': 1,
      },
      {
        'id': 2,
        'part': 'III',
        'partTitle': 'Fundamental Rights',
        'title': 'Right to Equality',
        'articleRange': 'Articles 14–18',
        'description': 'Equality before law.',
        'whatItMeans': 'Everyone is equal before the law.',
        'displayOrder': 2,
      },
    ],
  },
};

void main() {
  late ArticlesViewModel viewModel;
  late List<Article> opened;

  Future<void> pumpPage(
    WidgetTester tester,
    Map<String, Object> routes, {
    Locale locale = const Locale('en'),
  }) async {
    viewModel = ArticlesViewModel(
      repository: ArticlesRepository(fakeBackend(routes)),
    );
    addTearDown(viewModel.dispose);
    opened = [];
    await pumpLocalized(
      tester,
      ArticlesPage(
        viewModel: viewModel,
        onArticleOpened: (article, _) => opened.add(article),
      ),
      locale: locale,
    );
  }

  testWidgets('AC-003 shows the hero, part headers and numbered articles', (
    tester,
  ) async {
    await pumpPage(tester, twoArticles);

    expect(find.byKey(const ValueKey('articles.hero')), findsOneWidget);
    expect(find.text('Learn & Stay Updated'), findsOneWidget);
    expect(find.text('Part I · The Union'), findsOneWidget);
    expect(find.text('Part III · Fundamental Rights'), findsOneWidget);
    expect(find.text('1. Name of the Union'), findsOneWidget);
    expect(find.text('2. Right to Equality'), findsOneWidget);
  });

  testWidgets('AC-004 tapping expands a preview in place and collapses it', (
    tester,
  ) async {
    await pumpPage(tester, twoArticles);
    final item = find.byKey(const ValueKey('articles.item.2'));

    expect(
      tester.getSemantics(item),
      isSemantics(
        isButton: true,
        hasTapAction: true,
        hasExpandedState: true,
        isExpanded: false,
        label: '2. Right to Equality, Articles 14–18',
      ),
    );
    expect(find.text('Everyone is equal before the law.'), findsNothing);

    await tester.tap(item);
    await tester.pumpAndSettle();
    expect(find.text('Everyone is equal before the law.'), findsOneWidget);
    expect(find.text('Read article'), findsOneWidget);

    await tester.tap(item);
    await tester.pumpAndSettle();
    expect(find.text('Everyone is equal before the law.'), findsNothing);
  });

  testWidgets('AC-004 without whatItMeans the preview is the description', (
    tester,
  ) async {
    await pumpPage(tester, twoArticles);

    await tester.tap(find.byKey(const ValueKey('articles.item.1')));
    await tester.pumpAndSettle();

    expect(find.text('India, that is Bharat.'), findsOneWidget);
  });

  testWidgets('AC-005 Read article reports the article', (tester) async {
    await pumpPage(tester, twoArticles);

    await tester.tap(find.byKey(const ValueKey('articles.item.2')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Read article'));

    expect(opened.single.id, 2);
  });

  testWidgets('AC-006 no articles shows the empty state', (tester) async {
    await pumpPage(tester, {
      '/articles': {'items': []},
    });

    expect(find.text('No articles yet.'), findsOneWidget);
  });

  testWidgets('AC-006 a failure shows Retry, which reloads', (tester) async {
    final routes = <String, Object>{
      '/articles': http.Response('{"message":"boom"}', 500),
    };
    await pumpPage(tester, routes);
    expect(
      find.text('Something went wrong. Please try again.'),
      findsOneWidget,
    );

    routes.addAll(twoArticles);
    await tester.tap(find.byKey(const ValueKey('loadState.retry')));
    await tester.pumpAndSettle();

    expect(find.text('1. Name of the Union'), findsOneWidget);
  });

  testWidgets('AC-007 strings are in Hindi', (tester) async {
    await pumpPage(tester, twoArticles, locale: const Locale('hi'));

    expect(find.text('सीखें और अपडेट रहें'), findsOneWidget);
    expect(find.text('भाग I · The Union'), findsOneWidget);
  });

  testWidgets('FR-001 shows a spinner while loading', (tester) async {
    viewModel = ArticlesViewModel(
      repository: ArticlesRepository(
        ApiClient(
          httpClient: MockClient(
            (_) => Future.delayed(
              const Duration(seconds: 1),
              () => http.Response('{"items":[]}', 200),
            ),
          ),
        ),
      ),
    );
    addTearDown(viewModel.dispose);
    await tester.pumpWidget(
      MaterialApp(
        home: ArticlesPage(viewModel: viewModel, onArticleOpened: (_, _) {}),
      ),
    );

    expect(find.byKey(const ValueKey('loadState.loading')), findsOneWidget);
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();
  });

  testWidgets('articles load in the current language', (tester) async {
    final queries = <String?>[];
    viewModel = ArticlesViewModel(
      repository: ArticlesRepository(
        ApiClient(
          languageCode: () => 'hi',
          httpClient: MockClient((request) async {
            queries.add(request.url.queryParameters['lang']);
            return http.Response('{"items":[]}', 200);
          }),
        ),
      ),
    );
    addTearDown(viewModel.dispose);

    await viewModel.load();

    expect(queries, ['hi']);
  });

  testWidgets('a blank part shows only its title', (tester) async {
    await pumpPage(tester, {
      '/articles': {
        'items': [
          {'id': 1, 'part': '', 'partTitle': 'Preamble', 'title': 'Preamble'},
        ],
      },
    });

    expect(find.text('Preamble'), findsOneWidget);
    expect(find.textContaining('Part'), findsNothing);
  });

  testWidgets('an expanded article fits large text on a small phone', (
    tester,
  ) async {
    tester.platformDispatcher.textScaleFactorTestValue = 1.6;
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    await pumpPage(tester, twoArticles);
    tester.view.physicalSize = const Size(320, 640);
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey('articles.item.2')));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
  });
}
