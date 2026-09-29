import 'package:flutter_test/flutter_test.dart';
import 'package:nyaya/app/quiz_history_store.dart';
import 'package:nyaya/features/leaderboard/presentation/leaderboard_view_model.dart';

void main() {
  test('ranks entries by points, highest first', () {
    final viewModel = LeaderboardViewModel(
      currentUserName: 'Test User',
      attempts: const [],
    );

    final entries = viewModel.entries;

    for (var i = 1; i < entries.length; i++) {
      expect(entries[i - 1].points, greaterThanOrEqualTo(entries[i].points));
      expect(entries[i].rank, entries[i - 1].rank + 1);
    }
  });

  test('podium holds exactly the top 3 ranks', () {
    final viewModel = LeaderboardViewModel(
      currentUserName: 'Test User',
      attempts: const [],
    );

    final podium = viewModel.podium;

    expect(podium, hasLength(3));
    expect(podium.map((e) => e.rank), [1, 2, 3]);
  });

  test('remaining holds every rank after the podium', () {
    final viewModel = LeaderboardViewModel(
      currentUserName: 'Test User',
      attempts: const [],
    );

    final total = viewModel.entries.length;

    expect(viewModel.remaining, hasLength(total - 3));
    expect(viewModel.remaining.first.rank, 4);
  });

  test('computes the current user\'s points from their quiz history', () {
    final viewModel = LeaderboardViewModel(
      currentUserName: 'Test User',
      attempts: [
        QuizAttempt(
          topicTitle: 'Civil & General Law Quiz',
          correctCount: 8,
          total: 10,
          completedAt: DateTime.now(),
        ),
        QuizAttempt(
          topicTitle: 'Criminal Law Quiz',
          correctCount: 12,
          total: 15,
          completedAt: DateTime.now(),
        ),
      ],
    );

    final self = viewModel.entries.singleWhere((e) => e.isCurrentUser);

    // (8 + 12) correct * 20 + 2 attempts * 30 = 460.
    expect(self.points, 460);
    expect(self.name, 'Test User');
  });

  test('a user with no quiz history scores zero points', () {
    final viewModel = LeaderboardViewModel(
      currentUserName: 'Test User',
      attempts: const [],
    );

    final self = viewModel.entries.singleWhere((e) => e.isCurrentUser);

    expect(self.points, 0);
  });

  test('falls back to a friendly label when no name is set', () {
    final viewModel = LeaderboardViewModel(
      currentUserName: '',
      attempts: const [],
    );

    final self = viewModel.entries.singleWhere((e) => e.isCurrentUser);

    expect(self.name, 'You');
  });

  test('derives initials from a full name', () {
    final viewModel = LeaderboardViewModel(
      currentUserName: 'Priya Sharma',
      attempts: const [],
    );

    final self = viewModel.entries.singleWhere((e) => e.isCurrentUser);

    expect(self.initials, 'PS');
  });

  test('exactly one entry is marked as the current user', () {
    final viewModel = LeaderboardViewModel(
      currentUserName: 'Test User',
      attempts: const [],
    );

    expect(viewModel.entries.where((e) => e.isCurrentUser), hasLength(1));
  });
}
