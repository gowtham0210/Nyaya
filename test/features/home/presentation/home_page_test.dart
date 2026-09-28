import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nyaya/features/home/data/daily_questions_repository.dart';
import 'package:nyaya/features/home/presentation/daily_questions_view_model.dart';
import 'package:nyaya/features/home/presentation/home_page.dart';
import 'package:nyaya/features/home/presentation/home_view_model.dart';
import 'package:nyaya/features/legal_updates/data/legal_updates_repository.dart';
import 'package:nyaya/features/legal_updates/presentation/legal_updates_view_model.dart';

import '../../../support/fake_backend.dart';

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

    final dailyQuestions = DailyQuestionsViewModel(
      repository: DailyQuestionsRepository(
        fakeBackend({
          '/daily-questions/random': {'items': []},
        }),
      ),
    );
    addTearDown(dailyQuestions.dispose);
    final legalUpdates = LegalUpdatesViewModel(
      repository: LegalUpdatesRepository(
        fakeBackend({
          '/legal-updates': {'items': []},
        }),
      ),
    );
    addTearDown(legalUpdates.dispose);

    await tester.pumpWidget(
      MaterialApp(
        home: HomePage(
          viewModel: const HomeViewModel(),
          dailyQuestions: dailyQuestions,
          legalUpdates: legalUpdates,
        ),
      ),
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
    expect(
      find.descendant(
        of: find.byKey(const ValueKey('home.continue.card')),
        matching: find.text('15 Questions'),
      ),
      findsOneWidget,
    );
    expect(find.text('65%'), findsOneWidget);
    expect(find.text('Resume'), findsOneWidget);
  });

  testWidgets(
    'AC-006 through AC-008 and AC-010 show scrollable popular quizzes',
    (WidgetTester tester) async {
      await pumpHomePage(tester, size: const Size(360, 780));

      await tester.scrollUntilVisible(
        find.byKey(const ValueKey('home.section.popular')),
        160,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();
      expect(
        find.byKey(const ValueKey('home.section.popular')),
        findsOneWidget,
      );
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
    },
  );
}
