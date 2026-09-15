/// The backend rejected the request. [statusCode] and [message] come
/// straight from the backend's own JSON error body.
class ApiException implements Exception {
  ApiException(this.statusCode, this.message);

  final int statusCode;
  final String message;

  @override
  String toString() => 'ApiException($statusCode, $message)';
}

/// No request could be made at all — DNS/connection failure, timeout, etc.
/// Distinct from [ApiException], which means the server *did* respond.
class NetworkException implements Exception {
  NetworkException(this.message);

  final String message;

  @override
  String toString() => 'NetworkException($message)';
}

/// The endpoint requires a signed-in session and none is available.
class UnauthenticatedException implements Exception {}
