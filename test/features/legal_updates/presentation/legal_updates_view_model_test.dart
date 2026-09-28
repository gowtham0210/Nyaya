import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:nyaya/core/network/api_client.dart';
import 'package:nyaya/core/presentation/load_state.dart';
import 'package:nyaya/features/legal_updates/data/legal_updates_repository.dart';
import 'package:nyaya/features/legal_updates/presentation/legal_updates_view_model.dart';

import '../../../support/fake_backend.dart';

LegalUpdatesViewModel viewModelWith(ApiClient client) =>
    LegalUpdatesViewModel(repository: LegalUpdatesRepository(client));

String oneUpdate(String title) =>
    '{"items":[{"id":1,"category":"Notices","title":"$title",'
    '"summary":"s","updateDate":"2026-09-01"}]}';

void main() {
  test('AC-002 loading then loaded with the updates', () async {
    final viewModel = viewModelWith(
      fakeBackend({
        '/legal-updates': {
          'items': [
            {
              'id': 1,
              'category': 'Reforms',
              'title': 'Bail reform',
              'summary': 'New rules.',
              'updateDate': '2026-09-10',
            },
          ],
        },
      }),
    );

    final loading = viewModel.load();
    expect(viewModel.state, isA<Loading<List<LegalUpdate>>>());
    await loading;

    final updates = (viewModel.state as Loaded<List<LegalUpdate>>).data;
    expect(updates.single.title, 'Bail reform');
  });

  test('AC-002 no updates is the empty state', () async {
    final viewModel = viewModelWith(
      fakeBackend({
        '/legal-updates': {'items': []},
      }),
    );

    await viewModel.load();

    expect(viewModel.state, isA<Empty<List<LegalUpdate>>>());
  });

  test('AC-002 a failure is the error state and load() recovers', () async {
    var online = false;
    final viewModel = viewModelWith(
      ApiClient(
        httpClient: MockClient((request) async {
          if (!online) {
            throw http.ClientException('offline');
          }
          return http.Response(oneUpdate('Back online'), 200);
        }),
      ),
    );

    await viewModel.load();
    final failed = viewModel.state as Failed<List<LegalUpdate>>;
    expect(failed.error, isA<ApiOfflineException>());

    online = true;
    await viewModel.load();
    expect(viewModel.state, isA<Loaded<List<LegalUpdate>>>());
  });

  test('AC-002 a newer load wins over a slower earlier one', () async {
    final firstResponse = Completer<http.Response>();
    var calls = 0;
    final viewModel = viewModelWith(
      ApiClient(
        httpClient: MockClient((request) async {
          calls++;
          return calls == 1
              ? firstResponse.future
              : http.Response(oneUpdate('New'), 200);
        }),
      ),
    );

    final slow = viewModel.load();
    await viewModel.load();
    firstResponse.complete(http.Response(oneUpdate('Old'), 200));
    await slow;

    final updates = (viewModel.state as Loaded<List<LegalUpdate>>).data;
    expect(updates.single.title, 'New');
  });
}
