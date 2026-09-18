import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show kIsWeb;

/// Central place for the Nyaya backend's base URL.
///
/// Override it at build/run time without touching code:
///   flutter run --dart-define=API_BASE_URL=https://your-host
/// This is how a staging/production URL gets plugged in later — nothing in
/// this file should ever be changed to hardcode one.
class ApiConfig {
  ApiConfig._();

  static const _envBaseUrl = String.fromEnvironment('API_BASE_URL');

  /// Defaults to the backend's local dev address. On the Android emulator,
  /// "localhost" refers to the emulator itself, not the host machine, so
  /// that case is mapped to the standard `10.0.2.2` loopback alias instead.
  static String get baseUrl {
    if (_envBaseUrl.isNotEmpty) {
      return _envBaseUrl;
    }
    if (!kIsWeb && Platform.isAndroid) {
      return 'http://10.0.2.2:5000';
    }
    return 'http://localhost:5000';
  }

  static String get apiV1BaseUrl => '$baseUrl/api/v1';
}
