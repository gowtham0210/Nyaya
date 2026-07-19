import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
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

  testWidgets('renders the approved signup composition and copy', (
    WidgetTester tester,
  ) async {
    await pumpSignUpPage(tester);

    expect(find.byKey(const ValueKey('signup.back')), findsOneWidget);
    expect(find.byKey(const ValueKey('signup.temple')), findsOneWidget);
    expect(
      find.byKey(const ValueKey('signup.dots.bottomLeft')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey('signup.star.bottomRight')),
      findsOneWidget,
    );
    expect(find.byKey(const ValueKey('signup.card')), findsOneWidget);
    expect(find.byKey(const ValueKey('signup.button.primary')), findsOneWidget);
    expect(find.byKey(const ValueKey('signup.button.google')), findsOneWidget);
    expect(find.byKey(const ValueKey('signup.footer.signin')), findsOneWidget);

    expect(find.text('Create Your Account'), findsOneWidget);
    expect(find.text("Let's get you started"), findsOneWidget);
    expect(find.text('Continue with Google'), findsOneWidget);
    expect(find.text('Full Name'), findsOneWidget);
    expect(find.text('Email Address'), findsOneWidget);
    expect(find.text('Phone Number'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
    expect(find.text('Confirm Password'), findsOneWidget);
    expect(find.text('Already have an account? Sign in'), findsOneWidget);

    expect(tester.takeException(), isNull);
  });

  testWidgets('shows field validation when submitting an empty form', (
    WidgetTester tester,
  ) async {
    await pumpSignUpPage(tester);

    await tester.ensureVisible(
      find.byKey(const ValueKey('signup.button.primary')),
    );
    await tester.tap(find.byKey(const ValueKey('signup.button.primary')));
    await tester.pumpAndSettle();

    expect(find.text('Full name is required'), findsOneWidget);
    expect(find.text('Email address is required'), findsOneWidget);
    expect(find.text('Phone number is required'), findsOneWidget);
    expect(find.text('Password is required'), findsOneWidget);
    expect(find.text('Confirm your password to continue'), findsOneWidget);
  });

  testWidgets('sign in screen routes into the signup screen', (
    WidgetTester tester,
  ) async {
    await pumpSignUpPage(tester, home: const SignInPage());

    await tester.ensureVisible(find.widgetWithText(OutlinedButton, 'SIGN UP'));
    await tester.tap(find.widgetWithText(OutlinedButton, 'SIGN UP'));
    await tester.pumpAndSettle();

    expect(find.byType(SignUpPage), findsOneWidget);
    expect(find.text('Create Your Account'), findsOneWidget);
  });

  testWidgets('valid submission invokes onSignUpCompleted', (
    WidgetTester tester,
  ) async {
    var completed = false;
    await pumpSignUpPage(
      tester,
      home: SignUpPage(onSignUpCompleted: (_) => completed = true),
    );

    Future<void> fill(String key, String text) async {
      final finder = find.byKey(ValueKey(key));
      await tester.ensureVisible(finder);
      await tester.enterText(finder, text);
    }

    await fill('signup.field.fullName', 'Gowtham S');
    await fill('signup.field.email', 'gowtham@example.com');
    await fill('signup.field.phone', '9876543210');
    await fill('signup.field.password', 'passw0rd1');
    await fill('signup.field.confirmPassword', 'passw0rd1');

    await tester.ensureVisible(
      find.byKey(const ValueKey('signup.button.primary')),
    );
    await tester.tap(find.byKey(const ValueKey('signup.button.primary')));
    await tester.pumpAndSettle();

    expect(completed, isTrue);
  });
}
