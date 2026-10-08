import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:nyaya/core/network/api_client.dart';

/// Canned JSON responses keyed by request path (`/api/v1` stripped), for
/// tests that fake the backend at the [ApiClient] seam (ADR 0002).
/// A path mapped to an [http.Response] returns it as is; a missing path
/// returns 404. A `'POST /path'` key wins over a plain path for that method,
/// and a route may be a function of the request (e.g. to read its body).
ApiClient fakeBackend(Map<String, Object> routes) => ApiClient(
  readAccessToken: () => 'test-token',
  httpClient: fakeBackendClient(routes),
);

/// The `http.Client` behind [fakeBackend]; [onRequest] sees each path.
http.Client fakeBackendClient(
  Map<String, Object> routes, {
  void Function(String path)? onRequest,
}) {
  return MockClient((request) async {
    final path = request.url.path.replaceFirst('/api/v1', '');
    onRequest?.call(path);
    var route = routes['${request.method} $path'] ?? routes[path];
    if (route is Object Function(http.Request)) {
      route = route(request);
    }
    if (route == null) {
      return http.Response(jsonEncode({'message': 'No route $path'}), 404);
    }
    if (route is http.Response) {
      return route;
    }
    return http.Response(
      jsonEncode(route),
      200,
      headers: const {'content-type': 'application/json; charset=utf-8'},
    );
  });
}
