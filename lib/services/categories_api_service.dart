import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../config/api_config.dart';
import '../models/category.dart';
import '../state/app_language.dart';
import 'api_exceptions.dart';

/// Calls the real NYAYA categories endpoints
/// (nyaya_backend/src/routes/v1/categories.js):
///   GET /categories               -> { items: Category[] }
///   GET /categories/:id/quizzes   -> { items: Quiz[] }
/// Both require `Authorization: Bearer <accessToken>` — see
/// nyaya_backend/openAPI_schema.yaml (global bearerAuth security applies;
/// this path has no `security: []` override) and the Postman collection's
/// "Added as a part of security scheme: bearer" note on this exact request.
class CategoriesApiService {
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

  Future<List<Category>> fetchCategories(String accessToken) async {
    try {
      final response = await http
          .get(_uri('/categories'.withLang()), headers: {'Authorization': 'Bearer $accessToken'})
          .timeout(const Duration(seconds: 10));
      final body = _decode(response);
      _throwIfError(response, body);
      final items = (body['items'] as List<dynamic>? ?? const []);
      return items.map((e) => Category.fromJson(e as Map<String, dynamic>)).toList();
    } on ApiException {
      rethrow;
    } on SocketException {
      throw NetworkException('Could not reach the NYAYA server.');
    } catch (e) {
      if (e is NetworkException) rethrow;
      throw NetworkException('Could not reach the NYAYA server.');
    }
  }

  /// Active quiz count for a category — used as the card's "N Modules" label.
  Future<int> fetchQuizCount(String accessToken, int categoryId) async {
    final response = await http
        .get(_uri('/categories/$categoryId/quizzes'), headers: {'Authorization': 'Bearer $accessToken'})
        .timeout(const Duration(seconds: 10));
    final body = _decode(response);
    _throwIfError(response, body);
    final items = (body['items'] as List<dynamic>? ?? const []);
    return items.length;
  }
}
