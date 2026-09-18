import 'package:flutter/material.dart';
import '../../../core/presentation/widgets/nyaya_widgets.dart';
import 'widgets/get_started_button.dart';

/// The very first screen a new user sees: brand lockup, value proposition,
/// hero illustration, a row of feature highlights and the primary CTA.
class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key, this.onGetStarted});

  final VoidCallback? onGetStarted;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    // Cap the reading width on tablets so the layout doesn't stretch thin.
    final contentWidth = width > 600 ? 600.0 : width;

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
                    padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
                    child: Column(
                      children: [
                        const _WelcomeLockup(),
                        SizedBox(height: contentWidth * 0.06),
                        _Heading(width: contentWidth),
                        const SizedBox(height: 12),
                        _SupportingText(width: contentWidth),
                        SizedBox(height: contentWidth * 0.05),
                        _HeroIllustration(width: contentWidth),
                        SizedBox(height: contentWidth * 0.07),
                        const _FeatureRow(),
                        SizedBox(height: contentWidth * 0.06),
                        GetStartedButton(
                          label: 'Get Started',
                          backgroundColor: navy,
                          onTap: onGetStarted ?? () {},
                          trailing: const Icon(
                            Icons.arrow_forward_rounded,
                            size: 18,
                            color: Colors.white,
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
}

class _WelcomeLockup extends StatelessWidget {
  const _WelcomeLockup();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 72,
          height: 72,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: navy.withValues(alpha: 0.08),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Image.asset(logoAsset, fit: BoxFit.contain),
        ),
        const SizedBox(height: 10),
        Image.asset(wordmarkAsset, width: 160, fit: BoxFit.contain),
        const SizedBox(height: 4),
        const Text(
          'LAW BASIC QUIZ APP',
          style: TextStyle(
            color: gold,
            fontSize: 12,
            fontWeight: FontWeight.bold,
            letterSpacing: 3,
          ),
        ),
      ],
    );
  }
}

class _Heading extends StatelessWidget {
  const _Heading({required this.width});

  final double width;

  @override
  Widget build(BuildContext context) {
    final fontSize = _clamp(width * 0.068, 22, 28);
    return Column(
      children: [
        Text(
          'Law Made Easy,',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.w700,
            color: navy,
            fontFamily: 'Serif',
            letterSpacing: -0.5,
          ),
        ),
        Text(
          'Justice Made Accessible.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.w700,
            color: gold,
            fontFamily: 'Serif',
            letterSpacing: -0.5,
          ),
        ),
      ],
    );
  }
}

class _SupportingText extends StatelessWidget {
  const _SupportingText({required this.width});

  final double width;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: width * 0.04),
      child: const Text(
        'Explore laws, test your knowledge, and become your own legal expert.',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: bodyGrey,
          height: 1.5,
        ),
      ),
    );
  }
}

class _HeroIllustration extends StatelessWidget {
  const _HeroIllustration({required this.width});

  final double width;

  @override
  Widget build(BuildContext context) {
    const heroAsset = 'assets/onboarding/onboarding_1_hero_img.png';
    final imageWidth = width * 0.72;

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Image.asset(
        heroAsset,
        width: imageWidth,
        fit: BoxFit.cover,
      ),
    );
  }
}

class _FeatureRow extends StatelessWidget {
  const _FeatureRow();

  @override
  Widget build(BuildContext context) {
    return const Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: _FeatureItem(
            icon: Icons.menu_book_outlined,
            title: 'Learn Laws',
            description:
                'Explore and understand important laws in simple language.',
          ),
        ),
        SizedBox(width: 8),
        Expanded(
          child: _FeatureItem(
            icon: Icons.shield_outlined,
            title: 'Know Your Rights',
            description:
                'Stay informed and empowered about your legal rights.',
          ),
        ),
        SizedBox(width: 8),
        Expanded(
          child: _FeatureItem(
            icon: Icons.groups_outlined,
            title: 'Track & Stay Updated',
            description:
                'Track case status and get the latest legal updates with ease.',
          ),
        ),
      ],
    );
  }
}

class _FeatureItem extends StatelessWidget {
  const _FeatureItem({
    required this.icon,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: navy.withValues(alpha: 0.08),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: navy, size: 20),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: navy,
            fontFamily: 'Serif',
          ),
        ),
        const SizedBox(height: 4),
        Text(
          description,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w400,
            color: bodyGrey,
            height: 1.3,
          ),
        ),
      ],
    );
  }
}

double _clamp(double value, double min, double max) {
  return value.clamp(min, max).toDouble();
}
