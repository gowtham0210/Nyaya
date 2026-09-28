import '../../../core/network/api_client.dart';

/// Where a support request stands. Unknown backend values count as open.
enum SupportStatus {
  open,
  inProgress,
  resolved,
  closed;

  static SupportStatus fromBackend(String? value) => switch (value) {
    'in_progress' => inProgress,
    'resolved' => resolved,
    'closed' => closed,
    _ => open,
  };
}

/// A request the learner sent to the Nyaya team.
class SupportRequest {
  const SupportRequest({
    required this.id,
    required this.subject,
    required this.message,
    required this.status,
    required this.createdAt,
  });

  final int id;
  final String subject;
  final String message;
  final SupportStatus status;

  /// Local time; null when the backend sent none.
  final DateTime? createdAt;
}

/// Support requests at `/users/me/support-requests`.
class SupportRepository {
  SupportRepository(this._client);

  final ApiClient _client;

  /// The learner's requests, newest first.
  Future<List<SupportRequest>> fetchRequests() async {
    final body = await _client.get('/users/me/support-requests');
    return [
      for (final item in body['items'] as List<dynamic>? ?? const [])
        _toRequest(item as Map<String, dynamic>),
    ]..sort(_newestFirst);
  }

  /// Sends a request. The reply isn't read, so an odd reply can't make a
  /// stored request look failed.
  Future<void> send({required String subject, required String message}) =>
      _client.post(
        '/users/me/support-requests',
        body: {'subject': subject, 'message': message},
      );

  /// Newest first; undated requests last.
  static int _newestFirst(SupportRequest a, SupportRequest b) {
    final aDate = a.createdAt, bDate = b.createdAt;
    if (aDate == null || bDate == null) {
      return (aDate == null ? 1 : 0) - (bDate == null ? 1 : 0);
    }
    return bDate.compareTo(aDate);
  }

  static SupportRequest _toRequest(Map<String, dynamic> json) {
    final createdAt = DateTime.tryParse(json['createdAt'] as String? ?? '');
    return SupportRequest(
      id: json['id'] as int,
      subject: json['subject'] as String,
      message: json['message'] as String? ?? '',
      status: SupportStatus.fromBackend(json['status'] as String?),
      createdAt: createdAt?.toLocal(),
    );
  }
}
