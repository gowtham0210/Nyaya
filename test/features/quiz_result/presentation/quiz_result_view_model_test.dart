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
    expect(vm.headline, 'Well Done!');
    expect(vm.subtitle, 'Arrest & Your Rights — completed');
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
}
