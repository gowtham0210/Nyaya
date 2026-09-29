import 'package:flutter/material.dart';

import '../../../app/app_session.dart';
import '../../../app/user_api.dart';
import '../../home/presentation/home_page.dart';
import '../../home/presentation/home_view_model.dart';
import '../../quiz_question/data/quiz_api.dart';
import '../data/category_content.dart';

/// Landing page for a single Home category: title, icon, description, and
/// its quizzes — or an empty state when none exist yet. Every category
/// except Criminal & Evidence Law (which opens its quiz directly) routes
/// here, so this is the shared template new categories grow into.
class CategoryDetailPage extends StatelessWidget {
  const CategoryDetailPage({
    super.key,
    required this.category,
    this.content,
    this.onBackPressed,
    this.onQuizSelected,
    this.quizApi,
    this.userApi,
  });

  final HomeCategoryData category;
  final CategoryContent? content;
  final VoidCallback? onBackPressed;
  final ValueChanged<CategoryQuizSummary>? onQuizSelected;

  /// Overridden in tests; default to real backends for the category
  /// leaderboard card.
  final QuizApi? quizApi;
  final UserApi? userApi;

  @override
  Widget build(BuildContext context) {
    final resolvedContent = content ?? categoryContentFor(category.id);

    return Scaffold(
      backgroundColor: HomePage.pageBackground,
      body: SafeArea(
        child: ListView(
          key: ValueKey('category.scroll.${category.id}'),
          padding: const EdgeInsets.fromLTRB(24, 4, 24, 32),
          children: [
            IconButton(
              key: const ValueKey('category.back'),
              onPressed: () {
                final callback = onBackPressed;
                if (callback != null) {
                  callback();
                  return;
                }
                Navigator.of(context).maybePop();
              },
              icon: const Icon(
                Icons.arrow_back_rounded,
                color: HomePage.heroBackground,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: HomePage.heroBackground,
                borderRadius: BorderRadius.circular(20),
              ),
              alignment: Alignment.center,
              child: HomeIcon(
                type: category.icon,
                size: 34,
                color: Colors.white,
                accentColor: HomePage.heroHighlight,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              category.label,
              key: ValueKey('category.title.${category.id}'),
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w700,
                color: HomePage.heroBackground,
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              resolvedContent.description,
              key: ValueKey('category.description.${category.id}'),
              style: const TextStyle(
                fontSize: 14,
                color: HomePage.supportText,
                height: 1.5,
              ),
            ),
            if (resolvedContent.articleContent.isNotEmpty) ...[
              const SizedBox(height: 24),
              Container(
                key: ValueKey('category.article.${category.id}'),
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: HomePage.cardBorder),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Overview',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: HomePage.heroBackground,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      resolvedContent.articleContent,
                      style: const TextStyle(
                        fontSize: 14,
                        color: HomePage.heroBackground,
                        height: 1.55,
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 28),
            const Text(
              'Quizzes',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: HomePage.heroBackground,
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(height: 16),
            if (resolvedContent.quizzes.isEmpty)
              _EmptyQuizzesCard(key: ValueKey('category.empty.${category.id}'))
            else
              for (final quiz in resolvedContent.quizzes) ...[
                _CategoryQuizRow(
                  quiz: quiz,
                  onTap: () => onQuizSelected?.call(quiz),
                ),
                const SizedBox(height: 12),
              ],
            const SizedBox(height: 12),
            _CategoryLeaderboardCard(
              key: ValueKey('category.leaderboard.${category.id}'),
              categorySlug: category.id.replaceAll('_', '-'),
              quizApi: quizApi,
              userApi: userApi,
            ),
          ],
        ),
      ),
    );
  }
}

enum _LeaderboardStatus { loading, loaded, empty, unavailable }

/// Top learners for this specific category, scoped by points earned on its
/// quizzes. Resolves [categorySlug] (the app's local category id, with
/// underscores swapped for the hyphens the backend's slugs use) to a real
/// category id, then reads `/leaderboards/category/:id`.
///
/// Signed out, offline, or a category the backend doesn't know about (a
/// dev/demo environment without seeded categories) all resolve to nothing
/// rendered — this card is a bonus on top of the quiz list above it, not
/// something worth showing an error box for.
class _CategoryLeaderboardCard extends StatefulWidget {
  const _CategoryLeaderboardCard({
    super.key,
    required this.categorySlug,
    this.quizApi,
    this.userApi,
  });

  final String categorySlug;
  final QuizApi? quizApi;
  final UserApi? userApi;

  @override
  State<_CategoryLeaderboardCard> createState() =>
      _CategoryLeaderboardCardState();
}

class _CategoryLeaderboardCardState extends State<_CategoryLeaderboardCard> {
  var _status = _LeaderboardStatus.loading;
  List<RemoteLeaderboardEntry> _entries = const [];
  int? _currentUserId;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final quizApi = widget.quizApi ?? QuizApi();
      final userApi = widget.userApi ?? UserApi();
      final categoryId = await quizApi.findCategoryIdBySlug(
        widget.categorySlug,
      );
      if (categoryId == null) {
        if (mounted) {
          setState(() => _status = _LeaderboardStatus.unavailable);
        }
        return;
      }

      final entries = await userApi.fetchCategoryLeaderboard(
        categoryId,
        limit: 5,
      );
      int? currentUserId;
      if (AppSession.accessToken != null) {
        try {
          currentUserId = await userApi.fetchCurrentUserId();
        } on Object {
          // Not fatal — the ranking still shows, just without a "YOU" tag.
        }
      }

      if (!mounted) {
        return;
      }
      setState(() {
        _entries = entries;
        _currentUserId = currentUserId;
        _status = entries.isEmpty
            ? _LeaderboardStatus.empty
            : _LeaderboardStatus.loaded;
      });
    } on Object {
      if (mounted) {
        setState(() => _status = _LeaderboardStatus.unavailable);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    switch (_status) {
      case _LeaderboardStatus.unavailable:
        return const SizedBox.shrink();
      case _LeaderboardStatus.loading:
        return const Center(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(strokeWidth: 2.5),
            ),
          ),
        );
      case _LeaderboardStatus.empty:
        return _CategoryLeaderboardShell(
          child: Text(
            'No one has finished a quiz here yet — be the first!',
            key: const ValueKey('category.leaderboard.empty'),
            style: const TextStyle(fontSize: 13, color: HomePage.supportText),
          ),
        );
      case _LeaderboardStatus.loaded:
        return _CategoryLeaderboardShell(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (final entry in _entries)
                Padding(
                  key: ValueKey('category.leaderboard.row.${entry.rank}'),
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 24,
                        child: Text(
                          '${entry.rank}',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: HomePage.supportText,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          entry.fullName,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: HomePage.heroBackground,
                          ),
                        ),
                      ),
                      if (entry.userId == _currentUserId) ...[
                        const SizedBox(width: 6),
                        const Text(
                          'YOU',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            color: HomePage.heroHighlight,
                          ),
                        ),
                      ],
                      const SizedBox(width: 8),
                      Text(
                        '${entry.totalPoints} pts',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: HomePage.heroBackground,
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
}

class _CategoryLeaderboardShell extends StatelessWidget {
  const _CategoryLeaderboardShell({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: HomePage.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Top Learners Here',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: HomePage.heroBackground,
            ),
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }
}

class _EmptyQuizzesCard extends StatelessWidget {
  const _EmptyQuizzesCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: HomePage.cardBorder),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.hourglass_empty_rounded,
            size: 32,
            color: HomePage.mutedIcon,
          ),
          const SizedBox(height: 12),
          const Text(
            'Content coming soon',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: HomePage.heroBackground,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            "We're building quizzes and study material for this category. "
            'Check back soon.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: HomePage.supportText,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryQuizRow extends StatelessWidget {
  const _CategoryQuizRow({required this.quiz, required this.onTap});

  final CategoryQuizSummary quiz;
  final VoidCallback onTap;

  Color get _difficultyColor => switch (quiz.difficulty) {
    QuizDifficulty.easy => HomePage.easyColor,
    QuizDifficulty.medium => HomePage.mediumColor,
    QuizDifficulty.hard => HomePage.hardColor,
  };

  @override
  Widget build(BuildContext context) {
    return InkWell(
      key: ValueKey('category.quiz.${quiz.id}'),
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: HomePage.cardBorder),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    quiz.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: HomePage.heroBackground,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        '${quiz.questionCount} Questions',
                        style: const TextStyle(
                          fontSize: 13,
                          color: HomePage.supportText,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        quiz.difficulty.label,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: _difficultyColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: HomePage.mutedIcon),
          ],
        ),
      ),
    );
  }
}
