import 'package:flutter/material.dart';

import '../config/api_config.dart';
import '../localization/app_strings.dart';
import '../repositories/categories_repository.dart';
import '../state/nyaya_tabs.dart';
import '../theme/app_colors.dart';
import '../widgets/recommendation_card.dart';
import '../widgets/recommended_for_you_section.dart';
import 'placeholder_screen.dart';

/// The "View All" page for Recommended for you — every category the
/// backend returned, as a grid, using the same cards as the Home section.
class AllRecommendedScreen extends StatelessWidget {
  const AllRecommendedScreen({super.key, required this.items});

  final List<CategoryRecommendation> items;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        foregroundColor: AppColors.navy,
        title: Text(
          tr('section_recommended_for_you'),
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.navy),
        ),
      ),
      bottomNavigationBar: const GlobalBottomNav(),
      body: SafeArea(
        top: false,
        child: GridView.builder(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            mainAxisExtent: 178,
          ),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final entry = items[index];
            final (line1, line2) = splitCategoryName(entry.category.name);
            return RecommendationCard(
              width: double.infinity,
              imagePath: categoryFallbackImages[entry.category.id % categoryFallbackImages.length],
              imageUrl: entry.category.imageUrl == null ? null : '${ApiConfig.serverOrigin}${entry.category.imageUrl}',
              titleLine1: line1,
              titleLine2: line2,
              modulesLabel: '${entry.moduleCount} ${entry.moduleCount == 1 ? tr('word_module') : tr('word_modules')}',
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => PlaceholderScreen(title: entry.category.name)),
              ),
            );
          },
        ),
      ),
    );
  }
}
