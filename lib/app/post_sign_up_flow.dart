import 'package:flutter/material.dart';

import '../core/presentation/motion.dart';
import '../core/presentation/widgets/nyaya_widgets.dart';
import '../features/categories/data/quiz_levels.dart';
import '../features/categories/presentation/categories_page.dart';
import '../features/category_detail/presentation/category_detail_page.dart';
import '../features/goal_selection/presentation/goal_selection_page.dart';
import '../features/home/presentation/home_page.dart';
import '../features/home/presentation/home_view_model.dart';
import '../features/leaderboard/presentation/leaderboard_journey.dart';
import '../features/leaderboard/presentation/journey_page.dart';
import '../features/leaderboard/presentation/journey_widgets.dart';
import '../features/leaderboard/presentation/leaderboard_page.dart';
import '../features/leaderboard/presentation/leaderboard_view_model.dart';
import '../features/notifications/presentation/notifications_page.dart';
import '../features/profile/presentation/profile_page.dart';
import '../features/profile/presentation/profile_view_model.dart';
import '../features/quiz_question/data/banking_financial_law_quiz_data.dart';
import '../features/quiz_question/data/civil_law_quiz_data.dart';
import '../features/quiz_question/data/constitutional_law_quiz_data.dart';
import '../features/quiz_question/data/contract_act_quiz_data.dart';
import '../features/quiz_question/data/continue_learning_quiz_data.dart';
import '../features/quiz_question/data/corporate_commercial_law_quiz_data.dart';
import '../features/quiz_question/data/criminal_law_quiz_data.dart';
import '../features/quiz_question/data/cyber_ip_law_quiz_data.dart';
import '../features/quiz_question/data/demo_pool_quiz_data.dart';
import '../features/quiz_question/data/environmental_law_quiz_data.dart';
import '../features/quiz_question/data/fundamental_rights_quiz_data.dart';
import '../features/quiz_question/data/indian_penal_code_quiz_data.dart';
import '../features/quiz_question/data/labor_industrial_law_quiz_data.dart';
import '../features/quiz_question/data/marriage_family_law_quiz_data.dart';
import '../features/quiz_question/data/property_real_estate_law_quiz_data.dart';
import '../features/quiz_question/data/quiz_api.dart';
import '../features/quiz_question/data/taxation_law_quiz_data.dart';
import '../features/quiz_question/presentation/quiz_question_page.dart';
import '../features/quiz_question/presentation/quiz_session_view_model.dart';
import '../features/quiz_result/presentation/quiz_result_page.dart';
import '../features/quiz_result/presentation/quiz_review_page.dart';
import '../features/quiz_result/presentation/quiz_result_view_model.dart';
import 'app_session.dart';
import 'leaderboard_progress_store.dart';
import 'notifications_store.dart';
import 'quiz_catalog.dart';
import 'quiz_history_store.dart';
import 'quiz_progress_store.dart';
import 'user_stats_store.dart';

/// Resolves quizzes against the backend, falling back to the bundled
/// question lists imported above when it can't be reached.
final _catalog = QuizCatalog();

/// The home page with its app-level wiring, shared by the post-sign-up
/// flow and the returning-user path.
Widget buildWiredHomePage(BuildContext context) => const _WiredHomePage();

/// Wraps [HomePage] so Continue Learning's state can be re-read from the
/// backend every time Home is shown. The flow rebuilds Home from scratch
/// after a quiz rather than popping back to it, so this runs after every
/// attempt as well as on first load.
class _WiredHomePage extends StatefulWidget {
  const _WiredHomePage();

  @override
  State<_WiredHomePage> createState() => _WiredHomePageState();
}

class _WiredHomePageState extends State<_WiredHomePage> {
  @override
  void initState() {
    super.initState();
    _refreshContinueLearning();
  }

  Future<void> _refreshContinueLearning() async {
    await QuizProgressStore.refresh();
    if (mounted) {
      setState(() {});
    }
  }

  /// Runs a quiz entry point and re-reads the card once it returns.
  ///
  /// Leaving a quiz through its close button pops back to this very Home
  /// instance rather than building a new one, so without this the card would
  /// still show whatever it showed before the attempt.
  Future<void> _thenRefresh(Future<void> Function() start) async {
    await start();
    await _refreshContinueLearning();
  }

  @override
  Widget build(BuildContext context) {
    return HomePage(
      viewModel: const HomeViewModel(),
      // The banner's Start Quiz leads into the level-wise journey (the
      // Quizzes page opens on its Levels tab by default).
      onStartQuizPressed: () => _openCategories(context),
      onDifficultySelected: (difficulty) =>
          _thenRefresh(() => _handleDifficultySelected(context, difficulty)),
      onResumePressed: () =>
          _thenRefresh(() => _startContinueLearningQuiz(context)),
      onCategorySelected: (category) =>
          _thenRefresh(() => _handleCategorySelected(context, category)),
      onViewAllCategoriesPressed: () =>
          _openCategories(context, showCategories: true),
      onNavigationSelected: (index) => _handleHomeNavigation(context, index),
      onQuizSelected: (quiz) =>
          _thenRefresh(() => _handlePopularQuizSelected(context, quiz)),
      onNotificationsPressed: () => _openNotifications(context),
    );
  }
}

/// A quiz the app ships questions for, paired with the slug it is seeded
/// under in the backend catalogue. The bundled list is the offline fallback;
/// the slug is what the backend copy is looked up by.
class _BundledQuiz {
  const _BundledQuiz({
    required this.slug,
    required this.title,
    required this.questions,
  });

  final String slug;
  final String title;
  final List<QuizQuestion> questions;
}

/// Fetches the signed-in user's backend stats and rebuilds [builder] with
/// them, in the same shape [_WiredHomePage] uses for the Continue Learning
/// card.
///
/// The first frame is built with whatever was last loaded this session
/// (null on a cold start), so the screen renders immediately from local
/// history and swaps to server numbers when they land. A failed load leaves
/// the local view in place rather than showing an error.
class _LiveStats extends StatefulWidget {
  const _LiveStats({required this.builder});

  final Widget Function(UserStats? stats) builder;

  @override
  State<_LiveStats> createState() => _LiveStatsState();
}

class _LiveStatsState extends State<_LiveStats> {
  UserStats? _stats = UserStatsStore.latest;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final stats = await UserStatsStore.refresh();
    if (mounted && stats != null) {
      setState(() => _stats = stats);
    }
  }

  @override
  Widget build(BuildContext context) => widget.builder(_stats);
}

/// Fetches the backend's pool of quizzes for the Leaderboard journey —
/// everything in the catalogue outside [_reservedQuizSlugs] — and lays it
/// out against [LeaderboardProgressStore]'s local progress and credits.
///
/// Signed out or unreachable both resolve to an empty pool rather than an
/// error, same as every other backend read in this flow: the screen just
/// shows nothing to play yet instead of failing.
class _LiveJourney extends StatefulWidget {
  const _LiveJourney({required this.builder});

  final Widget Function(
    LeaderboardJourney journey,
    int credits,
    VoidCallback refresh,
  )
  builder;

  @override
  State<_LiveJourney> createState() => _LiveJourneyState();
}

class _LiveJourneyState extends State<_LiveJourney> {
  LeaderboardJourney _journey = const LeaderboardJourney(stops: []);

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    await LeaderboardProgressStore.refreshRegen();

    var pool = const <RemoteQuiz>[];
    // Which pool quizzes are done — the backend's record of submitted
    // attempts, never a local flag, so it can't be forged by editing
    // on-device state.
    var completedSlugs = const <String>{};
    if (AppSession.accessToken != null) {
      try {
        final quizApi = QuizApi();
        final catalogue = await quizApi.fetchQuizzes();
        pool = [
          for (final quiz in catalogue)
            // The level-wise quizzes have their own home on the Levels tab.
            if (!_reservedQuizSlugs.contains(quiz.slug) &&
                levelNumberOf(quiz) == null)
              quiz,
        ]..sort((a, b) => a.id.compareTo(b.id));

        final attempts = await quizApi.fetchAttempts(limit: 100);
        final submittedQuizIds = {
          for (final attempt in attempts)
            if (attempt.status == 'submitted') attempt.quizId,
        };
        completedSlugs = {
          for (final quiz in pool)
            if (submittedQuizIds.contains(quiz.id)) quiz.slug,
        };
      } on Object {
        pool = const [];
      }
    }

    // No server reachable, or nothing seeded for the journey yet: fall
    // back to the local demo quizzes so there's still something to play.
    if (pool.isEmpty) {
      pool = [
        for (final (index, entry) in _demoPoolQuizzes.entries.indexed)
          RemoteQuiz(
            id: -(index + 1),
            slug: entry.key,
            title: entry.value.title,
            totalQuestions: entry.value.questions.length,
          ),
      ];
    }

    if (!mounted) {
      return;
    }
    setState(() {
      _journey = LeaderboardJourney.build(
        pool: pool,
        completedSlugs: completedSlugs,
        openedChests: LeaderboardProgressStore.openedChests,
      );
    });
  }

  @override
  Widget build(BuildContext context) =>
      widget.builder(_journey, LeaderboardProgressStore.credits, _load);
}

/// Pushes the notifications feed, reached from Home's bell icon. Popping
/// back replaces Home with a fresh instance so its unread badge — just
/// cleared by opening this page — reflects that immediately, the same
/// trick [_startQuiz] uses for Continue Learning's progress.
void _openNotifications(BuildContext context) {
  Navigator.of(context).push(
    FadeThroughPageRoute<void>(
      builder: (notificationsContext) => NotificationsPage(
        onBackPressed: () => Navigator.of(notificationsContext).pushReplacement(
          FadeThroughPageRoute<void>(builder: buildWiredHomePage),
        ),
      ),
    ),
  );
}

/// The quizzes behind Home's "Popular Quizzes" cards, keyed by card id —
/// which is already the backend slug.
final _popularQuizzes = <String, _BundledQuiz>{
  'fundamental-rights-quiz': _BundledQuiz(
    slug: 'fundamental-rights-quiz',
    title: 'Fundamental Rights Quiz',
    questions: fundamentalRightsQuizQuestions,
  ),
  'indian-penal-code-quiz': _BundledQuiz(
    slug: 'indian-penal-code-quiz',
    title: 'Indian Penal Code Quiz',
    questions: indianPenalCodeQuizQuestions,
  ),
  'contract-act-quiz': _BundledQuiz(
    slug: 'contract-act-quiz',
    title: 'Contract Act Quiz',
    questions: contractActQuizQuestions,
  ),
};

/// The quizzes behind the category grid, keyed by category id.
final _categoryQuizzes = <String, _BundledQuiz>{
  'constitutional_law': _BundledQuiz(
    slug: 'constitutional-law-quiz',
    title: 'Constitutional Law Quiz',
    questions: constitutionalLawQuizQuestions,
  ),
  'criminal_evidence_law': _BundledQuiz(
    slug: 'criminal-law-quiz',
    title: 'Criminal Law Quiz',
    questions: criminalLawQuizQuestions,
  ),
  'civil_general_law': _BundledQuiz(
    slug: 'civil-general-law-quiz',
    title: 'Civil & General Law Quiz',
    questions: civilLawQuizQuestions,
  ),
  'labor_industrial_law': _BundledQuiz(
    slug: 'labor-industrial-law-quiz',
    title: 'Labor & Industrial Law Quiz',
    questions: laborIndustrialLawQuizQuestions,
  ),
  'marriage_family_law': _BundledQuiz(
    slug: 'marriage-family-law-quiz',
    title: 'Marriage & Family Law Quiz',
    questions: marriageFamilyLawQuizQuestions,
  ),
  'taxation_law': _BundledQuiz(
    slug: 'taxation-law-quiz',
    title: 'Taxation Law Quiz',
    questions: taxationLawQuizQuestions,
  ),
  'cyber_intellectual_property': _BundledQuiz(
    slug: 'cyber-intellectual-property-quiz',
    title: 'Cyber & Intellectual Property Quiz',
    questions: cyberIpLawQuizQuestions,
  ),
  'property_real_estate': _BundledQuiz(
    slug: 'property-real-estate-quiz',
    title: 'Property & Real Estate Quiz',
    questions: propertyRealEstateLawQuizQuestions,
  ),
  'banking_financial_law': _BundledQuiz(
    slug: 'banking-financial-law-quiz',
    title: 'Banking & Financial Law Quiz',
    questions: bankingFinancialLawQuizQuestions,
  ),
  'environmental_law': _BundledQuiz(
    slug: 'environmental-law-quiz',
    title: 'Environmental Law Quiz',
    questions: environmentalLawQuizQuestions,
  ),
  'corporate_commercial_law': _BundledQuiz(
    slug: 'corporate-commercial-law-quiz',
    title: 'Corporate & Commercial Law Quiz',
    questions: corporateCommercialLawQuizQuestions,
  ),
};

/// Slugs already spoken for elsewhere in the app — Explore by Category, the
/// Popular Quizzes cards, and Continue Learning. The Leaderboard journey
/// pulls from the backend's full quiz catalogue minus this set, so it never
/// shows a quiz the user can already reach some other way.
final _reservedQuizSlugs = <String>{
  ..._categoryQuizzes.values.map((quiz) => quiz.slug),
  ..._popularQuizzes.keys,
  QuizProgressStore.continueLearningSlug,
};

/// Wraps [demoPoolQuizzes] as `_BundledQuiz`es, keyed by slug, so they can
/// be played offline through the same `_startQuiz` path as everything
/// else.
final _demoPoolQuizzes = <String, _BundledQuiz>{
  for (final entry in demoPoolQuizzes.entries)
    entry.key: _BundledQuiz(
      slug: entry.key,
      title: 'Legal Trivia ${entry.key.split('-').last}',
      questions: entry.value,
    ),
};

/// Starts the quiz behind a Home "Popular Quizzes" card.
Future<void> _handlePopularQuizSelected(
  BuildContext context,
  PopularQuizData quiz,
) async {
  final bundled = _popularQuizzes[quiz.id];
  if (bundled == null) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text('${quiz.title} is not wired yet.')),
      );
    return;
  }
  await _startQuiz(context, bundled);
}

/// Pushes the full category grid, reached from Home's "Explore by
/// Category" section header ("View All") and the "Quizzes" bottom nav tab.
void _openCategories(BuildContext context, {bool showCategories = false}) {
  // Tops up any credits that refilled while the app was away, so the
  // balance on the page is current.
  LeaderboardProgressStore.refreshRegen();
  Navigator.of(context).push(
    FadeThroughPageRoute<void>(
      builder: (categoriesContext) => CategoriesPage(
        viewModel: const HomeViewModel(),
        // Home's "Explore by Category › View All" lands on the category
        // list; the Quizzes nav tab keeps its default (Levels).
        showCategoriesFirst: showCategories,
        onJourneyPressed: () => _openJourney(categoriesContext),
        onCategorySelected: (category) =>
            _handleCategorySelected(categoriesContext, category),
        onNavigationSelected: (index) =>
            _handleCategoriesNavigation(categoriesContext, index),
        onLevelSelected: (level) => _startLevelQuiz(categoriesContext, level),
      ),
    ),
  );
}

void _handleHomeNavigation(BuildContext context, int index) {
  if (index == 1) {
    _openCategories(context);
    return;
  }
  if (index == 2) {
    _openLeaderboard(context);
    return;
  }
  if (index == 4) {
    _openProfile(context);
    return;
  }
  _showNavigationPlaceholder(context, index);
}

void _handleCategoriesNavigation(BuildContext context, int index) {
  if (index == 0) {
    Navigator.of(context).maybePop();
    return;
  }
  if (index == 1) {
    return;
  }
  if (index == 2) {
    _openLeaderboard(context);
    return;
  }
  if (index == 4) {
    _openProfile(context);
    return;
  }
  _showNavigationPlaceholder(context, index);
}

/// Pushes the Profile tab, reached from the "Profile" bottom nav item on
/// Home and Categories.
void _openProfile(BuildContext context) {
  Navigator.of(context).push(
    FadeThroughPageRoute<void>(
      builder: (profileContext) => _LiveStats(
        builder: (stats) => ProfilePage(
          viewModel: ProfileViewModel(stats: stats),
          onNavigationSelected: (index) =>
              _handleProfileNavigation(profileContext, index),
          onViewLeaderboard: () => _openLeaderboard(profileContext),
        ),
      ),
    ),
  );
}

void _handleProfileNavigation(BuildContext context, int index) {
  if (index == 0) {
    Navigator.of(context).maybePop();
    return;
  }
  if (index == 1) {
    _openCategories(context);
    return;
  }
  if (index == 2) {
    _openLeaderboard(context);
    return;
  }
  if (index == 4) {
    return;
  }
  _showNavigationPlaceholder(context, index);
}

/// Pushes the Leaderboard tab, reached from the "Leaderboard" bottom nav
/// item on Home, Categories, and Profile.
void _openLeaderboard(BuildContext context) {
  Navigator.of(context).push(
    FadeThroughPageRoute<void>(
      builder: (leaderboardContext) => _LiveStats(
        builder: (stats) => LeaderboardPage(
          viewModel: LeaderboardViewModel(stats: stats),
          onProfilePressed: () => _openProfile(leaderboardContext),
          onNavigationSelected: (index) =>
              _handleLeaderboardNavigation(leaderboardContext, index),
        ),
      ),
    ),
  );
}

/// Pushes the credits journey — pool quizzes laid out level by level —
/// reached from the Quizzes tab.
void _openJourney(BuildContext context) {
  Navigator.of(context).push(
    FadeThroughPageRoute<void>(
      builder: (journeyContext) => _LiveJourney(
        builder: (journey, credits, refresh) => JourneyPage(
          journey: journey,
          credits: credits,
          onStartQuizPressed: () => _startContinueLearningQuiz(journeyContext),
          onQuizSelected: (quiz) =>
              _startLeaderboardQuiz(journeyContext, quiz, refresh),
          onChestOpened: (chestIndex) =>
              _openLeaderboardChest(journeyContext, chestIndex, refresh),
          onNavigationSelected: (index) =>
              _handleJourneyNavigation(journeyContext, index),
        ),
      ),
    ),
  );
}

void _handleJourneyNavigation(BuildContext context, int index) {
  if (index == 1) {
    Navigator.of(context).maybePop();
    return;
  }
  if (index == 2) {
    _openLeaderboard(context);
    return;
  }
  _handleLeaderboardNavigation(context, index);
}

/// Spends the entry cost and plays a quiz from the Leaderboard journey —
/// the backend's pool of quizzes that Explore by Category doesn't already
/// cover. Unlike a bundled quiz there is no offline fallback content, so a
/// server that can't be reached fails the attempt outright and the spent
/// credits are handed back.
Future<void> _startLeaderboardQuiz(
  BuildContext context,
  RemoteQuiz quiz,
  VoidCallback refresh,
) async {
  final messenger = ScaffoldMessenger.of(context);
  final spent = await LeaderboardProgressStore.spend(
    LeaderboardProgressStore.quizCost,
  );
  if (!spent) {
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(content: Text('Not enough credits for this quiz.')),
      );
    refresh();
    return;
  }
  if (!context.mounted) {
    return;
  }

  // A demo pool stand-in carries its own questions and plays offline; a
  // real backend quiz has none bundled and must resolve online.
  final demo = _demoPoolQuizzes[quiz.slug];
  await _startQuiz(
    context,
    demo ??
        _BundledQuiz(slug: quiz.slug, title: quiz.title, questions: const []),
    requireOnline: demo == null,
    onUnavailable: () =>
        LeaderboardProgressStore.refund(LeaderboardProgressStore.quizCost),
    leaderboardSlug: quiz.slug,
  );
  refresh();
}

/// Opens a journey chest for its one-time credit reward.
Future<void> _openLeaderboardChest(
  BuildContext context,
  int chestIndex,
  VoidCallback refresh,
) async {
  final messenger = ScaffoldMessenger.of(context);
  final opened = await LeaderboardProgressStore.openChest(chestIndex);
  if (opened) {
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            'Chest opened! +${LeaderboardProgressStore.chestReward} credits',
          ),
        ),
      );
  }
  refresh();
}

void _handleLeaderboardNavigation(BuildContext context, int index) {
  if (index == 0) {
    // A plain pop would only reveal whatever page Leaderboard was pushed
    // from (Categories or Profile, not necessarily Home), so tapping Home
    // wouldn't always land on Home. Clear back to the root and push a
    // fresh Home instead, same as the quiz result "back to home" flow.
    Navigator.of(context).pushAndRemoveUntil(
      FadeThroughPageRoute<void>(builder: buildWiredHomePage),
      (route) => route.isFirst,
    );
    return;
  }
  if (index == 1) {
    _openCategories(context);
    return;
  }
  if (index == 2) {
    return;
  }
  if (index == 4) {
    _openProfile(context);
    return;
  }
  _showNavigationPlaceholder(context, index);
}

void _showNavigationPlaceholder(BuildContext context, int index) {
  final label = const HomeViewModel().navigationItems[index].label;
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text('$label coming soon.')));
}

/// Plays one level of the level-wise journey through the normal quiz
/// flow: questions, grading and submission all go to the backend under the
/// level's own quiz. A fresh attempt costs credits like every other quiz in
/// this section; continuing a half-finished one resumes it for free, since
/// it was already paid for.
Future<void> _startLevelQuiz(BuildContext context, QuizLevel level) async {
  // The backend gates levels behind a points tier and refuses locked ones
  // outright; stop here so no credits are spent on a doomed attempt.
  if (level.isLocked) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(level.unlockHint)));
    return;
  }
  final resuming = level.canResume;
  if (!resuming) {
    await LeaderboardProgressStore.refreshRegen();
    if (!context.mounted) {
      return;
    }
    final confirmed = await showQuizCostDialog(
      context,
      title: level.quiz.title,
      subtitle:
          level.milestoneLabel ?? '${level.quiz.totalQuestions} questions',
    );
    if (!confirmed || !context.mounted) {
      return;
    }
    if (!await LeaderboardProgressStore.spend(
      LeaderboardProgressStore.quizCost,
    )) {
      if (context.mounted) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            const SnackBar(content: Text('Not enough credits for this quiz.')),
          );
      }
      return;
    }
    if (!context.mounted) {
      return;
    }
  }

  await _startQuiz(
    context,
    _BundledQuiz(
      slug: level.quiz.slug,
      title: level.quiz.title,
      questions: const [],
    ),
    resume: resuming,
    // Levels live only on the backend — no offline copy to fall back to.
    requireOnline: true,
    onUnavailable: resuming
        ? null
        : () => LeaderboardProgressStore.refund(
            LeaderboardProgressStore.quizCost,
          ),
  );
}

/// Spends the entry cost and plays a mixed-topic quiz at [difficulty],
/// started from Home's Quick Practice cards. There is no bundled fallback
/// for a cross-category draw, so a failed start refunds the credits rather
/// than dropping to an offline copy.
Future<void> _handleDifficultySelected(
  BuildContext context,
  String difficulty,
) async {
  await LeaderboardProgressStore.refreshRegen();
  if (!context.mounted) {
    return;
  }

  final label = difficulty[0].toUpperCase() + difficulty.substring(1);
  final confirmed = await showQuizCostDialog(
    context,
    title: 'Practice Quiz',
    subtitle: '$label difficulty',
  );
  if (!confirmed || !context.mounted) {
    return;
  }

  if (!await LeaderboardProgressStore.spend(
    LeaderboardProgressStore.quizCost,
  )) {
    if (context.mounted) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(content: Text('Not enough credits for this quiz.')),
        );
    }
    return;
  }
  if (!context.mounted) {
    return;
  }

  await _startQuiz(
    context,
    _BundledQuiz(
      slug: 'practice-$difficulty',
      title: 'Practice Quiz ($label)',
      questions: const [],
    ),
    requireOnline: true,
    onUnavailable: () =>
        LeaderboardProgressStore.refund(LeaderboardProgressStore.quizCost),
    launcher: () => _catalog.prepareCustom(difficulty),
  );
}

Future<void> _handleCategorySelected(
  BuildContext context,
  HomeCategoryData category,
) async {
  final bundled = _categoryQuizzes[category.id];
  if (bundled != null) {
    // Category quizzes draw on the same credit balance as the Learning
    // Journey: confirm the cost, spend it, then play.
    await LeaderboardProgressStore.refreshRegen();
    if (!context.mounted) {
      return;
    }
    final confirmed = await showQuizCostDialog(
      context,
      title: bundled.title,
      subtitle: category.label,
    );
    if (!confirmed || !context.mounted) {
      return;
    }
    if (!await LeaderboardProgressStore.spend(
      LeaderboardProgressStore.quizCost,
    )) {
      if (context.mounted) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            const SnackBar(content: Text('Not enough credits for this quiz.')),
          );
      }
      return;
    }
    if (!context.mounted) {
      return;
    }
    await _startQuiz(context, bundled);
    return;
  }
  // Every other category opens its own landing page, which shows its
  // quizzes once they exist and an empty state until then.
  await Navigator.of(context).push(
    FadeThroughPageRoute<void>(
      builder: (_) => CategoryDetailPage(category: category),
    ),
  );
}

/// Home's "Continue Learning" quiz: the Indian Constitution set the card
/// tracks. Unlike every other entry point this resumes — if the user left an
/// attempt half finished, it picks up at the first question they never
/// answered instead of starting over.
Future<void> _startContinueLearningQuiz(BuildContext context) {
  return _startQuiz(
    context,
    _BundledQuiz(
      slug: QuizProgressStore.continueLearningSlug,
      title: 'Indian Constitution Quiz',
      questions: continueLearningQuizQuestions,
    ),
    resume: true,
  );
}

/// Resolves [bundled] against the backend, pushes the quiz session, and on
/// completion records the attempt and shows the result screen.
///
/// Everything up to the first question needs the network, so the button that
/// started this is covered by a blocking spinner until the quiz is ready.
/// [QuizCatalog.prepare] never throws — an unreachable server comes back as
/// an offline launch over the bundled questions.
Future<void> _startQuiz(
  BuildContext context,
  _BundledQuiz bundled, {
  bool resume = false,
  // Pool quizzes (the Leaderboard journey) ship no bundled fallback
  // content, so a failed resolve has nothing to play rather than a
  // degraded offline copy — this stops the launch instead of pushing a
  // quiz with zero questions.
  bool requireOnline = false,
  VoidCallback? onUnavailable,
  // Slug to credit in LeaderboardProgressStore once this attempt finishes,
  // set only for a journey quiz.
  String? leaderboardSlug,
  // Overrides how the launch is resolved — used by practice mode,
  // which has no slug to look up and no bundled fallback. Every
  // other caller leaves this null and gets today's behavior.
  Future<QuizLaunch> Function()? launcher,
}) async {
  final navigator = Navigator.of(context);
  final messenger = ScaffoldMessenger.of(context);

  showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (_) => const Center(
      key: ValueKey('quiz.loading'),
      child: CircularProgressIndicator(color: gold),
    ),
  );

  final launch =
      await (launcher ??
          () => _catalog.prepare(
            slug: bundled.slug,
            fallbackQuestions: bundled.questions,
            fallbackTitle: bundled.title,
            resume: resume,
          ))();

  // Closes the spinner dialog.
  navigator.pop();

  if (requireOnline && launch.questions.isEmpty) {
    onUnavailable?.call();
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(content: Text("This quiz isn't available right now.")),
      );
    return;
  }

  if (launch.isOffline && !requireOnline) {
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(
          content: Text("Offline — your score for this quiz won't be saved."),
        ),
      );
  }

  // Awaited so callers can react once the quiz route is gone — Home
  // re-reads the Continue Learning card at that point.
  await navigator.push(
    FadeThroughPageRoute<void>(
      builder: (quizContext) => QuizQuestionPage(
        session: launch.buildSession(
          // A wrong answer costs credits as it happens.
          onAnswered: (isCorrect) {
            if (!isCorrect) {
              LeaderboardProgressStore.penaliseWrongAnswer();
            }
          },
        ),
        onQuizCompleted: (outcomes) => _finishQuiz(
          quizContext,
          launch,
          outcomes,
          leaderboardSlug: leaderboardSlug,
        ),
      ),
    ),
  );
}

/// Submits the attempt, records it locally, and swaps the quiz page for the
/// result screen.
Future<void> _finishQuiz(
  BuildContext context,
  QuizLaunch launch,
  List<QuizOutcome> outcomes, {
  String? leaderboardSlug,
}) async {
  final navigator = Navigator.of(context);

  var correctCount = outcomes.where((o) => o.isCorrect).length;
  var total = outcomes.length;

  final api = launch.api;
  final attemptId = launch.attemptId;
  if (api != null && attemptId != null) {
    try {
      final attempt = await api.submitAttempt(attemptId);
      // Resuming answers only the questions that were left, so the server's
      // tally — which covers the whole attempt — is the real score.
      correctCount = attempt.correctAnswers;
      total = attempt.totalQuestions;
    } on Object {
      // The answers were already recorded one by one as they were given, so
      // a failed submit costs the final tally, not the work. Fall through
      // with the locally counted score.
    }
  }

  await QuizHistoryStore.recordAttempt(
    topicTitle: launch.title,
    correctCount: correctCount,
    total: total,
  );
  await NotificationsStore.addQuizCompletedNotification(
    topicTitle: launch.title,
    correctCount: correctCount,
    total: total,
  );
  if (launch.slug == QuizProgressStore.continueLearningSlug) {
    await QuizProgressStore.recordResult(
      correctCount: correctCount,
      total: total,
    );
  }
  // Completion for the Leaderboard journey is read straight from the
  // backend's submitted attempts on the next load — nothing local to
  // record here now that credits and progress are both server-owned.

  navigator.pushReplacement(
    FadeThroughPageRoute<void>(
      builder: (resultContext) => QuizResultPage(
        viewModel: QuizResultViewModel(
          outcomes: outcomes,
          topicTitle: launch.title,
          headline: 'Quiz Completed!',
          total: total,
          correctCount: correctCount,
        ),
        backButtonLabel: 'BACK TO HOME',
        onReviewAnswers: () => Navigator.of(resultContext).push(
          MaterialPageRoute<void>(
            builder: (_) => QuizReviewPage(
              questions: launch.questions,
              outcomes: outcomes,
            ),
          ),
        ),
        // A plain pop would reveal the Home instance built before this
        // attempt, which Flutter won't rebuild on its own, so any state it
        // reads (e.g. Continue Learning progress) would stay stale. Discard
        // it and push a fresh Home instead.
        onBackToTopic: () => Navigator.of(resultContext).pushAndRemoveUntil(
          FadeThroughPageRoute<void>(builder: buildWiredHomePage),
          (route) => route.isFirst,
        ),
      ),
    ),
  );
}

/// Replaces the sign-up route with goal selection, then home.
void startPostSignUpFlow(BuildContext context) {
  AppSession.saveSignedIn();
  _pushGoalSelectionThenHome(context);
}

/// Replaces the sign-in route after a successful login. A returning user
/// who already picked a goal skips straight to Home; anyone else (e.g. a
/// fresh device that never finished onboarding) still sees goal selection.
void startPostSignInFlow(BuildContext context) {
  if (AppSession.isOnboarded) {
    Navigator.of(
      context,
    ).pushReplacement(FadeThroughPageRoute<void>(builder: buildWiredHomePage));
    return;
  }
  _pushGoalSelectionThenHome(context);
}

void _pushGoalSelectionThenHome(BuildContext context) {
  Navigator.of(context).pushReplacement(
    FadeThroughPageRoute<void>(
      builder: (goalContext) => GoalSelectionPage(
        onContinue: (goalId) {
          AppSession.saveGoal(goalId);
          Navigator.of(goalContext).pushReplacement(
            FadeThroughPageRoute<void>(
              builder: (homeContext) => buildWiredHomePage(homeContext),
            ),
          );
        },
      ),
    ),
  );
}
