import 'package:flutter/material.dart';

import '../../../app/theme/app_tokens.dart';
import '../../../core/presentation/widgets/nyaya_widgets.dart';
import '../../../app/theme/app_typography.dart';
import 'widgets/get_started_button.dart';
import '../../../core/localization/l10n.dart';

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
                          label: context.l10n.commonGetStarted,
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
            borderRadius: BorderRadius.circular(NyayaRadii.sm),
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
        Text(
          context.l10n.brandTagline,
          style: const TextStyle(
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
    final fontSize = _clamp(width * 0.084, 28, 34);
    return Column(
      children: [
        Text(
          context.l10n.welcomeHeadlineLine1,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.w700,
            color: navy,
            fontFamily: NyayaFonts.display,
            height: 1.1,
          ),
        ),
        Text(
          context.l10n.welcomeHeadlineLine2,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.w700,
            color: gold,
            fontFamily: NyayaFonts.display,
            height: 1.1,
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
      child: Text(
        context.l10n.welcomeBody,
        textAlign: TextAlign.center,
        style: const TextStyle(
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
      borderRadius: BorderRadius.circular(NyayaRadii.md),
      child: Image.asset(heroAsset, width: imageWidth, fit: BoxFit.cover),
    );
  }
}

class _FeatureRow extends StatelessWidget {
  const _FeatureRow();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: _FeatureItem(
            icon: Icons.menu_book_outlined,
            title: l10n.welcomeLearnTitle,
            description: l10n.welcomeLearnBody,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _FeatureItem(
            icon: Icons.shield_outlined,
            title: l10n.welcomeRightsTitle,
            description: l10n.welcomeRightsBody,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _FeatureItem(
            icon: Icons.groups_outlined,
            title: l10n.welcomeTrackTitle,
            description: l10n.welcomeTrackBody,
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
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: navy,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          description,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 12,
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
