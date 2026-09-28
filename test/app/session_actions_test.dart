import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nyaya/app/app_session.dart';
import 'package:nyaya/app/session_actions.dart';
import 'package:nyaya/features/auth/presentation/sign_in_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  testWidgets('AC-009 ending the session returns to sign-in with a message', (
    tester,
  ) async {
    await AppSession.saveSignedIn();
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => TextButton(
            onPressed: () =>
                endSession(context, message: 'Please sign in again.'),
            child: const Text('expire'),
          ),
        ),
      ),
    );

    await tester.tap(find.text('expire'));
    await tester.pumpAndSettle();

    expect(find.byType(SignInPage), findsOneWidget);
    expect(find.text('Please sign in again.'), findsOneWidget);
    expect(AppSession.signedIn, isFalse);
    expect(
      Navigator.of(tester.element(find.byType(SignInPage))).canPop(),
      isFalse,
    );
  });
}
