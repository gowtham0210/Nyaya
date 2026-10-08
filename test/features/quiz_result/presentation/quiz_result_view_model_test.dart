import 'package:flutter_test/flutter_test.dart';
import 'package:nyaya/features/quiz_question/presentation/quiz_session_view_model.dart';
import 'package:nyaya/features/quiz_result/presentation/quiz_result_view_model.dart';

void main() {
  List<QuizOutcome> outcomes({required int correct, required int wrong}) => [
    for (var i = 0; i < correct; i++)
      QuizOutcome(questionId: 'c$i', chosenOption: 0, isCorrect: true),
    for (var i = 0; i < wrong; i++)
      QuizOutcome(questionId: 'w$i', chosenOption: 0, isCorrect: false),
  ];

  test('derives the score, percent and counts from outcomes', () {
    final vm = QuizResultViewModel(
      outcomes: outcomes(correct: 9, wrong: 3),
      topicTitle: 'Arrest & Your Rights',
    );

    expect(vm.total, 12);
    expect(vm.correctCount, 9);
    expect(vm.wrongCount, 3);
    expect(vm.scoreLabel, '9/12');
    expect(vm.percentLabel, '75%');
  });

  test('rounds the percent to the nearest whole number', () {
    final vm = QuizResultViewModel(outcomes: outcomes(correct: 2, wrong: 1));

    // 2/3 = 66.66… → 67%
    expect(vm.percentLabel, '67%');
  });

  test('the weak list holds the wrong count and shows when non-zero', () {
    final vm = QuizResultViewModel(outcomes: outcomes(correct: 9, wrong: 3));

    expect(vm.weakCount, 3);
    expect(vm.showWeakStrip, isTrue);
  });

  test('a perfect score hides the weak-list strip', () {
    final vm = QuizResultViewModel(outcomes: outcomes(correct: 12, wrong: 0));

    expect(vm.weakCount, 0);
    expect(vm.showWeakStrip, isFalse);
    expect(vm.percentLabel, '100%');
  });

  test('spec 037 AC-005 the headline band follows the score', () {
    ResultBand band(int correct, int wrong) => QuizResultViewModel(
      outcomes: outcomes(correct: correct, wrong: wrong),
    ).band;

    expect(band(12, 0), ResultBand.excellent);
    expect(band(9, 3), ResultBand.excellent); // 75%, as in the mockup
    expect(band(7, 3), ResultBand.excellent); // 70%
    expect(band(6, 4), ResultBand.good); // 60%
    expect(band(4, 6), ResultBand.good); // 40%
    expect(band(2, 10), ResultBand.keepGoing); // 17%
    expect(QuizResultViewModel(outcomes: const []).band, ResultBand.keepGoing);
  });
}
