import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../config/api_config.dart';
import 'api_exceptions.dart';

/// Calls the real NYAYA authentication endpoints
/// (nyaya_backend/src/routes/v1/auth.js: POST /auth/login, POST /auth/register).
/// Both return an `accessToken` used as the Bearer token for every other
/// authenticated request.
class AuthApiService {
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

  Future<String> login({required String email, required String password}) async {
    try {
      final response = await http
          .post(
            _uri('/auth/login'),
            headers: const {'Content-Type': 'application/json'},
            body: jsonEncode({'email': email, 'password': password}),
          )
          .timeout(const Duration(seconds: 10));
      final body = _decode(response);
      _throwIfError(response, body);
      return body['accessToken'] as String;
    } on ApiException {
      rethrow;
    } on SocketException {
      throw NetworkException('Could not reach the NYAYA server.');
    } catch (e) {
      if (e is NetworkException) rethrow;
      throw NetworkException('Could not reach the NYAYA server.');
    }
  }

  Future<String> register({required String fullName, required String email, required String password}) async {
    try {
      final response = await http
          .post(
            _uri('/auth/register'),
            headers: const {'Content-Type': 'application/json'},
            body: jsonEncode({'fullName': fullName, 'email': email, 'password': password}),
          )
          .timeout(const Duration(seconds: 10));
      final body = _decode(response);
      _throwIfError(response, body);
      return body['accessToken'] as String;
    } on ApiException {
      rethrow;
    } on SocketException {
      throw NetworkException('Could not reach the NYAYA server.');
    } catch (e) {
      if (e is NetworkException) rethrow;
      throw NetworkException('Could not reach the NYAYA server.');
    }
  }
}
