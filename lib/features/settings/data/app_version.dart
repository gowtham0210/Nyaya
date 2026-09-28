import 'package:package_info_plus/package_info_plus.dart';

/// Reads the app version; tests pass a fake (ADR 0004).
typedef AppVersionReader = Future<String> Function();

/// The installed app version, e.g. `1.0.0 (1)`.
Future<String> readAppVersion() async {
  final info = await PackageInfo.fromPlatform();
  return '${info.version} (${info.buildNumber})';
}
