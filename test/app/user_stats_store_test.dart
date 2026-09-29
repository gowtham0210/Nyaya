import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:nyaya/app/api_client.dart';
import 'package:nyaya/app/app_session.dart';
import 'package:nyaya/app/user_api.dart';
import 'package:nyaya/app/user_stats_store.dart';
import 'package:nyaya/features/leaderboard/presentation/leaderboard_view_model.dart';
import 'package:nyaya/features/profile/presentation/profile_view_model.dart';
import 'package:nyaya/features/quiz_question/data/quiz_api.dart';

void main() {
  setUp(() {
    AppSession.accessToken = 'test-token';
    UserStatsStore.latest = null;
  });
  tearDown(() {
    AppSession.accessToken = null;
    UserStatsStore.latest = null;
  });

  http.Response ok(Object body) => http.Response(
    jsonEncode(body),
    200,
    headers: {'content-type': 'application/json'},
  );

  /// A backend where the signed-in user (id 2) sits second of three.
  MockClient healthyServer() => MockClient((request) async {
    switch (request.url.path) {
      case '/api/v1/leaderboards/global':
        return ok({
          'items': [
            {
              'rank': 1,
              'userId': 7,
              'fullName': 'Ananya Iyer',
              'totalPoints': 320,
              'currentLevelId': 2,
            },
            {
              'rank': 2,
              'userId': 2,
              'fullName': 'AnshulTestUser',
              'totalPoints': 100,
              'currentLevelId': 1,
            },
            {
              'rank': 3,
              'userId': 5,
              'fullName': 'Rohan Mehta',
              'totalPoints': 40,
              'currentLevelId': 1,
            },
          ],
        });
      case '/api/v1/users/me':
        return ok({'id': 2, 'fullName': 'AnshulTestUser', 'email': 'a@b.c'});
      case '/api/v1/users/me/progress':
        return ok({
          'userId': 2,
          'totalPoints': 100,
          'currentLevelId': 1,
          'totalQuizzesAttempted': 2,
          'totalQuizzesCompleted': 2,
          'totalQuestionsAnswered': 30,
          'totalCorrectAnswers': 10,
          'totalWrongAnswers': 20,
          'accuracyPercentage': 33.33,
        });
      case '/api/v1/users/me/streak':
        return ok({'userId': 2, 'currentStreak': 3, 'maxStreak': 5});
      case '/api/v1/quiz-attempts':
        return ok({
          'items': [
            {
              'id': 5,
              'quizId': 1,
              'status': 'submitted',
              'totalQuestions': 15,
              'answeredQuestions': 15,
              'correctAnswers': 6,
              'submittedAt': '2026-09-05T20:10:43.000Z',
            },
            {
              'id': 6,
              'quizId': 3,
              'status': 'in_progress',
              'totalQuestions': 10,
              'answeredQuestions': 2,
              'correctAnswers': 1,
              'submittedAt': null,
            },
          ],
        });
      default:
        return ok({
          'items': [
            {
              'id': 1,
              'slug': 'indian-constitution-quiz',
              'title': 'Indian Constitution Quiz',
              'totalQuestions': 15,
            },
            {
              'id': 3,
              'slug': 'fundamental-rights-quiz',
              'title': 'Fundamental Rights Quiz',
              'totalQuestions': 10,
            },
          ],
        });
    }
  });

  Future<UserStats?> load(MockClient client) {
    final api = ApiClient(baseUrl: 'http://test/api/v1', httpClient: client);
    return UserStatsStore.refresh(
      userApi: UserApi(client: api),
      quizApi: QuizApi(client: api),
    );
  }

  test(
    'loads the ranking, the user own id, progress, streak and history',
    () async {
      final stats = await load(healthyServer());

      expect(stats, isNotNull);
      expect(stats!.leaderboard, hasLength(3));
      expect(stats.currentUserId, 2);
      expect(stats.rank, 2);
      expect(stats.progress.totalPoints, 100);
      expect(stats.progress.accuracyPercentage, closeTo(33.33, 0.01));
      expect(stats.streak.currentStreak, 3);

      // Only the submitted attempt becomes history, labelled with its title.
      expect(stats.completedAttempts, hasLength(1));
      expect(
        stats.completedAttempts.single.topicTitle,
        'Indian Constitution Quiz',
      );
      expect(stats.completedAttempts.single.correctCount, 6);
      expect(stats.completedAttempts.single.total, 15);
    },
  );

  test(
    'the leaderboard renders the server ranking and marks the user',
    () async {
      final stats = await load(healthyServer());
      final board = LeaderboardViewModel(stats: stats);

      expect(board.isLive, isTrue);
      expect(board.entries.map((e) => e.name), [
        'Ananya Iyer',
        'AnshulTestUser',
        'Rohan Mehta',
      ]);
      expect(board.entries.map((e) => e.points), [320, 100, 40]);
      expect(board.entries.where((e) => e.isCurrentUser).single.rank, 2);
      expect(board.podium, hasLength(3));
      expect(board.remaining, isEmpty);
    },
  );

  test('a ranking too short for a podium still lists everyone', () async {
    final loaded = await load(healthyServer());
    final twoPeople = UserStats(
      leaderboard: loaded!.leaderboard.take(2).toList(),
      currentUserId: 2,
      progress: loaded.progress,
      streak: loaded.streak,
      completedAttempts: const [],
    );

    final board = LeaderboardViewModel(stats: twoPeople);

    // A half-filled podium would render as a broken layout, so both rows go
    // in the list instead of vanishing between the two sections.
    expect(board.podium, isEmpty);
    expect(board.remaining, hasLength(2));
    expect(board.entries, hasLength(2));
  });

  test('the profile reads its stats from the server', () async {
    final stats = await load(healthyServer());
    final profile = ProfileViewModel(
      fullName: 'AnshulTestUser',
      email: 'a@b.c',
      stats: stats,
    );

    expect(profile.isLive, isTrue);
    expect(profile.totalPoints, 100);
    expect(profile.currentStreak, 3);
    expect(profile.quizzesCompleted, 2);
    expect(profile.questionsAnswered, 30);
    expect(profile.averageScorePercent, 33);
    expect(profile.leaderboardRank, 2);
    expect(
      profile.recentAttempts.single.topicTitle,
      'Indian Constitution Quiz',
    );
  });

  test('a user not yet on the ranking is placed after everyone', () async {
    final loaded = await load(healthyServer());
    // Same ranking, but viewed as someone who has not finished a quiz and so
    // does not appear on it at all.
    final stats = UserStats(
      leaderboard: loaded!.leaderboard,
      currentUserId: 99,
      progress: loaded.progress,
      streak: loaded.streak,
      completedAttempts: const [],
    );

    expect(stats.rank, isNull);
    expect(ProfileViewModel(stats: stats).leaderboardRank, 4);
  });

  test('an unreachable server leaves the screens on local data', () async {
    final stats = await load(
      MockClient((_) async => throw http.ClientException('offline')),
    );

    expect(stats, isNull);
    expect(UserStatsStore.latest, isNull);
    // Falls back to the sample board rather than rendering nothing.
    expect(LeaderboardViewModel(stats: null).isLive, isFalse);
    expect(LeaderboardViewModel(stats: null).entries, isNotEmpty);
    expect(ProfileViewModel(stats: null).isLive, isFalse);
  });

  test('a signed-out user never calls the backend', () async {
    AppSession.accessToken = null;

    final stats = await load(
      MockClient((_) async => throw StateError('should not be called')),
    );

    expect(stats, isNull);
  });
}
