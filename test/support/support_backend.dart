import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:nyaya/core/network/api_client.dart';

/// A fake support backend that keeps sent requests in memory.
class FakeSupportBackend {
  FakeSupportBackend({List<Map<String, Object?>>? requests})
    : requests = requests ?? [];

  final List<Map<String, Object?>> requests;
  var online = true;
  var posts = 0;

  ApiClient get client => ApiClient(
    httpClient: MockClient((request) async {
      if (!online) {
        throw http.ClientException('offline');
      }
      if (request.method == 'POST') {
        posts++;
        final body = jsonDecode(request.body) as Map<String, dynamic>;
        final created = {
          'id': requests.length + 1,
          ...body,
          'status': 'open',
          'createdAt': DateTime.now().toUtc().toIso8601String(),
        };
        requests.add(created);
        return http.Response(jsonEncode(created), 201);
      }
      return http.Response(jsonEncode({'items': requests}), 200);
    }),
  );
}
