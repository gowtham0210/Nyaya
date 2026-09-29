import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:nyaya/app/api_client.dart';
import 'package:nyaya/app/app_session.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await AppSession.clear();
    AppSession.accessToken = 'expired-access';
    AppSession.refreshToken = 'good-refresh';
  });

  http.Response json(Object body, int status) => http.Response(
    jsonEncode(body),
    status,
    headers: {'content-type': 'application/json'},
  );

  test(
    'an expired access token is refreshed and the request replayed',
    () async {
      final paths = <String>[];
      var refreshed = false;

      final client = ApiClient(
        baseUrl: 'http://test/api/v1',
        httpClient: MockClient((request) async {
          paths.add('${request.method} ${request.url.path}');

          if (request.url.path.endsWith('/auth/refresh')) {
            refreshed = true;
            return json({
              'accessToken': 'fresh-access',
              'refreshToken': 'fresh-refresh',
            }, 200);
          }
          if (!refreshed) {
            return json({'message': 'Invalid or expired token'}, 401);
          }
          expect(request.headers['Authorization'], 'Bearer fresh-access');
          return json({'items': <Object>[]}, 200);
        }),
      );

      final result = await client.get('/quizzes');

      expect(result, containsPair('items', isEmpty));
      expect(paths, [
        'GET /api/v1/quizzes',
        'POST /api/v1/auth/refresh',
        'GET /api/v1/quizzes',
      ]);
      expect(AppSession.accessToken, 'fresh-access');
      expect(AppSession.refreshToken, 'fresh-refresh');
    },
  );

  test('a refused refresh ends the session but keeps the goal', () async {
    await AppSession.saveGoal('learn-law-for-life');

    final client = ApiClient(
      baseUrl: 'http://test/api/v1',
      httpClient: MockClient((request) async {
        if (request.url.path.endsWith('/auth/refresh')) {
          return json({'message': 'Invalid or expired refresh token'}, 401);
        }
        return json({'message': 'Invalid or expired token'}, 401);
      }),
    );

    await expectLater(
      client.get('/quizzes'),
      throwsA(
        isA<ApiException>().having((e) => e.isUnauthorized, 'is 401', isTrue),
      ),
    );

    expect(AppSession.accessToken, isNull);
    expect(AppSession.refreshToken, isNull);
    expect(AppSession.isOnboarded, isFalse);
    // Signing back in should not mean picking a goal again.
    expect(AppSession.selectedGoalId, 'learn-law-for-life');
  });

  test('a refresh that answers with nulls ends the session', () async {
    final client = ApiClient(
      baseUrl: 'http://test/api/v1',
      httpClient: MockClient((request) async {
        if (request.url.path.endsWith('/auth/refresh')) {
          return json({'accessToken': null, 'refreshToken': null}, 200);
        }
        return json({'message': 'Invalid or expired token'}, 401);
      }),
    );

    await expectLater(client.get('/quizzes'), throwsA(isA<ApiException>()));

    expect(AppSession.accessToken, isNull);
  });

  test('a network failure leaves the tokens alone to retry later', () async {
    final client = ApiClient(
      baseUrl: 'http://test/api/v1',
      httpClient: MockClient((_) async => throw http.ClientException('down')),
    );

    await expectLater(
      client.get('/quizzes'),
      throwsA(
        isA<ApiException>().having(
          (e) => e.isNetworkFailure,
          'is a network failure',
          isTrue,
        ),
      ),
    );

    expect(AppSession.accessToken, 'expired-access');
    expect(AppSession.refreshToken, 'good-refresh');
  });

  test('the request is only replayed once', () async {
    var calls = 0;

    final client = ApiClient(
      baseUrl: 'http://test/api/v1',
      httpClient: MockClient((request) async {
        if (request.url.path.endsWith('/auth/refresh')) {
          return json({
            'accessToken': 'fresh-access',
            'refreshToken': 'fresh-refresh',
          }, 200);
        }
        calls += 1;
        return json({'message': 'Invalid or expired token'}, 401);
      }),
    );

    await expectLater(client.get('/quizzes'), throwsA(isA<ApiException>()));

    expect(calls, 2, reason: 'original plus one replay, then give up');
  });
}
