import '../models/category.dart';
import '../services/api_exceptions.dart';
import '../services/auth_storage.dart';
import '../services/categories_api_service.dart';

/// A category paired with its live module (quiz) count.
class CategoryRecommendation {
  const CategoryRecommendation({required this.category, required this.moduleCount});

  final Category category;
  final int moduleCount;
}

/// The single source of truth for "what categories should the Home screen
/// recommend", backed entirely by GET /api/v1/categories. Never returns
/// invented data — callers get real categories or a thrown exception.
class CategoriesRepository {
  CategoriesRepository({CategoriesApiService? api, AuthStorage? authStorage})
      : _api = api ?? CategoriesApiService(),
        _authStorage = authStorage ?? AuthStorage();

  final CategoriesApiService _api;
  final AuthStorage _authStorage;

  /// Throws [UnauthenticatedException] if there's no session, or
  /// [ApiException]/[NetworkException] if the request fails.
  Future<List<CategoryRecommendation>> getRecommended() async {
    final token = await _authStorage.readToken();
    if (token == null) {
      throw UnauthenticatedException();
    }

    final categories = await _api.fetchCategories(token);

    final moduleCounts = await Future.wait(
      categories.map((category) async {
        try {
          return await _api.fetchQuizCount(token, category.id);
        } catch (_) {
          // One category's quiz count failing shouldn't hide the category
          // itself — just show it with an unknown module count.
          return 0;
        }
      }),
    );

    return [
      for (var i = 0; i < categories.length; i++)
        CategoryRecommendation(category: categories[i], moduleCount: moduleCounts[i]),
    ];
  }
}
