import 'package:flutter/material.dart';

import '../../../app/post_sign_up_flow.dart';
import '../../../core/presentation/widgets/nyaya_widgets.dart';
import '../data/auth_api_client.dart';
import '../data/auth_repository.dart';
import 'sign_up_page.dart';
import 'widgets/auth_header.dart';
import 'widgets/auth_primary_button.dart';
import 'widgets/auth_text_field.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _identifierController = TextEditingController();
  final _passwordController = TextEditingController();

  // Deferred until first use — see the note in sign_up_page.dart.
  late final _authRepository = AuthRepository();

  var _obscurePassword = true;
  var _isLoggingIn = false;

  @override
  void dispose() {
    _identifierController.dispose();
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
                        const Text(
                          'Welcome Back to NYAYA !',
                          key: ValueKey('signin.title'),
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
                          'Rejoin NYAYA and start your legal learning journey',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 13,
                            color: bodyGrey,
                            height: 1.4,
                          ),
                        ),
                        SizedBox(height: contentWidth * 0.08),
                        _SignInCard(
                          key: const ValueKey('signin.card'),
                          identifierController: _identifierController,
                          passwordController: _passwordController,
                          obscurePassword: _obscurePassword,
                          isLoading: _isLoggingIn,
                          onToggleObscure: () => setState(
                            () => _obscurePassword = !_obscurePassword,
                          ),
                          onLoginPressed: _handleLogin,
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
    final identifier = _identifierController.text.trim();
    // Trimmed to avoid a stray leading/trailing space (e.g. from a keyboard
    // autocomplete tap) silently breaking the match — Signup trims the same
    // way, so both sides stay consistent.
    final password = _passwordController.text.trim();

    if (identifier.isEmpty) {
      _showMessage('Enter your phone number.');
      return;
    }
    if (password.isEmpty) {
      _showMessage('Enter your password.');
      return;
    }

    setState(() => _isLoggingIn = true);
    try {
      await _authRepository.login(
        // Signup always stores phone numbers as "+91<digits>" (see
        // sign_up_page.dart); normalize the same way here so a user typing
        // just the 10-digit number still matches what's in the database.
        phone: _normalizePhone(identifier),
        password: password,
      );
      if (!mounted) return;
      setState(() => _isLoggingIn = false);
      // Reuses the existing post-auth entry point (goal selection -> home);
      // there's no separate "returning user" destination yet.
      startPostSignUpFlow(context);
    } on AuthApiException catch (error) {
      if (!mounted) return;
      setState(() => _isLoggingIn = false);
      _showMessage(error.message);
    } catch (_) {
      if (!mounted) return;
      setState(() => _isLoggingIn = false);
      _showMessage('Network error. Please check your connection and try again.');
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
    required this.identifierController,
    required this.passwordController,
    required this.obscurePassword,
    required this.onToggleObscure,
    required this.onLoginPressed,
    this.isLoading = false,
  });

  final TextEditingController identifierController;
  final TextEditingController passwordController;
  final bool obscurePassword;
  final VoidCallback onToggleObscure;
  final VoidCallback onLoginPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFDF9),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: gold.withValues(alpha: 0.28)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AuthTextField(
            key: const ValueKey('signin.field.identifier'),
            label: 'Phone Number',
            hint: 'Enter your phone number',
            icon: Icons.call_outlined,
            controller: identifierController,
            keyboardType: TextInputType.phone,
            autofillHints: const [AutofillHints.telephoneNumber],
          ),
          const SizedBox(height: 16),
          AuthTextField(
            key: const ValueKey('signin.field.password'),
            label: 'Password',
            hint: 'Create a strong password',
            icon: Icons.lock_outline_rounded,
            controller: passwordController,
            obscureText: obscurePassword,
            textInputAction: TextInputAction.done,
            autofillHints: const [AutofillHints.password],
            suffixIcon: IconButton(
              onPressed: onToggleObscure,
              tooltip: obscurePassword ? 'Show password' : 'Hide password',
              icon: Icon(
                obscurePassword
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
              ),
              color: bodyGrey.withValues(alpha: 0.72),
            ),
          ),
          const SizedBox(height: 20),
          AuthPrimaryButton(
            key: const ValueKey('signin.button.login'),
            label: 'Login',
            isLoading: isLoading,
            onPressed: onLoginPressed,
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
          text: const TextSpan(
            style: TextStyle(fontSize: 14, color: bodyGrey),
            children: [
              TextSpan(text: "Don't have an account? "),
              TextSpan(
                text: 'Signup',
                style: TextStyle(color: gold, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
