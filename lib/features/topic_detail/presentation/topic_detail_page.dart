import 'package:flutter/material.dart';

import '../../../core/presentation/widgets/nyaya_widgets.dart';
import 'topic_detail_view_model.dart';

const _cardBorder = Color(0xFFECE5DB);
const _sectionStripFill = Color(0xFFF7EFE2);
const _easyGreen = Color(0xFF1FA35B);
const _mediumGold = Color(0xFFD19A2E);
const _hardRed = Color(0xFFD64545);
const _templeAsset = 'assets/backgrounds/temple_bg.png';

class TopicDetailPage extends StatefulWidget {
  const TopicDetailPage({
    super.key,
    required this.onQuizSelected,
    required this.onContinueQuiz,
    this.viewModel,
  });

  final ValueChanged<String> onQuizSelected;
  final ValueChanged<String> onContinueQuiz;
  final TopicDetailViewModel? viewModel;

  @override
  State<TopicDetailPage> createState() => _TopicDetailPageState();
}

class _TopicDetailPageState extends State<TopicDetailPage> {
  late final TopicDetailViewModel _viewModel =
      widget.viewModel ?? TopicDetailViewModel();

  @override
  Widget build(BuildContext context) {
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
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        key: const ValueKey('topic.back'),
                        onPressed: () => Navigator.maybePop(context),
                        icon: const Icon(Icons.arrow_back, color: navy),
                        tooltip: 'Back',
                      ),
                      IconButton(
                        key: const ValueKey('topic.bookmark'),
                        onPressed: () => setState(_viewModel.toggleBookmark),
                        icon: Icon(
                          _viewModel.isBookmarked
                              ? Icons.bookmark
                              : Icons.bookmark_border,
                          color: gold,
                        ),
                        tooltip: _viewModel.isBookmarked
                            ? 'Remove bookmark'
                            : 'Bookmark topic',
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _viewModel.title,
                          style: Theme.of(context).textTheme.headlineMedium
                              ?.copyWith(
                                color: navy,
                                fontFamily: 'serif',
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          _viewModel.subtitle,
                          style: const TextStyle(color: bodyGrey, fontSize: 14),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Text(
                              '${_viewModel.quizCount} quizzes',
                              style: const TextStyle(
                                color: bodyGrey,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(width: 12),
                            _DifficultyChip(difficulty: _viewModel.difficulty),
                            const SizedBox(width: 12),
                            _ProgressRing(progress: _viewModel.progress),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _viewModel.description,
                          style: const TextStyle(
                            color: bodyGrey,
                            fontSize: 14,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: _sectionStripFill,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.menu_book_outlined,
                                color: gold,
                                size: 20,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  _viewModel.sectionReference,
                                  style: const TextStyle(
                                    color: bodyGrey,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Quizzes',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(
                                color: navy,
                                fontFamily: 'serif',
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                        const SizedBox(height: 12),
                        for (final (index, quiz)
                            in _viewModel.quizzes.indexed) ...[
                          _QuizRow(
                            position: index + 1,
                            quiz: quiz,
                            onTap: () => widget.onQuizSelected(quiz.id),
                          ),
                          const SizedBox(height: 12),
                        ],
                        const SizedBox(height: 80),
                      ],
                    ),
                  ),
                ),
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
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: () =>
                          widget.onContinueQuiz(_viewModel.continueQuizId),
                      child: Text(
                        _viewModel.continueLabel,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
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

  (String, Color) get _labelAndColor => switch (difficulty) {
    TopicDifficulty.easy => ('EASY', _easyGreen),
    TopicDifficulty.medium => ('MEDIUM', _mediumGold),
    TopicDifficulty.hard => ('HARD', _hardRed),
  };

  @override
  Widget build(BuildContext context) {
    final (label, color) = _labelAndColor;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
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
  final VoidCallback onTap;

  String get _difficultyLabel => switch (quiz.difficulty) {
    TopicDifficulty.easy => 'Easy',
    TopicDifficulty.medium => 'Medium',
    TopicDifficulty.hard => 'Hard',
  };

  String get _statusLabel => switch (quiz.status) {
    QuizStatus.completed => 'completed',
    QuizStatus.inProgress => 'in progress',
    QuizStatus.notStarted => 'not started',
  };

  Widget get _trailing => switch (quiz.status) {
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
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Text(
        'RESUME',
        style: TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.8,
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
    return Semantics(
      button: true,
      label:
          '${quiz.title}. ${quiz.questionCount} questions, '
          '$_difficultyLabel. $_statusLabel',
      child: InkWell(
        key: ValueKey('topic.quiz.${quiz.id}'),
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: ExcludeSemantics(
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: _cardBorder),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x0F000000),
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
                        '${quiz.questionCount} Questions · $_difficultyLabel',
                        style: const TextStyle(color: bodyGrey, fontSize: 13),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                _trailing,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
