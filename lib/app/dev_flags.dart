import 'package:flutter/foundation.dart';

/// Skips sign-in until the backend accepts OTP-only sessions. Debug builds
/// only, off by default:
///   flutter run --dart-define=SKIP_SIGN_IN=true
/// Backend calls then run without a session (and without the 401 redirect
/// to sign-in), so data screens show their error states.
final bool skipSignInForDev =
    kDebugMode && const bool.fromEnvironment('SKIP_SIGN_IN');
