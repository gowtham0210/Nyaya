import 'package:flutter/material.dart';

import '../models/article.dart';
import '../theme/app_colors.dart';
import '../theme/app_shadows.dart';

/// One article row in the Articles list: a tappable card showing
/// "N. Title", a short real-description subtitle, and a colored icon
/// badge — opens the full detail screen on tap.
class ArticleAccordionItem extends StatelessWidget {
  const ArticleAccordionItem({
    super.key,
    required this.number,
    required this.article,
    required this.onTap,
  });

  final int number;
  final Article article;
  final VoidCallback onTap;

  static const _badgeColors = [
    AppColors.navy,
    AppColors.goldDark,
    AppColors.navySecondary,
    AppColors.gold,
    AppColors.navyDark,
  ];

  @override
  Widget build(BuildContext context) {
    final badgeColor = _badgeColors[(number - 1) % _badgeColors.length];

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
            decoration: BoxDecoration(
              color: AppColors.beigeBorder,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: badgeColor.withValues(alpha: 0.25)),
              boxShadow: AppShadows.card,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 36,
                  height: 36,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(color: badgeColor, shape: BoxShape.circle),
                  child: const Icon(Icons.account_balance_outlined, color: Colors.white, size: 17),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$number. ${article.title}',
                        style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w800, color: AppColors.navy, height: 1.35),
                      ),
                      if (article.whatItMeans != null && article.whatItMeans!.trim().isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          article.whatItMeans!,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 11.5, color: AppColors.textSecondary, height: 1.35),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Icon(Icons.arrow_forward_ios_rounded, size: 13, color: badgeColor),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
