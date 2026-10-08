import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nyaya/app/theme/app_motion.dart';
import 'package:nyaya/core/presentation/widgets/nyaya_icon.dart';
import 'package:nyaya/core/presentation/widgets/nyaya_skeleton.dart';
import 'package:nyaya/features/quiz_question/presentation/quiz_question_page.dart';
import 'package:nyaya/features/quiz_question/presentation/quiz_session_view_model.dart';
import 'package:nyaya/features/quiz_result/presentation/quiz_result_page.dart';
import 'package:nyaya/features/quiz_result/presentation/quiz_result_view_model.dart';
import 'package:nyaya/features/shell/presentation/tab_shell_page.dart';

/// Records haptic calls on the platform channel.
List<String> recordHaptics(WidgetTester tester) {
  final haptics = <String>[];
  tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
    SystemChannels.platform,
    (call) async {
      if (call.method == 'HapticFeedback.vibrate') {
        haptics.add(call.arguments as String);
      }
      return null;
    },
  );
  addTearDown(
    () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      SystemChannels.platform,
      null,
    ),
  );
  return haptics;
}

List<QuizOutcome> outcomes(int correct, int wrong) => [
  for (var i = 0; i < correct; i++)
    QuizOutcome(questionId: 'c$i', chosenOption: 0, isCorrect: true),
  for (var i = 0; i < wrong; i++)
    QuizOutcome(questionId: 'w$i', chosenOption: 0, isCorrect: false),
];

void main() {
  testWidgets('AC-001 a right answer taps then confirms lightly', (
    tester,
  ) async {
    final haptics = recordHaptics(tester);
    final question = QuizSessionViewModel().questions.first;
    await tester.pumpWidget(
      MaterialApp(
        home: QuizQuestionPage(
          session: QuizSessionViewModel(questions: [question]),
          onQuizCompleted: (_) {},
        ),
      ),
    );
    final letter = String.fromCharCode(65 + question.correctOption!);
    await tester.tap(find.byKey(ValueKey('quiz.option.$letter')));
    await tester.pumpAndSettle();

    expect(haptics, [
      'HapticFeedbackType.selectionClick',
      'HapticFeedbackType.lightImpact',
    ]);
  });

  testWidgets('AC-001 a wrong answer gives a firmer tap', (tester) async {
    final haptics = recordHaptics(tester);
    final question = QuizSessionViewModel().questions.first;
    await tester.pumpWidget(
      MaterialApp(
        home: QuizQuestionPage(
          session: QuizSessionViewModel(questions: [question]),
          onQuizCompleted: (_) {},
        ),
      ),
    );
    final wrong = question.correctOption == 0 ? 'B' : 'A';
    await tester.tap(find.byKey(ValueKey('quiz.option.$wrong')));
    await tester.pumpAndSettle();

    expect(haptics.last, 'HapticFeedbackType.mediumImpact');
  });

  testWidgets('AC-002 a strong result celebrates and counts up', (
    tester,
  ) async {
    final haptics = recordHaptics(tester);
    await tester.pumpWidget(
      MaterialApp(
        home: QuizResultPage(
          viewModel: QuizResultViewModel(outcomes: outcomes(9, 3)),
          onBackToTopic: () {},
        ),
      ),
    );

    expect(find.text('0/12'), findsOneWidget);
    await tester.pumpAndSettle();
    expect(find.text('9/12'), findsOneWidget);
    expect(find.text('75%'), findsOneWidget);
    expect(haptics, ['HapticFeedbackType.heavyImpact']);
  });

  testWidgets('AC-002 a low result only taps lightly', (tester) async {
    final haptics = recordHaptics(tester);
    await tester.pumpWidget(
      MaterialApp(
        home: QuizResultPage(
          viewModel: QuizResultViewModel(outcomes: outcomes(2, 10)),
          onBackToTopic: () {},
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(haptics, ['HapticFeedbackType.selectionClick']);
  });

  testWidgets('AC-003 switching tabs taps and slides the indicator', (
    tester,
  ) async {
    final haptics = recordHaptics(tester);
    final controller = TabShellController();
    addTearDown(controller.dispose);
    ShellTab tab(String id) => ShellTab(
      id: id,
      label: id,
      icon: HomeIconType.navHome,
      builder: (_) => Text('$id body'),
    );
    await tester.pumpWidget(
      MaterialApp(
        home: TabShellPage(
          controller: controller,
          tabs: [tab('home'), tab('profile')],
        ),
      ),
    );
    final indicator = find.byKey(const ValueKey('nav.indicator'));
    final before = tester.getRect(indicator).left;

    await tester.tap(find.byKey(const ValueKey('nav.profile')));
    await tester.pumpAndSettle();

    expect(tester.getRect(indicator).left, greaterThan(before));
    expect(haptics, ['HapticFeedbackType.selectionClick']);

    // Tapping the current tab again stays quiet.
    await tester.tap(find.byKey(const ValueKey('nav.profile')));
    await tester.pumpAndSettle();
    expect(haptics, hasLength(1));
  });

  testWidgets('AC-004 reduced motion: no durations, a still skeleton', (
    tester,
  ) async {
    late Duration duration;
    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(disableAnimations: true),
        child: MaterialApp(
          home: Builder(
            builder: (context) {
              duration = NyayaMotion.of(context, NyayaMotion.slow);
              return const Scaffold(body: NyayaSkeleton());
            },
          ),
        ),
      ),
    );

    expect(duration, Duration.zero);
    expect(tester.hasRunningAnimations, isFalse);
  });
}
