import 'api_client.dart';
import 'notifications_store.dart';

/// Reads and clears the signed-in user's notification feed under
/// `/notifications`.
class NotificationsApi {
  NotificationsApi({ApiClient? client}) : _client = client ?? ApiClient();

  final ApiClient _client;

  Future<List<AppNotification>> fetchNotifications() async {
    final json = await _client.get('/notifications');
    final items = json['items'] as List<Object?>;
    return [
      for (final item in items)
        AppNotification.fromJson(item as Map<String, Object?>),
    ];
  }

  Future<void> markAllRead() async {
    await _client.post('/notifications/mark-all-read', const {});
  }
}
