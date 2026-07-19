import 'package:flutter/material.dart';

import '../../../core/presentation/widgets/nyaya_widgets.dart';
import 'quiz_session_view_model.dart';

const _correctGreen = Color(0xFF1FA35B);
const _correctTint = Color(0xFFE9F7EF);
const _wrongRed = Color(0xFFD64545);
const _wrongTint = Color(0xFFFDEEEE);
const _cardBorder = Color(0xFFECE5DB);
const _disabledGrey = Color(0xFFBFC5CE);

class QuizQuestionPage extends StatefulWidget {
  const QuizQuestionPage({
    super.key,
    required this.onQuizCompleted,
    this.session,
  });

  final ValueChanged<List<QuizOutcome>> onQuizCompleted;
  final QuizSessionViewModel? session;

  @override
  State<QuizQuestionPage> createState() => _QuizQuestionPageState();
}

class _QuizQuestionPageState extends State<QuizQuestionPage> {
  late final QuizSessionViewModel _session =
      widget.session ?? QuizSessionViewModel();

  void _answer(int option) {
    if (_session.isAnswered) {
      return;
    }
    setState(() => _session.answer(option));
  }

  void _next() {
    setState(() => _session.next());
    if (_session.isComplete) {
      widget.onQuizCompleted(_session.outcomes);
    }
  }

  @override
  Widget build(BuildContext context) {
    final question = _session.currentQuestion;
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
                    key: const ValueKey('quiz.exit'),
                    onPressed: () => Navigator.maybePop(context),
                    icon: const Icon(Icons.close, color: navy),
                    tooltip: 'Exit quiz',
                  ),
                  Expanded(
                    child: Text(
                      _session.counterLabel,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: bodyGrey, fontSize: 15),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Row(
                key: const ValueKey('quiz.progress'),
                children: [
                  for (var i = 0; i < _session.questions.length; i++) ...[
                    Expanded(
                      child: Container(
                        height: 6,
                        decoration: BoxDecoration(
                          color: i <= _session.currentIndex
                              ? gold
                              : progressTrack,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ),
                    if (i < _session.questions.length - 1)
                      const SizedBox(width: 6),
                  ],
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
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
                      child: Text(
                        question.stem,
                        style: const TextStyle(
                          color: navy,
                          fontSize: 19,
                          fontWeight: FontWeight.w700,
                          height: 1.4,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    for (final (index, option)
                        in question.options.indexed) ...[
                      _OptionCard(
                        letter: String.fromCharCode(65 + index),
                        text: option,
                        state: _optionState(index),
                        onTap: () => _answer(index),
                      ),
                      const SizedBox(height: 12),
                    ],
                    if (_session.isAnswered)
                      _ExplanationCard(
                        isCorrect: _session.isCorrect,
                        explanation: question.explanation,
                      ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 12),
              child: SizedBox(
                height: 54,
                width: double.infinity,
                child: _session.isAnswered
                    ? ElevatedButton(
                        key: const ValueKey('quiz.next'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: gold,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        onPressed: _next,
                        child: const Text(
                          'NEXT',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            letterSpacing: 2,
                          ),
                        ),
                      )
                    : Container(
                        key: const ValueKey('quiz.selectbar'),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: _disabledGrey.withValues(alpha: 0.4),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: const Text(
                          'SELECT AN ANSWER',
                          style: TextStyle(
                            color: _disabledGrey,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 2,
                          ),
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _OptionState _optionState(int index) {
    if (!_session.isAnswered) {
      return _OptionState.neutral;
    }
    final question = _session.currentQuestion;
    if (index == question.correctOption) {
      return index == _session.selectedOption
          ? _OptionState.lockedCorrect
          : _OptionState.revealedCorrect;
    }
    if (index == _session.selectedOption) {
      return _OptionState.lockedWrong;
    }
    return _OptionState.neutral;
  }
}

enum _OptionState { neutral, lockedCorrect, lockedWrong, revealedCorrect }

class _OptionCard extends StatelessWidget {
  const _OptionCard({
    required this.letter,
    required this.text,
    required this.state,
    required this.onTap,
  });

  final String letter;
  final String text;
  final _OptionState state;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final (fill, border, badge) = switch (state) {
      _OptionState.neutral => (Colors.white, _cardBorder, _LetterBadge.neutral),
      _OptionState.lockedCorrect => (
          _correctTint,
          _correctGreen,
          _LetterBadge.check,
        ),
      _OptionState.lockedWrong => (_wrongTint, _wrongRed, _LetterBadge.cross),
      _OptionState.revealedCorrect => (
          Colors.white,
          _correctGreen,
          _LetterBadge.neutral,
        ),
    };

    final stateLabel = switch (state) {
      _OptionState.neutral => '',
      _OptionState.lockedCorrect => '. Your answer, correct',
      _OptionState.lockedWrong => '. Your answer, wrong',
      _OptionState.revealedCorrect => '. Correct answer',
    };

    return Semantics(
      button: true,
      label: 'Option $letter. $text$stateLabel',
      child: InkWell(
        key: ValueKey('quiz.option.$letter'),
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: ExcludeSemantics(
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: fill,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: border,
                width: state == _OptionState.neutral ? 1 : 1.6,
              ),
            ),
            child: Row(
              children: [
                _buildBadge(),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    text,
                    style: const TextStyle(
                      color: navy,
                      fontSize: 15,
                      height: 1.35,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBadge() {
    switch (badge()) {
      case _LetterBadge.check:
        return Container(
          width: 36,
          height: 36,
          decoration: const BoxDecoration(
            color: _correctGreen,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.check, color: Colors.white, size: 20),
        );
      case _LetterBadge.cross:
        return Container(
          width: 36,
          height: 36,
          decoration: const BoxDecoration(
            color: _wrongRed,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.close, color: Colors.white, size: 20),
        );
      case _LetterBadge.neutral:
        final ringColor =
            state == _OptionState.revealedCorrect ? _correctGreen : gold;
        return Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: ringColor, width: 1.6),
          ),
          alignment: Alignment.center,
          child: Text(
            letter,
            style: const TextStyle(
              color: navy,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        );
    }
  }

  _LetterBadge badge() => switch (state) {
        _OptionState.lockedCorrect => _LetterBadge.check,
        _OptionState.lockedWrong => _LetterBadge.cross,
        _ => _LetterBadge.neutral,
      };
}

enum _LetterBadge { neutral, check, cross }

class _ExplanationCard extends StatelessWidget {
  const _ExplanationCard({required this.isCorrect, required this.explanation});

  final bool isCorrect;
  final QuizExplanation explanation;

  @override
  Widget build(BuildContext context) {
    final verdictColor = isCorrect ? _correctGreen : _wrongRed;
    return Container(
      key: const ValueKey('quiz.explanation'),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: const Border(left: BorderSide(color: gold, width: 4)),
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
          Row(
            children: [
              Icon(
                isCorrect ? Icons.check_circle : Icons.cancel,
                color: verdictColor,
                size: 22,
              ),
              const SizedBox(width: 8),
              Text(
                isCorrect ? 'Correct!' : 'Not quite',
                style: TextStyle(
                  color: verdictColor,
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            explanation.core,
            style: const TextStyle(color: bodyGrey, fontSize: 14, height: 1.5),
          ),
          if (explanation.reference != null) ...[
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.menu_book_outlined,
                    color: bodyGrey, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    explanation.reference!,
                    style: const TextStyle(color: bodyGrey, fontSize: 13),
                  ),
                ),
              ],
            ),
          ],
          if (explanation.takeaway != null) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.balance, color: gold, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    explanation.takeaway!,
                    style: const TextStyle(
                      color: gold,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
