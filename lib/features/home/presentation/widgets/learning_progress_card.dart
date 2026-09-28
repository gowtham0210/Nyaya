import 'package:flutter/material.dart';

import '../../../../core/localization/l10n.dart';
import '../../../../core/presentation/widgets/load_state_view.dart';
import '../learning_progress_view_model.dart';

const _navy = Color(0xFF11233B);
const _gold = Color(0xFFD3A247);
const _supportText = Color(0xFF5E6878);
const _cardBorder = Color(0xFFECE5DB);

/// Home's Continue Learning card with the learner's real progress
/// (spec 026). Its load states render inside the card.
class LearningProgressCard extends StatelessWidget {
  const LearningProgressCard({
    super.key,
    required this.viewModel,
    required this.onResumePressed,
  });

  final LearningProgressViewModel viewModel;
  final VoidCallback onResumePressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const ValueKey('home.continue.card'),
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: _cardBorder),
        boxShadow: [
          BoxShadow(
            color: _navy.withValues(alpha: 0.06),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: ListenableBuilder(
        listenable: viewModel,
        builder: (context, _) => LoadStateView<LearningProgress>(
          state: viewModel.state,
          onRetry: viewModel.load,
          emptyMessage: context.l10n.homeProgressEmpty,
          emptyIcon: Icons.school_outlined,
          builder: (context, progress) => _ProgressRow(
            progress: progress,
            onResumePressed: onResumePressed,
          ),
        ),
      ),
    );
  }
}

class _ProgressRow extends StatelessWidget {
  const _ProgressRow({required this.progress, required this.onResumePressed});

  final LearningProgress progress;
  final VoidCallback onResumePressed;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 320;
        return Row(
          children: [
            _ProgressRing(accuracy: progress.accuracy, compact: compact),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.homeProgressQuizzesCompleted(
                      progress.quizzesCompleted,
                    ),
                    key: const ValueKey('home.continue.title'),
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: _navy,
                      letterSpacing: -0.3,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    l10n.homeProgressPoints(progress.points),
                    key: const ValueKey('home.continue.meta'),
                    style: const TextStyle(fontSize: 14, color: _supportText),
                  ),
                  const SizedBox(height: 12),
                  _ProgressBar(progress: progress.completion),
                ],
              ),
            ),
            const SizedBox(width: 14),
            SizedBox(
              width: compact ? 88 : 100,
              height: 52,
              child: ElevatedButton(
                key: const ValueKey('home.continue.resume'),
                onPressed: onResumePressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _navy,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    l10n.commonResume,
                    style: const TextStyle(
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
    );
  }
}

class _ProgressRing extends StatelessWidget {
  const _ProgressRing({required this.accuracy, required this.compact});

  /// Share of correct answers, 0–1.
  final double accuracy;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final size = compact ? 68.0 : 78.0;
    final percent = (accuracy * 100).round();
    return Semantics(
      label: context.l10n.homeProgressAccuracy(percent),
      excludeSemantics: true,
      child: SizedBox(
        width: size,
        height: size,
        child: Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: size,
              height: size,
              child: CircularProgressIndicator(
                key: const ValueKey('home.continue.progress'),
                value: accuracy,
                strokeWidth: compact ? 6 : 7,
                backgroundColor: const Color(0xFFF0E8DC),
                valueColor: const AlwaysStoppedAnimation<Color>(_gold),
              ),
            ),
            Text(
              '$percent%',
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: _navy,
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
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: progress,
        child: const DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [_gold, Color(0xFFC97A28)]),
            borderRadius: BorderRadius.all(Radius.circular(999)),
          ),
        ),
      ),
    );
  }
}
