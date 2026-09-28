import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:nyaya/core/network/api_client.dart';
import 'package:nyaya/core/presentation/load_state.dart';
import 'package:nyaya/core/presentation/widgets/nyaya_icon.dart';
import 'package:nyaya/features/categories/data/categories_repository.dart';
import 'package:nyaya/features/categories/presentation/categories_view_model.dart';

import '../../../support/fake_backend.dart';

const twoCategories = {
  'items': [
    {'id': 1, 'name': 'Criminal Law', 'slug': 'criminal-law'},
    {'id': 2, 'name': 'Tax Law', 'slug': 'tax-law'},
  ],
};

CategoriesViewModel viewModelWith(ApiClient client) =>
    CategoriesViewModel(repository: CategoriesRepository(client));

void main() {
  test('AC-003 loading then loaded with a card per category', () async {
    final viewModel = viewModelWith(
      fakeBackend({
        '/categories': twoCategories,
        '/categories/1/quizzes': {
          'items': [
            {'id': 5},
          ],
        },
        '/categories/2/quizzes': {'items': []},
      }),
    );

    final loading = viewModel.load();
    expect(viewModel.state, isA<Loading<List<CategoryData>>>());
    await loading;

    final cards = (viewModel.state as Loaded<List<CategoryData>>).data;
    expect(cards.map((c) => c.label), ['Criminal Law', 'Tax Law']);
    expect(cards.map((c) => c.quizCount), [1, 0]);
    // A known slug keeps its designed icon; an unknown one still gets one.
    expect(cards.first.icon, HomeIconType.gavel);
    expect(cards.last.icon, isA<HomeIconType>());
  });

  test('AC-003 no categories is the empty state', () async {
    final viewModel = viewModelWith(
      fakeBackend({
        '/categories': {'items': []},
      }),
    );

    await viewModel.load();

    expect(viewModel.state, isA<Empty<List<CategoryData>>>());
  });

  test('AC-003 a failure is the error state and load() recovers', () async {
    var online = false;
    final client = ApiClient(
      httpClient: MockClient((request) async {
        if (!online) {
          throw http.ClientException('offline');
        }
        return request.url.path.endsWith('/categories')
            ? http.Response(
                '{"items":[{"id":1,"name":"Civil Law","slug":"civil-law"}]}',
                200,
              )
            : http.Response('{"items":[]}', 200);
      }),
    );
    final viewModel = viewModelWith(client);

    await viewModel.load();
    final failed = viewModel.state as Failed<List<CategoryData>>;
    expect(failed.error, isA<ApiOfflineException>());

    online = true;
    await viewModel.load();
    expect(viewModel.state, isA<Loaded<List<CategoryData>>>());
  });

  test('filter is case-insensitive and blank returns everything', () async {
    final viewModel = viewModelWith(
      fakeBackend({
        '/categories': twoCategories,
        '/categories/1/quizzes': {'items': []},
        '/categories/2/quizzes': {'items': []},
      }),
    );
    await viewModel.load();
    final cards = (viewModel.state as Loaded<List<CategoryData>>).data;

    expect(viewModel.filter(cards, 'CRIM').map((c) => c.slug), [
      'criminal-law',
    ]);
    expect(viewModel.filter(cards, '  '), hasLength(2));
    expect(viewModel.filter(cards, 'zzz'), isEmpty);
  });

  test(
    'AC-003 an unexpected response is the error state, not a stuck spinner',
    () async {
      final viewModel = viewModelWith(
        fakeBackend({
          '/categories': {
            'items': [
              {'id': 1, 'name': null, 'slug': 'civil-law'},
            ],
          },
        }),
      );

      await viewModel.load();

      expect(viewModel.state, isA<Failed<List<CategoryData>>>());
    },
  );

  test('a newer load wins over a slower earlier one', () async {
    final firstResponse = Completer<http.Response>();
    var calls = 0;
    final client = ApiClient(
      httpClient: MockClient((request) async {
        if (!request.url.path.endsWith('/categories')) {
          return http.Response('{"items":[]}', 200);
        }
        calls++;
        if (calls == 1) {
          return firstResponse.future;
        }
        return http.Response(
          '{"items":[{"id":2,"name":"New","slug":"new"}]}',
          200,
        );
      }),
    );
    final viewModel = viewModelWith(client);

    final slow = viewModel.load();
    await viewModel.load();
    firstResponse.complete(
      http.Response('{"items":[{"id":1,"name":"Old","slug":"old"}]}', 200),
    );
    await slow;

    final cards = (viewModel.state as Loaded<List<CategoryData>>).data;
    expect(cards.single.label, 'New');
  });
}
