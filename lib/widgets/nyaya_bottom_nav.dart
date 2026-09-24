import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../localization/app_strings.dart';
import '../theme/app_colors.dart';

class NyayaBottomNav extends StatelessWidget {
  const NyayaBottomNav({super.key, required this.currentIndex, required this.onTap});

  final int currentIndex;
  final ValueChanged<int> onTap;

  static const _leaderboardIndex = 2;

  static const _items = [
    (icon: Icons.home_rounded, labelKey: 'nav_home'),
    (icon: Icons.edit_document, labelKey: 'nav_quizzes'),
    (icon: Icons.emoji_events_rounded, labelKey: 'nav_leaderboard'),
    (icon: Icons.campaign, labelKey: 'nav_articles'),
    (icon: Icons.person_rounded, labelKey: 'nav_profile'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        border: Border(top: BorderSide(color: AppColors.beigeBorder)),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, -2)),
        ],
      ),
      padding: const EdgeInsets.only(top: 8),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(_items.length, (i) {
            final selected = i == currentIndex;
            final item = _items[i];
            final label = tr(item.labelKey);
            final isLeaderboard = i == _leaderboardIndex;
            final color = selected ? AppColors.navy : AppColors.muted;
            return Expanded(
              child: Semantics(
                button: true,
                selected: selected,
                label: label,
                child: InkWell(
                  onTap: () => onTap(i),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (isLeaderboard)
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: AppColors.navy,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(color: AppColors.navy.withValues(alpha: 0.35), blurRadius: 8, offset: const Offset(0, 3)),
                              ],
                            ),
                            transform: Matrix4.translationValues(0, -15, 0),
                            child: Icon(item.icon, color: AppColors.gold, size: 24),
                          )
                        else
                          Icon(item.icon, color: color, size: 24),
                        Padding(
                          padding: EdgeInsets.only(top: isLeaderboard ? 0 : 3),
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              label,
                              maxLines: 1,
                              style: GoogleFonts.inter(
                                fontSize: 11.5,
                                color: color,
                                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                                letterSpacing: 0.1,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
