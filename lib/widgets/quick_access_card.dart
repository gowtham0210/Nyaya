import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Fixed card height so all Quick Access cards line up identically
/// regardless of whether their label wraps to one, two, or (for longer
/// translated labels, e.g. Tamil/Kannada) three lines.
const double _cardHeight = 132;
const double _iconContainerSize = 42;
const double _iconSize = 23;
const double _labelAreaHeight = 54;

class QuickAccessCard extends StatelessWidget {
  const QuickAccessCard({
    super.key,
    required this.icon,
    required this.label,
    this.secondLabel,
    this.badgeText,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final String? secondLabel;
  final String? badgeText;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final fullLabel = secondLabel == null ? label : '$label $secondLabel';
    return Material(
      color: Colors.transparent,
      child: Semantics(
        button: true,
        label: badgeText == null ? fullLabel : '$fullLabel, $badgeText',
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Container(
            height: _cardHeight,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
            decoration: BoxDecoration(
              color: AppColors.cardBackground,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.beigeBorder),
            ),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: _iconContainerSize,
                      height: _iconContainerSize,
                      decoration: BoxDecoration(
                        color: AppColors.navy.withValues(alpha: 0.06),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(icon, color: AppColors.navy, size: _iconSize),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: _labelAreaHeight,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              label,
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                            ),
                            if (secondLabel != null)
                              Text(
                                secondLabel!,
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                if (badgeText != null)
                  Positioned(
                    top: -6,
                    right: -6,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.soonRedBg,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        badgeText!,
                        style: const TextStyle(fontSize: 9.5, fontWeight: FontWeight.w700, color: AppColors.soonRed),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
