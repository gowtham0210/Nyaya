import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../app/theme/app_motion.dart';
import '../../../app/theme/app_tokens.dart';

import '../../../app/theme/app_typography.dart';

import '../../../app/post_sign_up_flow.dart';
import '../../../core/presentation/widgets/nyaya_widgets.dart';
import '../data/auth_api_client.dart';
import '../data/auth_repository.dart';
import '../data/firebase_phone_auth_service.dart';
import '../../../app/app_services.dart';
import 'sign_up_page.dart';
import 'widgets/auth_header.dart';
import 'widgets/auth_primary_button.dart';
import 'widgets/auth_text_field.dart';
import '../../../core/localization/l10n.dart';
import 'auth_error_text.dart';
import 'email_validation.dart';
import 'otp_verification_page.dart';

/// How the learner signs in: email + password (spec 041) or phone + OTP
/// (spec 042).
enum SignInMethod { email, phone }

class SignInPage extends StatefulWidget {
  const SignInPage({super.key, this.authRepository, this.phoneAuthService});

  /// Defaults to the app's; tests pass their own.
  final AuthRepository? authRepository;

  /// Defaults to Firebase; tests pass a fake.
  final FirebasePhoneAuthService? phoneAuthService;

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  // Deferred until first use — see the note in sign_up_page.dart.
  late final _authRepository =
      widget.authRepository ?? AppServices.authRepository;

  late final _phoneAuthService =
      widget.phoneAuthService ?? FirebasePhoneAuthService();

  // Email first: phone login isn't fully integrated yet (spec 041).
  var _method = SignInMethod.email;

  var _obscurePassword = true;
  var _isLoggingIn = false;

  @override
  void dispose() {
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final contentWidth = width > 600 ? 600.0 : width;
    final keyboardInset = MediaQuery.viewInsetsOf(context).bottom;

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
                      key: const ValueKey('signin.content'),
                      children: [
                        const AuthHeader(),
                        SizedBox(height: contentWidth * 0.08),
                        Text(
                          context.l10n.signInTitle,
                          key: const ValueKey('signin.title'),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                            color: navy,
                            fontFamily: NyayaFonts.display,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          context.l10n.signInSubtitle,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 13,
                            color: bodyGrey,
                            height: 1.4,
                          ),
                        ),
                        SizedBox(height: contentWidth * 0.08),
                        _SignInCard(
                          key: const ValueKey('signin.card'),
                          method: _method,
                          onMethodChanged: (method) =>
                              setState(() => _method = method),
                          emailController: _emailController,
                          phoneController: _phoneController,
                          passwordController: _passwordController,
                          obscurePassword: _obscurePassword,
                          isLoading: _isLoggingIn,
                          onToggleObscure: () => setState(
                            () => _obscurePassword = !_obscurePassword,
                          ),
                          onLoginPressed: _method == SignInMethod.email
                              ? _handleLogin
                              : _handleSendOtp,
                        ),
                        const SizedBox(height: 20),
                        _SignupLink(
                          key: const ValueKey('signin.footer.signup'),
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (_) => SignUpPage(
                                onSignInRequested: (signUpContext) =>
                                    Navigator.of(signUpContext).pop(),
                              ),
                            ),
                          ),
                        ),
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

  Future<void> _handleLogin() async {
    FocusScope.of(context).unfocus();
    final l10n = context.l10n;
    final email = _emailController.text.trim().toLowerCase();
    // Trimmed to avoid a stray leading/trailing space (e.g. from a keyboard
    // autocomplete tap) silently breaking the match — Signup trims the same
    // way, so both sides stay consistent.
    final password = _passwordController.text.trim();

    final emailError = validateEmail(l10n, email);
    if (emailError != null) {
      _showMessage(emailError);
      return;
    }
    if (password.isEmpty) {
      _showMessage(context.l10n.signInPasswordMissing);
      return;
    }

    setState(() => _isLoggingIn = true);
    try {
      await _authRepository.login(email: email, password: password);
      if (!mounted) return;
      setState(() => _isLoggingIn = false);
      // Reuses the existing post-auth entry point (goal selection -> home);
      // there's no separate "returning user" destination yet.
      startPostSignUpFlow(context);
    } on AuthApiException catch (error) {
      if (!mounted) return;
      setState(() => _isLoggingIn = false);
      _showMessage(authApiErrorText(context.l10n, error));
    } catch (_) {
      if (!mounted) return;
      setState(() => _isLoggingIn = false);
      _showMessage(context.l10n.errorOffline);
    }
  }

  /// Phone sign-in: no password; Firebase texts a code, the OTP page
  /// checks it, then the backend signs the learner in (spec 042).
  Future<void> _handleSendOtp() async {
    FocusScope.of(context).unfocus();
    final l10n = context.l10n;
    final digits = _phoneController.text.trim();
    if (digits.isEmpty) {
      _showMessage(l10n.signInPhoneMissing);
      return;
    }
    if (digits.length != 10) {
      _showMessage(l10n.validationPhoneInvalid);
      return;
    }
    // Sign-up stores "+91<digits>"; match it.
    final phone = _normalizePhone(digits);

    Future<void> completeAuth(String? firebaseIdToken) => _authRepository
        .phoneLogin(firebaseIdToken: firebaseIdToken ?? '', phone: phone);

    setState(() => _isLoggingIn = true);
    try {
      await _phoneAuthService.sendVerificationCode(
        phoneNumber: phone,
        onCodeSent: (verificationId, resendToken) {
          if (!mounted) return;
          setState(() => _isLoggingIn = false);
          Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (otpContext) => OtpVerificationPage(
                phoneNumber: phone,
                verificationId: verificationId,
                resendToken: resendToken,
                phoneAuthService: _phoneAuthService,
                completeAuth: completeAuth,
                onChangeNumber: () => Navigator.of(otpContext).pop(),
                onVerified: () => startPostSignUpFlow(otpContext),
              ),
            ),
          );
        },
        onVerificationFailed: (error) {
          if (!mounted) return;
          setState(() => _isLoggingIn = false);
          _showMessage(firebaseAuthErrorText(context.l10n, error));
        },
        onAutoVerified: (_) async {
          // Android can confirm the device without a code screen.
          try {
            await completeAuth(await _phoneAuthService.getIdToken());
            if (!mounted) return;
            setState(() => _isLoggingIn = false);
            startPostSignUpFlow(context);
          } on AuthApiException catch (error) {
            if (!mounted) return;
            setState(() => _isLoggingIn = false);
            _showMessage(authApiErrorText(context.l10n, error));
          }
        },
      );
    } on FirebaseAuthException catch (error) {
      if (!mounted) return;
      setState(() => _isLoggingIn = false);
      _showMessage(firebaseAuthErrorText(context.l10n, error));
    } catch (_) {
      if (!mounted) return;
      setState(() => _isLoggingIn = false);
      _showMessage(context.l10n.errorOffline);
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }
}

/// Mirrors how sign_up_page.dart builds the phone number it sends the
/// backend ("+91" + the 10-digit local number), so a returning user typing
/// just their local number on Login still matches what Signup stored.
/// Tolerates a leading "+", a leading "91", or stray spaces/dashes.
String _normalizePhone(String value) {
  final trimmed = value.trim();
  if (trimmed.startsWith('+')) {
    return '+${trimmed.substring(1).replaceAll(RegExp(r'\D'), '')}';
  }
  final digits = trimmed.replaceAll(RegExp(r'\D'), '');
  if (digits.length == 12 && digits.startsWith('91')) {
    return '+$digits';
  }
  return '+91$digits';
}

class _SignInCard extends StatelessWidget {
  const _SignInCard({
    super.key,
    required this.method,
    required this.onMethodChanged,
    required this.emailController,
    required this.phoneController,
    required this.passwordController,
    required this.obscurePassword,
    required this.onToggleObscure,
    required this.onLoginPressed,
    this.isLoading = false,
  });

  final SignInMethod method;
  final ValueChanged<SignInMethod> onMethodChanged;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController passwordController;
  final bool obscurePassword;
  final VoidCallback onToggleObscure;
  final VoidCallback onLoginPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: NyayaColors.surfaceWarm,
        borderRadius: BorderRadius.circular(NyayaRadii.md),
        border: Border.all(color: gold.withValues(alpha: 0.28)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _MethodSwitch(method: method, onChanged: onMethodChanged),
          const SizedBox(height: 16),
          switch (method) {
            SignInMethod.email => AuthTextField(
              key: const ValueKey('signin.field.email'),
              label: l10n.fieldEmailLabel,
              hint: l10n.fieldEmailHint,
              icon: Icons.mail_outline_rounded,
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              autofillHints: const [AutofillHints.email],
            ),
            SignInMethod.phone => AuthTextField(
              key: const ValueKey('signin.field.phone'),
              label: l10n.fieldPhoneLabel,
              hint: l10n.fieldPhoneHint,
              icon: Icons.call_outlined,
              controller: phoneController,
              keyboardType: TextInputType.phone,
              autofillHints: const [AutofillHints.telephoneNumber],
              prefixText: '+91',
              inputFormatters: indianMobileFormatters,
            ),
          },
          // Phone sign-in uses an OTP instead of a password (spec 042).
          if (method == SignInMethod.email) ...[
            const SizedBox(height: 16),
            AuthTextField(
              key: const ValueKey('signin.field.password'),
              label: l10n.fieldPasswordLabel,
              hint: l10n.fieldPasswordHint,
              icon: Icons.lock_outline_rounded,
              controller: passwordController,
              obscureText: obscurePassword,
              textInputAction: TextInputAction.done,
              autofillHints: const [AutofillHints.password],
              suffixIcon: IconButton(
                onPressed: onToggleObscure,
                tooltip: obscurePassword
                    ? l10n.showPassword
                    : l10n.hidePassword,
                icon: Icon(
                  obscurePassword
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                ),
                color: bodyGrey.withValues(alpha: 0.72),
              ),
            ),
          ],
          const SizedBox(height: 20),
          AuthPrimaryButton(
            key: ValueKey(
              method == SignInMethod.email
                  ? 'signin.button.login'
                  : 'signin.button.sendOtp',
            ),
            label: method == SignInMethod.email
                ? l10n.commonLogin
                : l10n.signUpSendOtp,
            isLoading: isLoading,
            onPressed: onLoginPressed,
          ),
        ],
      ),
    );
  }
}

/// Email | Phone, as a two-segment pill (spec 041).
class _MethodSwitch extends StatelessWidget {
  const _MethodSwitch({required this.method, required this.onChanged});

  final SignInMethod method;
  final ValueChanged<SignInMethod> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: NyayaColors.hairline.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(NyayaRadii.pill),
      ),
      child: Row(
        children: [
          for (final (option, label, icon) in [
            (SignInMethod.email, l10n.authMethodEmail, Icons.mail_outline),
            (SignInMethod.phone, l10n.authMethodPhone, Icons.call_outlined),
          ])
            Expanded(
              child: Semantics(
                button: true,
                selected: option == method,
                child: GestureDetector(
                  key: ValueKey('signin.method.${option.name}'),
                  behavior: HitTestBehavior.opaque,
                  onTap: () => onChanged(option),
                  child: AnimatedContainer(
                    duration: NyayaMotion.of(context, NyayaMotion.quick),
                    curve: NyayaMotion.curve,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: option == method
                          ? NyayaColors.surface
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(NyayaRadii.pill),
                      boxShadow: option == method ? NyayaShadows.card : null,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          icon,
                          size: 16,
                          color: option == method ? gold : bodyGrey,
                        ),
                        const SizedBox(width: 6),
                        Flexible(
                          child: Text(
                            label,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: option == method ? navy : bodyGrey,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _SignupLink extends StatelessWidget {
  const _SignupLink({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: const TextStyle(fontSize: 14, color: bodyGrey),
            children: [
              TextSpan(text: context.l10n.signInNoAccount),
              TextSpan(
                text: context.l10n.commonSignUp,
                style: const TextStyle(
                  color: gold,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
