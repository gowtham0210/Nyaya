import 'package:flutter/material.dart';
import '../../../../core/presentation/widgets/nyaya_widgets.dart';

/// Compact horizontal brand lockup (icon beside wordmark, tagline centered
/// below) used at the top of the login and sign-up screens. Distinct from
/// [BrandLockup], which stacks the icon above the wordmark for splash/welcome.
class AuthHeader extends StatelessWidget {
  const AuthHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final iconSize = _clamp(width * 0.12, 42, 52);
    final wordmarkWidth = _clamp(width * 0.36, 140, 170);

    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: iconSize,
              height: iconSize,
              child: Image.asset(logoAsset, fit: BoxFit.contain),
            ),
            const SizedBox(width: 10),
            SizedBox(
              width: wordmarkWidth,
              child: Image.asset(wordmarkAsset, fit: BoxFit.contain),
            ),
          ],
        ),
        const SizedBox(height: 4),
        const Text(
          'LAW BASIC QUIZ APP',
          style: TextStyle(
            color: gold,
            fontSize: 11,
            fontWeight: FontWeight.bold,
            letterSpacing: 2.2,
          ),
        ),
      ],
    );
  }
}

double _clamp(double value, double min, double max) {
  return value.clamp(min, max).toDouble();
}
