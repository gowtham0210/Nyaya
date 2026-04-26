import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nyaya/app/app.dart';
import 'package:nyaya/features/splash/presentation/splash_page.dart';

void main() {
  Future<void> pumpSplash(
    WidgetTester tester, {
    Size size = const Size(393, 852),
    FakeViewPadding padding = const FakeViewPadding(top: 59, bottom: 34),
  }) async {
    tester.view.reset();
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1;
    tester.view.padding = padding;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
      tester.view.resetPadding();
    });

    await tester.pumpWidget(const MaterialApp(home: SplashPage()));
    await tester.pumpAndSettle();
  }

  testWidgets('AC-001 shows the approved branded splash composition', (
    WidgetTester tester,
  ) async {
    await pumpSplash(tester);

    expect(find.byKey(const ValueKey('splash.screen')), findsOneWidget);
    expect(find.byKey(const ValueKey('splash.wave')), findsOneWidget);
    expect(find.byKey(const ValueKey('splash.temple')), findsOneWidget);
    expect(find.byKey(const ValueKey('splash.brand')), findsOneWidget);
    expect(find.byKey(const ValueKey('splash.logo')), findsOneWidget);
    expect(find.byKey(const ValueKey('splash.wordmark')), findsOneWidget);
    expect(find.byKey(const ValueKey('splash.divider')), findsOneWidget);
    expect(find.byKey(const ValueKey('splash.tagline')), findsOneWidget);
    expect(find.byKey(const ValueKey('splash.book')), findsOneWidget);
    expect(find.byKey(const ValueKey('splash.progress')), findsOneWidget);
    expect(find.byKey(const ValueKey('splash.star.top')), findsOneWidget);
    expect(find.byKey(const ValueKey('splash.star.bottom')), findsOneWidget);
    expect(find.byKey(const ValueKey('splash.dots.top')), findsOneWidget);
    expect(find.byKey(const ValueKey('splash.dots.bottom')), findsOneWidget);
    expect(find.text('LAW BASED QUIZ APP'), findsOneWidget);
  });

  testWidgets('AC-002 keeps the approved decorative accents and hero assets', (
    WidgetTester tester,
  ) async {
    await pumpSplash(tester);

    expect(find.byKey(const ValueKey('splash.logo')), findsOneWidget);
    expect(find.byKey(const ValueKey('splash.wordmark')), findsOneWidget);
    expect(find.byKey(const ValueKey('splash.book')), findsOneWidget);
    expect(find.byKey(const ValueKey('splash.temple')), findsOneWidget);
    expect(find.byKey(const ValueKey('splash.star.top')), findsOneWidget);
    expect(find.byKey(const ValueKey('splash.star.bottom')), findsOneWidget);
    expect(find.byKey(const ValueKey('splash.dots.top')), findsOneWidget);
    expect(find.byKey(const ValueKey('splash.dots.bottom')), findsOneWidget);
  });

  testWidgets(
    'AC-003 places the book icon and progress bar below the tagline',
    (WidgetTester tester) async {
      await pumpSplash(tester);

      final taglineRect = tester.getRect(
        find.byKey(const ValueKey('splash.tagline')),
      );
      final bookRect = tester.getRect(
        find.byKey(const ValueKey('splash.book')),
      );
      final progressRect = tester.getRect(
        find.byKey(const ValueKey('splash.progress')),
      );

      expect(bookRect.top - taglineRect.bottom, inInclusiveRange(32.0, 56.0));
      expect(progressRect.top - bookRect.bottom, inInclusiveRange(20.0, 36.0));
      expect(progressRect.width, inInclusiveRange(158.0, 172.0));
    },
  );

  testWidgets('AC-005 keeps the splash content centered on compact phones', (
    WidgetTester tester,
  ) async {
    const size = Size(360, 780);
    await pumpSplash(
      tester,
      size: size,
      padding: const FakeViewPadding(top: 47, bottom: 28),
    );

    expect(tester.takeException(), isNull);

    final logoRect = tester.getRect(find.byKey(const ValueKey('splash.logo')));
    final wordmarkRect = tester.getRect(
      find.byKey(const ValueKey('splash.wordmark')),
    );
    final bookRect = tester.getRect(find.byKey(const ValueKey('splash.book')));
    final progressRect = tester.getRect(
      find.byKey(const ValueKey('splash.progress')),
    );

    for (final rect in [logoRect, wordmarkRect, bookRect, progressRect]) {
      expect(rect.left, greaterThanOrEqualTo(0));
      expect(rect.right, lessThanOrEqualTo(size.width));
      expect(rect.top, greaterThanOrEqualTo(0));
      expect(rect.bottom, lessThanOrEqualTo(size.height));
    }

    expect(logoRect.top, inInclusiveRange(150.0, 240.0));
    expect(progressRect.bottom, lessThan(size.height * 0.79));
  });

  testWidgets('AC-006 exposes splash identity and loading semantics', (
    WidgetTester tester,
  ) async {
    await pumpSplash(tester);
    final semantics = tester.ensureSemantics();

    expect(find.bySemanticsLabel('Nyaya splash screen'), findsOneWidget);
    expect(
      tester.getSemantics(
        find.byKey(const ValueKey('splash.loading_semantics')),
      ),
      matchesSemantics(label: 'Loading Nyaya', value: '33 percent'),
    );

    semantics.dispose();
  });

  testWidgets('NyayaApp waits for tap after the loading bar completes', (
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

    await tester.pumpWidget(
      const NyayaApp(splashDuration: Duration(milliseconds: 10)),
    );

    expect(find.byKey(const ValueKey('splash.screen')), findsOneWidget);
    expect(find.byKey(const ValueKey('home.headline')), findsNothing);

    await tester.pump(const Duration(milliseconds: 10));
    await tester.pump();

    final progress = tester.widget<LinearProgressIndicator>(
      find.byKey(const ValueKey('splash.progress')),
    );
    expect(progress.value, 1);
    expect(find.byKey(const ValueKey('splash.screen')), findsOneWidget);
    expect(find.byKey(const ValueKey('splash.tap_target')), findsOneWidget);
    expect(find.byKey(const ValueKey('home.headline')), findsNothing);

    await tester.tap(find.byKey(const ValueKey('splash.tap_target')));
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('home.headline')), findsOneWidget);
    expect(find.text('Spec-driven Flutter baseline'), findsOneWidget);
  });
}
