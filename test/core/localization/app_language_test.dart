import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:nyaya/core/localization/app_language.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() => SharedPreferences.setMockInitialValues({}));

  test('AC-002 a fresh install starts in a supported device language', () async {
    await AppLanguage.load(deviceLocale: const Locale('ta', 'IN'));

    expect(AppLanguage.current.value, const Locale('ta'));
  });

  test('AC-003 an unsupported device language falls back to English', () async {
    await AppLanguage.load(deviceLocale: const Locale('fr', 'FR'));

    expect(AppLanguage.current.value, const Locale('en'));
  });

  test('AC-004 and AC-005 a selected language is restored on launch', () async {
    await AppLanguage.load(deviceLocale: const Locale('en'));
    await AppLanguage.select('kn');
    expect(AppLanguage.current.value, const Locale('kn'));

    AppLanguage.current.value = const Locale('en');
    await AppLanguage.load(deviceLocale: const Locale('hi'));

    expect(AppLanguage.current.value, const Locale('kn'));
  });
}
