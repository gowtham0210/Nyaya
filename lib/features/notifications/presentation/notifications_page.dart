import 'package:flutter/material.dart';

import '../../../app/notifications_store.dart';
import '../../home/presentation/home_page.dart';
import 'notifications_view_model.dart';

/// Home's notification bell destination: the device's notification feed,
/// generated from real in-app activity (a welcome note, then one per
/// completed quiz). Opening this page marks every notification read, so
/// the bell's unread badge clears once the user has actually seen them.
class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key, this.viewModel, this.onBackPressed});

  final NotificationsViewModel? viewModel;
  final VoidCallback? onBackPressed;

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  late final NotificationsViewModel _viewModel =
      widget.viewModel ?? NotificationsViewModel();

  @override
  void initState() {
    super.initState();
    // The snapshot above already captured which items were unread when
    // this page opened, so marking the store read now doesn't change
    // what's rendered here — it only clears Home's badge going forward.
    NotificationsStore.markAllRead();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HomePage.pageBackground,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 24, 0),
              child: Row(
                children: [
                  IconButton(
                    key: const ValueKey('notifications.back'),
                    onPressed: () {
                      final callback = widget.onBackPressed;
                      if (callback != null) {
                        callback();
                        return;
                      }
                      Navigator.of(context).maybePop();
                    },
                    icon: const Icon(
                      Icons.arrow_back_rounded,
                      color: HomePage.heroBackground,
                    ),
                  ),
                  const Text(
                    'Notifications',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: HomePage.heroBackground,
                      letterSpacing: -0.3,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: _viewModel.isEmpty
                  ? const _EmptyNotifications()
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
                      itemCount: _viewModel.notifications.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 10),
                      itemBuilder: (context, index) => _NotificationCard(
                        notification: _viewModel.notifications[index],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyNotifications extends StatelessWidget {
  const _EmptyNotifications();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Container(
          key: const ValueKey('notifications.empty'),
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: HomePage.cardBorder),
          ),
          child: const Column(
            children: [
              Icon(
                Icons.notifications_none_rounded,
                size: 32,
                color: HomePage.mutedIcon,
              ),
              SizedBox(height: 12),
              Text(
                'No notifications yet',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: HomePage.heroBackground,
                ),
              ),
              SizedBox(height: 6),
              Text(
                "We'll let you know here when there's something new.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: HomePage.supportText,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  const _NotificationCard({required this.notification});

  final AppNotification notification;

  IconData get _icon => switch (notification.type) {
    NotificationType.welcome => Icons.celebration_rounded,
    NotificationType.quizResult => Icons.fact_check_rounded,
    NotificationType.streakMilestone => Icons.local_fire_department_rounded,
  };

  String get _relativeTime {
    final createdAt = notification.createdAt;
    final difference = DateTime.now().difference(createdAt);
    if (difference.inMinutes < 1) {
      return 'Just now';
    }
    if (difference.inMinutes < 60) {
      final minutes = difference.inMinutes;
      return '$minutes ${minutes == 1 ? 'minute' : 'minutes'} ago';
    }
    if (difference.inHours < 24) {
      final hours = difference.inHours;
      return '$hours ${hours == 1 ? 'hour' : 'hours'} ago';
    }
    final days = difference.inDays;
    if (days == 1) {
      return 'Yesterday';
    }
    if (days < 7) {
      return '$days days ago';
    }
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[createdAt.month - 1]} ${createdAt.day}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      key: ValueKey('notifications.item.${notification.id}'),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: notification.isRead
              ? HomePage.cardBorder
              : HomePage.heroHighlight.withValues(alpha: 0.5),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: HomePage.heroHighlight.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Icon(_icon, color: HomePage.heroHighlight, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        notification.title,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: HomePage.heroBackground,
                        ),
                      ),
                    ),
                    if (!notification.isRead)
                      Container(
                        key: ValueKey(
                          'notifications.unreadDot.${notification.id}',
                        ),
                        width: 8,
                        height: 8,
                        margin: const EdgeInsets.only(left: 8, top: 4),
                        decoration: const BoxDecoration(
                          color: HomePage.heroHighlight,
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  notification.body,
                  style: const TextStyle(
                    fontSize: 12.5,
                    color: HomePage.supportText,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  _relativeTime,
                  style: const TextStyle(
                    fontSize: 11,
                    color: HomePage.mutedIcon,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
