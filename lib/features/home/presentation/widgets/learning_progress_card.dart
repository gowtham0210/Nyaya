import 'package:flutter/material.dart';

import '../../../../app/theme/app_tokens.dart';

import '../../../../app/theme/app_typography.dart';

import '../../../../core/localization/l10n.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/presentation/load_state.dart';
import '../../../../core/presentation/widgets/load_state_view.dart';
import '../learning_progress_view_model.dart';

const _navy = NyayaColors.inkDeep;
const _navyLight = NyayaColors.inkRaised;
const _gold = NyayaColors.gold;
const _goldLight = NyayaColors.goldBright;
const _track = NyayaColors.onDarkFaint;
const _mutedOnNavy = NyayaColors.onDarkMuted;
const _artAsset = 'assets/illustrations/continue_pillars.png';

/// Home's Continue Learning card with the learner's real progress
/// (spec 026). A navy card with court-pillar art; its load states render
/// inside the card.
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
      constraints: const BoxConstraints(minHeight: 176),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(NyayaRadii.md),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [_navyLight, _navy],
        ),
        boxShadow: [
          BoxShadow(
            color: _navy.withValues(alpha: 0.18),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -6,
            bottom: 0,
            child: Image.asset(
              _artAsset,
              width: 150,
              fit: BoxFit.contain,
              excludeFromSemantics: true,
            ),
          ),
          ListenableBuilder(
            listenable: viewModel,
            builder: (context, _) => Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
              child: switch (viewModel.state) {
                Loading() => const SizedBox(
                  height: 136,
                  child: Center(
                    key: ValueKey('loadState.loading'),
                    child: CircularProgressIndicator(color: _gold),
                  ),
                ),
                Loaded(:final data) => _ProgressContent(
                  progress: data,
                  onResumePressed: onResumePressed,
                ),
                Empty() => _FirstQuizContent(onStartPressed: onResumePressed),
                Failed(:final error) => _FailedContent(
                  message: failureMessage(context.l10n, error),
                  onRetry: error is ApiUnauthorizedException
                      ? null
                      : viewModel.load,
                ),
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// Keeps text clear of the pillar art on the right.
class _TextColumn extends StatelessWidget {
  const _TextColumn({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      alignment: Alignment.centerLeft,
      widthFactor: 0.68,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: children,
      ),
    );
  }
}

class _ProgressContent extends StatelessWidget {
  const _ProgressContent({
    required this.progress,
    required this.onResumePressed,
  });

  final LearningProgress progress;
  final VoidCallback onResumePressed;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final percent = (progress.accuracy * 100).round();
    return _TextColumn(
      children: [
        Text(
          l10n.homeProgressQuizzesCompleted(progress.quizzesCompleted),
          key: const ValueKey('home.continue.title'),
          style: const TextStyle(
            fontSize: 26,
            fontFamily: NyayaFonts.display,
            fontWeight: FontWeight.w700,
            height: 1.2,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          '${l10n.homeProgressPoints(progress.points)} · '
          '${l10n.homeProgressAccuracy(percent)}',
          key: const ValueKey('home.continue.meta'),
          style: const TextStyle(
            fontSize: 14,
            height: 1.35,
            color: _mutedOnNavy,
          ),
        ),
        const SizedBox(height: 14),
        _ProgressBar(
          completed: progress.quizzesCompleted,
          attempted: progress.quizzesAttempted,
        ),
        const SizedBox(height: 18),
        _GoldButton(
          buttonKey: const ValueKey('home.continue.resume'),
          label: l10n.commonResume,
          onPressed: onResumePressed,
        ),
      ],
    );
  }
}

class _FirstQuizContent extends StatelessWidget {
  const _FirstQuizContent({required this.onStartPressed});

  final VoidCallback onStartPressed;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return _TextColumn(
      children: [
        Text(
          l10n.homeProgressEmpty,
          key: const ValueKey('loadState.empty'),
          style: const TextStyle(
            fontSize: 26,
            fontFamily: NyayaFonts.display,
            fontWeight: FontWeight.w700,
            height: 1.25,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 18),
        _GoldButton(
          buttonKey: const ValueKey('home.continue.resume'),
          label: l10n.homeStartQuiz,
          onPressed: onStartPressed,
        ),
      ],
    );
  }
}

class _FailedContent extends StatelessWidget {
  const _FailedContent({required this.message, required this.onRetry});

  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final retry = onRetry;
    return _TextColumn(
      children: [
        Text(
          message,
          key: const ValueKey('loadState.error'),
          style: const TextStyle(
            fontSize: 15,
            height: 1.4,
            color: _mutedOnNavy,
          ),
        ),
        if (retry != null) ...[
          const SizedBox(height: 16),
          _GoldButton(
            buttonKey: const ValueKey('loadState.retry'),
            label: context.l10n.commonRetry,
            onPressed: retry,
            showArrow: false,
          ),
        ],
      ],
    );
  }
}

class _ProgressBar extends StatelessWidget {
  const _ProgressBar({required this.completed, required this.attempted});

  final int completed;
  final int attempted;

  @override
  Widget build(BuildContext context) {
    final value = attempted == 0 ? 0.0 : completed / attempted;
    return Row(
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(NyayaRadii.pill),
            child: LinearProgressIndicator(
              key: const ValueKey('home.continue.progress'),
              value: value,
              minHeight: 6,
              backgroundColor: _track,
              valueColor: const AlwaysStoppedAnimation<Color>(_gold),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          '$completed/$attempted',
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: _mutedOnNavy,
          ),
        ),
      ],
    );
  }
}

class _GoldButton extends StatelessWidget {
  const _GoldButton({
    required this.buttonKey,
    required this.label,
    required this.onPressed,
    this.showArrow = true,
  });

  final Key buttonKey;
  final String label;
  final VoidCallback onPressed;
  final bool showArrow;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(NyayaRadii.sm)),
        gradient: LinearGradient(colors: [_goldLight, _gold]),
      ),
      child: ElevatedButton(
        key: buttonKey,
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          foregroundColor: _navy,
          elevation: 0,
          minimumSize: const Size(0, 48),
          padding: const EdgeInsets.symmetric(horizontal: 22),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(NyayaRadii.sm),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Text(
                label,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            if (showArrow) ...[
              const SizedBox(width: 8),
              const Icon(Icons.arrow_forward_rounded, size: 18),
            ],
          ],
        ),
      ),
    );
  }
}
