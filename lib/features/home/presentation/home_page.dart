import 'package:flutter/material.dart';

import '../../../core/presentation/motion.dart';
import '../../../core/presentation/widgets/nyaya_widgets.dart';
import '../../quiz_question/data/quiz_api.dart';
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
    this.onDifficultySelected,
    this.quizApi,
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

  /// Called with 'easy' | 'medium' | 'hard' from the Quick Practice cards.
  final ValueChanged<String>? onDifficultySelected;

  /// Overridden in tests; defaults to a real [QuizApi] otherwise.
  final QuizApi? quizApi;

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
      bottomNavigationBar: HomeBottomNavigationBar(
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
            _PracticeStrip(api: quizApi, onSelected: onDifficultySelected),
            _QuestionOfTheDay(api: quizApi),
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
              key: ValueKey(
                'home.continue.${viewModel.continueLearning.progress}',
              ),
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
            for (final (index, quiz) in viewModel.popularQuizzes.indexed) ...[
              FadeSlideIn(
                delay: Motion.stagger * index,
                child: _PopularQuizCard(
                  quiz: quiz,
                  onPressed: () {
                    final callback = onQuizSelected;
                    if (callback != null) {
                      callback(quiz);
                      return;
                    }
                    _showPlaceholder(
                      context,
                      '${quiz.title} is not wired yet.',
                    );
                  },
                ),
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
    // Narrower on small screens so the headline keeps a usable column
    // beside it rather than being squeezed into one word per line.
    final heroArtWidth = (width * (compact ? 0.52 : 0.62))
        .clamp(170.0, 300.0)
        .toDouble();
    final heroTextWidth = width * (compact ? 0.58 : 0.52);
    final leadSize = compact ? 22.0 : 29.0;
    final accentSize = compact ? 23.0 : 30.0;
    final trailSize = compact ? 22.0 : 29.0;
    final supportSize = compact ? 13.0 : 15.0;

    return Container(
      key: const ValueKey('home.hero'),
      // A minimum rather than a fixed height: the headline wraps to more
      // lines on narrow screens and at large text scales, and a hard height
      // would clip it instead of letting the card grow.
      constraints: BoxConstraints(minHeight: heroHeight),
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
            child: LayoutBuilder(
              builder: (context, constraints) {
                // The artwork hangs off the right edge, so only the part of
                // it still inside the card eats into the text column. Sizing
                // the text against that leftover space — rather than a fixed
                // fraction of the screen — is what stops the supporting copy
                // running underneath the scales.
                const artOverhang = 28.0;
                const gutter = 10.0;
                final artInsideCard = heroArtWidth - artOverhang;
                final available = constraints.maxWidth - artInsideCard - gutter;
                final textWidth = available
                    .clamp(constraints.maxWidth * 0.56, heroTextWidth)
                    .toDouble();

                return ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: textWidth),
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
                      const SizedBox(height: 18),
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
                );
              },
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
              child: HomeIcon(
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
    super.key,
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
                      data.canResume
                          ? '${data.answeredCount} of ${data.questionCount} answered'
                          : '${data.questionCount} Questions',
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
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  child: const FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      'Resume',
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
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

    // The ring sweeps round and the label counts up together, so the card
    // reads as filling to the user's score rather than snapping to it. The
    // same tween also animates when the score changes after an attempt.
    return SizedBox(
      width: size,
      height: size,
      child: AnimatedCount(
        value: progress,
        duration: Motion.slow,
        builder: (context, animated) => Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: size,
              height: size,
              child: CircularProgressIndicator(
                key: const ValueKey('home.continue.progress'),
                value: animated,
                strokeWidth: compact ? 6 : 7,
                backgroundColor: const Color(0xFFF0E8DC),
                valueColor: const AlwaysStoppedAnimation<Color>(
                  HomePage.heroHighlight,
                ),
              ),
            ),
            Text(
              '${(animated * 100).round()}%',
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: HomePage.heroBackground,
              ),
            ),
          ],
        ),
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
      child: AnimatedFractionallySizedBox(
        duration: Motion.duration(context, Motion.slow),
        curve: Motion.enter,
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
                child: HomeIcon(
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

class HomeBottomNavigationBar extends StatelessWidget {
  const HomeBottomNavigationBar({
    super.key,
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
                    onTap: () {
                      Motion.tick();
                      onSelected(i);
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// One bottom-nav tab. The active tab's icon sits inside a navy circle
/// that pops upward with a bouncy [Curves.easeOutBack] animation — the
/// circle and the rise are both purely painted via [AnimatedContainer]'s
/// size/transform tweens, so neighbouring tabs and the label never shift.
class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.item,
    required this.isActive,
    required this.onTap,
  });

  final HomeNavItemData item;
  final bool isActive;
  final VoidCallback onTap;

  /// Fixed for both states — only paint (transform/decoration), never
  /// layout size, changes with [isActive]. That's what keeps the label
  /// and neighbouring tabs from ever shifting.
  static const _circleSize = 46.0;
  static const _riseOffset = 18.0;
  static const _popDuration = Duration(milliseconds: 300);

  @override
  Widget build(BuildContext context) {
    final tint = isActive ? HomePage.heroHighlight : HomePage.mutedIcon;

    return InkWell(
      key: ValueKey('home.nav.${item.id}'),
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            key: isActive
                ? ValueKey('home.nav.${item.id}.active')
                : ValueKey('home.nav.${item.id}.inactive'),
            duration: _popDuration,
            curve: Curves.easeOutBack,
            transformAlignment: Alignment.center,
            transform: Matrix4.translationValues(
              0,
              isActive ? -_riseOffset : 0,
              0,
            ),
            width: _circleSize,
            height: _circleSize,
            decoration: BoxDecoration(
              color: isActive ? HomePage.heroBackground : Colors.transparent,
              shape: BoxShape.circle,
              boxShadow: isActive
                  ? [
                      BoxShadow(
                        color: HomePage.heroBackground.withValues(alpha: 0.35),
                        blurRadius: 14,
                        offset: const Offset(0, 6),
                      ),
                    ]
                  : const [],
            ),
            alignment: Alignment.center,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              transitionBuilder: (child, animation) =>
                  ScaleTransition(scale: animation, child: child),
              child: HomeIcon(
                key: ValueKey('home.nav.${item.id}.icon.$isActive'),
                type: item.icon,
                size: isActive ? 22 : 24,
                color: isActive ? HomePage.heroHighlight : HomePage.mutedIcon,
                accentColor: tint,
                filled: isActive,
              ),
            ),
          ),
          const SizedBox(height: 6),
          AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 220),
            style: TextStyle(
              fontSize: 11.5,
              fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
              color: tint,
            ),
            child: Text(
              item.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

class HomeIcon extends StatelessWidget {
  const HomeIcon({
    super.key,
    required this.type,
    required this.size,
    required this.color,
    required this.accentColor,
    this.filled = false,
  });

  final HomeIconType type;
  final double size;
  final Color color;
  final Color accentColor;

  /// Solid variant instead of outlined, for the bottom nav's active tab.
  final bool filled;

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
      case HomeIconType.labor:
        return Icon(Icons.engineering_outlined, size: size, color: color);
      case HomeIconType.taxation:
        return Icon(Icons.currency_rupee_rounded, size: size, color: color);
      case HomeIconType.cyber:
        return Icon(Icons.security_rounded, size: size, color: color);
      case HomeIconType.property:
        return Icon(Icons.apartment_outlined, size: size, color: color);
      case HomeIconType.banking:
        return Icon(
          Icons.account_balance_wallet_outlined,
          size: size,
          color: color,
        );
      case HomeIconType.environmental:
        return Icon(Icons.eco_outlined, size: size, color: color);
      case HomeIconType.navHome:
        return Icon(
          filled ? Icons.home_rounded : Icons.home_outlined,
          size: size,
          color: color,
        );
      case HomeIconType.navQuizzes:
        return Icon(
          filled ? Icons.quiz_rounded : Icons.quiz_outlined,
          size: size,
          color: color,
        );
      case HomeIconType.navLeaderboard:
        return Icon(
          filled ? Icons.emoji_events_rounded : Icons.emoji_events_outlined,
          size: size,
          color: color,
        );
      case HomeIconType.navLegalUpdates:
        return Icon(
          filled ? Icons.campaign_rounded : Icons.campaign_outlined,
          size: size,
          color: color,
        );
      case HomeIconType.navProfile:
        return Icon(
          filled ? Icons.person_rounded : Icons.person_outline_rounded,
          size: size,
          color: color,
        );
    }
  }
}

/// The three difficulty tiers, as the admin configured them, each starting a
/// mixed-topic quiz. A tier the admin turned off simply doesn't appear.
class _PracticeStrip extends StatefulWidget {
  const _PracticeStrip({required this.api, required this.onSelected});

  final QuizApi? api;
  final ValueChanged<String>? onSelected;

  @override
  State<_PracticeStrip> createState() => _PracticeStripState();
}

class _PracticeStripState extends State<_PracticeStrip> {
  late final QuizApi _api = widget.api ?? QuizApi();
  late final Future<List<PracticeSetting>> _future = _api
      .fetchPracticeSettings();

  static const _tints = {
    'easy': HomePage.easyColor,
    'medium': HomePage.mediumColor,
    'hard': HomePage.hardColor,
  };

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<PracticeSetting>>(
      future: _future,
      builder: (context, snapshot) {
        final settings = snapshot.hasError
            ? const <PracticeSetting>[]
            : (snapshot.data ?? const <PracticeSetting>[]);

        if (snapshot.connectionState != ConnectionState.done ||
            settings.isEmpty) {
          // Nothing to show while loading, and nothing to say if the admin
          // has every tier switched off.
          return const SizedBox.shrink();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 30),
            const Text(
              'Quick Practice',
              key: ValueKey('home.section.practice'),
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: HomePage.heroBackground,
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Mixed questions from every topic, at the level you pick.',
              style: TextStyle(fontSize: 13.5, color: HomePage.supportText),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                for (final setting in settings) ...[
                  Expanded(
                    child: _PracticeCard(
                      setting: setting,
                      tint:
                          _tints[setting.difficulty] ?? HomePage.heroHighlight,
                      onTap: widget.onSelected == null
                          ? null
                          : () => widget.onSelected!(setting.difficulty),
                    ),
                  ),
                  if (setting != settings.last) const SizedBox(width: 12),
                ],
              ],
            ),
          ],
        );
      },
    );
  }
}

class _PracticeCard extends StatelessWidget {
  const _PracticeCard({
    required this.setting,
    required this.tint,
    required this.onTap,
  });

  final PracticeSetting setting;
  final Color tint;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final label =
        setting.difficulty[0].toUpperCase() + setting.difficulty.substring(1);

    return Material(
      color: Colors.white,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: HomePage.cardBorder),
      ),
      child: InkWell(
        key: ValueKey('home.practice.${setting.difficulty}'),
        onTap: onTap == null
            ? null
            : () {
                Motion.tick();
                onTap!();
              },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
          child: Column(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: tint.withValues(alpha: 0.14),
                ),
                alignment: Alignment.center,
                child: Icon(Icons.bolt_rounded, size: 20, color: tint),
              ),
              const SizedBox(height: 10),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: HomePage.heroBackground,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '${setting.questionCount} questions',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 11.5,
                  color: HomePage.supportText,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// A few random questions from the backend. Tapping one turns it over to show
/// the answer and its explanation — reading, not playing, so nothing is
/// scored and no credits are spent.
class _QuestionOfTheDay extends StatefulWidget {
  const _QuestionOfTheDay({required this.api});

  final QuizApi? api;

  @override
  State<_QuestionOfTheDay> createState() => _QuestionOfTheDayState();
}

class _QuestionOfTheDayState extends State<_QuestionOfTheDay> {
  late final QuizApi _api = widget.api ?? QuizApi();
  late Future<List<RemoteFlashQuestion>> _future = _load();
  final _revealed = <int>{};

  Future<List<RemoteFlashQuestion>> _load() =>
      _api.fetchRandomQuestions(limit: 3);

  void _shuffle() {
    setState(() {
      _revealed.clear();
      _future = _load();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<RemoteFlashQuestion>>(
      future: _future,
      builder: (context, snapshot) {
        final questions = snapshot.hasError
            ? const <RemoteFlashQuestion>[]
            : (snapshot.data ?? const <RemoteFlashQuestion>[]);

        if (snapshot.connectionState != ConnectionState.done) {
          return const SizedBox.shrink();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 30),
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Test Yourself',
                    key: ValueKey('home.section.testYourself'),
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: HomePage.heroBackground,
                      letterSpacing: -0.3,
                    ),
                  ),
                ),
                TextButton.icon(
                  key: const ValueKey('home.testYourself.shuffle'),
                  onPressed: _shuffle,
                  icon: const Icon(Icons.refresh_rounded, size: 18),
                  label: const Text('Shuffle'),
                  style: TextButton.styleFrom(
                    foregroundColor: HomePage.heroHighlight,
                    textStyle: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              questions.isEmpty
                  ? 'Questions appear here once the server has some.'
                  : 'Tap a question to see the answer.',
              key: const ValueKey('home.testYourself.hint'),
              style: const TextStyle(
                fontSize: 13.5,
                color: HomePage.supportText,
              ),
            ),
            const SizedBox(height: 16),
            for (final question in questions) ...[
              _FlashCard(
                question: question,
                isRevealed: _revealed.contains(question.id),
                onTap: () => setState(() {
                  if (!_revealed.remove(question.id)) {
                    _revealed.add(question.id);
                  }
                }),
              ),
              const SizedBox(height: 12),
            ],
          ],
        );
      },
    );
  }
}

class _FlashCard extends StatelessWidget {
  const _FlashCard({
    required this.question,
    required this.isRevealed,
    required this.onTap,
  });

  final RemoteFlashQuestion question;
  final bool isRevealed;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final answer = question.correctOption >= 0
        ? question.options[question.correctOption]
        : null;
    final explanation = question.explanation?.core ?? '';

    return Material(
      color: Colors.white,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: isRevealed ? HomePage.heroHighlight : HomePage.cardBorder,
        ),
      ),
      child: InkWell(
        key: ValueKey('home.flash.${question.id}'),
        onTap: () {
          Motion.tick();
          onTap();
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      question.questionText,
                      style: const TextStyle(
                        fontSize: 15,
                        height: 1.35,
                        fontWeight: FontWeight.w700,
                        color: HomePage.heroBackground,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Icon(
                    isRevealed
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    color: HomePage.heroHighlight,
                  ),
                ],
              ),
              if (question.quizTitle.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  question.quizTitle,
                  style: const TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                    color: HomePage.supportText,
                  ),
                ),
              ],
              if (isRevealed) ...[
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: HomePage.easyColor.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.check_circle_rounded,
                            size: 18,
                            color: HomePage.easyColor,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              answer ?? 'Answer unavailable.',
                              key: ValueKey('home.flash.${question.id}.answer'),
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                height: 1.3,
                                color: HomePage.heroBackground,
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (explanation.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Text(
                          explanation,
                          style: const TextStyle(
                            fontSize: 13,
                            height: 1.35,
                            color: HomePage.supportText,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
