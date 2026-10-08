import 'package:flutter/material.dart';

import '../../../app/theme/app_motion.dart';
import '../../../app/theme/app_tokens.dart';

import '../../../core/localization/l10n.dart';
import '../../../core/presentation/show_message.dart';
import '../../../core/presentation/widgets/nyaya_widgets.dart';
import 'quiz_session_view_model.dart';

const _correctGreen = NyayaColors.success;
const _correctTint = NyayaColors.successTint;
const _wrongRed = NyayaColors.danger;
const _wrongTint = NyayaColors.dangerTint;
const _cardBorder = NyayaColors.hairline;
const _disabledGrey = NyayaColors.inkDisabled;

class QuizQuestionPage extends StatefulWidget {
  const QuizQuestionPage({
    super.key,
    required this.onQuizCompleted,
    this.session,
  });

  /// Called after [QuizSession.finish] succeeds.
  final ValueChanged<List<QuizOutcome>> onQuizCompleted;

  /// Defaults to the sample session; the app passes a backend attempt.
  final QuizSession? session;

  @override
  State<QuizQuestionPage> createState() => _QuizQuestionPageState();
}

class _QuizQuestionPageState extends State<QuizQuestionPage> {
  late final QuizSession _session = widget.session ?? QuizSessionViewModel();

  /// True while an answer or the final submit is with the server.
  var _busy = false;

  final _scrollController = ScrollController();
  final _explanationKey = GlobalKey();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _answer(int option) async {
    if (_session.isAnswered || _busy) {
      return;
    }
    NyayaHaptics.select();
    setState(() => _busy = true);
    try {
      await _session.answer(option);
    } catch (_) {
      // The question stays open so the learner can tap again.
      if (mounted) showMessage(context, context.l10n.quizAnswerFailed);
    }
    if (!mounted) return;
    setState(() => _busy = false);
    if (!_session.isAnswered) return;
    _session.isCorrect ? NyayaHaptics.correct() : NyayaHaptics.wrong();
    // The explanation lands below the options, often under the footer
    // button; bring it into view (spec 037).
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final explanation = _explanationKey.currentContext;
      if (explanation == null || !mounted) return;
      Scrollable.ensureVisible(
        explanation,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        alignmentPolicy: ScrollPositionAlignmentPolicy.keepVisibleAtEnd,
      );
    });
  }

  Future<void> _next() async {
    if (_busy) return;
    if (!_session.isComplete) setState(_session.next);
    if (_session.isComplete) {
      setState(() => _busy = true);
      try {
        await _session.finish();
      } catch (_) {
        // Next stays on screen; tapping it again retries the submit.
        if (mounted) {
          setState(() => _busy = false);
          showMessage(context, context.l10n.quizSubmitFailed);
        }
        return;
      }
      if (mounted) widget.onQuizCompleted(_session.outcomes);
      return;
    }
    // Each question starts at the top.
    if (_scrollController.hasClients) _scrollController.jumpTo(0);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
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
                    tooltip: l10n.quizExit,
                  ),
                  Expanded(
                    child: Text(
                      l10n.quizCounter(
                        _session.currentIndex + 1,
                        _session.questions.length,
                      ),
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
                controller: _scrollController,
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
                        borderRadius: BorderRadius.circular(NyayaRadii.md),
                        boxShadow: const [
                          BoxShadow(
                            color: NyayaColors.shadowMid,
                            blurRadius: 12,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Text(
                        question.stem,
                        style: const TextStyle(
                          color: navy,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          height: 1.4,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    for (final (index, option) in question.options.indexed) ...[
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
                        key: _explanationKey,
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
                            borderRadius: BorderRadius.circular(
                              NyayaRadii.pill,
                            ),
                          ),
                        ),
                        onPressed: _busy ? null : _next,
                        child: Text(
                          l10n.commonNext,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      )
                    : Container(
                        key: const ValueKey('quiz.selectbar'),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: _disabledGrey.withValues(alpha: 0.4),
                          borderRadius: BorderRadius.circular(NyayaRadii.pill),
                        ),
                        child: Text(
                          l10n.quizSelectAnswer,
                          style: const TextStyle(
                            color: _disabledGrey,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
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
    if (index == _session.correctOption) {
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

    final l10n = context.l10n;
    final stateLabel = switch (state) {
      _OptionState.neutral => null,
      _OptionState.lockedCorrect => l10n.quizYourAnswerCorrect,
      _OptionState.lockedWrong => l10n.quizYourAnswerWrong,
      _OptionState.revealedCorrect => l10n.quizCorrectAnswer,
    };
    final optionLabel = l10n.quizOptionLabel(letter, text);

    return Semantics(
      button: true,
      label: stateLabel == null ? optionLabel : '$optionLabel. $stateLabel',
      child: InkWell(
        key: ValueKey('quiz.option.$letter'),
        borderRadius: BorderRadius.circular(NyayaRadii.sm),
        onTap: onTap,
        child: ExcludeSemantics(
          // Color and border ease into the verdict (spec 039).
          child: AnimatedContainer(
            duration: NyayaMotion.of(context, NyayaMotion.medium),
            curve: NyayaMotion.curve,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: fill,
              borderRadius: BorderRadius.circular(NyayaRadii.sm),
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
        final ringColor = state == _OptionState.revealedCorrect
            ? _correctGreen
            : gold;
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
  const _ExplanationCard({
    super.key,
    required this.isCorrect,
    required this.explanation,
  });

  final bool isCorrect;
  final QuizExplanation explanation;

  @override
  Widget build(BuildContext context) {
    final verdictColor = isCorrect ? _correctGreen : _wrongRed;
    // Slides and fades up into place (spec 039).
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: NyayaMotion.of(context, NyayaMotion.medium),
      curve: NyayaMotion.curve,
      builder: (context, t, child) => Opacity(
        opacity: t,
        child: Transform.translate(
          offset: Offset(0, 16 * (1 - t)),
          child: child,
        ),
      ),
      child: _card(context, verdictColor),
    );
  }

  Widget _card(BuildContext context, Color verdictColor) {
    return Container(
      key: const ValueKey('quiz.explanation'),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(NyayaRadii.sm),
        border: const Border(left: BorderSide(color: gold, width: 4)),
        boxShadow: const [
          BoxShadow(
            color: NyayaColors.shadowMid,
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
                isCorrect
                    ? context.l10n.quizVerdictCorrect
                    : context.l10n.quizVerdictWrong,
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
                const Icon(Icons.menu_book_outlined, color: bodyGrey, size: 18),
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
