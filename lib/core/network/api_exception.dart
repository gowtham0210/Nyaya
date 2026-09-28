/// Every failure the [ApiClient] reports. Pages map the type to a
/// localized message; [message] is an English fallback or the backend's own.
sealed class ApiException implements Exception {
  const ApiException(this.message, {this.serverMessage});

  final String message;

  /// The backend's own `message`, when it sent one. Unlike [message], never
  /// an English fallback, so it is safe to show in any language.
  final String? serverMessage;

  @override
  String toString() => '$runtimeType($message)';
}

/// No response: connection refused, DNS failure or timeout.
class ApiOfflineException extends ApiException {
  const ApiOfflineException([
    super.message =
        'Network error. Please check your connection and try again.',
  ]);
}

/// The session is missing or could not be refreshed.
class ApiUnauthorizedException extends ApiException {
  const ApiUnauthorizedException([
    super.message = 'Your session has ended. Please sign in again.',
  ]);

  const ApiUnauthorizedException.fromServer(super.message)
    : super(serverMessage: message);
}

class ApiNotFoundException extends ApiException {
  const ApiNotFoundException([
    super.message = 'Not found.',
    String? serverMessage,
  ]) : super(serverMessage: serverMessage);
}

/// Any other non-2xx response.
class ApiServerException extends ApiException {
  const ApiServerException(
    this.statusCode,
    super.message, {
    super.serverMessage,
  });

  final int statusCode;
}
