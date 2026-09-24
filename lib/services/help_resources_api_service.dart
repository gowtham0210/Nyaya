import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../config/api_config.dart';
import '../models/help_resource.dart';
import 'api_exceptions.dart';

/// Calls the Help & Resources endpoints
/// (nyaya_backend/src/routes/v1/help-resources.js):
///   GET /help-resources/states
///   GET /help-resources/categories
///   GET /help-resources?state=TN&category=women-safety
/// All require `Authorization: Bearer <accessToken>`.
class HelpResourcesApiService {
  Uri _uri(String path) => Uri.parse('${ApiConfig.baseUrl}$path');

  Future<List<T>> _getList<T>(String accessToken, String path, T Function(Map<String, dynamic>) parse) async {
    try {
      final response = await http
          .get(_uri(path), headers: {'Authorization': 'Bearer $accessToken'})
          .timeout(const Duration(seconds: 10));
      final body = response.body.isEmpty ? <String, dynamic>{} : jsonDecode(response.body) as Map<String, dynamic>;
      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw ApiException(response.statusCode, (body['message'] ?? 'Request failed (${response.statusCode})').toString());
      }
      return (body['items'] as List<dynamic>? ?? const []).map((e) => parse(e as Map<String, dynamic>)).toList();
    } on ApiException {
      rethrow;
    } on SocketException {
      throw NetworkException('Could not reach the NYAYA server.');
    } catch (e) {
      if (e is NetworkException) rethrow;
      throw NetworkException('Could not reach the NYAYA server.');
    }
  }

  Future<List<IndianState>> fetchStates(String accessToken) =>
      _getList(accessToken, '/help-resources/states', IndianState.fromJson);

  Future<List<SupportCategory>> fetchCategories(String accessToken) =>
      _getList(accessToken, '/help-resources/categories', SupportCategory.fromJson);

  Future<List<HelpResource>> fetchResources(String accessToken, {required String stateCode, required String categorySlug}) =>
      _getList(
        accessToken,
        '/help-resources?state=${Uri.encodeQueryComponent(stateCode)}&category=${Uri.encodeQueryComponent(categorySlug)}',
        HelpResource.fromJson,
      );
}
