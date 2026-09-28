import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:nyaya/core/network/api_client.dart';
import 'package:nyaya/features/help/data/support_repository.dart';

void main() {
  test('lists requests newest first with their status', () async {
    final repository = SupportRepository(
      ApiClient(
        httpClient: MockClient(
          (_) async => http.Response(
            jsonEncode({
              'items': [
                {
                  'id': 1,
                  'subject': 'Old',
                  'message': 'First',
                  'status': 'resolved',
                  'createdAt': '2026-08-01T10:00:00.000Z',
                },
                {
                  'id': 2,
                  'subject': 'New',
                  'message': 'Second',
                  'status': 'in_progress',
                  'createdAt': '2026-09-20T10:00:00.000Z',
                },
                {
                  'id': 3,
                  'subject': 'Odd',
                  'message': 'Third',
                  'status': 'escalated',
                  'createdAt': '2026-09-01T10:00:00.000Z',
                },
              ],
            }),
            200,
          ),
        ),
      ),
    );

    final requests = await repository.fetchRequests();

    expect(requests.map((r) => r.subject), ['New', 'Odd', 'Old']);
    expect(requests.first.status, SupportStatus.inProgress);
    expect(requests.last.status, SupportStatus.resolved);
    expect(requests[1].status, SupportStatus.open);
    expect(requests.first.createdAt, DateTime.utc(2026, 9, 20, 10).toLocal());
  });

  test('sends a request and returns it', () async {
    late http.Request sent;
    final repository = SupportRepository(
      ApiClient(
        httpClient: MockClient((request) async {
          sent = request;
          return http.Response(
            '{"id":9,"subject":"Help","message":"Cannot log in","status":"open"}',
            201,
          );
        }),
      ),
    );

    final request = await repository.send(
      subject: 'Help',
      message: 'Cannot log in',
    );

    expect(sent.method, 'POST');
    expect(sent.url.path, '/api/v1/users/me/support-requests');
    expect(jsonDecode(sent.body), {
      'subject': 'Help',
      'message': 'Cannot log in',
    });
    expect(request.id, 9);
    expect(request.status, SupportStatus.open);
    // No createdAt from the backend: treat it as just sent.
    expect(DateTime.now().difference(request.createdAt).inMinutes, lessThan(1));
  });
}
