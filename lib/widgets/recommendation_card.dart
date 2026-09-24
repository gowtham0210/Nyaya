import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class RecommendationCard extends StatelessWidget {
  const RecommendationCard({
    super.key,
    required this.imagePath,
    this.imageUrl,
    required this.titleLine1,
    required this.titleLine2,
    required this.modulesLabel,
    this.rating,
    required this.onTap,
    this.width = 152,
  });

  /// Path to the real legal-visual asset (e.g. `assets/images/rec_constitution.png`).
  final String imagePath;

  /// Optional remote cover image; [imagePath] is the fallback if it is absent or fails to load.
  final String? imageUrl;
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
                  child: imageUrl == null
                      ? Image.asset(imagePath, fit: BoxFit.contain)
                      : Image.network(
                          imageUrl!,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) => Image.asset(imagePath, fit: BoxFit.contain),
                        ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _TitleLine(titleLine1),
                    _TitleLine(titleLine2),
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

/// One title line that scales down slightly instead of wrapping, so cards
/// stay the same height whatever the category name or language.
class _TitleLine extends StatelessWidget {
  const _TitleLine(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        alignment: Alignment.centerLeft,
        child: Text(text, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
      ),
    );
  }
}
