import '../../../core/network/api_client.dart';

/// An Indian state or union territory.
class IndianState {
  const IndianState({required this.code, required this.name});

  final String code;
  final String name;
}

/// A kind of help, e.g. women's safety.
class HelpCategory {
  const HelpCategory({required this.slug, required this.name});

  final String slug;
  final String name;
}

/// What the learner can filter by.
class HelpOptions {
  const HelpOptions({required this.states, required this.categories});

  final List<IndianState> states;
  final List<HelpCategory> categories;
}

/// One helpline or office, as the backend lists it.
class HelpResource {
  const HelpResource({
    required this.id,
    required this.name,
    required this.isNational,
    required this.isVerified,
    required this.sourceName,
    this.tollFree,
    this.phone,
    this.email,
    this.website,
    this.hours,
    this.source,
    this.verifiedAt,
  });

  final int id;
  final String name;
  final bool isNational;
  final bool isVerified;
  final String sourceName;
  final String? tollFree;
  final String? phone;
  final String? email;
  final Uri? website;
  final String? hours;
  final Uri? source;

  /// Local time; null when never verified.
  final DateTime? verifiedAt;

  /// What "Call" dials: toll-free first, else the phone number.
  String? get callNumber => tollFree ?? phone;
}

/// Legal help contacts from `/help-resources`.
class HelpResourcesRepository {
  HelpResourcesRepository(this._client);

  final ApiClient _client;

  Future<HelpOptions> fetchOptions() async {
    final [states, categories] = await Future.wait([
      _client.get('/help-resources/states'),
      _client.get('/help-resources/categories'),
    ]);
    return HelpOptions(
      states: [
        for (final item in _items(states))
          IndianState(
            code: item['code'] as String,
            name: item['name'] as String,
          ),
      ],
      categories: [
        for (final item in _items(categories))
          HelpCategory(
            slug: item['slug'] as String,
            name: item['name'] as String,
          ),
      ],
    );
  }

  Future<List<HelpResource>> fetchResources({
    required String state,
    required String category,
  }) async {
    final body = await _client.get(
      '/help-resources',
      query: {'state': state, 'category': category},
    );
    return [for (final item in _items(body)) _toResource(item)];
  }

  static Iterable<Map<String, dynamic>> _items(Map<String, dynamic> body) =>
      (body['items'] as List<dynamic>? ?? const []).cast();

  static HelpResource _toResource(Map<String, dynamic> json) {
    final verifiedAt = DateTime.tryParse(
      json['lastVerifiedAt'] as String? ?? '',
    );
    return HelpResource(
      id: json['id'] as int,
      name: json['resourceName'] as String,
      isNational: json['isNational'] as bool? ?? false,
      isVerified: json['verificationStatus'] == 'verified',
      sourceName: json['sourceName'] as String? ?? '',
      tollFree: _text(json['tollFree']),
      phone: _text(json['phoneNumber']),
      email: _text(json['email']),
      website: _https(json['websiteUrl']),
      hours: _text(json['serviceHours']),
      source: _https(json['sourceUrl']),
      verifiedAt: verifiedAt?.toLocal(),
    );
  }

  static String? _text(Object? value) {
    final text = (value as String?)?.trim();
    return text == null || text.isEmpty ? null : text;
  }

  /// Only web links open; anything else is dropped.
  static Uri? _https(Object? value) {
    final uri = Uri.tryParse(_text(value) ?? '');
    return uri != null && (uri.scheme == 'https' || uri.scheme == 'http')
        ? uri
        : null;
  }
}
