import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../app/leaderboard_progress_store.dart';
import '../../../core/presentation/motion.dart';
import '../../home/presentation/home_page.dart';
import '../../home/presentation/home_view_model.dart';
import '../../quiz_question/data/quiz_api.dart';
import 'journey_widgets.dart';
import 'leaderboard_journey.dart';

/// The credits journey (opened from the Quizzes tab): a winding road through the backend's pool of
/// quizzes — distinct from the ones Explore by Category already shows —
/// styled as a learning journey rather than a points ranking. Five quizzes
/// to a level, ten on every fifth ("boss") level, a chest after every
/// finished cluster of five levels, and each stop locked until the one
/// before it is finished.
///
/// Everything structural (road, nodes, shields, start and finish) is drawn
/// in code so it stays crisp at any density; the extracted illustrations
/// are low-resolution crops, so they only ever appear edge-faded inside
/// cards, never as free-floating cut-outs.
class JourneyPage extends StatelessWidget {
  const JourneyPage({
    super.key,
    this.journey = const LeaderboardJourney(stops: []),
    this.credits = LeaderboardProgressStore.maxCredits,
    this.onBackPressed,
    this.onStartQuizPressed,
    this.onQuizSelected,
    this.onChestOpened,
    this.onNavigationSelected,
  });

  final LeaderboardJourney journey;

  /// The user's current spendable balance, shown in the hero and used to
  /// disable quizzes they can't currently afford.
  final int credits;

  final VoidCallback? onBackPressed;

  /// Fired by the hero button only when there is no journey stop left to
  /// continue — otherwise that button opens the next stop's preview.
  final VoidCallback? onStartQuizPressed;

  /// Fired when the user commits to playing a quiz from its preview dialog.
  final ValueChanged<RemoteQuiz>? onQuizSelected;

  /// Fired when the user taps an available chest.
  final ValueChanged<int>? onChestOpened;
  final ValueChanged<int>? onNavigationSelected;

  // Reached from the Quizzes tab, so that tab stays highlighted.
  static const _activeNavigationIndex = 1;

  static const navy = JourneyColors.navy;
  static const gold = JourneyColors.gold;
  static const goldDeep = JourneyColors.goldDeep;
  static const pageBackground = JourneyColors.pageBackground;
  static const lockedFace = JourneyColors.lockedFace;
  static const lockedEdge = JourneyColors.lockedEdge;

  @override
  Widget build(BuildContext context) {
    final current = _currentStop(journey.stops);

    return Scaffold(
      backgroundColor: pageBackground,
      bottomNavigationBar: HomeBottomNavigationBar(
        items: const HomeViewModel().navigationItems,
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
        child: Column(
          children: [
            JourneyHeader(
              backKey: const ValueKey('journey.back'),
              onBackPressed: () {
                final callback = onBackPressed;
                if (callback != null) {
                  callback();
                  return;
                }
                Navigator.of(context).maybePop();
              },
            ),
            Expanded(
              child: ListView(
                key: const ValueKey('journey.scroll'),
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 32),
                children: [
                  FadeSlideIn(
                    child: _JourneyHero(
                      stops: journey.stops,
                      current: current,
                      credits: credits,
                      onContinue: () {
                        if (current != null) {
                          _openPreview(context, current);
                          return;
                        }
                        final callback = onStartQuizPressed;
                        if (callback != null) {
                          callback();
                          return;
                        }
                        _snack(context, 'Quiz entry flow is not wired yet.');
                      },
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (journey.stops.isEmpty)
                    const _EmptyJourney()
                  else
                    FadeSlideIn(
                      delay: Motion.stagger,
                      child: _JourneyMap(
                        stops: journey.stops,
                        current: current,
                        onQuizTapped: (stop) => _openPreview(context, stop),
                        onChestTapped: (stop) {
                          if (!stop.isChestAvailable) {
                            _snack(
                              context,
                              stop.isChestOpened
                                  ? 'You already opened this chest.'
                                  : "Finish this level's quizzes to unlock "
                                        'the chest.',
                            );
                            return;
                          }
                          final callback = onChestOpened;
                          if (callback != null) {
                            callback(stop.chestIndex!);
                            return;
                          }
                          _snack(context, 'Chest opening is not wired yet.');
                        },
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

  void _openPreview(BuildContext context, JourneyStop stop) {
    if (stop.isLocked) {
      _snack(context, 'Finish the quiz before this one to unlock it.');
      return;
    }
    final quiz = stop.quiz!;
    final levelStops = [
      for (final s in journey.stops)
        if (!s.isChest && s.levelNumber == stop.levelNumber) s,
    ];
    showDialog<void>(
      context: context,
      builder: (_) => _QuizPreviewDialog(
        stop: stop,
        position: levelStops.indexOf(stop) + 1,
        levelSize: levelStops.length,
        credits: credits,
        onStartQuiz: () {
          final callback = onQuizSelected;
          if (callback != null) {
            callback(quiz);
            return;
          }
          _snack(context, '${quiz.title} is not wired yet.');
        },
      ),
    );
  }

  static void _snack(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }
}

/// The first quiz stop that is unlocked but not yet finished — where the
/// user is on the road right now.
JourneyStop? _currentStop(List<JourneyStop> stops) {
  for (final stop in stops) {
    if (!stop.isChest && !stop.isLocked && !stop.isCompleted) {
      return stop;
    }
  }
  return null;
}

/// Copy and artwork for a level's card. Levels 1-4 have bespoke topic art;
/// boss levels share the graduation-cap art and everything else the gavel.
class _LevelTheme {
  const _LevelTheme(this.title, this.subtitle, this.asset, this.alignment);

  final String title;
  final String subtitle;
  final String asset;

  /// Where to anchor the cover-crop so the subject, not a bled-in edge from
  /// the source extraction, is what shows.
  final Alignment alignment;

  static _LevelTheme of(int level) {
    switch (level) {
      case 1:
        return const _LevelTheme(
          'Constitutional Law',
          'The fundamentals of India.',
          'assets/journey/topic_1.png',
          Alignment(0.6, 0),
        );
      case 2:
        return const _LevelTheme(
          'Indian Penal Code',
          'Offences, punishments and interpretation.',
          'assets/journey/topic_2.png',
          Alignment(0.2, 0.4),
        );
      case 3:
        return const _LevelTheme(
          'Criminal Procedure',
          'Investigation, trial and judicial process.',
          'assets/journey/topic_3.png',
          Alignment(0, -0.6),
        );
      case 4:
        return const _LevelTheme(
          'Law of Contract',
          'Agreements, obligations and remedies.',
          'assets/journey/topic_4.png',
          Alignment(0.4, 0),
        );
    }
    if (level % LeaderboardJourney.levelsPerCluster == 0) {
      return const _LevelTheme(
        'Boss Challenge',
        'Ten quizzes that test everything so far.',
        'assets/journey/topic_final.png',
        Alignment(0, -0.2),
      );
    }
    return const _LevelTheme(
      'Mixed Practice',
      "Sharpen what you've learned across topics.",
      'assets/journey/law_emblem.png',
      Alignment(0.3, 0),
    );
  }
}

class _JourneyHero extends StatelessWidget {
  const _JourneyHero({
    required this.stops,
    required this.current,
    required this.credits,
    required this.onContinue,
  });

  final List<JourneyStop> stops;
  final JourneyStop? current;
  final int credits;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    final quizzes = [
      for (final s in stops)
        if (!s.isChest) s,
    ];
    final done = quizzes.where((s) => s.isCompleted).length;
    final progress = quizzes.isEmpty ? 0.0 : done / quizzes.length;
    final current = this.current;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1C3657), JourneyPage.navy],
        ),
        boxShadow: [
          BoxShadow(
            color: JourneyPage.navy.withValues(alpha: 0.28),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Positioned(
            top: 0,
            right: 0,
            bottom: 0,
            width: 170,
            child: JourneyFadedArt(
              asset: 'assets/journey/law_emblem.png',
              alignment: const Alignment(0.2, 0),
              fadeBottom: false,
              opacity: 0.3,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                JourneyEyebrow(
                  current == null
                      ? (quizzes.isNotEmpty && done == quizzes.length
                            ? 'JOURNEY COMPLETE'
                            : 'LEARNING JOURNEY')
                      : 'LEVEL ${current.levelNumber} · IN PROGRESS',
                ),
                const SizedBox(height: 8),
                const Text(
                  'Your Learning Journey',
                  key: ValueKey('journey.title'),
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
                  'Master the law one stop at a time.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withValues(alpha: 0.72),
                  ),
                ),
                const SizedBox(height: 18),
                _ProgressBar(
                  value: progress,
                  track: Colors.white.withValues(alpha: 0.14),
                  height: 8,
                ),
                const SizedBox(height: 8),
                Text(
                  '$done of ${quizzes.length} quizzes · '
                  '${(progress * 100).round()}%',
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: Colors.white.withValues(alpha: 0.72),
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        key: const ValueKey('journey.startQuiz'),
                        onPressed: onContinue,
                        icon: const Icon(Icons.arrow_forward_rounded, size: 20),
                        iconAlignment: IconAlignment.end,
                        label: Text(
                          current == null ? 'Start Quiz' : 'Continue',
                          maxLines: 1,
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: JourneyPage.gold,
                          foregroundColor: JourneyPage.navy,
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
                    const SizedBox(width: 12),
                    JourneyCreditsPill(credits: credits),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProgressBar extends StatelessWidget {
  const _ProgressBar({
    required this.value,
    required this.track,
    this.height = 6,
  });

  final double value;
  final Color track;
  final double height;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(height),
      child: SizedBox(
        width: double.infinity,
        height: height,
        child: Stack(
          alignment: Alignment.centerLeft,
          children: [
            Positioned.fill(child: ColoredBox(color: track)),
            FractionallySizedBox(
              widthFactor: value.clamp(0.0, 1.0),
              child: const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFE9C271), JourneyPage.gold],
                  ),
                ),
                child: SizedBox.expand(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyJourney extends StatelessWidget {
  const _EmptyJourney();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: HomePage.cardBorder),
      ),
      child: const Column(
        children: [
          Icon(Icons.map_outlined, size: 40, color: JourneyPage.gold),
          SizedBox(height: 12),
          Text(
            'No journey quizzes yet — check back soon.',
            key: ValueKey('journey.empty'),
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: HomePage.supportText),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// The map: one Stack, one continuous road painted behind every stop.
// ---------------------------------------------------------------------------

enum _PieceKind { start, level, quiz, chest, finish }

/// One laid-out element of the map, positioned in map coordinates.
class _Piece {
  _Piece(this.kind, this.center, {this.stop, this.level = 0, this.levelStops});

  final _PieceKind kind;
  final Offset center;
  final JourneyStop? stop;
  final int level;
  final List<JourneyStop>? levelStops;
}

class _JourneyMap extends StatelessWidget {
  const _JourneyMap({
    required this.stops,
    required this.current,
    required this.onQuizTapped,
    required this.onChestTapped,
  });

  final List<JourneyStop> stops;
  final JourneyStop? current;
  final ValueChanged<JourneyStop> onQuizTapped;
  final ValueChanged<JourneyStop> onChestTapped;

  static const _startHeight = 76.0;
  static const _cardHeight = 132.0;
  static const _cardGap = 22.0;
  static const _rowHeight = 124.0;
  static const _chestHeight = 190.0;
  static const _finishHeight = 250.0;
  static const nodeSize = 68.0;

  /// A sine wave sampled at eighths — the classic "road" swing, so each
  /// level's quizzes sweep out to one side and back.
  static const _wave = [0.0, 0.72, 1.0, 0.72, 0.0, -0.72, -1.0, -0.72];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final mid = width / 2;
        final swing = math.min((width - nodeSize) / 2 - 18, 118.0);
        final pieces = <_Piece>[];
        // Road waypoints and whether the user has reached each one yet.
        final road = <Offset>[];
        final reached = <bool>[];
        var y = 0.0;

        void waypoint(Offset point, bool isReached) {
          road.add(point);
          reached.add(isReached);
        }

        pieces.add(_Piece(_PieceKind.start, Offset(mid, 30)));
        waypoint(Offset(mid, 30), true);
        y = _startHeight;

        var levelIndex = 0;
        var i = 0;
        while (i < stops.length) {
          final stop = stops[i];
          if (stop.isChest) {
            final center = Offset(mid, y + 70);
            pieces.add(_Piece(_PieceKind.chest, center, stop: stop));
            waypoint(center, stop.isChestAvailable || stop.isChestOpened);
            y += _chestHeight;
            i++;
            continue;
          }

          final level = stop.levelNumber;
          final levelStops = <JourneyStop>[];
          while (i < stops.length &&
              !stops[i].isChest &&
              stops[i].levelNumber == level) {
            levelStops.add(stops[i]);
            i++;
          }

          final levelReached = !levelStops.first.isLocked;
          final cardTop = y + _cardGap;
          pieces.add(
            _Piece(
              _PieceKind.level,
              Offset(mid, cardTop + _cardHeight / 2),
              level: level,
              levelStops: levelStops,
            ),
          );
          waypoint(Offset(mid, cardTop + 10), levelReached);
          waypoint(Offset(mid, cardTop + _cardHeight - 10), levelReached);
          y = cardTop + _cardHeight + _cardGap;

          final side = levelIndex.isEven ? 1.0 : -1.0;
          for (final (n, quizStop) in levelStops.indexed) {
            final center = Offset(
              mid + side * swing * _wave[(n + 1) % _wave.length],
              y + _rowHeight / 2,
            );
            pieces.add(_Piece(_PieceKind.quiz, center, stop: quizStop));
            waypoint(center, !quizStop.isLocked);
            y += _rowHeight;
          }
          levelIndex++;
        }

        final allDone = stops.every((s) => s.isChest || s.isCompleted);
        final finishCenter = Offset(mid, y + 90);
        pieces.add(_Piece(_PieceKind.finish, finishCenter));
        waypoint(Offset(mid, y + 40), allDone);
        y += _finishHeight;

        final reachedUpTo = reached.lastIndexOf(true);

        return SizedBox(
          key: const ValueKey('journey.journeyPath'),
          height: y,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned.fill(
                child: CustomPaint(
                  painter: JourneyRoadPainter(
                    points: road,
                    reachedUpTo: reachedUpTo,
                  ),
                ),
              ),
              for (final piece in pieces) _place(piece, width),
            ],
          ),
        );
      },
    );
  }

  Widget _place(_Piece piece, double width) {
    switch (piece.kind) {
      case _PieceKind.start:
        return Positioned(
          left: 0,
          right: 0,
          top: piece.center.dy - 22,
          child: const Center(
            child: JourneyStartFlag(key: ValueKey('journey.startPin')),
          ),
        );
      case _PieceKind.level:
        return Positioned(
          left: 0,
          right: 0,
          top: piece.center.dy - _cardHeight / 2,
          height: _cardHeight,
          child: _LevelCard(level: piece.level, stops: piece.levelStops!),
        );
      case _PieceKind.quiz:
        final stop = piece.stop!;
        final isCurrent = identical(stop, current);
        return Positioned(
          left: piece.center.dx - 60,
          top: piece.center.dy - nodeSize / 2 - (isCurrent ? 34 : 0),
          width: 120,
          child: _QuizNode(
            stop: stop,
            isCurrent: isCurrent,
            onTap: () => onQuizTapped(stop),
          ),
        );
      case _PieceKind.chest:
        return Positioned(
          left: 0,
          right: 0,
          top: piece.center.dy - 62,
          child: Center(
            child: _ChestNode(
              stop: piece.stop!,
              onTap: () => onChestTapped(piece.stop!),
            ),
          ),
        );
      case _PieceKind.finish:
        final allDone = stops.every((s) => s.isChest || s.isCompleted);
        return Positioned(
          left: 0,
          right: 0,
          top: piece.center.dy - 64,
          child: _FinishMedal(achieved: allDone),
        );
    }
  }
}

class _LevelCard extends StatelessWidget {
  const _LevelCard({required this.level, required this.stops});

  final int level;
  final List<JourneyStop> stops;

  @override
  Widget build(BuildContext context) {
    final theme = _LevelTheme.of(level);
    final locked = stops.first.isLocked;
    final done = stops.where((s) => s.isCompleted).length;
    final complete = done == stops.length;
    final boss = stops.first.isBossLevel;

    return Semantics(
      container: true,
      label:
          'Level $level, ${theme.title}. '
          '${locked ? 'Locked' : '$done of ${stops.length} quizzes done'}.',
      child: Container(
        key: ValueKey('journey.level.$level'),
        decoration: BoxDecoration(
          color: const Color(0xFFFFFDFA),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: complete || boss
                ? JourneyPage.gold
                : const Color(0xFFEFE4D6),
            width: complete || boss ? 1.6 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF6B4A1F).withValues(alpha: 0.10),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            Positioned(
              top: 0,
              right: 0,
              bottom: 0,
              width: 132,
              child: JourneyFadedArt(
                asset: theme.asset,
                alignment: theme.alignment,
                locked: locked,
                opacity: locked ? 0.4 : 0.95,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
              child: Row(
                children: [
                  JourneyShield(number: level, locked: locked, boss: boss),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 60),
                      child: ExcludeSemantics(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              boss ? 'BOSS LEVEL $level' : 'LEVEL $level',
                              style: const TextStyle(
                                fontSize: 10.5,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 1.2,
                                color: JourneyPage.goldDeep,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              theme.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.2,
                                color: locked
                                    ? HomePage.mutedIcon
                                    : JourneyPage.navy,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              theme.subtitle,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 12,
                                height: 1.3,
                                color: HomePage.supportText,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                SizedBox(
                                  width: 72,
                                  child: _ProgressBar(
                                    value: done / stops.length,
                                    track: const Color(0xFFF0E6D9),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                if (locked)
                                  const Icon(
                                    Icons.lock_rounded,
                                    size: 13,
                                    color: HomePage.mutedIcon,
                                  )
                                else
                                  Text(
                                    complete
                                        ? 'Complete'
                                        : '$done/${stops.length}',
                                    style: const TextStyle(
                                      fontSize: 11.5,
                                      fontWeight: FontWeight.w700,
                                      color: JourneyPage.goldDeep,
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
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

/// A chunky, pressable 3D stop on the road. Gold with a tick once done,
/// navy with a star (a crown on boss levels) for the stop you're on, stone
/// with a padlock while locked. The current stop also carries a floating
/// "START" tag and a soft halo so it's findable at a glance.
class _QuizNode extends StatefulWidget {
  const _QuizNode({
    required this.stop,
    required this.isCurrent,
    required this.onTap,
  });

  final JourneyStop stop;
  final bool isCurrent;
  final VoidCallback onTap;

  @override
  State<_QuizNode> createState() => _QuizNodeState();
}

class _QuizNodeState extends State<_QuizNode> {
  var _pressed = false;

  static const _size = _JourneyMap.nodeSize;
  static const _depth = 6.0;

  @override
  Widget build(BuildContext context) {
    final stop = widget.stop;
    final quiz = stop.quiz!;

    final Color face;
    final Color edge;
    final Widget glyph;
    if (stop.isCompleted) {
      face = JourneyPage.gold;
      edge = JourneyPage.goldDeep;
      glyph = const Icon(Icons.check_rounded, size: 34, color: Colors.white);
    } else if (stop.isLocked) {
      face = JourneyPage.lockedFace;
      edge = JourneyPage.lockedEdge;
      glyph = const Icon(
        Icons.lock_rounded,
        size: 24,
        color: Color(0xFFA99D8D),
      );
    } else {
      face = JourneyPage.navy;
      edge = const Color(0xFF07111F);
      glyph = Icon(
        stop.isBossLevel ? Icons.workspace_premium_rounded : Icons.star_rounded,
        size: 34,
        color: JourneyPage.gold,
      );
    }

    final state = stop.isCompleted
        ? 'completed'
        : stop.isLocked
        ? 'locked'
        : 'ready to play';

    final button = GestureDetector(
      key: ValueKey('journey.node.${quiz.slug}'),
      behavior: HitTestBehavior.opaque,
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      onTap: () {
        Motion.tick();
        widget.onTap();
      },
      child: SizedBox(
        width: _size + 20,
        height: _size + _depth + 4,
        child: Stack(
          alignment: Alignment.topCenter,
          clipBehavior: Clip.none,
          children: [
            if (widget.isCurrent)
              Positioned(
                top: -6,
                child: Container(
                  width: _size + 16,
                  height: _size + 16,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: JourneyPage.gold.withValues(alpha: 0.22),
                  ),
                ),
              ),
            Positioned(
              top: _depth,
              child: _disc(edge, null, stop.isBossLevel && !stop.isLocked),
            ),
            AnimatedPositioned(
              duration: Motion.duration(context, Motion.fast),
              top: _pressed ? _depth - 2 : 0,
              child: _disc(face, glyph, stop.isBossLevel && !stop.isLocked),
            ),
          ],
        ),
      ),
    );

    return Semantics(
      button: true,
      label: 'Level ${stop.levelNumber} quiz, $state',
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.isCurrent) ...[
            const _StartTag(),
            const SizedBox(height: 6),
          ],
          button,
        ],
      ),
    );
  }

  Widget _disc(Color color, Widget? glyph, bool bossRing) {
    return Container(
      width: _size,
      height: _size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        border: bossRing
            ? Border.all(color: const Color(0xFFF3D58C), width: 3)
            : null,
      ),
      alignment: Alignment.center,
      child: glyph,
    );
  }
}

class _StartTag extends StatelessWidget {
  const _StartTag();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: JourneyPage.gold, width: 1.6),
            boxShadow: [
              BoxShadow(
                color: JourneyPage.navy.withValues(alpha: 0.12),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: const Text(
            'START',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.2,
              color: JourneyPage.navy,
            ),
          ),
        ),
        CustomPaint(size: const Size(12, 6), painter: const _TagPointer()),
      ],
    );
  }
}

class _TagPointer extends CustomPainter {
  const _TagPointer();

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width / 2, size.height)
      ..close();
    canvas.drawPath(path, Paint()..color = JourneyPage.gold);
  }

  @override
  bool shouldRepaint(covariant _TagPointer old) => false;
}

/// A chest sitting on the road after every five-level cluster: greyed until
/// that cluster is finished, glowing with its reward while it can be
/// opened, and marked once claimed so it can't be farmed.
class _ChestNode extends StatelessWidget {
  const _ChestNode({required this.stop, required this.onTap});

  final JourneyStop stop;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final available = stop.isChestAvailable;
    final opened = stop.isChestOpened;

    Widget chest = Image.asset(
      'assets/journey/chest_${(stop.chestIndex! % 4) + 1}.png',
      width: 92,
      height: 92,
      fit: BoxFit.contain,
      filterQuality: FilterQuality.high,
      excludeFromSemantics: true,
    );
    // Faded rather than greyscaled: desaturating this low-res art turns its
    // gold highlights into speckle.
    if (!available && !opened) {
      chest = Opacity(opacity: 0.5, child: chest);
    }

    final label = opened
        ? 'Opened'
        : available
        ? 'Open · +${LeaderboardProgressStore.chestReward}'
        : 'Locked · +${LeaderboardProgressStore.chestReward}';

    return Semantics(
      button: true,
      label:
          'Treasure chest, ${opened
              ? 'opened'
              : available
              ? 'ready to open'
              : 'locked'}',
      child: GestureDetector(
        key: ValueKey('journey.chest.${stop.chestIndex}'),
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: SizedBox(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 124,
                height: 124,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFFFFDFA),
                  border: Border.all(
                    color: available
                        ? JourneyPage.gold
                        : const Color(0xFFEFE4D6),
                    width: available ? 3 : 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: available
                          ? JourneyPage.gold.withValues(alpha: 0.45)
                          : const Color(0xFF6B4A1F).withValues(alpha: 0.10),
                      blurRadius: available ? 28 : 16,
                      spreadRadius: available ? 2 : 0,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: chest,
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: available ? JourneyPage.navy : const Color(0xFFF3EADF),
                  borderRadius: BorderRadius.circular(99),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      opened ? Icons.check_rounded : Icons.bolt_rounded,
                      size: 14,
                      color: available ? JourneyPage.gold : HomePage.mutedIcon,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: available ? Colors.white : HomePage.supportText,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FinishMedal extends StatelessWidget {
  const _FinishMedal({required this.achieved});

  final bool achieved;

  @override
  Widget build(BuildContext context) {
    Widget cap = Image.asset(
      'assets/journey/topic_final.png',
      fit: BoxFit.contain,
      filterQuality: FilterQuality.high,
      excludeFromSemantics: true,
    );
    if (!achieved) {
      cap = ColorFiltered(colorFilter: journeyGreyscale, child: cap);
    }

    return Column(
      key: const ValueKey('journey.finish'),
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 128,
          height: 128,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFFFFFDFA),
            border: Border.all(color: JourneyPage.gold, width: 4),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF6B4A1F).withValues(alpha: 0.16),
                blurRadius: 24,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: cap,
        ),
        Transform.translate(
          offset: const Offset(0, -16),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
            decoration: BoxDecoration(
              color: JourneyPage.navy,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: JourneyPage.gold, width: 2),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.emoji_events_rounded,
                  size: 20,
                  color: JourneyPage.gold,
                ),
                SizedBox(width: 8),
                Text(
                  'FINISH',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 2,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
        Text(
          achieved
              ? 'You are a Law Master!'
              : 'Reach the end to become a Law Master',
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 12.5,
            fontWeight: FontWeight.w600,
            color: HomePage.supportText,
          ),
        ),
      ],
    );
  }
}

/// The card shown when a quiz stop is tapped: where it sits in its level,
/// what it costs and what's left afterwards, before committing to it.
class _QuizPreviewDialog extends StatelessWidget {
  const _QuizPreviewDialog({
    required this.stop,
    required this.position,
    required this.levelSize,
    required this.credits,
    required this.onStartQuiz,
  });

  final JourneyStop stop;
  final int position;
  final int levelSize;
  final int credits;
  final VoidCallback onStartQuiz;

  bool get _canAfford => credits >= LeaderboardProgressStore.quizCost;

  @override
  Widget build(BuildContext context) {
    final quiz = stop.quiz!;
    final theme = _LevelTheme.of(stop.levelNumber);

    return Dialog(
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: 112,
            child: Stack(
              children: [
                const Positioned.fill(
                  child: ColoredBox(color: Color(0xFFFFFAF3)),
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  bottom: 0,
                  width: 200,
                  child: JourneyFadedArt(
                    asset: theme.asset,
                    alignment: theme.alignment,
                  ),
                ),
                Positioned(
                  left: 20,
                  top: 20,
                  child: JourneyShield(
                    number: stop.levelNumber,
                    boss: stop.isBossLevel,
                  ),
                ),
                Positioned(
                  top: 4,
                  right: 4,
                  child: IconButton(
                    key: const ValueKey('journey.preview.close'),
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(
                      Icons.close_rounded,
                      color: JourneyPage.navy,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${stop.isBossLevel ? 'BOSS LEVEL' : 'LEVEL'} '
                  '${stop.levelNumber} · QUIZ $position OF $levelSize',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.1,
                    color: JourneyPage.goldDeep,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  quiz.title,
                  style: const TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.3,
                    color: JourneyPage.navy,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  theme.title,
                  style: const TextStyle(
                    fontSize: 13,
                    color: HomePage.supportText,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _PreviewStat(
                        icon: Icons.help_outline_rounded,
                        value: '${quiz.totalQuestions}',
                        label: 'Questions',
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _PreviewStat(
                        icon: Icons.bolt_rounded,
                        value: '${LeaderboardProgressStore.quizCost}',
                        label: 'Cost',
                        alert: !_canAfford,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _PreviewStat(
                        icon: Icons.account_balance_wallet_outlined,
                        value: _canAfford
                            ? '${credits - LeaderboardProgressStore.quizCost}'
                            : '$credits',
                        label: _canAfford ? 'Left after' : 'You have',
                        alert: !_canAfford,
                      ),
                    ),
                  ],
                ),
                if (!_canAfford) ...[
                  const SizedBox(height: 12),
                  Text(
                    'Not enough credits — they refill by '
                    '${LeaderboardProgressStore.regenAmount} every '
                    '${LeaderboardProgressStore.regenInterval.inHours} hours.',
                    style: const TextStyle(
                      fontSize: 12.5,
                      color: Color(0xFFC0392B),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    key: const ValueKey('journey.preview.start'),
                    onPressed: _canAfford
                        ? () {
                            Navigator.of(context).pop();
                            onStartQuiz();
                          }
                        : null,
                    icon: const Icon(Icons.play_arrow_rounded, size: 22),
                    label: Text(
                      _canAfford ? 'Start Quiz' : 'Not Enough Credits',
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: JourneyPage.navy,
                      disabledBackgroundColor: HomePage.cardBorder,
                      foregroundColor: Colors.white,
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
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    key: const ValueKey('journey.preview.cancel'),
                    onPressed: () => Navigator.of(context).pop(),
                    style: TextButton.styleFrom(
                      foregroundColor: HomePage.supportText,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text(
                      'Maybe later',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PreviewStat extends StatelessWidget {
  const _PreviewStat({
    required this.icon,
    required this.value,
    required this.label,
    this.alert = false,
  });

  final IconData icon;
  final String value;
  final String label;
  final bool alert;

  @override
  Widget build(BuildContext context) {
    final tint = alert ? const Color(0xFFC0392B) : JourneyPage.navy;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      decoration: BoxDecoration(
        color: alert ? const Color(0xFFFDF0EE) : const Color(0xFFFBF5EC),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Icon(icon, size: 18, color: alert ? tint : JourneyPage.goldDeep),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w800,
              color: tint,
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: HomePage.supportText,
            ),
          ),
        ],
      ),
    );
  }
}
