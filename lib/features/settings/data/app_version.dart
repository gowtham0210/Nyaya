import 'package:package_info_plus/package_info_plus.dart';

/// The installed app version, e.g. `1.0.0 (1)` (ADR 0004).
Future<String> readAppVersion() async {
  final info = await PackageInfo.fromPlatform();
  return '${info.version} (${info.buildNumber})';
}
