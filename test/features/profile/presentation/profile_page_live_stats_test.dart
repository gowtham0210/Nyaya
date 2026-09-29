import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nyaya/app/quiz_history_store.dart';
import 'package:nyaya/app/user_api.dart';
import 'package:nyaya/app/user_stats_store.dart';
import 'package:nyaya/features/profile/presentation/profile_page.dart';
import 'package:nyaya/features/profile/presentation/profile_view_model.dart';

/// Rebuilds [ProfilePage] with a new view model, the way the app does once
/// the backend stats land after the first frame.
class _StatsArriveLater extends StatefulWidget {
  const _StatsArriveLater({super.key, required this.later});

  final ProfileViewModel later;

  @override
  State<_StatsArriveLater> createState() => _StatsArriveLaterState();
}

class _StatsArriveLaterState extends State<_StatsArriveLater> {
  ProfileViewModel? _viewModel;

  void deliver() => setState(() => _viewModel = widget.later);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ProfilePage(viewModel: _viewModel ?? ProfileViewModel()),
    );
  }
}

void main() {
  const stats = UserStats(
    leaderboard: [
      RemoteLeaderboardEntry(
        rank: 1,
        userId: 9,
        fullName: 'Ananya',
        totalPoints: 300,
      ),
      RemoteLeaderboardEntry(
        rank: 2,
        userId: 1,
        fullName: 'Nyaya Admin',
        totalPoints: 40,
      ),
    ],
    currentUserId: 1,
    progress: RemoteProgress(
      totalPoints: 40,
      quizzesCompleted: 1,
      questionsAnswered: 10,
      correctAnswers: 4,
      accuracyPercentage: 40,
    ),
    streak: RemoteStreak(currentStreak: 2, maxStreak: 4),
    completedAttempts: [],
  );

  setUp(() => QuizHistoryStore.attempts = []);
  tearDown(() => QuizHistoryStore.attempts = []);

  testWidgets('the page adopts stats that arrive after the first frame', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    final key = GlobalKey<_StatsArriveLaterState>();
    await tester.pumpWidget(
      _StatsArriveLater(
        key: key,
        later: ProfileViewModel(
          fullName: 'Nyaya Admin',
          email: 'admin@nyaya.local',
          stats: stats,
        ),
      ),
    );
    await tester.pumpAndSettle();

    // First frame: no backend stats, so everything reads zero.
    expect(find.text('0%'), findsOneWidget);

    key.currentState!.deliver();
    await tester.pumpAndSettle();

    // The page must pick up the new view model rather than keeping the
    // one its `late` field was first built with.
    expect(find.text('40%'), findsOneWidget);
    expect(find.text('0%'), findsNothing);
    expect(find.text('Rank #2 on the Leaderboard'), findsOneWidget);
  });

  test('a local profile edit keeps the backend stats', () {
    final live = ProfileViewModel(
      fullName: 'Nyaya Admin',
      email: 'admin@nyaya.local',
      stats: stats,
    );

    // What the page builds after the edit dialog returns.
    final edited = ProfileViewModel(
      fullName: 'Renamed Admin',
      email: live.email,
      goalId: live.goalId,
      attempts: live.attempts,
      memberSince: live.memberSince,
      memberSinceProvided: true,
      stats: live.stats,
    );

    expect(edited.fullName, 'Renamed Admin');
    expect(edited.isLive, isTrue, reason: 'stats must survive the rebuild');
    expect(edited.averageScorePercent, 40);
    expect(edited.leaderboardRank, 2);
  });
}
