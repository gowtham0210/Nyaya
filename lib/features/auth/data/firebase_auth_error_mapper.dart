import 'package:firebase_auth/firebase_auth.dart';

/// Translates a [FirebaseAuthException] from the phone-auth flow into a
/// short, user-facing message. Falls back to the SDK's own message for
/// codes we haven't special-cased.
String mapFirebaseAuthError(FirebaseAuthException error) {
  switch (error.code) {
    case 'invalid-phone-number':
      return 'That phone number doesn\'t look right. Please check and try again.';
    case 'too-many-requests':
      return 'Too many attempts. Please wait a while before trying again.';
    case 'quota-exceeded':
      return 'SMS quota exceeded for now. Please try again later.';
    case 'invalid-verification-code':
      return 'Incorrect OTP. Please check the code and try again.';
    case 'invalid-verification-id':
    case 'session-expired':
      return 'This OTP has expired. Please request a new one.';
    case 'network-request-failed':
      return 'Network error. Please check your connection and try again.';
    case 'user-disabled':
      return 'This account has been disabled. Please contact support.';
    case 'operation-not-allowed':
      return 'Phone sign-in isn\'t enabled for this app yet.';
    case 'credential-already-in-use':
      return 'This phone number is already linked to another account.';
    default:
      return error.message ?? 'Something went wrong. Please try again.';
  }
}
