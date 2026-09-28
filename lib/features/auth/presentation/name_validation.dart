import '../../../core/localization/l10n.dart';

/// A full name needs at least 3 characters (sign-up and edit profile).
String? validateFullName(AppLocalizations l10n, String? value) {
  final trimmed = value?.trim() ?? '';
  if (trimmed.isEmpty) {
    return l10n.validationNameRequired;
  }
  if (trimmed.length < 3) {
    return l10n.validationNameTooShort;
  }
  return null;
}
