/// Trimmed text from a JSON field, or null when missing or blank.
String? jsonText(Object? value) {
  final text = (value as String?)?.trim();
  return text == null || text.isEmpty ? null : text;
}
