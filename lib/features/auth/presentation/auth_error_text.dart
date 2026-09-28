import 'package:firebase_auth/firebase_auth.dart';

import '../../../core/localization/l10n.dart';
import '../data/auth_api_client.dart';
import '../../../core/network/api_client.dart';

/// User-facing text for a backend auth failure. The backend's own message
/// is shown as returned (the request carries the app language); otherwise
/// the app's localized text, never an English fallback.
String authApiErrorText(AppLocalizations l10n, AuthApiException error) {
  final cause = error.cause;
  return switch (cause) {
    ApiOfflineException() => l10n.errorOffline,
    _ => cause?.serverMessage ?? l10n.errorGeneric,
  };
}

/// User-facing text for a Firebase phone-auth failure. Codes we haven't
/// special-cased get localized generic text, not the SDK's English.
String firebaseAuthErrorText(
  AppLocalizations l10n,
  FirebaseAuthException error,
) {
  return switch (error.code) {
    'invalid-phone-number' => l10n.authErrorInvalidPhone,
    'too-many-requests' => l10n.authErrorTooManyRequests,
    'quota-exceeded' => l10n.authErrorQuotaExceeded,
    'invalid-verification-code' => l10n.authErrorInvalidCode,
    'invalid-verification-id' || 'session-expired' => l10n.authErrorCodeExpired,
    'network-request-failed' => l10n.errorOffline,
    'user-disabled' => l10n.authErrorUserDisabled,
    'operation-not-allowed' => l10n.authErrorNotEnabled,
    'credential-already-in-use' => l10n.authErrorCredentialInUse,
    _ => l10n.errorGeneric,
  };
}
