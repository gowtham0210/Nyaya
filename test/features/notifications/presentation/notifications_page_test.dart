import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nyaya/app/notifications_store.dart';
import 'package:nyaya/features/notifications/presentation/notifications_page.dart';
import 'package:nyaya/features/notifications/presentation/notifications_view_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await NotificationsStore.clear();
  });

  Future<void> pumpPage(
    WidgetTester tester, {
    NotificationsViewModel? viewModel,
    VoidCallback? onBackPressed,
  }) async {
    await tester.pumpWidget(
      MaterialApp(
        home: NotificationsPage(
          viewModel: viewModel,
          onBackPressed: onBackPressed,
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('shows each notification with its title and body', (
    tester,
  ) async {
    await pumpPage(
      tester,
      viewModel: NotificationsViewModel(
        notifications: [
          AppNotification(
            id: 'welcome',
            title: 'Welcome to Nyaya',
            body: 'Start your first quiz to begin climbing the leaderboard.',
            type: NotificationType.welcome,
            createdAt: DateTime.now(),
            isRead: false,
          ),
          AppNotification(
            id: 'quiz-1',
            title: 'Quiz completed: Civil & General Law Quiz',
            body: 'You scored 8/10 (80%). Keep it up!',
            type: NotificationType.quizResult,
            createdAt: DateTime.now().subtract(const Duration(hours: 2)),
            isRead: true,
          ),
        ],
      ),
    );

    expect(find.text('Welcome to Nyaya'), findsOneWidget);
    expect(
      find.text('Start your first quiz to begin climbing the leaderboard.'),
      findsOneWidget,
    );
    expect(
      find.text('Quiz completed: Civil & General Law Quiz'),
      findsOneWidget,
    );
    expect(find.text('You scored 8/10 (80%). Keep it up!'), findsOneWidget);

    // Only the unread one shows the unread dot.
    expect(
      find.byKey(const ValueKey('notifications.unreadDot.welcome')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey('notifications.unreadDot.quiz-1')),
      findsNothing,
    );
  });

  testWidgets('shows the empty state when there are no notifications', (
    tester,
  ) async {
    await pumpPage(
      tester,
      viewModel: NotificationsViewModel(notifications: const []),
    );

    expect(find.byKey(const ValueKey('notifications.empty')), findsOneWidget);
    expect(find.text('No notifications yet'), findsOneWidget);
  });

  testWidgets('tapping the back button reports it', (tester) async {
    var backPressed = false;
    await pumpPage(
      tester,
      viewModel: NotificationsViewModel(notifications: const []),
      onBackPressed: () => backPressed = true,
    );

    await tester.tap(find.byKey(const ValueKey('notifications.back')));
    await tester.pumpAndSettle();

    expect(backPressed, isTrue);
  });

  testWidgets('opening the page marks the store notifications read', (
    tester,
  ) async {
    await NotificationsStore.addQuizCompletedNotification(
      topicTitle: 'Fundamental Rights Quiz',
      correctCount: 9,
      total: 10,
    );
    expect(NotificationsStore.unreadCount, 1);

    // The page displays an explicit snapshot (still showing the original
    // unread state) while the live store is marked read in the background.
    final displayedSnapshot = NotificationsViewModel(
      notifications: List.of(NotificationsStore.notifications),
    );
    await pumpPage(tester, viewModel: displayedSnapshot);

    expect(
      find.byKey(
        ValueKey(
          'notifications.unreadDot.${displayedSnapshot.notifications.single.id}',
        ),
      ),
      findsOneWidget,
    );
    expect(NotificationsStore.unreadCount, 0);
  });
}
