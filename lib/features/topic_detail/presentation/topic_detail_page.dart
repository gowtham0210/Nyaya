import 'package:flutter/material.dart';

import '../../../app/theme/app_tokens.dart';

import '../../../app/theme/app_typography.dart';

import '../../../core/localization/l10n.dart';
import '../../../core/presentation/widgets/load_state_view.dart';
import '../../../core/presentation/widgets/nyaya_widgets.dart';
import 'topic_detail_view_model.dart';

const _cardBorder = NyayaColors.hairline;
const _easyGreen = NyayaDifficulty.easy;
const _mediumGold = NyayaDifficulty.medium;
const _hardRed = NyayaDifficulty.hard;
const _templeAsset = 'assets/backgrounds/temple_bg.png';

class TopicDetailPage extends StatefulWidget {
  const TopicDetailPage({
    super.key,
    required this.viewModel,
    required this.onQuizSelected,
  });

  /// The topic's quizzes and progress from the backend (spec 038).
  final TopicDetailViewModel viewModel;

  /// Opens a quiz; also used by the bottom Start/Continue button.
  final ValueChanged<TopicQuiz> onQuizSelected;

  @override
  State<TopicDetailPage> createState() => _TopicDetailPageState();
}

class _TopicDetailPageState extends State<TopicDetailPage> {
  TopicDetailViewModel get _viewModel => widget.viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel.ensureLoaded();
  }

  String _continueLabel(AppLocalizations l10n, TopicQuiz target) =>
      switch (target.status) {
        QuizStatus.inProgress => l10n.topicContinueQuiz(
          _viewModel.continueNumber,
        ),
        QuizStatus.notStarted => l10n.topicStartQuiz(_viewModel.continueNumber),
        QuizStatus.completed => l10n.topicPracticeAgain,
      };

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      backgroundColor: ivory,
      body: Stack(
        children: [
          Positioned(
            right: -20,
            top: 100,
            child: ExcludeSemantics(
              child: Opacity(
                opacity: 0.12,
                child: Image.asset(_templeAsset, width: 240),
              ),
            ),
          ),
          const Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: ExcludeSemantics(child: BackgroundWave()),
          ),
          SafeArea(
            child: ListenableBuilder(
              listenable: _viewModel,
              builder: (context, _) {
                final target = _viewModel.continueTarget;
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: IconButton(
                          key: const ValueKey('topic.back'),
                          onPressed: () => Navigator.maybePop(context),
                          icon: const Icon(Icons.arrow_back, color: navy),
                          tooltip: MaterialLocalizations.of(
                            context,
                          ).backButtonTooltip,
                        ),
                      ),
                    ),
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: _viewModel.load,
                        child: ListView(
                          key: const ValueKey('topic.scroll'),
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          children: [
                            Text(
                              _viewModel.title,
                              key: const ValueKey('topic.title'),
                              style: Theme.of(context).textTheme.headlineMedium
                                  ?.copyWith(
                                    color: navy,
                                    fontFamily: NyayaFonts.display,
                                    fontWeight: FontWeight.w700,
                                  ),
                            ),
                            if (_viewModel.quizzes.isNotEmpty) ...[
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Text(
                                    l10n.quizCount(_viewModel.quizzes.length),
                                    style: const TextStyle(
                                      color: bodyGrey,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  _DifficultyChip(
                                    difficulty: _viewModel.difficulty,
                                  ),
                                  const SizedBox(width: 12),
                                  _ProgressRing(progress: _viewModel.progress),
                                ],
                              ),
                            ],
                            if (_viewModel.description case final text?
                                when text.trim().isNotEmpty) ...[
                              const SizedBox(height: 16),
                              Text(
                                text,
                                style: const TextStyle(
                                  color: bodyGrey,
                                  fontSize: 14,
                                  height: 1.5,
                                ),
                              ),
                            ],
                            const SizedBox(height: 20),
                            Text(
                              l10n.topicQuizzesHeading,
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(
                                    color: navy,
                                    fontFamily: NyayaFonts.display,
                                    fontWeight: FontWeight.w700,
                                  ),
                            ),
                            const SizedBox(height: 12),
                            LoadStateView<List<TopicQuiz>>(
                              state: _viewModel.state,
                              onRetry: _viewModel.load,
                              emptyMessage: l10n.topicNoQuizzes,
                              emptyIcon: Icons.quiz_outlined,
                              builder: (context, quizzes) => Column(
                                children: [
                                  for (final (index, quiz) in quizzes.indexed)
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: 12,
                                      ),
                                      child: _QuizRow(
                                        position: index + 1,
                                        quiz: quiz,
                                        onTap: quiz.isLocked
                                            ? null
                                            : () => widget.onQuizSelected(quiz),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 80),
                          ],
                        ),
                      ),
                    ),
                    if (target != null)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(24, 8, 24, 12),
                        child: SizedBox(
                          height: 54,
                          width: double.infinity,
                          child: ElevatedButton(
                            key: const ValueKey('topic.continue'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: gold,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  NyayaRadii.pill,
                                ),
                              ),
                            ),
                            onPressed: () => widget.onQuizSelected(target),
                            child: Text(
                              _continueLabel(l10n, target),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _DifficultyChip extends StatelessWidget {
  const _DifficultyChip({required this.difficulty});

  final TopicDifficulty difficulty;

  Color get _color => switch (difficulty) {
    TopicDifficulty.easy => _easyGreen,
    TopicDifficulty.medium => _mediumGold,
    TopicDifficulty.hard => _hardRed,
  };

  @override
  Widget build(BuildContext context) {
    final label = _difficultyLabel(context.l10n, difficulty).toUpperCase();
    final color = _color;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(NyayaRadii.md),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}

class _ProgressRing extends StatelessWidget {
  const _ProgressRing({required this.progress});

  final double progress;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 44,
      height: 44,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircularProgressIndicator(
            value: progress,
            strokeWidth: 3,
            color: gold,
            backgroundColor: progressTrack,
          ),
          Text(
            '${(progress * 100).round()}%',
            style: const TextStyle(
              color: navy,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _QuizRow extends StatelessWidget {
  const _QuizRow({
    required this.position,
    required this.quiz,
    required this.onTap,
  });

  final int position;
  final TopicQuiz quiz;

  /// Null for a locked quiz.
  final VoidCallback? onTap;

  String _statusLabel(AppLocalizations l10n) => switch (quiz.status) {
    QuizStatus.completed => l10n.quizStatusCompleted,
    QuizStatus.inProgress => l10n.quizStatusInProgress,
    QuizStatus.notStarted => l10n.quizStatusNotStarted,
  };

  Widget _trailing(AppLocalizations l10n) => quiz.isLocked
      ? Icon(
          Icons.lock_outline_rounded,
          key: ValueKey('topic.quiz.locked.${quiz.id}'),
          color: bodyGrey,
        )
      : switch (quiz.status) {
          QuizStatus.completed => Container(
            key: ValueKey('topic.quiz.completed.${quiz.id}'),
            width: 30,
            height: 30,
            decoration: const BoxDecoration(
              color: _easyGreen,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.check, color: Colors.white, size: 18),
          ),
          QuizStatus.inProgress => Container(
            key: ValueKey('topic.quiz.resume.${quiz.id}'),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: navy,
              borderRadius: BorderRadius.circular(NyayaRadii.md),
            ),
            child: Text(
              l10n.commonResume,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          QuizStatus.notStarted => Icon(
            Icons.chevron_right,
            key: ValueKey('topic.quiz.chevron.${quiz.id}'),
            color: bodyGrey,
          ),
        };

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final difficulty = _difficultyLabel(l10n, quiz.difficulty);
    final lockNote = quiz.isLocked && quiz.requiredPoints != null
        ? l10n.quizUnlocksAt(quiz.requiredPoints!)
        : null;
    return Semantics(
      button: true,
      label: l10n.topicQuizSemantics(
        quiz.title,
        quiz.questionCount,
        difficulty,
        lockNote ?? _statusLabel(l10n),
      ),
      child: InkWell(
        key: ValueKey('topic.quiz.${quiz.id}'),
        borderRadius: BorderRadius.circular(NyayaRadii.md),
        onTap: onTap,
        child: ExcludeSemantics(
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(NyayaRadii.md),
              border: Border.all(color: _cardBorder),
              boxShadow: const [
                BoxShadow(
                  color: NyayaColors.shadowSoft,
                  blurRadius: 10,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    color: gold,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '$position',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        quiz.title,
                        style: const TextStyle(
                          color: navy,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        lockNote ??
                            '${l10n.questionCount(quiz.questionCount)} · '
                                '$difficulty',
                        style: const TextStyle(color: bodyGrey, fontSize: 13),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                _trailing(l10n),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

String _difficultyLabel(AppLocalizations l10n, TopicDifficulty difficulty) =>
    switch (difficulty) {
      TopicDifficulty.easy => l10n.difficultyEasy,
      TopicDifficulty.medium => l10n.difficultyMedium,
      TopicDifficulty.hard => l10n.difficultyHard,
    };
