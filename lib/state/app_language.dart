import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// The app's current language code ('en', 'hi', 'ta', 'te', 'kn'). Every
/// static UI string reads through `tr()` (see app_strings.dart), which
/// looks up [current]'s value — so changing it re-renders the whole app in
/// the new language, not just the Profile screen that set it.
class AppLanguage {
  AppLanguage._();

  static const _prefsKey = 'nyaya_language_code';
  static final ValueNotifier<String> current = ValueNotifier('en');

  static Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_prefsKey);
    if (saved != null) current.value = saved;
  }

  static Future<void> set(String code) async {
    current.value = code;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsKey, code);
  }
}

/// Appends `?lang=xx` (or `&lang=xx` if the path already has a query
/// string) using the current language, so every content-fetching API call
/// can request server-side translated text with `path.withLang()`. A no-op
/// for English, since the base columns already are English.
extension LangQuery on String {
  String withLang() {
    final code = AppLanguage.current.value;
    if (code == 'en') return this;
    final separator = contains('?') ? '&' : '?';
    return '$this${separator}lang=$code';
  }
}
