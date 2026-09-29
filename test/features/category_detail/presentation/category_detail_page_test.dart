import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:nyaya/app/api_client.dart';
import 'package:nyaya/app/app_session.dart';
import 'package:nyaya/app/user_api.dart';
import 'package:nyaya/features/category_detail/data/category_content.dart';
import 'package:nyaya/features/category_detail/presentation/category_detail_page.dart';
import 'package:nyaya/features/home/presentation/home_view_model.dart';
import 'package:nyaya/features/quiz_question/data/quiz_api.dart';

void main() {
  const category = HomeCategoryData(
    id: 'environmental_law',
    label: 'Environmental Law',
    icon: HomeIconType.environmental,
  );

  http.Response ok(Object body) => http.Response(
    jsonEncode(body),
    200,
    headers: {'content-type': 'application/json'},
  );

  /// A backend with no matching category — the default for these tests, so
  /// the leaderboard card resolves to nothing rendered without a live
  /// server. [leaderboardEntries] seeds a matching category (id 1) with a
  /// ranking when a test needs the card to actually render.
  ({QuizApi quizApi, UserApi userApi}) fakeApis({
    List<Map<String, Object?>>? leaderboardEntries,
  }) {
    final client = ApiClient(
      httpClient: MockClient((request) async {
        final path = request.url.path;
        if (path == '/api/v1/categories') {
          return ok({
            'items': leaderboardEntries == null
                ? []
                : [
                    {'id': 1, 'slug': 'environmental-law', 'name': 'Environmental Law'},
                  ],
          });
        }
        if (path == '/api/v1/leaderboards/category/1') {
          return ok({'items': leaderboardEntries ?? []});
        }
        if (path == '/api/v1/users/me') {
          return ok({'id': 2, 'fullName': 'Test User', 'email': 'a@b.c'});
        }
        return http.Response('{"message":"not found"}', 404);
      }),
    );
    return (quizApi: QuizApi(client: client), userApi: UserApi(client: client));
  }

  Future<void> pumpPage(
    WidgetTester tester, {
    CategoryContent? content,
    VoidCallback? onBackPressed,
    ValueChanged<CategoryQuizSummary>? onQuizSelected,
    ({QuizApi quizApi, UserApi userApi})? apis,
  }) async {
    final resolvedApis = apis ?? fakeApis();
    await tester.pumpWidget(
      MaterialApp(
        home: CategoryDetailPage(
          category: category,
          content: content,
          onBackPressed: onBackPressed,
          onQuizSelected: onQuizSelected,
          quizApi: resolvedApis.quizApi,
          userApi: resolvedApis.userApi,
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('shows the category title and its registered description', (
    WidgetTester tester,
  ) async {
    await pumpPage(tester);

    expect(find.text('Environmental Law'), findsOneWidget);
    expect(
      find.byKey(const ValueKey('category.description.environmental_law')),
      findsOneWidget,
    );
  });

  testWidgets('shows the registered article overview when present', (
    WidgetTester tester,
  ) async {
    await pumpPage(tester);

    expect(
      find.byKey(const ValueKey('category.article.environmental_law')),
      findsOneWidget,
    );
    expect(find.text('Overview'), findsOneWidget);
  });

  testWidgets('hides the overview card when no article content is registered', (
    WidgetTester tester,
  ) async {
    await pumpPage(
      tester,
      content: const CategoryContent(description: 'Test description.'),
    );

    expect(
      find.byKey(const ValueKey('category.article.environmental_law')),
      findsNothing,
    );
  });

  testWidgets('shows the empty state when there are no quizzes yet', (
    WidgetTester tester,
  ) async {
    await pumpPage(
      tester,
      content: const CategoryContent(description: 'Test description.'),
    );

    expect(
      find.byKey(const ValueKey('category.empty.environmental_law')),
      findsOneWidget,
    );
    expect(find.text('Content coming soon'), findsOneWidget);
  });

  testWidgets('shows real quizzes instead of the empty state when present', (
    WidgetTester tester,
  ) async {
    await pumpPage(
      tester,
      content: const CategoryContent(
        description: 'Test description.',
        quizzes: [
          CategoryQuizSummary(
            id: 'sample-quiz',
            title: 'Sample Quiz',
            questionCount: 5,
            difficulty: QuizDifficulty.easy,
          ),
        ],
      ),
    );

    expect(
      find.byKey(const ValueKey('category.empty.environmental_law')),
      findsNothing,
    );
    expect(
      find.byKey(const ValueKey('category.quiz.sample-quiz')),
      findsOneWidget,
    );
    expect(find.text('Sample Quiz'), findsOneWidget);
  });

  testWidgets('tapping a quiz reports it', (WidgetTester tester) async {
    CategoryQuizSummary? selected;
    await pumpPage(
      tester,
      content: const CategoryContent(
        description: 'Test description.',
        quizzes: [
          CategoryQuizSummary(
            id: 'sample-quiz',
            title: 'Sample Quiz',
            questionCount: 5,
            difficulty: QuizDifficulty.easy,
          ),
        ],
      ),
      onQuizSelected: (quiz) => selected = quiz,
    );

    await tester.tap(find.byKey(const ValueKey('category.quiz.sample-quiz')));
    await tester.pumpAndSettle();

    expect(selected?.id, 'sample-quiz');
  });

  testWidgets('tapping the back button reports it', (
    WidgetTester tester,
  ) async {
    var backPressed = false;
    await pumpPage(tester, onBackPressed: () => backPressed = true);

    await tester.tap(find.byKey(const ValueKey('category.back')));
    await tester.pumpAndSettle();

    expect(backPressed, isTrue);
  });

  group('category leaderboard card', () {
    // The card sits at the bottom of a long scrollable page; ListView only
    // lays out what's near the viewport, so these scroll it into view
    // before asserting — the same reason plenty of other tests in this app
    // call tester.ensureVisible before checking a low-down widget.
    Future<void> scrollToCard(WidgetTester tester) async {
      await tester.scrollUntilVisible(
        find.byKey(const ValueKey('category.leaderboard.environmental_law')),
        200,
        scrollable: find.byType(Scrollable),
      );
      await tester.pumpAndSettle();
    }

    testWidgets('renders nothing when the backend has no matching category', (
      WidgetTester tester,
    ) async {
      await pumpPage(tester); // fakeApis() default: no matching category
      await scrollToCard(tester);

      expect(find.text('Top Learners Here'), findsNothing);
    });

    testWidgets('shows a ranked list once the category resolves', (
      WidgetTester tester,
    ) async {
      AppSession.accessToken = 'test-token';
      addTearDown(() => AppSession.accessToken = null);

      await pumpPage(
        tester,
        apis: fakeApis(
          leaderboardEntries: [
            {'rank': 1, 'userId': 2, 'fullName': 'Test User', 'totalPoints': 40},
            {'rank': 2, 'userId': 5, 'fullName': 'Other Learner', 'totalPoints': 30},
          ],
        ),
      );
      await scrollToCard(tester);

      expect(find.text('Top Learners Here'), findsOneWidget);
      expect(
        find.byKey(const ValueKey('category.leaderboard.row.1')),
        findsOneWidget,
      );
      expect(find.text('40 pts'), findsOneWidget);
      // Row 1 belongs to userId 2, which /users/me also reports as signed in.
      expect(
        find.descendant(
          of: find.byKey(const ValueKey('category.leaderboard.row.1')),
          matching: find.text('YOU'),
        ),
        findsOneWidget,
      );
    });

    testWidgets('shows an empty-ranking message when nobody has played yet', (
      WidgetTester tester,
    ) async {
      await pumpPage(tester, apis: fakeApis(leaderboardEntries: const []));
      await scrollToCard(tester);

      expect(
        find.byKey(const ValueKey('category.leaderboard.empty')),
        findsOneWidget,
      );
    });
  });

  test('every home category has registered content with a description', () {
    for (final category in const HomeViewModel().categories) {
      final content = categoryContentFor(category.id);
      expect(content.description, isNotEmpty, reason: category.id);
    }
  });

  test('every home category has registered article content', () {
    for (final category in const HomeViewModel().categories) {
      final content = categoryContentFor(category.id);
      expect(content.articleContent, isNotEmpty, reason: category.id);
    }
  });
}
