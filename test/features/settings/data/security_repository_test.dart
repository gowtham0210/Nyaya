import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:nyaya/core/network/api_client.dart';
import 'package:nyaya/features/settings/data/security_repository.dart';

void main() {
  test('reads the active session count', () async {
    final repository = SecurityRepository(
      ApiClient(
        httpClient: MockClient((request) async {
          expect(request.url.path, '/api/v1/users/me/security');
          return http.Response('{"activeSessions":3}', 200);
        }),
      ),
    );

    expect(await repository.fetchActiveSessions(), 3);
  });

  test('logs out of every device', () async {
    late http.Request sent;
    final repository = SecurityRepository(
      ApiClient(
        httpClient: MockClient((request) async {
          sent = request;
          return http.Response('{}', 200);
        }),
      ),
    );

    await repository.logoutAll();

    expect(sent.method, 'POST');
    expect(sent.url.path, '/api/v1/users/me/logout-all');
  });
}
