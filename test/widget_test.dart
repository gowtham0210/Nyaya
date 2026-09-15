// Basic smoke test for the NYAYA home screen.

import 'package:flutter_test/flutter_test.dart';

import 'package:my_flutter_app/main.dart';

void main() {
  testWidgets('NYAYA home screen renders key sections', (WidgetTester tester) async {
    await tester.pumpWidget(const NyayaApp());
    await tester.pumpAndSettle();

    expect(find.text('NYAYA'), findsOneWidget);
    expect(find.text('Continue Your Learning'), findsOneWidget);
    expect(find.text('Quick Access'), findsOneWidget);
    expect(find.text('Recommended for you'), findsOneWidget);
    expect(find.text('Ask Nyaya'), findsWidgets);
  });
}
