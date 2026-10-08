import 'package:flutter/material.dart';

import '../../../app/theme/app_tokens.dart';

import '../../../app/theme/app_typography.dart';

import '../../../app/post_sign_up_flow.dart';
import '../../../core/presentation/widgets/nyaya_widgets.dart';
import '../data/auth_api_client.dart';
import '../data/auth_repository.dart';
import '../../../app/app_services.dart';
import 'widgets/auth_header.dart';
import 'widgets/auth_primary_button.dart';
import 'widgets/auth_text_field.dart';
import '../../../core/localization/l10n.dart';
import 'auth_error_text.dart';
import 'email_validation.dart';
import 'name_validation.dart';
import 'profession.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key, this.onSignInRequested, this.authRepository});

  final void Function(BuildContext context)? onSignInRequested;

  /// Defaults to the app's; tests pass their own.
  final AuthRepository? authRepository;

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _professionController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();

  // Email sign-up straight to the backend, no phone OTP (spec 041). The
  // OTP page and Firebase service stay for when phone sign-up returns.
  late final _authRepository =
      widget.authRepository ?? AppServices.authRepository;

  var _obscurePassword = true;
  var _hasAttemptedSubmit = false;
  var _isSubmitting = false;

  /// The picked profession. The field shows its localized label; the
  /// backend gets its stable English [Profession.value].
  Profession? _profession;

  IconData get _selectedProfessionIcon =>
      _profession?.icon ?? Icons.work_outline_rounded;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Keep the field's label in the current language.
    final profession = _profession;
    if (profession != null) {
      _professionController.text = profession.label(context.l10n);
    }
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
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
                        Text(
                          context.l10n.signUpTitle,
                          key: const ValueKey('signup.title'),
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
                          context.l10n.authJoinSubtitle,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
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
        color: NyayaColors.surfaceWarm,
        borderRadius: BorderRadius.circular(NyayaRadii.md),
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
              label: context.l10n.fieldFullNameLabel,
              hint: context.l10n.fieldFullNameHint,
              icon: Icons.person_outline_rounded,
              controller: _fullNameController,
              textCapitalization: TextCapitalization.words,
              autofillHints: const [AutofillHints.name],
              validator: _validateFullName,
            ),
            const SizedBox(height: 16),
            AuthTextField(
              key: const ValueKey('signup.field.email'),
              label: context.l10n.fieldEmailLabel,
              hint: context.l10n.fieldEmailHint,
              icon: Icons.mail_outline_rounded,
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              autofillHints: const [AutofillHints.email],
              validator: (value) => validateEmail(context.l10n, value),
            ),
            const SizedBox(height: 16),
            AuthTextField(
              key: const ValueKey('signup.field.profession'),
              label: context.l10n.fieldProfessionLabel,
              hint: context.l10n.fieldProfessionHint,
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
              label: context.l10n.fieldPasswordLabel,
              hint: context.l10n.fieldPasswordHintCreate,
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
                    ? context.l10n.showPassword
                    : context.l10n.hidePassword,
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
              label: context.l10n.fieldPhoneOptionalLabel,
              hint: context.l10n.fieldPhoneHint,
              icon: Icons.call_outlined,
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.done,
              autofillHints: const [AutofillHints.telephoneNumber],
              prefixText: '+91',
              inputFormatters: indianMobileFormatters,
              validator: _validatePhone,
            ),
            const SizedBox(height: 20),
            AuthPrimaryButton(
              key: const ValueKey('signup.button.create'),
              label: context.l10n.signUpCreateAccount,
              backgroundColor: gold,
              isLoading: _isSubmitting,
              onPressed: _submitForm,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickProfession(BuildContext context) async {
    FocusScope.of(context).unfocus();
    final l10n = context.l10n;
    final selected = await showModalBottomSheet<Profession>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(NyayaRadii.md),
        ),
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
                  color: NyayaColors.hairline,
                  borderRadius: BorderRadius.circular(NyayaRadii.pill),
                ),
              ),
              for (final profession in Profession.values) ...[
                _ProfessionOptionTile(
                  label: profession.label(l10n),
                  icon: profession.icon,
                  isSelected: profession == _profession,
                  onTap: () => Navigator.of(sheetContext).pop(profession),
                ),
                const SizedBox(height: 10),
              ],
            ],
          ),
        ),
      ),
    );
    if (selected != null && mounted) {
      setState(() {
        _profession = selected;
        _professionController.text = selected.label(l10n);
      });
    }
  }

  String? _validateFullName(String? value) =>
      validateFullName(context.l10n, value);

  String? _validateProfession(String? value) {
    if (_profession == null) {
      return context.l10n.validationProfessionRequired;
    }
    return null;
  }

  String? _validatePassword(String? value) {
    final text = value ?? '';
    final hasLetter = RegExp(r'[A-Za-z]').hasMatch(text);
    final hasNumber = RegExp(r'\d').hasMatch(text);
    if (text.isEmpty) {
      return context.l10n.validationPasswordRequired;
    }
    if (text.length < 8 || !hasLetter || !hasNumber) {
      return context.l10n.validationPasswordWeak;
    }
    return null;
  }

  String? _validatePhone(String? value) {
    final digits = (value ?? '').replaceAll(RegExp(r'\D'), '');
    // Optional (spec 041), but a number given must be complete.
    if (digits.isEmpty) {
      return null;
    }
    if (digits.length != 10) {
      return context.l10n.validationPhoneInvalid;
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
    setState(() => _isSubmitting = true);
    try {
      await _authRepository.register(
        fullName: _fullNameController.text.trim(),
        email: _emailController.text.trim().toLowerCase(),
        // Trimmed so a stray keyboard-inserted space doesn't silently make
        // this password different from what Login sends later.
        password: _passwordController.text.trim(),
        profession: _profession!.value,
        phone: digits.isEmpty ? null : '+91$digits',
      );
      if (!mounted) return;
      setState(() => _isSubmitting = false);
      startPostSignUpFlow(context);
    } on AuthApiException catch (error) {
      if (!mounted) return;
      setState(() => _isSubmitting = false);
      _showMessage(authApiErrorText(context.l10n, error));
    } catch (_) {
      if (!mounted) return;
      setState(() => _isSubmitting = false);
      _showMessage(context.l10n.errorOffline);
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
    const borderColor = NyayaColors.hairline;
    const fillColor = NyayaColors.surfaceWarm;
    final selectedFill = gold.withValues(alpha: 0.14);
    final selectedBorder = gold.withValues(alpha: 0.6);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        key: ValueKey('signup.profession.option.$label'),
        onTap: onTap,
        borderRadius: BorderRadius.circular(NyayaRadii.sm),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: isSelected ? selectedFill : fillColor,
            borderRadius: BorderRadius.circular(NyayaRadii.sm),
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
              if (isSelected) Icon(Icons.check_circle, size: 18, color: gold),
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
          text: TextSpan(
            style: const TextStyle(fontSize: 14, color: bodyGrey),
            children: [
              TextSpan(text: context.l10n.commonHaveAccount),
              TextSpan(
                text: context.l10n.commonLogin,
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
