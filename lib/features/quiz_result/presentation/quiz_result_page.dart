import 'package:flutter/material.dart';

import '../../../core/presentation/widgets/nyaya_widgets.dart';
import 'quiz_result_view_model.dart';

const _correctGreen = Color(0xFF1FA35B);
const _correctTint = Color(0xFFE9F7EF);
const _wrongRed = Color(0xFFD64545);
const _wrongTint = Color(0xFFFDEEEE);
const _cardBorder = Color(0xFFECE5DB);
const _weakStripFill = Color(0xFFF3E9D7);

class QuizResultPage extends StatelessWidget {
  const QuizResultPage({
    super.key,
    required this.viewModel,
    required this.onReviewAnswers,
    required this.onBackToTopic,
  });

  final QuizResultViewModel viewModel;
  final VoidCallback onReviewAnswers;
  final VoidCallback onBackToTopic;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ivory,
      body: Stack(
        children: [
          const Positioned.fill(child: BackgroundWave()),
          Positioned(
            top: 0,
            left: 0,
            child: ExcludeSemantics(
              child: DotPattern(width: 96, height: 96),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 12),
                  _ScoreRing(
                    scoreLabel: viewModel.scoreLabel,
                    percentLabel: viewModel.percentLabel,
                  ),
                  const SizedBox(height: 28),
                  Text(
                    viewModel.headline,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: 'serif',
                      color: navy,
                      fontSize: 34,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const ExcludeSemantics(child: ContentDivider()),
                  const SizedBox(height: 10),
                  Text(
                    viewModel.subtitle,
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
                  _PrimaryCta(
                    label: 'REVIEW ANSWERS',
                    onPressed: onReviewAnswers,
                  ),
                  const SizedBox(height: 14),
                  _SecondaryCta(
                    label: 'BACK TO TOPIC',
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
  const _ScoreRing({required this.scoreLabel, required this.percentLabel});

  final String scoreLabel;
  final String percentLabel;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      key: const ValueKey('result.ring'),
      label: 'Your score: $scoreLabel, $percentLabel',
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
                    color: Color(0x22000000),
                    blurRadius: 18,
                    offset: Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    scoreLabel,
                    key: const ValueKey('result.score'),
                    style: const TextStyle(
                      fontFamily: 'serif',
                      color: navy,
                      fontSize: 46,
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
                    percentLabel,
                    key: const ValueKey('result.percent'),
                    style: const TextStyle(
                      fontFamily: 'serif',
                      color: navy,
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
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
      child: Icon(
        Icons.eco,
        color: gold.withValues(alpha: 0.85),
        size: 44,
      ),
    );
  }
}

class _StatsCard extends StatelessWidget {
  const _StatsCard({required this.correctCount, required this.wrongCount});

  final int correctCount;
  final int wrongCount;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
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
              label: 'CORRECT',
              semanticLabel: '$correctCount correct',
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
              label: 'WRONG',
              semanticLabel: '$wrongCount wrong',
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
              decoration: BoxDecoration(color: iconTint, shape: BoxShape.circle),
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
                fontSize: 13,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.5,
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
    final noun = count == 1 ? 'question' : 'questions';
    return Container(
      key: const ValueKey('result.weakstrip'),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: _weakStripFill,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          const Icon(Icons.bookmark, color: gold, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              '$count $noun added to your weak list.',
              style: const TextStyle(color: bodyGrey, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}

class _PrimaryCta extends StatelessWidget {
  const _PrimaryCta({required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 54,
      child: ElevatedButton(
        key: const ValueKey('result.review'),
        style: ElevatedButton.styleFrom(
          backgroundColor: gold,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            letterSpacing: 2,
          ),
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
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            letterSpacing: 2,
          ),
        ),
      ),
    );
  }
}
