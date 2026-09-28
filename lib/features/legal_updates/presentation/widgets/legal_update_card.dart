import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/localization/l10n.dart';
import '../legal_updates_view_model.dart';

const _navy = Color(0xFF11233B);
const _supportText = Color(0xFF5E6878);
const _muted = Color(0xFF8B95A5);
const _cardBorder = Color(0xFFECE5DB);

typedef _Pill = ({
  String Function(AppLocalizations l10n) label,
  Color background,
  Color text,
});

const _judgements = (
  label: _judgementsLabel,
  background: Color(0xFFFFF1DF),
  text: Color(0xFFC28135),
);

/// Label and colours per backend category (colours from `nisha-frontend`).
const _pills = <String, _Pill>{
  'Judgements': _judgements,
  'Judgments': _judgements,
  'Legislation': (
    label: _legislationLabel,
    background: Color(0xFFE5F1F6),
    text: Color(0xFF437F92),
  ),
  'Reforms': (
    label: _reformsLabel,
    background: Color(0xFFEAF4E8),
    text: Color(0xFF568A4F),
  ),
  'Notices': (
    label: _noticesLabel,
    background: Color(0xFFF3EDF7),
    text: Color(0xFF7E5D9D),
  ),
};
const _otherBackground = Color(0xFFF1F5F9);
const _otherText = Color(0xFF475569);

String _judgementsLabel(AppLocalizations l10n) =>
    l10n.legalUpdatesCategoryJudgements;
String _legislationLabel(AppLocalizations l10n) =>
    l10n.legalUpdatesCategoryLegislation;
String _reformsLabel(AppLocalizations l10n) => l10n.legalUpdatesCategoryReforms;
String _noticesLabel(AppLocalizations l10n) => l10n.legalUpdatesCategoryNotices;

/// One legal update: category, title, summary, date and source (spec 020).
class LegalUpdateCard extends StatelessWidget {
  const LegalUpdateCard({super.key, required this.update});

  final LegalUpdate update;

  @override
  Widget build(BuildContext context) {
    final pill = _pills[update.category];
    final date = _formatDate(context, update);
    final source = update.source;
    return MergeSemantics(
      child: Container(
        key: ValueKey('legalUpdate.card.${update.id}'),
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: _cardBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                color: pill?.background ?? _otherBackground,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                child: Text(
                  // Unknown categories show as sent.
                  pill?.label(context.l10n) ?? update.category,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: pill?.text ?? _otherText,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              update.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                height: 1.3,
                color: _navy,
              ),
            ),
            if (update.summary.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                update.summary,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 13,
                  height: 1.4,
                  color: _supportText,
                ),
              ),
            ],
            const SizedBox(height: 10),
            Wrap(
              spacing: 12,
              runSpacing: 4,
              children: [
                if (date.isNotEmpty)
                  _Meta(icon: Icons.calendar_today_outlined, text: date),
                if (source != null)
                  _Meta(icon: Icons.menu_book_outlined, text: source),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Meta extends StatelessWidget {
  const _Meta({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: _muted),
        const SizedBox(width: 4),
        Flexible(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: _muted,
            ),
          ),
        ),
      ],
    );
  }
}

/// The update's date in the app's locale, or the raw text if unparsed.
String _formatDate(BuildContext context, LegalUpdate update) {
  final date = update.date;
  if (date == null) {
    return update.rawDate;
  }
  final locale = Localizations.localeOf(context).toLanguageTag();
  return DateFormat.yMMMd(locale).format(date);
}
