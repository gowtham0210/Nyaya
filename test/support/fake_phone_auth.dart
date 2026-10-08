import 'package:firebase_auth/firebase_auth.dart';
import 'package:nyaya/features/auth/data/firebase_phone_auth_service.dart';

/// Firebase phone auth without Firebase: every send "texts" a code, every
/// code verifies, and the ID token is `fb-token` (spec 042).
class FakePhoneAuthService extends FirebasePhoneAuthService {
  final sentTo = <String>[];
  final codes = <String>[];

  @override
  Future<void> sendVerificationCode({
    required String phoneNumber,
    required void Function(String verificationId, int? resendToken) onCodeSent,
    required void Function(FirebaseAuthException error) onVerificationFailed,
    required void Function(UserCredential credential) onAutoVerified,
    void Function(String verificationId)? onCodeAutoRetrievalTimeout,
    int? forceResendingToken,
    Duration timeout = const Duration(seconds: 60),
  }) async {
    sentTo.add(phoneNumber);
    onCodeSent('verification-1', 7);
  }

  @override
  Future<void> verifyCode({
    required String verificationId,
    required String smsCode,
  }) async => codes.add(smsCode);

  @override
  Future<String?> getIdToken({bool forceRefresh = false}) async => 'fb-token';
}
