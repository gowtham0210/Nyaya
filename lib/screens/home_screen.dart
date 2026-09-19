import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../widgets/ask_nyaya_card.dart';
import '../widgets/daily_questions_section.dart';
import '../widgets/hero_card.dart';
import '../widgets/learning_progress_card.dart';
import '../widgets/nyaya_app_bar.dart';
import '../widgets/nyaya_search_bar.dart';
import '../widgets/quick_access_card.dart';
import '../widgets/recommended_for_you_section.dart';
import '../state/nyaya_tabs.dart';
import 'placeholder_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _openPlaceholder(BuildContext context, String title, {String? subtitle}) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => PlaceholderScreen(title: title, subtitle: subtitle ?? 'This screen is coming soon.'),
      ),
    );
  }

  void _openArticles(BuildContext context) {
    NyayaTabs.current.value = 3;
  }

  void _showComingSoon(BuildContext context, String feature) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColors.navy,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          content: Text('$feature — Coming Soon', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: NyayaAppBar(onNotificationTap: () => _openPlaceholder(context, 'Notifications')),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
          children: [
            NyayaSearchBar(
              onTap: () => _openPlaceholder(context, 'Search'),
              onFilterTap: () => _openPlaceholder(context, 'Search Filters'),
            ),
            const SizedBox(height: 16),
            HeroCard(
              onStartQuiz: () => _openPlaceholder(context, 'Quiz Journey'),
              onExploreArticles: () => _openArticles(context),
            ),
            const SizedBox(height: 22),
            const _SectionTitle(title: 'Continue Your Learning'),
            const SizedBox(height: 10),
            LearningProgressCard(
              progress: 0.32,
              lessonsCompleted: 5,
              totalLessons: 15,
              title: 'Constitution of India -',
              subtitle: 'Fundamentals',
              lessonsLabel: '5 of 15 Lessons Completed',
              onResume: () => _openPlaceholder(context, 'Continue Learning'),
            ),
            const SizedBox(height: 22),
            const _SectionTitle(title: 'Quick Access'),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: QuickAccessCard(
                    icon: Icons.quiz_outlined,
                    label: 'Quizzes',
                    onTap: () => _openPlaceholder(context, 'Quizzes'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: QuickAccessCard(
                    icon: Icons.description_outlined,
                    label: 'Articles',
                    onTap: () => _openArticles(context),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: QuickAccessCard(
                    icon: Icons.campaign_outlined,
                    label: 'Legal',
                    secondLabel: 'Updates',
                    onTap: () => _openPlaceholder(context, 'Legal Updates'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: QuickAccessCard(
                    icon: Icons.gavel_outlined,
                    label: 'Case Status',
                    badgeText: 'Soon',
                    onTap: () => _showComingSoon(context, 'Case Status'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 22),
            const DailyQuestionsSection(),
            const SizedBox(height: 22),
            const RecommendedForYouSection(),
            const SizedBox(height: 18),
            AskNyayaCard(onTap: () => _showComingSoon(context, 'Ask Nyaya')),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(title, style: const TextStyle(fontSize: 15.5, fontWeight: FontWeight.w700, color: AppColors.textPrimary));
  }
}
