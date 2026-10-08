import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:nyaya/core/network/api_client.dart';
import 'package:nyaya/features/auth/data/auth_api_client.dart';
import 'package:nyaya/features/auth/data/auth_repository.dart';
import 'package:nyaya/features/auth/data/auth_token_store.dart';
import 'package:nyaya/features/goal_selection/presentation/goal_selection_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
    expect(find.byKey(const ValueKey('signup.button.create')), findsOneWidget);
    expect(find.byKey(const ValueKey('signup.footer.login')), findsOneWidget);

    expect(find.text('Create Your Account'), findsOneWidget);
    expect(
      find.text('Join NYAYA and start your legal learning journey'),
      findsOneWidget,
    );
    expect(find.text('Full Name'), findsOneWidget);
    expect(find.text('Profession'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
    expect(find.text('Email Address'), findsOneWidget);
    expect(find.text('Phone Number (optional)'), findsOneWidget);
    expect(find.text('Create account'), findsOneWidget);
    expect(find.text('Send OTP'), findsNothing);

    expect(tester.takeException(), isNull);
  });

  testWidgets('shows field validation when submitting an empty form', (
    WidgetTester tester,
  ) async {
    await pumpSignUpPage(tester);

    await tester.ensureVisible(
      find.byKey(const ValueKey('signup.button.create')),
    );
    await tester.tap(find.byKey(const ValueKey('signup.button.create')));
    await tester.pumpAndSettle();

    expect(find.text('Full name is required'), findsOneWidget);
    expect(find.text('Profession is required'), findsOneWidget);
    expect(find.text('Email is required'), findsOneWidget);
    expect(find.text('Password is required'), findsOneWidget);
    // Phone is optional (spec 041).
    expect(find.text('Phone number is required'), findsNothing);
  });

  testWidgets('spec 041 AC-003 a bad email or short phone is flagged', (
    tester,
  ) async {
    await pumpSignUpPage(tester);
    await tester.enterText(
      find.byKey(const ValueKey('signup.field.email')),
      'asha@',
    );
    await tester.enterText(
      find.byKey(const ValueKey('signup.field.phone')),
      '98765',
    );
    await tester.ensureVisible(
      find.byKey(const ValueKey('signup.button.create')),
    );
    await tester.tap(find.byKey(const ValueKey('signup.button.create')));
    await tester.pumpAndSettle();

    expect(find.text('Enter a valid email'), findsOneWidget);
    expect(find.text('Enter a valid phone number'), findsOneWidget);
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

  group('spec 041 AC-004 creating an account', () {
    late List<http.Request> requests;

    AuthRepository repository({int registerStatus = 201}) {
      requests = [];
      return AuthRepository(
        apiClient: AuthApiClient(
          client: ApiClient(
            httpClient: MockClient((request) async {
              requests.add(request);
              if (request.url.path.endsWith('/auth/register')) {
                return registerStatus == 201
                    ? http.Response(
                        jsonEncode({
                          'accessToken': 'a1',
                          'refreshToken': 'r1',
                          'user': {'id': 9, 'fullName': 'Gowtham S'},
                        }),
                        201,
                      )
                    : http.Response(
                        jsonEncode({'message': 'Email already registered'}),
                        registerStatus,
                      );
              }
              return http.Response('{"id":9}', 200);
            }),
          ),
        ),
      );
    }

    Future<void> fillAndSubmit(WidgetTester tester, {String phone = ''}) async {
      Future<void> fill(String key, String text) async {
        final finder = find.byKey(ValueKey(key));
        await tester.ensureVisible(finder);
        await tester.enterText(finder, text);
      }

      await fill('signup.field.fullName', 'Gowtham S');
      await fill('signup.field.email', ' Gowtham@Example.com ');
      await tester.ensureVisible(
        find.byKey(const ValueKey('signup.field.profession')),
      );
      await tester.tap(find.byKey(const ValueKey('signup.field.profession')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Law Student'));
      await tester.pumpAndSettle();
      await fill('signup.field.password', 'passw0rd1');
      if (phone.isNotEmpty) await fill('signup.field.phone', phone);

      await tester.ensureVisible(
        find.byKey(const ValueKey('signup.button.create')),
      );
      await tester.tap(find.byKey(const ValueKey('signup.button.create')));
      await tester.pumpAndSettle();
    }

    setUp(() {
      AuthTokenStore.clear();
      SharedPreferences.setMockInitialValues({});
    });

    testWidgets('registers by email, saves the profession, opens goals', (
      tester,
    ) async {
      await pumpSignUpPage(
        tester,
        home: SignUpPage(authRepository: repository()),
      );
      await fillAndSubmit(tester, phone: '9876543210');

      expect(requests.map((r) => '${r.method} ${r.url.path}'), [
        'POST /api/v1/auth/register',
        'PATCH /api/v1/users/me',
      ]);
      expect(jsonDecode(requests.first.body), {
        'fullName': 'Gowtham S',
        'email': 'gowtham@example.com',
        'password': 'passw0rd1',
        'phone': '+919876543210',
      });
      expect(jsonDecode(requests.last.body), {'profession': 'Law Student'});
      expect(AuthTokenStore.accessToken, 'a1');
      expect(find.byType(GoalSelectionPage), findsOneWidget);
    });

    testWidgets('without a phone, sends none', (tester) async {
      await pumpSignUpPage(
        tester,
        home: SignUpPage(authRepository: repository()),
      );
      await fillAndSubmit(tester);

      expect(
        (jsonDecode(requests.first.body) as Map).containsKey('phone'),
        isFalse,
      );
    });

    testWidgets('a backend error shows its message and stays', (tester) async {
      await pumpSignUpPage(
        tester,
        home: SignUpPage(authRepository: repository(registerStatus: 409)),
      );
      await fillAndSubmit(tester);

      expect(find.text('Email already registered'), findsOneWidget);
      expect(find.byType(SignUpPage), findsOneWidget);
      expect(requests, hasLength(1));
    });
  });
}
