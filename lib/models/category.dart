/// A quiz category, matching the backend's `Category` schema exactly
/// (see nyaya_backend/openAPI_schema.yaml, components.schemas.Category).
/// Only fields the backend actually returns are modelled here — no
/// invented `image`/`rating`/`moduleCount` fields.
class Category {
  const Category({
    required this.id,
    required this.name,
    required this.slug,
    required this.description,
    required this.isActive,
  });

  final int id;
  final String name;
  final String slug;
  final String? description;
  final bool isActive;

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] as int,
      name: json['name'] as String,
      slug: json['slug'] as String,
      description: json['description'] as String?,
      isActive: json['isActive'] as bool? ?? true,
    );
  }
}
