import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nyaya/app/leaderboard_progress_store.dart';
import 'package:nyaya/features/leaderboard/presentation/leaderboard_journey.dart';
import 'package:nyaya/features/leaderboard/presentation/journey_page.dart';
import 'package:nyaya/features/quiz_question/data/quiz_api.dart';

void main() {
  const quizOne = RemoteQuiz(
    id: 1,
    slug: 'demo-quiz-1',
    title: 'Demo Quiz One',
    totalQuestions: 5,
  );
  const quizTwo = RemoteQuiz(
    id: 2,
    slug: 'demo-quiz-2',
    title: 'Demo Quiz Two',
    totalQuestions: 5,
  );

  final unlockedJourney = LeaderboardJourney(
    stops: [
      const JourneyStop.quiz(
        quiz: quizOne,
        levelNumber: 1,
        isBossLevel: false,
        isCompleted: false,
        isLocked: false,
      ),
      const JourneyStop.quiz(
        quiz: quizTwo,
        levelNumber: 1,
        isBossLevel: false,
        isCompleted: false,
        isLocked: true,
      ),
    ],
  );

  Future<void> pumpPage(
    WidgetTester tester, {
    LeaderboardJourney? journey,
    int credits = LeaderboardProgressStore.maxCredits,
    VoidCallback? onBackPressed,
    VoidCallback? onStartQuizPressed,
    ValueChanged<RemoteQuiz>? onQuizSelected,
    ValueChanged<int>? onChestOpened,
    ValueChanged<int>? onNavigationSelected,
  }) async {
    await tester.pumpWidget(
      MaterialApp(
        home: JourneyPage(
          journey: journey ?? unlockedJourney,
          credits: credits,
          onBackPressed: onBackPressed,
          onStartQuizPressed: onStartQuizPressed,
          onQuizSelected: onQuizSelected,
          onChestOpened: onChestOpened,
          onNavigationSelected: onNavigationSelected,
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  Future<void> scrollToNode(WidgetTester tester, String slug) async {
    await tester.dragUntilVisible(
      find.byKey(ValueKey('journey.node.$slug')),
      find.byType(Scrollable),
      const Offset(0, -200),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('shows the journey heading and a node per quiz', (tester) async {
    await pumpPage(tester);

    expect(find.byKey(const ValueKey('journey.title')), findsOneWidget);
    expect(
      find.byKey(const ValueKey('journey.node.demo-quiz-1')),
      findsOneWidget,
    );

    // The finish banner sits after every stop on the path, well below the
    // fold — scroll it into view before asserting on it.
    await tester.dragUntilVisible(
      find.byKey(const ValueKey('journey.finish')),
      find.byType(Scrollable),
      const Offset(0, -300),
    );
    expect(find.byKey(const ValueKey('journey.finish')), findsOneWidget);
  });

  testWidgets('shows an empty state when the journey has no stops yet', (
    tester,
  ) async {
    await pumpPage(tester, journey: const LeaderboardJourney(stops: []));

    expect(find.byKey(const ValueKey('journey.empty')), findsOneWidget);
  });

  testWidgets(
    'tapping an unlocked node opens a preview, Start Quiz reports it',
    (tester) async {
      RemoteQuiz? selected;
      await pumpPage(tester, onQuizSelected: (quiz) => selected = quiz);

      await scrollToNode(tester, 'demo-quiz-1');
      await tester.tap(find.byKey(const ValueKey('journey.node.demo-quiz-1')));
      await tester.pumpAndSettle();

      expect(
        find.byKey(const ValueKey('journey.preview.start')),
        findsOneWidget,
      );
      expect(selected, isNull);

      await tester.tap(find.byKey(const ValueKey('journey.preview.start')));
      await tester.pumpAndSettle();

      expect(selected?.slug, 'demo-quiz-1');
    },
  );

  testWidgets('cancelling a preview reports nothing', (tester) async {
    RemoteQuiz? selected;
    await pumpPage(tester, onQuizSelected: (quiz) => selected = quiz);

    await scrollToNode(tester, 'demo-quiz-1');
    await tester.tap(find.byKey(const ValueKey('journey.node.demo-quiz-1')));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey('journey.preview.cancel')));
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('journey.preview.cancel')), findsNothing);
    expect(selected, isNull);
  });

  testWidgets('tapping a locked node never opens a preview', (tester) async {
    RemoteQuiz? selected;
    await pumpPage(tester, onQuizSelected: (quiz) => selected = quiz);

    await tester.dragUntilVisible(
      find.byKey(const ValueKey('journey.node.demo-quiz-2')),
      find.byType(Scrollable),
      const Offset(0, -300),
    );
    await tester.pumpAndSettle();
    await tester.tap(
      find.byKey(const ValueKey('journey.node.demo-quiz-2')),
      warnIfMissed: false,
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('journey.preview.start')), findsNothing);
    expect(selected, isNull);
  });

  testWidgets('without enough credits, Start Quiz is disabled', (tester) async {
    RemoteQuiz? selected;
    await pumpPage(
      tester,
      credits: LeaderboardProgressStore.quizCost - 1,
      onQuizSelected: (quiz) => selected = quiz,
    );

    await scrollToNode(tester, 'demo-quiz-1');
    await tester.tap(find.byKey(const ValueKey('journey.node.demo-quiz-1')));
    await tester.pumpAndSettle();

    final button = tester.widget<ElevatedButton>(
      find.byKey(const ValueKey('journey.preview.start')),
    );
    expect(button.onPressed, isNull);
    expect(selected, isNull);
  });

  testWidgets('tapping an available chest reports its index', (tester) async {
    int? openedIndex;
    final journey = LeaderboardJourney(
      stops: [
        const JourneyStop.chest(
          chestIndex: 0,
          isChestOpened: false,
          isChestAvailable: true,
        ),
      ],
    );
    await pumpPage(
      tester,
      journey: journey,
      onChestOpened: (index) => openedIndex = index,
    );

    await tester.tap(find.byKey(const ValueKey('journey.chest.0')));
    await tester.pumpAndSettle();

    expect(openedIndex, 0);
  });

  testWidgets('tapping an unavailable chest reports nothing', (tester) async {
    int? openedIndex;
    final journey = LeaderboardJourney(
      stops: [
        const JourneyStop.chest(
          chestIndex: 0,
          isChestOpened: false,
          isChestAvailable: false,
        ),
      ],
    );
    await pumpPage(
      tester,
      journey: journey,
      onChestOpened: (index) => openedIndex = index,
    );

    await tester.tap(find.byKey(const ValueKey('journey.chest.0')));
    await tester.pumpAndSettle();

    expect(openedIndex, isNull);
  });

  testWidgets('shows the credits balance', (tester) async {
    await pumpPage(tester, credits: 42);

    expect(find.text('42'), findsOneWidget);
  });

  testWidgets('Continue opens the current stop instead of reporting', (
    tester,
  ) async {
    var started = false;
    await pumpPage(tester, onStartQuizPressed: () => started = true);

    await tester.tap(find.byKey(const ValueKey('journey.startQuiz')));
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('journey.preview.start')), findsOneWidget);
    expect(started, isFalse);
  });

  testWidgets('with nothing left to continue, Start Quiz reports it', (
    tester,
  ) async {
    var started = false;
    await pumpPage(
      tester,
      journey: const LeaderboardJourney(stops: []),
      onStartQuizPressed: () => started = true,
    );

    await tester.tap(find.byKey(const ValueKey('journey.startQuiz')));
    await tester.pumpAndSettle();

    expect(started, isTrue);
  });

  testWidgets('tapping the back button reports it', (tester) async {
    var backPressed = false;
    await pumpPage(tester, onBackPressed: () => backPressed = true);

    await tester.tap(find.byKey(const ValueKey('journey.back')));
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
