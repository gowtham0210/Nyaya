import 'package:flutter/material.dart';

import '../../../core/presentation/widgets/nyaya_widgets.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key, this.onSignInRequested, this.onSignUpCompleted});

  final void Function(BuildContext context)? onSignInRequested;

  /// Called when the form passes validation and the user submits.
  final void Function(BuildContext context)? onSignUpCompleted;

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  var _obscurePassword = true;
  var _obscureConfirmPassword = true;
  var _agreedToTerms = true;
  var _hasAttemptedSubmit = false;

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final safeArea = MediaQuery.paddingOf(context);
    final keyboardInset = MediaQuery.viewInsetsOf(context).bottom;
    final width = size.width;

    final topSectionHeight = (size.height * 0.42)
        .clamp(340.0, 450.0)
        .toDouble();
    final templeWidth = (width * 0.54).clamp(200.0, 320.0).toDouble();
    final heroWidth = (width * 0.5).clamp(190.0, 290.0).toDouble();
    final bottomDotWidth = (width * 0.24).clamp(82.0, 118.0).toDouble();
    final brandScale = width < 360 ? 0.68 : 0.76;
    final introMaxWidth = width * 0.56;

    const templeAsset = 'assets/backgrounds/temple_bg.png';
    const starAsset = 'assets/icons/star.png';
    // Temporary fallback until a dedicated signup illustration lands.
    const heroAsset = 'assets/onboarding/onboarding_2_hero.png';

    return Scaffold(
      backgroundColor: ivory,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              const Positioned.fill(child: BackgroundWave()),
              Positioned(
                key: const ValueKey('signup.temple'),
                right: -34,
                top: 84,
                child: IgnorePointer(
                  child: Opacity(
                    opacity: 0.13,
                    child: Image.asset(
                      templeAsset,
                      width: templeWidth,
                      fit: BoxFit.contain,
                      excludeFromSemantics: true,
                    ),
                  ),
                ),
              ),
              Positioned(
                key: const ValueKey('signup.dots.bottomLeft'),
                left: 10,
                bottom: 34,
                child: IgnorePointer(
                  child: Opacity(
                    opacity: 0.48,
                    child: DotPattern(
                      width: bottomDotWidth,
                      height: bottomDotWidth * 0.78,
                    ),
                  ),
                ),
              ),
              Positioned(
                key: const ValueKey('signup.star.bottomRight'),
                right: 18,
                bottom: 42,
                child: IgnorePointer(
                  child: Opacity(
                    opacity: 0.95,
                    child: Image.asset(
                      starAsset,
                      width: 24,
                      excludeFromSemantics: true,
                    ),
                  ),
                ),
              ),
              SafeArea(
                child: SingleChildScrollView(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  padding: EdgeInsets.fromLTRB(24, 8, 24, 28 + keyboardInset),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight:
                            constraints.maxHeight - safeArea.vertical - 36,
                        maxWidth: 560,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(
                            height: topSectionHeight,
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Positioned(
                                  key: const ValueKey('signup.back'),
                                  left: -4,
                                  top: 0,
                                  child: IconButton(
                                    onPressed: () =>
                                        Navigator.maybePop(context),
                                    icon: const Icon(
                                      Icons.arrow_back_ios_new_rounded,
                                      color: navy,
                                      size: 22,
                                    ),
                                    tooltip: 'Back',
                                    splashRadius: 24,
                                  ),
                                ),
                                Positioned(
                                  right: -heroWidth * 0.16,
                                  top: 70,
                                  child: _HeroGlow(size: heroWidth * 1.1),
                                ),
                                Positioned(
                                  right: -6,
                                  top: 120,
                                  width: heroWidth,
                                  child: IgnorePointer(
                                    child: Image.asset(
                                      heroAsset,
                                      fit: BoxFit.contain,
                                      excludeFromSemantics: true,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  left: 0,
                                  top: 44,
                                  child: Transform.scale(
                                    scale: brandScale,
                                    alignment: Alignment.topLeft,
                                    child: const BrandLockup(),
                                  ),
                                ),
                                Positioned(
                                  left: 0,
                                  bottom: 18,
                                  child: ConstrainedBox(
                                    constraints: BoxConstraints(
                                      maxWidth: introMaxWidth,
                                    ),
                                    child: const _IntroCopy(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Transform.translate(
                            offset: const Offset(0, -12),
                            child: _buildSignUpCard(context),
                          ),
                          const SizedBox(height: 8),
                          _FooterSignIn(
                            onPressed: () => _handleSignInRequested(context),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSignUpCard(BuildContext context) {
    return Container(
      key: const ValueKey('signup.card'),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.96),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.88),
          width: 1.4,
        ),
        boxShadow: [
          BoxShadow(
            color: navy.withValues(alpha: 0.08),
            blurRadius: 36,
            offset: const Offset(0, 18),
          ),
          BoxShadow(
            color: gold.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
      child: Form(
        key: _formKey,
        autovalidateMode: _hasAttemptedSubmit
            ? AutovalidateMode.onUserInteraction
            : AutovalidateMode.disabled,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "Let's get you started",
              key: ValueKey('signup.card.title'),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w700,
                color: navy,
                fontFamily: 'serif',
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Create an account to begin your journey',
              key: ValueKey('signup.card.subtitle'),
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, height: 1.5, color: bodyGrey),
            ),
            const SizedBox(height: 28),
            AutofillGroup(
              child: Column(
                children: [
                  _AuthTextFormField(
                    key: const ValueKey('signup.field.fullName'),
                    controller: _fullNameController,
                    label: 'Full Name',
                    hint: 'Enter your full name',
                    icon: Icons.person_outline_rounded,
                    autofillHints: const [AutofillHints.name],
                    keyboardType: TextInputType.name,
                    textCapitalization: TextCapitalization.words,
                    validator: _validateFullName,
                  ),
                  const SizedBox(height: 18),
                  _AuthTextFormField(
                    key: const ValueKey('signup.field.email'),
                    controller: _emailController,
                    label: 'Email Address',
                    hint: 'Enter your email address',
                    icon: Icons.mail_outline_rounded,
                    autofillHints: const [AutofillHints.email],
                    keyboardType: TextInputType.emailAddress,
                    validator: _validateEmail,
                  ),
                  const SizedBox(height: 18),
                  _AuthTextFormField(
                    key: const ValueKey('signup.field.phone'),
                    controller: _phoneController,
                    label: 'Phone Number',
                    hint: 'Enter your phone number',
                    icon: Icons.call_outlined,
                    autofillHints: const [AutofillHints.telephoneNumber],
                    keyboardType: TextInputType.phone,
                    validator: _validatePhone,
                  ),
                  const SizedBox(height: 18),
                  _AuthTextFormField(
                    key: const ValueKey('signup.field.password'),
                    controller: _passwordController,
                    label: 'Password',
                    hint: 'Create a password',
                    icon: Icons.lock_outline_rounded,
                    obscureText: _obscurePassword,
                    autofillHints: const [AutofillHints.newPassword],
                    textInputAction: TextInputAction.next,
                    validator: _validatePassword,
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
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
                  const SizedBox(height: 8),
                  const _PasswordHelperRow(),
                  const SizedBox(height: 18),
                  _AuthTextFormField(
                    key: const ValueKey('signup.field.confirmPassword'),
                    controller: _confirmPasswordController,
                    label: 'Confirm Password',
                    hint: 'Confirm your password',
                    icon: Icons.lock_outline_rounded,
                    obscureText: _obscureConfirmPassword,
                    autofillHints: const [AutofillHints.newPassword],
                    textInputAction: TextInputAction.done,
                    validator: _validateConfirmPassword,
                    onFieldSubmitted: (_) => _submitForm(),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _obscureConfirmPassword = !_obscureConfirmPassword;
                        });
                      },
                      tooltip: _obscureConfirmPassword
                          ? 'Show password confirmation'
                          : 'Hide password confirmation',
                      icon: Icon(
                        _obscureConfirmPassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                      ),
                      color: bodyGrey.withValues(alpha: 0.72),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),
            SizedBox(
              height: 56,
              child: ElevatedButton(
                key: const ValueKey('signup.button.primary'),
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: navy,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                child: const Text(
                  'SIGN UP',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            const _AuthDivider(key: ValueKey('signup.divider')),
            const SizedBox(height: 20),
            SizedBox(
              height: 56,
              child: OutlinedButton(
                key: const ValueKey('signup.button.google'),
                onPressed: () =>
                    _showPlaceholderMessage('Google sign-up is not wired yet.'),
                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: navy,
                  side: const BorderSide(color: Color(0xFFE7DFD5), width: 1.2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _GoogleMark(),
                      SizedBox(width: 14),
                      Text(
                        'Continue with Google',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 18),
            _TermsAgreementField(
              key: const ValueKey('signup.terms'),
              agreed: _agreedToTerms,
              onChanged: (value) {
                setState(() {
                  _agreedToTerms = value;
                });
              },
              onOpenTerms: () {
                _showPlaceholderMessage(
                  'Terms of Service content coming soon.',
                );
              },
              onOpenPrivacy: () {
                _showPlaceholderMessage('Privacy Policy content coming soon.');
              },
            ),
          ],
        ),
      ),
    );
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

  String? _validateEmail(String? value) {
    final trimmed = value?.trim() ?? '';
    final emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (trimmed.isEmpty) {
      return 'Email address is required';
    }
    if (!emailPattern.hasMatch(trimmed)) {
      return 'Enter a valid email address';
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

  String? _validateConfirmPassword(String? value) {
    final text = value ?? '';
    if (text.isEmpty) {
      return 'Confirm your password to continue';
    }
    if (text != _passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  void _submitForm() {
    FocusScope.of(context).unfocus();
    setState(() {
      _hasAttemptedSubmit = true;
    });

    final isFormValid = _formKey.currentState?.validate() ?? false;
    if (!isFormValid) {
      return;
    }
    if (!_agreedToTerms) {
      _showPlaceholderMessage('Please accept the terms to continue.');
      return;
    }

    final onSignUpCompleted = widget.onSignUpCompleted;
    if (onSignUpCompleted != null) {
      onSignUpCompleted(context);
      return;
    }
    _showPlaceholderMessage('Sign-up submission will be wired next.');
  }

  void _handleSignInRequested(BuildContext context) {
    final onSignInRequested = widget.onSignInRequested;
    if (onSignInRequested != null) {
      onSignInRequested(context);
      return;
    }
    Navigator.maybePop(context);
  }

  void _showPlaceholderMessage(String message) {
    if (!mounted) {
      return;
    }
    final messenger = ScaffoldMessenger.of(context);
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }
}

class _IntroCopy extends StatelessWidget {
  const _IntroCopy();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Create Your Account',
          key: ValueKey('signup.intro.title'),
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w700,
            color: navy,
            fontFamily: 'serif',
            height: 1.05,
            letterSpacing: -0.7,
          ),
        ),
        const SizedBox(height: 12),
        Text.rich(
          const TextSpan(
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              height: 1.6,
              color: bodyGrey,
            ),
            children: [
              TextSpan(text: 'Start your legal learning\njourney with '),
              TextSpan(
                text: 'Nyaya',
                style: TextStyle(color: gold, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          key: const ValueKey('signup.intro.subtitle'),
        ),
      ],
    );
  }
}

class _AuthTextFormField extends StatelessWidget {
  const _AuthTextFormField({
    super.key,
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    required this.validator,
    this.autofillHints,
    this.keyboardType,
    this.obscureText = false,
    this.textCapitalization = TextCapitalization.none,
    this.textInputAction = TextInputAction.next,
    this.suffixIcon,
    this.onFieldSubmitted,
  });

  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final String? Function(String?) validator;
  final Iterable<String>? autofillHints;
  final TextInputType? keyboardType;
  final bool obscureText;
  final TextCapitalization textCapitalization;
  final TextInputAction textInputAction;
  final Widget? suffixIcon;
  final ValueChanged<String>? onFieldSubmitted;

  @override
  Widget build(BuildContext context) {
    const borderColor = Color(0xFFE7DFD5);
    const fillColor = Color(0xFFFFFCF8);
    const hintColor = Color(0xFF8A94A6);
    const errorColor = Color(0xFFB64A4A);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: navy,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          autofillHints: autofillHints?.toList(),
          keyboardType: keyboardType,
          textCapitalization: textCapitalization,
          textInputAction: textInputAction,
          cursorColor: navy,
          enableSuggestions: !obscureText,
          autocorrect: !obscureText,
          validator: validator,
          onFieldSubmitted: onFieldSubmitted,
          decoration: InputDecoration(
            filled: true,
            fillColor: fillColor,
            hintText: hint,
            hintStyle: const TextStyle(color: hintColor, fontSize: 14),
            prefixIcon: Icon(icon, size: 20),
            prefixIconColor: bodyGrey.withValues(alpha: 0.74),
            suffixIcon: suffixIcon,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 18,
            ),
            errorMaxLines: 2,
            errorStyle: const TextStyle(
              color: errorColor,
              fontSize: 12,
              height: 1.3,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: const BorderSide(color: borderColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: const BorderSide(color: borderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide(
                color: gold.withValues(alpha: 0.88),
                width: 1.6,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: const BorderSide(color: errorColor, width: 1.2),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: const BorderSide(color: errorColor, width: 1.4),
            ),
          ),
        ),
      ],
    );
  }
}

class _PasswordHelperRow extends StatelessWidget {
  const _PasswordHelperRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      key: const ValueKey('signup.password.helper'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          Icons.verified_user_outlined,
          size: 16,
          color: bodyGrey.withValues(alpha: 0.76),
        ),
        const SizedBox(width: 8),
        const Expanded(
          child: Text(
            'Password must be at least 8 characters with letters and numbers',
            style: TextStyle(fontSize: 12, height: 1.4, color: bodyGrey),
          ),
        ),
      ],
    );
  }
}

class _TermsAgreementField extends FormField<bool> {
  _TermsAgreementField({
    super.key,
    required bool agreed,
    required ValueChanged<bool> onChanged,
    required VoidCallback onOpenTerms,
    required VoidCallback onOpenPrivacy,
  }) : super(
         initialValue: agreed,
         validator: (value) {
           if (value != true) {
             return 'You must accept the terms to continue';
           }
           return null;
         },
         builder: (state) {
           return Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
               Row(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   Padding(
                     padding: const EdgeInsets.only(top: 1),
                     child: Checkbox(
                       value: state.value ?? false,
                       onChanged: (value) {
                         final nextValue = value ?? false;
                         state.didChange(nextValue);
                         onChanged(nextValue);
                       },
                       materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                       side: const BorderSide(color: Color(0xFFD5B36C)),
                       activeColor: gold,
                       checkColor: Colors.white,
                       shape: RoundedRectangleBorder(
                         borderRadius: BorderRadius.circular(4),
                       ),
                       visualDensity: const VisualDensity(
                         horizontal: -2,
                         vertical: -2,
                       ),
                     ),
                   ),
                   const SizedBox(width: 10),
                   Expanded(
                     child: Wrap(
                       crossAxisAlignment: WrapCrossAlignment.center,
                       children: [
                         const Text(
                           'I agree to the ',
                           style: TextStyle(
                             fontSize: 13,
                             height: 1.5,
                             color: bodyGrey,
                           ),
                         ),
                         _InlineLink(
                           label: 'Terms of Service',
                           onPressed: onOpenTerms,
                         ),
                         const Text(
                           ' and ',
                           style: TextStyle(
                             fontSize: 13,
                             height: 1.5,
                             color: bodyGrey,
                           ),
                         ),
                         _InlineLink(
                           label: 'Privacy Policy',
                           onPressed: onOpenPrivacy,
                         ),
                       ],
                     ),
                   ),
                 ],
               ),
               if (state.hasError) ...[
                 const SizedBox(height: 4),
                 Padding(
                   padding: const EdgeInsets.only(left: 42),
                   child: Text(
                     state.errorText!,
                     style: const TextStyle(
                       color: Color(0xFFB64A4A),
                       fontSize: 12,
                       height: 1.3,
                     ),
                   ),
                 ),
               ],
             ],
           );
         },
       );
}

class _InlineLink extends StatelessWidget {
  const _InlineLink({required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        foregroundColor: gold,
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          height: 1.5,
        ),
      ),
    );
  }
}

class _FooterSignIn extends StatelessWidget {
  const _FooterSignIn({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      key: const ValueKey('signup.footer.signin'),
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: bodyGrey,
        padding: const EdgeInsets.symmetric(vertical: 8),
      ),
      child: Text.rich(
        const TextSpan(
          style: TextStyle(fontSize: 14, color: bodyGrey),
          children: [
            TextSpan(text: 'Already have an account? '),
            TextSpan(
              text: 'Sign in',
              style: TextStyle(color: gold, fontWeight: FontWeight.w600),
            ),
          ],
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class _HeroGlow extends StatelessWidget {
  const _HeroGlow({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            gold.withValues(alpha: 0.16),
            waveBeige.withValues(alpha: 0.28),
            waveBeige.withValues(alpha: 0),
          ],
          stops: const [0, 0.42, 1],
        ),
      ),
    );
  }
}

class _AuthDivider extends StatelessWidget {
  const _AuthDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Container(height: 1, color: const Color(0xFFE8E0D5))),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'or',
            style: TextStyle(
              fontSize: 13,
              color: bodyGrey.withValues(alpha: 0.8),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(child: Container(height: 1, color: const Color(0xFFE8E0D5))),
      ],
    );
  }
}

class _GoogleMark extends StatelessWidget {
  const _GoogleMark();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size.square(18),
      painter: _GoogleMarkPainter(),
    );
  }
}

class _GoogleMarkPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final strokeWidth = size.width * 0.22;
    final rect = Rect.fromLTWH(
      strokeWidth * 0.35,
      strokeWidth * 0.35,
      size.width - strokeWidth * 0.7,
      size.height - strokeWidth * 0.7,
    );

    void drawArc(Color color, double startAngle, double sweepAngle) {
      canvas.drawArc(
        rect,
        startAngle,
        sweepAngle,
        false,
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth
          ..strokeCap = StrokeCap.round
          ..isAntiAlias = true,
      );
    }

    drawArc(const Color(0xFFEA4335), 2.82, 1.22);
    drawArc(const Color(0xFFFBBC05), 4.06, 1.08);
    drawArc(const Color(0xFF34A853), 5.17, 1.22);
    drawArc(const Color(0xFF4285F4), 0.14, 1.46);

    final barPaint = Paint()
      ..color = const Color(0xFF4285F4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true;

    final centerY = size.height * 0.52;
    canvas.drawLine(
      Offset(size.width * 0.57, centerY),
      Offset(size.width * 0.9, centerY),
      barPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
