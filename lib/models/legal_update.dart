/// A legal update, matching the backend's `LegalUpdate` schema exactly
/// (see serializeLegalUpdate in nyaya_backend src/utils/serializers.js).
class LegalUpdate {
  const LegalUpdate({
    required this.id,
    required this.category,
    required this.title,
    required this.summary,
    required this.updateDate,
    required this.source,
    required this.imageUrl,
  });

  final int id;
  final String category;
  final String title;
  final String summary;
  final String updateDate;
  final String? source;
  final String? imageUrl;

  factory LegalUpdate.fromJson(Map<String, dynamic> json) {
    return LegalUpdate(
      id: json['id'] as int,
      category: json['category'] as String,
      title: json['title'] as String,
      summary: json['summary'] as String,
      updateDate: json['updateDate'] as String,
      source: json['source'] as String?,
      imageUrl: json['imageUrl'] as String?,
    );
  }
}
