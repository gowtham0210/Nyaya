import 'package:flutter_test/flutter_test.dart';
import 'package:nyaya/app/notifications_store.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await NotificationsStore.clear();
  });

  test('clear resets to no notifications', () {
    expect(NotificationsStore.notifications, isEmpty);
    expect(NotificationsStore.unreadCount, 0);
  });

  test(
    'recording a quiz result adds an unread notification at the front',
    () async {
      await NotificationsStore.addQuizCompletedNotification(
        topicTitle: 'Civil & General Law Quiz',
        correctCount: 8,
        total: 10,
      );
      await NotificationsStore.addQuizCompletedNotification(
        topicTitle: 'Criminal Law Quiz',
        correctCount: 12,
        total: 15,
      );

      expect(NotificationsStore.notifications, hasLength(2));
      expect(
        NotificationsStore.notifications.first.title,
        'Quiz completed: Criminal Law Quiz',
      );
      expect(NotificationsStore.notifications.first.isRead, isFalse);
      expect(NotificationsStore.unreadCount, 2);
    },
  );

  test('a quiz result with zero questions is not recorded', () async {
    await NotificationsStore.addQuizCompletedNotification(
      topicTitle: 'Empty Quiz',
      correctCount: 0,
      total: 0,
    );

    expect(NotificationsStore.notifications, isEmpty);
  });

  test('markAllRead clears the unread count', () async {
    await NotificationsStore.addQuizCompletedNotification(
      topicTitle: 'Fundamental Rights Quiz',
      correctCount: 9,
      total: 10,
    );
    expect(NotificationsStore.unreadCount, 1);

    await NotificationsStore.markAllRead();

    expect(NotificationsStore.unreadCount, 0);
    expect(NotificationsStore.notifications.every((n) => n.isRead), isTrue);
  });

  test('notifications survive a reload', () async {
    await NotificationsStore.addQuizCompletedNotification(
      topicTitle: 'Contract Act Quiz',
      correctCount: 6,
      total: 12,
    );

    NotificationsStore.notifications = [];
    await NotificationsStore.load();

    expect(NotificationsStore.notifications, hasLength(1));
    expect(
      NotificationsStore.notifications.single.title,
      'Quiz completed: Contract Act Quiz',
    );
  });

  test('read state survives a reload', () async {
    await NotificationsStore.addQuizCompletedNotification(
      topicTitle: 'Taxation Law Quiz',
      correctCount: 10,
      total: 15,
    );
    await NotificationsStore.markAllRead();

    NotificationsStore.notifications = [];
    await NotificationsStore.load();

    expect(NotificationsStore.notifications.single.isRead, isTrue);
  });

  test('clear removes everything and persists the reset', () async {
    await NotificationsStore.addQuizCompletedNotification(
      topicTitle: 'Property & Real Estate Quiz',
      correctCount: 5,
      total: 15,
    );

    await NotificationsStore.clear();
    await NotificationsStore.load();

    expect(NotificationsStore.notifications, isEmpty);
  });
}
