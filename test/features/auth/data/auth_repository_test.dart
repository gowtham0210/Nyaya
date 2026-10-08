import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:nyaya/core/network/api_client.dart';
import 'package:nyaya/features/auth/data/auth_api_client.dart';
import 'package:nyaya/features/auth/data/auth_repository.dart';
import 'package:nyaya/features/auth/data/auth_token_store.dart';

AuthRepository repositoryWith(MockClientHandler handler) => AuthRepository(
  apiClient: AuthApiClient(client: ApiClient(httpClient: MockClient(handler))),
);

http.Response jsonResponse(Object body, [int status = 200]) =>
    http.Response(jsonEncode(body), status);

void main() {
  setUp(AuthTokenStore.clear);

  test('login stores the session and returns the user', () async {
    final repository = repositoryWith(
      (request) async => jsonResponse({
        'accessToken': 'a1',
        'refreshToken': 'r1',
        'user': {'id': 3, 'fullName': 'Asha'},
      }),
    );

    final user = await repository.login(phone: '+919000000000', password: 'x');

    expect(user?.fullName, 'Asha');
    expect(AuthTokenStore.accessToken, 'a1');
    expect(AuthTokenStore.refreshToken, 'r1');
  });

  test('a rejected login surfaces the backend message', () async {
    final repository = repositoryWith(
      (_) async => jsonResponse({'message': 'Wrong phone or password'}, 401),
    );

    expect(
      repository.login(phone: '+919000000000', password: 'x'),
      throwsA(
        isA<AuthApiException>().having(
          (e) => e.message,
          'message',
          'Wrong phone or password',
        ),
      ),
    );
  });

  test('spec 041 register signs in, then saves the profession', () async {
    final calls = <String>[];
    final repository = repositoryWith((request) async {
      calls.add('${request.method} ${request.url.path} ${request.body}');
      return request.url.path.endsWith('/auth/register')
          ? jsonResponse({
              'accessToken': 'a1',
              'refreshToken': 'r1',
              'user': {'id': 9, 'fullName': 'Asha'},
            }, 201)
          : jsonResponse({'message': 'boom'}, 500);
    });

    final user = await repository.register(
      fullName: 'Asha',
      email: 'asha@example.com',
      password: 'passw0rd1',
      profession: 'Law Student',
    );

    // A failed profession save doesn't undo the new account.
    expect(user?.fullName, 'Asha');
    expect(AuthTokenStore.accessToken, 'a1');
    expect(calls, [
      'POST /api/v1/auth/register '
          '{"fullName":"Asha","email":"asha@example.com","password":"passw0rd1"}',
      'PATCH /api/v1/users/me {"profession":"Law Student"}',
    ]);
  });

  test('refresh swaps in the new tokens', () async {
    AuthTokenStore.saveSession(accessToken: 'old', refreshToken: 'r-old');
    final repository = repositoryWith((request) async {
      expect(jsonDecode(request.body), {'refreshToken': 'r-old'});
      return jsonResponse({'accessToken': 'new', 'refreshToken': 'r-new'});
    });

    expect(await repository.refresh(), isTrue);
    expect(AuthTokenStore.accessToken, 'new');
  });

  test('refresh with an invalid token clears the session', () async {
    AuthTokenStore.saveSession(accessToken: 'old', refreshToken: 'r-old');
    final repository = repositoryWith(
      (_) async => jsonResponse({'accessToken': null, 'refreshToken': null}),
    );

    expect(await repository.refresh(), isFalse);
    expect(AuthTokenStore.hasSession, isFalse);
  });
}
