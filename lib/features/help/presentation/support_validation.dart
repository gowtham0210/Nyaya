import '../../../core/localization/l10n.dart';

/// Shortest message the team can act on.
const supportMinMessageLength = 10;

String? validateSupportSubject(AppLocalizations l10n, String? value) =>
    (value ?? '').trim().isEmpty ? l10n.validationRequired : null;

String? validateSupportMessage(AppLocalizations l10n, String? value) {
  final text = (value ?? '').trim();
  if (text.isEmpty) {
    return l10n.validationRequired;
  }
  if (text.length < supportMinMessageLength) {
    return l10n.supportMessageTooShort(supportMinMessageLength);
  }
  return null;
}
