import 'package:url_launcher/url_launcher.dart';

/// Opens a `tel:`, `mailto:` or web link; true when something opened.
/// Tests pass a fake (ADR 0004).
typedef LinkOpener = Future<bool> Function(Uri uri);

/// Opens [uri] in the phone's dialer, mail app or browser.
Future<bool> openExternally(Uri uri) async {
  try {
    return await launchUrl(uri, mode: LaunchMode.externalApplication);
  } catch (_) {
    return false;
  }
}
