import 'package:flutter/material.dart';

import '../../../app/theme/app_motion.dart';
import '../../../app/theme/app_tokens.dart';

import '../../../app/theme/app_typography.dart';

import '../../../core/localization/l10n.dart';
import '../../../core/presentation/widgets/nyaya_widgets.dart';
import 'quiz_result_view_model.dart';

const _correctGreen = NyayaColors.success;
const _correctTint = NyayaColors.successTint;
const _wrongRed = NyayaColors.danger;
const _wrongTint = NyayaColors.dangerTint;
const _cardBorder = NyayaColors.hairline;
const _weakStripFill = NyayaColors.goldTint;

class QuizResultPage extends StatelessWidget {
  const QuizResultPage({
    super.key,
    required this.viewModel,
    this.onReviewAnswers,
    required this.onBackToTopic,
  });

  final QuizResultViewModel viewModel;

  /// Null hides Review answers until answer review exists; Back to topic
  /// then becomes the primary button.
  final VoidCallback? onReviewAnswers;
  final VoidCallback onBackToTopic;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      backgroundColor: ivory,
      body: Stack(
        children: [
          const Positioned.fill(child: BackgroundWave()),
          Positioned(
            top: 0,
            left: 0,
            child: ExcludeSemantics(child: DotPattern(width: 96, height: 96)),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 12),
                  _ResultHaptic(band: viewModel.band),
                  _ScoreRing(
                    scoreLabel: viewModel.scoreLabel,
                    percentLabel: viewModel.percentLabel,
                    correct: viewModel.correctCount,
                    total: viewModel.total,
                  ),
                  const SizedBox(height: 28),
                  _Entrance(
                    child: Text(
                      switch (viewModel.band) {
                        ResultBand.excellent => l10n.resultHeadline,
                        ResultBand.good => l10n.resultHeadlineGood,
                        ResultBand.keepGoing => l10n.resultHeadlineKeepGoing,
                      },
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontFamily: NyayaFonts.display,
                        color: navy,
                        fontSize: 40,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const ExcludeSemantics(child: ContentDivider()),
                  const SizedBox(height: 10),
                  Text(
                    l10n.resultCompleted(
                      viewModel.topicTitle ?? l10n.resultThisTopic,
                    ),
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: bodyGrey, fontSize: 16),
                  ),
                  const SizedBox(height: 24),
                  _StatsCard(
                    correctCount: viewModel.correctCount,
                    wrongCount: viewModel.wrongCount,
                  ),
                  if (viewModel.showWeakStrip) ...[
                    const SizedBox(height: 16),
                    _WeakStrip(count: viewModel.weakCount),
                  ],
                  const SizedBox(height: 28),
                  if (onReviewAnswers case final onReview?) ...[
                    _PrimaryCta(
                      ctaKey: const ValueKey('result.review'),
                      label: l10n.resultReviewAnswers,
                      onPressed: onReview,
                    ),
                    const SizedBox(height: 14),
                    _SecondaryCta(
                      label: l10n.resultBackToTopic,
                      onPressed: onBackToTopic,
                    ),
                  ] else
                    _PrimaryCta(
                      ctaKey: const ValueKey('result.backtotopic'),
                      label: l10n.resultBackToTopic,
                      onPressed: onBackToTopic,
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

class _ScoreRing extends StatelessWidget {
  const _ScoreRing({
    required this.scoreLabel,
    required this.percentLabel,
    required this.correct,
    required this.total,
  });

  final String scoreLabel;
  final String percentLabel;
  final int correct;
  final int total;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      key: const ValueKey('result.ring'),
      label: context.l10n.resultScoreSemantics(scoreLabel, percentLabel),
      child: ExcludeSemantics(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const _Laurel(),
            Container(
              width: 200,
              height: 200,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: gold, width: 6),
                boxShadow: const [
                  BoxShadow(
                    color: NyayaColors.shadowStrong,
                    blurRadius: 18,
                    offset: Offset(0, 6),
                  ),
                ],
              ),
              // The score counts up from zero (spec 039); screen readers get
              // the final numbers from the label above.
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: 1),
                duration: NyayaMotion.of(context, NyayaMotion.slow),
                curve: NyayaMotion.curve,
                builder: (context, t, _) => Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      t == 1 ? scoreLabel : '${(correct * t).round()}/$total',
                      key: const ValueKey('result.score'),
                      style: const TextStyle(
                        fontFamily: NyayaFonts.display,
                        color: navy,
                        fontSize: 54,
                        height: 1.0,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Container(
                      width: 64,
                      height: 1,
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      color: gold,
                    ),
                    Text(
                      t == 1
                          ? percentLabel
                          : '${total == 0 ? 0 : (correct / total * 100 * t).round()}%',
                      key: const ValueKey('result.percent'),
                      style: const TextStyle(
                        fontFamily: NyayaFonts.display,
                        color: navy,
                        fontSize: 28,
                        height: 1.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const _Laurel(mirror: true),
          ],
        ),
      ),
    );
  }
}

class _Laurel extends StatelessWidget {
  const _Laurel({this.mirror = false});

  final bool mirror;

  @override
  Widget build(BuildContext context) {
    return Transform(
      alignment: Alignment.center,
      transform: mirror
          ? Matrix4.diagonal3Values(-1, 1, 1)
          : Matrix4.identity(),
      child: Icon(Icons.eco, color: gold.withValues(alpha: 0.85), size: 44),
    );
  }
}

class _StatsCard extends StatelessWidget {
  const _StatsCard({required this.correctCount, required this.wrongCount});

  final int correctCount;
  final int wrongCount;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(NyayaRadii.md),
        boxShadow: const [
          BoxShadow(
            color: NyayaColors.shadowMid,
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _StatColumn(
              key: const ValueKey('result.correct'),
              icon: Icons.check_circle,
              iconColor: _correctGreen,
              iconTint: _correctTint,
              count: correctCount,
              countColor: _correctGreen,
              label: l10n.resultCorrect.toUpperCase(),
              semanticLabel: l10n.resultCorrectCount(correctCount),
            ),
          ),
          Container(width: 1, height: 68, color: _cardBorder),
          Expanded(
            child: _StatColumn(
              key: const ValueKey('result.wrong'),
              icon: Icons.cancel,
              iconColor: _wrongRed,
              iconTint: _wrongTint,
              count: wrongCount,
              countColor: _wrongRed,
              label: l10n.resultWrong.toUpperCase(),
              semanticLabel: l10n.resultWrongCount(wrongCount),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatColumn extends StatelessWidget {
  const _StatColumn({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.iconTint,
    required this.count,
    required this.countColor,
    required this.label,
    required this.semanticLabel,
  });

  final IconData icon;
  final Color iconColor;
  final Color iconTint;
  final int count;
  final Color countColor;
  final String label;
  final String semanticLabel;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticLabel,
      child: ExcludeSemantics(
        child: Column(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: iconTint,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 24),
            ),
            const SizedBox(height: 10),
            Text(
              '$count',
              style: TextStyle(
                color: countColor,
                fontSize: 26,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                color: navy,
                fontSize: 12,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WeakStrip extends StatelessWidget {
  const _WeakStrip({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const ValueKey('result.weakstrip'),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: _weakStripFill,
        borderRadius: BorderRadius.circular(NyayaRadii.sm),
      ),
      child: Row(
        children: [
          const Icon(Icons.bookmark, color: gold, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              context.l10n.resultWeakList(count),
              style: const TextStyle(color: bodyGrey, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}

class _PrimaryCta extends StatelessWidget {
  const _PrimaryCta({
    required this.ctaKey,
    required this.label,
    required this.onPressed,
  });

  final Key ctaKey;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 54,
      child: ElevatedButton(
        key: ctaKey,
        style: ElevatedButton.styleFrom(
          backgroundColor: gold,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(NyayaRadii.pill),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}

class _SecondaryCta extends StatelessWidget {
  const _SecondaryCta({required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 54,
      child: OutlinedButton(
        key: const ValueKey('result.backtotopic'),
        style: OutlinedButton.styleFrom(
          foregroundColor: navy,
          side: const BorderSide(color: navy, width: 1.4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(NyayaRadii.pill),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}

/// Fires one haptic as the result appears (spec 039): a celebration for a
/// strong score, a light tap otherwise.
class _ResultHaptic extends StatefulWidget {
  const _ResultHaptic({required this.band});

  final ResultBand band;

  @override
  State<_ResultHaptic> createState() => _ResultHapticState();
}

class _ResultHapticState extends State<_ResultHaptic> {
  @override
  void initState() {
    super.initState();
    widget.band == ResultBand.excellent
        ? NyayaHaptics.celebrate()
        : NyayaHaptics.select();
  }

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}

/// Fades and settles its child into place.
class _Entrance extends StatelessWidget {
  const _Entrance({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => TweenAnimationBuilder<double>(
    tween: Tween(begin: 0, end: 1),
    duration: NyayaMotion.of(context, NyayaMotion.slow),
    curve: NyayaMotion.curve,
    builder: (context, t, child) => Opacity(
      opacity: t,
      child: Transform.scale(scale: 0.92 + 0.08 * t, child: child),
    ),
    child: child,
  );
}
