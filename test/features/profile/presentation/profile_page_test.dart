import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nyaya/app/quiz_history_store.dart';
import 'package:nyaya/features/profile/presentation/profile_page.dart';
import 'package:nyaya/features/profile/presentation/profile_view_model.dart';

void main() {
  Future<void> pumpPage(
    WidgetTester tester, {
    ProfileViewModel? viewModel,
    VoidCallback? onBackPressed,
    ValueChanged<int>? onNavigationSelected,
    void Function(String fullName, String email)? onSaveProfile,
    ValueChanged<String>? onChangeGoal,
    VoidCallback? onSignOut,
    VoidCallback? onViewLeaderboard,
    VoidCallback? onStartQuizPressed,
  }) async {
    await tester.pumpWidget(
      MaterialApp(
        home: ProfilePage(
          viewModel: viewModel,
          onBackPressed: onBackPressed,
          onNavigationSelected: onNavigationSelected,
          onSaveProfile: onSaveProfile,
          onChangeGoal: onChangeGoal,
          onSignOut: onSignOut,
          onViewLeaderboard: onViewLeaderboard,
          onStartQuizPressed: onStartQuizPressed,
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('shows the user\'s name, email, and initials', (tester) async {
    await pumpPage(
      tester,
      viewModel: ProfileViewModel(
        fullName: 'Priya Sharma',
        email: 'priya@example.com',
        attempts: const [],
      ),
    );

    expect(find.text('Priya Sharma'), findsOneWidget);
    expect(find.text('priya@example.com'), findsOneWidget);
    expect(find.text('PS'), findsOneWidget);
  });

  testWidgets('shows computed stats from quiz history', (tester) async {
    await pumpPage(
      tester,
      viewModel: ProfileViewModel(
        fullName: 'Priya Sharma',
        email: 'priya@example.com',
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
      ),
    );

    expect(
      find.descendant(
        of: find.byKey(const ValueKey('profile.stat.quizzes')),
        matching: find.text('2'),
      ),
      findsOneWidget,
    );
    expect(
      find.descendant(
        of: find.byKey(const ValueKey('profile.stat.average')),
        matching: find.text('80%'),
      ),
      findsOneWidget,
    );
    expect(
      find.descendant(
        of: find.byKey(const ValueKey('profile.stat.questions')),
        matching: find.text('25'),
      ),
      findsOneWidget,
    );
  });

  testWidgets('shows a choose-a-goal prompt when no goal is selected', (
    tester,
  ) async {
    await pumpPage(
      tester,
      viewModel: ProfileViewModel(
        fullName: 'Priya Sharma',
        email: 'priya@example.com',
        attempts: const [],
      ),
    );

    await tester.dragUntilVisible(
      find.byKey(const ValueKey('profile.goal.empty')),
      find.byType(Scrollable),
      const Offset(0, -300),
    );

    expect(find.byKey(const ValueKey('profile.goal.empty')), findsOneWidget);
    expect(find.text('No goal selected'), findsOneWidget);
  });

  testWidgets('shows the selected goal and its description', (tester) async {
    await pumpPage(
      tester,
      viewModel: ProfileViewModel(
        fullName: 'Priya Sharma',
        email: 'priya@example.com',
        goalId: 'crack-an-exam',
        attempts: const [],
      ),
    );

    await tester.dragUntilVisible(
      find.byKey(const ValueKey('profile.goal.card')),
      find.byType(Scrollable),
      const Offset(0, -300),
    );

    expect(find.byKey(const ValueKey('profile.goal.card')), findsOneWidget);
    expect(find.text('Crack an exam'), findsOneWidget);
  });

  testWidgets('shows the empty activity state with no attempts', (
    tester,
  ) async {
    await pumpPage(
      tester,
      viewModel: ProfileViewModel(
        fullName: 'Priya Sharma',
        email: 'priya@example.com',
        attempts: const [],
      ),
    );

    await tester.dragUntilVisible(
      find.byKey(const ValueKey('profile.activity.empty')),
      find.byType(Scrollable),
      const Offset(0, -300),
    );

    expect(
      find.byKey(const ValueKey('profile.activity.empty')),
      findsOneWidget,
    );
    expect(find.text('No quizzes completed yet'), findsOneWidget);
  });

  testWidgets('lists recent quiz attempts with their score', (tester) async {
    await pumpPage(
      tester,
      viewModel: ProfileViewModel(
        fullName: 'Priya Sharma',
        email: 'priya@example.com',
        attempts: [
          QuizAttempt(
            topicTitle: 'Fundamental Rights Quiz',
            correctCount: 9,
            total: 10,
            completedAt: DateTime.now(),
          ),
        ],
      ),
    );

    await tester.dragUntilVisible(
      find.byKey(const ValueKey('profile.attempt.0')),
      find.byType(Scrollable),
      const Offset(0, -300),
    );

    expect(find.byKey(const ValueKey('profile.attempt.0')), findsOneWidget);
    expect(find.text('Fundamental Rights Quiz'), findsOneWidget);
    expect(find.text('9/10 · 90%'), findsOneWidget);
  });

  testWidgets('editing the profile validates and saves the new details', (
    tester,
  ) async {
    String? savedName;
    String? savedEmail;
    await pumpPage(
      tester,
      viewModel: ProfileViewModel(
        fullName: 'Priya Sharma',
        email: 'priya@example.com',
        attempts: const [],
      ),
      onSaveProfile: (fullName, email) {
        savedName = fullName;
        savedEmail = email;
      },
    );

    await tester.tap(find.byKey(const ValueKey('profile.edit')));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(const ValueKey('profile.editDialog.fullName')),
      'A',
    );
    await tester.tap(find.byKey(const ValueKey('profile.editDialog.save')));
    await tester.pumpAndSettle();

    expect(find.text('Name must be at least 3 characters'), findsOneWidget);
    expect(savedName, isNull);

    await tester.enterText(
      find.byKey(const ValueKey('profile.editDialog.fullName')),
      'Anjali Rao',
    );
    await tester.enterText(
      find.byKey(const ValueKey('profile.editDialog.email')),
      'anjali@example.com',
    );
    await tester.tap(find.byKey(const ValueKey('profile.editDialog.save')));
    await tester.pumpAndSettle();

    expect(savedName, 'Anjali Rao');
    expect(savedEmail, 'anjali@example.com');
    expect(find.text('Anjali Rao'), findsOneWidget);
    expect(find.text('anjali@example.com'), findsOneWidget);
  });

  testWidgets('canceling the edit dialog keeps the original details', (
    tester,
  ) async {
    var saveCalled = false;
    await pumpPage(
      tester,
      viewModel: ProfileViewModel(
        fullName: 'Priya Sharma',
        email: 'priya@example.com',
        attempts: const [],
      ),
      onSaveProfile: (_, _) => saveCalled = true,
    );

    await tester.tap(find.byKey(const ValueKey('profile.edit')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('profile.editDialog.cancel')));
    await tester.pumpAndSettle();

    expect(saveCalled, isFalse);
    expect(find.text('Priya Sharma'), findsOneWidget);
  });

  testWidgets('changing the goal updates the selected goal', (tester) async {
    String? changedGoalId;
    await pumpPage(
      tester,
      viewModel: ProfileViewModel(
        fullName: 'Priya Sharma',
        email: 'priya@example.com',
        goalId: 'learn-law-for-life',
        attempts: const [],
      ),
      onChangeGoal: (goalId) => changedGoalId = goalId,
    );

    await tester.dragUntilVisible(
      find.byKey(const ValueKey('profile.goal.change')),
      find.byType(Scrollable),
      const Offset(0, -300),
    );
    await tester.ensureVisible(
      find.byKey(const ValueKey('profile.goal.change')),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey('profile.goal.change')));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey('goal.card.study-law')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('goal.continue')));
    await tester.pumpAndSettle();

    expect(changedGoalId, 'study-law');
    expect(find.text('Study law'), findsOneWidget);
  });

  testWidgets(
    'signing out asks for confirmation before invoking the callback',
    (tester) async {
      var signedOut = false;
      await pumpPage(
        tester,
        viewModel: ProfileViewModel(
          fullName: 'Priya Sharma',
          email: 'priya@example.com',
          attempts: const [],
        ),
        onSignOut: () => signedOut = true,
      );

      await tester.dragUntilVisible(
        find.byKey(const ValueKey('profile.signOut')),
        find.byType(Scrollable),
        const Offset(0, -300),
      );
      await tester.ensureVisible(find.byKey(const ValueKey('profile.signOut')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const ValueKey('profile.signOut')));
      await tester.pumpAndSettle();

      expect(signedOut, isFalse);
      expect(find.text('Sign out?'), findsOneWidget);

      await tester.tap(find.byKey(const ValueKey('profile.signOut.confirm')));
      await tester.pumpAndSettle();

      expect(signedOut, isTrue);
    },
  );

  testWidgets('canceling the sign-out dialog does not sign out', (
    tester,
  ) async {
    var signedOut = false;
    await pumpPage(
      tester,
      viewModel: ProfileViewModel(
        fullName: 'Priya Sharma',
        email: 'priya@example.com',
        attempts: const [],
      ),
      onSignOut: () => signedOut = true,
    );

    await tester.dragUntilVisible(
      find.byKey(const ValueKey('profile.signOut')),
      find.byType(Scrollable),
      const Offset(0, -300),
    );
    await tester.ensureVisible(find.byKey(const ValueKey('profile.signOut')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('profile.signOut')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('profile.signOut.cancel')));
    await tester.pumpAndSettle();

    expect(signedOut, isFalse);
    expect(find.byKey(const ValueKey('profile.back')), findsOneWidget);
  });

  testWidgets('tapping the back button reports it', (tester) async {
    var backPressed = false;
    await pumpPage(
      tester,
      viewModel: ProfileViewModel(
        fullName: 'Priya Sharma',
        email: 'priya@example.com',
        attempts: const [],
      ),
      onBackPressed: () => backPressed = true,
    );

    await tester.tap(find.byKey(const ValueKey('profile.back')));
    await tester.pumpAndSettle();

    expect(backPressed, isTrue);
  });

  testWidgets('tapping a bottom nav tab reports its index', (tester) async {
    int? selectedIndex;
    await pumpPage(
      tester,
      viewModel: ProfileViewModel(
        fullName: 'Priya Sharma',
        email: 'priya@example.com',
        attempts: const [],
      ),
      onNavigationSelected: (index) => selectedIndex = index,
    );

    await tester.tap(find.byKey(const ValueKey('home.nav.home')));
    await tester.pumpAndSettle();

    expect(selectedIndex, 0);
  });

  testWidgets('shows the live leaderboard rank and reports taps on it', (
    tester,
  ) async {
    var viewedLeaderboard = false;
    await pumpPage(
      tester,
      viewModel: ProfileViewModel(
        fullName: 'Priya Sharma',
        email: 'priya@example.com',
        attempts: const [],
      ),
      onViewLeaderboard: () => viewedLeaderboard = true,
    );

    expect(find.byKey(const ValueKey('profile.rankBadge')), findsOneWidget);
    expect(find.textContaining('Rank #'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('profile.rankBadge')));
    await tester.pumpAndSettle();

    expect(viewedLeaderboard, isTrue);
  });

  testWidgets('shows a member-since label when the join date is known', (
    tester,
  ) async {
    await pumpPage(
      tester,
      viewModel: ProfileViewModel(
        fullName: 'Priya Sharma',
        email: 'priya@example.com',
        attempts: const [],
        memberSince: DateTime(2026, 9, 1),
        memberSinceProvided: true,
      ),
    );

    expect(find.byKey(const ValueKey('profile.memberSince')), findsOneWidget);
    expect(find.text('Member since Sep 2026'), findsOneWidget);
  });

  testWidgets('the empty activity state offers a CTA that reports taps on it', (
    tester,
  ) async {
    var startedQuiz = false;
    await pumpPage(
      tester,
      viewModel: ProfileViewModel(
        fullName: 'Priya Sharma',
        email: 'priya@example.com',
        attempts: const [],
      ),
      onStartQuizPressed: () => startedQuiz = true,
    );

    await tester.dragUntilVisible(
      find.byKey(const ValueKey('profile.startQuiz')),
      find.byType(Scrollable),
      const Offset(0, -300),
    );
    await tester.ensureVisible(find.byKey(const ValueKey('profile.startQuiz')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('profile.startQuiz')));
    await tester.pumpAndSettle();

    expect(startedQuiz, isTrue);
  });
}
