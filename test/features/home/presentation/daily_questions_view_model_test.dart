import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:nyaya/core/network/api_client.dart';
import 'package:nyaya/core/presentation/load_state.dart';
import 'package:nyaya/features/home/data/daily_questions_repository.dart';
import 'package:nyaya/features/home/presentation/daily_questions_view_model.dart';

import '../../../support/daily_backend.dart';
import '../../../support/fake_backend.dart';

/// Spec 045 AC-002 (plus 018's load states).
void main() {
  late int answeredCalls;

  DailyQuestionsViewModel viewModelWith(Map<String, Object> routes) {
    answeredCalls = 0;
    final viewModel = DailyQuestionsViewModel(
      repository: DailyQuestionsRepository(fakeBackend(routes)),
      onAnswered: () => answeredCalls++,
    );
    addTearDown(viewModel.dispose);
    return viewModel;
  }

  DailyToday loaded(DailyQuestionsViewModel viewModel) =>
      (viewModel.state as Loaded<DailyToday>).data;

  test('loads today; no question is the empty state', () async {
    final viewModel = viewModelWith(dailyRoutes());
    expect(viewModel.state, isA<Loading<DailyToday>>());
    await viewModel.load();
    expect(loaded(viewModel).question!.options, hasLength(3));

    final empty = viewModelWith({'/daily-questions/today': noDailyQuestion});
    await empty.load();
    expect(empty.state, isA<Empty<DailyToday>>());
  });

  test('a failed load is the error state; load() recovers', () async {
    final routes = <String, Object>{
      '/daily-questions/today': http.Response('{"message":"down"}', 500),
    };
    final viewModel = viewModelWith(routes);
    await viewModel.load();
    expect(viewModel.state, isA<Failed<DailyToday>>());

    routes.addAll(dailyRoutes());
    await viewModel.load();
    expect(viewModel.state, isA<Loaded<DailyToday>>());
  });

  test('answering grades in place and runs onAnswered once', () async {
    final answers = <int>[];
    final viewModel = viewModelWith(dailyRoutes(answers: answers));
    await viewModel.load();

    final pending = viewModel.answer(13);
    expect(viewModel.sending, 13);
    // A second tap while the first is in flight is ignored.
    expect(await viewModel.answer(12), isNull);
    final result = await pending;

    expect(answers, [13]);
    expect(result!.isCorrect, isFalse);
    expect(loaded(viewModel).result!.correctOptionId, 12);
    expect(viewModel.sending, isNull);
    expect(answeredCalls, 1);
  });

  test('a failed answer keeps the question open and reports it', () async {
    final viewModel = viewModelWith(
      dailyRoutes(answerResponse: http.Response('{"message":"x"}', 500)),
    );
    await viewModel.load();

    await expectLater(viewModel.answer(12), throwsA(isA<ApiException>()));
    expect(loaded(viewModel).answered, isFalse);
    expect(viewModel.sending, isNull);
    expect(answeredCalls, 0);
  });

  test('already answered elsewhere (409) reloads to show it', () async {
    final routes = dailyRoutes(
      answerResponse: http.Response('{"message":"already"}', 409),
    );
    final viewModel = viewModelWith(routes);
    await viewModel.load();
    routes['/daily-questions/today'] = dailyToday(selectedOptionId: 11);

    expect(await viewModel.answer(12), isNull);

    expect(loaded(viewModel).result!.selectedOptionId, 11);
    expect(answeredCalls, 0);
  });
}
