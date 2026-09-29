import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nyaya/features/articles/presentation/articles_page.dart';
import 'package:nyaya/features/home/presentation/home_view_model.dart';

void main() {
  Future<void> pumpPage(
    WidgetTester tester, {
    VoidCallback? onBackPressed,
    ValueChanged<HomeCategoryData>? onArticleSelected,
    ValueChanged<int>? onNavigationSelected,
  }) async {
    await tester.pumpWidget(
      MaterialApp(
        home: ArticlesPage(
          onBackPressed: onBackPressed,
          onArticleSelected: onArticleSelected,
          onNavigationSelected: onNavigationSelected,
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  // dragUntilVisible's ballistic drag()+ensureVisible combo gets stuck well
  // before this ListView's actual scroll extent, so scroll by hand instead.
  Future<void> scrollUntilFound(WidgetTester tester, Finder finder) async {
    for (var step = 0; step < 20 && finder.evaluate().isEmpty; step++) {
      await tester.drag(find.byType(Scrollable), const Offset(0, -200));
      await tester.pump();
    }
    await tester.pumpAndSettle();
  }

  testWidgets('shows the hero copy and every category as a numbered row', (
    tester,
  ) async {
    await pumpPage(tester);

    expect(find.byKey(const ValueKey('articles.hero')), findsOneWidget);
    expect(find.text('ARTICLES'), findsOneWidget);
    expect(find.text('Learn. Understand.\nExplore.'), findsOneWidget);

    const viewModel = HomeViewModel();
    for (var i = 0; i < viewModel.categories.length; i++) {
      final category = viewModel.categories[i];
      final rowFinder = find.byKey(ValueKey('articles.item.${category.id}'));
      await scrollUntilFound(tester, rowFinder);

      expect(rowFinder, findsOneWidget);
      expect(find.text('${i + 1}. ${category.label}'), findsOneWidget);
    }
  });

  testWidgets('tapping a topic reports the selected category', (tester) async {
    HomeCategoryData? selected;
    await pumpPage(
      tester,
      onArticleSelected: (category) => selected = category,
    );

    await tester.tap(
      find.byKey(const ValueKey('articles.item.constitutional_law')),
    );
    await tester.pumpAndSettle();

    expect(selected?.id, 'constitutional_law');
  });

  testWidgets('tapping the back button reports it', (tester) async {
    var backPressed = false;
    await pumpPage(tester, onBackPressed: () => backPressed = true);

    await tester.tap(find.byKey(const ValueKey('articles.back')));
    await tester.pumpAndSettle();

    expect(backPressed, isTrue);
  });

  testWidgets('tapping a bottom nav tab reports its index', (tester) async {
    int? selectedIndex;
    await pumpPage(
      tester,
      onNavigationSelected: (index) => selectedIndex = index,
    );

    await tester.tap(find.byKey(const ValueKey('home.nav.home')));
    await tester.pumpAndSettle();

    expect(selectedIndex, 0);
  });
}
