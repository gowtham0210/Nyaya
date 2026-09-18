import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/presentation/widgets/nyaya_widgets.dart';
import '../data/auth_api_client.dart';
import '../data/auth_repository.dart';
import '../data/auth_token_store.dart';
import '../data/firebase_auth_error_mapper.dart';
import '../data/firebase_phone_auth_service.dart';
import 'widgets/auth_header.dart';
import 'widgets/auth_primary_button.dart';

const _otpLength = 6;
const _resendCooldown = Duration(seconds: 45);

/// The OTP verification screen (Figma 1.4), shown after the signup form is
/// submitted so the user can confirm the code Firebase sent to their phone
/// number.
class OtpVerificationPage extends StatefulWidget {
  const OtpVerificationPage({
    super.key,
    required this.phoneNumber,
    required this.verificationId,
    required this.fullName,
    required this.profession,
    required this.password,
    this.resendToken,
    this.onVerified,
    this.onChangeNumber,
  });

  final String phoneNumber;

  /// The Firebase verification id for the code currently in flight. Updated
  /// internally whenever the user requests a resend.
  final String verificationId;

  /// Lets Firebase send the resend over the same verification session
  /// instead of starting a brand new one.
  final int? resendToken;

  // Carried over from the signup form so the backend Signup call can fire
  // from here, right after Firebase confirms the OTP.
  final String fullName;
  final String profession;
  final String password;

  /// Called once the OTP is confirmed, the backend account is created, and
  /// the session tokens are stored (see `AuthRepository`/[AuthTokenStore]).
  final VoidCallback? onVerified;
  final VoidCallback? onChangeNumber;

  @override
  State<OtpVerificationPage> createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends State<OtpVerificationPage> {
  // Deferred until first use — see the note in sign_up_page.dart.
  late final _phoneAuthService = FirebasePhoneAuthService();
  late final _authRepository = AuthRepository();

  late final List<TextEditingController> _controllers = List.generate(
    _otpLength,
    (_) => TextEditingController(),
  );
  late final List<FocusNode> _focusNodes = List.generate(
    _otpLength,
    (_) => FocusNode(),
  );

  late String _verificationId = widget.verificationId;
  int? _resendToken;

  Timer? _resendTimer;
  var _secondsRemaining = _resendCooldown.inSeconds;
  var _isVerifying = false;
  var _isResending = false;

  // Once Firebase confirms the code it's spent — a retry after a backend
  // failure should call the backend again, not re-verify the same OTP.
  var _firebaseVerified = false;
  String? _firebaseIdToken;

  @override
  void initState() {
    super.initState();
    _resendToken = widget.resendToken;
    _startResendTimer();
  }

  @override
  void dispose() {
    _resendTimer?.cancel();
    for (final controller in _controllers) {
      controller.dispose();
    }
    for (final node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _startResendTimer() {
    setState(() => _secondsRemaining = _resendCooldown.inSeconds);
    _resendTimer?.cancel();
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      if (_secondsRemaining == 0) {
        timer.cancel();
        return;
      }
      setState(() => _secondsRemaining--);
    });
  }

  void _handleDigitChanged(int index, String value) {
    if (value.isNotEmpty && index < _otpLength - 1) {
      _focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
  }

  String get _enteredCode => _controllers.map((c) => c.text).join();

  Future<void> _handleVerify() async {
    FocusScope.of(context).unfocus();
    setState(() => _isVerifying = true);

    // A retry after a backend failure skips straight to the signup call —
    // the OTP was already consumed by Firebase on the first attempt.
    if (!_firebaseVerified) {
      final code = _enteredCode;
      if (code.length < _otpLength) {
        setState(() => _isVerifying = false);
        _showMessage('Enter the full 6-digit code.');
        return;
      }
      try {
        await _phoneAuthService.verifyCode(
          verificationId: _verificationId,
          smsCode: code,
        );
        await _captureFirebaseIdToken();
      } on FirebaseAuthException catch (error) {
        if (!mounted) return;
        setState(() => _isVerifying = false);
        _showMessage(mapFirebaseAuthError(error));
        return;
      } catch (_) {
        if (!mounted) return;
        setState(() => _isVerifying = false);
        _showMessage('Network error. Please check your connection and try again.');
        return;
      }
    }

    await _completeSignup();
  }

  /// Reads the Firebase ID token once, right after OTP verification — it's
  /// held locally just long enough to send to the backend, and never
  /// persisted.
  Future<void> _captureFirebaseIdToken() async {
    final token = await _phoneAuthService.getIdToken();
    _firebaseIdToken = token;
    AuthTokenStore.idToken = token;
    _firebaseVerified = true;
  }

  Future<void> _completeSignup() async {
    try {
      await _authRepository.signup(
        fullName: widget.fullName,
        profession: widget.profession,
        phone: widget.phoneNumber,
        password: widget.password,
        firebaseIdToken: _firebaseIdToken,
      );
      // The ID token has done its job — drop it now that the backend
      // session has replaced it.
      _firebaseIdToken = null;
      AuthTokenStore.idToken = null;
      if (!mounted) return;
      setState(() => _isVerifying = false);
      widget.onVerified?.call();
    } on AuthApiException catch (error) {
      if (!mounted) return;
      setState(() => _isVerifying = false);
      _showMessage(error.message);
    } catch (_) {
      if (!mounted) return;
      setState(() => _isVerifying = false);
      _showMessage('Network error. Please check your connection and try again.');
    }
  }

  Future<void> _resendOtp() async {
    setState(() => _isResending = true);
    try {
      await _phoneAuthService.sendVerificationCode(
        phoneNumber: widget.phoneNumber,
        forceResendingToken: _resendToken,
        onCodeSent: (verificationId, resendToken) {
          if (!mounted) return;
          setState(() {
            _verificationId = verificationId;
            _resendToken = resendToken;
            _isResending = false;
          });
          _startResendTimer();
          _showMessage('A new OTP has been sent.');
        },
        onVerificationFailed: (error) {
          if (!mounted) return;
          setState(() => _isResending = false);
          _showMessage(mapFirebaseAuthError(error));
        },
        onAutoVerified: (credential) async {
          if (!mounted) return;
          setState(() => _isResending = false);
          setState(() => _isVerifying = true);
          await _captureFirebaseIdToken();
          await _completeSignup();
        },
      );
    } on FirebaseAuthException catch (error) {
      if (!mounted) return;
      setState(() => _isResending = false);
      _showMessage(mapFirebaseAuthError(error));
    } catch (_) {
      if (!mounted) return;
      setState(() => _isResending = false);
      _showMessage('Network error. Please check your connection and try again.');
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final contentWidth = width > 600 ? 600.0 : width;
    final keyboardInset = MediaQuery.viewInsetsOf(context).bottom;
    final canResend = _secondsRemaining == 0 && !_isResending;

    return Scaffold(
      backgroundColor: ivory,
      body: SizedBox.expand(
        child: Stack(
          children: [
            const Positioned.fill(child: BackgroundWave()),
            SafeArea(
              child: Center(
                child: SizedBox(
                  width: contentWidth,
                  child: SingleChildScrollView(
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    padding: EdgeInsets.fromLTRB(
                      24,
                      32,
                      24,
                      24 + keyboardInset,
                    ),
                    child: Column(
                      key: const ValueKey('otp.content'),
                      children: [
                        const AuthHeader(),
                        SizedBox(height: contentWidth * 0.08),
                        const Text(
                          'Create Your Account',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: navy,
                            fontFamily: 'Serif',
                            letterSpacing: -0.3,
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Join NYAYA and start your legal learning journey',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 13,
                            color: bodyGrey,
                            height: 1.4,
                          ),
                        ),
                        SizedBox(height: contentWidth * 0.08),
                        _buildOtpCard(canResend),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOtpCard(bool canResend) {
    return Container(
      key: const ValueKey('otp.card'),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFDF9),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: gold.withValues(alpha: 0.28)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Verify OTP',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: navy,
              fontFamily: 'Serif',
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "We've sent a 6-digit OTP to",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, color: bodyGrey.withValues(alpha: 0.9)),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.phoneNumber,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: navy,
                ),
              ),
              const SizedBox(width: 6),
              GestureDetector(
                key: const ValueKey('otp.button.change'),
                onTap: widget.onChangeNumber,
                behavior: HitTestBehavior.opaque,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.edit_outlined, size: 14, color: gold.withValues(alpha: 0.9)),
                    const SizedBox(width: 2),
                    const Text(
                      'Change',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: gold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Enter OTP',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: navy),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(
              _otpLength,
              (index) => _OtpDigitBox(
                key: ValueKey('otp.digit.$index'),
                controller: _controllers[index],
                focusNode: _focusNodes[index],
                enabled: !_isVerifying,
                onChanged: (value) => _handleDigitChanged(index, value),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: Column(
              children: [
                Text.rich(
                  TextSpan(
                    style: TextStyle(fontSize: 13, color: bodyGrey.withValues(alpha: 0.9)),
                    children: [
                      const TextSpan(text: "Didn't receive the OTP?\n"),
                      TextSpan(
                        text: canResend
                            ? 'Resend OTP'
                            : (_isResending
                                ? 'Resending…'
                                : 'Resend OTP in ${_formatSeconds(_secondsRemaining)}'),
                        style: const TextStyle(color: gold, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
                if (canResend)
                  TextButton(
                    key: const ValueKey('otp.button.resend'),
                    onPressed: _resendOtp,
                    child: const Text('Tap to resend'),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          AuthPrimaryButton(
            key: const ValueKey('otp.button.verify'),
            label: 'Verify & Continue',
            isLoading: _isVerifying,
            onPressed: _handleVerify,
          ),
        ],
      ),
    );
  }
}

String _formatSeconds(int totalSeconds) {
  final minutes = (totalSeconds ~/ 60).toString().padLeft(2, '0');
  final seconds = (totalSeconds % 60).toString().padLeft(2, '0');
  return '$minutes:$seconds';
}

class _OtpDigitBox extends StatelessWidget {
  const _OtpDigitBox({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.onChanged,
    this.enabled = true,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 44,
      height: 52,
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        onChanged: onChanged,
        enabled: enabled,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        cursorColor: navy,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: navy),
        decoration: InputDecoration(
          counterText: '',
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE7DFD5)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE7DFD5)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: gold.withValues(alpha: 0.88), width: 1.6),
          ),
        ),
      ),
    );
  }
}
