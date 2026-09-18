import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../app/post_sign_up_flow.dart';
import '../../../core/presentation/widgets/nyaya_widgets.dart';
import '../data/auth_api_client.dart';
import '../data/auth_repository.dart';
import '../data/firebase_auth_error_mapper.dart';
import '../data/firebase_phone_auth_service.dart';
import 'otp_verification_page.dart';
import 'widgets/auth_header.dart';
import 'widgets/auth_primary_button.dart';
import 'widgets/auth_text_field.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key, this.onSignInRequested});

  final void Function(BuildContext context)? onSignInRequested;

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _professionController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();

  // Deferred until first use so widget tests that never submit the form
  // don't need a configured Firebase app just to render this page.
  late final _phoneAuthService = FirebasePhoneAuthService();
  late final _authRepository = AuthRepository();

  var _obscurePassword = true;
  var _hasAttemptedSubmit = false;
  var _isSendingOtp = false;

  static const _professions = [
    (label: 'Law Student', icon: Icons.school_outlined),
    (label: 'Lawyer / Advocate', icon: Icons.balance_outlined),
    (label: 'Judge / Judicial Officer', icon: Icons.gavel_rounded),
    (label: 'Legal Professional', icon: Icons.work_outline_rounded),
    (label: 'General Citizen', icon: Icons.person_outline_rounded),
  ];

  IconData get _selectedProfessionIcon {
    final label = _professionController.text;
    for (final profession in _professions) {
      if (profession.label == label) {
        return profession.icon;
      }
    }
    return Icons.work_outline_rounded;
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _professionController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
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
                      key: const ValueKey('signup.content'),
                      children: [
                        const AuthHeader(),
                        SizedBox(height: contentWidth * 0.08),
                        const Text(
                          'Create Your Account',
                          key: ValueKey('signup.title'),
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
                        _buildSignUpCard(context),
                        const SizedBox(height: 20),
                        _LoginLink(
                          key: const ValueKey('signup.footer.login'),
                          onTap: () => _handleSignInRequested(context),
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

  Widget _buildSignUpCard(BuildContext context) {
    return Container(
      key: const ValueKey('signup.card'),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFDF9),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: gold.withValues(alpha: 0.28)),
      ),
      child: Form(
        key: _formKey,
        autovalidateMode: _hasAttemptedSubmit
            ? AutovalidateMode.onUserInteraction
            : AutovalidateMode.disabled,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AuthTextField(
              key: const ValueKey('signup.field.fullName'),
              label: 'Full Name',
              hint: 'Enter your full name',
              icon: Icons.person_outline_rounded,
              controller: _fullNameController,
              textCapitalization: TextCapitalization.words,
              autofillHints: const [AutofillHints.name],
              validator: _validateFullName,
            ),
            const SizedBox(height: 16),
            AuthTextField(
              key: const ValueKey('signup.field.profession'),
              label: 'Profession',
              hint: 'Select your profession',
              icon: _selectedProfessionIcon,
              controller: _professionController,
              readOnly: true,
              onTap: () => _pickProfession(context),
              validator: _validateProfession,
              suffixIcon: Icon(
                Icons.keyboard_arrow_down_rounded,
                color: bodyGrey.withValues(alpha: 0.72),
              ),
            ),
            const SizedBox(height: 16),
            AuthTextField(
              key: const ValueKey('signup.field.password'),
              label: 'Password',
              hint: 'Create a strong password',
              icon: Icons.lock_outline_rounded,
              controller: _passwordController,
              obscureText: _obscurePassword,
              textInputAction: TextInputAction.next,
              autofillHints: const [AutofillHints.newPassword],
              validator: _validatePassword,
              suffixIcon: IconButton(
                onPressed: () =>
                    setState(() => _obscurePassword = !_obscurePassword),
                tooltip: _obscurePassword
                    ? 'Show password'
                    : 'Hide password',
                icon: Icon(
                  _obscurePassword
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                ),
                color: bodyGrey.withValues(alpha: 0.72),
              ),
            ),
            const SizedBox(height: 16),
            AuthTextField(
              key: const ValueKey('signup.field.phone'),
              label: 'Phone Number',
              hint: 'Enter your phone number',
              icon: Icons.call_outlined,
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.done,
              autofillHints: const [AutofillHints.telephoneNumber],
              prefixText: '+91',
              validator: _validatePhone,
            ),
            const SizedBox(height: 20),
            AuthPrimaryButton(
              key: const ValueKey('signup.button.sendOtp'),
              label: 'Send OTP',
              backgroundColor: gold,
              isLoading: _isSendingOtp,
              onPressed: _submitForm,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickProfession(BuildContext context) async {
    FocusScope.of(context).unfocus();
    final currentSelection = _professionController.text;
    final selected = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 36,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFFE7DFD5),
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              for (final profession in _professions) ...[
                _ProfessionOptionTile(
                  label: profession.label,
                  icon: profession.icon,
                  isSelected: profession.label == currentSelection,
                  onTap: () => Navigator.of(sheetContext).pop(profession.label),
                ),
                const SizedBox(height: 10),
              ],
            ],
          ),
        ),
      ),
    );
    if (selected != null && mounted) {
      setState(() => _professionController.text = selected);
    }
  }

  String? _validateFullName(String? value) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) {
      return 'Full name is required';
    }
    if (trimmed.length < 3) {
      return 'Name must be at least 3 characters';
    }
    return null;
  }

  String? _validateProfession(String? value) {
    if ((value ?? '').trim().isEmpty) {
      return 'Profession is required';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    final text = value ?? '';
    final hasLetter = RegExp(r'[A-Za-z]').hasMatch(text);
    final hasNumber = RegExp(r'\d').hasMatch(text);
    if (text.isEmpty) {
      return 'Password is required';
    }
    if (text.length < 8 || !hasLetter || !hasNumber) {
      return 'Use at least 8 characters with letters and numbers';
    }
    return null;
  }

  String? _validatePhone(String? value) {
    final digits = (value ?? '').replaceAll(RegExp(r'\D'), '');
    if (digits.isEmpty) {
      return 'Phone number is required';
    }
    if (digits.length < 10 || digits.length > 15) {
      return 'Enter a valid phone number';
    }
    return null;
  }

  Future<void> _submitForm() async {
    FocusScope.of(context).unfocus();
    setState(() => _hasAttemptedSubmit = true);

    final isFormValid = _formKey.currentState?.validate() ?? false;
    if (!isFormValid) {
      return;
    }

    final digits = _phoneController.text.replaceAll(RegExp(r'\D'), '');
    final phoneNumber = '+91$digits';
    final fullName = _fullNameController.text.trim();
    final profession = _professionController.text;
    // Trimmed so a stray keyboard-inserted space doesn't silently make this
    // password different from what Login sends later (see sign_in_page.dart).
    final password = _passwordController.text.trim();
    setState(() => _isSendingOtp = true);

    try {
      await _phoneAuthService.sendVerificationCode(
        phoneNumber: phoneNumber,
        onCodeSent: (verificationId, resendToken) {
          if (!mounted) return;
          setState(() => _isSendingOtp = false);
          Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (otpContext) => OtpVerificationPage(
                phoneNumber: phoneNumber,
                verificationId: verificationId,
                resendToken: resendToken,
                fullName: fullName,
                profession: profession,
                password: password,
                onChangeNumber: () => Navigator.of(otpContext).pop(),
                onVerified: () => startPostSignUpFlow(otpContext),
              ),
            ),
          );
        },
        onVerificationFailed: (error) {
          if (!mounted) return;
          setState(() => _isSendingOtp = false);
          _showMessage(mapFirebaseAuthError(error));
        },
        onAutoVerified: (credential) async {
          // Android could silently confirm the device without ever showing
          // an OTP screen — finish the backend signup right here instead.
          final firebaseIdToken = await _phoneAuthService.getIdToken();
          await _completeSignup(
            fullName: fullName,
            profession: profession,
            phone: phoneNumber,
            password: password,
            firebaseIdToken: firebaseIdToken,
          );
        },
      );
    } on FirebaseAuthException catch (error) {
      if (!mounted) return;
      setState(() => _isSendingOtp = false);
      _showMessage(mapFirebaseAuthError(error));
    } catch (_) {
      if (!mounted) return;
      setState(() => _isSendingOtp = false);
      _showMessage('Network error. Please check your connection and try again.');
    }
  }

  Future<void> _completeSignup({
    required String fullName,
    required String profession,
    required String phone,
    required String password,
    String? firebaseIdToken,
  }) async {
    try {
      await _authRepository.signup(
        fullName: fullName,
        profession: profession,
        phone: phone,
        password: password,
        firebaseIdToken: firebaseIdToken,
      );
      if (!mounted) return;
      setState(() => _isSendingOtp = false);
      startPostSignUpFlow(context);
    } on AuthApiException catch (error) {
      if (!mounted) return;
      setState(() => _isSendingOtp = false);
      _showMessage(error.message);
    } catch (_) {
      if (!mounted) return;
      setState(() => _isSendingOtp = false);
      _showMessage('Network error. Please check your connection and try again.');
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  void _handleSignInRequested(BuildContext context) {
    final onSignInRequested = widget.onSignInRequested;
    if (onSignInRequested != null) {
      onSignInRequested(context);
      return;
    }
    Navigator.maybePop(context);
  }
}

/// One row in the profession picker sheet, styled to match the signup
/// card's text fields: same rounded border, fill color and label weight,
/// with a soft gold highlight when selected.
class _ProfessionOptionTile extends StatelessWidget {
  const _ProfessionOptionTile({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    const borderColor = Color(0xFFE7DFD5);
    const fillColor = Color(0xFFFFFCF8);
    final selectedFill = gold.withValues(alpha: 0.14);
    final selectedBorder = gold.withValues(alpha: 0.6);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        key: ValueKey('signup.profession.option.$label'),
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: isSelected ? selectedFill : fillColor,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isSelected ? selectedBorder : borderColor,
              width: isSelected ? 1.4 : 1,
            ),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: 20,
                color: isSelected ? gold : bodyGrey.withValues(alpha: 0.74),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    color: navy,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
              ),
              if (isSelected)
                Icon(Icons.check_circle, size: 18, color: gold),
            ],
          ),
        ),
      ),
    );
  }
}

class _LoginLink extends StatelessWidget {
  const _LoginLink({super.key, required this.onTap});

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
              TextSpan(text: 'Already have an account? '),
              TextSpan(
                text: 'Login',
                style: TextStyle(color: gold, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
