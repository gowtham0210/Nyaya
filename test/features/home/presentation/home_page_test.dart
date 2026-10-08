import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nyaya/features/home/data/daily_questions_repository.dart';
import 'package:nyaya/features/home/presentation/daily_questions_view_model.dart';
import 'package:nyaya/features/home/presentation/home_page.dart';
import 'package:nyaya/features/home/presentation/home_view_model.dart';
import 'package:nyaya/features/legal_updates/data/legal_updates_repository.dart';
import 'package:nyaya/features/legal_updates/presentation/legal_updates_view_model.dart';
import 'package:nyaya/features/profile/data/profile_repository.dart';
import 'package:nyaya/features/profile/presentation/profile_view_model.dart';

import '../../../support/fake_backend.dart';
import '../../../support/home_fixture.dart';
import '../../../support/profile_backend.dart';

void main() {
  Future<void> pumpHomePage(
    WidgetTester tester, {
    Size size = const Size(393, 852),
    FakeViewPadding padding = const FakeViewPadding(top: 59, bottom: 34),
    VoidCallback? onNotificationsPressed,
    ValueChanged<PopularQuizData>? onQuizSelected,
    ProfileViewModel? profile,
    DateTime? now,
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
          '/daily-questions/today': {
            'date': '2026-10-06',
            'answered': false,
            'question': null,
            'result': null,
          },
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
    final sections = quietHomeSections();

    await tester.pumpWidget(
      MaterialApp(
        home: HomePage(
          // A fresh page per pump, so each call loads its own sections.
          key: UniqueKey(),
          viewModel: const HomeViewModel(),
          dailyQuestions: dailyQuestions,
          legalUpdates: legalUpdates,
          progress: sections.progress,
          categories: sections.categories,
          profile: profile,
          clock: () => now ?? DateTime(2026, 10, 6, 9),
          onNotificationsPressed: onNotificationsPressed,
          onQuizSelected: onQuizSelected,
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  ProfileViewModel profileOf({String fullName = 'Asha Rao', int streak = 4}) {
    final profile = ProfileViewModel(
      repository: ProfileRepository(
        fakeBackend(profileRoutes(fullName: fullName, streak: streak)),
      ),
    );
    addTearDown(profile.dispose);
    return profile;
  }

  testWidgets('AC-001 and AC-002 show the header and continue card first', (
    WidgetTester tester,
  ) async {
    await pumpHomePage(tester, onNotificationsPressed: () {});

    expect(find.byKey(const ValueKey('home.header')), findsOneWidget);
    // The wordmark and tagline gave way to a greeting (spec 040).
    expect(find.text('LAW BASED QUIZ APP'), findsNothing);
    expect(
      find.byKey(const ValueKey('home.notification.button')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey('home.notification.badge')),
      findsOneWidget,
    );
    // The Continue Learning card replaced the marketing hero.
    expect(find.byKey(const ValueKey('home.continue.card')), findsOneWidget);
    expect(find.text('Test Your'), findsNothing);
  });

  testWidgets('AC-005 shows continue learning', (WidgetTester tester) async {
    await pumpHomePage(tester);

    // Backend categories only; the sample strip is gone (spec 040).
    expect(find.text('Constitutional Law'), findsNothing);

    await tester.scrollUntilVisible(
      find.byKey(const ValueKey('home.section.continue')),
      160,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('home.section.continue')), findsOneWidget);
    expect(find.byKey(const ValueKey('home.continue.card')), findsOneWidget);
    // Real progress (spec 026); this backend has no attempts yet.
    expect(find.text('No quizzes yet. Take your first quiz!'), findsOneWidget);
  });

  testWidgets(
    'AC-006 through AC-008 and AC-010 show scrollable popular quizzes',
    (WidgetTester tester) async {
      await pumpHomePage(
        tester,
        size: const Size(360, 780),
        onQuizSelected: (_) {},
      );

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

  testWidgets('spec 035 AC-001 unwired bell and popular quizzes stay hidden', (
    WidgetTester tester,
  ) async {
    await pumpHomePage(tester);

    expect(find.byKey(const ValueKey('home.header')), findsOneWidget);
    expect(
      find.byKey(const ValueKey('home.notification.button')),
      findsNothing,
    );
    expect(find.byKey(const ValueKey('home.notification.badge')), findsNothing);

    await tester.scrollUntilVisible(
      find.byKey(const ValueKey('home.section.legalUpdates')),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.byKey(const ValueKey('home.section.popular')), findsNothing);
    expect(find.text('Fundamental Rights Quiz'), findsNothing);
  });

  group('spec 040 header', () {
    testWidgets('AC-001 greets by time of day and first name, with streak', (
      tester,
    ) async {
      await pumpHomePage(tester, profile: profileOf());

      expect(find.text('Good morning'), findsOneWidget);
      expect(find.text('Asha'), findsOneWidget);
      expect(find.text('Asha Rao'), findsNothing);
      final streak = find.byKey(const ValueKey('home.streak'));
      expect(
        find.descendant(of: streak, matching: find.text('4')),
        findsOneWidget,
      );
      expect(tester.getSemantics(streak), isSemantics(label: '4-day streak'));
      expect(
        tester.getSemantics(find.byKey(const ValueKey('home.greeting.name'))),
        isSemantics(label: 'Good morning, Asha', isHeader: true),
      );

      await pumpHomePage(
        tester,
        profile: profileOf(),
        now: DateTime(2026, 10, 6, 14),
      );
      expect(find.text('Good afternoon'), findsOneWidget);

      await pumpHomePage(
        tester,
        profile: profileOf(),
        now: DateTime(2026, 10, 6, 20),
      );
      expect(find.text('Good evening'), findsOneWidget);
    });

    testWidgets('AC-002 no streak hides the chip; no profile, no name', (
      tester,
    ) async {
      await pumpHomePage(tester, profile: profileOf(streak: 0));
      expect(find.text('Asha'), findsOneWidget);
      expect(find.byKey(const ValueKey('home.streak')), findsNothing);

      await pumpHomePage(tester);
      expect(find.text('Good morning'), findsOneWidget);
      expect(find.byKey(const ValueKey('home.greeting.name')), findsNothing);
      expect(find.byKey(const ValueKey('home.streak')), findsNothing);
      expect(tester.takeException(), isNull);
    });

    testWidgets('a long name stays on one line next to the streak', (
      tester,
    ) async {
      tester.platformDispatcher.textScaleFactorTestValue = 1.6;
      addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
      await pumpHomePage(
        tester,
        size: const Size(360, 740),
        profile: profileOf(fullName: 'Venkataramanasubramanian Iyer'),
      );

      expect(tester.takeException(), isNull);
      expect(find.byKey(const ValueKey('home.streak')), findsOneWidget);
    });

    testWidgets('AC-004 sections run content first', (tester) async {
      await pumpHomePage(tester, size: const Size(393, 3000));

      double top(String key) => tester.getTopLeft(find.byKey(ValueKey(key))).dy;
      final order = [
        top('home.section.continue'),
        top('home.section.daily'),
        top('home.section.explore'),
        top('home.section.legalUpdates'),
      ];
      expect(order, [...order]..sort());
    });
  });

  testWidgets('the continue card fits large text on a small phone', (
    tester,
  ) async {
    tester.platformDispatcher.textScaleFactorTestValue = 1.6;
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    await pumpHomePage(tester, size: const Size(360, 740));

    expect(tester.takeException(), isNull);
    expect(find.byKey(const ValueKey('home.continue.resume')), findsOneWidget);
  });
}
