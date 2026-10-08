import 'package:flutter/material.dart';

import '../../../../app/theme/app_tokens.dart';
import 'package:intl/intl.dart';

import '../../../../core/localization/l10n.dart';
import '../legal_updates_view_model.dart';

const _navy = NyayaColors.ink;
const _supportText = NyayaColors.inkMuted;
const _muted = NyayaColors.inkSubtle;
const _cardBorder = NyayaColors.hairline;

typedef _Pill = ({
  String Function(AppLocalizations l10n) label,
  Color background,
  Color text,
});

const _judgements = (
  label: _judgementsLabel,
  background: NyayaTones.bronzeTint,
  text: NyayaTones.bronzeInk,
);

/// Label and colours per backend category (colours from `nisha-frontend`).
const _pills = <String, _Pill>{
  'Judgements': _judgements,
  'Judgments': _judgements,
  'Legislation': (
    label: _legislationLabel,
    background: NyayaTones.tealTint,
    text: NyayaTones.tealInk,
  ),
  'Reforms': (
    label: _reformsLabel,
    background: NyayaTones.oliveTint,
    text: NyayaTones.oliveInk,
  ),
  'Notices': (
    label: _noticesLabel,
    background: NyayaTones.plumTint,
    text: NyayaTones.plumInk,
  ),
};
const _otherBackground = NyayaTones.slateTint;
const _otherText = NyayaTones.slateInk;

String _judgementsLabel(AppLocalizations l10n) =>
    l10n.legalUpdatesCategoryJudgements;
String _legislationLabel(AppLocalizations l10n) =>
    l10n.legalUpdatesCategoryLegislation;
String _reformsLabel(AppLocalizations l10n) => l10n.legalUpdatesCategoryReforms;
String _noticesLabel(AppLocalizations l10n) => l10n.legalUpdatesCategoryNotices;

/// One legal update: category, title, summary, date and source (spec 020).
/// Tapping it calls [onTap] (spec 047).
class LegalUpdateCard extends StatelessWidget {
  const LegalUpdateCard({super.key, required this.update, this.onTap});

  final LegalUpdate update;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return MergeSemantics(
      child: Material(
        key: ValueKey('legalUpdate.card.${update.id}'),
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(NyayaRadii.md),
          side: const BorderSide(color: _cardBorder),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LegalUpdateCategoryPill(category: update.category),
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
                LegalUpdateMeta(update: update),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// The update's category as a coloured pill.
class LegalUpdateCategoryPill extends StatelessWidget {
  const LegalUpdateCategoryPill({super.key, required this.category});

  final String category;

  @override
  Widget build(BuildContext context) {
    final pill = _pills[category];
    return DecoratedBox(
      decoration: BoxDecoration(
        color: pill?.background ?? _otherBackground,
        borderRadius: BorderRadius.circular(NyayaRadii.xs),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        child: Text(
          // Unknown categories show as sent.
          pill?.label(context.l10n) ?? category,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: pill?.text ?? _otherText,
          ),
        ),
      ),
    );
  }
}

/// Date · source, wrapping on narrow screens.
class LegalUpdateMeta extends StatelessWidget {
  const LegalUpdateMeta({super.key, required this.update});

  final LegalUpdate update;

  @override
  Widget build(BuildContext context) {
    final date = _formatDate(context, update);
    final source = update.source;
    return Wrap(
      spacing: 12,
      runSpacing: 4,
      children: [
        if (date.isNotEmpty)
          _Meta(icon: Icons.calendar_today_outlined, text: date),
        if (source != null) _Meta(icon: Icons.menu_book_outlined, text: source),
      ],
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
