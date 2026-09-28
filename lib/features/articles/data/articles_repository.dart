import '../../../core/network/api_client.dart';

/// A Constitution article as the backend returns it.
class Article {
  const Article({
    required this.id,
    required this.part,
    required this.partTitle,
    required this.title,
    required this.articleRange,
    required this.description,
    required this.keyFeatures,
    this.whatItMeans,
    this.whyItMatters,
  });

  final int id;

  /// Constitution part, e.g. `III`.
  final String part;
  final String partTitle;
  final String title;

  /// e.g. `Articles 14–18`.
  final String articleRange;
  final String description;
  final String? whatItMeans;
  final String? whyItMatters;
  final List<String> keyFeatures;
}

/// Articles from `GET /articles`, in display order.
class ArticlesRepository {
  ArticlesRepository(this._client);

  final ApiClient _client;

  Future<List<Article>> fetchArticles() async {
    final body = await _client.get('/articles');
    final items = [
      for (final item in body['items'] as List<dynamic>? ?? const [])
        item as Map<String, dynamic>,
    ]..sort(_byDisplayOrder);
    return [for (final item in items) _toArticle(item)];
  }

  /// Display order, then id; articles without an order go last.
  static int _byDisplayOrder(Map<String, dynamic> a, Map<String, dynamic> b) {
    final byOrder = _order(a).compareTo(_order(b));
    return byOrder != 0 ? byOrder : (a['id'] as int).compareTo(b['id'] as int);
  }

  static num _order(Map<String, dynamic> json) =>
      (json['displayOrder'] as num?) ?? double.infinity;

  static Article _toArticle(Map<String, dynamic> json) => Article(
    id: json['id'] as int,
    part: json['part'] as String? ?? '',
    partTitle: json['partTitle'] as String? ?? '',
    title: json['title'] as String,
    articleRange: json['articleRange'] as String? ?? '',
    description: json['description'] as String? ?? '',
    whatItMeans: _text(json['whatItMeans']),
    whyItMatters: _text(json['whyItMatters']),
    keyFeatures: [
      for (final feature in (_text(json['keyFeatures']) ?? '').split(';'))
        if (feature.trim().isNotEmpty) feature.trim(),
    ],
  );

  /// Trimmed text, or null when missing or blank.
  static String? _text(Object? value) {
    final text = (value as String?)?.trim();
    return text == null || text.isEmpty ? null : text;
  }
}
