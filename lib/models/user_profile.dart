/// The signed-in user's profile, matching the backend's `User` schema
/// exactly (see serializeUser in nyaya_backend src/utils/serializers.js).
class UserProfile {
  const UserProfile({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.profession,
    required this.avatarUrl,
    required this.status,
  });

  final int id;
  final String fullName;
  final String email;
  final String? phone;
  final String? profession;
  final String? avatarUrl;
  final String status;

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] as int,
      fullName: json['fullName'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String?,
      profession: json['profession'] as String?,
      avatarUrl: json['avatarUrl'] as String?,
      status: json['status'] as String,
    );
  }
}
