import 'package:flutter/material.dart';

import '../core/localization/l10n.dart';
import '../core/network/api_client.dart';
import '../features/categories/data/categories_repository.dart';
import '../features/categories/presentation/categories_page.dart';
import '../features/categories/presentation/categories_view_model.dart';
import '../features/home/data/daily_questions_repository.dart';
import '../features/home/data/progress_repository.dart';
import '../features/home/presentation/daily_questions_view_model.dart';
import '../features/home/presentation/home_page.dart';
import '../features/home/presentation/home_view_model.dart';
import '../features/home/presentation/learning_progress_view_model.dart';
import '../features/home/presentation/recommended_page.dart';
import '../features/legal_updates/data/legal_updates_repository.dart';
import '../features/legal_updates/presentation/legal_updates_page.dart';
import '../features/legal_updates/presentation/legal_updates_view_model.dart';
import '../features/quiz_question/presentation/quiz_question_page.dart';
import '../features/quiz_result/presentation/quiz_result_page.dart';
import '../features/quiz_result/presentation/quiz_result_view_model.dart';
import '../features/shell/presentation/coming_soon_tab.dart';
import '../features/shell/presentation/tab_shell_page.dart';
import '../features/topic_detail/presentation/topic_detail_page.dart';
import '../features/topic_detail/presentation/topic_detail_view_model.dart';
import '../core/presentation/show_message.dart';
import 'app_services.dart';
import 'session_actions.dart';
import 'session_expiry_listener.dart';

/// The shell's tabs, in bottom-nav order. [name] is the tab id.
enum MainTab { home, categories, leaderboard, articles, profile }

/// The signed-in app: five tabs under one bottom nav (spec 016).
class MainShell extends StatefulWidget {
  const MainShell({super.key, this.apiClient});

  /// Backend client for the tabs' data; tests pass a fake.
  final ApiClient? apiClient;

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  final _controller = TabShellController();
  late final ApiClient _apiClient = widget.apiClient ?? AppServices.apiClient;

  // Tab view models live as long as the shell so each tab keeps its data.
  late final _categoriesViewModel = CategoriesViewModel(
    repository: CategoriesRepository(_apiClient),
  );
  late final _dailyQuestionsViewModel = DailyQuestionsViewModel(
    repository: DailyQuestionsRepository(_apiClient),
  );
  late final _progressViewModel = LearningProgressViewModel(
    repository: ProgressRepository(_apiClient),
  );
  late final _legalUpdatesViewModel = LegalUpdatesViewModel(
    repository: LegalUpdatesRepository(_apiClient),
  );

  @override
  void dispose() {
    _controller.dispose();
    _categoriesViewModel.dispose();
    _dailyQuestionsViewModel.dispose();
    _legalUpdatesViewModel.dispose();
    _progressViewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return SessionExpiryListener(
      sessionExpired: AppServices.sessionExpired,
      onExpired: (context) =>
          endSession(context, message: context.l10n.errorSessionExpired),
      child: TabShellPage(
        controller: _controller,
        tabs: [
          _tab(MainTab.home, l10n.navHome, HomeIconType.navHome, _buildHome),
          _tab(
            MainTab.categories,
            l10n.navCategories,
            HomeIconType.navCategories,
            (_) => CategoriesPage(viewModel: _categoriesViewModel),
          ),
          _comingSoon(
            MainTab.leaderboard,
            l10n.navLeaderboard,
            HomeIconType.navLeaderboard,
          ),
          _comingSoon(
            MainTab.articles,
            l10n.navArticles,
            HomeIconType.navArticles,
          ),
          _comingSoon(
            MainTab.profile,
            l10n.navProfile,
            HomeIconType.navProfile,
          ),
        ],
      ),
    );
  }

  ShellTab _tab(
    MainTab tab,
    String label,
    HomeIconType icon,
    WidgetBuilder builder,
  ) => ShellTab(id: tab.name, label: label, icon: icon, builder: builder);

  ShellTab _comingSoon(MainTab tab, String label, HomeIconType icon) =>
      _tab(tab, label, icon, (_) => ComingSoonTab(title: label, icon: icon));

  Widget _buildHome(BuildContext context) {
    return HomePage(
      viewModel: const HomeViewModel(),
      dailyQuestions: _dailyQuestionsViewModel,
      legalUpdates: _legalUpdatesViewModel,
      progress: _progressViewModel,
      categories: _categoriesViewModel,
      // Provisional wire until the Topics tab exists.
      onResumePressed: () => Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (topicContext) => TopicDetailPage(
            onQuizSelected: (quizId) => _startQuiz(topicContext, quizId),
            onContinueQuiz: (quizId) => _startQuiz(topicContext, quizId),
          ),
        ),
      ),
      onViewAllCategoriesPressed: () =>
          _controller.select(MainTab.categories.index),
      onViewAllRecommendedPressed: () => Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (pageContext) => RecommendedPage(
            viewModel: _categoriesViewModel,
            // Category screens don't exist yet; same message as on Home.
            onCategorySelected: (category) => showMessage(
              pageContext,
              pageContext.l10n.featureComingSoon(category.label),
            ),
          ),
        ),
      ),
      onViewAllLegalUpdatesPressed: () => Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => LegalUpdatesPage(viewModel: _legalUpdatesViewModel),
        ),
      ),
    );
  }
}

/// The sample session ignores the quiz id for its questions, but uses it to
/// name the topic on the result screen.
void _startQuiz(BuildContext context, String quizId) {
  final title = _quizTitle(quizId);
  Navigator.of(context).push(
    MaterialPageRoute<void>(
      builder: (quizContext) => QuizQuestionPage(
        onQuizCompleted: (outcomes) =>
            Navigator.of(quizContext).pushReplacement(
              MaterialPageRoute<void>(
                builder: (resultContext) => QuizResultPage(
                  viewModel: QuizResultViewModel(
                    outcomes: outcomes,
                    topicTitle: title,
                  ),
                  // Review answers (Phase 9) lands next; no-op for now.
                  onReviewAnswers: () {},
                  onBackToTopic: () => Navigator.of(resultContext).pop(),
                ),
              ),
            ),
      ),
    ),
  );
}

String _quizTitle(String quizId) {
  final quizzes = TopicDetailViewModel().quizzes;
  return quizzes
      .firstWhere((quiz) => quiz.id == quizId, orElse: () => quizzes.first)
      .title;
}
