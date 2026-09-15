import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class RecommendationCard extends StatelessWidget {
  const RecommendationCard({
    super.key,
    required this.imagePath,
    required this.titleLine1,
    required this.titleLine2,
    required this.modulesLabel,
    this.rating,
    required this.onTap,
    this.width = 152,
  });

  /// Path to the real legal-visual asset (e.g. `assets/images/rec_constitution.png`).
  final String imagePath;
  final String titleLine1;
  final String titleLine2;
  final String modulesLabel;
  /// Star rating out of 5. Omit when the source data has no rating (the
  /// star row is hidden rather than showing a made-up number).
  final double? rating;
  final VoidCallback onTap;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Semantics(
        button: true,
        label: rating == null
            ? '$titleLine1 $titleLine2, $modulesLabel'
            : '$titleLine1 $titleLine2, $modulesLabel, rated $rating stars',
        child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          width: width,
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.beigeBorder),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                child: Container(
                  height: 96,
                  width: double.infinity,
                  color: AppColors.cardBackground,
                  padding: const EdgeInsets.all(10),
                  child: Image.asset(imagePath, fit: BoxFit.contain),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(titleLine1, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                    Text(titleLine2, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(modulesLabel, style: const TextStyle(fontSize: 11.5, color: AppColors.textSecondary)),
                        if (rating != null) ...[
                          const Spacer(),
                          const Icon(Icons.star, size: 13, color: AppColors.gold),
                          const SizedBox(width: 2),
                          Text('$rating', style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                        ],
                      ],
                    ),
                  ],
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
