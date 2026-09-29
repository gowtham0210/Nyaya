import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nyaya/app/app.dart';
import 'package:nyaya/app/main_shell.dart';
import 'package:nyaya/features/onboarding/presentation/welcome_page.dart';

void main() {
  Future<void> pumpApp(WidgetTester tester, {required bool skipSignIn}) async {
    tester.view.physicalSize = const Size(393, 852);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      NyayaApp(splashDuration: Duration.zero, skipSignIn: skipSignIn),
    );
    await tester.pump();
  }

  testWidgets('with the dev flag, a fresh install skips to the tabs', (
    tester,
  ) async {
    await pumpApp(tester, skipSignIn: true);

    expect(find.byType(MainShell), findsOneWidget);
    expect(find.byType(WelcomePage), findsNothing);
  });

  testWidgets('without it, a fresh install still starts at Welcome', (
    tester,
  ) async {
    await pumpApp(tester, skipSignIn: false);

    expect(find.byType(WelcomePage), findsOneWidget);
    expect(find.byType(MainShell), findsNothing);
  });
}
