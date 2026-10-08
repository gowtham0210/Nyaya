import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nyaya/features/auth/presentation/otp_verification_page.dart';
import 'package:nyaya/features/auth/presentation/sign_in_page.dart';
import 'package:nyaya/features/auth/presentation/sign_up_page.dart';

import '../../../support/localized_app.dart';

void main() {
  testWidgets('Sign-in renders in Hindi', (tester) async {
    await pumpLocalized(tester, const SignInPage(), locale: const Locale('hi'));

    expect(find.text('न्याय में फिर से स्वागत है!'), findsOneWidget);
    // Email first (spec 041).
    expect(find.text('ईमेल पता'), findsOneWidget);
    expect(find.text('फ़ोन'), findsOneWidget);
    expect(find.text('लॉगिन'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('signin.method.phone')));
    await tester.pumpAndSettle();
    expect(find.text('फ़ोन नंबर'), findsOneWidget);
  });

  testWidgets('Sign-up renders and validates in Kannada', (tester) async {
    await pumpLocalized(tester, const SignUpPage(), locale: const Locale('kn'));

    expect(find.text('ನಿಮ್ಮ ಖಾತೆಯನ್ನು ರಚಿಸಿ'), findsOneWidget);
    await tester.ensureVisible(
      find.byKey(const ValueKey('signup.button.create')),
    );
    await tester.tap(find.byKey(const ValueKey('signup.button.create')));
    await tester.pumpAndSettle();

    expect(find.text('ಪೂರ್ಣ ಹೆಸರು ಅಗತ್ಯ'), findsOneWidget);
    expect(find.text('ಇಮೇಲ್ ಅಗತ್ಯವಿದೆ'), findsOneWidget);
    // Phone is optional (spec 041).
    expect(find.text('ಫೋನ್ ಸಂಖ್ಯೆ ಅಗತ್ಯ'), findsNothing);
  });

  testWidgets('Sign-up profession picker shows localized professions', (
    tester,
  ) async {
    await pumpLocalized(tester, const SignUpPage(), locale: const Locale('hi'));

    await tester.tap(find.byKey(const ValueKey('signup.field.profession')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('कानून का छात्र'));
    await tester.pumpAndSettle();

    expect(find.text('कानून का छात्र'), findsOneWidget);
  });

  testWidgets('OTP verification renders in Hindi', (tester) async {
    await pumpLocalized(
      tester,
      OtpVerificationPage(
        phoneNumber: '+919876543210',
        verificationId: 'test-verification',
        completeAuth: _noBackend,
      ),
      locale: const Locale('hi'),
    );

    expect(find.text('OTP सत्यापित करें'), findsOneWidget);
    expect(find.text('6 अंकों का OTP इस नंबर पर भेजा गया है:'), findsOneWidget);
    expect(find.text('सत्यापित करें और आगे बढ़ें'), findsOneWidget);
  });
}

Future<void> _noBackend(String? firebaseIdToken) async {}
