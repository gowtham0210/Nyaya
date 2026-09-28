import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:nyaya/core/network/api_client.dart';
import 'package:nyaya/core/presentation/load_state.dart';
import 'package:nyaya/features/articles/data/articles_repository.dart';
import 'package:nyaya/features/articles/presentation/articles_view_model.dart';

import '../../../support/fake_backend.dart';

const oneArticle = {
  'items': [
    {'id': 1, 'part': 'I', 'partTitle': 'The Union', 'title': 'Name'},
  ],
};

ArticlesViewModel viewModelWith(ApiClient client) =>
    ArticlesViewModel(repository: ArticlesRepository(client));

void main() {
  test('AC-002 loading then loaded', () async {
    final viewModel = viewModelWith(fakeBackend({'/articles': oneArticle}));

    final loading = viewModel.load();
    expect(viewModel.state, isA<Loading<List<Article>>>());
    await loading;

    expect(
      (viewModel.state as Loaded<List<Article>>).data.single.title,
      'Name',
    );
  });

  test('AC-002 no articles is empty', () async {
    final viewModel = viewModelWith(
      fakeBackend({
        '/articles': {'items': []},
      }),
    );

    await viewModel.load();

    expect(viewModel.state, isA<Empty<List<Article>>>());
  });

  test('AC-002 a failure is the error state and load() recovers', () async {
    var online = false;
    final viewModel = viewModelWith(
      ApiClient(
        httpClient: MockClient((_) async {
          if (!online) {
            throw http.ClientException('offline');
          }
          return http.Response(
            '{"items":[{"id":1,"part":"I","partTitle":"U","title":"Name"}]}',
            200,
          );
        }),
      ),
    );

    await viewModel.load();
    expect(viewModel.state, isA<Failed<List<Article>>>());

    online = true;
    await viewModel.load();
    expect(viewModel.state, isA<Loaded<List<Article>>>());
  });

  test('AC-002 one article is expanded at a time; tapping again collapses', () {
    final viewModel = viewModelWith(fakeBackend({}));
    var notified = 0;
    viewModel.addListener(() => notified++);

    viewModel.toggle(1);
    expect(viewModel.isExpanded(1), isTrue);

    viewModel.toggle(2);
    expect(viewModel.isExpanded(1), isFalse);
    expect(viewModel.isExpanded(2), isTrue);

    viewModel.toggle(2);
    expect(viewModel.isExpanded(2), isFalse);
    expect(notified, 3);
  });

  test('AC-002 reloading collapses the expanded article', () async {
    final viewModel = viewModelWith(fakeBackend({'/articles': oneArticle}));
    viewModel.toggle(1);

    await viewModel.load();

    expect(viewModel.isExpanded(1), isFalse);
  });
}
