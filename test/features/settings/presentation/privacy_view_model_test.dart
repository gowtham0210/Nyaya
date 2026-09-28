import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:nyaya/core/network/api_client.dart';
import 'package:nyaya/core/presentation/load_state.dart';
import 'package:nyaya/features/settings/data/security_repository.dart';
import 'package:nyaya/features/settings/presentation/privacy_view_model.dart';

PrivacyViewModel viewModelWith(
  Future<http.Response> Function(http.Request) handler,
) => PrivacyViewModel(
  repository: SecurityRepository(ApiClient(httpClient: MockClient(handler))),
);

void main() {
  test('loads the active session count', () async {
    final viewModel = viewModelWith(
      (_) async => http.Response('{"activeSessions":2}', 200),
    );

    await viewModel.load();

    expect((viewModel.state as Loaded<int>).data, 2);
  });

  test('logging out everywhere reports success', () async {
    final viewModel = viewModelWith((_) async => http.Response('{}', 200));

    expect(await viewModel.logoutAll(), isTrue);
    expect(viewModel.logoutError, isNull);
  });

  test('a failed logout keeps the learner in and says why', () async {
    final viewModel = viewModelWith(
      (_) async => throw http.ClientException('offline'),
    );

    final logout = viewModel.logoutAll();
    expect(viewModel.loggingOut, isTrue);
    expect(await logout, isFalse);

    expect(viewModel.loggingOut, isFalse);
    expect(viewModel.logoutError, isA<ApiOfflineException>());
  });

  test('a failed load is the error state and load() recovers', () async {
    var online = false;
    final viewModel = viewModelWith((_) async {
      if (!online) {
        throw http.ClientException('offline');
      }
      return http.Response('{"activeSessions":1}', 200);
    });

    await viewModel.load();
    expect(viewModel.state, isA<Failed<int>>());

    online = true;
    await viewModel.load();
    expect((viewModel.state as Loaded<int>).data, 1);
  });

  test('closing during log out does not throw', () async {
    final viewModel = viewModelWith((_) async => http.Response('{}', 200));

    final logout = viewModel.logoutAll();
    viewModel.dispose();

    expect(await logout, isTrue);
  });
}
