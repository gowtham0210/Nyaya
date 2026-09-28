import 'package:flutter/material.dart';

import '../../../core/localization/app_language.dart';
import '../../../core/localization/l10n.dart';
import '../../../core/presentation/widgets/detail_scaffold.dart';

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
    return DetailScaffold(
      title: l10n.profileLanguage,
      children: [
        DetailCard(
          children: [
            for (final locale in AppLanguage.supported)
              _LanguageTile(
                code: locale.languageCode,
                name: AppLanguage.nativeName(l10n, locale.languageCode),
                selected: locale.languageCode == current.languageCode,
                onTap: () => onSelected(locale.languageCode),
              ),
          ],
        ),
      ],
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
              color: brandNavy,
            ),
          ),
          trailing: selected
              ? Icon(
                  Icons.check_circle_rounded,
                  key: ValueKey('language.$code.check'),
                  color: brandGold,
                )
              : null,
          onTap: onTap,
        ),
      ),
    );
  }
}
