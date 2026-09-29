import 'api_client.dart';

/// The tokens and profile returned by a successful register or login call.
class AuthResult {
  const AuthResult({
    required this.accessToken,
    required this.refreshToken,
    required this.fullName,
    required this.email,
  });

  final String accessToken;
  final String refreshToken;
  final String fullName;
  final String email;
}

/// A failed register or login call. Kept as its own name because the sign-in
/// and sign-up pages catch it specifically; [ApiException] carries the
/// message and status.
typedef AuthApiException = ApiException;

/// Talks to the Nyaya backend's `/auth` endpoints.
class AuthApi {
  AuthApi({String? baseUrl, ApiClient? client})
    : _client = client ?? ApiClient(baseUrl: baseUrl);

  final ApiClient _client;

  String get baseUrl => _client.baseUrl;

  Future<AuthResult> register({
    required String fullName,
    required String email,
    required String password,
    String? phone,
  }) async {
    final json = await _client.post('/auth/register', {
      'fullName': fullName,
      'email': email,
      'password': password,
      if (phone != null && phone.isNotEmpty) 'phone': phone,
    }, authenticated: false);
    return _parseAuthResult(json);
  }

  Future<AuthResult> login({
    required String email,
    required String password,
  }) async {
    final json = await _client.post('/auth/login', {
      'email': email,
      'password': password,
    }, authenticated: false);
    return _parseAuthResult(json);
  }

  AuthResult _parseAuthResult(Map<String, Object?> json) {
    final user = json['user'] as Map<String, Object?>;
    return AuthResult(
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
      fullName: user['fullName'] as String,
      email: user['email'] as String,
    );
  }
}
