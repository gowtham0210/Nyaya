import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class HeroCard extends StatelessWidget {
  const HeroCard({super.key, required this.onStartQuiz, required this.onExploreArticles});

  final VoidCallback onStartQuiz;
  final VoidCallback onExploreArticles;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 208,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: AppColors.beigeBorder,
        border: Border.all(color: AppColors.beigeBorder),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // The whole photo, uncropped — anchored right at the card's edge.
          Align(
            alignment: Alignment.centerRight,
            child: FractionallySizedBox(
              widthFactor: 0.42,
              heightFactor: 0.94,
              child: Image.asset(
                'assets/images/legal_scene.png',
                fit: BoxFit.contain,
                alignment: Alignment.center,
              ),
            ),
          ),
          // Text + buttons fill the full card height so the buttons can sit
          // lower via spaceBetween, instead of hugging the heading.
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(14, 14, 8, 14),
              child: FractionallySizedBox(
                widthFactor: 0.60,
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 10),
                        const Text(
                          'Law Made Easy,',
                          style: TextStyle(
                            color: AppColors.navy,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'serif',
                            height: 1.22,
                          ),
                        ),
                        Text(
                          'Justice Made',
                          style: TextStyle(
                            color: AppColors.gold,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'serif',
                            height: 1.22,
                          ),
                        ),
                        Text(
                          'Accessible.',
                          style: TextStyle(
                            color: AppColors.gold,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'serif',
                            height: 1.22,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Explore laws, test your knowledge, and become your own legal expert.',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 10.5,
                            fontWeight: FontWeight.w500,
                            height: 1.35,
                          ),
                        ),
                      ],
                    ),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: [
                        ElevatedButton(
                          onPressed: onStartQuiz,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.navy,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 8),
                            minimumSize: const Size(0, 34),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),
                            textStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
                            elevation: 0,
                          ),
                          child: const Text('Start a Quiz →'),
                        ),
                        OutlinedButton(
                          onPressed: onExploreArticles,
                          style: OutlinedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: AppColors.navyDark,
                            side: BorderSide(color: AppColors.beigeBorder.withValues(alpha: 1)),
                            padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 8),
                            minimumSize: const Size(0, 34),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),
                            textStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
                          ),
                          child: const Text('Explore Articles'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
