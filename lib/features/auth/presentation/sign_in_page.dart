import 'package:flutter/material.dart';

import '../../../app/post_sign_up_flow.dart';
import '../../../core/presentation/widgets/nyaya_widgets.dart';
import 'sign_up_page.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final safeArea = MediaQuery.paddingOf(context);
    final keyboardInset = MediaQuery.viewInsetsOf(context).bottom;
    final width = size.width;

    final topSectionHeight = (size.height * 0.38)
        .clamp(310.0, 400.0)
        .toDouble();
    final templeWidth = (width * 0.52).clamp(180.0, 300.0).toDouble();
    final heroWidth = (width * 0.48).clamp(184.0, 270.0).toDouble();
    final dotWidth = (width * 0.18).clamp(58.0, 92.0).toDouble();
    final bottomDotWidth = (width * 0.24).clamp(78.0, 114.0).toDouble();
    final brandScale = width < 360 ? 0.68 : 0.76;
    final welcomeMaxWidth = width * 0.56;

    const templeAsset = 'assets/backgrounds/temple_bg.png';
    const starAsset = 'assets/icons/star.png';
    const heroAsset = 'assets/onboarding/onboarding_2_hero.png';

    return Scaffold(
      backgroundColor: ivory,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              const Positioned.fill(child: BackgroundWave()),
              Positioned(
                key: const ValueKey('signin.temple'),
                right: -28,
                top: 92,
                child: IgnorePointer(
                  child: Opacity(
                    opacity: 0.14,
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
                key: const ValueKey('signin.dots.topLeft'),
                left: 14,
                top: 106,
                child: IgnorePointer(
                  child: Opacity(
                    opacity: 0.18,
                    child: DotPattern(width: dotWidth, height: dotWidth * 0.8),
                  ),
                ),
              ),
              Positioned(
                key: const ValueKey('signin.dots.bottomLeft'),
                left: 12,
                bottom: 94,
                child: IgnorePointer(
                  child: Opacity(
                    opacity: 0.52,
                    child: DotPattern(
                      width: bottomDotWidth,
                      height: bottomDotWidth * 0.78,
                    ),
                  ),
                ),
              ),
              Positioned(
                key: const ValueKey('signin.star.topRight'),
                right: 28,
                top: 148,
                child: IgnorePointer(
                  child: Opacity(
                    opacity: 0.9,
                    child: Image.asset(
                      starAsset,
                      width: 18,
                      excludeFromSemantics: true,
                    ),
                  ),
                ),
              ),
              Positioned(
                key: const ValueKey('signin.star.bottomRight'),
                right: 30,
                bottom: 72,
                child: IgnorePointer(
                  child: Opacity(
                    opacity: 0.96,
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
                  padding: EdgeInsets.fromLTRB(24, 12, 24, 28 + keyboardInset),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight:
                            constraints.maxHeight - safeArea.vertical - 40,
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
                                  left: 0,
                                  top: 0,
                                  child: _TopActionButton(
                                    onPressed: () =>
                                        Navigator.maybePop(context),
                                  ),
                                ),
                                Positioned(
                                  right: -heroWidth * 0.18,
                                  top: 34,
                                  child: _HeroGlow(size: heroWidth * 1.14),
                                ),
                                Positioned(
                                  right: 0,
                                  top: 40,
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
                                  top: 58,
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
                                      maxWidth: welcomeMaxWidth,
                                    ),
                                    child: const _WelcomeCopy(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Transform.translate(
                            offset: const Offset(0, -18),
                            child: _buildSignInCard(context),
                          ),
                          const SizedBox(height: 6),
                          const _TrustBadge(),
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

  Widget _buildSignInCard(BuildContext context) {
    final borderColor = const Color(0xFFE7DFD5);

    return Container(
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Already have an account?',
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
          Text.rich(
            TextSpan(
              style: const TextStyle(
                fontSize: 14,
                height: 1.5,
                color: bodyGrey,
              ),
              children: [
                const TextSpan(text: 'Sign in to continue your '),
                TextSpan(
                  text: 'learning journey',
                  style: TextStyle(
                    color: gold.withValues(alpha: 0.96),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 28),
          AutofillGroup(
            child: Column(
              children: [
                _buildField(
                  label: 'Email / Phone Number',
                  hint: 'Enter your email or phone number',
                  icon: Icons.person_outline_rounded,
                  autofillHints: const [
                    AutofillHints.username,
                    AutofillHints.email,
                    AutofillHints.telephoneNumber,
                  ],
                ),
                const SizedBox(height: 18),
                _buildField(
                  label: 'Password',
                  hint: 'Enter your password',
                  icon: Icons.lock_outline_rounded,
                  obscureText: _obscurePassword,
                  autofillHints: const [AutofillHints.password],
                  textInputAction: TextInputAction.done,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                    ),
                    color: bodyGrey.withValues(alpha: 0.72),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                foregroundColor: gold,
              ),
              child: const Text(
                'Forgot Password?',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
              ),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 56,
            child: ElevatedButton(
              onPressed: () {},
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
                'SIGN IN',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          const _AuthDivider(),
          const SizedBox(height: 24),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFFFFAF4),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: gold.withValues(alpha: 0.18)),
            ),
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'New to Nyaya?',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: navy,
                    fontFamily: 'serif',
                  ),
                ),
                const SizedBox(height: 6),
                Text.rich(
                  TextSpan(
                    style: const TextStyle(
                      fontSize: 13,
                      height: 1.5,
                      color: bodyGrey,
                    ),
                    children: [
                      const TextSpan(text: 'Create an account and start your '),
                      TextSpan(
                        text: 'legal learning journey',
                        style: TextStyle(
                          color: gold.withValues(alpha: 0.96),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 54,
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.person_add_alt_1_rounded, size: 18),
                    label: const Text(
                      'SIGN UP',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.1,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: gold,
                      side: BorderSide(color: borderColor, width: 1.4),
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => SignUpPage(
                            onSignInRequested: (context) {
                              Navigator.of(context).pop();
                            },
                            onSignUpCompleted: startPostSignUpFlow,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildField({
    required String label,
    required String hint,
    required IconData icon,
    Iterable<String>? autofillHints,
    bool obscureText = false,
    TextInputAction textInputAction = TextInputAction.next,
    Widget? suffixIcon,
  }) {
    const borderColor = Color(0xFFE7DFD5);
    const fillColor = Color(0xFFFFFCF8);
    const hintColor = Color(0xFF8A94A6);

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
        TextField(
          obscureText: obscureText,
          autofillHints: autofillHints?.toList(),
          textInputAction: textInputAction,
          cursorColor: navy,
          enableSuggestions: !obscureText,
          autocorrect: !obscureText,
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
          ),
        ),
      ],
    );
  }
}

class _WelcomeCopy extends StatelessWidget {
  const _WelcomeCopy();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Welcome to Nyaya',
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
        const Text(
          'Test your knowledge.',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w400,
            color: bodyGrey,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 4),
        Text.rich(
          TextSpan(
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              height: 1.5,
              color: bodyGrey,
            ),
            children: [
              const TextSpan(text: 'Master '),
              TextSpan(
                text: 'justice.',
                style: TextStyle(
                  color: gold.withValues(alpha: 0.96),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TopActionButton extends StatelessWidget {
  const _TopActionButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.78),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.9)),
        boxShadow: [
          BoxShadow(
            color: navy.withValues(alpha: 0.05),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: const Icon(
          Icons.arrow_back_ios_new_rounded,
          color: navy,
          size: 18,
        ),
        constraints: const BoxConstraints.tightFor(width: 44, height: 44),
        padding: EdgeInsets.zero,
        splashRadius: 22,
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
            gold.withValues(alpha: 0.18),
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
  const _AuthDivider();

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

class _TrustBadge extends StatelessWidget {
  const _TrustBadge();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.74),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: Colors.white.withValues(alpha: 0.88)),
          boxShadow: [
            BoxShadow(
              color: navy.withValues(alpha: 0.04),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.verified_user_outlined, color: bodyGrey, size: 16),
            SizedBox(width: 8),
            Flexible(
              child: Text(
                'Secure & trusted by learners',
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: bodyGrey,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
