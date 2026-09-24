/// A help/support request the user submitted (POST /users/me/support-requests),
/// as stored by the backend.
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
  final String status;
  final DateTime createdAt;

  factory SupportRequest.fromJson(Map<String, dynamic> json) {
    return SupportRequest(
      id: json['id'] as int,
      subject: json['subject'] as String,
      message: json['message'] as String,
      status: json['status'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String).toLocal(),
    );
  }
}
