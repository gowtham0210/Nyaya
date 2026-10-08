import 'package:flutter/material.dart';

import '../../../../app/theme/app_motion.dart';
import '../../../../app/theme/app_tokens.dart';

import '../../../../core/localization/l10n.dart';
import '../../../../core/presentation/load_state.dart';
import '../../../../core/presentation/show_message.dart';
import '../../../../core/presentation/widgets/load_state_view.dart';
import '../../../../core/presentation/widgets/nyaya_widgets.dart';
import '../daily_questions_view_model.dart';

const _deepNavy = NyayaColors.ink;
const _supportText = NyayaColors.inkMuted;
const _cardBorder = NyayaColors.hairline;

/// Today's question in full (specs 045, 046): pick an option, the backend
/// grades it. Shown on its own screen; Home has a compact card.
class DailyQuestionView extends StatelessWidget {
  const DailyQuestionView({super.key, required this.viewModel});

  final DailyQuestionsViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, _) {
        final state = viewModel.state;
        return Container(
          key: const ValueKey('daily.view'),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(NyayaRadii.md),
            border: Border.all(color: _cardBorder),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Header(today: state is Loaded<DailyToday> ? state.data : null),
              const SizedBox(height: 14),
              LoadStateView<DailyToday>(
                state: state,
                onRetry: viewModel.load,
                emptyMessage: l10n.homeDailyNone,
                emptyIcon: Icons.lightbulb_outline_rounded,
                builder: (context, today) =>
                    _TodayCard(viewModel: viewModel, today: today),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.today});

  /// Null until today's question loads.
  final DailyToday? today;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final question = today?.question;
    final result = today?.result;
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: const BoxDecoration(color: gold, shape: BoxShape.circle),
          alignment: Alignment.center,
          child: const Icon(
            Icons.lightbulb_outline_rounded,
            color: Colors.white,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        // The screen's app bar carries the title.
        Expanded(
          child: Text(
            l10n.homeDailySubtitle,
            style: const TextStyle(
              fontSize: 13,
              color: _supportText,
              height: 1.35,
            ),
          ),
        ),
        if (result != null && result.pointsEarned > 0)
          Flexible(
            child: _Chip(
              key: const ValueKey('home.daily.earned'),
              text: l10n.homeDailyEarned(result.pointsEarned),
              color: NyayaColors.successTint,
              textColor: NyayaColors.success,
            ),
          )
        else if (result == null &&
            question != null &&
            question.pointsReward > 0)
          Flexible(
            child: _Chip(
              key: const ValueKey('home.daily.points'),
              text: l10n.homeDailyPoints(question.pointsReward),
              color: gold.withValues(alpha: 0.14),
              textColor: _deepNavy,
            ),
          ),
      ],
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({
    super.key,
    required this.text,
    required this.color,
    required this.textColor,
  });

  final String text;
  final Color color;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 8),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(NyayaRadii.md),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: textColor,
        ),
      ),
    );
  }
}

class _TodayCard extends StatelessWidget {
  const _TodayCard({required this.viewModel, required this.today});

  final DailyQuestionsViewModel viewModel;
  final DailyToday today;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    // Empty days never reach here (see `isEmpty`).
    final question = today.question!;
    final result = today.result;
    final sending = viewModel.sending;
    return Container(
      key: const ValueKey('home.daily.question'),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: NyayaColors.ivory,
        borderRadius: BorderRadius.circular(NyayaRadii.md),
        border: Border.all(color: _cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (question.category.isNotEmpty) ...[
            Align(
              alignment: Alignment.centerLeft,
              child: _CategoryChip(text: question.category),
            ),
            const SizedBox(height: 12),
          ],
          Semantics(
            container: true,
            header: true,
            child: Text(
              question.question,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: _deepNavy,
                height: 1.4,
              ),
            ),
          ),
          const SizedBox(height: 14),
          for (final (index, option) in question.options.indexed) ...[
            if (index > 0) const SizedBox(height: 8),
            _OptionTile(
              key: ValueKey('home.daily.option.${option.id}'),
              letter: String.fromCharCode(65 + index),
              option: option,
              state: _stateOf(option, result),
              sending: sending == option.id,
              // Locked once answered, and while an answer is on its way.
              onTap: result == null && sending == null
                  ? () => _answer(context, option)
                  : null,
            ),
          ],
          if (result != null) ...[
            _Explanation(result: result),
            const SizedBox(height: 10),
            Text(
              l10n.homeDailyComeBack,
              key: const ValueKey('home.daily.comeBack'),
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 13, color: _supportText),
            ),
          ],
        ],
      ),
    );
  }

  _OptionState _stateOf(DailyOption option, DailyResult? result) {
    if (result == null) return _OptionState.open;
    final isRight = option.id == result.correctOptionId;
    if (option.id == result.selectedOptionId) {
      return isRight ? _OptionState.pickedRight : _OptionState.pickedWrong;
    }
    return isRight ? _OptionState.right : _OptionState.other;
  }

  Future<void> _answer(BuildContext context, DailyOption option) async {
    NyayaHaptics.select();
    final failed = context.l10n.quizAnswerFailed;
    try {
      final result = await viewModel.answer(option.id);
      if (result != null) {
        result.isCorrect ? NyayaHaptics.correct() : NyayaHaptics.wrong();
      }
    } catch (_) {
      if (context.mounted) showMessage(context, failed);
    }
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: NyayaColors.goldTint,
        borderRadius: BorderRadius.circular(NyayaRadii.xs),
      ),
      child: Text(
        text,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: NyayaColors.goldDeep,
        ),
      ),
    );
  }
}

enum _OptionState { open, pickedRight, pickedWrong, right, other }

class _OptionTile extends StatelessWidget {
  const _OptionTile({
    super.key,
    required this.letter,
    required this.option,
    required this.state,
    required this.sending,
    required this.onTap,
  });

  final String letter;
  final DailyOption option;
  final _OptionState state;

  /// True while this pick is being graded.
  final bool sending;

  /// Null once answered or while an answer is on its way.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final (fill, accent, icon, stateLabel) = switch (state) {
      _OptionState.open => (
        NyayaColors.surface,
        sending ? gold : _cardBorder,
        null,
        null,
      ),
      _OptionState.pickedRight => (
        NyayaColors.successTint,
        NyayaColors.success,
        Icons.check_rounded,
        l10n.quizYourAnswerCorrect,
      ),
      _OptionState.pickedWrong => (
        NyayaColors.dangerTint,
        NyayaColors.danger,
        Icons.close_rounded,
        l10n.quizYourAnswerWrong,
      ),
      _OptionState.right => (
        NyayaColors.successTint,
        NyayaColors.success,
        Icons.check_rounded,
        l10n.quizCorrectAnswer,
      ),
      _OptionState.other => (NyayaColors.surface, _cardBorder, null, null),
    };
    final faded = state == _OptionState.other;
    return Semantics(
      container: true,
      button: onTap != null,
      label: l10n.quizOptionLabel(letter, option.text),
      value: stateLabel,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: NyayaMotion.of(context, NyayaMotion.medium),
          curve: NyayaMotion.curve,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
          decoration: BoxDecoration(
            color: fill,
            borderRadius: BorderRadius.circular(NyayaRadii.sm),
            border: Border.all(color: accent, width: icon == null ? 1 : 1.5),
          ),
          child: ExcludeSemantics(
            child: Row(
              children: [
                Container(
                  width: 26,
                  height: 26,
                  decoration: BoxDecoration(
                    color: icon == null ? NyayaColors.inkTint : accent,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: icon == null
                      ? Text(
                          letter,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: faded ? NyayaColors.inkSubtle : _deepNavy,
                          ),
                        )
                      : Icon(icon, size: 16, color: Colors.white),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    option.text,
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.35,
                      fontWeight: FontWeight.w600,
                      color: faded ? NyayaColors.inkSubtle : _deepNavy,
                    ),
                  ),
                ),
                if (sending) ...[
                  const SizedBox(width: 8),
                  const SizedBox(
                    key: ValueKey('home.daily.sending'),
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: gold,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// The verdict and the explanation, sliding up into place.
class _Explanation extends StatelessWidget {
  const _Explanation({required this.result});

  final DailyResult result;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final correct = result.isCorrect;
    final accent = correct ? NyayaColors.success : NyayaColors.danger;
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: NyayaMotion.of(context, NyayaMotion.medium),
      curve: NyayaMotion.curve,
      builder: (context, t, child) => Opacity(
        opacity: t,
        child: Transform.translate(
          offset: Offset(0, 8 * (1 - t)),
          child: child,
        ),
      ),
      child: Container(
        key: const ValueKey('home.daily.explanation'),
        margin: const EdgeInsets.only(top: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: NyayaColors.surface,
          borderRadius: BorderRadius.circular(NyayaRadii.sm),
          border: Border(left: BorderSide(color: accent, width: 3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              key: const ValueKey('home.daily.verdict'),
              children: [
                Icon(
                  correct ? Icons.check_circle_rounded : Icons.cancel_rounded,
                  size: 18,
                  color: accent,
                ),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    correct ? l10n.quizVerdictCorrect : l10n.quizVerdictWrong,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: accent,
                    ),
                  ),
                ),
              ],
            ),
            if (result.explanation.isNotEmpty) ...[
              const SizedBox(height: 6),
              Text(
                result.explanation,
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.5,
                  color: bodyGrey,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
