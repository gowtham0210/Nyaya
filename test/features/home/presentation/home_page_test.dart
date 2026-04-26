import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nyaya/app/app.dart';

void main() {
  testWidgets('AC-001 shows the Nyaya home shell', (WidgetTester tester) async {
    await tester.pumpWidget(const NyayaApp());

    expect(find.text('Nyaya'), findsOneWidget);
    expect(find.byKey(const ValueKey('home.headline')), findsOneWidget);
    expect(find.text('Spec-driven Flutter baseline'), findsOneWidget);
    expect(
      find.text(
        'Define intent in specs, decisions, and tests before code changes.',
      ),
      findsOneWidget,
    );
  });

  testWidgets('AC-002 lists the three adoption steps', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const NyayaApp());

    expect(find.text('Write the spec first'), findsOneWidget);
    expect(find.text('Record design decisions'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Trace every criterion to tests'),
      200,
    );
    await tester.pumpAndSettle();
    expect(find.text('Trace every criterion to tests'), findsOneWidget);
  });
}
