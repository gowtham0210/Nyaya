import '../../../core/presentation/load_state_notifier.dart';
import '../data/articles_repository.dart';

export '../data/articles_repository.dart' show Article;

/// The Articles tab (spec 019): the articles and which one is expanded.
class ArticlesViewModel extends LoadStateNotifier<List<Article>> {
  ArticlesViewModel({required ArticlesRepository repository})
    : _repository = repository;

  final ArticlesRepository _repository;
  int? _expandedId;

  @override
  Future<List<Article>> fetch() => _repository.fetchArticles();

  @override
  bool isEmpty(List<Article> articles) => articles.isEmpty;

  bool isExpanded(int articleId) => _expandedId == articleId;

  /// Expands [articleId] (collapsing any other), or collapses it if open.
  void toggle(int articleId) {
    _expandedId = _expandedId == articleId ? null : articleId;
    notifyListeners();
  }
}
