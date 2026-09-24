import 'package:flutter/material.dart';

import '../localization/app_strings.dart';
import '../theme/app_colors.dart';

class HeroCard extends StatelessWidget {
  const HeroCard({super.key, required this.onStartQuiz, required this.onExploreArticles});

  final VoidCallback onStartQuiz;
  final VoidCallback onExploreArticles;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: AppColors.beigeBorder,
        border: Border.all(color: AppColors.beigeBorder),
      ),
      clipBehavior: Clip.antiAlias,
      // The card's height comes from its content (via IntrinsicHeight)
      // instead of a fixed number, so it hugs short English text and
      // grows only as much as a longer translation (Tamil/Kannada) needs
      // — no leftover empty space, no overflow either way.
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 6,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(14, 14, 10, 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      tr('hero_line1'),
                      style: const TextStyle(
                        color: AppColors.navy,
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'serif',
                        height: 1.2,
                      ),
                    ),
                    Text(
                      tr('hero_line2'),
                      style: TextStyle(
                        color: AppColors.gold,
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'serif',
                        height: 1.2,
                      ),
                    ),
                    Text(
                      tr('hero_line3'),
                      style: TextStyle(
                        color: AppColors.gold,
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'serif',
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      tr('hero_desc'),
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 10.5,
                        fontWeight: FontWeight.w500,
                        height: 1.35,
                      ),
                    ),
                    const SizedBox(height: 14),
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
                          child: Text(tr('button_start_quiz')),
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
                          child: Text(tr('button_explore_articles')),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(17),
                  bottomRight: Radius.circular(17),
                ),
                child: Image.asset(
                  'assets/images/legal_scene.png',
                  fit: BoxFit.cover,
                  alignment: Alignment.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
