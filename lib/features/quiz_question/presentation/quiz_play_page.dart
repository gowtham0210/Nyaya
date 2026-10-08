import 'package:flutter/material.dart';

import '../../../core/presentation/load_state.dart';
import '../../../core/presentation/widgets/load_state_view.dart';
import '../../../core/presentation/widgets/nyaya_widgets.dart';
import 'quiz_question_page.dart';
import 'quiz_session_view_model.dart';

/// Opens a backend quiz (spec 038): loads its questions and starts an
/// attempt, with Retry on failure, then plays it.
class QuizPlayPage extends StatefulWidget {
  const QuizPlayPage({
    super.key,
    required this.start,
    required this.onQuizCompleted,
  });

  /// Loads the questions and opens the attempt.
  final Future<QuizSession> Function() start;
  final ValueChanged<List<QuizOutcome>> onQuizCompleted;

  @override
  State<QuizPlayPage> createState() => _QuizPlayPageState();
}

class _QuizPlayPageState extends State<QuizPlayPage> {
  LoadState<QuizSession> _state = const Loading();

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _state = const Loading());
    final state = await LoadState.run(
      widget.start,
      isEmpty: (session) => session.questions.isEmpty,
    );
    if (mounted) setState(() => _state = state);
  }

  @override
  Widget build(BuildContext context) {
    if (_state case Loaded(:final data)) {
      return QuizQuestionPage(
        session: data,
        onQuizCompleted: widget.onQuizCompleted,
      );
    }
    return Scaffold(
      backgroundColor: ivory,
      appBar: AppBar(backgroundColor: ivory),
      body: LoadStateView<QuizSession>(
        state: _state,
        onRetry: _load,
        emptyIcon: Icons.quiz_outlined,
        builder: (_, _) => const SizedBox.shrink(),
      ),
    );
  }
}
