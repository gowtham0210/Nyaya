import 'package:flutter/widgets.dart';

import '../../l10n/app_localizations.dart';

export '../../l10n/app_localizations.dart';

extension L10nContext on BuildContext {
  /// Strings for the current locale. Falls back to English when no
  /// localization delegate is installed, e.g. in plain widget tests.
  AppLocalizations get l10n =>
      Localizations.of<AppLocalizations>(this, AppLocalizations) ??
      lookupAppLocalizations(const Locale('en'));
}
