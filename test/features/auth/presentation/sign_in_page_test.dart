import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:nyaya/core/network/api_client.dart';
import 'package:nyaya/features/auth/data/auth_api_client.dart';
import 'package:nyaya/features/auth/data/auth_repository.dart';
import 'package:nyaya/features/auth/data/auth_token_store.dart';
import 'package:nyaya/features/auth/presentation/otp_verification_page.dart';
import 'package:nyaya/features/auth/presentation/sign_in_page.dart';
import 'package:nyaya/features/goal_selection/presentation/goal_selection_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../support/fake_phone_auth.dart';

/// Specs 041–042: email + password first; phone signs in by OTP.
void main() {
  late List<Map<String, dynamic>> logins;
  late List<String> paths;
  late FakePhoneAuthService phoneAuth;

  setUp(() {
    AuthTokenStore.clear();
    SharedPreferences.setMockInitialValues({});
  });

  Future<void> pumpSignIn(
    WidgetTester tester, {
    bool phoneLoginExists = true,
  }) async {
    logins = [];
    paths = [];
    phoneAuth = FakePhoneAuthService();
    final repository = AuthRepository(
      apiClient: AuthApiClient(
        client: ApiClient(
          httpClient: MockClient((request) async {
            logins.add(jsonDecode(request.body) as Map<String, dynamic>);
            paths.add(request.url.path);
            if (!phoneLoginExists &&
                request.url.path.endsWith('/auth/phone-login')) {
              return http.Response('{"message":"Not found"}', 404);
            }
            return http.Response(
              jsonEncode({'accessToken': 'a1', 'refreshToken': 'r1'}),
              200,
            );
          }),
        ),
      ),
    );
    tester.view.physicalSize = const Size(393, 852);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      MaterialApp(
        home: SignInPage(
          authRepository: repository,
          phoneAuthService: phoneAuth,
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  Future<void> login(WidgetTester tester) async {
    await tester.ensureVisible(
      find.byKey(const ValueKey('signin.button.login')),
    );
    await tester.tap(find.byKey(const ValueKey('signin.button.login')));
    await tester.pumpAndSettle();
  }

  testWidgets('AC-001 email comes first; the switch shows phone', (
    tester,
  ) async {
    await pumpSignIn(tester);

    expect(find.byKey(const ValueKey('signin.field.email')), findsOneWidget);
    expect(find.byKey(const ValueKey('signin.field.phone')), findsNothing);
    expect(find.text('Email Address'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('signin.method.phone')));
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('signin.field.email')), findsNothing);
    expect(find.byKey(const ValueKey('signin.field.phone')), findsOneWidget);
    expect(find.text('+91'), findsOneWidget);
  });

  testWidgets('AC-002 email login sends the email, then opens goals', (
    tester,
  ) async {
    await pumpSignIn(tester);
    await tester.enterText(
      find.byKey(const ValueKey('signin.field.email')),
      ' Asha@Example.com ',
    );
    await tester.enterText(
      find.byKey(const ValueKey('signin.field.password')),
      'passw0rd1',
    );
    await login(tester);

    expect(logins, [
      {'email': 'asha@example.com', 'password': 'passw0rd1'},
    ]);
    expect(find.byType(GoalSelectionPage), findsOneWidget);
  });

  group('spec 042 phone OTP', () {
    Future<void> sendOtp(WidgetTester tester, String phone) async {
      await tester.tap(find.byKey(const ValueKey('signin.method.phone')));
      await tester.pumpAndSettle();
      await tester.enterText(
        find.byKey(const ValueKey('signin.field.phone')),
        phone,
      );
      await tester.tap(find.byKey(const ValueKey('signin.button.sendOtp')));
      await tester.pumpAndSettle();
    }

    Future<void> enterCode(WidgetTester tester) async {
      for (var i = 0; i < 6; i++) {
        await tester.enterText(find.byKey(ValueKey('otp.digit.$i')), '$i');
      }
      await tester.tap(find.byKey(const ValueKey('otp.button.verify')));
      await tester.pumpAndSettle();
    }

    testWidgets('AC-001 the phone tab has no password; Send OTP', (
      tester,
    ) async {
      await pumpSignIn(tester);
      await tester.tap(find.byKey(const ValueKey('signin.method.phone')));
      await tester.pumpAndSettle();

      expect(find.byKey(const ValueKey('signin.field.password')), findsNothing);
      expect(find.byKey(const ValueKey('signin.button.login')), findsNothing);
      expect(find.text('Send OTP'), findsOneWidget);
    });

    testWidgets('AC-002 the code signs in by phone, then opens goals', (
      tester,
    ) async {
      await pumpSignIn(tester);
      await sendOtp(tester, '9876543210');

      expect(phoneAuth.sentTo, ['+919876543210']);
      expect(find.byType(OtpVerificationPage), findsOneWidget);

      await enterCode(tester);

      expect(phoneAuth.codes, ['012345']);
      expect(paths, ['/api/v1/auth/phone-login']);
      expect(logins, [
        {'firebase_id_token': 'fb-token', 'phone': '+919876543210'},
      ]);
      expect(AuthTokenStore.accessToken, 'a1');
      expect(find.byType(GoalSelectionPage), findsOneWidget);
    });

    testWidgets('AC-003 a short number sends no code', (tester) async {
      await pumpSignIn(tester);
      await sendOtp(tester, '98765');

      expect(find.text('Enter a valid phone number'), findsOneWidget);
      expect(phoneAuth.sentTo, isEmpty);
    });

    testWidgets('AC-004 without the backend endpoint, says use email', (
      tester,
    ) async {
      await pumpSignIn(tester, phoneLoginExists: false);
      await sendOtp(tester, '9876543210');
      await enterCode(tester);

      expect(
        find.text("Phone sign-in isn't available yet. Please use email."),
        findsOneWidget,
      );
      expect(find.byType(OtpVerificationPage), findsOneWidget);
      expect(AuthTokenStore.hasSession, isFalse);
    });
  });

  testWidgets('AC-002 a missing or bad email sends nothing', (tester) async {
    await pumpSignIn(tester);
    await tester.enterText(
      find.byKey(const ValueKey('signin.field.password')),
      'passw0rd1',
    );
    await login(tester);
    expect(find.text('Email is required'), findsOneWidget);

    await tester.enterText(
      find.byKey(const ValueKey('signin.field.email')),
      'asha',
    );
    await login(tester);
    expect(find.text('Enter a valid email'), findsOneWidget);
    expect(logins, isEmpty);
  });
}
