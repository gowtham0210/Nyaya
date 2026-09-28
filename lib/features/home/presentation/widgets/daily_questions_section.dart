import 'package:flutter/material.dart';

import '../../../../core/localization/l10n.dart';
import '../../../../core/presentation/load_state.dart';
import '../../../../core/presentation/widgets/load_state_view.dart';
import '../../../../core/presentation/widgets/nyaya_widgets.dart';
import '../daily_questions_view_model.dart';

const _deepNavy = Color(0xFF11233B);
const _supportText = Color(0xFF5E6878);
const _cardBorder = Color(0xFFECE5DB);
const _tileBackground = Color(0xFFF8F6F2);
const _badgeColors = [_deepNavy, Color(0xFFB9823A)];

/// Home's Daily Questions card (spec 018). Its own load states render
/// inside the card, so the rest of Home never waits on it.
class DailyQuestionsSection extends StatelessWidget {
  const DailyQuestionsSection({super.key, required this.viewModel});

  final DailyQuestionsViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, _) {
        final state = viewModel.state;
        return Container(
          key: const ValueKey('home.section.daily'),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: _cardBorder),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Header(
                questionCount: state is Loaded<List<DailyQuestion>>
                    ? state.data.length
                    : null,
              ),
              const SizedBox(height: 14),
              LoadStateView<List<DailyQuestion>>(
                state: state,
                onRetry: viewModel.load,
                emptyMessage: l10n.homeDailyQuestionsEmpty,
                emptyIcon: Icons.lightbulb_outline_rounded,
                builder: (context, questions) => Column(
                  children: [
                    for (final (index, question) in questions.indexed) ...[
                      if (index > 0) const SizedBox(height: 10),
                      _QuestionTile(
                        number: index + 1,
                        question: question,
                        revealed: viewModel.isRevealed(question.id),
                        onToggle: () => viewModel.toggleAnswer(question.id),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.questionCount});

  /// Null until the questions load.
  final int? questionCount;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final count = questionCount;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
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
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.homeDailyQuestions,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: _deepNavy,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                l10n.homeDailyQuestionsSubtitle,
                style: const TextStyle(
                  fontSize: 13,
                  color: _supportText,
                  height: 1.35,
                ),
              ),
            ],
          ),
        ),
        if (count != null) ...[
          const SizedBox(width: 8),
          Container(
            key: const ValueKey('home.daily.count'),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: gold.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              l10n.questionCount(count),
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: _deepNavy,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _QuestionTile extends StatelessWidget {
  const _QuestionTile({
    required this.number,
    required this.question,
    required this.revealed,
    required this.onToggle,
  });

  final int number;
  final DailyQuestion question;
  final bool revealed;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final badgeColor = _badgeColors[(number - 1) % _badgeColors.length];
    return Material(
      color: _tileBackground,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: revealed
            ? const BorderSide(color: gold, width: 1.3)
            : const BorderSide(color: _cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Semantics(
            button: true,
            expanded: revealed,
            label: l10n.homeDailyQuestionSemantics(
              number,
              question.question,
              question.category,
            ),
            child: InkWell(
              key: ValueKey('home.daily.question.${question.id}'),
              onTap: onToggle,
              child: ExcludeSemantics(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: _QuestionHeader(
                    number: number,
                    question: question,
                    badgeColor: badgeColor,
                    revealed: revealed,
                  ),
                ),
              ),
            ),
          ),
          if (revealed)
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  key: ValueKey('home.daily.answer.${question.id}'),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      left: BorderSide(color: badgeColor, width: 3),
                    ),
                  ),
                  child: Text(
                    question.answer,
                    style: const TextStyle(
                      fontSize: 14,
                      height: 1.5,
                      color: bodyGrey,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _QuestionHeader extends StatelessWidget {
  const _QuestionHeader({
    required this.number,
    required this.question,
    required this.badgeColor,
    required this.revealed,
  });

  final int number;
  final DailyQuestion question;
  final Color badgeColor;
  final bool revealed;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(color: badgeColor, shape: BoxShape.circle),
          alignment: Alignment.center,
          child: Text(
            '$number',
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                question.question,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: _deepNavy,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 9,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: badgeColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: badgeColor.withValues(alpha: 0.35),
                      ),
                    ),
                    child: Text(
                      question.category,
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                        color: badgeColor,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        revealed
                            ? l10n.homeDailyHideAnswer
                            : l10n.homeDailyShowAnswer,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: gold,
                        ),
                      ),
                      Icon(
                        revealed
                            ? Icons.expand_less_rounded
                            : Icons.expand_more_rounded,
                        size: 18,
                        color: gold,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
