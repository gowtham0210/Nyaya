import 'package:flutter/material.dart';

import '../../../core/presentation/widgets/nyaya_widgets.dart';
import 'home_view_model.dart';

class HomePage extends StatelessWidget {
  const HomePage({
    super.key,
    required this.viewModel,
    this.onNotificationsPressed,
    this.onStartQuizPressed,
    this.onResumePressed,
    this.onViewAllCategoriesPressed,
    this.onViewAllPopularPressed,
    this.onCategorySelected,
    this.onQuizSelected,
    this.onNavigationSelected,
  });

  final HomeViewModel viewModel;
  final VoidCallback? onNotificationsPressed;
  final VoidCallback? onStartQuizPressed;
  final VoidCallback? onResumePressed;
  final VoidCallback? onViewAllCategoriesPressed;
  final VoidCallback? onViewAllPopularPressed;
  final ValueChanged<HomeCategoryData>? onCategorySelected;
  final ValueChanged<PopularQuizData>? onQuizSelected;
  final ValueChanged<int>? onNavigationSelected;

  static const pageBackground = Color(0xFFF8F6F2);
  static const heroBackground = Color(0xFF11233B);
  static const heroHighlight = Color(0xFFD3A247);
  static const supportText = Color(0xFF5E6878);
  static const cardBorder = Color(0xFFECE5DB);
  static const mutedIcon = Color(0xFF8B95A5);
  static const mediumColor = Color(0xFFD19A2E);
  static const hardColor = Color(0xFFD64545);
  static const easyColor = Color(0xFF1FA35B);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: pageBackground,
      bottomNavigationBar: _HomeBottomNavigationBar(
        items: viewModel.navigationItems,
        activeIndex: viewModel.activeNavigationIndex,
        onSelected: (index) {
          final callback = onNavigationSelected;
          if (callback != null) {
            callback(index);
            return;
          }
          _showPlaceholder(
            context,
            '${viewModel.navigationItems[index].label} coming soon.',
          );
        },
      ),
      body: SafeArea(
        bottom: false,
        child: ListView(
          key: const ValueKey('home.scroll'),
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
          children: [
            _HeaderRow(
              hasUnreadNotifications: viewModel.hasUnreadNotifications,
              onNotificationsPressed: () {
                final callback = onNotificationsPressed;
                if (callback != null) {
                  callback();
                  return;
                }
                _showPlaceholder(context, 'Notifications are not wired yet.');
              },
            ),
            const SizedBox(height: 20),
            _HeroBanner(
              leadLine: viewModel.heroLeadLine,
              accentLine: viewModel.heroAccentLine,
              trailLine: viewModel.heroTrailLine,
              supportingCopy: viewModel.heroSupportingCopy,
              ctaLabel: viewModel.heroCtaLabel,
              onPressed: () {
                final callback = onStartQuizPressed;
                if (callback != null) {
                  callback();
                  return;
                }
                _showPlaceholder(context, 'Quiz entry flow is not wired yet.');
              },
            ),
            const SizedBox(height: 28),
            _SectionHeader(
              key: const ValueKey('home.section.explore'),
              title: 'Explore by Category',
              actionLabel: 'View All',
              onPressed: () {
                final callback = onViewAllCategoriesPressed;
                if (callback != null) {
                  callback();
                  return;
                }
                _showPlaceholder(context, 'Category list is not wired yet.');
              },
            ),
            const SizedBox(height: 16),
            _CategoryStrip(
              categories: viewModel.categories,
              onCategorySelected: (category) {
                final callback = onCategorySelected;
                if (callback != null) {
                  callback(category);
                  return;
                }
                _showPlaceholder(
                  context,
                  '${category.label} is not wired yet.',
                );
              },
            ),
            const SizedBox(height: 30),
            const Text(
              'Continue Learning',
              key: ValueKey('home.section.continue'),
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: heroBackground,
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(height: 16),
            _ContinueLearningCard(
              data: viewModel.continueLearning,
              onResumePressed: () {
                final callback = onResumePressed;
                if (callback != null) {
                  callback();
                  return;
                }
                _showPlaceholder(context, 'Resume flow is not wired yet.');
              },
            ),
            const SizedBox(height: 28),
            _SectionHeader(
              key: const ValueKey('home.section.popular'),
              title: 'Popular Quizzes',
              actionLabel: 'View All',
              onPressed: () {
                final callback = onViewAllPopularPressed;
                if (callback != null) {
                  callback();
                  return;
                }
                _showPlaceholder(
                  context,
                  'Popular quizzes list is not wired yet.',
                );
              },
            ),
            const SizedBox(height: 16),
            for (final quiz in viewModel.popularQuizzes) ...[
              _PopularQuizCard(
                quiz: quiz,
                onPressed: () {
                  final callback = onQuizSelected;
                  if (callback != null) {
                    callback(quiz);
                    return;
                  }
                  _showPlaceholder(context, '${quiz.title} is not wired yet.');
                },
              ),
              const SizedBox(height: 16),
            ],
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  void _showPlaceholder(BuildContext context, String message) {
    final messenger = ScaffoldMessenger.of(context);
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }
}

class _HeaderRow extends StatelessWidget {
  const _HeaderRow({
    required this.hasUnreadNotifications,
    required this.onNotificationsPressed,
  });

  final bool hasUnreadNotifications;
  final VoidCallback onNotificationsPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      key: const ValueKey('home.header'),
      children: [
        const Expanded(child: _HeaderBrand()),
        Stack(
          clipBehavior: Clip.none,
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.78),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: HomePage.heroBackground.withValues(alpha: 0.06),
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: IconButton(
                key: const ValueKey('home.notification.button'),
                onPressed: onNotificationsPressed,
                icon: const Icon(
                  Icons.notifications_none_rounded,
                  size: 28,
                  color: HomePage.heroBackground,
                ),
                splashRadius: 24,
              ),
            ),
            if (hasUnreadNotifications)
              const Positioned(
                key: ValueKey('home.notification.badge'),
                right: 6,
                top: 8,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: HomePage.heroHighlight,
                    shape: BoxShape.circle,
                  ),
                  child: SizedBox(width: 10, height: 10),
                ),
              ),
          ],
        ),
      ],
    );
  }
}

class _HeaderBrand extends StatelessWidget {
  const _HeaderBrand();

  @override
  Widget build(BuildContext context) {
    return Row(
      key: const ValueKey('home.brand'),
      children: [
        Image.asset(
          logoAsset,
          width: 48,
          height: 48,
          fit: BoxFit.contain,
          excludeFromSemantics: true,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FittedBox(
                alignment: Alignment.centerLeft,
                fit: BoxFit.scaleDown,
                child: SizedBox(
                  width: 168,
                  height: 38,
                  child: Image.asset(
                    wordmarkAsset,
                    fit: BoxFit.contain,
                    excludeFromSemantics: true,
                  ),
                ),
              ),
              const SizedBox(height: 2),
              const FittedBox(
                alignment: Alignment.centerLeft,
                fit: BoxFit.scaleDown,
                child: Text(
                  'LAW BASED QUIZ APP',
                  style: TextStyle(
                    color: HomePage.heroHighlight,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.3,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _HeroBanner extends StatelessWidget {
  const _HeroBanner({
    required this.leadLine,
    required this.accentLine,
    required this.trailLine,
    required this.supportingCopy,
    required this.ctaLabel,
    required this.onPressed,
  });

  final String leadLine;
  final String accentLine;
  final String trailLine;
  final String supportingCopy;
  final String ctaLabel;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final compact = width <= 400;
    final heroHeight = (width * (compact ? 0.86 : 0.76))
        .clamp(324.0, 360.0)
        .toDouble();
    final heroArtWidth = (width * (compact ? 0.62 : 0.68))
        .clamp(210.0, 320.0)
        .toDouble();
    final heroTextWidth = width * (compact ? 0.58 : 0.52);
    final leadSize = compact ? 22.0 : 29.0;
    final accentSize = compact ? 23.0 : 30.0;
    final trailSize = compact ? 22.0 : 29.0;
    final supportSize = compact ? 13.0 : 15.0;

    return Container(
      key: const ValueKey('home.hero'),
      height: heroHeight,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [HomePage.heroBackground, Color(0xFF0F2036)],
        ),
        boxShadow: [
          BoxShadow(
            color: HomePage.heroBackground.withValues(alpha: 0.12),
            blurRadius: 28,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -20,
            top: 38,
            child: Opacity(
              opacity: 0.09,
              child: Image.asset(
                'assets/backgrounds/temple_bg.png',
                width: heroArtWidth * 0.72,
                fit: BoxFit.contain,
                excludeFromSemantics: true,
              ),
            ),
          ),
          Positioned(
            right: -28,
            bottom: -8,
            child: Image.asset(
              'assets/onboarding/onboarding_2_hero.png',
              width: heroArtWidth,
              fit: BoxFit.contain,
              excludeFromSemantics: true,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 22, 24, 22),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: heroTextWidth),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    leadLine,
                    key: const ValueKey('home.hero.title.lead'),
                    style: TextStyle(
                      fontSize: leadSize,
                      fontWeight: FontWeight.w700,
                      height: 1.06,
                      color: Colors.white,
                      fontFamily: 'serif',
                      letterSpacing: -0.8,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    accentLine,
                    key: const ValueKey('home.hero.title.accent'),
                    style: TextStyle(
                      fontSize: accentSize,
                      fontWeight: FontWeight.w700,
                      height: 1.06,
                      color: HomePage.heroHighlight,
                      fontFamily: 'serif',
                      letterSpacing: -0.8,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    trailLine,
                    key: const ValueKey('home.hero.title.trail'),
                    style: TextStyle(
                      fontSize: trailSize,
                      fontWeight: FontWeight.w700,
                      height: 1.06,
                      color: Colors.white,
                      fontFamily: 'serif',
                      letterSpacing: -0.8,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    supportingCopy,
                    key: const ValueKey('home.hero.support'),
                    style: TextStyle(
                      fontSize: supportSize,
                      height: 1.45,
                      color: Color(0xFFF2F3F5),
                    ),
                  ),
                  const SizedBox(height: 18),
                  SizedBox(
                    height: compact ? 50 : 56,
                    child: ElevatedButton(
                      key: const ValueKey('home.hero.cta'),
                      onPressed: onPressed,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: HomePage.heroHighlight,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shadowColor: Colors.transparent,
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 30,
                              height: 30,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              alignment: Alignment.center,
                              child: const Padding(
                                padding: EdgeInsets.only(left: 2),
                                child: Icon(
                                  Icons.play_arrow_rounded,
                                  size: 20,
                                  color: HomePage.heroHighlight,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              ctaLabel,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    super.key,
    required this.title,
    required this.actionLabel,
    required this.onPressed,
  });

  final String title;
  final String actionLabel;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: HomePage.heroBackground,
              letterSpacing: -0.3,
            ),
          ),
        ),
        TextButton(
          onPressed: onPressed,
          style: TextButton.styleFrom(
            foregroundColor: HomePage.heroHighlight,
            padding: EdgeInsets.zero,
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                actionLabel,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 4),
              const Icon(Icons.chevron_right_rounded, size: 20),
            ],
          ),
        ),
      ],
    );
  }
}

class _CategoryStrip extends StatelessWidget {
  const _CategoryStrip({
    required this.categories,
    required this.onCategorySelected,
  });

  final List<HomeCategoryData> categories;
  final ValueChanged<HomeCategoryData> onCategorySelected;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (var i = 0; i < categories.length; i++) ...[
            _CategoryTile(
              category: categories[i],
              onTap: () => onCategorySelected(categories[i]),
            ),
            if (i != categories.length - 1) const SizedBox(width: 14),
          ],
        ],
      ),
    );
  }
}

class _CategoryTile extends StatelessWidget {
  const _CategoryTile({required this.category, required this.onTap});

  final HomeCategoryData category;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 108,
      child: InkWell(
        key: ValueKey('home.category.${category.id}'),
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: Column(
          children: [
            Container(
              width: 108,
              height: 96,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.88),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: HomePage.cardBorder),
              ),
              alignment: Alignment.center,
              child: _HomeIcon(
                type: category.icon,
                size: 38,
                color: HomePage.heroBackground,
                accentColor: HomePage.heroHighlight,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              category.label,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: HomePage.heroBackground,
                height: 1.35,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ContinueLearningCard extends StatelessWidget {
  const _ContinueLearningCard({
    required this.data,
    required this.onResumePressed,
  });

  final ContinueLearningData data;
  final VoidCallback onResumePressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const ValueKey('home.continue.card'),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: HomePage.cardBorder),
        boxShadow: [
          BoxShadow(
            color: HomePage.heroBackground.withValues(alpha: 0.06),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 360;

          return Row(
            children: [
              _ProgressRing(progress: data.progress, compact: compact),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.title,
                      key: const ValueKey('home.continue.title'),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: HomePage.heroBackground,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${data.questionCount} Questions',
                      key: const ValueKey('home.continue.meta'),
                      style: const TextStyle(
                        fontSize: 14,
                        color: HomePage.supportText,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _ProgressBar(progress: data.progress),
                  ],
                ),
              ),
              const SizedBox(width: 14),
              SizedBox(
                width: compact ? 92 : 104,
                height: 52,
                child: ElevatedButton(
                  key: const ValueKey('home.continue.resume'),
                  onPressed: onResumePressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: HomePage.heroBackground,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  child: const Text(
                    'Resume',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _ProgressRing extends StatelessWidget {
  const _ProgressRing({required this.progress, required this.compact});

  final double progress;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final size = compact ? 74.0 : 82.0;

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              key: const ValueKey('home.continue.progress'),
              value: progress,
              strokeWidth: compact ? 6 : 7,
              backgroundColor: const Color(0xFFF0E8DC),
              valueColor: const AlwaysStoppedAnimation<Color>(
                HomePage.heroHighlight,
              ),
            ),
          ),
          Text(
            '${(progress * 100).round()}%',
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: HomePage.heroBackground,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProgressBar extends StatelessWidget {
  const _ProgressBar({required this.progress});

  final double progress;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 8,
      decoration: BoxDecoration(
        color: const Color(0xFFF2ECE4),
        borderRadius: BorderRadius.circular(999),
      ),
      clipBehavior: Clip.antiAlias,
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: progress,
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [HomePage.heroHighlight, Color(0xFFC97A28)],
            ),
            borderRadius: BorderRadius.circular(999),
          ),
        ),
      ),
    );
  }
}

class _PopularQuizCard extends StatelessWidget {
  const _PopularQuizCard({required this.quiz, required this.onPressed});

  final PopularQuizData quiz;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        key: ValueKey('home.quiz.${quiz.id}'),
        onTap: onPressed,
        borderRadius: BorderRadius.circular(24),
        child: Ink(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: HomePage.cardBorder),
            boxShadow: [
              BoxShadow(
                color: HomePage.heroBackground.withValues(alpha: 0.05),
                blurRadius: 22,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 94,
                height: 94,
                decoration: BoxDecoration(
                  color: Color(quiz.tileBackgroundHex),
                  borderRadius: BorderRadius.circular(18),
                ),
                alignment: Alignment.center,
                child: _HomeIcon(
                  type: quiz.icon,
                  size: 40,
                  color: Color(quiz.tileForegroundHex),
                  accentColor: Color(quiz.tileForegroundHex),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            quiz.title,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: HomePage.heroBackground,
                              letterSpacing: -0.3,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        _RatingPill(rating: quiz.rating),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(
                          '${quiz.questionCount} Questions',
                          style: const TextStyle(
                            fontSize: 14,
                            color: HomePage.supportText,
                          ),
                        ),
                        const Text(
                          '•',
                          style: TextStyle(
                            color: HomePage.supportText,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          quiz.difficulty.label,
                          key: ValueKey('home.quiz.${quiz.id}.difficulty'),
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: _difficultyColor(quiz.difficulty),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      quiz.description,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        height: 1.45,
                        color: HomePage.heroBackground,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const Padding(
                padding: EdgeInsets.only(top: 28),
                child: Icon(
                  Icons.chevron_right_rounded,
                  color: HomePage.heroBackground,
                  size: 26,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _difficultyColor(QuizDifficulty difficulty) {
    switch (difficulty) {
      case QuizDifficulty.easy:
        return HomePage.easyColor;
      case QuizDifficulty.medium:
        return HomePage.mediumColor;
      case QuizDifficulty.hard:
        return HomePage.hardColor;
    }
  }
}

class _RatingPill extends StatelessWidget {
  const _RatingPill({required this.rating});

  final double rating;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8EE),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.star_rounded,
            size: 18,
            color: HomePage.heroHighlight,
          ),
          const SizedBox(width: 6),
          Text(
            rating.toStringAsFixed(1),
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: HomePage.heroBackground,
            ),
          ),
        ],
      ),
    );
  }
}

class _HomeBottomNavigationBar extends StatelessWidget {
  const _HomeBottomNavigationBar({
    required this.items,
    required this.activeIndex,
    required this.onSelected,
  });

  final List<HomeNavItemData> items;
  final int activeIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const ValueKey('home.bottomNav'),
      decoration: BoxDecoration(
        color: Colors.white,
        border: const Border(top: BorderSide(color: HomePage.cardBorder)),
        boxShadow: [
          BoxShadow(
            color: HomePage.heroBackground.withValues(alpha: 0.06),
            blurRadius: 20,
            offset: const Offset(0, -6),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
          child: Row(
            children: [
              for (var i = 0; i < items.length; i++)
                Expanded(
                  child: _NavItem(
                    item: items[i],
                    isActive: i == activeIndex,
                    onTap: () => onSelected(i),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.item,
    required this.isActive,
    required this.onTap,
  });

  final HomeNavItemData item;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = isActive ? HomePage.heroBackground : HomePage.mutedIcon;

    return InkWell(
      key: ValueKey('home.nav.${item.id}'),
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _HomeIcon(
              type: item.icon,
              size: 24,
              color: color,
              accentColor: color,
            ),
            const SizedBox(height: 6),
            Text(
              item.label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                color: color,
              ),
            ),
            const SizedBox(height: 8),
            AnimatedContainer(
              key: isActive
                  ? ValueKey('home.nav.${item.id}.active')
                  : ValueKey('home.nav.${item.id}.inactive'),
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeOut,
              width: isActive ? 28 : 12,
              height: 3,
              decoration: BoxDecoration(
                color: isActive ? HomePage.heroHighlight : Colors.transparent,
                borderRadius: BorderRadius.circular(999),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeIcon extends StatelessWidget {
  const _HomeIcon({
    required this.type,
    required this.size,
    required this.color,
    required this.accentColor,
  });

  final HomeIconType type;
  final double size;
  final Color color;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case HomeIconType.book:
        return Icon(Icons.menu_book_rounded, size: size, color: color);
      case HomeIconType.gavel:
        return Transform.rotate(
          angle: -0.35,
          child: Icon(Icons.gavel_rounded, size: size, color: color),
        );
      case HomeIconType.scales:
        return Icon(Icons.balance_rounded, size: size, color: color);
      case HomeIconType.document:
        return Stack(
          alignment: Alignment.center,
          children: [
            Icon(Icons.description_outlined, size: size, color: color),
            Positioned(
              right: size * 0.06,
              bottom: size * 0.02,
              child: Icon(
                Icons.edit_outlined,
                size: size * 0.38,
                color: accentColor,
              ),
            ),
          ],
        );
      case HomeIconType.community:
        return Icon(Icons.groups_outlined, size: size, color: color);
      case HomeIconType.temple:
        return Icon(Icons.account_balance_outlined, size: size, color: color);
      case HomeIconType.handcuffs:
        return Icon(Icons.link_rounded, size: size, color: color);
      case HomeIconType.contract:
        return Stack(
          alignment: Alignment.center,
          children: [
            Icon(Icons.article_outlined, size: size, color: color),
            Positioned(
              right: size * 0.04,
              bottom: 0,
              child: Icon(
                Icons.verified_user_outlined,
                size: size * 0.34,
                color: accentColor,
              ),
            ),
          ],
        );
      case HomeIconType.navHome:
        return Icon(Icons.home_rounded, size: size, color: color);
      case HomeIconType.navCategories:
        return Icon(Icons.grid_view_rounded, size: size, color: color);
      case HomeIconType.navLeaderboard:
        return Icon(Icons.emoji_events_outlined, size: size, color: color);
      case HomeIconType.navBookmarks:
        return Icon(Icons.bookmark_border_rounded, size: size, color: color);
      case HomeIconType.navProfile:
        return Icon(Icons.person_outline_rounded, size: size, color: color);
    }
  }
}
