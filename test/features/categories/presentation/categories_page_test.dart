import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:nyaya/core/network/api_client.dart';
import 'package:nyaya/features/categories/data/categories_repository.dart';
import 'package:nyaya/features/categories/presentation/categories_page.dart';
import 'package:nyaya/features/categories/presentation/categories_view_model.dart';

import '../../../support/fake_backend.dart';

final threeCategories = {
  '/categories': {
    'items': [
      {'id': 1, 'name': 'Constitutional Law', 'slug': 'constitutional-law'},
      {'id': 2, 'name': 'Criminal Law', 'slug': 'criminal-law'},
      {'id': 3, 'name': 'Criminal Procedure', 'slug': 'criminal-procedure'},
    ],
  },
  '/categories/1/quizzes': {
    'items': [
      {'id': 1},
    ],
  },
  '/categories/2/quizzes': {
    'items': [
      {'id': 2},
      {'id': 3},
    ],
  },
  '/categories/3/quizzes': http.Response('{"message":"boom"}', 500),
};

void main() {
  Future<void> pumpCategoriesPage(
    WidgetTester tester,
    ApiClient client, {
    ValueChanged<CategoryData>? onCategorySelected,
    VoidCallback? onFiltersPressed,
  }) async {
    tester.view.physicalSize = const Size(393, 852);
    tester.view.devicePixelRatio = 1;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
    final viewModel = CategoriesViewModel(
      repository: CategoriesRepository(client),
    );
    addTearDown(viewModel.dispose);

    await tester.pumpWidget(
      MaterialApp(
        home: CategoriesPage(
          viewModel: viewModel,
          onCategorySelected: onCategorySelected,
          onFiltersPressed: onFiltersPressed,
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('spec 035 AC-002 an unwired Filters button stays hidden', (
    tester,
  ) async {
    await pumpCategoriesPage(tester, fakeBackend(threeCategories));

    expect(find.byKey(const ValueKey('categories.filter')), findsNothing);
  });

  testWidgets('spec 035 AC-002 a wired Filters button reports taps', (
    tester,
  ) async {
    var taps = 0;
    await pumpCategoriesPage(
      tester,
      fakeBackend(threeCategories),
      onFiltersPressed: () => taps++,
    );

    await tester.tap(find.byKey(const ValueKey('categories.filter')));
    expect(taps, 1);
  });

  testWidgets('AC-001 header renders', (tester) async {
    await pumpCategoriesPage(tester, fakeBackend(threeCategories));

    expect(
      find.byKey(const ValueKey('categories.header.title')),
      findsOneWidget,
    );
  });

  testWidgets(
    'AC-004 (013 AC-002) the grid shows each category with its quiz count',
    (tester) async {
      await pumpCategoriesPage(tester, fakeBackend(threeCategories));

      expect(find.text('Constitutional Law'), findsOneWidget);
      expect(find.text('1 quiz'), findsOneWidget);
      expect(find.text('Criminal Law'), findsOneWidget);
      expect(find.text('2 quizzes'), findsOneWidget);
      // A failed count shows the category without a count.
      expect(find.text('Criminal Procedure'), findsOneWidget);
      expect(
        find.byKey(const ValueKey('categories.card.criminal-procedure.meta')),
        findsNothing,
      );
    },
  );

  testWidgets(
    'AC-005 (013 AC-003, AC-004) search filters the grid and shows the no-match state',
    (tester) async {
      await pumpCategoriesPage(tester, fakeBackend(threeCategories));

      await tester.enterText(
        find.byKey(const ValueKey('categories.search')),
        'CRIMINAL',
      );
      await tester.pumpAndSettle();

      expect(
        find.byKey(const ValueKey('categories.card.criminal-law')),
        findsOneWidget,
      );
      expect(
        find.byKey(const ValueKey('categories.card.constitutional-law')),
        findsNothing,
      );

      await tester.enterText(
        find.byKey(const ValueKey('categories.search')),
        'zzz-no-match',
      );
      await tester.pumpAndSettle();

      expect(find.byKey(const ValueKey('categories.empty')), findsOneWidget);
    },
  );

  testWidgets('AC-006 offline shows a message; Retry loads the categories', (
    tester,
  ) async {
    var online = false;
    final client = ApiClient(
      httpClient: MockClient((request) async {
        if (!online) {
          throw http.ClientException('offline');
        }
        return http.Response(
          request.url.path.endsWith('/categories')
              ? '{"items":[{"id":2,"name":"Criminal Law","slug":"criminal-law"}]}'
              : '{"items":[]}',
          200,
        );
      }),
    );
    await pumpCategoriesPage(tester, client);

    expect(
      find.text(
        "Can't reach the Nyaya server. Check your connection and try again.",
      ),
      findsOneWidget,
    );

    online = true;
    await tester.tap(find.byKey(const ValueKey('loadState.retry')));
    await tester.pumpAndSettle();

    expect(find.text('Criminal Law'), findsOneWidget);
  });

  testWidgets('AC-007 no categories shows the empty state', (tester) async {
    await pumpCategoriesPage(
      tester,
      fakeBackend({
        '/categories': {'items': []},
      }),
    );

    expect(find.byKey(const ValueKey('loadState.empty')), findsOneWidget);
    expect(find.text('No categories yet.'), findsOneWidget);
  });

  testWidgets('013 AC-005 tapping a card reports the category', (tester) async {
    CategoryData? selected;
    await pumpCategoriesPage(
      tester,
      fakeBackend(threeCategories),
      onCategorySelected: (category) => selected = category,
    );

    await tester.tap(
      find.byKey(const ValueKey('categories.card.criminal-law')),
    );
    await tester.pumpAndSettle();

    expect(selected?.id, 2);
  });

  testWidgets('AC-006 a server error shows the generic message with Retry', (
    tester,
  ) async {
    await pumpCategoriesPage(
      tester,
      fakeBackend({
        '/categories': http.Response('{"message":"Database down"}', 500),
      }),
    );

    expect(
      find.text('Something went wrong. Please try again.'),
      findsOneWidget,
    );
    expect(find.byKey(const ValueKey('loadState.retry')), findsOneWidget);
  });

  testWidgets('AC-006 an ended session says so, without Retry', (tester) async {
    await pumpCategoriesPage(
      tester,
      fakeBackend({
        '/categories': http.Response('{"message":"Invalid token"}', 401),
      }),
    );

    expect(
      find.text('Your session has ended. Please sign in again.'),
      findsOneWidget,
    );
    expect(find.byKey(const ValueKey('loadState.retry')), findsNothing);
  });
}
