import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nyaya/app/theme/app_theme.dart';
import 'package:nyaya/app/theme/app_typography.dart';

void main() {
  final text = buildNyayaTextTheme();

  test('AC-001 display and headline styles use the serif', () {
    for (final style in [
      text.displayLarge,
      text.displayMedium,
      text.displaySmall,
      text.headlineLarge,
      text.headlineMedium,
      text.headlineSmall,
    ]) {
      expect(style?.fontFamily, NyayaFonts.display);
    }
  });

  test('AC-001 title, body and label styles use the sans', () {
    for (final style in [
      text.titleLarge,
      text.titleMedium,
      text.titleSmall,
      text.bodyLarge,
      text.bodyMedium,
      text.bodySmall,
      text.labelLarge,
      text.labelMedium,
      text.labelSmall,
    ]) {
      expect(style?.fontFamily, NyayaFonts.body);
    }
  });

  test('AC-002 body and title text has no extra tracking', () {
    for (final style in [
      text.titleLarge,
      text.titleMedium,
      text.bodyLarge,
      text.bodyMedium,
      text.bodySmall,
      text.labelLarge,
    ]) {
      expect(style?.letterSpacing, 0);
    }
  });

  test('AC-003 the app theme defaults to the sans and the type scale', () {
    final theme = buildNyayaTheme();

    expect(theme.textTheme.bodyMedium?.fontFamily, NyayaFonts.body);
    expect(theme.textTheme.headlineSmall?.fontFamily, NyayaFonts.display);
    expect(theme.textTheme.bodyLarge?.color, nyayaInk);
  });

  testWidgets('AC-003 plain Text inherits the sans with no tracking', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: buildNyayaTheme(),
        home: const Scaffold(body: Text('Nyaya')),
      ),
    );

    final style = DefaultTextStyle.of(tester.element(find.text('Nyaya')));
    expect(style.style.fontFamily, NyayaFonts.body);
    expect(style.style.letterSpacing, 0);
  });
}
