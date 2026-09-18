import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nyaya/features/auth/presentation/otp_verification_page.dart';
import 'package:nyaya/features/auth/presentation/sign_in_page.dart';
import 'package:nyaya/features/auth/presentation/sign_up_page.dart';

void main() {
  Future<void> pumpSignUpPage(
    WidgetTester tester, {
    Widget? home,
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

    await tester.pumpWidget(MaterialApp(home: home ?? const SignUpPage()));
    await tester.pumpAndSettle();
  }

  testWidgets('renders the Figma-matched signup composition and copy', (
    WidgetTester tester,
  ) async {
    await pumpSignUpPage(tester);

    expect(find.byKey(const ValueKey('signup.card')), findsOneWidget);
    expect(
      find.byKey(const ValueKey('signup.button.sendOtp')),
      findsOneWidget,
    );
    expect(find.byKey(const ValueKey('signup.footer.login')), findsOneWidget);

    expect(find.text('Create Your Account'), findsOneWidget);
    expect(
      find.text('Join NYAYA and start your legal learning journey'),
      findsOneWidget,
    );
    expect(find.text('Full Name'), findsOneWidget);
    expect(find.text('Profession'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
    expect(find.text('Phone Number'), findsOneWidget);
    expect(find.text('Send OTP'), findsOneWidget);

    expect(tester.takeException(), isNull);
  });

  testWidgets('shows field validation when submitting an empty form', (
    WidgetTester tester,
  ) async {
    await pumpSignUpPage(tester);

    await tester.ensureVisible(
      find.byKey(const ValueKey('signup.button.sendOtp')),
    );
    await tester.tap(find.byKey(const ValueKey('signup.button.sendOtp')));
    await tester.pumpAndSettle();

    expect(find.text('Full name is required'), findsOneWidget);
    expect(find.text('Profession is required'), findsOneWidget);
    expect(find.text('Password is required'), findsOneWidget);
    expect(find.text('Phone number is required'), findsOneWidget);
  });

  testWidgets('sign in screen routes into the signup screen', (
    WidgetTester tester,
  ) async {
    await pumpSignUpPage(tester, home: const SignInPage());

    await tester.ensureVisible(
      find.byKey(const ValueKey('signin.footer.signup')),
    );
    await tester.tap(find.byKey(const ValueKey('signin.footer.signup')));
    await tester.pumpAndSettle();

    expect(find.byType(SignUpPage), findsOneWidget);
    expect(find.text('Create Your Account'), findsOneWidget);
  });

  testWidgets('signup screen routes back to sign in', (
    WidgetTester tester,
  ) async {
    await pumpSignUpPage(tester, home: const SignInPage());

    await tester.tap(find.byKey(const ValueKey('signin.footer.signup')));
    await tester.pumpAndSettle();

    await tester.ensureVisible(
      find.byKey(const ValueKey('signup.footer.login')),
    );
    await tester.tap(find.byKey(const ValueKey('signup.footer.login')));
    await tester.pumpAndSettle();

    expect(find.byType(SignInPage), findsOneWidget);
  });

  // Skipped: this now calls FirebaseAuth.instance, which requires a
  // configured Firebase app that plain widget tests don't have. Exercise
  // this manually, or add firebase_auth_mocks to cover it automatically.
  testWidgets(
    'valid submission opens the OTP verification screen',
    skip: true,
    (WidgetTester tester) async {
    await pumpSignUpPage(tester);

    Future<void> fill(String key, String text) async {
      final finder = find.byKey(ValueKey(key));
      await tester.ensureVisible(finder);
      await tester.enterText(finder, text);
    }

    await fill('signup.field.fullName', 'Gowtham S');
    // Profession is a read-only field populated via a picker sheet; set it
    // directly through its controller-backed field for this form-level test.
    final professionField = tester.widget<TextFormField>(
      find.descendant(
        of: find.byKey(const ValueKey('signup.field.profession')),
        matching: find.byType(TextFormField),
      ),
    );
    professionField.controller?.text = 'Student';
    await fill('signup.field.password', 'passw0rd1');
    await fill('signup.field.phone', '9876543210');

    await tester.ensureVisible(
      find.byKey(const ValueKey('signup.button.sendOtp')),
    );
    await tester.tap(find.byKey(const ValueKey('signup.button.sendOtp')));
    await tester.pumpAndSettle();

    expect(find.byType(OtpVerificationPage), findsOneWidget);
    expect(find.text('Verify OTP'), findsOneWidget);
    expect(find.text('+91 9876543210'), findsOneWidget);
  });
}
