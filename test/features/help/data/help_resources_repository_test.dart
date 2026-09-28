import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:nyaya/core/network/api_client.dart';
import 'package:nyaya/features/help/data/help_resources_repository.dart';

import '../../../support/fake_backend.dart';
import '../../../support/help_resources_backend.dart';

const tamilNadu = IndianState(code: 'TN', name: 'Tamil Nadu');
const womenSafety = HelpCategory(slug: 'women-safety', name: "Women's safety");

void main() {
  test('loads states and categories', () async {
    final repository = HelpResourcesRepository(
      fakeBackend(helpResourcesRoutes()),
    );

    final options = await repository.fetchOptions();

    expect(options.states.map((s) => s.code), ['TN', 'KA']);
    expect(options.states.first.name, 'Tamil Nadu');
    expect(options.categories.map((c) => c.slug), [
      'women-safety',
      'legal-aid',
    ]);
  });

  test('filters resources by state and category', () async {
    late Uri asked;
    final repository = HelpResourcesRepository(
      ApiClient(
        httpClient: MockClient((request) async {
          asked = request.url;
          return http.Response('{"items":[]}', 200);
        }),
      ),
    );

    await repository.fetchResources(state: tamilNadu, category: womenSafety);

    expect(asked.path, '/api/v1/help-resources');
    expect(asked.queryParameters, {'state': 'TN', 'category': 'women-safety'});
  });

  test('maps resources, calling toll-free first', () async {
    final repository = HelpResourcesRepository(
      fakeBackend(helpResourcesRoutes()),
    );

    final [national, state] = await repository.fetchResources(
      state: tamilNadu,
      category: womenSafety,
    );

    expect(national.name, 'Women Helpline');
    expect(national.isNational, isTrue);
    expect(national.callNumber, '181');
    expect(national.email, 'help@wcd.example.in');
    expect(national.website, Uri.parse('https://wcd.example.in'));
    expect(national.isVerified, isTrue);
    expect(national.verifiedAt, DateTime.utc(2026, 9, 1).toLocal());
    expect(state.callNumber, '044-2855 1155');
    expect(state.isVerified, isFalse);
    expect(state.email, isNull);
    expect(state.source, Uri.parse('https://tn.example.in'));
  });
}
