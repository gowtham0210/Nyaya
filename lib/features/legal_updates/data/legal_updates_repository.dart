import '../../../core/network/api_client.dart';
import '../../../core/network/api_config.dart';
import '../../../core/network/json_text.dart';

/// A legal update as the backend returns it.
class LegalUpdate {
  const LegalUpdate({
    required this.id,
    required this.category,
    required this.title,
    required this.summary,
    required this.rawDate,
    this.date,
    this.source,
    this.imageUrl,
  });

  final int id;

  /// English value from the backend, e.g. `Judgements`.
  final String category;
  final String title;
  final String summary;

  /// `updateDate` as sent; shown when [date] is null.
  final String rawDate;

  /// Parsed [rawDate] in local time; null when it isn't a date.
  final DateTime? date;
  final String? source;

  /// Absolute image URL; null when the update has none.
  final String? imageUrl;
}

/// Updates from `GET /legal-updates`, newest first.
class LegalUpdatesRepository {
  LegalUpdatesRepository(this._client);

  final ApiClient _client;

  Future<List<LegalUpdate>> fetchUpdates() async {
    final body = await _client.get('/legal-updates');
    final updates = [
      for (final item in body['items'] as List<dynamic>? ?? const [])
        _toUpdate(item as Map<String, dynamic>),
    ];
    // Undated updates go last.
    return updates..sort((a, b) {
      final aDate = a.date, bDate = b.date;
      if (aDate == null || bDate == null) {
        return (aDate == null ? 1 : 0) - (bDate == null ? 1 : 0);
      }
      return bDate.compareTo(aDate);
    });
  }

  LegalUpdate _toUpdate(Map<String, dynamic> json) {
    final rawDate = json['updateDate'] as String? ?? '';
    return LegalUpdate(
      id: json['id'] as int,
      category: json['category'] as String,
      title: json['title'] as String,
      summary: json['summary'] as String? ?? '',
      rawDate: rawDate,
      date: DateTime.tryParse(rawDate)?.toLocal(),
      source: jsonText(json['source']),
      imageUrl: ApiConfig.absoluteUrl(jsonText(json['imageUrl'])),
    );
  }
}
