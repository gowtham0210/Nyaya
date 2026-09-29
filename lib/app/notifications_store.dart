import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'api_client.dart';
import 'app_session.dart';
import 'notifications_api.dart';

enum NotificationType { welcome, quizResult, streakMilestone }

class AppNotification {
  const AppNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    required this.createdAt,
    required this.isRead,
  });

  final String id;
  final String title;
  final String body;
  final NotificationType type;
  final DateTime createdAt;
  final bool isRead;

  AppNotification copyWith({bool? isRead}) => AppNotification(
    id: id,
    title: title,
    body: body,
    type: type,
    createdAt: createdAt,
    isRead: isRead ?? this.isRead,
  );

  Map<String, Object?> toJson() => {
    'id': id,
    'title': title,
    'body': body,
    'type': type.name,
    'createdAt': createdAt.toIso8601String(),
    'isRead': isRead,
  };

  static AppNotification fromJson(Map<String, Object?> json) => AppNotification(
    id: json['id'] as String,
    title: json['title'] as String,
    body: json['body'] as String,
    type: NotificationType.values.byName(json['type'] as String),
    createdAt: DateTime.parse(json['createdAt'] as String),
    isRead: json['isRead'] as bool,
  );
}

/// Notifications feed, newest first, backed by `/notifications` with a
/// locally persisted cache for offline/first-launch rendering. Powers the
/// Home bell icon's unread badge and the Notifications page.
class NotificationsStore {
  NotificationsStore._();

  static const _key = 'notifications.items';
  static const _maxStored = 30;

  /// Seeded with a welcome notification so a fresh install shows the
  /// unread badge, same as before this store existed.
  static List<AppNotification> notifications = [_welcomeNotification()];

  static AppNotification _welcomeNotification() => AppNotification(
    id: 'welcome',
    title: 'Welcome to Nyaya',
    body: 'Start your first quiz to begin climbing the leaderboard.',
    type: NotificationType.welcome,
    createdAt: DateTime.now(),
    isRead: false,
  );

  static int get unreadCount =>
      notifications.where((notification) => !notification.isRead).length;

  static Future<void> load({NotificationsApi? api}) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_key);
    if (raw == null) {
      // First run on this device: persist the seeded welcome notification
      // so it survives a restart instead of being re-created every launch.
      await _persist();
    } else {
      notifications = raw
          .map(
            (entry) => AppNotification.fromJson(
              jsonDecode(entry) as Map<String, Object?>,
            ),
          )
          .toList();
    }

    // The cached/seeded list above renders immediately; refresh it from the
    // backend when signed in, same offline-first pattern as the other
    // stores. Signed out or unreachable just keeps the local list.
    if (AppSession.accessToken == null) {
      return;
    }
    try {
      notifications = await (api ?? NotificationsApi()).fetchNotifications();
      await _persist();
    } on ApiException {
      // Offline: keep the local list.
    }
  }

  static Future<void> addQuizCompletedNotification({
    required String topicTitle,
    required int correctCount,
    required int total,
  }) async {
    if (total <= 0) {
      return;
    }
    final percent = ((correctCount / total) * 100).round();
    final notification = AppNotification(
      id: 'quiz-${DateTime.now().microsecondsSinceEpoch}',
      title: 'Quiz completed: $topicTitle',
      body: 'You scored $correctCount/$total ($percent%). Keep it up!',
      type: NotificationType.quizResult,
      createdAt: DateTime.now(),
      isRead: false,
    );
    notifications = [notification, ...notifications].take(_maxStored).toList();
    await _persist();
  }

  static Future<void> addStreakMilestoneNotification(int currentStreak) async {
    final notification = AppNotification(
      id: 'streak-$currentStreak',
      title: '$currentStreak day streak!',
      body: "You've kept your streak going for $currentStreak days. Don't break it now.",
      type: NotificationType.streakMilestone,
      createdAt: DateTime.now(),
      isRead: false,
    );
    notifications = [notification, ...notifications].take(_maxStored).toList();
    await _persist();
  }

  static Future<void> markAllRead({NotificationsApi? api}) async {
    if (notifications.every((notification) => notification.isRead)) {
      return;
    }
    notifications = [
      for (final notification in notifications)
        notification.copyWith(isRead: true),
    ];
    await _persist();
    if (AppSession.accessToken == null) {
      return;
    }
    try {
      await (api ?? NotificationsApi()).markAllRead();
    } on ApiException {
      // Best effort: the local badge is already cleared either way.
    }
  }

  static Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      _key,
      notifications
          .map((notification) => jsonEncode(notification.toJson()))
          .toList(),
    );
  }

  static Future<void> clear() async {
    notifications = [];
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
