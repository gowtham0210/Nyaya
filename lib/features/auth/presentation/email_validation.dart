import '../../../core/localization/l10n.dart';

final _email = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

/// An email needs a name, an "@" and a domain with a dot (spec 041).
String? validateEmail(AppLocalizations l10n, String? value) {
  final trimmed = value?.trim() ?? '';
  if (trimmed.isEmpty) {
    return l10n.validationEmailRequired;
  }
  if (!_email.hasMatch(trimmed)) {
    return l10n.validationEmailInvalid;
  }
  return null;
}
