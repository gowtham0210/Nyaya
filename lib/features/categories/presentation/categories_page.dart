import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../app/leaderboard_progress_store.dart';
import '../../../core/presentation/motion.dart';
import '../../category_detail/data/category_content.dart';
import '../../home/presentation/home_page.dart';
import '../../home/presentation/home_view_model.dart';
import '../../leaderboard/presentation/journey_widgets.dart';
import '../data/quiz_levels.dart';

/// The "Quizzes" tab: the backend's level-wise journey, Level 1 upward,
/// along a winding road.
///
/// The same page, opened with [showCategoriesFirst] from Home's "Explore by
/// Category > View All", shows the category list on that road instead.
class CategoriesPage extends StatefulWidget {
  const CategoriesPage({
    super.key,
    required this.viewModel,
    this.onBackPressed,
    this.onCategorySelected,
    this.onNavigationSelected,
    this.onJourneyPressed,
    this.onLevelSelected,
    this.levelsLoader,
    this.showCategoriesFirst = false,
  });

  final HomeViewModel viewModel;
  final VoidCallback? onBackPressed;
  final ValueChanged<HomeCategoryData>? onCategorySelected;
  final ValueChanged<int>? onNavigationSelected;

  /// Opens the credits journey; its hero button is hidden when unset.
  final VoidCallback? onJourneyPressed;

  /// Plays a level; awaited so the level list refreshes its progress when
  /// the user comes back.
  final Future<void> Function(QuizLevel level)? onLevelSelected;

  /// Overridden in tests; defaults to [loadQuizLevels] against the backend.
  final Future<List<QuizLevel>> Function()? levelsLoader;

  /// Shows the category list instead of the level journey.
  final bool showCategoriesFirst;

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  static const _activeNavigationIndex = 1;

  @override
  Widget build(BuildContext context) {
    final categories = widget.viewModel.categories;
    final showCategories = widget.showCategoriesFirst;

    void select(HomeCategoryData category) {
      final callback = widget.onCategorySelected;
      if (callback != null) {
        callback(category);
        return;
      }
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(content: Text('${category.label} is not wired yet.')),
        );
    }

    return Scaffold(
      backgroundColor: JourneyColors.pageBackground,
      bottomNavigationBar: HomeBottomNavigationBar(
        items: widget.viewModel.navigationItems,
        activeIndex: _activeNavigationIndex,
        onSelected: (index) {
          final callback = widget.onNavigationSelected;
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
        child: Column(
          children: [
            JourneyHeader(
              backKey: const ValueKey('categories.back'),
              onBackPressed: () {
                final callback = widget.onBackPressed;
                if (callback != null) {
                  callback();
                  return;
                }
                Navigator.of(context).maybePop();
              },
            ),
            Expanded(
              child: ListView(
                key: const ValueKey('categories.grid'),
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 32),
                children: [
                  FadeSlideIn(
                    child: _QuizzesHero(
                      count: categories.length,
                      showCategories: showCategories,
                      onJourney: widget.onJourneyPressed,
                      onSurprise: !showCategories || categories.isEmpty
                          ? null
                          : () => select(
                              categories[math.Random().nextInt(
                                categories.length,
                              )],
                            ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  FadeSlideIn(
                    delay: Motion.stagger,
                    child: showCategories
                        ? _CategoryRoad(
                            categories: categories,
                            onSelected: select,
                          )
                        : _LevelsSection(
                            loader: widget.levelsLoader ?? loadQuizLevels,
                            onLevelSelected: widget.onLevelSelected,
                          ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuizzesHero extends StatelessWidget {
  const _QuizzesHero({
    required this.count,
    required this.showCategories,
    required this.onSurprise,
    this.onJourney,
  });

  final int count;

  /// Whether this page is showing categories rather than the level journey.
  final bool showCategories;

  final VoidCallback? onSurprise;
  final VoidCallback? onJourney;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1C3657), JourneyColors.navy],
        ),
        boxShadow: [
          BoxShadow(
            color: JourneyColors.navy.withValues(alpha: 0.28),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          const Positioned(
            top: 0,
            right: 0,
            bottom: 0,
            width: 170,
            child: JourneyFadedArt(
              asset: 'assets/journey/topic_3.png',
              alignment: Alignment(0, -0.6),
              fadeBottom: false,
              opacity: 0.3,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: JourneyEyebrow(
                          showCategories
                              ? '$count CATEGORIES'
                              : 'LEVEL JOURNEY',
                        ),
                      ),
                    ),
                    ValueListenableBuilder<int>(
                      valueListenable: LeaderboardProgressStore.creditsNotifier,
                      builder: (context, credits, _) => JourneyCreditsPill(
                        key: const ValueKey('categories.credits'),
                        credits: credits,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  'Explore Quizzes',
                  key: ValueKey('categories.title'),
                  style: TextStyle(
                    fontSize: 25,
                    height: 1.15,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: -0.4,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  showCategories
                      ? 'Pick a branch of law and test what you know. '
                            'Each quiz costs '
                            '${LeaderboardProgressStore.quizCost} credits.'
                      : 'Climb the levels one at a time. Each quiz costs '
                            '${LeaderboardProgressStore.quizCost} credits.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withValues(alpha: 0.72),
                  ),
                ),
                const SizedBox(height: 20),
                if (showCategories)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      key: const ValueKey('categories.surprise'),
                      onPressed: onSurprise,
                      icon: const Icon(Icons.shuffle_rounded, size: 20),
                      label: const Text('Surprise Me'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: JourneyColors.gold,
                        foregroundColor: JourneyColors.navy,
                        elevation: 0,
                        textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  ),
                if (onJourney != null) ...[
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      key: const ValueKey('categories.journey'),
                      onPressed: onJourney,
                      icon: const Icon(Icons.route_rounded, size: 20),
                      label: const Text('Learning Journey'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: BorderSide(
                          color: Colors.white.withValues(alpha: 0.35),
                        ),
                        textStyle: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Cards staggered left and right down the page, with the road sweeping
/// between them from a START flag to [endCap]. Shared by the Categories and
/// Levels tabs so the two read as one design. The road is gold up to
/// [reachedUpTo] (a waypoint index: 0 is the flag, then each card's top and
/// bottom), or all beige when that is -1.
class _CardRoad extends StatelessWidget {
  const _CardRoad({
    required this.count,
    required this.cardBuilder,
    required this.endCap,
    this.reachedUpTo = -1,
  });

  final int count;
  final Widget Function(int index) cardBuilder;
  final Widget endCap;
  final int reachedUpTo;

  static const _startHeight = 76.0;
  static const _cardHeight = 140.0;
  static const _gap = 40.0;
  static const _endHeight = 90.0;

  /// Wider than this and cards would stretch across a tablet or desktop
  /// window; the road stays phone-shaped and centred instead.
  static const _maxWidth = 560.0;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: _maxWidth),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            final cardWidth = width * 0.86;
            final mid = width / 2;
            final road = <Offset>[Offset(mid, 30)];
            final tops = <double>[];
            var y = _startHeight;

            for (var i = 0; i < count; i++) {
              final left = i.isEven ? 0.0 : width - cardWidth;
              final cx = left + cardWidth / 2;
              tops.add(y);
              road
                ..add(Offset(cx, y + 18))
                ..add(Offset(cx, y + _cardHeight - 18));
              y += _cardHeight + _gap;
            }
            final endY = y + 10;
            road.add(Offset(mid, endY));
            final height = endY + _endHeight;

            return SizedBox(
              height: height,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned.fill(
                    child: CustomPaint(
                      painter: JourneyRoadPainter(
                        points: road,
                        reachedUpTo: reachedUpTo.clamp(-1, road.length - 1),
                      ),
                    ),
                  ),
                  const Positioned(
                    left: 0,
                    right: 0,
                    top: 8,
                    child: Center(child: JourneyStartFlag()),
                  ),
                  for (var i = 0; i < count; i++)
                    Positioned(
                      left: i.isEven ? 0 : width - cardWidth,
                      top: tops[i],
                      width: cardWidth,
                      height: _cardHeight,
                      child: cardBuilder(i),
                    ),
                  Positioned(
                    left: 0,
                    right: 0,
                    top: endY - 18,
                    child: Center(child: endCap),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

/// Every category along the road.
class _CategoryRoad extends StatelessWidget {
  const _CategoryRoad({required this.categories, required this.onSelected});

  final List<HomeCategoryData> categories;
  final ValueChanged<HomeCategoryData> onSelected;

  @override
  Widget build(BuildContext context) {
    return _CardRoad(
      count: categories.length,
      endCap: const _ComingSoonCap(),
      cardBuilder: (i) => _CategoryCard(
        number: i + 1,
        category: categories[i],
        onTap: () => onSelected(categories[i]),
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  const _CategoryCard({
    required this.number,
    required this.category,
    required this.onTap,
  });

  final int number;
  final HomeCategoryData category;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final description = categoryContentFor(category.id).description;

    return Material(
      color: JourneyColors.card,
      clipBehavior: Clip.antiAlias,
      shadowColor: const Color(0xFF6B4A1F).withValues(alpha: 0.25),
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: const BorderSide(color: JourneyColors.cardBorder),
      ),
      child: InkWell(
        key: ValueKey('categories.card.${category.id}'),
        onTap: () {
          Motion.tick();
          onTap();
        },
        child: Stack(
          children: [
            // Oversized icon ghosted into the corner — the card's "art",
            // drawn from the same icon set as the badge so it stays crisp.
            Positioned(
              right: -14,
              bottom: -18,
              child: ExcludeSemantics(
                child: HomeIcon(
                  type: category.icon,
                  size: 96,
                  color: JourneyColors.navy.withValues(alpha: 0.05),
                  accentColor: JourneyColors.gold.withValues(alpha: 0.08),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  ExcludeSemantics(child: JourneyShield(number: number)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'CATEGORY $number',
                          style: const TextStyle(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.2,
                            color: JourneyColors.goldDeep,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          category.label,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 16.5,
                            height: 1.2,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.2,
                            color: JourneyColors.navy,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 12,
                            height: 1.3,
                            color: HomePage.supportText,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: JourneyColors.gold.withValues(alpha: 0.16),
                        ),
                        alignment: Alignment.center,
                        child: HomeIcon(
                          type: category.icon,
                          size: 20,
                          color: JourneyColors.navy,
                          accentColor: JourneyColors.goldDeep,
                        ),
                      ),
                      const Icon(
                        Icons.arrow_forward_rounded,
                        size: 20,
                        color: JourneyColors.goldDeep,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ComingSoonCap extends StatelessWidget {
  const _ComingSoonCap();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
      decoration: BoxDecoration(
        color: JourneyColors.card,
        borderRadius: BorderRadius.circular(99),
        border: Border.all(color: JourneyColors.gold, width: 1.6),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.auto_awesome_rounded,
            size: 16,
            color: JourneyColors.goldDeep,
          ),
          SizedBox(width: 6),
          Text(
            'MORE COMING SOON',
            style: TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.1,
              color: JourneyColors.navy,
            ),
          ),
        ],
      ),
    );
  }
}

/// One stop on the level road: a level, or a chest standing after every
/// [LeaderboardProgressStore.levelsPerChest] levels.
class _RoadItem {
  const _RoadItem.level(this.level)
    : chestIndex = null,
      isChestReady = false,
      isChestOpened = false,
      levelsNeeded = null;

  const _RoadItem.chest({
    required int this.chestIndex,
    required this.isChestReady,
    required this.isChestOpened,
    required int this.levelsNeeded,
  }) : level = null;

  final QuizLevel? level;
  final int? chestIndex;
  final bool isChestReady;
  final bool isChestOpened;

  /// The level that has to be finished for this chest to open.
  final int? levelsNeeded;

  /// Finished: a played level, or a claimed chest. Drives how far the gold
  /// stretch of road reaches.
  bool get isDone => level?.isCompleted ?? isChestOpened;
}

/// Levels in order, with a chest after every whole group of
/// [LeaderboardProgressStore.levelsPerChest] of them.
List<_RoadItem> _roadItems(List<QuizLevel> levels) {
  final items = <_RoadItem>[];
  for (final (index, level) in levels.indexed) {
    items.add(_RoadItem.level(level));
    final played = index + 1;
    if (played % LeaderboardProgressStore.levelsPerChest != 0) {
      continue;
    }
    final chestIndex = played ~/ LeaderboardProgressStore.levelsPerChest - 1;
    items.add(
      _RoadItem.chest(
        chestIndex: chestIndex,
        isChestReady: levels.take(played).every((l) => l.isCompleted),
        isChestOpened: LeaderboardProgressStore.isLevelChestOpened(chestIndex),
        levelsNeeded: level.number,
      ),
    );
  }
  return items;
}

/// The level-wise journey: Level 1 … Level 10 from the backend, in number
/// order, each card showing its size, difficulty and the user's progress.
/// Owns its own loading / empty / error states so a failed fetch never
/// leaves the page blank.
class _LevelsSection extends StatefulWidget {
  const _LevelsSection({required this.loader, this.onLevelSelected});

  final Future<List<QuizLevel>> Function() loader;
  final Future<void> Function(QuizLevel level)? onLevelSelected;

  @override
  State<_LevelsSection> createState() => _LevelsSectionState();
}

class _LevelsSectionState extends State<_LevelsSection> {
  late Future<List<QuizLevel>> _future = _load();

  /// One silent retry before the error state: a dev backend restarting
  /// (nodemon) or a phone switching networks drops the request for a second,
  /// and showing "unable to load" for that is noise the user has to clear.
  Future<List<QuizLevel>> _load() async {
    try {
      return await widget.loader();
    } on Object {
      await Future<void>.delayed(const Duration(milliseconds: 700));
      return widget.loader();
    }
  }

  void _reload() {
    setState(() {
      _future = _load();
    });
  }

  Future<void> _openChest(_RoadItem chest) async {
    final messenger = ScaffoldMessenger.of(context);
    if (chest.isDone) {
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(content: Text('You already opened this chest.')),
        );
      return;
    }
    if (!chest.isChestReady) {
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text('Finish Level ${chest.levelsNeeded} to open it.'),
          ),
        );
      return;
    }

    final opened = await LeaderboardProgressStore.openLevelChest(
      chest.chestIndex!,
    );
    if (!mounted) {
      return;
    }
    if (opened) {
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            content: Text(
              '+${LeaderboardProgressStore.levelChestReward} credits!',
            ),
          ),
        );
    }
    setState(() {});
  }

  Future<void> _play(QuizLevel level) async {
    if (level.isLocked) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(level.unlockHint)));
      return;
    }
    final callback = widget.onLevelSelected;
    if (callback == null) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(content: Text('${level.quiz.title} is not wired yet.')),
        );
      return;
    }
    await callback(level);
    // Back from the quiz: pick up the attempt the backend just recorded.
    if (mounted) {
      _reload();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<QuizLevel>>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const _LevelsMessage(
            key: ValueKey('levels.loading'),
            icon: null,
            text: 'Loading quizzes...',
          );
        }
        if (snapshot.hasError) {
          return _LevelsMessage(
            key: const ValueKey('levels.error'),
            icon: Icons.cloud_off_rounded,
            text: 'Unable to load quizzes. Please try again.',
            onRetry: _reload,
          );
        }
        final levels = snapshot.data ?? const <QuizLevel>[];
        if (levels.isEmpty) {
          return _LevelsMessage(
            key: const ValueKey('levels.empty'),
            icon: Icons.inbox_outlined,
            text: 'No quizzes available.',
            onRetry: _reload,
          );
        }

        final questions = levels.fold<int>(
          0,
          (sum, level) => sum + level.quiz.totalQuestions,
        );
        final done = levels.where((level) => level.isCompleted).length;
        // The first level not yet finished — highlighted, never enforced:
        // the backend has no locking, so every level stays playable.
        final upNext = levels.where((level) => !level.isCompleted).firstOrNull;
        final items = _roadItems(levels);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'QUIZZES',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.4,
                color: JourneyColors.goldDeep,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Your Legal Learning Journey',
              key: ValueKey('levels.title'),
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.3,
                color: JourneyColors.navy,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${levels.length} levels · $questions questions · '
              '$done completed. Every level mixes topics from across the law.',
              style: const TextStyle(
                fontSize: 13,
                height: 1.35,
                color: HomePage.supportText,
              ),
            ),
            const SizedBox(height: 6),
            _CardRoad(
              count: items.length,
              // Gold up to the top of the first stop still to do.
              reachedUpTo:
                  2 * items.takeWhile((item) => item.isDone).length + 1,
              endCap: _JourneyEndCap(allDone: done == levels.length),
              cardBuilder: (i) {
                final item = items[i];
                final level = item.level;
                if (level != null) {
                  return _LevelCard(
                    level: level,
                    isUpNext: identical(level, upNext),
                    onPlay: () => _play(level),
                  );
                }
                return _ChestCard(
                  chestIndex: item.chestIndex!,
                  isReady: item.isChestReady,
                  isOpened: item.isDone,
                  levelsNeeded: item.levelsNeeded!,
                  onOpen: () => _openChest(item),
                );
              },
            ),
          ],
        );
      },
    );
  }
}

class _LevelsMessage extends StatelessWidget {
  const _LevelsMessage({
    super.key,
    required this.icon,
    required this.text,
    this.onRetry,
  });

  /// Null shows a spinner instead.
  final IconData? icon;
  final String text;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 20),
      decoration: BoxDecoration(
        color: JourneyColors.card,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: JourneyColors.cardBorder),
      ),
      child: Column(
        children: [
          if (icon == null)
            const SizedBox(
              width: 32,
              height: 32,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                color: JourneyColors.gold,
              ),
            )
          else
            Icon(icon, size: 36, color: JourneyColors.goldDeep),
          const SizedBox(height: 14),
          Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14.5,
              fontWeight: FontWeight.w600,
              color: JourneyColors.navy,
            ),
          ),
          if (onRetry != null) ...[
            const SizedBox(height: 10),
            TextButton.icon(
              key: const ValueKey('levels.retry'),
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: const Text(
                'Try again',
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
              style: TextButton.styleFrom(
                foregroundColor: JourneyColors.goldDeep,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// One level on the road, built like a category card: shield, eyebrow,
/// title, a detail line, a status badge and an arrow; the whole card starts
/// the level. The checkpoint is gold and the final level navy so the two
/// milestones stand out.
class _LevelCard extends StatelessWidget {
  const _LevelCard({
    required this.level,
    required this.isUpNext,
    required this.onPlay,
  });

  final QuizLevel level;
  final bool isUpNext;
  final VoidCallback onPlay;

  @override
  Widget build(BuildContext context) {
    final finalLevel = level.isMilestone && level.isFinal;
    final checkpoint = level.isMilestone && !level.isFinal;
    final ink = finalLevel ? Colors.white : JourneyColors.navy;
    final muted = finalLevel
        ? Colors.white.withValues(alpha: 0.72)
        : HomePage.supportText;
    final attempt = level.latestAttempt;

    final eyebrow = [
      level.milestoneLabel?.toUpperCase() ?? 'LEVEL ${level.number}',
      if (isUpNext) 'UP NEXT',
    ].join(' · ');

    String? progress;
    if (level.isLocked) {
      progress = level.unlockHint;
    } else if (attempt != null && level.canResume) {
      progress =
          'In progress · ${attempt.answeredQuestions} of '
          '${attempt.totalQuestions} answered';
    } else if (attempt != null && !attempt.isInProgress && level.isCompleted) {
      progress =
          '✓ Completed · ${attempt.correctAnswers}/'
          '${attempt.totalQuestions} correct';
    } else if (level.isCompleted) {
      progress = '✓ Completed';
    }

    final IconData badge;
    final String action;
    if (level.isLocked) {
      badge = Icons.lock_rounded;
      action = 'Locked';
    } else if (level.canResume) {
      badge = Icons.play_circle_outline_rounded;
      action = 'Continue';
    } else if (level.isCompleted) {
      badge = Icons.check_rounded;
      action = 'Play again';
    } else {
      badge = level.isMilestone
          ? Icons.emoji_events_rounded
          : Icons.play_arrow_rounded;
      action = 'Start quiz';
    }

    return Material(
      key: ValueKey('levels.card.${level.number}'),
      color: checkpoint ? const Color(0xFFFFF6E3) : JourneyColors.card,
      clipBehavior: Clip.antiAlias,
      shadowColor: const Color(0xFF6B4A1F).withValues(alpha: 0.25),
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: BorderSide(
          color: !level.isLocked && (level.isMilestone || isUpNext)
              ? JourneyColors.gold
              : JourneyColors.cardBorder,
          width: !level.isLocked && (level.isMilestone || isUpNext) ? 1.6 : 1,
        ),
      ),
      child: Ink(
        decoration: finalLevel
            ? const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF1C3657), JourneyColors.navy],
                ),
              )
            : null,
        child: InkWell(
          key: ValueKey('levels.start.${level.number}'),
          onTap: () {
            Motion.tick();
            onPlay();
          },
          child: Semantics(
            button: true,
            label:
                '${level.quiz.title}. ${level.quiz.totalQuestions} questions. '
                '${level.difficultyLabel}. ${progress ?? ''} $action.',
            child: ExcludeSemantics(
              child: Stack(
                children: [
                  // A big ghosted level number in the corner — the card's
                  // "art", like the category cards' ghosted icon.
                  Positioned(
                    right: 6,
                    bottom: -30,
                    child: Text(
                      '${level.number}',
                      style: TextStyle(
                        fontSize: 110,
                        fontWeight: FontWeight.w900,
                        height: 1,
                        color: (finalLevel ? Colors.white : JourneyColors.navy)
                            .withValues(alpha: 0.05),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(14),
                    child: Row(
                      children: [
                        JourneyShield(
                          number: level.number,
                          boss: level.isMilestone && !level.isLocked,
                          locked: level.isLocked,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                eyebrow,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 1.2,
                                  color: JourneyColors.goldDeep,
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                level.quiz.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 16.5,
                                  height: 1.2,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: -0.2,
                                  color: ink,
                                ),
                              ),
                              const SizedBox(height: 3),
                              Wrap(
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  Text(
                                    '${level.quiz.totalQuestions} Questions',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: ink,
                                    ),
                                  ),
                                  Text(
                                    '  ·  ',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: muted,
                                    ),
                                  ),
                                  Text(
                                    level.difficultyLabel,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: muted,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 3),
                              // Gives way (ellipsizing) before the fixed-height
                              // card can overflow with large system text.
                              Flexible(
                                child: Text(
                                  progress ?? level.quiz.description ?? '',
                                  key: progress == null
                                      ? null
                                      : ValueKey(
                                          'levels.progress.${level.number}',
                                        ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 12,
                                    height: 1.3,
                                    fontWeight: progress == null
                                        ? FontWeight.w400
                                        : FontWeight.w700,
                                    color: progress == null
                                        ? muted
                                        : finalLevel
                                        ? JourneyColors.gold
                                        : JourneyColors.goldDeep,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: 38,
                              height: 38,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: level.isLocked
                                    ? JourneyColors.lockedFace
                                    : level.isCompleted
                                    ? JourneyColors.gold
                                    : JourneyColors.gold.withValues(
                                        alpha: finalLevel ? 0.25 : 0.16,
                                      ),
                              ),
                              alignment: Alignment.center,
                              child: Icon(
                                badge,
                                size: 20,
                                color: level.isLocked
                                    ? HomePage.mutedIcon
                                    : level.isCompleted
                                    ? Colors.white
                                    : finalLevel
                                    ? JourneyColors.gold
                                    : JourneyColors.navy,
                              ),
                            ),
                            Icon(
                              level.isLocked
                                  ? Icons.lock_outline_rounded
                                  : Icons.arrow_forward_rounded,
                              size: 20,
                              color: level.isLocked
                                  ? HomePage.mutedIcon
                                  : finalLevel
                                  ? JourneyColors.gold
                                  : JourneyColors.goldDeep,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// The road's end cap on the Levels tab.
class _JourneyEndCap extends StatelessWidget {
  const _JourneyEndCap({required this.allDone});

  final bool allDone;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
      decoration: BoxDecoration(
        color: allDone ? JourneyColors.navy : JourneyColors.card,
        borderRadius: BorderRadius.circular(99),
        border: Border.all(color: JourneyColors.gold, width: 1.6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.emoji_events_rounded,
            size: 16,
            color: JourneyColors.gold,
          ),
          const SizedBox(width: 6),
          Text(
            allDone ? 'JOURNEY COMPLETE' : 'FINISH',
            style: TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.1,
              color: allDone ? Colors.white : JourneyColors.navy,
            ),
          ),
        ],
      ),
    );
  }
}

/// A treasure chest on the level road, one after every
/// [LeaderboardProgressStore.levelsPerChest] levels. It opens once those
/// levels are all finished, pays [LeaderboardProgressStore.levelChestReward]
/// credits, and can only be claimed once.
class _ChestCard extends StatelessWidget {
  const _ChestCard({
    required this.chestIndex,
    required this.isReady,
    required this.isOpened,
    required this.levelsNeeded,
    required this.onOpen,
  });

  final int chestIndex;

  /// All the levels before this chest are finished.
  final bool isReady;
  final bool isOpened;

  /// The last level that has to be finished before it opens.
  final int levelsNeeded;

  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    const reward = LeaderboardProgressStore.levelChestReward;
    final claimable = isReady && !isOpened;

    final String status;
    if (isOpened) {
      status = 'Opened · +$reward credits claimed';
    } else if (isReady) {
      status = 'Tap to claim +$reward credits';
    } else {
      status = 'Finish Level $levelsNeeded to open.';
    }

    Widget chest = Image.asset(
      // Four chest illustrations, one per chest along the road.
      'assets/journey/chest_${(chestIndex % 4) + 1}.png',
      width: 74,
      height: 74,
      fit: BoxFit.contain,
      filterQuality: FilterQuality.high,
      excludeFromSemantics: true,
    );
    if (!claimable) {
      chest = Opacity(opacity: isOpened ? 0.55 : 0.4, child: chest);
    }

    return Material(
      key: ValueKey('levels.chest.$chestIndex'),
      color: claimable ? const Color(0xFFFFF6E3) : JourneyColors.card,
      clipBehavior: Clip.antiAlias,
      shadowColor: const Color(0xFF6B4A1F).withValues(alpha: 0.25),
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: BorderSide(
          color: claimable ? JourneyColors.gold : JourneyColors.cardBorder,
          width: claimable ? 1.6 : 1,
        ),
      ),
      child: InkWell(
        key: ValueKey('levels.chest.open.$chestIndex'),
        onTap: () {
          Motion.tick();
          onOpen();
        },
        child: Semantics(
          button: true,
          label: 'Treasure chest. $status',
          child: ExcludeSemantics(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  chest,
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          claimable ? 'REWARD READY' : 'TREASURE CHEST',
                          style: const TextStyle(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.2,
                            color: JourneyColors.goldDeep,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          '+$reward Credits',
                          style: TextStyle(
                            fontSize: 16.5,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.2,
                            color: claimable
                                ? JourneyColors.navy
                                : HomePage.mutedIcon,
                          ),
                        ),
                        const SizedBox(height: 3),
                        // Shrinks before the fixed-height card can
                        // overflow with large system text.
                        Flexible(
                          child: Text(
                            status,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12,
                              height: 1.3,
                              fontWeight: claimable
                                  ? FontWeight.w700
                                  : FontWeight.w400,
                              color: claimable
                                  ? JourneyColors.goldDeep
                                  : HomePage.supportText,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    isOpened
                        ? Icons.check_circle_rounded
                        : claimable
                        ? Icons.redeem_rounded
                        : Icons.lock_rounded,
                    size: 26,
                    color: claimable ? JourneyColors.gold : HomePage.mutedIcon,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
