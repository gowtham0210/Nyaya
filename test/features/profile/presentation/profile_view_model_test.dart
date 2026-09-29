import 'package:flutter_test/flutter_test.dart';
import 'package:nyaya/app/quiz_history_store.dart';
import 'package:nyaya/features/profile/presentation/profile_view_model.dart';

void main() {
  test('falls back to a friendly default when no name is set', () {
    final viewModel = ProfileViewModel(
      fullName: '',
      email: '',
      attempts: const [],
    );

    expect(viewModel.fullName, 'Guest User');
    expect(viewModel.initials, 'GU');
  });

  test('derives initials from a full name', () {
    final viewModel = ProfileViewModel(
      fullName: 'Priya Sharma',
      email: 'priya@example.com',
      attempts: const [],
    );

    expect(viewModel.initials, 'PS');
  });

  test('resolves the goal option for a known goal id', () {
    final viewModel = ProfileViewModel(
      fullName: 'Priya Sharma',
      email: 'priya@example.com',
      goalId: 'crack-an-exam',
      attempts: const [],
    );

    expect(viewModel.goal?.id, 'crack-an-exam');
    expect(viewModel.goal?.title, 'Crack an exam');
  });

  test('has no goal when none is selected', () {
    final viewModel = ProfileViewModel(
      fullName: 'Priya Sharma',
      email: 'priya@example.com',
      attempts: const [],
    );

    expect(viewModel.goal, isNull);
  });

  test('computes stats from recorded attempts', () {
    final viewModel = ProfileViewModel(
      fullName: 'Priya Sharma',
      email: 'priya@example.com',
      attempts: [
        QuizAttempt(
          topicTitle: 'Civil & General Law Quiz',
          correctCount: 8,
          total: 10,
          completedAt: DateTime(2026, 8, 30),
        ),
        QuizAttempt(
          topicTitle: 'Criminal Law Quiz',
          correctCount: 12,
          total: 15,
          completedAt: DateTime(2026, 8, 31),
        ),
      ],
    );

    expect(viewModel.quizzesCompleted, 2);
    expect(viewModel.questionsAnswered, 25);
    // (0.8 + 0.8) / 2 = 0.8 -> 80%
    expect(viewModel.averageScorePercent, 80);
  });

  test('stats are zero with no recorded attempts', () {
    final viewModel = ProfileViewModel(
      fullName: 'Priya Sharma',
      email: 'priya@example.com',
      attempts: const [],
    );

    expect(viewModel.quizzesCompleted, 0);
    expect(viewModel.questionsAnswered, 0);
    expect(viewModel.averageScorePercent, 0);
  });

  test('recent attempts are capped at five', () {
    final attempts = List.generate(
      8,
      (index) => QuizAttempt(
        topicTitle: 'Quiz $index',
        correctCount: 5,
        total: 10,
        completedAt: DateTime(2026, 8, index + 1),
      ),
    );
    final viewModel = ProfileViewModel(
      fullName: 'Priya Sharma',
      email: 'priya@example.com',
      attempts: attempts,
    );

    expect(viewModel.recentAttempts, hasLength(5));
  });

  test('formats a member-since date as month and year', () {
    final viewModel = ProfileViewModel(
      fullName: 'Priya Sharma',
      email: 'priya@example.com',
      attempts: const [],
      memberSince: DateTime(2026, 9, 1),
      memberSinceProvided: true,
    );

    expect(viewModel.memberSinceLabel, 'Member since Sep 2026');
  });

  test('has no member-since label when unknown', () {
    final viewModel = ProfileViewModel(
      fullName: 'Priya Sharma',
      email: 'priya@example.com',
      attempts: const [],
      memberSinceProvided: true,
    );

    expect(viewModel.memberSinceLabel, isNull);
  });

  test('a much higher score ranks ahead of a user with no history', () {
    // Comfortably exceeds every sample leaderboard entry's points.
    final topOfTheBoard = ProfileViewModel(
      fullName: 'Top Scorer',
      email: 'top@example.com',
      attempts: [
        QuizAttempt(
          topicTitle: 'Marathon Quiz',
          correctCount: 10000,
          total: 10000,
          completedAt: DateTime(2026, 8, 1),
        ),
      ],
    );
    final noHistory = ProfileViewModel(
      fullName: 'New Learner',
      email: 'new@example.com',
      attempts: const [],
    );

    expect(topOfTheBoard.leaderboardRank, 1);
    expect(
      noHistory.leaderboardRank,
      greaterThan(topOfTheBoard.leaderboardRank),
    );
  });
}
