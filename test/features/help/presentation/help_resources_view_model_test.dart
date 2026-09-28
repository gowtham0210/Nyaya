import 'dart:async';
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:nyaya/core/network/api_client.dart';
import 'package:nyaya/core/presentation/load_state.dart';
import 'package:nyaya/features/help/data/help_resources_repository.dart';
import 'package:nyaya/features/help/presentation/help_resources_view_model.dart';

import '../../../support/fake_backend.dart';
import '../../../support/help_resources_backend.dart';

void main() {
  test('loads options, picks the first of each, then resources', () async {
    final viewModel = HelpResourcesViewModel(
      repository: HelpResourcesRepository(fakeBackend(helpResourcesRoutes())),
    );

    await viewModel.load();

    expect(viewModel.state, isA<Loaded<HelpOptions>>());
    expect(viewModel.selectedState?.code, 'TN');
    expect(viewModel.selectedCategory?.slug, 'women-safety');
    final resources = viewModel.resources as Loaded<List<HelpResource>>;
    expect(resources.data, hasLength(2));
  });

  test('changing the state reloads resources for it', () async {
    final asked = <Map<String, String>>[];
    final routes = helpResourcesRoutes();
    final viewModel = HelpResourcesViewModel(
      repository: HelpResourcesRepository(
        ApiClient(
          httpClient: MockClient((request) async {
            final path = request.url.path.replaceFirst('/api/v1', '');
            if (path == '/help-resources') {
              asked.add(request.url.queryParameters);
            }
            return http.Response(jsonEncode(routes[path]), 200);
          }),
        ),
      ),
    );
    await viewModel.load();

    await viewModel.selectState(
      const IndianState(code: 'KA', name: 'Karnataka'),
    );

    expect(viewModel.selectedState?.code, 'KA');
    expect(asked.last, {'state': 'KA', 'category': 'women-safety'});
  });

  test('no matches is the empty state', () async {
    final viewModel = HelpResourcesViewModel(
      repository: HelpResourcesRepository(
        fakeBackend(helpResourcesRoutes(resources: [])),
      ),
    );

    await viewModel.load();

    expect(viewModel.resources, isA<Empty<List<HelpResource>>>());
  });

  test('a slow earlier filter does not overwrite a newer one', () async {
    final slow = Completer<http.Response>();
    final routes = helpResourcesRoutes();
    var resourceCalls = 0;
    final viewModel = HelpResourcesViewModel(
      repository: HelpResourcesRepository(
        ApiClient(
          httpClient: MockClient((request) async {
            final path = request.url.path.replaceFirst('/api/v1', '');
            if (path == '/help-resources' && ++resourceCalls == 2) {
              return slow.future;
            }
            return http.Response(jsonEncode(routes[path]), 200);
          }),
        ),
      ),
    );
    await viewModel.load();

    final first = viewModel.selectCategory(
      const HelpCategory(slug: 'legal-aid', name: 'Free legal aid'),
    );
    await viewModel.selectCategory(
      const HelpCategory(slug: 'women-safety', name: "Women's safety"),
    );
    slow.complete(http.Response('{"items":[]}', 200));
    await first;

    expect(viewModel.resources, isA<Loaded<List<HelpResource>>>());
  });

  test('a failed option load is the error state and load() recovers', () async {
    final routes = helpResourcesRoutes()
      ..['/help-resources/categories'] = http.Response('{}', 500);
    final viewModel = HelpResourcesViewModel(
      repository: HelpResourcesRepository(fakeBackend(routes)),
    );

    await viewModel.load();
    expect(viewModel.state, isA<Failed<HelpOptions>>());

    routes.addAll(helpResourcesRoutes());
    await viewModel.load();
    expect(viewModel.resources, isA<Loaded<List<HelpResource>>>());
  });

  test('reloading options keeps an equal selection', () async {
    final viewModel = HelpResourcesViewModel(
      repository: HelpResourcesRepository(fakeBackend(helpResourcesRoutes())),
    );
    await viewModel.load();
    await viewModel.selectState(
      const IndianState(code: 'KA', name: 'Karnataka'),
    );

    await viewModel.load();

    final options = (viewModel.state as Loaded<HelpOptions>).data;
    expect(options.states, contains(viewModel.selectedState));
    expect(viewModel.selectedState?.code, 'KA');
  });
}
