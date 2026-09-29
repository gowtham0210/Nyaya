import 'package:flutter/material.dart';

import '../../../app/api_client.dart';
import '../../../app/user_api.dart';
import '../../../core/presentation/motion.dart';
import '../../home/presentation/home_page.dart';
import '../../home/presentation/home_view_model.dart';
import 'journey_widgets.dart';
import 'leaderboard_view_model.dart';

enum _Board { topLearners, weekly, monthly }

extension on _Board {
  String get period => this == _Board.weekly ? 'weekly' : 'monthly';
  String get label => this == _Board.weekly ? 'Weekly' : 'Monthly';
}

/// Home's "Leaderboard" tab: learners ranked by points — a banner, a
/// Top Learners / Weekly / Monthly switch, a podium for the top three and a
/// ranked list for everyone after.
///
/// Top Learners renders from [viewModel], fetched once by the caller
/// alongside the rest of the app's stats. Weekly and Monthly are fetched
/// separately, on demand the first time each tab is opened, since showing
/// them eagerly would mean two extra backend calls most sessions never
/// need.
class LeaderboardPage extends StatefulWidget {
  const LeaderboardPage({
    super.key,
    this.viewModel,
    this.onBackPressed,
    this.onProfilePressed,
    this.onNavigationSelected,
    this.userApi,
  });

  /// Defaults to a [LeaderboardViewModel] over local history — the sample
  /// ranking — when no live stats are passed in.
  final LeaderboardViewModel? viewModel;
  final VoidCallback? onBackPressed;
  final VoidCallback? onProfilePressed;
  final ValueChanged<int>? onNavigationSelected;

  /// Overridden in tests; defaults to a real [UserApi] for the Weekly and
  /// Monthly boards.
  final UserApi? userApi;

  static const _activeNavigationIndex = 2;

  @override
  State<LeaderboardPage> createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage> {
  var _board = _Board.topLearners;
  late final _userApi = widget.userApi ?? UserApi();

  /// Weekly/Monthly entries fetched so far, keyed by board; absent until
  /// that tab has been opened at least once.
  final _periodEntries = <_Board, List<LeaderboardEntry>>{};
  _Board? _loadingBoard;
  String? _periodError;

  void _snack(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  void _selectBoard(_Board board) {
    Motion.tick();
    setState(() => _board = board);
    if (board != _Board.topLearners && !_periodEntries.containsKey(board)) {
      _loadPeriod(board);
    }
  }

  Future<void> _loadPeriod(_Board board) async {
    setState(() {
      _loadingBoard = board;
      _periodError = null;
    });
    try {
      final remote = await _userApi.fetchPeriodLeaderboard(board.period);
      if (!mounted) {
        return;
      }
      setState(() {
        _periodEntries[board] = LeaderboardViewModel.entriesFromRemote(
          remote,
          widget.viewModel?.currentUserId,
        );
        _loadingBoard = null;
      });
    } on ApiException {
      if (!mounted) {
        return;
      }
      setState(() {
        _periodError = "Couldn't load the ${board.label} ranking.";
        _loadingBoard = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = widget.viewModel ?? LeaderboardViewModel();
    final periodEntries = _periodEntries[_board];
    final entries = _board == _Board.topLearners
        ? viewModel.entries
        : periodEntries ?? const <LeaderboardEntry>[];
    final podium = entries.length >= 3
        ? entries.take(3).toList()
        : const <LeaderboardEntry>[];
    final remaining = entries.length >= 3 ? entries.skip(3).toList() : entries;
    final isTopLearners = _board == _Board.topLearners;
    final isLoadingPeriod = _loadingBoard == _board;
    final periodHasNoData =
        !isTopLearners && !isLoadingPeriod && (periodEntries?.isEmpty ?? false);

    return Scaffold(
      backgroundColor: JourneyColors.pageBackground,
      bottomNavigationBar: HomeBottomNavigationBar(
        items: const HomeViewModel().navigationItems,
        activeIndex: LeaderboardPage._activeNavigationIndex,
        onSelected: (index) {
          final callback = widget.onNavigationSelected;
          if (callback != null) {
            callback(index);
            return;
          }
          if (index == LeaderboardPage._activeNavigationIndex) {
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
              backKey: const ValueKey('leaderboard.back'),
              onBackPressed: () {
                final callback = widget.onBackPressed;
                if (callback != null) {
                  callback();
                  return;
                }
                Navigator.of(context).maybePop();
              },
              onProfilePressed:
                  widget.onProfilePressed ??
                  () => _snack('Profile lives on the bottom nav for now.'),
            ),
            Expanded(
              child: ListView(
                key: const ValueKey('leaderboard.scroll'),
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                children: [
                  const FadeSlideIn(child: _Banner()),
                  const SizedBox(height: 14),
                  _BoardSwitch(selected: _board, onChanged: _selectBoard),
                  if (isLoadingPeriod)
                    const _PeriodMessage.loading()
                  else if (_periodError != null)
                    _PeriodMessage.error(
                      message: _periodError!,
                      onRetry: () => _loadPeriod(_board),
                    )
                  else if (periodHasNoData)
                    _PeriodMessage.empty(
                      board: _board,
                      onShowTopLearners: () =>
                          setState(() => _board = _Board.topLearners),
                    )
                  else ...[
                    if (isTopLearners && !viewModel.isLive)
                      const _SampleNote(),
                    if (podium.isNotEmpty) ...[
                      const SizedBox(height: 18),
                      FadeSlideIn(
                        delay: Motion.stagger,
                        child: _Podium(entries: podium),
                      ),
                    ],
                    const SizedBox(height: 14),
                    for (final (i, entry) in remaining.indexed)
                      FadeSlideIn(
                        delay: Motion.stagger * (i.clamp(0, 8) + 2),
                        child: _RankRow(
                          entry: entry,
                          onTap: () => _snack(
                            entry.isCurrentUser
                                ? 'This is you — keep playing to climb!'
                                : 'Learner profiles are coming soon.',
                          ),
                        ),
                      ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Banner extends StatelessWidget {
  const _Banner();

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      // Sized to the banner artwork's own aspect ratio (2170x725) so the
      // full image shows — a fixed height with BoxFit.cover cropped its
      // sides, cutting off the "L" in "Leaderboard". Ratio-based sizing
      // still gives the banner a real height as soon as its width is
      // known, without waiting on the image to decode.
      child: AspectRatio(
        aspectRatio: 2170 / 725,
        child: Image.asset(
          'assets/journey/leaderboard_banner.png',
          key: const ValueKey('leaderboard.banner'),
          fit: BoxFit.cover,
          width: double.infinity,
        ),
      ),
    );
  }
}

class _BoardSwitch extends StatelessWidget {
  const _BoardSwitch({required this.selected, required this.onChanged});

  final _Board selected;
  final ValueChanged<_Board> onChanged;

  @override
  Widget build(BuildContext context) {
    Widget segment(_Board board, String label, IconData icon, String key) {
      final active = board == selected;
      return Expanded(
        child: Semantics(
          selected: active,
          button: true,
          child: GestureDetector(
            key: ValueKey('leaderboard.tab.$key'),
            behavior: HitTestBehavior.opaque,
            onTap: () => onChanged(board),
            child: AnimatedContainer(
              duration: Motion.duration(context, Motion.fast),
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: active ? JourneyColors.navy : Colors.transparent,
                borderRadius: BorderRadius.circular(99),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    icon,
                    size: 18,
                    color: active ? JourneyColors.gold : JourneyColors.goldDeep,
                  ),
                  const SizedBox(width: 6),
                  Flexible(
                    child: Text(
                      label,
                      maxLines: 1,
                      overflow: TextOverflow.fade,
                      softWrap: false,
                      style: TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w700,
                        color: active ? Colors.white : JourneyColors.navy,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: JourneyColors.card,
        borderRadius: BorderRadius.circular(99),
        border: Border.all(color: JourneyColors.cardBorder),
      ),
      child: Row(
        children: [
          segment(
            _Board.topLearners,
            'Top Learners',
            Icons.emoji_events_outlined,
            'top',
          ),
          segment(
            _Board.weekly,
            'Weekly',
            Icons.calendar_view_week_outlined,
            'weekly',
          ),
          segment(
            _Board.monthly,
            'Monthly',
            Icons.calendar_month_outlined,
            'monthly',
          ),
        ],
      ),
    );
  }
}

class _SampleNote extends StatelessWidget {
  const _SampleNote();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      key: ValueKey('leaderboard.sampleNote'),
      padding: EdgeInsets.only(top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.info_outline_rounded, size: 14, color: HomePage.mutedIcon),
          SizedBox(width: 6),
          Flexible(
            child: Text(
              'Sample rankings — finish a quiz online to see live standings.',
              style: TextStyle(fontSize: 11.5, color: HomePage.supportText),
            ),
          ),
        ],
      ),
    );
  }
}

/// Per-rank palette for the podium, matching the medal each place earns.
class _PodiumStyle {
  const _PodiumStyle(this.card, this.base, this.badge);

  final Color card;
  final Color base;
  final Color badge;

  static _PodiumStyle of(int rank) => switch (rank) {
    1 => const _PodiumStyle(
      Color(0xFFEAF4E6),
      Color(0xFFA8D3A0),
      JourneyColors.gold,
    ),
    2 => const _PodiumStyle(
      Color(0xFFE8EFF8),
      Color(0xFFB9CBE3),
      Color(0xFF6B7A90),
    ),
    _ => const _PodiumStyle(
      Color(0xFFF0EAFB),
      Color(0xFFCBB9EC),
      Color(0xFF8B6CCB),
    ),
  };
}

class _Podium extends StatelessWidget {
  const _Podium({required this.entries});

  /// Ranks 1-3, in rank order.
  final List<LeaderboardEntry> entries;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(flex: 5, child: _PodiumCard(entry: entries[1])),
        const SizedBox(width: 8),
        Expanded(flex: 6, child: _PodiumCard(entry: entries[0], first: true)),
        const SizedBox(width: 8),
        Expanded(flex: 5, child: _PodiumCard(entry: entries[2])),
      ],
    );
  }
}

class _PodiumCard extends StatelessWidget {
  const _PodiumCard({required this.entry, this.first = false});

  final LeaderboardEntry entry;
  final bool first;

  @override
  Widget build(BuildContext context) {
    final style = _PodiumStyle.of(entry.rank);
    final avatarSize = first ? 74.0 : 58.0;

    return Semantics(
      container: true,
      label:
          'Rank ${entry.rank}, ${entry.name}, level ${entry.level}, '
          '${entry.points} points',
      child: ExcludeSemantics(
        child: Column(
          key: ValueKey('leaderboard.podium.${entry.rank}'),
          mainAxisSize: MainAxisSize.min,
          children: [
            if (first)
              const Icon(
                Icons.emoji_events_rounded,
                size: 30,
                color: JourneyColors.gold,
              ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(6, first ? 14 : 10, 6, 10),
              decoration: BoxDecoration(
                color: style.card,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(18),
                ),
                border: entry.isCurrentUser
                    ? Border.all(color: JourneyColors.gold, width: 1.6)
                    : null,
              ),
              child: Column(
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      _Avatar(
                        entry: entry,
                        size: avatarSize,
                        ring: style.badge,
                      ),
                      Positioned(
                        left: -4,
                        top: -4,
                        child: Container(
                          width: first ? 26 : 22,
                          height: first ? 26 : 22,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: style.badge,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: Text(
                            '${entry.rank}',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    entry.isCurrentUser ? 'You' : entry.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'serif',
                      fontSize: first ? 14 : 12.5,
                      fontWeight: FontWeight.w700,
                      color: JourneyColors.navy,
                    ),
                  ),
                  const SizedBox(height: 4),
                  _LevelChip(level: entry.level, tint: style.base),
                  const SizedBox(height: 6),
                  // Side podium cards are narrow; shrink rather than clip a
                  // large score or a large system font.
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: _Points(points: entry.points, compact: true),
                  ),
                ],
              ),
            ),
            Container(
              height: first ? 16 : 8,
              decoration: BoxDecoration(
                color: style.base,
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RankRow extends StatelessWidget {
  const _RankRow({required this.entry, required this.onTap});

  final LeaderboardEntry entry;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final you = entry.isCurrentUser;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: you ? const Color(0xFFFFF4DC) : JourneyColors.card,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: you ? JourneyColors.gold : JourneyColors.cardBorder,
            width: you ? 1.4 : 1,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          key: ValueKey('leaderboard.row.${entry.rank}'),
          onTap: onTap,
          child: Semantics(
            container: true,
            label:
                'Rank ${entry.rank}, ${you ? 'you' : entry.name}, '
                'level ${entry.level}, ${entry.points} points',
            child: ExcludeSemantics(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 9, 4, 9),
                child: Row(
                  children: [
                    SizedBox(
                      width: 28,
                      child: Text(
                        '${entry.rank}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontFamily: 'serif',
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: JourneyColors.navy,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    _Avatar(entry: entry, size: 42),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  entry.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontFamily: 'serif',
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: JourneyColors.navy,
                                  ),
                                ),
                              ),
                              if (you) ...[
                                const SizedBox(width: 6),
                                const _YouTag(),
                              ],
                            ],
                          ),
                          const SizedBox(height: 3),
                          _LevelChip(level: entry.level),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    _Points(points: entry.points),
                    const Icon(
                      Icons.chevron_right_rounded,
                      color: HomePage.mutedIcon,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.entry, required this.size, this.ring});

  final LeaderboardEntry entry;
  final double size;
  final Color? ring;

  @override
  Widget build(BuildContext context) {
    final color = entry.avatarColor;
    return Container(
      width: size,
      height: size,
      padding: EdgeInsets.all(ring == null ? 0 : 3),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: ring ?? Colors.transparent,
      ),
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: ring == null
              ? null
              : Border.all(color: Colors.white, width: 2),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color.lerp(color, Colors.white, 0.25)!, color],
          ),
        ),
        child: Text(
          entry.initials,
          style: TextStyle(
            fontSize: size * 0.34,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class _LevelChip extends StatelessWidget {
  const _LevelChip({required this.level, this.tint});

  final int level;
  final Color? tint;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 2),
      decoration: BoxDecoration(
        color: (tint ?? const Color(0xFFD9D4CC)).withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(99),
      ),
      child: Text(
        'Level $level',
        style: const TextStyle(
          fontSize: 10.5,
          fontWeight: FontWeight.w600,
          color: JourneyColors.navy,
        ),
      ),
    );
  }
}

class _Points extends StatelessWidget {
  const _Points({required this.points, this.compact = false});

  final int points;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          Icons.bolt_rounded,
          size: compact ? 15 : 20,
          color: JourneyColors.gold,
        ),
        Text(
          '$points',
          style: TextStyle(
            fontSize: compact ? 11.5 : 16,
            fontWeight: FontWeight.w800,
            color: JourneyColors.navy,
          ),
        ),
        Text(
          compact ? ' pts' : ' points',
          style: TextStyle(
            fontSize: compact ? 10.5 : 13,
            color: HomePage.supportText,
          ),
        ),
      ],
    );
  }
}

class _YouTag extends StatelessWidget {
  const _YouTag();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 1),
      decoration: BoxDecoration(
        color: JourneyColors.navy,
        borderRadius: BorderRadius.circular(99),
      ),
      child: const Text(
        'YOU',
        style: TextStyle(
          fontSize: 9.5,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.8,
          color: JourneyColors.gold,
        ),
      ),
    );
  }
}

/// The Weekly/Monthly board's non-data states: a spinner while it loads, a
/// retry prompt if the fetch failed, or a nudge back to Top Learners if the
/// window genuinely has no activity yet.
class _PeriodMessage extends StatelessWidget {
  const _PeriodMessage.loading()
    : _icon = null,
      _title = 'Loading the ranking…',
      _subtitle = null,
      _actionLabel = null,
      _onAction = null;

  const _PeriodMessage.error({required String message, required VoidCallback onRetry})
    : _icon = Icons.cloud_off_rounded,
      _title = message,
      _subtitle = null,
      _actionLabel = 'Try again',
      _onAction = onRetry;

  _PeriodMessage.empty({required _Board board, required VoidCallback onShowTopLearners})
    : _icon = board == _Board.weekly
          ? Icons.calendar_view_week_rounded
          : Icons.calendar_month_rounded,
      _title = 'No ${board.label.toLowerCase()} activity yet',
      _subtitle =
          'Finish a quiz to appear here. Until then, the all-time Top '
          'Learners board shows where you stand.',
      _actionLabel = 'View Top Learners',
      _onAction = onShowTopLearners;

  final IconData? _icon;
  final String _title;
  final String? _subtitle;
  final String? _actionLabel;
  final VoidCallback? _onAction;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const ValueKey('leaderboard.empty'),
      margin: const EdgeInsets.only(top: 18),
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
      decoration: BoxDecoration(
        color: JourneyColors.card,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: JourneyColors.cardBorder),
      ),
      child: Column(
        children: [
          if (_icon == null)
            const SizedBox(
              width: 32,
              height: 32,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                color: JourneyColors.gold,
              ),
            )
          else
            Icon(_icon, size: 40, color: JourneyColors.gold),
          const SizedBox(height: 12),
          Text(
            _title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'serif',
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: JourneyColors.navy,
            ),
          ),
          if (_subtitle != null) ...[
            const SizedBox(height: 6),
            Text(
              _subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 13, color: HomePage.supportText),
            ),
          ],
          if (_actionLabel != null) ...[
            const SizedBox(height: 16),
            TextButton(
              onPressed: _onAction,
              style: TextButton.styleFrom(
                foregroundColor: JourneyColors.goldDeep,
              ),
              child: Text(
                _actionLabel,
                style: const TextStyle(fontWeight: FontWeight.w800),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
