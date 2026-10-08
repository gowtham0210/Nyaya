import 'package:firebase_auth/firebase_auth.dart';

/// Thin wrapper around [FirebaseAuth]'s phone-number verification flow.
///
/// Kept separate from the presentation layer so the OTP UI only ever talks
/// to this service rather than `FirebaseAuth.instance` directly.
class FirebasePhoneAuthService {
  FirebasePhoneAuthService({FirebaseAuth? auth}) : _authOverride = auth;

  final FirebaseAuth? _authOverride;

  // Read on first use, so pages and test fakes can be built without a
  // configured Firebase app.
  FirebaseAuth get _auth => _authOverride ?? FirebaseAuth.instance;

  /// Starts (or resends, when [forceResendingToken] is supplied) phone
  /// verification for [phoneNumber].
  ///
  /// Exactly one of [onAutoVerified] or [onCodeSent] fires on success,
  /// depending on whether the platform could auto-verify the device
  /// (Android instant/SMS-retriever verification). [onVerificationFailed]
  /// fires for invalid numbers, quota limits, network errors, etc.
  Future<void> sendVerificationCode({
    required String phoneNumber,
    required void Function(String verificationId, int? resendToken) onCodeSent,
    required void Function(FirebaseAuthException error) onVerificationFailed,
    required void Function(UserCredential credential) onAutoVerified,
    void Function(String verificationId)? onCodeAutoRetrievalTimeout,
    int? forceResendingToken,
    Duration timeout = const Duration(seconds: 60),
  }) {
    return _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      timeout: timeout,
      forceResendingToken: forceResendingToken,
      verificationCompleted: (PhoneAuthCredential credential) async {
        try {
          final userCredential = await _auth.signInWithCredential(credential);
          onAutoVerified(userCredential);
        } on FirebaseAuthException catch (error) {
          onVerificationFailed(error);
        }
      },
      verificationFailed: onVerificationFailed,
      codeSent: onCodeSent,
      codeAutoRetrievalTimeout:
          onCodeAutoRetrievalTimeout ?? (String verificationId) {},
    );
  }

  /// Confirms the user-entered [smsCode] against [verificationId].
  Future<void> verifyCode({
    required String verificationId,
    required String smsCode,
  }) async {
    final credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: smsCode,
    );
    await _auth.signInWithCredential(credential);
  }

  /// The current Firebase ID token, if a user is signed in.
  Future<String?> getIdToken({bool forceRefresh = false}) {
    return _auth.currentUser?.getIdToken(forceRefresh) ??
        Future<String?>.value();
  }

  Future<void> signOut() => _auth.signOut();
}
