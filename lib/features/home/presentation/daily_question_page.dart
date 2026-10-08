import 'package:flutter/material.dart';

import '../../../core/localization/l10n.dart';
import '../../../core/presentation/widgets/detail_scaffold.dart';
import 'daily_questions_view_model.dart';
import 'widgets/daily_question_view.dart';

/// Today's question on its own screen (spec 046), opened from Home's card.
/// Shares Home's view model, so an answer here updates the card.
class DailyQuestionPage extends StatelessWidget {
  const DailyQuestionPage({super.key, required this.viewModel});

  final DailyQuestionsViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return DetailScaffold(
      key: const ValueKey('daily.page'),
      title: context.l10n.homeDailyTitle,
      children: [DailyQuestionView(viewModel: viewModel)],
    );
  }
}
