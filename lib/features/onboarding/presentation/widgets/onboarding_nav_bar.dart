import 'package:flutter/material.dart';
import '../../../../core/presentation/widgets/nyaya_widgets.dart';

/// Navigation bar for onboarding screens with SKIP and NEXT buttons.
class OnboardingNavBar extends StatelessWidget {
  const OnboardingNavBar({
    super.key,
    required this.onSkip,
    required this.onNext,
  });

  final VoidCallback onSkip;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: onSkip,
            behavior: HitTestBehavior.opaque,
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
              child: Text(
                'SKIP',
                style: TextStyle(
                  color: navy,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.0,
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: onNext,
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text(
                    'NEXT',
                    style: TextStyle(
                      color: gold,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.0,
                    ),
                  ),
                  SizedBox(width: 4),
                  Icon(
                    Icons.chevron_right,
                    color: gold,
                    size: 18,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
