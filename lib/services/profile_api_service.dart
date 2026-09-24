import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../config/api_config.dart';
import '../models/profile_stats.dart';
import '../models/support_request.dart';
import '../models/user_profile.dart';
import 'api_exceptions.dart';

/// Calls the real NYAYA user-profile endpoints
/// (nyaya_backend/src/routes/v1/users.js):
///   GET   /users/me
///   PATCH /users/me                      -> { fullName?, phone? }
///   GET   /users/me/progress
///   GET   /users/me/streak
///   GET   /users/me/categories-explored
/// All require `Authorization: Bearer <accessToken>`.
class ProfileApiService {
  Uri _uri(String path) => Uri.parse('${ApiConfig.baseUrl}$path');

  Map<String, dynamic> _decode(http.Response response) {
    if (response.body.isEmpty) return const {};
    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  void _throwIfError(http.Response response, Map<String, dynamic> body) {
    if (response.statusCode >= 200 && response.statusCode < 300) return;
    final message = (body['message'] ?? body['error'] ?? 'Request failed (${response.statusCode})').toString();
    throw ApiException(response.statusCode, message);
  }

  Future<T> _guard<T>(Future<T> Function() body) async {
    try {
      return await body();
    } on ApiException {
      rethrow;
    } on SocketException {
      throw NetworkException('Could not reach the NYAYA server.');
    } catch (e) {
      if (e is NetworkException) rethrow;
      throw NetworkException('Could not reach the NYAYA server.');
    }
  }

  Future<UserProfile> fetchProfile(String accessToken) => _guard(() async {
        final response = await http
            .get(_uri('/users/me'), headers: {'Authorization': 'Bearer $accessToken'})
            .timeout(const Duration(seconds: 10));
        final body = _decode(response);
        _throwIfError(response, body);
        return UserProfile.fromJson(body);
      });

  Future<UserProfile> updateProfile(String accessToken, {String? fullName, String? phone, String? profession}) => _guard(() async {
        final payload = <String, dynamic>{
          if (fullName != null) 'fullName': fullName,
          if (phone != null) 'phone': phone,
          if (profession != null) 'profession': profession,
        };
        final response = await http
            .patch(
              _uri('/users/me'),
              headers: {'Authorization': 'Bearer $accessToken', 'Content-Type': 'application/json'},
              body: jsonEncode(payload),
            )
            .timeout(const Duration(seconds: 10));
        final body = _decode(response);
        _throwIfError(response, body);
        return UserProfile.fromJson(body);
      });

  Future<UserProfile> uploadAvatar(String accessToken, File imageFile) => _guard(() async {
        final request = http.MultipartRequest('POST', _uri('/users/me/avatar'))
          ..headers['Authorization'] = 'Bearer $accessToken'
          ..files.add(await http.MultipartFile.fromPath('avatar', imageFile.path));
        final streamedResponse = await request.send().timeout(const Duration(seconds: 20));
        final response = await http.Response.fromStream(streamedResponse);
        final body = _decode(response);
        _throwIfError(response, body);
        return UserProfile.fromJson(body);
      });

  Future<void> changePassword(String accessToken, {required String currentPassword, required String newPassword}) =>
      _guard(() async {
        final response = await http
            .post(
              _uri('/users/me/change-password'),
              headers: {'Authorization': 'Bearer $accessToken', 'Content-Type': 'application/json'},
              body: jsonEncode({'currentPassword': currentPassword, 'newPassword': newPassword}),
            )
            .timeout(const Duration(seconds: 10));
        _throwIfError(response, _decode(response));
      });

  Future<int> fetchActiveSessions(String accessToken) => _guard(() async {
        final response = await http
            .get(_uri('/users/me/security'), headers: {'Authorization': 'Bearer $accessToken'})
            .timeout(const Duration(seconds: 10));
        final body = _decode(response);
        _throwIfError(response, body);
        return body['activeSessions'] as int? ?? 0;
      });

  Future<void> logoutEverywhere(String accessToken) => _guard(() async {
        final response = await http
            .post(_uri('/users/me/logout-all'), headers: {'Authorization': 'Bearer $accessToken'})
            .timeout(const Duration(seconds: 10));
        _throwIfError(response, _decode(response));
      });

  Future<SupportRequest> submitSupportRequest(String accessToken, {required String subject, required String message}) =>
      _guard(() async {
        final response = await http
            .post(
              _uri('/users/me/support-requests'),
              headers: {'Authorization': 'Bearer $accessToken', 'Content-Type': 'application/json'},
              body: jsonEncode({'subject': subject, 'message': message}),
            )
            .timeout(const Duration(seconds: 10));
        final body = _decode(response);
        _throwIfError(response, body);
        return SupportRequest.fromJson({...body, 'createdAt': DateTime.now().toUtc().toIso8601String()});
      });

  Future<List<SupportRequest>> fetchSupportRequests(String accessToken) => _guard(() async {
        final response = await http
            .get(_uri('/users/me/support-requests'), headers: {'Authorization': 'Bearer $accessToken'})
            .timeout(const Duration(seconds: 10));
        final body = _decode(response);
        _throwIfError(response, body);
        return (body['items'] as List<dynamic>? ?? const [])
            .map((e) => SupportRequest.fromJson(e as Map<String, dynamic>))
            .toList();
      });

  Future<ProfileStats> fetchStats(String accessToken) => _guard(() async {
        final headers = {'Authorization': 'Bearer $accessToken'};
        final results = await Future.wait([
          http.get(_uri('/users/me/progress'), headers: headers).timeout(const Duration(seconds: 10)),
          http.get(_uri('/users/me/streak'), headers: headers).timeout(const Duration(seconds: 10)),
          http.get(_uri('/users/me/categories-explored'), headers: headers).timeout(const Duration(seconds: 10)),
        ]);

        final progressBody = _decode(results[0]);
        _throwIfError(results[0], progressBody);
        final streakBody = _decode(results[1]);
        _throwIfError(results[1], streakBody);
        final categoriesBody = _decode(results[2]);
        _throwIfError(results[2], categoriesBody);

        return ProfileStats(
          categoriesExplored: categoriesBody['categoriesExplored'] as int? ?? 0,
          topicsCompleted: progressBody['totalQuizzesCompleted'] as int? ?? 0,
          pointsEarned: progressBody['totalPoints'] as int? ?? 0,
          dayStreak: streakBody['currentStreak'] as int? ?? 0,
        );
      });
}
