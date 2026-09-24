import 'package:flutter/material.dart';

import '../localization/app_strings.dart';
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
import '../widgets/filter_sheet.dart';
import 'filter_results_screen.dart';
import 'placeholder_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<void> _openFilter(BuildContext context) async {
    final criteria = await showFilterSheet(context, const FilterCriteria());
    if (criteria == null || !context.mounted) return;
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => FilterResultsScreen(criteria: criteria)));
  }

  void _openPlaceholder(BuildContext context, String title, {String? subtitle}) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => PlaceholderScreen(title: title, subtitle: subtitle)),
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
          content: Text('$feature — ${tr('label_coming_soon')}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: NyayaAppBar(onNotificationTap: () => _openPlaceholder(context, tr('label_notifications'))),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
          children: [
            NyayaSearchBar(
              onTap: () => _openPlaceholder(context, tr('label_search')),
              onFilterTap: () => _openFilter(context),
            ),
            const SizedBox(height: 16),
            HeroCard(
              onStartQuiz: () => _openPlaceholder(context, tr('placeholder_quiz_journey')),
              onExploreArticles: () => _openArticles(context),
            ),
            const SizedBox(height: 22),
            _SectionTitle(title: tr('section_continue_learning')),
            const SizedBox(height: 10),
            LearningProgressCard(
              progress: 0.32,
              lessonsCompleted: 5,
              totalLessons: 15,
              title: tr('home_progress_title'),
              subtitle: tr('home_progress_subtitle'),
              lessonsLabel: '5 ${tr('word_of')} 15 ${tr('label_lessons_completed')}',
              onResume: () => _openPlaceholder(context, tr('placeholder_continue_learning')),
            ),
            const SizedBox(height: 22),
            _SectionTitle(title: tr('section_quick_access')),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: QuickAccessCard(
                    icon: Icons.quiz_outlined,
                    label: tr('quick_quizzes_label'),
                    onTap: () => _openPlaceholder(context, tr('nav_quizzes')),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: QuickAccessCard(
                    icon: Icons.description_outlined,
                    label: tr('quick_articles_label'),
                    onTap: () => _openArticles(context),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: QuickAccessCard(
                    icon: Icons.campaign_outlined,
                    label: tr('quick_legal'),
                    secondLabel: tr('quick_updates'),
                    onTap: () => _openPlaceholder(context, tr('placeholder_legal_updates')),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: QuickAccessCard(
                    icon: Icons.gavel_outlined,
                    label: tr('placeholder_case_status'),
                    badgeText: tr('badge_soon'),
                    onTap: () => _showComingSoon(context, tr('placeholder_case_status')),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 22),
            const DailyQuestionsSection(),
            const SizedBox(height: 22),
            const RecommendedForYouSection(),
            const SizedBox(height: 18),
            AskNyayaCard(onTap: () => _showComingSoon(context, tr('ask_nyaya_title'))),
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
