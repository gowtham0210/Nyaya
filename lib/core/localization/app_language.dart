import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../l10n/app_localizations.dart';

/// The learner's chosen app language (see ADR 0003). Defaults to the device
/// language when supported, otherwise English, and is remembered once picked.
class AppLanguage {
  AppLanguage._();

  static const _prefsKey = 'app.languageCode';

  static final current = ValueNotifier<Locale>(const Locale('en'));

  static List<Locale> get supported => AppLocalizations.supportedLocales;

  static Future<void> load({Locale? deviceLocale}) async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_prefsKey);
    final device = deviceLocale ?? PlatformDispatcher.instance.locale;
    current.value =
        _supported(saved) ??
        _supported(device.languageCode) ??
        const Locale('en');
  }

  static Future<void> select(String languageCode) async {
    final locale = _supported(languageCode);
    if (locale == null) {
      return;
    }
    current.value = locale;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsKey, languageCode);
  }

  /// A language's name in its own script, e.g. `हिन्दी` for `hi`.
  static String nativeName(AppLocalizations l10n, String languageCode) =>
      switch (languageCode) {
        'en' => l10n.languageEnglish,
        'hi' => l10n.languageHindi,
        'ta' => l10n.languageTamil,
        'te' => l10n.languageTelugu,
        'kn' => l10n.languageKannada,
        _ => languageCode,
      };

  static Locale? _supported(String? languageCode) {
    for (final locale in supported) {
      if (locale.languageCode == languageCode) {
        return locale;
      }
    }
    return null;
  }
}
