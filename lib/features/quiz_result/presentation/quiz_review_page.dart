import 'package:flutter/material.dart';

import '../../../core/presentation/widgets/nyaya_widgets.dart';
import '../../quiz_question/presentation/quiz_session_view_model.dart';

const _correctGreen = Color(0xFF1FA35B);
const _correctTint = Color(0xFFE9F7EF);
const _wrongRed = Color(0xFFD64545);
const _wrongTint = Color(0xFFFDEEEE);

/// Shows each question from a finished attempt next to the option the user
/// picked, so "REVIEW ANSWERS" on the result screen has somewhere to go.
class QuizReviewPage extends StatelessWidget {
  const QuizReviewPage({
    super.key,
    required this.questions,
    required this.outcomes,
  });

  final List<QuizQuestion> questions;
  final List<QuizOutcome> outcomes;

  @override
  Widget build(BuildContext context) {
    final outcomeByQuestionId = {
      for (final outcome in outcomes) outcome.questionId: outcome,
    };

    return Scaffold(
      backgroundColor: ivory,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  IconButton(
                    key: const ValueKey('review.close'),
                    onPressed: () => Navigator.maybePop(context),
                    icon: const Icon(Icons.close, color: navy),
                    tooltip: 'Close review',
                  ),
                  const Expanded(
                    child: Text(
                      'Review Answers',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: navy,
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.all(24),
                itemCount: questions.length,
                separatorBuilder: (_, _) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final question = questions[index];
                  final outcome = outcomeByQuestionId[question.id];
                  return _QuestionReviewCard(
                    index: index,
                    question: question,
                    outcome: outcome,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuestionReviewCard extends StatelessWidget {
  const _QuestionReviewCard({
    required this.index,
    required this.question,
    required this.outcome,
  });

  final int index;
  final QuizQuestion question;

  /// Null when the attempt was resumed and this question was answered in an
  /// earlier session that didn't record locally.
  final QuizOutcome? outcome;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${index + 1}. ${question.stem}',
            style: const TextStyle(
              color: navy,
              fontSize: 16,
              fontWeight: FontWeight.w700,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 12),
          for (final (optionIndex, option) in question.options.indexed)
            _OptionRow(
              text: option,
              isCorrectOption: optionIndex == question.correctOption,
              isChosenOption: optionIndex == outcome?.chosenOption,
            ),
          if (question.explanation.core.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              question.explanation.core,
              style: const TextStyle(color: bodyGrey, fontSize: 13.5),
            ),
          ],
        ],
      ),
    );
  }
}

class _OptionRow extends StatelessWidget {
  const _OptionRow({
    required this.text,
    required this.isCorrectOption,
    required this.isChosenOption,
  });

  final String text;
  final bool isCorrectOption;
  final bool isChosenOption;

  @override
  Widget build(BuildContext context) {
    if (!isCorrectOption && !isChosenOption) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Text(text, style: const TextStyle(color: bodyGrey)),
      );
    }

    final isWrongChoice = isChosenOption && !isCorrectOption;
    final color = isWrongChoice ? _wrongRed : _correctGreen;
    final tint = isWrongChoice ? _wrongTint : _correctTint;
    final icon = isWrongChoice ? Icons.cancel : Icons.check_circle;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: tint,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 18),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                text,
                style: TextStyle(color: color, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
