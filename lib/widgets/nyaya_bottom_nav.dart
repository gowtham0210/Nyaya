import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class NyayaBottomNav extends StatelessWidget {
  const NyayaBottomNav({super.key, required this.currentIndex, required this.onTap});

  final int currentIndex;
  final ValueChanged<int> onTap;

  static const _leaderboardIndex = 2;

  static const _items = [
    (icon: Icons.home_rounded, label: 'Home'),
    (icon: Icons.edit_document, label: 'Quizzes'),
    (icon: Icons.emoji_events_rounded, label: 'Leaderboard'),
    (icon: Icons.campaign, label: 'Articles'),
    (icon: Icons.person_rounded, label: 'Profile'),
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
            final isLeaderboard = i == _leaderboardIndex;
            final color = selected ? AppColors.navy : AppColors.muted;
            return Expanded(
              child: Semantics(
                button: true,
                selected: selected,
                label: item.label,
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
                              item.label,
                              maxLines: 1,
                              style: TextStyle(
                                fontSize: 12.5,
                                color: color,
                                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                                fontFamily: 'serif',
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
