import 'package:flutter/material.dart';

import '../models/article.dart';
import '../state/nyaya_tabs.dart';
import '../theme/app_colors.dart';
import '../theme/app_shadows.dart';

/// Full-screen article detail — opened when an article is tapped in the
/// Articles list. Numbered header with a chevron, then What/Why/Key
/// Features sections, all populated from real backend data (no fabricated
/// content).
class ArticleDetailScreen extends StatelessWidget {
  const ArticleDetailScreen({super.key, required this.number, required this.article});

  final int number;
  final Article article;

  static const _goldDark = Color(0xFFB9823A);
  static const _navySecondary = Color(0xFF667183);

  @override
  Widget build(BuildContext context) {
    final whatItMeans = article.whatItMeans;
    final whyItMatters = article.whyItMatters;
    final keyFeatures = article.keyFeatures;
    final features = (keyFeatures == null || keyFeatures.trim().isEmpty)
        ? const <String>[]
        : keyFeatures.split(RegExp(r';\s*')).where((f) => f.trim().isNotEmpty).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        foregroundColor: AppColors.navy,
        title: Text(
          'Part ${article.part} · ${article.partTitle}',
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.navy),
        ),
      ),
      bottomNavigationBar: const GlobalBottomNav(),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          children: [
            // Header — numbered title with a chevron, plus the real
            // article-range chip (no duplicate of the title below it).
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              decoration: BoxDecoration(
                color: AppColors.cardBackground,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.gold, width: 1.4),
                boxShadow: AppShadows.highlighted,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(color: AppColors.navy, shape: BoxShape.circle),
                    child: const Icon(Icons.account_balance_outlined, color: Colors.white, size: 17),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$number. ${article.title}',
                          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.navy, height: 1.35),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.gold.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: AppColors.gold.withValues(alpha: 0.4)),
                          ),
                          child: Text(
                            article.articleRange,
                            style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700, color: _goldDark),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.gold, size: 22),
                ],
              ),
            ),
            const SizedBox(height: 12),
            if (whatItMeans != null && whatItMeans.trim().isNotEmpty)
              _SectionCard(
                icon: Icons.lightbulb_outline,
                iconColor: AppColors.navy,
                heading: 'What are ${article.title}?',
                child: Text(whatItMeans, style: const TextStyle(fontSize: 12.5, color: AppColors.textPrimary, height: 1.5)),
              ),
            if (whyItMatters != null && whyItMatters.trim().isNotEmpty) ...[
              const SizedBox(height: 12),
              _SectionCard(
                icon: Icons.balance_outlined,
                iconColor: _goldDark,
                heading: 'Why are they important?',
                child: Text(whyItMatters, style: const TextStyle(fontSize: 12.5, color: AppColors.textPrimary, height: 1.5)),
              ),
            ],
            if (features.isNotEmpty) ...[
              const SizedBox(height: 12),
              _SectionCard(
                icon: Icons.checklist_rounded,
                iconColor: _navySecondary,
                heading: 'Key Features',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (var i = 0; i < features.length; i++)
                      Padding(
                        padding: EdgeInsets.only(bottom: i == features.length - 1 ? 0 : 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 20,
                              height: 20,
                              margin: const EdgeInsets.only(top: 1),
                              alignment: Alignment.center,
                              decoration: const BoxDecoration(color: AppColors.navy, shape: BoxShape.circle),
                              child: Text('${i + 1}', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Colors.white)),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(features[i], style: const TextStyle(fontSize: 12.5, color: AppColors.textPrimary, height: 1.5)),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.icon, required this.iconColor, required this.heading, required this.child});

  final IconData icon;
  final Color iconColor;
  final String heading;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.beigeBorder),
        boxShadow: AppShadows.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 28,
                height: 28,
                alignment: Alignment.center,
                decoration: BoxDecoration(color: iconColor.withValues(alpha: 0.12), shape: BoxShape.circle),
                child: Icon(icon, size: 15, color: iconColor),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(heading, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.navy)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }
}
