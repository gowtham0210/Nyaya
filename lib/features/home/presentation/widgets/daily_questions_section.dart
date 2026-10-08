import 'package:flutter/material.dart';

import '../../../../app/theme/app_tokens.dart';

import '../../../../core/localization/l10n.dart';
import '../../../../core/presentation/load_state.dart';
import '../../../../core/presentation/widgets/load_state_view.dart';
import '../../../../core/presentation/widgets/nyaya_skeleton.dart';
import '../../../../core/presentation/widgets/nyaya_widgets.dart';
import '../daily_question_page.dart';
import '../daily_questions_view_model.dart';

const _deepNavy = NyayaColors.ink;
const _supportText = NyayaColors.inkMuted;

/// Home's compact Today's Question card (spec 046): a one-line preview and
/// "Answer now", or the result once answered. Tapping opens the question
/// on its own screen, so Home stays light.
class DailyQuestionsSection extends StatelessWidget {
  const DailyQuestionsSection({super.key, required this.viewModel});

  final DailyQuestionsViewModel viewModel;

  void _open(BuildContext context) => Navigator.of(context).push(
    MaterialPageRoute<void>(
      builder: (_) => DailyQuestionPage(viewModel: viewModel),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, _) {
        final state = viewModel.state;
        final today = state is Loaded<DailyToday> ? state.data : null;
        return Material(
          key: const ValueKey('home.section.daily'),
          color: NyayaColors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(NyayaRadii.md),
            side: const BorderSide(color: NyayaColors.hairline),
          ),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            // Only a loaded question opens; other states stay put.
            onTap: today == null ? null : () => _open(context),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: switch (state) {
                Loading() => const NyayaSkeleton(
                  key: ValueKey('loadState.loading'),
                  lines: 2,
                ),
                Empty() => const _NoQuestion(),
                Failed(:final error) => _Failed(
                  message: failureMessage(context.l10n, error),
                  onRetry: viewModel.load,
                ),
                Loaded(:final data) =>
                  data.result == null
                      ? _Unanswered(question: data.question!)
                      : _Answered(result: data.result!),
              },
            ),
          ),
        );
      },
    );
  }
}

/// The circle, label and two lines of text every state shares.
class _CardRow extends StatelessWidget {
  const _CardRow({
    required this.icon,
    required this.iconColor,
    required this.labelColor,
    required this.title,
    required this.caption,
    this.trailing,
  });

  final IconData icon;
  final Color iconColor;
  final Color labelColor;
  final String title;
  final String? caption;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final caption = this.caption;
    final trailing = this.trailing;
    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(color: iconColor, shape: BoxShape.circle),
          alignment: Alignment.center,
          child: Icon(icon, color: Colors.white, size: 22),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.homeDailyTitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: labelColor,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                title,
                key: const ValueKey('home.daily.title'),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  height: 1.3,
                  color: _deepNavy,
                ),
              ),
              if (caption != null) ...[
                const SizedBox(height: 3),
                Text(
                  caption,
                  key: const ValueKey('home.daily.caption'),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 12, color: _supportText),
                ),
              ],
            ],
          ),
        ),
        if (trailing != null) ...[const SizedBox(width: 12), trailing],
      ],
    );
  }
}

class _Unanswered extends StatelessWidget {
  const _Unanswered({required this.question});

  final DailyQuestion question;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final caption = [
      if (question.category.isNotEmpty) question.category,
      if (question.pointsReward > 0)
        l10n.homeDailyPoints(question.pointsReward),
    ].join(' · ');
    // Large text: the button moves below, so the preview keeps its room.
    final roomy = MediaQuery.textScalerOf(context).scale(1) <= 1.3;
    const button = _AnswerNow();
    return Semantics(
      button: true,
      label: '${l10n.homeDailyTitle}. ${question.question}',
      hint: l10n.homeDailyAnswerNow,
      child: ExcludeSemantics(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _CardRow(
              icon: Icons.lightbulb_outline_rounded,
              iconColor: gold,
              labelColor: NyayaColors.goldDeep,
              title: question.question,
              caption: caption.isEmpty ? null : caption,
              trailing: roomy ? button : null,
            ),
            if (!roomy) ...[
              const SizedBox(height: 12),
              const Align(alignment: Alignment.centerRight, child: button),
            ],
          ],
        ),
      ),
    );
  }
}

class _AnswerNow extends StatelessWidget {
  const _AnswerNow();

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const ValueKey('home.daily.answerNow'),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: gold,
        borderRadius: BorderRadius.circular(NyayaRadii.pill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            context.l10n.homeDailyAnswerNow,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: _deepNavy,
            ),
          ),
          const SizedBox(width: 4),
          const Icon(Icons.arrow_forward_rounded, size: 16, color: _deepNavy),
        ],
      ),
    );
  }
}

class _Answered extends StatelessWidget {
  const _Answered({required this.result});

  final DailyResult result;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final accent = result.isCorrect ? NyayaColors.success : NyayaColors.danger;
    final title =
        '${l10n.homeDailyAnswered} · '
        '${result.isCorrect ? l10n.quizVerdictCorrect : l10n.quizVerdictWrong}';
    final caption = [
      if (result.pointsEarned > 0) l10n.homeDailyEarned(result.pointsEarned),
      l10n.homeDailyTomorrow,
    ].join(' · ');
    return Semantics(
      key: const ValueKey('home.daily.answered'),
      button: true,
      label: '${l10n.homeDailyTitle}. $title. $caption',
      child: ExcludeSemantics(
        child: _CardRow(
          icon: result.isCorrect ? Icons.check_rounded : Icons.close_rounded,
          iconColor: accent,
          labelColor: accent,
          title: title,
          caption: caption,
          trailing: const Icon(
            Icons.chevron_right_rounded,
            color: NyayaColors.inkSubtle,
          ),
        ),
      ),
    );
  }
}

class _NoQuestion extends StatelessWidget {
  const _NoQuestion();

  @override
  Widget build(BuildContext context) {
    return _CardRow(
      icon: Icons.lightbulb_outline_rounded,
      iconColor: NyayaColors.inkDisabled,
      labelColor: _supportText,
      title: context.l10n.homeDailyNone,
      caption: null,
    );
  }
}

class _Failed extends StatelessWidget {
  const _Failed({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.cloud_off_rounded, color: _supportText),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            message,
            key: const ValueKey('loadState.error'),
            style: const TextStyle(fontSize: 13, color: _supportText),
          ),
        ),
        TextButton(
          key: const ValueKey('loadState.retry'),
          onPressed: onRetry,
          style: TextButton.styleFrom(foregroundColor: NyayaColors.goldDeep),
          child: Text(context.l10n.commonRetry),
        ),
      ],
    );
  }
}
