import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:nyaya/app/api_client.dart';
import 'package:nyaya/app/leaderboard_progress_store.dart';
import 'package:nyaya/features/categories/data/quiz_levels.dart';
import 'package:nyaya/features/categories/presentation/categories_page.dart';
import 'package:nyaya/features/home/presentation/home_view_model.dart';
import 'package:nyaya/features/quiz_question/data/quiz_api.dart';

import '../../../app/leaderboard_progress_store_test.dart' show FakeCreditsBackend;

void main() {
  Future<void> pumpCategoriesPage(
    WidgetTester tester, {
    VoidCallback? onBackPressed,
    ValueChanged<HomeCategoryData>? onCategorySelected,
    ValueChanged<int>? onNavigationSelected,
    Future<List<QuizLevel>> Function()? levelsLoader,
    Future<void> Function(QuizLevel level)? onLevelSelected,
    bool showCategories = false,
  }) async {
    tester.view.physicalSize = const Size(393, 1600);
    tester.view.devicePixelRatio = 1;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      MaterialApp(
        home: CategoriesPage(
          viewModel: const HomeViewModel(),
          showCategoriesFirst: showCategories,
          onBackPressed: onBackPressed,
          onCategorySelected: onCategorySelected,
          onNavigationSelected: onNavigationSelected,
          levelsLoader: levelsLoader ?? () async => const <QuizLevel>[],
          onLevelSelected: onLevelSelected,
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  // Ten levels as the backend returns them: newest first, so out of order.
  final backendLevels = buildQuizLevels([
    for (var n = 10; n >= 1; n--)
      RemoteQuiz(
        id: 100 + n,
        slug: 'legal-awareness-level-$n',
        title: 'Level $n',
        totalQuestions: n % 5 == 0 ? 10 : 5,
        difficulty: n == 10 ? 'hard' : 'easy',
        description: 'Level $n of the Legal Awareness Journey.',
      ),
  ], const []);

  testWidgets('shows every category from the view model', (
    WidgetTester tester,
  ) async {
    await pumpCategoriesPage(tester, showCategories: true);

    for (final category in const HomeViewModel().categories) {
      final finder = find.byKey(ValueKey('categories.card.${category.id}'));
      await tester.scrollUntilVisible(
        finder,
        200,
        scrollable: find.byType(Scrollable).first,
      );
      expect(finder, findsOneWidget);
      expect(find.text(category.label), findsOneWidget);
    }
  });

  testWidgets('tapping a category reports it', (WidgetTester tester) async {
    HomeCategoryData? selected;
    await pumpCategoriesPage(
      tester,
      onCategorySelected: (category) => selected = category,
      showCategories: true,
    );

    final finder = find.byKey(
      const ValueKey('categories.card.environmental_law'),
    );
    // Every card is laid out up front along the road, so it exists before
    // it's on screen — bring it into view rather than just waiting for it.
    await tester.ensureVisible(finder);
    await tester.pumpAndSettle();
    await tester.tap(finder);
    await tester.pumpAndSettle();

    expect(selected?.id, 'environmental_law');
  });

  testWidgets('tapping the back button reports it', (
    WidgetTester tester,
  ) async {
    var backPressed = false;
    await pumpCategoriesPage(tester, onBackPressed: () => backPressed = true);

    await tester.tap(find.byKey(const ValueKey('categories.back')));
    await tester.pumpAndSettle();

    expect(backPressed, isTrue);
  });

  testWidgets('tapping the Home nav tab reports index 0', (
    WidgetTester tester,
  ) async {
    int? tappedIndex;
    await pumpCategoriesPage(
      tester,
      onNavigationSelected: (index) => tappedIndex = index,
    );

    await tester.tap(find.byKey(const ValueKey('home.nav.home')));
    await tester.pumpAndSettle();

    expect(tappedIndex, 0);
  });

  testWidgets('the Quizzes page lists Level 1-10 in order', (
    WidgetTester tester,
  ) async {
    await pumpCategoriesPage(tester, levelsLoader: () async => backendLevels);

    expect(find.byKey(const ValueKey('levels.title')), findsOneWidget);
    double? previousTop;
    for (var n = 1; n <= 10; n++) {
      final card = find.byKey(ValueKey('levels.card.$n'));
      await tester.ensureVisible(card);
      await tester.pumpAndSettle();
      expect(card, findsOneWidget);
      final expected = n % 5 == 0 ? '10 Questions' : '5 Questions';
      expect(
        find.descendant(of: card, matching: find.text(expected)),
        findsOneWidget,
      );
      final top =
          tester.getTopLeft(card).dy +
          tester
              .state<ScrollableState>(find.byType(Scrollable).first)
              .position
              .pixels;
      if (previousTop != null) {
        expect(top, greaterThan(previousTop), reason: 'Level $n out of order');
      }
      previousTop = top;
    }
    expect(find.text('CHECKPOINT CHALLENGE'), findsOneWidget);
    expect(find.text('FINAL CHALLENGE'), findsOneWidget);
  });

  testWidgets('tapping Start Quiz on a level reports that level', (
    WidgetTester tester,
  ) async {
    QuizLevel? played;
    await pumpCategoriesPage(
      tester,
      levelsLoader: () async => backendLevels,
      onLevelSelected: (level) async => played = level,
    );

    final start = find.byKey(const ValueKey('levels.start.1'));
    await tester.ensureVisible(start);
    await tester.pumpAndSettle();
    await tester.tap(start);
    await tester.pumpAndSettle();

    expect(played?.number, 1);
    expect(played?.quiz.slug, 'legal-awareness-level-1');
  });

  testWidgets('a one-off failure retries itself instead of erroring', (
    WidgetTester tester,
  ) async {
    var calls = 0;
    await pumpCategoriesPage(
      tester,
      levelsLoader: () async {
        calls++;
        // The backend blinking (a nodemon restart) fails only the first call.
        if (calls == 1) {
          throw Exception('server restarting');
        }
        return backendLevels;
      },
    );

    expect(calls, 2);
    expect(find.byKey(const ValueKey('levels.card.1')), findsOneWidget);
    expect(
      find.text('Unable to load quizzes. Please try again.'),
      findsNothing,
    );
  });

  testWidgets('shows loading, then an error with a working retry', (
    WidgetTester tester,
  ) async {
    var calls = 0;
    await pumpCategoriesPage(
      tester,
      levelsLoader: () async {
        calls++;
        // Down for both the first call and its automatic retry.
        if (calls <= 2) {
          throw Exception('server down');
        }
        await Future<void>.delayed(const Duration(milliseconds: 50));
        return backendLevels;
      },
    );

    expect(
      find.text('Unable to load quizzes. Please try again.'),
      findsOneWidget,
    );

    await tester.tap(find.byKey(const ValueKey('levels.retry')));
    await tester.pump();
    expect(find.text('Loading quizzes...'), findsOneWidget);
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('levels.card.1')), findsOneWidget);
  });

  testWidgets('shows the empty state when there are no levels', (
    WidgetTester tester,
  ) async {
    await pumpCategoriesPage(tester);

    expect(find.text('No quizzes available.'), findsOneWidget);
  });

  testWidgets('showCategoriesFirst opens straight on the category list', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(393, 1600);
    tester.view.devicePixelRatio = 1;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
    await tester.pumpWidget(
      MaterialApp(
        home: CategoriesPage(
          viewModel: const HomeViewModel(),
          showCategoriesFirst: true,
          levelsLoader: () async => const <QuizLevel>[],
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(
      find.byKey(const ValueKey('categories.card.constitutional_law')),
      findsOneWidget,
    );
    expect(find.byKey(const ValueKey('levels.title')), findsNothing);
  });

  testWidgets('a locked level cannot be started', (WidgetTester tester) async {
    QuizLevel? played;
    final lockedLevels = buildQuizLevels(
      [
        const RemoteQuiz(
          id: 101,
          slug: 'legal-awareness-level-1',
          title: 'Level 1',
          totalQuestions: 5,
          difficulty: 'easy',
        ),
        const RemoteQuiz(
          id: 106,
          slug: 'legal-awareness-level-6',
          title: 'Level 6',
          totalQuestions: 5,
          difficulty: 'easy',
          levelId: 2,
          isLocked: true,
          requiredPoints: 250,
        ),
      ],
      const [],
      {2: 'Apprentice'},
    );

    await pumpCategoriesPage(
      tester,
      levelsLoader: () async => lockedLevels,
      onLevelSelected: (level) async => played = level,
    );

    final locked = find.byKey(const ValueKey('levels.start.6'));
    await tester.ensureVisible(locked);
    await tester.pumpAndSettle();
    await tester.tap(locked);
    await tester.pumpAndSettle();

    expect(played, isNull);
    expect(find.text('Finish Level 1 first.'), findsWidgets);

    // The open level still plays.
    final open = find.byKey(const ValueKey('levels.start.1'));
    await tester.ensureVisible(open);
    await tester.pumpAndSettle();
    await tester.tap(open);
    await tester.pumpAndSettle();

    expect(played?.number, 1);
  });

  testWidgets('a chest sits after every four levels and opens when they are '
      'done', (WidgetTester tester) async {
    final backend = FakeCreditsBackend();
    LeaderboardProgressStore.clientFactory = () => ApiClient(
      httpClient: MockClient(backend.handle),
    );
    addTearDown(() => LeaderboardProgressStore.clientFactory = ApiClient.new);
    await LeaderboardProgressStore.clear();
    // Spend first: a chest can't push the balance past the cap.
    await LeaderboardProgressStore.spend(LeaderboardProgressStore.quizCost);

    // Levels 1-4 finished, so the first chest is claimable.
    final played = buildQuizLevels(
      [
        for (var n = 1; n <= 10; n++)
          RemoteQuiz(
            id: 100 + n,
            slug: 'legal-awareness-level-$n',
            title: 'Level $n',
            totalQuestions: 5,
            difficulty: 'easy',
          ),
      ],
      [
        for (var n = 1; n <= 4; n++)
          RemoteAttempt(
            id: n,
            quizId: 100 + n,
            status: 'submitted',
            totalQuestions: 5,
            answeredQuestions: 5,
            correctAnswers: 5,
          ),
      ],
    );

    await pumpCategoriesPage(tester, levelsLoader: () async => played);

    // One chest after Level 4, one after Level 8 — not after every level.
    expect(find.byKey(const ValueKey('levels.chest.0')), findsOneWidget);
    expect(find.byKey(const ValueKey('levels.chest.1')), findsOneWidget);
    expect(find.byKey(const ValueKey('levels.chest.2')), findsNothing);

    final credits = LeaderboardProgressStore.credits;
    final chest = find.byKey(const ValueKey('levels.chest.open.0'));
    await tester.ensureVisible(chest);
    await tester.pumpAndSettle();
    await tester.tap(chest);
    await tester.pumpAndSettle();

    expect(
      LeaderboardProgressStore.credits,
      credits + LeaderboardProgressStore.levelChestReward,
    );

    // The second chest waits on levels 5-8.
    final locked = find.byKey(const ValueKey('levels.chest.open.1'));
    await tester.ensureVisible(locked);
    await tester.pumpAndSettle();
    await tester.tap(locked);
    await tester.pumpAndSettle();

    expect(find.text('Finish Level 8 to open it.'), findsOneWidget);
  });
}
