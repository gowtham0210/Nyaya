/// Central place for the NYAYA backend's address.
///
/// The backend (nyaya_backend/) runs on the developer's own machine on the
/// port from its .env (PORT, defaults to 5000 — see src/config/env.js).
/// From the Android emulator, the host machine's localhost is reachable at
/// 10.0.2.2, not 127.0.0.1/localhost.
class ApiConfig {
  ApiConfig._();

  static const String baseUrl = 'http://10.0.2.2:5000/api/v1';
}
