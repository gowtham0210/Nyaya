import 'package:flutter/material.dart';

import '../localization/app_strings.dart';
import '../theme/app_colors.dart';

class LearningProgressCard extends StatelessWidget {
  const LearningProgressCard({
    super.key,
    required this.progress,
    required this.lessonsCompleted,
    required this.totalLessons,
    required this.title,
    required this.subtitle,
    required this.lessonsLabel,
    required this.onResume,
  });

  /// Circular ring target, e.g. 0.32 for 32%.
  final double progress;
  final int lessonsCompleted;
  final int totalLessons;
  final String title;
  final String subtitle;
  final String lessonsLabel;
  final VoidCallback onResume;

  @override
  Widget build(BuildContext context) {
    final barTarget = totalLessons == 0 ? 0.0 : lessonsCompleted / totalLessons;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.beigeBorder),
      ),
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.0, end: 1.0),
        duration: const Duration(milliseconds: 1000),
        curve: Curves.easeOutCubic,
        builder: (context, t, _) {
          final circleValue = progress * t;
          final barValue = barTarget * t;
          final percent = (progress * 100 * t).round();
          return Row(
            children: [
              SizedBox(
                width: 52,
                height: 52,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 52,
                      height: 52,
                      child: CircularProgressIndicator(
                        value: circleValue,
                        strokeWidth: 4,
                        backgroundColor: AppColors.beigeBorder,
                        valueColor: const AlwaysStoppedAnimation(AppColors.gold),
                      ),
                    ),
                    Text(
                      '$percent%',
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                    Text(subtitle, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                    const SizedBox(height: 4),
                    Text(lessonsLabel, style: const TextStyle(fontSize: 11.5, color: AppColors.textSecondary)),
                    const SizedBox(height: 6),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: barValue,
                        minHeight: 5,
                        backgroundColor: AppColors.beigeBorder,
                        valueColor: const AlwaysStoppedAnimation(AppColors.gold),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: onResume,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.navy,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                  elevation: 0,
                ),
                child: Text(tr('button_resume')),
              ),
            ],
          );
        },
      ),
    );
  }
}
