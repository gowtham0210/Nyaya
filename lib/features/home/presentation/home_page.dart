import 'package:flutter/material.dart';

import '../../../core/localization/l10n.dart';
import '../../../core/presentation/show_message.dart';
import '../../../core/presentation/widgets/nyaya_icon.dart';
import '../../../core/presentation/widgets/nyaya_widgets.dart';
import '../../legal_updates/presentation/legal_updates_section.dart';
import '../../legal_updates/presentation/legal_updates_view_model.dart';
import '../../categories/presentation/categories_view_model.dart';
import 'daily_questions_view_model.dart';
import 'home_view_model.dart';
import 'learning_progress_view_model.dart';
import 'widgets/ask_nyaya_card.dart';
import 'widgets/daily_questions_section.dart';
import 'widgets/learning_progress_card.dart';
import 'widgets/recommended_section.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
    required this.viewModel,
    required this.dailyQuestions,
    required this.legalUpdates,
    required this.progress,
    required this.categories,
    this.onNotificationsPressed,
    this.onStartQuizPressed,
    this.onResumePressed,
    this.onViewAllCategoriesPressed,
    this.onViewAllPopularPressed,
    this.onCategorySelected,
    this.onQuizSelected,
    this.onViewAllLegalUpdatesPressed,
    this.onAskNyayaPressed,
    this.onRecommendedSelected,
    this.onViewAllRecommendedPressed,
    this.onSearchPressed,
  });

  final HomeViewModel viewModel;
  final DailyQuestionsViewModel dailyQuestions;
  final LegalUpdatesViewModel legalUpdates;
  final LearningProgressViewModel progress;

  /// Backend categories for Recommended; shared with the Categories tab.
  final CategoriesViewModel categories;
  final VoidCallback? onNotificationsPressed;
  final VoidCallback? onStartQuizPressed;
  final VoidCallback? onResumePressed;
  final VoidCallback? onViewAllCategoriesPressed;
  final VoidCallback? onViewAllPopularPressed;
  final ValueChanged<HomeCategoryData>? onCategorySelected;
  final ValueChanged<PopularQuizData>? onQuizSelected;
  final VoidCallback? onViewAllLegalUpdatesPressed;
  final VoidCallback? onAskNyayaPressed;
  final ValueChanged<CategoryData>? onRecommendedSelected;
  final VoidCallback? onViewAllRecommendedPressed;
  final VoidCallback? onSearchPressed;

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
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    widget.progress.load();
    widget.dailyQuestions.load();
    widget.categories.ensureLoaded();
    widget.legalUpdates.load();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final viewModel = widget.viewModel;
    return Scaffold(
      backgroundColor: HomePage.pageBackground,
      body: SafeArea(
        bottom: false,
        child: ListView(
          key: const ValueKey('home.scroll'),
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
          children: [
            _HeaderRow(
              hasUnreadNotifications: viewModel.hasUnreadNotifications,
              onNotificationsPressed: _orPlaceholder(
                widget.onNotificationsPressed,
                l10n.featureComingSoon(l10n.homeNotifications),
              ),
            ),
            const SizedBox(height: 16),
            _SearchBar(
              onPressed: _orPlaceholder(
                widget.onSearchPressed,
                l10n.commonComingSoon,
              ),
            ),
            const SizedBox(height: 20),
            _HeroBanner(
              leadLine: l10n.homeHeroLead,
              accentLine: l10n.homeHeroAccent,
              trailLine: l10n.homeHeroTrail,
              supportingCopy: l10n.homeHeroSupport,
              ctaLabel: l10n.homeStartQuiz,
              onPressed: _orPlaceholder(
                widget.onStartQuizPressed,
                l10n.commonComingSoon,
              ),
            ),
            const SizedBox(height: 28),
            _SectionHeader(
              key: const ValueKey('home.section.explore'),
              title: l10n.homeExploreByCategory,
              actionLabel: l10n.commonViewAll,
              onPressed: _orPlaceholder(
                widget.onViewAllCategoriesPressed,
                l10n.commonComingSoon,
              ),
            ),
            const SizedBox(height: 16),
            _CategoryStrip(
              categories: viewModel.categories,
              onCategorySelected: _orPlaceholderWith(
                widget.onCategorySelected,
                (category) => l10n.featureComingSoon(category.label),
              ),
            ),
            const SizedBox(height: 30),
            Text(
              l10n.homeContinueLearning,
              key: const ValueKey('home.section.continue'),
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: HomePage.heroBackground,
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(height: 16),
            LearningProgressCard(
              viewModel: widget.progress,
              onResumePressed: _orPlaceholder(
                widget.onResumePressed,
                l10n.commonComingSoon,
              ),
            ),
            const SizedBox(height: 16),
            AskNyayaCard(
              onPressed: _orPlaceholder(
                widget.onAskNyayaPressed,
                l10n.featureComingSoon(l10n.homeAskNyayaTitle),
              ),
            ),
            const SizedBox(height: 28),
            DailyQuestionsSection(viewModel: widget.dailyQuestions),
            const SizedBox(height: 28),
            _SectionHeader(
              key: const ValueKey('home.section.recommended'),
              actionKey: const ValueKey('home.section.recommended.viewAll'),
              title: l10n.homeRecommended,
              actionLabel: l10n.commonViewAll,
              onPressed: _orPlaceholder(
                widget.onViewAllRecommendedPressed,
                l10n.commonComingSoon,
              ),
            ),
            const SizedBox(height: 16),
            RecommendedSection(
              viewModel: widget.categories,
              onCategorySelected: _orPlaceholderWith(
                widget.onRecommendedSelected,
                (category) => l10n.featureComingSoon(category.label),
              ),
            ),
            const SizedBox(height: 28),
            _SectionHeader(
              key: const ValueKey('home.section.popular'),
              title: l10n.homePopularQuizzes,
              actionLabel: l10n.commonViewAll,
              onPressed: _orPlaceholder(
                widget.onViewAllPopularPressed,
                l10n.commonComingSoon,
              ),
            ),
            const SizedBox(height: 16),
            for (final quiz in viewModel.popularQuizzes) ...[
              _PopularQuizCard(
                quiz: quiz,
                onPressed: () => _orPlaceholderWith<PopularQuizData>(
                  widget.onQuizSelected,
                  (quiz) => l10n.featureComingSoon(quiz.title),
                )(quiz),
              ),
              const SizedBox(height: 16),
            ],
            const SizedBox(height: 12),
            _SectionHeader(
              key: const ValueKey('home.section.legalUpdates'),
              actionKey: const ValueKey('home.section.legalUpdates.viewAll'),
              title: l10n.legalUpdatesTitle,
              actionLabel: l10n.commonViewAll,
              onPressed: _orPlaceholder(
                widget.onViewAllLegalUpdatesPressed,
                l10n.commonComingSoon,
              ),
            ),
            const SizedBox(height: 16),
            LegalUpdatesSection(viewModel: widget.legalUpdates),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  /// [callback], or a snackbar with [message] until the feature is wired.
  VoidCallback _orPlaceholder(VoidCallback? callback, String message) =>
      callback ?? () => showMessage(context, message);

  /// [_orPlaceholder] for callbacks that take the tapped item.
  ValueChanged<T> _orPlaceholderWith<T>(
    ValueChanged<T>? callback,
    String Function(T item) message,
  ) => callback ?? (item) => showMessage(context, message(item));
}

/// Looks like a search field; opens search (spec 033).
class _SearchBar extends StatelessWidget {
  const _SearchBar({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final hint = context.l10n.searchHint;
    return Semantics(
      key: const ValueKey('home.search'),
      button: true,
      label: hint,
      child: Material(
        color: Colors.white,
        shape: const StadiumBorder(
          side: BorderSide(color: HomePage.cardBorder),
        ),
        child: InkWell(
          customBorder: const StadiumBorder(),
          onTap: onPressed,
          child: ExcludeSemantics(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
              child: Row(
                children: [
                  const Icon(Icons.search_rounded, color: HomePage.mutedIcon),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      hint,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 15,
                        color: HomePage.supportText,
                      ),
                    ),
                  ),
                  const Icon(Icons.tune_rounded, color: HomePage.mutedIcon),
                ],
              ),
            ),
          ),
        ),
      ),
    );
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
                tooltip: context.l10n.homeNotifications,
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
              FittedBox(
                alignment: Alignment.centerLeft,
                fit: BoxFit.scaleDown,
                child: Text(
                  context.l10n.brandTagline,
                  style: const TextStyle(
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
      // A minimum, so large text grows the banner instead of overflowing.
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
        fit: StackFit.passthrough,
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
              // Lets the Spacer push the CTA down in a min-height banner.
              child: IntrinsicHeight(
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
    this.actionKey,
  });

  final String title;
  final String actionLabel;
  final VoidCallback onPressed;
  final Key? actionKey;

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
          key: actionKey,
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
              child: NyayaIcon(
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
                child: NyayaIcon(
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
                          context.l10n.questionCount(quiz.questionCount),
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
                          _difficultyLabel(context.l10n, quiz.difficulty),
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

String _difficultyLabel(AppLocalizations l10n, QuizDifficulty difficulty) =>
    switch (difficulty) {
      QuizDifficulty.easy => l10n.difficultyEasy,
      QuizDifficulty.medium => l10n.difficultyMedium,
      QuizDifficulty.hard => l10n.difficultyHard,
    };
