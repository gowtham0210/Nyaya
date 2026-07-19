import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nyaya/features/topic_detail/presentation/topic_detail_page.dart';
import 'package:nyaya/features/topic_detail/presentation/topic_detail_view_model.dart';

void main() {
  Future<void> pumpTopicDetailPage(
    WidgetTester tester, {
    ValueChanged<String>? onQuizSelected,
    ValueChanged<String>? onContinueQuiz,
    TopicDetailViewModel? viewModel,
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
        home: TopicDetailPage(
          onQuizSelected: onQuizSelected ?? (_) {},
          onContinueQuiz: onContinueQuiz ?? (_) {},
          viewModel: viewModel,
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('shows the topic header, description and section strip', (
    WidgetTester tester,
  ) async {
    await pumpTopicDetailPage(tester);

    expect(find.text('Arrest, Bail & Police Powers'), findsOneWidget);
    expect(find.text('Under BNSS — formerly CrPC'), findsOneWidget);
    expect(find.text('6 quizzes'), findsOneWidget);
    expect(find.text('MEDIUM'), findsOneWidget);
    expect(find.text('33%'), findsOneWidget);
    expect(
      find.text(
        'What the police can and cannot do — your rights during FIR, arrest, '
        'custody and bail, under the new BNSS code.',
      ),
      findsOneWidget,
    );
    expect(
      find.text('Sections referenced: BNSS §35–§62 (formerly CrPC §41–§60)'),
      findsOneWidget,
    );
    expect(find.byKey(const ValueKey('topic.back')), findsOneWidget);
    expect(find.byKey(const ValueKey('topic.bookmark')), findsOneWidget);
  });

  testWidgets('lists the four quizzes with their state affordances', (
    WidgetTester tester,
  ) async {
    await pumpTopicDetailPage(tester);

    expect(find.text('FIR Basics'), findsOneWidget);
    expect(find.text('10 Questions · Easy'), findsOneWidget);
    expect(find.text('Arrest & Your Rights'), findsOneWidget);
    expect(find.text('12 Questions · Medium'), findsOneWidget);
    expect(find.text('Custody & Remand'), findsOneWidget);
    expect(find.text('Bail: When & How'), findsOneWidget);
    expect(find.text('14 Questions · Hard'), findsOneWidget);

    expect(
      find.byKey(const ValueKey('topic.quiz.completed.fir-basics')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey('topic.quiz.resume.arrest-your-rights')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey('topic.quiz.chevron.custody-remand')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey('topic.quiz.chevron.bail-when-how')),
      findsOneWidget,
    );
  });

  testWidgets('tapping a quiz row reports its id', (
    WidgetTester tester,
  ) async {
    String? selected;
    await pumpTopicDetailPage(
      tester,
      onQuizSelected: (quizId) => selected = quizId,
    );

    await tester.ensureVisible(
      find.byKey(const ValueKey('topic.quiz.custody-remand')),
    );
    await tester.tap(find.byKey(const ValueKey('topic.quiz.custody-remand')));
    await tester.pumpAndSettle();

    expect(selected, 'custody-remand');
  });

  testWidgets('the continue CTA reports the in-progress quiz', (
    WidgetTester tester,
  ) async {
    String? continued;
    await pumpTopicDetailPage(
      tester,
      onContinueQuiz: (quizId) => continued = quizId,
    );

    expect(find.text('CONTINUE QUIZ 2'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('topic.continue')));
    await tester.pumpAndSettle();

    expect(continued, 'arrest-your-rights');
  });

  testWidgets('the bookmark icon toggles between saved and unsaved', (
    WidgetTester tester,
  ) async {
    await pumpTopicDetailPage(tester);

    expect(find.byIcon(Icons.bookmark_border), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('topic.bookmark')));
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.bookmark), findsOneWidget);
    expect(find.byIcon(Icons.bookmark_border), findsNothing);
  });

  testWidgets('quiz rows announce their status to screen readers', (
    WidgetTester tester,
  ) async {
    await pumpTopicDetailPage(tester);

    expect(
      tester.getSemantics(
        find.byKey(const ValueKey('topic.quiz.arrest-your-rights')),
      ),
      isSemantics(
        isButton: true,
        hasTapAction: true,
        label: 'Arrest & Your Rights. 12 questions, Medium. in progress',
      ),
    );
  });
}
