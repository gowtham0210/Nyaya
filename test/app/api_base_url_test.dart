import 'package:flutter_test/flutter_test.dart';
import 'package:nyaya/app/api_client.dart';

void main() {
  test('the default base URL points at a local dev server', () {
    // No --dart-define in a plain test run, so this is the fallback path.
    expect(ApiClient().baseUrl, endsWith(':5000/api/v1'));
  });

  test('an explicit base URL points the app at another host', () {
    final client = ApiClient(baseUrl: 'http://192.168.0.8:5000/api/v1');

    expect(client.baseUrl, 'http://192.168.0.8:5000/api/v1');
  });

  test('the app only ever speaks HTTP to an /api/v1 root', () {
    // A guard against anyone reintroducing a direct database connection:
    // the client's only configured endpoint is the API server.
    final uri = Uri.parse(ApiClient().baseUrl);

    expect(uri.scheme, anyOf('http', 'https'));
    expect(uri.path, '/api/v1');
    expect(uri.port, isNot(3306), reason: 'must never address MySQL directly');
  });
}
