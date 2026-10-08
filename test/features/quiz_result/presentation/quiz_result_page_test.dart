import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nyaya/features/quiz_question/presentation/quiz_session_view_model.dart';
import 'package:nyaya/features/quiz_result/presentation/quiz_result_page.dart';
import 'package:nyaya/features/quiz_result/presentation/quiz_result_view_model.dart';

void main() {
  List<QuizOutcome> outcomes({required int correct, required int wrong}) => [
    for (var i = 0; i < correct; i++)
      QuizOutcome(questionId: 'c$i', chosenOption: 0, isCorrect: true),
    for (var i = 0; i < wrong; i++)
      QuizOutcome(questionId: 'w$i', chosenOption: 0, isCorrect: false),
  ];

  Future<void> pumpResultPage(
    WidgetTester tester, {
    QuizResultViewModel? viewModel,
    VoidCallback? onReviewAnswers,
    VoidCallback? onBackToTopic,
    bool withReview = true,
    Size size = const Size(393, 852),
  }) async {
    tester.view.reset();
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1;
    tester.view.padding = const FakeViewPadding(top: 59, bottom: 34);
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
      tester.view.resetPadding();
    });

    await tester.pumpWidget(
      MaterialApp(
        home: QuizResultPage(
          viewModel:
              viewModel ??
              QuizResultViewModel(
                outcomes: outcomes(correct: 9, wrong: 3),
                topicTitle: 'Arrest & Your Rights',
              ),
          onReviewAnswers: withReview ? onReviewAnswers ?? () {} : null,
          onBackToTopic: onBackToTopic ?? () {},
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('shows the score ring, headline and stats', (
    WidgetTester tester,
  ) async {
    await pumpResultPage(tester);

    expect(find.byKey(const ValueKey('result.ring')), findsOneWidget);
    expect(find.text('9/12'), findsOneWidget);
    expect(find.text('75%'), findsOneWidget);
    expect(find.text('Well Done!'), findsOneWidget);
    expect(find.text('Arrest & Your Rights — completed'), findsOneWidget);
    expect(find.text('CORRECT'), findsOneWidget);
    expect(find.text('WRONG'), findsOneWidget);
    expect(find.text('TIME'), findsNothing);
  });

  testWidgets('the weak-list strip reports the wrong count', (
    WidgetTester tester,
  ) async {
    await pumpResultPage(tester);

    expect(find.byKey(const ValueKey('result.weakstrip')), findsOneWidget);
    expect(
      find.textContaining('3 questions added to your weak list'),
      findsOneWidget,
    );
  });

  testWidgets('a perfect score hides the weak-list strip', (
    WidgetTester tester,
  ) async {
    await pumpResultPage(
      tester,
      viewModel: QuizResultViewModel(
        outcomes: outcomes(correct: 12, wrong: 0),
        topicTitle: 'Arrest & Your Rights',
      ),
    );

    expect(find.byKey(const ValueKey('result.weakstrip')), findsNothing);
    expect(find.text('12/12'), findsOneWidget);
    expect(find.text('100%'), findsOneWidget);
  });

  testWidgets('the CTAs invoke their callbacks', (WidgetTester tester) async {
    var reviewed = 0;
    var backed = 0;
    await pumpResultPage(
      tester,
      onReviewAnswers: () => reviewed++,
      onBackToTopic: () => backed++,
    );

    await tester.ensureVisible(find.byKey(const ValueKey('result.review')));
    await tester.tap(find.byKey(const ValueKey('result.review')));
    await tester.pumpAndSettle();
    await tester.ensureVisible(
      find.byKey(const ValueKey('result.backtotopic')),
    );
    await tester.tap(find.byKey(const ValueKey('result.backtotopic')));
    await tester.pumpAndSettle();

    expect(reviewed, 1);
    expect(backed, 1);
  });

  testWidgets(
    'spec 035 AC-003 without review, Back to topic is the only, primary CTA',
    (WidgetTester tester) async {
      var backed = 0;
      await pumpResultPage(
        tester,
        withReview: false,
        onBackToTopic: () => backed++,
      );

      expect(find.byKey(const ValueKey('result.review')), findsNothing);
      expect(find.text('Review answers'), findsNothing);
      final back = find.byKey(const ValueKey('result.backtotopic'));
      expect(
        find.ancestor(
          of: find.text('Back to topic'),
          matching: find.byType(ElevatedButton),
        ),
        findsOneWidget,
      );
      await tester.ensureVisible(back);
      await tester.tap(back);
      expect(backed, 1);
    },
  );

  testWidgets('spec 037 AC-005 a low score is not called "Well Done!"', (
    WidgetTester tester,
  ) async {
    await pumpResultPage(
      tester,
      viewModel: QuizResultViewModel(
        outcomes: outcomes(correct: 2, wrong: 10),
        topicTitle: 'Arrest & Your Rights',
      ),
    );

    expect(find.text('Keep going!'), findsOneWidget);
    expect(find.text('Well Done!'), findsNothing);
  });
}
