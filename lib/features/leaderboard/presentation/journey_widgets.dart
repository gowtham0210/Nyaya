import 'dart:async';
import 'dart:math' as math;
import 'dart:ui' show PathMetric;

import 'package:flutter/material.dart';

import '../../../app/leaderboard_progress_store.dart';
import '../../../core/presentation/widgets/nyaya_widgets.dart';
import '../../home/presentation/home_page.dart';

/// The visual language shared by the Leaderboard journey and the Quizzes
/// page: a warm parchment page, navy and gold, and a code-drawn road.
class JourneyColors {
  JourneyColors._();

  static const navy = HomePage.heroBackground;
  static const gold = HomePage.heroHighlight;
  static const goldDeep = Color(0xFFB9862B);
  static const pageBackground = Color(0xFFFBF3EA);
  static const card = Color(0xFFFFFDFA);
  static const cardBorder = Color(0xFFEFE4D6);
  static const road = Color(0xFFEBDDCB);
  static const lockedFace = Color(0xFFE7DFD4);
  static const lockedEdge = Color(0xFFCFC3B3);
}

/// Desaturates locked artwork rather than fading it, so it reads as
/// locked instead of missing.
const journeyGreyscale = ColorFilter.matrix(<double>[
  0.2126,
  0.7152,
  0.0722,
  0,
  0,
  0.2126,
  0.7152,
  0.0722,
  0,
  0,
  0.2126,
  0.7152,
  0.0722,
  0,
  0,
  0,
  0,
  0,
  1,
  0,
]);

class JourneyHeader extends StatelessWidget {
  const JourneyHeader({
    super.key,
    required this.backKey,
    required this.onBackPressed,
    this.onProfilePressed,
  });

  final Key backKey;
  final VoidCallback onBackPressed;

  /// Shows a profile button at the end of the bar when set.
  final VoidCallback? onProfilePressed;

  static void _snack(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 6, 8, 4),
      child: Row(
        children: [
          IconButton(
            key: backKey,
            onPressed: onBackPressed,
            icon: const Icon(
              Icons.arrow_back_rounded,
              color: JourneyColors.navy,
            ),
          ),
          Image.asset(
            logoAsset,
            width: 30,
            height: 30,
            fit: BoxFit.contain,
            excludeFromSemantics: true,
          ),
          const SizedBox(width: 8),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'NYAYA',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.2,
                    color: JourneyColors.navy,
                  ),
                ),
                Text(
                  'LAW BASED QUIZ APP',
                  style: TextStyle(
                    fontSize: 8,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.8,
                    color: JourneyColors.goldDeep,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: 'Search',
            onPressed: () => _snack(context, 'Search is not wired yet.'),
            icon: const Icon(Icons.search_rounded, color: JourneyColors.navy),
          ),
          IconButton(
            tooltip: 'Notifications',
            onPressed: () =>
                _snack(context, 'Notifications live on Home for now.'),
            icon: const Icon(
              Icons.notifications_none_rounded,
              color: JourneyColors.navy,
            ),
          ),
          if (onProfilePressed != null)
            IconButton(
              tooltip: 'Profile',
              onPressed: onProfilePressed,
              icon: Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: JourneyColors.gold, width: 1.6),
                ),
                child: const Icon(
                  Icons.person_rounded,
                  size: 20,
                  color: JourneyColors.navy,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class JourneyEyebrow extends StatelessWidget {
  const JourneyEyebrow(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: JourneyColors.gold.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(99),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 10.5,
          fontWeight: FontWeight.w800,
          letterSpacing: 1.1,
          color: JourneyColors.gold,
        ),
      ),
    );
  }
}

/// An illustration cover-cropped into its box with its left and bottom
/// edges faded out, so the rough edges of the source extraction melt into
/// whatever card it sits on.
class JourneyFadedArt extends StatelessWidget {
  const JourneyFadedArt({
    super.key,
    required this.asset,
    required this.alignment,
    this.fadeBottom = true,
    this.opacity = 1,
    this.locked = false,
  });

  final String asset;
  final Alignment alignment;
  final bool fadeBottom;
  final double opacity;
  final bool locked;

  @override
  Widget build(BuildContext context) {
    Widget art = Image.asset(
      asset,
      fit: BoxFit.cover,
      alignment: alignment,
      excludeFromSemantics: true,
      filterQuality: FilterQuality.high,
    );
    if (locked) {
      art = ColorFiltered(colorFilter: journeyGreyscale, child: art);
    }
    art = ShaderMask(
      blendMode: BlendMode.dstIn,
      shaderCallback: (rect) => const LinearGradient(
        colors: [Colors.transparent, Colors.black],
        stops: [0, 0.55],
      ).createShader(rect),
      child: art,
    );
    if (fadeBottom) {
      art = ShaderMask(
        blendMode: BlendMode.dstIn,
        shaderCallback: (rect) => const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.black, Colors.black, Colors.transparent],
          stops: [0, 0.7, 1],
        ).createShader(rect),
        child: art,
      );
    }
    return Opacity(opacity: opacity, child: art);
  }
}

/// A smooth Catmull-Rom road through every waypoint: a soft beige bed, the
/// stretch already travelled overlaid in gold, and a dashed centre line on
/// what's still ahead.
class JourneyRoadPainter extends CustomPainter {
  const JourneyRoadPainter({required this.points, required this.reachedUpTo});

  final List<Offset> points;
  final int reachedUpTo;

  static const _width = 20.0;

  Path _through(int last) {
    final path = Path()..moveTo(points.first.dx, points.first.dy);
    for (var i = 0; i < last; i++) {
      final p0 = points[math.max(i - 1, 0)];
      final p1 = points[i];
      final p2 = points[i + 1];
      final p3 = points[math.min(i + 2, points.length - 1)];
      final c1 = p1 + (p2 - p0) / 6;
      final c2 = p2 - (p3 - p1) / 6;
      path.cubicTo(c1.dx, c1.dy, c2.dx, c2.dy, p2.dx, p2.dy);
    }
    return path;
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (points.length < 2) {
      return;
    }
    final full = _through(points.length - 1);

    Paint stroke(Color color, double width) => Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = width
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    // Soft drop shadow, then the road bed.
    canvas.drawPath(
      full.shift(const Offset(0, 4)),
      stroke(const Color(0x14000000), _width + 4),
    );
    canvas.drawPath(full, stroke(JourneyColors.road, _width));

    if (reachedUpTo > 0) {
      canvas.drawPath(
        _through(reachedUpTo),
        stroke(JourneyColors.gold, _width),
      );
    }

    // Dashed centre line along the road still ahead.
    final dash = stroke(Colors.white.withValues(alpha: 0.9), 3);
    final aheadStart = reachedUpTo <= 0
        ? 0.0
        : _through(
            reachedUpTo,
          ).computeMetrics().fold<double>(0, (sum, m) => sum + m.length);
    var travelled = 0.0;
    for (final PathMetric metric in full.computeMetrics()) {
      var d = math.max(0.0, aheadStart - travelled);
      while (d < metric.length) {
        canvas.drawPath(
          metric.extractPath(d, math.min(d + 10, metric.length)),
          dash,
        );
        d += 22;
      }
      travelled += metric.length;
    }
  }

  @override
  bool shouldRepaint(covariant JourneyRoadPainter old) =>
      old.reachedUpTo != reachedUpTo || old.points != points;
}

class JourneyStartFlag extends StatelessWidget {
  const JourneyStartFlag({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 10, 18, 10),
      decoration: BoxDecoration(
        color: JourneyColors.navy,
        borderRadius: BorderRadius.circular(99),
        border: Border.all(color: JourneyColors.gold, width: 2),
        boxShadow: [
          BoxShadow(
            color: JourneyColors.navy.withValues(alpha: 0.25),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.flag_rounded, size: 18, color: JourneyColors.gold),
          SizedBox(width: 6),
          Text(
            'START',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.6,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

/// A crisp, code-drawn level shield: navy with a gold rim, gold with a navy
/// numeral for boss levels, stone grey while locked.
class JourneyShield extends StatelessWidget {
  const JourneyShield({
    super.key,
    required this.number,
    this.locked = false,
    this.boss = false,
  });

  final int number;
  final bool locked;
  final bool boss;

  @override
  Widget build(BuildContext context) {
    final Color fill;
    final Color rim;
    final Color ink;
    if (locked) {
      fill = JourneyColors.lockedFace;
      rim = JourneyColors.lockedEdge;
      ink = HomePage.mutedIcon;
    } else if (boss) {
      fill = JourneyColors.gold;
      rim = JourneyColors.goldDeep;
      ink = JourneyColors.navy;
    } else {
      fill = JourneyColors.navy;
      rim = JourneyColors.gold;
      ink = Colors.white;
    }

    return SizedBox(
      width: 50,
      height: 58,
      child: CustomPaint(
        painter: _ShieldPainter(fill: fill, rim: rim),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: Center(
            child: Text(
              '$number',
              style: TextStyle(
                fontSize: number > 9 ? 19 : 23,
                fontWeight: FontWeight.w900,
                color: ink,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ShieldPainter extends CustomPainter {
  const _ShieldPainter({required this.fill, required this.rim});

  final Color fill;
  final Color rim;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final path = Path()
      ..moveTo(w * 0.5, 1.5)
      ..quadraticBezierTo(w * 0.78, h * 0.12, w - 2, h * 0.14)
      ..lineTo(w - 2, h * 0.52)
      ..cubicTo(w - 2, h * 0.8, w * 0.62, h * 0.92, w * 0.5, h - 1.5)
      ..cubicTo(w * 0.38, h * 0.92, 2, h * 0.8, 2, h * 0.52)
      ..lineTo(2, h * 0.14)
      ..quadraticBezierTo(w * 0.22, h * 0.12, w * 0.5, 1.5)
      ..close();

    canvas.drawShadow(path, Colors.black, 3, false);
    canvas.drawPath(path, Paint()..color = fill);
    // Inner highlight on the upper half for a little depth.
    canvas.save();
    canvas.clipPath(path);
    canvas.drawRect(
      Rect.fromLTWH(0, 0, w, h * 0.45),
      Paint()..color = Colors.white.withValues(alpha: 0.08),
    );
    canvas.restore();
    canvas.drawPath(
      path,
      Paint()
        ..color = rim
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.6,
    );
  }

  @override
  bool shouldRepaint(covariant _ShieldPainter old) =>
      old.fill != fill || old.rim != rim;
}

/// The dark-hero credits badge: balance out of the cap and time to the next
/// refill.
class JourneyCreditsPill extends StatelessWidget {
  const JourneyCreditsPill({super.key, required this.credits});

  final int credits;

  @override
  Widget build(BuildContext context) {
    final full = credits >= LeaderboardProgressStore.maxCredits;
    final wait =
        LeaderboardProgressStore.timeUntilNextRegen ??
        LeaderboardProgressStore.regenInterval;
    final caption = full
        ? 'Full'
        : '+${LeaderboardProgressStore.regenAmount} in '
              '${wait.inHours}h ${wait.inMinutes.remainder(60)}m';

    return Semantics(
      label: '$credits credits. $caption',
      child: Container(
        key: const ValueKey('journey.credits'),
        padding: const EdgeInsets.fromLTRB(12, 8, 14, 8),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withValues(alpha: 0.16)),
        ),
        child: ExcludeSemantics(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.bolt_rounded,
                size: 24,
                color: JourneyColors.gold,
              ),
              const SizedBox(width: 4),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        '$credits',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        '/${LeaderboardProgressStore.maxCredits}',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Colors.white.withValues(alpha: 0.55),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    caption,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: Colors.white.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Confirms spending [LeaderboardProgressStore.quizCost] credits on [title]
/// before a quiz starts. Resolves true only when the user commits and can
/// afford it; the caller still does the actual spend.
Future<bool> showQuizCostDialog(
  BuildContext context, {
  required String title,
  required String subtitle,
}) async {
  final credits = LeaderboardProgressStore.credits;
  const cost = LeaderboardProgressStore.quizCost;
  final canAfford = credits >= cost;
  final wait =
      LeaderboardProgressStore.timeUntilNextRegen ??
      LeaderboardProgressStore.regenInterval;

  final confirmed = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => Dialog(
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 22, 20, 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              subtitle.toUpperCase(),
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.1,
                color: JourneyColors.goldDeep,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: const TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.3,
                color: JourneyColors.navy,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: canAfford
                    ? const Color(0xFFFBF5EC)
                    : const Color(0xFFFDF0EE),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.bolt_rounded,
                    size: 28,
                    color: canAfford
                        ? JourneyColors.gold
                        : const Color(0xFFC0392B),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      canAfford
                          ? "Costs $cost credits · you'll have "
                                '${credits - cost} left'
                          : 'Costs $cost credits · you have $credits. '
                                '+${LeaderboardProgressStore.regenAmount} in '
                                '${wait.inHours}h ${wait.inMinutes.remainder(60)}m',
                      key: const ValueKey('quizCost.summary'),
                      style: TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w600,
                        color: canAfford
                            ? JourneyColors.navy
                            : const Color(0xFFC0392B),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            if (!canAfford) ...[
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  key: const ValueKey('quizCost.watchAd'),
                  onPressed: () async {
                    final rewarded = await showWatchAdDialog(dialogContext);
                    if (rewarded && dialogContext.mounted) {
                      // Re-opened by the caller with the new balance.
                      Navigator.of(dialogContext).pop(false);
                    }
                  },
                  icon: const Icon(Icons.play_circle_outline_rounded, size: 20),
                  label: Text(
                    'Watch an ad for +${LeaderboardProgressStore.adReward}',
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: JourneyColors.navy,
                    side: const BorderSide(
                      color: JourneyColors.gold,
                      width: 1.6,
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    textStyle: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
            ],
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                key: const ValueKey('quizCost.start'),
                onPressed: canAfford
                    ? () => Navigator.of(dialogContext).pop(true)
                    : null,
                icon: const Icon(Icons.play_arrow_rounded, size: 22),
                label: Text(canAfford ? 'Start Quiz' : 'Not Enough Credits'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: JourneyColors.navy,
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
            SizedBox(
              width: double.infinity,
              child: TextButton(
                key: const ValueKey('quizCost.cancel'),
                onPressed: () => Navigator.of(dialogContext).pop(false),
                style: TextButton.styleFrom(
                  foregroundColor: HomePage.supportText,
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
    ),
  );
  return confirmed == true && canAfford;
}

/// Plays a rewarded ad and pays [LeaderboardProgressStore.adReward] credits
/// once it finishes. Resolves true when the reward was paid.
///
/// ponytail: there is no ad SDK in this project yet, so the "ad" is a short
/// countdown the viewer must sit through. Swapping in google_mobile_ads means
/// replacing the body of [_playAd] — the reward, the button and the wiring
/// around it stay as they are.
Future<bool> showWatchAdDialog(BuildContext context) async {
  final watched = await showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (_) => const _WatchAdDialog(),
  );

  if (watched != true) {
    return false;
  }

  await LeaderboardProgressStore.rewardForAd();
  return true;
}

class _WatchAdDialog extends StatefulWidget {
  const _WatchAdDialog();

  @override
  State<_WatchAdDialog> createState() => _WatchAdDialogState();
}

class _WatchAdDialogState extends State<_WatchAdDialog> {
  static const _adSeconds = 5;

  int _secondsLeft = _adSeconds;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        return;
      }
      setState(() => _secondsLeft -= 1);
      if (_secondsLeft <= 0) {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final finished = _secondsLeft <= 0;

    return Dialog(
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 22, 20, 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'ADVERTISEMENT',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.1,
                color: JourneyColors.goldDeep,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              height: 150,
              width: double.infinity,
              decoration: BoxDecoration(
                color: JourneyColors.navy,
                borderRadius: BorderRadius.circular(18),
              ),
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    finished
                        ? Icons.check_circle_rounded
                        : Icons.play_circle_outline_rounded,
                    size: 44,
                    color: JourneyColors.gold,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    finished ? 'Thanks for watching' : 'Your ad is playing...',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            Text(
              finished
                  ? 'Collect your +${LeaderboardProgressStore.adReward} credits.'
                  : 'Reward in $_secondsLeft second${_secondsLeft == 1 ? '' : 's'}.',
              key: const ValueKey('watchAd.status'),
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: JourneyColors.navy,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                key: const ValueKey('watchAd.collect'),
                onPressed: finished
                    ? () => Navigator.of(context).pop(true)
                    : null,
                icon: const Icon(Icons.bolt_rounded, size: 20),
                label: Text('Collect +${LeaderboardProgressStore.adReward}'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: JourneyColors.gold,
                  disabledBackgroundColor: HomePage.cardBorder,
                  foregroundColor: JourneyColors.navy,
                  elevation: 0,
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                key: const ValueKey('watchAd.cancel'),
                onPressed: () => Navigator.of(context).pop(false),
                style: TextButton.styleFrom(
                  foregroundColor: HomePage.supportText,
                ),
                child: Text(finished ? 'No thanks' : 'Skip'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
