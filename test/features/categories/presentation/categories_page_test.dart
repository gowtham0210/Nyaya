import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nyaya/features/categories/presentation/categories_page.dart';
import 'package:nyaya/features/categories/presentation/categories_view_model.dart';

void main() {
  Future<void> pumpCategoriesPage(
    WidgetTester tester, {
    ValueChanged<CategoryData>? onCategorySelected,
  }) async {
    tester.view.physicalSize = const Size(393, 852);
    tester.view.devicePixelRatio = 1;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      MaterialApp(
        home: CategoriesPage(
          viewModel: const CategoriesViewModel(),
          onCategorySelected: onCategorySelected,
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('AC-001 header renders', (tester) async {
    await pumpCategoriesPage(tester);

    expect(find.text('Categories'), findsWidgets);
    expect(
      find.byKey(const ValueKey('categories.header.title')),
      findsOneWidget,
    );
  });

  testWidgets('AC-002 grid renders a card per category with topic count', (
    tester,
  ) async {
    await pumpCategoriesPage(tester);

    const viewModel = CategoriesViewModel();
    for (final category in viewModel.categories) {
      final finder = find.byKey(ValueKey('categories.card.${category.id}'));
      await tester.scrollUntilVisible(
        finder,
        200,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();
      expect(finder, findsOneWidget);
      expect(find.text('${category.topicCount} topics'), findsOneWidget);
    }
  });

  testWidgets('AC-003 and AC-004 search filters the grid and empty state', (
    tester,
  ) async {
    await pumpCategoriesPage(tester);

    await tester.enterText(
      find.byKey(const ValueKey('categories.search')),
      'criminal',
    );
    await tester.pumpAndSettle();

    expect(
      find.byKey(const ValueKey('categories.card.criminal-law')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey('categories.card.civil-law')),
      findsNothing,
    );

    await tester.enterText(
      find.byKey(const ValueKey('categories.search')),
      'zzz-no-match',
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('categories.empty')), findsOneWidget);
  });

  testWidgets('AC-005 tapping a card reports its id', (tester) async {
    CategoryData? selected;
    await pumpCategoriesPage(
      tester,
      onCategorySelected: (category) => selected = category,
    );

    await tester.tap(
      find.byKey(const ValueKey('categories.card.constitutional-law')),
    );
    await tester.pumpAndSettle();

    expect(selected?.id, 'constitutional-law');
  });
}
