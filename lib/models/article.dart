/// A Constitution article/topic entry, matching the backend's `Article`
/// schema exactly (see serializeArticle in nyaya_backend
/// src/utils/serializers.js).
class Article {
  const Article({
    required this.id,
    required this.part,
    required this.partTitle,
    required this.title,
    required this.slug,
    required this.articleRange,
    required this.description,
    required this.whatItMeans,
    required this.whyItMatters,
    required this.keyFeatures,
    required this.displayOrder,
  });

  final int id;
  final String part;
  final String partTitle;
  final String title;
  final String slug;
  final String articleRange;
  final String description;
  final String? whatItMeans;
  final String? whyItMatters;
  final String? keyFeatures;
  final int displayOrder;

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      id: json['id'] as int,
      part: json['part'] as String,
      partTitle: json['partTitle'] as String,
      title: json['title'] as String,
      slug: json['slug'] as String,
      articleRange: json['articleRange'] as String,
      description: json['description'] as String,
      whatItMeans: json['whatItMeans'] as String?,
      whyItMatters: json['whyItMatters'] as String?,
      keyFeatures: json['keyFeatures'] as String?,
      displayOrder: json['displayOrder'] as int? ?? 0,
    );
  }
}
