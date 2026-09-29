import 'package:flutter_test/flutter_test.dart';
import 'package:nyaya/app/quiz_history_store.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await QuizHistoryStore.clear();
  });

  test('a fresh install has no attempts', () async {
    await QuizHistoryStore.load();

    expect(QuizHistoryStore.attempts, isEmpty);
  });

  test('recording an attempt makes it the newest entry', () async {
    await QuizHistoryStore.recordAttempt(
      topicTitle: 'Civil & General Law Quiz',
      correctCount: 8,
      total: 10,
    );
    await QuizHistoryStore.recordAttempt(
      topicTitle: 'Criminal Law Quiz',
      correctCount: 12,
      total: 15,
    );

    expect(QuizHistoryStore.attempts, hasLength(2));
    expect(QuizHistoryStore.attempts.first.topicTitle, 'Criminal Law Quiz');
    expect(QuizHistoryStore.attempts.first.scoreFraction, closeTo(0.8, 1e-9));
  });

  test('an attempt with zero questions is not recorded', () async {
    await QuizHistoryStore.recordAttempt(
      topicTitle: 'Empty Quiz',
      correctCount: 0,
      total: 0,
    );

    expect(QuizHistoryStore.attempts, isEmpty);
  });

  test('attempts survive a reload', () async {
    await QuizHistoryStore.recordAttempt(
      topicTitle: 'Fundamental Rights Quiz',
      correctCount: 9,
      total: 10,
    );

    QuizHistoryStore.attempts = [];
    await QuizHistoryStore.load();

    expect(QuizHistoryStore.attempts, hasLength(1));
    expect(
      QuizHistoryStore.attempts.single.topicTitle,
      'Fundamental Rights Quiz',
    );
    expect(QuizHistoryStore.attempts.single.correctCount, 9);
    expect(QuizHistoryStore.attempts.single.total, 10);
  });

  test('clear resets the history', () async {
    await QuizHistoryStore.recordAttempt(
      topicTitle: 'Contract Act Quiz',
      correctCount: 6,
      total: 12,
    );

    await QuizHistoryStore.clear();
    await QuizHistoryStore.load();

    expect(QuizHistoryStore.attempts, isEmpty);
  });
}
