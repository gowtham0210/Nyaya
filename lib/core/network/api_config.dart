/// Central place for the Nyaya backend's base URL.
///
/// Defaults to the hosted backend. Point at another one (e.g. a local
/// server) at build/run time without touching code:
///   flutter run --dart-define=API_BASE_URL=http://localhost:5050
/// On the Android emulator, use `http://10.0.2.2:<port>` for the host
/// machine's localhost.
class ApiConfig {
  ApiConfig._();

  static const _hostedBaseUrl = 'https://nyayaapi.deepwebstudio.dev';
  static const _envBaseUrl = String.fromEnvironment('API_BASE_URL');

  static String get baseUrl =>
      _envBaseUrl.isNotEmpty ? _envBaseUrl : _hostedBaseUrl;

  static String get apiV1BaseUrl => '$baseUrl/api/v1';

  /// The backend sends upload paths relative to its origin.
  static String? absoluteUrl(String? path) {
    if (path == null || path.startsWith('http')) {
      return path;
    }
    return '$baseUrl${path.startsWith('/') ? '' : '/'}$path';
  }
}
