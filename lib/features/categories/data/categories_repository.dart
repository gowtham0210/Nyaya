import '../../../core/network/api_client.dart';

/// A law category as the backend returns it, plus its quiz count.
class LawCategory {
  const LawCategory({
    required this.id,
    required this.name,
    required this.slug,
    this.description,
    this.quizCount,
  });

  final int id;
  final String name;
  final String slug;
  final String? description;

  /// Active quizzes in this category; null when the count couldn't load.
  final int? quizCount;
}

/// Categories from `GET /categories`, each with its quiz count from
/// `GET /categories/:id/quizzes` (the list has no count of its own).
class CategoriesRepository {
  CategoriesRepository(this._client);

  final ApiClient _client;

  Future<List<LawCategory>> fetchCategories() async {
    final body = await _client.get('/categories');
    final active = [
      for (final item in body['items'] as List<dynamic>? ?? const [])
        if (item is Map<String, dynamic> && item['isActive'] != false) item,
    ];
    final counts = await Future.wait(
      active.map((item) => _quizCount(item['id'] as int)),
    );
    return [
      for (var i = 0; i < active.length; i++)
        LawCategory(
          id: active[i]['id'] as int,
          name: active[i]['name'] as String,
          slug: active[i]['slug'] as String,
          description: active[i]['description'] as String?,
          quizCount: counts[i],
        ),
    ];
  }

  Future<int?> _quizCount(int categoryId) async {
    try {
      final body = await _client.get('/categories/$categoryId/quizzes');
      return (body['items'] as List<dynamic>? ?? const []).length;
    } on ApiException {
      // A missing count shouldn't hide the category itself.
      return null;
    }
  }
}
