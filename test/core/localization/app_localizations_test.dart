import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:nyaya/l10n/app_localizations.dart';

void main() {
  test('AC-001 every supported locale loads its own strings', () {
    const retry = {
      'en': 'Retry',
      'hi': 'पुनः प्रयास करें',
      'ta': 'மீண்டும் முயற்சி',
      'te': 'మళ్లీ ప్రయత్నించండి',
      'kn': 'ಮತ್ತೆ ಪ್ರಯತ್ನಿಸಿ',
    };
    for (final entry in retry.entries) {
      final strings = lookupAppLocalizations(Locale(entry.key));
      expect(strings.commonRetry, entry.value, reason: entry.key);
    }
  });
}
