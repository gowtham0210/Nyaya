import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nyaya/features/auth/presentation/widgets/auth_text_field.dart';

void main() {
  testWidgets('spec 037 AC-004 a phone field keeps only 10 digits', (
    tester,
  ) async {
    final controller = TextEditingController();
    addTearDown(controller.dispose);
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AuthTextField(
            label: 'Phone',
            hint: 'Phone',
            icon: Icons.call_outlined,
            controller: controller,
            prefixText: '+91',
            inputFormatters: indianMobileFormatters,
          ),
        ),
      ),
    );

    await tester.enterText(find.byType(TextFormField), '98765-43210 9999 ab');

    expect(controller.text, '9876543210');
  });
}
