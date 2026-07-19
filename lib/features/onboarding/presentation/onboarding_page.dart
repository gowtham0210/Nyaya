import 'package:flutter/material.dart';
import '../../../core/presentation/widgets/nyaya_widgets.dart';
import '../../auth/presentation/sign_in_page.dart';
import '../../auth/presentation/sign_up_page.dart';
import 'widgets/get_started_button.dart';
import 'widgets/onboarding_nav_bar.dart';
import 'widgets/page_indicator.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() => _currentPage = page);
  }

  void _goToNextPage() {
    if (_currentPage < 3) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    }
  }

  void _skipOnboarding() {
    // TODO: Navigate to home/main app
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final width = size.width;

    const templeAsset = 'assets/backgrounds/temple_bg.png';
    const starAsset = 'assets/icons/star.png';

    return Scaffold(
      backgroundColor: ivory,
      body: SizedBox.expand(
        child: Stack(
          children: [
            // ── Shared background layer ──
            const Positioned.fill(child: BackgroundWave()),
            Positioned(
              key: const ValueKey('onboarding.temple'),
              right: -20,
              top: 120,
              child: IgnorePointer(
                child: Opacity(
                  opacity: 0.15,
                  child: Image.asset(
                    templeAsset,
                    width: width * 0.45,
                    fit: BoxFit.contain,
                    excludeFromSemantics: true,
                  ),
                ),
              ),
            ),
            Positioned(
              key: const ValueKey('onboarding.dots.top'),
              left: 16,
              top: 80,
              child: IgnorePointer(
                child: Opacity(
                  opacity: 0.15,
                  child: DotPattern(width: width * 0.14, height: width * 0.11),
                ),
              ),
            ),
            Positioned(
              key: const ValueKey('onboarding.star.top'),
              right: 20,
              top: 120,
              child: IgnorePointer(
                child: Opacity(
                  opacity: 0.95,
                  child: Image.asset(
                    starAsset,
                    width: _clamp(width * 0.05, 18, 22),
                    excludeFromSemantics: true,
                  ),
                ),
              ),
            ),
            Positioned(
              key: const ValueKey('onboarding.star.bottom'),
              right: 20,
              bottom: 140,
              child: IgnorePointer(
                child: Opacity(
                  opacity: 0.94,
                  child: Image.asset(
                    starAsset,
                    width: _clamp(width * 0.06, 18, 22),
                    excludeFromSemantics: true,
                  ),
                ),
              ),
            ),

            // ── PageView with onboarding screens ──
            PageView(
              controller: _pageController,
              onPageChanged: _onPageChanged,
              children: [
                _buildScreen1(context, width),
                _buildScreen2(context, width),
                _buildScreen3(context, width),
              ],
            ),

            // ── Bottom controls (shared across pages) ──
            Positioned(
              left: 24,
              right: 24,
              bottom: 0,
              child: SafeArea(
                top: false,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Show nav bar only on the second page (index 1)
                    if (_currentPage == 1)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: OnboardingNavBar(
                          onSkip: _skipOnboarding,
                          onNext: _goToNextPage,
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 80),
                      child: PageIndicator(
                        count: 4,
                        currentIndex: _currentPage,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  // Screen 1: Brand lockup + illustration + heading
  // ─────────────────────────────────────────────
  Widget _buildScreen1(BuildContext context, double width) {
    const onboardingIllustration =
        'assets/onboarding/onboarding_1_hero_img.png';

    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 180),
              child: Transform.scale(scale: 0.9, child: const BrandLockup()),
            ),
            const SizedBox(height: 16),
            Expanded(
              flex: 3,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: width * 1.0,
                    height: width * 1.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          waveBeige.withValues(alpha: 0.4),
                          waveBeige.withValues(alpha: 0),
                        ],
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Image.asset(
                      onboardingIllustration,
                      width: width * 0.99,
                      fit: BoxFit.contain,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Column(
              children: [
                const Text(
                  'Test Your Knowledge.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1F2A37),
                    fontFamily: 'Serif',
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Master Justice.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: gold,
                    fontFamily: 'Serif',
                  ),
                ),
              ],
            ),
            // Reserve space for bottom controls
            const SizedBox(height: 140),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  // Screen 2: Illustration + heading + divider + body text
  // ─────────────────────────────────────────────
  Widget _buildScreen2(BuildContext context, double width) {
    const onboarding2Illustration = 'assets/onboarding/onboarding_2_hero.png';

    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            // ── Hero illustration (no brand lockup) ──
            const SizedBox(height: 20),
            Expanded(
              flex: 5,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: width * 0.9,
                    height: width * 0.9,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          waveBeige.withValues(alpha: 0.35),
                          waveBeige.withValues(alpha: 0),
                        ],
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Image.asset(
                      onboarding2Illustration,
                      width: width * 0.88,
                      fit: BoxFit.contain,
                    ),
                  ),
                ],
              ),
            ),

            // ── Heading ──
            const SizedBox(height: 16),
            const Text(
              'Learn. Understand.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: navy,
                fontFamily: 'Serif',
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Apply Law.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: gold,
                fontFamily: 'Serif',
              ),
            ),

            // ── Content divider with outlined diamond ──
            const SizedBox(height: 12),
            SizedBox(width: width * 0.6, child: const ContentDivider()),

            // ── Body text ──
            const SizedBox(height: 12),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 0.05),
              child: const Text(
                'Nyaya makes legal learning simple with case-based quizzes, real-life scenarios and expertly crafted content.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: bodyGrey,
                  height: 1.5,
                ),
              ),
            ),

            // Reserve space for bottom controls (nav bar + indicator)
            const SizedBox(height: 160),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  // Screen 3: Gamification dashboard + CTA
  // ─────────────────────────────────────────────
  Widget _buildScreen3(BuildContext context, double width) {
    const onboarding3Illustration = 'assets/onboarding/onboarding_3_hero.png';

    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            // ── Hero illustration ──
            const SizedBox(height: 20),
            Expanded(
              flex: 5,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: width * 0.9,
                    height: width * 0.9,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          waveBeige.withValues(alpha: 0.35),
                          waveBeige.withValues(alpha: 0),
                        ],
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Image.asset(
                      onboarding3Illustration,
                      width: width * 0.88,
                      fit: BoxFit.contain,
                    ),
                  ),
                ],
              ),
            ),

            // ── Heading ──
            const SizedBox(height: 16),
            const Text(
              'Track Progress.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: navy,
                fontFamily: 'Serif',
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Achieve Excellence.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: gold,
                fontFamily: 'Serif',
              ),
            ),

            // ── Content divider with outlined diamond ──
            const SizedBox(height: 12),
            SizedBox(width: width * 0.6, child: const ContentDivider()),

            // ── Body text ──
            const SizedBox(height: 12),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 0.05),
              child: const Text(
                'Track your performance, build streaks, earn badges and become the best version of your legal knowledge.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: bodyGrey,
                  height: 1.5,
                ),
              ),
            ),

            // ── CTA Button ──
            const SizedBox(height: 20),
            GetStartedButton(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => SignUpPage(
                      onSignInRequested: (signUpContext) {
                        Navigator.of(signUpContext).pushReplacement(
                          MaterialPageRoute<void>(
                            builder: (_) => const SignInPage(),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),

            // ── Sign in Link ──
            const SizedBox(height: 12),
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(builder: (_) => const SignInPage()),
                );
              },
              behavior: HitTestBehavior.opaque,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: const TextSpan(
                    style: TextStyle(
                      fontFamily: 'Roboto', // Or whatever default sans-serif is
                      fontSize: 13,
                    ),
                    children: [
                      TextSpan(
                        text: 'Already have an account? ',
                        style: TextStyle(
                          color: bodyGrey,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      TextSpan(
                        text: 'Sign in',
                        style: TextStyle(
                          color: gold,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Reserve space for bottom indicator
            const SizedBox(height: 110),
          ],
        ),
      ),
    );
  }
}

double _clamp(double value, double min, double max) {
  return value.clamp(min, max).toDouble();
}
