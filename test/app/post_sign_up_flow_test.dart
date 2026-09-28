import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nyaya/app/main_shell.dart';
import 'package:nyaya/app/post_sign_up_flow.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  testWidgets('after goal selection the shell is the only route, so back '
      'on Home leaves the app', (tester) async {
    tester.view.physicalSize = const Size(393, 852);
    tester.view.devicePixelRatio = 1;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (welcomeContext) => TextButton(
            onPressed: () => Navigator.of(welcomeContext).push(
              MaterialPageRoute<void>(
                builder: (signInContext) => TextButton(
                  onPressed: () => startPostSignUpFlow(signInContext),
                  child: const Text('signed in'),
                ),
              ),
            ),
            child: const Text('welcome'),
          ),
        ),
      ),
    );
    await tester.tap(find.text('welcome'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('signed in'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.byKey(const ValueKey('goal.continue')));
    await tester.tap(find.byKey(const ValueKey('goal.continue')));
    await tester.pumpAndSettle();

    expect(find.byType(MainShell), findsOneWidget);
    expect(
      Navigator.of(tester.element(find.byType(MainShell))).canPop(),
      isFalse,
    );
  });
}
