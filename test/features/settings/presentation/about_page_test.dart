import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nyaya/features/settings/presentation/about_page.dart';

import '../../../support/localized_app.dart';

void main() {
  testWidgets('shows the purpose, features and version', (tester) async {
    await pumpLocalized(
      tester,
      AboutPage(loadVersion: () async => '1.0.0 (1)'),
      locale: const Locale('en'),
    );

    expect(find.text('Law basics, one quiz at a time'), findsOneWidget);
    expect(find.textContaining('understand Indian law'), findsOneWidget);
    expect(find.text("What you'll find in Nyaya"), findsOneWidget);
    expect(find.text('Version 1.0.0 (1)'), findsOneWidget);
  });

  testWidgets('strings are in Hindi', (tester) async {
    await pumpLocalized(
      tester,
      AboutPage(loadVersion: () async => '1.0.0 (1)'),
      locale: const Locale('hi'),
    );

    expect(find.text('संस्करण 1.0.0 (1)'), findsOneWidget);
  });

  testWidgets('reads the version once and fits large text', (tester) async {
    tester.platformDispatcher.textScaleFactorTestValue = 1.6;
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    var reads = 0;
    await pumpLocalized(
      tester,
      AboutPage(
        loadVersion: () async {
          reads++;
          return '1.0.0 (1)';
        },
      ),
      locale: const Locale('en'),
    );
    tester.view.physicalSize = const Size(320, 640);
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(reads, 1);
  });
}
