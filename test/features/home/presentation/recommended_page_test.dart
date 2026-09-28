import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:nyaya/features/categories/data/categories_repository.dart';
import 'package:nyaya/features/categories/presentation/categories_view_model.dart';
import 'package:nyaya/features/home/presentation/recommended_page.dart';

import '../../../support/fake_backend.dart';
import '../../../support/localized_app.dart';

Map<String, Object> categoriesBackend(int count) => {
  '/categories': {
    'items': [
      for (var i = 1; i <= count; i++)
        {'id': i, 'name': 'Category $i', 'slug': 'category-$i'},
    ],
  },
  for (var i = 1; i <= count; i++) '/categories/$i/quizzes': {'items': []},
};

void main() {
  Future<CategoriesViewModel> pumpPage(
    WidgetTester tester,
    Map<String, Object> routes, {
    ValueChanged<CategoryData>? onCategorySelected,
  }) async {
    final viewModel = CategoriesViewModel(
      repository: CategoriesRepository(fakeBackend(routes)),
    );
    addTearDown(viewModel.dispose);
    await viewModel.load();
    await pumpLocalized(
      tester,
      RecommendedPage(
        viewModel: viewModel,
        onCategorySelected: onCategorySelected ?? (_) {},
      ),
      locale: const Locale('en'),
    );
    return viewModel;
  }

  testWidgets('AC-007 the grid shows every category and scrolls', (
    tester,
  ) async {
    final selected = <String>[];
    await pumpPage(
      tester,
      categoriesBackend(9),
      onCategorySelected: (category) => selected.add(category.slug),
    );

    expect(find.text('Recommended for you'), findsOneWidget);
    expect(find.text('Category 1'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('Category 9'),
      300,
      scrollable: find.descendant(
        of: find.byKey(const ValueKey('recommended.grid')),
        matching: find.byType(Scrollable),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Category 9'));

    expect(selected, ['category-9']);
  });

  testWidgets('AC-008 no categories shows the empty state', (tester) async {
    await pumpPage(tester, categoriesBackend(0));

    expect(find.text('No categories yet.'), findsOneWidget);
  });

  testWidgets('AC-008 a failure shows Retry, which reloads', (tester) async {
    final routes = <String, Object>{
      '/categories': http.Response('{"message":"boom"}', 500),
    };
    await pumpPage(tester, routes);

    routes.addAll(categoriesBackend(1));
    await tester.tap(find.byKey(const ValueKey('loadState.retry')));
    await tester.pumpAndSettle();

    expect(find.text('Category 1'), findsOneWidget);
  });
}
