import 'package:flutter/material.dart';

import '../../../app/theme/app_tokens.dart';

import '../../../app/theme/app_typography.dart';

import '../../../core/localization/l10n.dart';
import '../../../core/presentation/load_state.dart';
import '../../../core/presentation/show_message.dart';
import '../../../core/presentation/widgets/nyaya_icon.dart';
import '../../../core/presentation/widgets/nyaya_widgets.dart';
import '../../legal_updates/presentation/legal_updates_section.dart';
import '../../legal_updates/presentation/legal_updates_view_model.dart';
import '../../categories/presentation/categories_view_model.dart';
import '../../profile/presentation/profile_view_model.dart';
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
    this.profile,
    this.clock = DateTime.now,
    this.onNotificationsPressed,
    this.onResumePressed,
    this.onViewAllCategoriesPressed,
    this.onViewAllPopularPressed,
    this.onCategorySelected,
    this.onQuizSelected,
    this.onViewAllLegalUpdatesPressed,
    this.onAskNyayaPressed,
  });

  final HomeViewModel viewModel;
  final DailyQuestionsViewModel dailyQuestions;
  final LegalUpdatesViewModel legalUpdates;
  final LearningProgressViewModel progress;

  /// Backend categories; shared with the Categories tab.
  final CategoriesViewModel categories;

  /// The learner's name and streak for the greeting (spec 040); shared
  /// with the Profile tab. Null greets without a name.
  final ProfileViewModel? profile;

  /// The time of day for the greeting.
  final DateTime Function() clock;
  final VoidCallback? onNotificationsPressed;
  final VoidCallback? onResumePressed;
  final VoidCallback? onViewAllCategoriesPressed;
  final VoidCallback? onViewAllPopularPressed;
  final ValueChanged<CategoryData>? onCategorySelected;
  final ValueChanged<PopularQuizData>? onQuizSelected;
  final VoidCallback? onViewAllLegalUpdatesPressed;
  final VoidCallback? onAskNyayaPressed;

  static const pageBackground = NyayaColors.ivory;
  static const heroBackground = NyayaColors.ink;
  static const heroHighlight = NyayaColors.goldBright;
  static const supportText = NyayaColors.inkMuted;
  static const cardBorder = NyayaColors.hairline;
  static const mutedIcon = NyayaColors.inkSubtle;
  static const mediumColor = NyayaDifficulty.medium;
  static const hardColor = NyayaDifficulty.hard;
  static const easyColor = NyayaDifficulty.easy;

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
    widget.profile?.ensureLoaded();
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
              profile: widget.profile,
              clock: widget.clock,
              hasUnreadNotifications: viewModel.hasUnreadNotifications,
              onNotificationsPressed: widget.onNotificationsPressed,
            ),
            const SizedBox(height: 24),
            Text(
              l10n.homeContinueLearning,
              key: const ValueKey('home.section.continue'),
              style: _sectionTitleStyle,
            ),
            const SizedBox(height: 16),
            LearningProgressCard(
              viewModel: widget.progress,
              onResumePressed: _orPlaceholder(
                widget.onResumePressed,
                l10n.commonComingSoon,
              ),
            ),
            const SizedBox(height: 28),
            // Unbuilt features stay hidden until they're wired (spec 035).
            if (widget.onAskNyayaPressed case final onAskNyaya?) ...[
              AskNyayaCard(onPressed: onAskNyaya),
              const SizedBox(height: 28),
            ],
            // Content first: the daily habit sits above browsing (spec 040).
            DailyQuestionsSection(viewModel: widget.dailyQuestions),
            const SizedBox(height: 28),
            // Popular quizzes are sample data; shown once quizzes open.
            if (widget.onQuizSelected case final onQuizSelected?) ...[
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
                  onPressed: () => onQuizSelected(quiz),
                ),
                const SizedBox(height: 16),
              ],
              const SizedBox(height: 12),
            ],
            // One category section, from the backend (spec 040).
            _SectionHeader(
              key: const ValueKey('home.section.explore'),
              actionKey: const ValueKey('home.section.explore.viewAll'),
              title: l10n.homeExploreByCategory,
              actionLabel: l10n.commonViewAll,
              onPressed: _orPlaceholder(
                widget.onViewAllCategoriesPressed,
                l10n.commonComingSoon,
              ),
            ),
            const SizedBox(height: 16),
            RecommendedSection(
              viewModel: widget.categories,
              onCategorySelected: _orPlaceholderWith(
                widget.onCategorySelected,
                (category) => l10n.featureComingSoon(category.label),
              ),
            ),
            const SizedBox(height: 28),
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

/// Section titles sit below the greeting in the hierarchy (spec 040).
const _sectionTitleStyle = TextStyle(
  fontSize: 22,
  fontFamily: NyayaFonts.display,
  fontWeight: FontWeight.w700,
  color: HomePage.heroBackground,
);

/// A compact header: logo, a greeting with the learner's first name, and
/// their streak (spec 040).
class _HeaderRow extends StatelessWidget {
  const _HeaderRow({
    required this.profile,
    required this.clock,
    required this.hasUnreadNotifications,
    required this.onNotificationsPressed,
  });

  final ProfileViewModel? profile;
  final DateTime Function() clock;
  final bool hasUnreadNotifications;

  /// Null hides the bell until notifications exist.
  final VoidCallback? onNotificationsPressed;

  @override
  Widget build(BuildContext context) {
    final profile = this.profile;
    if (profile == null) return _build(context, null);
    return ListenableBuilder(
      listenable: profile,
      builder: (context, _) => _build(context, switch (profile.state) {
        Loaded(:final data) => data,
        _ => null,
      }),
    );
  }

  Widget _build(BuildContext context, ProfileOverview? overview) {
    final streak = overview?.stats.streak ?? 0;
    return Row(
      key: const ValueKey('home.header'),
      children: [
        Image.asset(
          logoAsset,
          width: 40,
          height: 40,
          fit: BoxFit.contain,
          excludeFromSemantics: true,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _Greeting(
            greeting: _greeting(context.l10n, clock()),
            name: _firstName(overview?.profile.fullName),
          ),
        ),
        if (streak > 0) ...[
          const SizedBox(width: 12),
          _StreakChip(days: streak),
        ],
        if (onNotificationsPressed != null) ...[
          const SizedBox(width: 8),
          _NotificationBell(
            hasUnread: hasUnreadNotifications,
            onPressed: onNotificationsPressed!,
          ),
        ],
      ],
    );
  }

  static String _greeting(AppLocalizations l10n, DateTime now) =>
      switch (now.hour) {
        < 12 => l10n.homeGreetingMorning,
        < 17 => l10n.homeGreetingAfternoon,
        _ => l10n.homeGreetingEvening,
      };

  static String? _firstName(String? fullName) {
    final first = fullName?.trim().split(RegExp(r'\s+')).first ?? '';
    return first.isEmpty ? null : first;
  }
}

class _Greeting extends StatelessWidget {
  const _Greeting({required this.greeting, required this.name});

  final String greeting;
  final String? name;

  static const _nameStyle = TextStyle(
    fontSize: 26,
    fontFamily: NyayaFonts.display,
    fontWeight: FontWeight.w700,
    height: 1.15,
    color: HomePage.heroBackground,
  );

  @override
  Widget build(BuildContext context) {
    final name = this.name;
    return Semantics(
      container: true,
      header: true,
      label: name == null ? greeting : '$greeting, $name',
      child: ExcludeSemantics(
        child: name == null
            ? Text(
                greeting,
                key: const ValueKey('home.greeting'),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: _nameStyle,
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    greeting,
                    key: const ValueKey('home.greeting'),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: HomePage.supportText,
                    ),
                  ),
                  Text(
                    name,
                    key: const ValueKey('home.greeting.name'),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: _nameStyle,
                  ),
                ],
              ),
      ),
    );
  }
}

class _StreakChip extends StatelessWidget {
  const _StreakChip({required this.days});

  final int days;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      key: const ValueKey('home.streak'),
      container: true,
      label: context.l10n.homeStreakDays(days),
      child: ExcludeSemantics(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: NyayaColors.goldWash,
            borderRadius: BorderRadius.circular(NyayaRadii.pill),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.local_fire_department_rounded,
                size: 18,
                color: HomePage.heroHighlight,
              ),
              const SizedBox(width: 4),
              Text(
                '$days',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: HomePage.heroBackground,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NotificationBell extends StatelessWidget {
  const _NotificationBell({required this.hasUnread, required this.onPressed});

  final bool hasUnread;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Stack(
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
            onPressed: onPressed,
            tooltip: context.l10n.homeNotifications,
            icon: const Icon(
              Icons.notifications_none_rounded,
              size: 28,
              color: HomePage.heroBackground,
            ),
            splashRadius: 24,
          ),
        ),
        if (hasUnread)
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
        Expanded(child: Text(title, style: _sectionTitleStyle)),
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

class _PopularQuizCard extends StatelessWidget {
  const _PopularQuizCard({required this.quiz, required this.onPressed});

  final PopularQuizData quiz;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    // The shadow sits outside the Material; drawn inside an unfilled Ink it
    // tinted the card grey and clipped to square corners (audit §3.3).
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(NyayaRadii.md),
        boxShadow: NyayaShadows.card,
      ),
      child: Material(
        color: NyayaColors.surface,
        borderRadius: BorderRadius.circular(NyayaRadii.md),
        child: InkWell(
          key: ValueKey('home.quiz.${quiz.id}'),
          onTap: onPressed,
          borderRadius: BorderRadius.circular(NyayaRadii.md),
          child: Ink(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: NyayaColors.surface,
              borderRadius: BorderRadius.circular(NyayaRadii.md),
              border: Border.all(color: HomePage.cardBorder),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 94,
                  height: 94,
                  decoration: BoxDecoration(
                    color: Color(quiz.tileBackgroundHex),
                    borderRadius: BorderRadius.circular(NyayaRadii.md),
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
                      // Full width, so long titles wrap between words
                      // instead of mid-word next to the rating (spec 037).
                      Text(
                        quiz.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: HomePage.heroBackground,
                        ),
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
                          _RatingPill(rating: quiz.rating),
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
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: NyayaColors.goldWash,
        borderRadius: BorderRadius.circular(NyayaRadii.sm),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.star_rounded,
            size: 15,
            color: HomePage.heroHighlight,
          ),
          const SizedBox(width: 4),
          Text(
            rating.toStringAsFixed(1),
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
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
