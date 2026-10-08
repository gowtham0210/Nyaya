import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:nyaya/core/network/api_client.dart';

http.Response jsonResponse(Object body, [int status = 200]) => http.Response(
  jsonEncode(body),
  status,
  headers: const {'content-type': 'application/json'},
);

void main() {
  test('AC-001 GET returns the decoded body from /api/v1/<path>', () async {
    late Uri requested;
    final client = ApiClient(
      httpClient: MockClient((request) async {
        requested = request.url;
        return jsonResponse({
          'items': [
            {'id': 1},
          ],
        });
      }),
    );

    final body = await client.get('/categories');

    expect(requested.path, '/api/v1/categories');
    expect(body['items'], [
      {'id': 1},
    ]);
  });

  test('AC-002 attaches the bearer token when a session exists', () async {
    late http.Request sent;
    final client = ApiClient(
      readAccessToken: () => 'token-1',
      httpClient: MockClient((request) async {
        sent = request;
        return jsonResponse({});
      }),
    );

    await client.get('/users/me');

    expect(sent.headers['Authorization'], 'Bearer token-1');
  });

  test('AC-002 sends no Authorization header when the call opts out', () async {
    late http.Request sent;
    final client = ApiClient(
      readAccessToken: () => 'token-1',
      httpClient: MockClient((request) async {
        sent = request;
        return jsonResponse({});
      }),
    );

    await client.get('/help-resources/states', authenticated: false);

    expect(sent.headers.containsKey('Authorization'), isFalse);
  });

  test(
    'AC-003 adds lang for non-English and keeps other query params',
    () async {
      late Uri requested;
      final client = ApiClient(
        languageCode: () => 'ta',
        httpClient: MockClient((request) async {
          requested = request.url;
          return jsonResponse({});
        }),
      );

      await client.get('/daily-questions/random', query: {'count': '3'});

      expect(requested.queryParameters, {'count': '3', 'lang': 'ta'});
    },
  );

  test('AC-003 omits lang for English', () async {
    late Uri requested;
    final client = ApiClient(
      languageCode: () => 'en',
      httpClient: MockClient((request) async {
        requested = request.url;
        return jsonResponse({});
      }),
    );

    await client.get('/articles');

    expect(requested.queryParameters, isEmpty);
  });

  test('AC-006 404 throws ApiNotFoundException', () async {
    final client = ApiClient(
      httpClient: MockClient(
        (_) async => jsonResponse({'message': 'Nope'}, 404),
      ),
    );

    expect(client.get('/articles/9'), throwsA(isA<ApiNotFoundException>()));
  });

  test(
    'AC-006 500 throws ApiServerException with the backend message',
    () async {
      final client = ApiClient(
        httpClient: MockClient(
          (_) async => jsonResponse({'message': 'Database down'}, 500),
        ),
      );

      expect(
        client.get('/articles'),
        throwsA(
          isA<ApiServerException>()
              .having((e) => e.statusCode, 'statusCode', 500)
              .having((e) => e.message, 'message', 'Database down'),
        ),
      );
    },
  );

  test('AC-006 a transport error throws ApiOfflineException', () async {
    final client = ApiClient(
      httpClient: MockClient(
        (_) async => throw http.ClientException('refused'),
      ),
    );

    expect(client.get('/articles'), throwsA(isA<ApiOfflineException>()));
  });

  test('AC-004 a 401 refreshes the session once and retries', () async {
    var token = 'expired';
    final seen = <String?>[];
    final client = ApiClient(
      readAccessToken: () => token,
      refreshSession: () async {
        token = 'fresh';
        return true;
      },
      httpClient: MockClient((request) async {
        seen.add(request.headers['Authorization']);
        return request.headers['Authorization'] == 'Bearer fresh'
            ? jsonResponse({'fullName': 'Asha'})
            : jsonResponse({'message': 'Invalid or expired token'}, 401);
      }),
    );

    final body = await client.get('/users/me');

    expect(body['fullName'], 'Asha');
    expect(seen, ['Bearer expired', 'Bearer fresh']);
  });

  test(
    'AC-005 a 401 with a failed refresh reports the session expired',
    () async {
      var expired = false;
      final client = ApiClient(
        readAccessToken: () => 'expired',
        refreshSession: () async => false,
        onSessionExpired: () => expired = true,
        httpClient: MockClient(
          (_) async => jsonResponse({'message': 'Invalid token'}, 401),
        ),
      );

      await expectLater(
        client.get('/users/me'),
        throwsA(isA<ApiUnauthorizedException>()),
      );
      expect(expired, isTrue);
    },
  );

  test('AC-007 POST sends a JSON body', () async {
    late http.Request sent;
    final client = ApiClient(
      httpClient: MockClient((request) async {
        sent = request;
        return jsonResponse({'id': 7}, 201);
      }),
    );

    final body = await client.post(
      '/users/me/support-requests',
      body: {'subject': 'Help', 'message': 'App crashed'},
    );

    expect(sent.method, 'POST');
    expect(sent.headers['Content-Type'], startsWith('application/json'));
    expect(jsonDecode(sent.body), {
      'subject': 'Help',
      'message': 'App crashed',
    });
    expect(body['id'], 7);
  });

  test('PATCH and DELETE use their HTTP methods', () async {
    final methods = <String>[];
    final client = ApiClient(
      httpClient: MockClient((request) async {
        methods.add(request.method);
        return jsonResponse({});
      }),
    );

    await client.patch('/users/me', body: {'fullName': 'Asha'});
    await client.delete('/users/me/avatar');

    expect(methods, ['PATCH', 'DELETE']);
  });

  test('upload sends a multipart file with the bearer token', () async {
    late http.BaseRequest sent;
    late String bodyText;
    final client = ApiClient(
      readAccessToken: () => 'token-1',
      httpClient: MockClient.streaming((request, stream) async {
        sent = request;
        bodyText = utf8.decode(await stream.toBytes(), allowMalformed: true);
        return http.StreamedResponse(
          Stream.value(utf8.encode(jsonEncode({'avatarUrl': '/a.png'}))),
          200,
        );
      }),
    );

    final body = await client.upload(
      '/users/me/avatar',
      field: 'avatar',
      bytes: [1, 2, 3],
      filename: 'me.png',
    );

    expect(sent.method, 'POST');
    expect(sent.headers['Authorization'], 'Bearer token-1');
    expect(sent.headers['Content-Type'], startsWith('multipart/form-data'));
    expect(bodyText, contains('name="avatar"; filename="me.png"'));
    expect(body['avatarUrl'], '/a.png');
  });
}
