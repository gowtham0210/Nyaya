import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../config/api_config.dart';
import '../models/legal_update.dart';
import 'api_exceptions.dart';

/// Calls the real NYAYA legal-updates endpoint
/// (nyaya_backend/src/routes/v1/legal-updates.js):
///   GET /legal-updates[?category=Judgements] -> { items: LegalUpdate[] }
/// Requires `Authorization: Bearer <accessToken>`.
class LegalUpdatesApiService {
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

  Future<List<LegalUpdate>> fetchAll(String accessToken, {String? category}) async {
    try {
      final path = category == null || category.isEmpty
          ? '/legal-updates'
          : '/legal-updates?category=${Uri.encodeQueryComponent(category)}';
      final response = await http
          .get(_uri(path), headers: {'Authorization': 'Bearer $accessToken'})
          .timeout(const Duration(seconds: 10));
      final body = _decode(response);
      _throwIfError(response, body);
      final items = (body['items'] as List<dynamic>? ?? const []);
      return items.map((e) => LegalUpdate.fromJson(e as Map<String, dynamic>)).toList();
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
