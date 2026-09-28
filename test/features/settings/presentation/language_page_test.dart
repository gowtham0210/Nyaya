import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nyaya/features/settings/presentation/language_page.dart';

import '../../../support/localized_app.dart';

void main() {
  testWidgets('lists the five languages in their own scripts', (tester) async {
    await pumpLocalized(
      tester,
      LanguagePage(current: const Locale('en'), onSelected: (_) {}),
      locale: const Locale('en'),
    );

    for (final name in ['English', 'हिन्दी', 'தமிழ்', 'తెలుగు', 'ಕನ್ನಡ']) {
      expect(find.text(name), findsOneWidget, reason: name);
    }
  });

  testWidgets('marks the current language as selected', (tester) async {
    await pumpLocalized(
      tester,
      LanguagePage(current: const Locale('ta'), onSelected: (_) {}),
      locale: const Locale('ta'),
    );

    expect(
      tester.getSemantics(find.byKey(const ValueKey('language.ta'))),
      isSemantics(
        isSelected: true,
        isInMutuallyExclusiveGroup: true,
        label: 'தமிழ்',
        hasTapAction: true,
      ),
    );
    expect(find.byKey(const ValueKey('language.ta.check')), findsOneWidget);
    expect(find.byKey(const ValueKey('language.en.check')), findsNothing);
  });

  testWidgets('tapping a language reports its code', (tester) async {
    final picked = <String>[];
    await pumpLocalized(
      tester,
      LanguagePage(current: const Locale('en'), onSelected: picked.add),
      locale: const Locale('en'),
    );

    await tester.tap(find.text('ಕನ್ನಡ'));

    expect(picked, ['kn']);
  });
}
