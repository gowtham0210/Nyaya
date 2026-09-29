import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nyaya/features/splash/presentation/splash_page.dart';

void main() {
  testWidgets('AC-007 matches the approved splash composition reference', (
    WidgetTester tester,
  ) async {
    tester.view.reset();
    tester.view.physicalSize = const Size(393, 852);
    tester.view.devicePixelRatio = 1;
    tester.view.padding = const FakeViewPadding(top: 59, bottom: 34);
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
      tester.view.resetPadding();
    });

    await tester.pumpWidget(const MaterialApp(home: SplashPage()));
    await tester.pumpAndSettle();

    await expectLater(
      find.byType(SplashPage),
      matchesGoldenFile('goldens/splash_page_reference.png'),
    );
  });
}
