import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:nyaya/app/api_client.dart';
import 'package:nyaya/features/quiz_question/data/quiz_api.dart';
import 'package:nyaya/app/quiz_progress_store.dart';
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
    // The card reflects the user's real latest attempt; stand one in so the
    // ring has a score to render.
    QuizProgressStore.remote = const ContinueLearningSnapshot(
      title: 'Indian Constitution Quiz',
      questionCount: 15,
      progress: 0.65,
      canResume: false,
    );
    addTearDown(() => QuizProgressStore.remote = null);

    await pumpHomePage(tester);

    expect(find.text('Explore by Category'), findsOneWidget);
    expect(find.text('Constitutional Law'), findsOneWidget);
    expect(find.text('Criminal & Evidence Law'), findsOneWidget);
    expect(find.text('Civil & General Law'), findsOneWidget);
    expect(find.text('Marriage & Family Law'), findsOneWidget);
    expect(find.text('Labor & Industrial Law'), findsOneWidget);
    expect(find.text('Corporate & Commercial Law'), findsOneWidget);
    expect(find.text('Taxation Law'), findsOneWidget);
    expect(find.text('Cyber & Intellectual Property'), findsOneWidget);
    expect(find.text('Property & Real Estate Law'), findsOneWidget);
    expect(find.text('Banking & Financial Law'), findsOneWidget);
    expect(find.text('Environmental Law'), findsOneWidget);

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
    expect(find.text('Quizzes'), findsOneWidget);
    expect(find.text('Leaderboard'), findsOneWidget);
    expect(find.text('Legal Updates'), findsOneWidget);
    expect(find.text('Profile'), findsOneWidget);
  });

  /// A backend that answers Home's two new sections.
  QuizApi fakeApi({
    List<Map<String, Object?>>? practice,
    List<Map<String, Object?>>? questions,
  }) {
    return QuizApi(
      client: ApiClient(
        baseUrl: 'http://test/api/v1',
        httpClient: MockClient((request) async {
          final body = request.url.path.contains('random-questions')
              ? {'items': questions ?? const []}
              : {
                  'items':
                      practice ??
                      const [
                        {'difficulty': 'easy', 'questionCount': 10},
                        {'difficulty': 'hard', 'questionCount': 10},
                      ],
                };
          return http.Response(
            jsonEncode(body),
            200,
            headers: {'content-type': 'application/json'},
          );
        }),
      ),
    );
  }

  testWidgets('Quick Practice shows the enabled tiers and reports a tap', (
    WidgetTester tester,
  ) async {
    String? picked;
    tester.view.physicalSize = const Size(393, 2200);
    tester.view.devicePixelRatio = 1;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      MaterialApp(
        home: HomePage(
          viewModel: const HomeViewModel(),
          quizApi: fakeApi(),
          onDifficultySelected: (difficulty) => picked = difficulty,
        ),
      ),
    );
    await tester.pumpAndSettle();

    final easy = find.byKey(const ValueKey('home.practice.easy'));
    await tester.scrollUntilVisible(
      easy,
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    // Only the tiers the admin enabled appear.
    expect(find.byKey(const ValueKey('home.practice.medium')), findsNothing);

    await tester.tap(easy);
    await tester.pumpAndSettle();

    expect(picked, 'easy');
  });

  testWidgets('a Test Yourself question hides its answer until tapped', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(393, 2200);
    tester.view.devicePixelRatio = 1;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      MaterialApp(
        home: HomePage(
          viewModel: const HomeViewModel(),
          quizApi: fakeApi(
            questions: [
              {
                'id': 7,
                'questionText': 'Which is the highest court in India?',
                'quizTitle': 'Level 1',
                'explanation': jsonEncode({'core': 'It is the apex court.'}),
                'options': [
                  {'id': 1, 'optionText': 'High Court', 'isCorrect': false},
                  {'id': 2, 'optionText': 'Supreme Court', 'isCorrect': true},
                ],
              },
            ],
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final card = find.byKey(const ValueKey('home.flash.7'));
    await tester.scrollUntilVisible(
      card,
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();

    expect(find.text('Which is the highest court in India?'), findsOneWidget);
    // The answer stays hidden until the card is opened.
    expect(find.byKey(const ValueKey('home.flash.7.answer')), findsNothing);

    await tester.tap(card);
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('home.flash.7.answer')), findsOneWidget);
    expect(find.text('Supreme Court'), findsOneWidget);
    expect(find.text('It is the apex court.'), findsOneWidget);

    // Tapping again turns it back over.
    await tester.tap(card);
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('home.flash.7.answer')), findsNothing);
  });
}
