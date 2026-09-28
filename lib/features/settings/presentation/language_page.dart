import 'package:flutter/material.dart';

import '../../../core/localization/app_language.dart';
import '../../../core/localization/l10n.dart';

const _pageBackground = Color(0xFFF8F6F2);
const _navy = Color(0xFF11233B);
const _gold = Color(0xFFB9823A);
const _cardBorder = Color(0xFFECE5DB);

/// Picks the app language (spec 028). Names show in their own scripts.
class LanguagePage extends StatelessWidget {
  const LanguagePage({
    super.key,
    required this.current,
    required this.onSelected,
  });

  final Locale current;

  /// The picked language code, e.g. `hi`.
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      backgroundColor: _pageBackground,
      appBar: AppBar(
        backgroundColor: _pageBackground,
        foregroundColor: _navy,
        surfaceTintColor: Colors.transparent,
        title: Text(l10n.profileLanguage),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
        children: [
          Material(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: const BorderSide(color: _cardBorder),
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                for (final (index, locale)
                    in AppLanguage.supported.indexed) ...[
                  if (index > 0) const Divider(height: 1, color: _cardBorder),
                  _LanguageTile(
                    code: locale.languageCode,
                    name: AppLanguage.nativeName(l10n, locale.languageCode),
                    selected: locale.languageCode == current.languageCode,
                    onTap: () => onSelected(locale.languageCode),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LanguageTile extends StatelessWidget {
  const _LanguageTile({
    required this.code,
    required this.name,
    required this.selected,
    required this.onTap,
  });

  final String code;
  final String name;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return MergeSemantics(
      key: ValueKey('language.$code'),
      child: Semantics(
        inMutuallyExclusiveGroup: true,
        selected: selected,
        child: ListTile(
          title: Text(
            name,
            style: TextStyle(
              fontSize: 17,
              fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
              color: _navy,
            ),
          ),
          trailing: selected
              ? Icon(
                  Icons.check_circle_rounded,
                  key: ValueKey('language.$code.check'),
                  color: _gold,
                )
              : null,
          onTap: onTap,
        ),
      ),
    );
  }
}
