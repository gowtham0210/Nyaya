import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:nyaya/features/topic_detail/data/topic_repository.dart';
import 'package:nyaya/features/topic_detail/presentation/topic_detail_page.dart';
import 'package:nyaya/features/topic_detail/presentation/topic_detail_view_model.dart';

import '../../../support/fake_backend.dart';
import '../../../support/quiz_backend.dart';

void main() {
  Future<TopicDetailViewModel> pumpTopicPage(
    WidgetTester tester, {
    Map<String, Object>? routes,
    ValueChanged<TopicQuiz>? onQuizSelected,
  }) async {
    tester.view.reset();
    tester.view.physicalSize = const Size(393, 852);
    tester.view.devicePixelRatio = 1;
    tester.view.padding = const FakeViewPadding(top: 59, bottom: 34);
    addTearDown(tester.view.reset);
    final viewModel = TopicDetailViewModel(
      repository: TopicRepository(fakeBackend(routes ?? quizRoutes())),
      categoryId: 3,
      title: 'Criminal Procedure',
      description: 'Arrest, bail and police powers.',
    );
    addTearDown(viewModel.dispose);

    await tester.pumpWidget(
      MaterialApp(
        home: TopicDetailPage(
          viewModel: viewModel,
          onQuizSelected: onQuizSelected ?? (_) {},
        ),
      ),
    );
    await tester.pumpAndSettle();
    return viewModel;
  }

  testWidgets('AC-003 the header shows real counts and progress', (
    tester,
  ) async {
    await pumpTopicPage(tester);

    expect(find.text('Criminal Procedure'), findsOneWidget);
    expect(find.text('3 quizzes'), findsOneWidget);
    expect(find.text('MEDIUM'), findsOneWidget);
    expect(find.text('33%'), findsOneWidget);
    expect(find.text('Arrest, bail and police powers.'), findsOneWidget);
    // Unbuilt controls stay hidden (spec 035): bookmarks aren't saved.
    expect(find.byKey(const ValueKey('topic.bookmark')), findsNothing);
  });

  testWidgets('AC-003 rows show each quiz status from attempts', (
    tester,
  ) async {
    await pumpTopicPage(tester);

    expect(find.byKey(const ValueKey('topic.quiz.completed.11')), findsOne);
    expect(find.byKey(const ValueKey('topic.quiz.resume.12')), findsOne);
    expect(find.byKey(const ValueKey('topic.quiz.chevron.13')), findsOne);
    expect(find.text('10 Questions · Easy'), findsOneWidget);
  });

  testWidgets('AC-003 tapping a quiz and Continue report the quiz', (
    tester,
  ) async {
    final opened = <int>[];
    await pumpTopicPage(tester, onQuizSelected: (quiz) => opened.add(quiz.id));

    await tester.tap(find.byKey(const ValueKey('topic.quiz.11')));
    expect(find.text('Continue quiz 2'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('topic.continue')));

    expect(opened, [11, 12]);
  });

  testWidgets('AC-003 a fresh topic offers Start quiz 1', (tester) async {
    await pumpTopicPage(tester, routes: quizRoutes(attempts: []));

    expect(find.text('Start quiz 1'), findsOneWidget);
    expect(find.text('0%'), findsOneWidget);
  });

  testWidgets('AC-003 a locked quiz says when it unlocks and is inert', (
    tester,
  ) async {
    final opened = <int>[];
    await pumpTopicPage(
      tester,
      routes: quizRoutes(lockLast: true),
      onQuizSelected: (quiz) => opened.add(quiz.id),
    );

    expect(find.byKey(const ValueKey('topic.quiz.locked.13')), findsOne);
    expect(find.text('Unlocks at 200 points'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('topic.quiz.13')));
    expect(opened, isEmpty);
  });

  testWidgets('AC-003 a failure shows Retry and no Continue button', (
    tester,
  ) async {
    final routes = quizRoutes()
      ..['/categories/3/quizzes'] = http.Response('{"message":"boom"}', 500);
    await pumpTopicPage(tester, routes: routes);

    expect(find.byKey(const ValueKey('loadState.retry')), findsOneWidget);
    expect(find.byKey(const ValueKey('topic.continue')), findsNothing);
  });

  testWidgets('quiz rows announce their status to screen readers', (
    tester,
  ) async {
    await pumpTopicPage(tester);

    expect(
      tester.getSemantics(find.byKey(const ValueKey('topic.quiz.12'))),
      isSemantics(
        isButton: true,
        hasTapAction: true,
        label: 'Arrest & Your Rights. 12 questions, Medium. in progress',
      ),
    );
  });
}
