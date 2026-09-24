import 'dart:io';

import '../models/profile_stats.dart';
import '../models/support_request.dart';
import '../models/user_profile.dart';
import '../services/api_exceptions.dart';
import '../services/auth_api_service.dart';
import '../services/auth_storage.dart';
import '../services/profile_api_service.dart';

/// The single source of truth for the Profile screen, backed entirely by
/// the real GET/PATCH /api/v1/users/me endpoints. Never returns invented
/// data — callers get real values or a thrown exception.
class ProfileRepository {
  ProfileRepository({ProfileApiService? api, AuthStorage? authStorage})
      : _api = api ?? ProfileApiService(),
        _authStorage = authStorage ?? AuthStorage();

  final ProfileApiService _api;
  final AuthStorage _authStorage;

  Future<String> _requireToken() async {
    final token = await _authStorage.readToken();
    if (token == null) {
      throw UnauthenticatedException();
    }
    return token;
  }

  Future<UserProfile> getProfile() async {
    final token = await _requireToken();
    return _api.fetchProfile(token);
  }

  Future<UserProfile> updateProfile({String? fullName, String? phone, String? profession}) async {
    final token = await _requireToken();
    return _api.updateProfile(token, fullName: fullName, phone: phone, profession: profession);
  }

  Future<UserProfile> uploadAvatar(File imageFile) async {
    final token = await _requireToken();
    return _api.uploadAvatar(token, imageFile);
  }

  Future<ProfileStats> getStats() async {
    final token = await _requireToken();
    return _api.fetchStats(token);
  }

  Future<void> changePassword({required String currentPassword, required String newPassword}) async {
    final token = await _requireToken();
    return _api.changePassword(token, currentPassword: currentPassword, newPassword: newPassword);
  }

  Future<int> getActiveSessions() async {
    final token = await _requireToken();
    return _api.fetchActiveSessions(token);
  }

  Future<void> logoutEverywhere() async {
    final token = await _requireToken();
    await _api.logoutEverywhere(token);
    await _authStorage.clearToken();
  }

  Future<SupportRequest> submitSupportRequest({required String subject, required String message}) async {
    final token = await _requireToken();
    return _api.submitSupportRequest(token, subject: subject, message: message);
  }

  Future<List<SupportRequest>> getSupportRequests() async {
    final token = await _requireToken();
    return _api.fetchSupportRequests(token);
  }

  /// Revokes the refresh token server-side (best-effort) and clears the
  /// local session.
  Future<void> logout() async {
    final refreshToken = await _authStorage.readRefreshToken();
    if (refreshToken != null) {
      await AuthApiService().logout(refreshToken);
    }
    await _authStorage.clearToken();
  }
}
