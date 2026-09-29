import '../../../app/notifications_store.dart';

/// Read model for the Notifications page: the signed-in device's
/// notification feed, newest first.
///
/// Defaults to the live [NotificationsStore] but accepts an override so
/// tests don't need real `SharedPreferences` state.
class NotificationsViewModel {
  NotificationsViewModel({List<AppNotification>? notifications})
    : notifications = notifications ?? NotificationsStore.notifications;

  final List<AppNotification> notifications;

  bool get isEmpty => notifications.isEmpty;
}
