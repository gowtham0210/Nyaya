import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nyaya/core/network/api_client.dart';
import 'package:nyaya/features/categories/data/categories_repository.dart';
import 'package:nyaya/features/categories/presentation/categories_page.dart';
import 'package:nyaya/features/categories/presentation/categories_view_model.dart';
import 'package:nyaya/features/goal_selection/presentation/goal_selection_page.dart';
import 'package:nyaya/features/home/presentation/home_page.dart';
import 'package:nyaya/features/home/presentation/home_view_model.dart';
import 'package:nyaya/features/quiz_question/presentation/quiz_question_page.dart';
import 'package:nyaya/features/quiz_question/presentation/quiz_session_view_model.dart';
import 'package:nyaya/features/quiz_result/presentation/quiz_result_page.dart';
import 'package:nyaya/features/quiz_result/presentation/quiz_result_view_model.dart';
import 'package:nyaya/features/topic_detail/presentation/topic_detail_page.dart';

import '../support/fake_backend.dart';
import '../support/localized_app.dart';

// Issue #28: learning screens render UI text in the learner's language.
// Sample content (quiz and topic names) stays in English.
void main() {
  testWidgets('Goal selection renders in Kannada', (tester) async {
    await pumpLocalized(
      tester,
      GoalSelectionPage(onContinue: (_) {}),
      locale: const Locale('kn'),
    );

    expect(find.text('ನಿಮ್ಮನ್ನು ನ್ಯಾಯಕ್ಕೆ'), findsOneWidget);
    expect(find.text('ಜೀವನಕ್ಕಾಗಿ ಕಾನೂನು ಕಲಿಯಿರಿ'), findsOneWidget);
    expect(find.text('ಮುಂದುವರಿಸಿ'), findsOneWidget);
    expect(find.text('What brings you'), findsNothing);
    expect(find.text('CONTINUE'), findsNothing);
  });

  testWidgets('Home renders in Hindi', (tester) async {
    await pumpLocalized(
      tester,
      const HomePage(viewModel: HomeViewModel()),
      locale: const Locale('hi'),
    );

    expect(find.text('कानूनी ज्ञान को परखें।'), findsOneWidget);
    expect(find.text('क्विज़ शुरू करें'), findsOneWidget);
    expect(find.text('श्रेणी के अनुसार देखें'), findsOneWidget);
    expect(find.text('पढ़ाई जारी रखें'), findsOneWidget);
    expect(find.text('कानून आधारित क्विज़ ऐप'), findsOneWidget);
    expect(find.text('Explore by Category'), findsNothing);
    // Sample content stays as is.
    expect(find.text('Indian Constitution Quiz'), findsOneWidget);

    final page = find
        .descendant(
          of: find.byKey(const ValueKey('home.scroll')),
          matching: find.byType(Scrollable),
        )
        .first;
    await tester.scrollUntilVisible(
      find.text('लोकप्रिय क्विज़'),
      300,
      scrollable: page,
    );
    await tester.scrollUntilVisible(
      find.text('Contract Act Quiz'),
      300,
      scrollable: page,
    );
    expect(find.text('आसान'), findsOneWidget);
    expect(find.text('12 प्रश्न'), findsOneWidget);
  });

  testWidgets('Categories renders in Tamil', (tester) async {
    final viewModel = CategoriesViewModel(
      repository: CategoriesRepository(_oneCategory()),
    );
    addTearDown(viewModel.dispose);
    await pumpLocalized(
      tester,
      CategoriesPage(viewModel: viewModel),
      locale: const Locale('ta'),
    );

    expect(find.text('வகைகள்'), findsOneWidget);
    expect(
      find.text('தலைப்புகளை ஆராய்ந்து உங்கள் சட்ட அறிவை வலுப்படுத்துங்கள்.'),
      findsOneWidget,
    );
    expect(find.text('வகைகளைத் தேடுங்கள்'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'zzz');
    await tester.pumpAndSettle();
    expect(
      find.text('உங்கள் தேடலுக்குப் பொருந்தும் வகைகள் இல்லை.'),
      findsOneWidget,
    );
  });

  testWidgets('Topic detail renders in Telugu', (tester) async {
    await pumpLocalized(
      tester,
      TopicDetailPage(onQuizSelected: (_) {}, onContinueQuiz: (_) {}),
      locale: const Locale('te'),
    );

    expect(find.text('6 క్విజ్‌లు'), findsOneWidget);
    expect(find.text('క్విజ్‌లు'), findsOneWidget);
    expect(find.text('10 ప్రశ్నలు · సులభం'), findsOneWidget);
    expect(find.text('క్విజ్ 2 కొనసాగించండి'), findsOneWidget);
    expect(find.byTooltip('అంశాన్ని బుక్‌మార్క్ చేయండి'), findsOneWidget);
    expect(find.text('FIR Basics'), findsOneWidget);
    expect(find.text('CONTINUE QUIZ 2'), findsNothing);
  });

  testWidgets('Quiz question renders in Hindi', (tester) async {
    await pumpLocalized(
      tester,
      QuizQuestionPage(onQuizCompleted: (_) {}),
      locale: const Locale('hi'),
    );

    expect(find.text('प्रश्न 1 / 12'), findsOneWidget);
    expect(find.text('एक उत्तर चुनें'), findsOneWidget);
    expect(find.byTooltip('क्विज़ से बाहर निकलें'), findsOneWidget);

    final correct = QuizSessionViewModel().questions.first.correctOption;
    await tester.tap(
      find.byKey(ValueKey('quiz.option.${String.fromCharCode(65 + correct)}')),
    );
    await tester.pumpAndSettle();

    expect(find.text('सही!'), findsOneWidget);
    expect(find.text('आगे'), findsOneWidget);
    expect(find.text('NEXT'), findsNothing);
  });

  testWidgets('Quiz result renders in Kannada', (tester) async {
    await pumpLocalized(
      tester,
      QuizResultPage(
        viewModel: QuizResultViewModel(
          outcomes: _outcomes(correct: 2, wrong: 1),
        ),
        onReviewAnswers: () {},
        onBackToTopic: () {},
      ),
      locale: const Locale('kn'),
    );

    expect(find.text('ಶಾಭಾಷ್!'), findsOneWidget);
    expect(find.text('ಈ ವಿಷಯ — ಪೂರ್ಣಗೊಂಡಿದೆ'), findsOneWidget);
    expect(find.text('ತಪ್ಪು'), findsOneWidget);
    expect(
      find.text('1 ಪ್ರಶ್ನೆಯನ್ನು ನಿಮ್ಮ ದುರ್ಬಲ ಪಟ್ಟಿಗೆ ಸೇರಿಸಲಾಗಿದೆ.'),
      findsOneWidget,
    );
    expect(find.text('ಉತ್ತರಗಳನ್ನು ಪರಿಶೀಲಿಸಿ'), findsOneWidget);
    expect(find.text('Well Done!'), findsNothing);
  });
}

ApiClient _oneCategory() => fakeBackend({
  '/categories': {
    'items': [
      {'id': 1, 'name': 'Constitutional Law', 'slug': 'constitutional-law'},
    ],
  },
  '/categories/1/quizzes': {'items': <Object>[]},
});

List<QuizOutcome> _outcomes({required int correct, required int wrong}) => [
  for (var i = 0; i < correct + wrong; i++)
    QuizOutcome(questionId: 'q$i', chosenOption: 0, isCorrect: i < correct),
];
