import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:nyaya/core/network/api_client.dart';
import 'package:nyaya/core/presentation/load_state.dart';
import 'package:nyaya/features/home/data/progress_repository.dart';
import 'package:nyaya/features/home/presentation/learning_progress_view_model.dart';

import '../../../support/fake_backend.dart';

LearningProgressViewModel viewModelWith(ApiClient client) =>
    LearningProgressViewModel(repository: ProgressRepository(client));

String progressJson({int attempted = 4, int points = 90}) =>
    '{"totalQuizzesAttempted":$attempted,"totalQuizzesCompleted":2,'
    '"totalPoints":$points,"accuracyPercentage":50}';

void main() {
  test('AC-002 loading then loaded with the progress', () async {
    final viewModel = viewModelWith(
      ApiClient(
        httpClient: MockClient((_) async => http.Response(progressJson(), 200)),
      ),
    );

    final loading = viewModel.load();
    expect(viewModel.state, isA<Loading<LearningProgress>>());
    await loading;

    final progress = (viewModel.state as Loaded<LearningProgress>).data;
    expect(progress.quizzesCompleted, 2);
    expect(progress.points, 90);
  });

  test('AC-002 no attempts is the empty state', () async {
    final viewModel = viewModelWith(
      fakeBackend({
        '/users/me/progress': {
          'totalQuizzesAttempted': 0,
          'totalQuizzesCompleted': 0,
          'totalPoints': 0,
          'accuracyPercentage': 0,
        },
      }),
    );

    await viewModel.load();

    expect(viewModel.state, isA<Empty<LearningProgress>>());
  });

  test('AC-002 a failure is the error state and load() recovers', () async {
    var online = false;
    final viewModel = viewModelWith(
      ApiClient(
        httpClient: MockClient((_) async {
          if (!online) {
            throw http.ClientException('offline');
          }
          return http.Response(progressJson(), 200);
        }),
      ),
    );

    await viewModel.load();
    expect(
      (viewModel.state as Failed<LearningProgress>).error,
      isA<ApiOfflineException>(),
    );

    online = true;
    await viewModel.load();
    expect(viewModel.state, isA<Loaded<LearningProgress>>());
  });

  test('AC-002 a newer load wins over a slower earlier one', () async {
    final first = Completer<http.Response>();
    var calls = 0;
    final viewModel = viewModelWith(
      ApiClient(
        httpClient: MockClient((_) async {
          calls++;
          return calls == 1
              ? first.future
              : http.Response(progressJson(points: 200), 200);
        }),
      ),
    );

    final slow = viewModel.load();
    await viewModel.load();
    first.complete(http.Response(progressJson(points: 10), 200));
    await slow;

    expect((viewModel.state as Loaded<LearningProgress>).data.points, 200);
  });
}
