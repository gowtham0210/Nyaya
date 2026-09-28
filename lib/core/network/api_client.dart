import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'api_config.dart';
import 'api_exception.dart';

export 'api_exception.dart';

/// The one client for every Nyaya backend call (see ADR 0002).
class ApiClient {
  ApiClient({
    http.Client? httpClient,
    String? Function()? readAccessToken,
    String Function()? languageCode,
    Future<bool> Function()? refreshSession,
    void Function()? onSessionExpired,
  }) : _httpClient = httpClient ?? http.Client(),
       _readAccessToken = readAccessToken ?? (() => null),
       _languageCode = languageCode ?? (() => 'en'),
       _refreshSession = refreshSession ?? (() async => false),
       _onSessionExpired = onSessionExpired;

  final http.Client _httpClient;
  final String? Function() _readAccessToken;
  final String Function() _languageCode;
  final Future<bool> Function() _refreshSession;
  final void Function()? _onSessionExpired;

  Future<Map<String, dynamic>> get(
    String path, {
    Map<String, String>? query,
    bool authenticated = true,
  }) async {
    final response = await _send(
      authenticated: authenticated,
      (headers) => _httpClient.get(_uri(path, query), headers: headers),
    );
    return _decode(response);
  }

  Future<Map<String, dynamic>> post(
    String path, {
    Object? body,
    bool authenticated = true,
  }) => _json('POST', path, body, authenticated);

  Future<Map<String, dynamic>> patch(
    String path, {
    Object? body,
    bool authenticated = true,
  }) => _json('PATCH', path, body, authenticated);

  Future<Map<String, dynamic>> delete(
    String path, {
    bool authenticated = true,
  }) => _json('DELETE', path, null, authenticated);

  /// POSTs one file as `multipart/form-data` under [field].
  Future<Map<String, dynamic>> upload(
    String path, {
    required String field,
    required List<int> bytes,
    required String filename,
  }) async {
    final response = await _send(authenticated: true, (headers) async {
      final request = http.MultipartRequest('POST', _uri(path, null))
        ..headers.addAll(headers)
        ..files.add(
          http.MultipartFile.fromBytes(field, bytes, filename: filename),
        );
      return http.Response.fromStream(await _httpClient.send(request));
    });
    return _decode(response);
  }

  Future<Map<String, dynamic>> _json(
    String method,
    String path,
    Object? body,
    bool authenticated,
  ) async {
    final response = await _send(authenticated: authenticated, (headers) {
      final request = http.Request(method, _uri(path, null))
        ..headers.addAll(headers)
        ..headers['Content-Type'] = 'application/json';
      if (body != null) {
        request.body = jsonEncode(body);
      }
      return _httpClient.send(request).then(http.Response.fromStream);
    });
    return _decode(response);
  }

  static const _timeout = Duration(seconds: 15);

  /// Sends [request] with auth headers; on 401 refreshes once and resends.
  Future<http.Response> _send(
    Future<http.Response> Function(Map<String, String> headers) request, {
    required bool authenticated,
  }) async {
    var response = await _transport(request, authenticated);
    if (response.statusCode == 401 && authenticated) {
      if (await _refreshSession()) {
        response = await _transport(request, authenticated);
      }
      if (response.statusCode == 401) {
        _onSessionExpired?.call();
        final message = _backendMessage(response);
        throw message == null
            ? const ApiUnauthorizedException()
            : ApiUnauthorizedException.fromServer(message);
      }
    }
    final status = response.statusCode;
    if (status >= 200 && status < 300) {
      return response;
    }
    final message = _backendMessage(response);
    if (status == 404) {
      throw ApiNotFoundException(message ?? 'Not found.', message);
    }
    throw ApiServerException(
      status,
      message ?? 'Request failed ($status). Please try again.',
      serverMessage: message,
    );
  }

  Future<http.Response> _transport(
    Future<http.Response> Function(Map<String, String> headers) request,
    bool authenticated,
  ) async {
    final token = authenticated ? _readAccessToken() : null;
    try {
      return await request({
        'Accept': 'application/json',
        'Authorization': ?(token == null ? null : 'Bearer $token'),
      }).timeout(_timeout);
    } on TimeoutException {
      throw const ApiOfflineException();
    } on http.ClientException {
      throw const ApiOfflineException();
    }
  }

  Map<String, dynamic> _decode(http.Response response) {
    if (response.body.isEmpty) {
      return const {};
    }
    final decoded = jsonDecode(response.body);
    return decoded is Map<String, dynamic> ? decoded : const {};
  }

  String? _backendMessage(http.Response response) {
    try {
      final decoded = jsonDecode(response.body);
      if (decoded is Map<String, dynamic> && decoded['message'] is String) {
        return decoded['message'] as String;
      }
    } on FormatException {
      // Not JSON; fall back to a generic message.
    }
    return null;
  }

  Uri _uri(String path, Map<String, String>? query) {
    final language = _languageCode();
    final params = {...?query, if (language != 'en') 'lang': language};
    final uri = Uri.parse('${ApiConfig.apiV1BaseUrl}$path');
    return params.isEmpty ? uri : uri.replace(queryParameters: params);
  }
}
