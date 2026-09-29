import 'package:flutter/material.dart';

import '../../category_detail/data/category_content.dart';
import '../../home/presentation/home_page.dart';
import '../../home/presentation/home_view_model.dart';

/// Home's "Article" tab: every law category as a numbered, read-first
/// list — icon, title, and a one-line summary per topic — rather than the
/// icon grid reached from Home's "View All".
class ArticlesPage extends StatelessWidget {
  const ArticlesPage({
    super.key,
    this.viewModel,
    this.onBackPressed,
    this.onArticleSelected,
    this.onNavigationSelected,
  });

  final HomeViewModel? viewModel;
  final VoidCallback? onBackPressed;
  final ValueChanged<HomeCategoryData>? onArticleSelected;
  final ValueChanged<int>? onNavigationSelected;

  static const _activeNavigationIndex = 1;

  @override
  Widget build(BuildContext context) {
    final resolvedViewModel = viewModel ?? const HomeViewModel();
    final categories = resolvedViewModel.categories;

    return Scaffold(
      backgroundColor: HomePage.pageBackground,
      bottomNavigationBar: HomeBottomNavigationBar(
        items: resolvedViewModel.navigationItems,
        activeIndex: _activeNavigationIndex,
        onSelected: (index) {
          final callback = onNavigationSelected;
          if (callback != null) {
            callback(index);
            return;
          }
          if (index == _activeNavigationIndex) {
            return;
          }
          Navigator.of(context).maybePop();
        },
      ),
      body: SafeArea(
        bottom: false,
        child: ListView(
          key: const ValueKey('articles.scroll'),
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                key: const ValueKey('articles.back'),
                onPressed: () {
                  final callback = onBackPressed;
                  if (callback != null) {
                    callback();
                    return;
                  }
                  Navigator.of(context).maybePop();
                },
                icon: const Icon(
                  Icons.arrow_back_rounded,
                  color: HomePage.heroBackground,
                ),
              ),
            ),
            const _ArticlesHero(),
            const SizedBox(height: 22),
            for (var i = 0; i < categories.length; i++) ...[
              _ArticleRow(
                index: i + 1,
                category: categories[i],
                description: categoryContentFor(categories[i].id).description,
                onTap: () {
                  final callback = onArticleSelected;
                  if (callback != null) {
                    callback(categories[i]);
                    return;
                  }
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                      SnackBar(
                        content: Text(
                          '${categories[i].label} is not wired yet.',
                        ),
                      ),
                    );
                },
              ),
              if (i != categories.length - 1) const SizedBox(height: 12),
            ],
          ],
        ),
      ),
    );
  }
}

class _ArticlesHero extends StatelessWidget {
  const _ArticlesHero();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      key: const ValueKey('articles.hero'),
      builder: (context, constraints) {
        final imageWidth = (constraints.maxWidth * 0.34).clamp(92.0, 136.0);

        return Container(
          padding: const EdgeInsets.fromLTRB(20, 22, 12, 22),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(26),
            border: Border.all(color: HomePage.cardBorder),
            boxShadow: [
              BoxShadow(
                color: HomePage.heroBackground.withValues(alpha: 0.05),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.article_rounded,
                          size: 16,
                          color: HomePage.heroHighlight,
                        ),
                        const SizedBox(width: 6),
                        const Text(
                          'ARTICLES',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.4,
                            color: HomePage.heroHighlight,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Learn. Understand.\nExplore.',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        height: 1.15,
                        color: HomePage.heroBackground,
                        fontFamily: 'serif',
                        letterSpacing: -0.4,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Explore key legal topics in simple language. '
                      'Tap any topic to read more.',
                      style: TextStyle(
                        fontSize: 12.5,
                        height: 1.45,
                        color: HomePage.supportText,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                width: imageWidth,
                child: Image.asset(
                  'assets/onboarding/onboarding_1_hero_img.png',
                  fit: BoxFit.contain,
                  excludeFromSemantics: true,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ArticleRow extends StatelessWidget {
  const _ArticleRow({
    required this.index,
    required this.category,
    required this.description,
    required this.onTap,
  });

  final int index;
  final HomeCategoryData category;
  final String description;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      key: ValueKey('articles.item.${category.id}'),
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: HomePage.cardBorder),
          boxShadow: [
            BoxShadow(
              color: HomePage.heroBackground.withValues(alpha: 0.04),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: HomePage.heroHighlight.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: HomeIcon(
                type: category.icon,
                size: 22,
                color: HomePage.heroHighlight,
                accentColor: HomePage.heroBackground,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$index. ${category.label}',
                    key: ValueKey('articles.item.${category.id}.title'),
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: HomePage.heroBackground,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12.5,
                      height: 1.4,
                      color: HomePage.supportText,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            const Icon(
              Icons.chevron_right_rounded,
              color: HomePage.mutedIcon,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }
}
