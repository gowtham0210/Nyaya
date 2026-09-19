import '../models/article.dart';
import '../services/api_exceptions.dart';
import '../services/articles_api_service.dart';
import '../services/auth_storage.dart';

/// The single source of truth for the Articles list, backed entirely by
/// GET /api/v1/articles. Never returns invented data.
class ArticlesRepository {
  ArticlesRepository({ArticlesApiService? api, AuthStorage? authStorage})
      : _api = api ?? ArticlesApiService(),
        _authStorage = authStorage ?? AuthStorage();

  final ArticlesApiService _api;
  final AuthStorage _authStorage;

  /// Throws [UnauthenticatedException] if there's no session, or
  /// [ApiException]/[NetworkException] if the request fails.
  Future<List<Article>> getArticles() async {
    final token = await _authStorage.readToken();
    if (token == null) {
      throw UnauthenticatedException();
    }
    return _api.fetchArticles(token);
  }
}
