/// An Indian state / union territory (GET /help-resources/states).
class IndianState {
  const IndianState({required this.code, required this.name});

  final String code;
  final String name;

  factory IndianState.fromJson(Map<String, dynamic> json) {
    return IndianState(code: json['code'] as String, name: json['name'] as String);
  }
}

/// A support category (GET /help-resources/categories).
class SupportCategory {
  const SupportCategory({required this.slug, required this.name});

  final String slug;
  final String name;

  factory SupportCategory.fromJson(Map<String, dynamic> json) {
    return SupportCategory(slug: json['slug'] as String, name: json['name'] as String);
  }
}

/// One helpline / support resource (GET /help-resources?state=&category=),
/// exactly as stored by the backend — nothing here is generated client-side.
class HelpResource {
  const HelpResource({
    required this.id,
    required this.name,
    required this.isNational,
    required this.phoneNumber,
    required this.tollFree,
    required this.email,
    required this.websiteUrl,
    required this.serviceHours,
    required this.sourceName,
    required this.sourceUrl,
    required this.isVerified,
    required this.lastVerifiedAt,
  });

  final int id;
  final String name;
  final bool isNational;
  final String? phoneNumber;
  final String? tollFree;
  final String? email;
  final String? websiteUrl;
  final String? serviceHours;
  final String sourceName;
  final String sourceUrl;
  final bool isVerified;
  final DateTime? lastVerifiedAt;

  /// The number the Call button dials: toll-free first, else the phone number.
  String? get primaryNumber => tollFree ?? phoneNumber;

  factory HelpResource.fromJson(Map<String, dynamic> json) {
    final verifiedAt = json['lastVerifiedAt'] as String?;
    return HelpResource(
      id: json['id'] as int,
      name: json['resourceName'] as String,
      isNational: json['isNational'] as bool? ?? false,
      phoneNumber: json['phoneNumber'] as String?,
      tollFree: json['tollFree'] as String?,
      email: json['email'] as String?,
      websiteUrl: json['websiteUrl'] as String?,
      serviceHours: json['serviceHours'] as String?,
      sourceName: json['sourceName'] as String,
      sourceUrl: json['sourceUrl'] as String,
      isVerified: json['verificationStatus'] == 'verified',
      lastVerifiedAt: verifiedAt == null ? null : DateTime.parse(verifiedAt).toLocal(),
    );
  }
}
