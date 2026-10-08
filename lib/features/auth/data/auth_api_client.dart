import '../../../core/network/api_client.dart';

/// Thrown for any auth failure. [cause] says what went wrong; pages turn
/// it into localized text (see `authApiErrorText`). [message] is for logs.
class AuthApiException implements Exception {
  AuthApiException(this.message, {this.statusCode, this.cause});

  AuthApiException.from(ApiException error)
    : this(
        error.message,
        statusCode: error is ApiServerException ? error.statusCode : null,
        cause: error,
      );

  final String message;
  final int? statusCode;
  final ApiException? cause;

  @override
  String toString() => message;
}

/// The backend has no phone OTP login yet (`/auth/phone-login` is 404).
class PhoneLoginUnavailableException extends AuthApiException {
  PhoneLoginUnavailableException(AuthApiException error)
    : super(error.message, statusCode: error.statusCode, cause: error.cause);
}

class AuthUser {
  const AuthUser({
    required this.id,
    required this.fullName,
    this.email,
    this.phone,
    this.profession,
    required this.phoneVerified,
    required this.status,
  });

  final int id;
  final String fullName;
  final String? email;
  final String? phone;
  final String? profession;
  final bool phoneVerified;
  final String status;

  factory AuthUser.fromJson(Map<String, dynamic> json) => AuthUser(
    id: json['id'] as int,
    fullName: json['fullName'] as String? ?? '',
    email: json['email'] as String?,
    phone: json['phone'] as String?,
    profession: json['profession'] as String?,
    phoneVerified: json['phoneVerified'] as bool? ?? false,
    status: json['status'] as String? ?? 'active',
  );
}

/// The full session returned by signup/login: a usable access token plus a
/// refresh token to obtain new ones later.
class AuthSession {
  const AuthSession({
    required this.accessToken,
    required this.refreshToken,
    this.refreshTokenExpiresAt,
    this.user,
  });

  final String accessToken;
  final String refreshToken;
  final DateTime? refreshTokenExpiresAt;
  final AuthUser? user;

  factory AuthSession.fromJson(Map<String, dynamic> json) => AuthSession(
    accessToken: json['accessToken'] as String,
    refreshToken: json['refreshToken'] as String,
    refreshTokenExpiresAt: _parseDate(json['refreshTokenExpiresAt']),
    user: json['user'] is Map<String, dynamic>
        ? AuthUser.fromJson(json['user'] as Map<String, dynamic>)
        : null,
  );
}

/// The result of `/auth/refresh`. Fields are nullable because the backend
/// returns an all-null 200 response when there was no valid refresh token
/// to use (rather than an error).
class RefreshedTokens {
  const RefreshedTokens({
    this.accessToken,
    this.refreshToken,
    this.refreshTokenExpiresAt,
  });

  final String? accessToken;
  final String? refreshToken;
  final DateTime? refreshTokenExpiresAt;

  factory RefreshedTokens.fromJson(Map<String, dynamic> json) =>
      RefreshedTokens(
        accessToken: json['accessToken'] as String?,
        refreshToken: json['refreshToken'] as String?,
        refreshTokenExpiresAt: _parseDate(json['refreshTokenExpiresAt']),
      );
}

DateTime? _parseDate(Object? value) {
  if (value is String) {
    return DateTime.tryParse(value);
  }
  return null;
}

/// The Nyaya backend's auth endpoints (`/auth/...`) on the shared
/// [ApiClient]. Deliberately stateless — it never reads or writes
/// [AuthTokenStore] itself; see `AuthRepository` for that.
class AuthApiClient {
  AuthApiClient({ApiClient? client}) : _client = client ?? ApiClient();

  final ApiClient _client;

  Future<AuthSession> signup({
    required String fullName,
    required String profession,
    required String phone,
    required String password,
    String? firebaseIdToken,
  }) async {
    final body = await _post('/auth/signup', {
      'full_name': fullName,
      'profession': profession,
      'phone': phone,
      'password': password,
      'firebase_id_token': ?firebaseIdToken,
    });
    return AuthSession.fromJson(body);
  }

  /// Creates an email account (`/auth/register`, spec 041). No phone OTP;
  /// [phone] is optional.
  Future<AuthSession> register({
    required String fullName,
    required String email,
    required String password,
    String? phone,
  }) async {
    final body = await _post('/auth/register', {
      'fullName': fullName,
      'email': email,
      'password': password,
      'phone': ?phone,
    });
    return AuthSession.fromJson(body);
  }

  /// Signs in with a phone number Firebase just verified by OTP (spec 042).
  /// Planned backend contract; a backend without it answers 404.
  Future<AuthSession> phoneLogin({
    required String firebaseIdToken,
    required String phone,
  }) async {
    final body = await _post('/auth/phone-login', {
      'firebase_id_token': firebaseIdToken,
      'phone': phone,
    });
    return AuthSession.fromJson(body);
  }

  /// Saves the profession on the signed-in account (`PATCH /users/me`);
  /// register has no profession field.
  Future<void> updateProfession(String profession) async {
    try {
      await _client.patch('/users/me', body: {'profession': profession});
    } on ApiException catch (error) {
      throw AuthApiException.from(error);
    }
  }

  Future<AuthSession> login({
    String? email,
    String? phone,
    required String password,
  }) async {
    final body = await _post('/auth/login', {
      'email': ?email,
      'phone': ?phone,
      'password': password,
    });
    return AuthSession.fromJson(body);
  }

  Future<RefreshedTokens> refresh({required String refreshToken}) async {
    final body = await _post('/auth/refresh', {'refreshToken': refreshToken});
    return RefreshedTokens.fromJson(body);
  }

  Future<void> logout({required String refreshToken}) async {
    await _post('/auth/logout', {'refreshToken': refreshToken});
  }

  /// Auth calls never send or refresh a bearer token, and surface failures
  /// as [AuthApiException] so the auth pages can show [message] directly.
  Future<Map<String, dynamic>> _post(
    String path,
    Map<String, dynamic> body,
  ) async {
    try {
      return await _client.post(path, body: body, authenticated: false);
    } on ApiException catch (error) {
      throw AuthApiException.from(error);
    }
  }
}
