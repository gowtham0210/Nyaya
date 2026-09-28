/// Every failure the [ApiClient] reports. Pages map the type to a
/// localized message; [message] is an English fallback or the backend's own.
sealed class ApiException implements Exception {
  const ApiException(this.message);

  final String message;

  @override
  String toString() => '$runtimeType($message)';
}

/// No response: connection refused, DNS failure or timeout.
class ApiOfflineException extends ApiException {
  const ApiOfflineException([
    super.message = 'Network error. Please check your connection and try again.',
  ]);
}

/// The session is missing or could not be refreshed.
class ApiUnauthorizedException extends ApiException {
  const ApiUnauthorizedException([
    super.message = 'Your session has ended. Please sign in again.',
  ]);
}

class ApiNotFoundException extends ApiException {
  const ApiNotFoundException([super.message = 'Not found.']);
}

/// Any other non-2xx response.
class ApiServerException extends ApiException {
  const ApiServerException(this.statusCode, super.message);

  final int statusCode;
}
