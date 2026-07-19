import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nyaya/features/home/presentation/home_page.dart';
import 'package:nyaya/features/home/presentation/home_view_model.dart';

void main() {
  Future<void> pumpHomePage(
    WidgetTester tester, {
    Size size = const Size(393, 852),
    FakeViewPadding padding = const FakeViewPadding(top: 59, bottom: 34),
  }) async {
    tester.view.reset();
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1;
    tester.view.padding = padding;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
      tester.view.resetPadding();
    });

    await tester.pumpWidget(
      const MaterialApp(home: HomePage(viewModel: HomeViewModel())),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('AC-001 and AC-002 show the branded header and hero CTA', (
    WidgetTester tester,
  ) async {
    await pumpHomePage(tester);

    expect(find.byKey(const ValueKey('home.header')), findsOneWidget);
    expect(find.byKey(const ValueKey('home.brand')), findsOneWidget);
    expect(
      find.byKey(const ValueKey('home.notification.button')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey('home.notification.badge')),
      findsOneWidget,
    );
    expect(find.byKey(const ValueKey('home.hero')), findsOneWidget);
    expect(find.byKey(const ValueKey('home.hero.cta')), findsOneWidget);
    expect(find.text('Test Your'), findsOneWidget);
    expect(find.text('Legal Knowledge.'), findsOneWidget);
    expect(find.text('Master Justice.'), findsOneWidget);
    expect(find.text('Quizzes on Law. Insights for Life.'), findsOneWidget);
    expect(find.text('Start Quiz'), findsOneWidget);
  });

  testWidgets('AC-003 through AC-005 show categories and continue learning', (
    WidgetTester tester,
  ) async {
    await pumpHomePage(tester);

    expect(find.text('Explore by Category'), findsOneWidget);
    expect(find.text('Constitutional Law'), findsOneWidget);
    expect(find.text('Criminal Law'), findsOneWidget);
    expect(find.text('Civil Law'), findsOneWidget);
    expect(find.text('Contract Law'), findsOneWidget);
    expect(find.text('Legal Reasoning'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.byKey(const ValueKey('home.section.continue')),
      160,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('home.section.continue')), findsOneWidget);
    expect(find.byKey(const ValueKey('home.continue.card')), findsOneWidget);
    expect(find.text('Indian Constitution Quiz'), findsOneWidget);
    expect(find.text('15 Questions'), findsOneWidget);
    expect(find.text('65%'), findsOneWidget);
    expect(find.text('Resume'), findsOneWidget);
  });

  testWidgets('AC-006 through AC-010 show popular quizzes and fixed nav', (
    WidgetTester tester,
  ) async {
    await pumpHomePage(tester, size: const Size(360, 780));

    await tester.scrollUntilVisible(
      find.byKey(const ValueKey('home.section.popular')),
      160,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('home.section.popular')), findsOneWidget);
    expect(find.text('Fundamental Rights Quiz'), findsOneWidget);
    expect(find.text('Medium'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('Indian Penal Code Quiz'),
      140,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    expect(find.text('Indian Penal Code Quiz'), findsOneWidget);
    expect(find.text('Hard'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('Contract Act Quiz'),
      160,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();

    expect(find.text('Contract Act Quiz'), findsOneWidget);
    expect(find.text('Easy'), findsOneWidget);
    expect(find.byKey(const ValueKey('home.bottomNav')), findsOneWidget);
    expect(find.byKey(const ValueKey('home.nav.home.active')), findsOneWidget);
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Categories'), findsOneWidget);
    expect(find.text('Leaderboard'), findsOneWidget);
    expect(find.text('Bookmarks'), findsOneWidget);
    expect(find.text('Profile'), findsOneWidget);
  });
}
