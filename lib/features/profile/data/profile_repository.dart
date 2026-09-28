import '../../../core/network/api_client.dart';
import '../../../core/network/api_config.dart';

/// The signed-in learner, from `GET /users/me`.
class UserProfile {
  const UserProfile({
    required this.fullName,
    this.phone,
    this.profession,
    this.avatarUrl,
  });

  final String fullName;
  final String? phone;
  final String? profession;

  /// Absolute photo URL; null when there's no photo.
  final String? avatarUrl;
}

/// The learner's headline numbers.
class ProfileStats {
  const ProfileStats({
    required this.streak,
    required this.categoriesExplored,
    required this.quizzesCompleted,
    required this.points,
  });

  final int streak;
  final int categoriesExplored;
  final int quizzesCompleted;
  final int points;
}

/// Everything the Profile tab shows.
class ProfileOverview {
  const ProfileOverview({required this.profile, required this.stats});

  final UserProfile profile;
  final ProfileStats stats;
}

/// Profile and stats from `/users/me` and its progress, streak and
/// categories-explored endpoints, fetched together.
class ProfileRepository {
  ProfileRepository(this._client);

  final ApiClient _client;

  Future<ProfileOverview> fetchOverview() async {
    final [me, progress, streak, explored] = await Future.wait([
      _client.get('/users/me'),
      _client.get('/users/me/progress'),
      _client.get('/users/me/streak'),
      _client.get('/users/me/categories-explored'),
    ]);
    return ProfileOverview(
      profile: toProfile(me),
      stats: ProfileStats(
        streak: _int(streak['currentStreak']),
        categoriesExplored: _int(explored['categoriesExplored']),
        quizzesCompleted: _int(progress['totalQuizzesCompleted']),
        points: _int(progress['totalPoints']),
      ),
    );
  }

  /// Maps a backend `User`; also used by the edit-profile calls.
  static UserProfile toProfile(Map<String, dynamic> json) => UserProfile(
    fullName: json['fullName'] as String,
    phone: _text(json['phone']),
    profession: _text(json['profession']),
    avatarUrl: _absoluteUrl(_text(json['avatarUrl'])),
  );

  /// The backend sends upload paths relative to its origin.
  static String? _absoluteUrl(String? path) {
    if (path == null || path.startsWith('http')) {
      return path;
    }
    return '${ApiConfig.baseUrl}${path.startsWith('/') ? '' : '/'}$path';
  }

  static int _int(Object? value) => (value as num?)?.toInt() ?? 0;

  static String? _text(Object? value) {
    final text = (value as String?)?.trim();
    return text == null || text.isEmpty ? null : text;
  }
}
