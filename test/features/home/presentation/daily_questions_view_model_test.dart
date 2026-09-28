import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:nyaya/core/network/api_client.dart';
import 'package:nyaya/core/presentation/load_state.dart';
import 'package:nyaya/features/home/data/daily_questions_repository.dart';
import 'package:nyaya/features/home/presentation/daily_questions_view_model.dart';

import '../../../support/fake_backend.dart';

const twoQuestions = {
  'items': [
    {
      'id': 1,
      'category': 'Constitutional Law',
      'question': 'Which article protects the right to life?',
      'answer': 'Article 21.',
    },
    {
      'id': 2,
      'category': 'Criminal Law',
      'question': 'What replaced the IPC in 2024?',
      'answer': 'The Bharatiya Nyaya Sanhita.',
    },
  ],
};

DailyQuestionsViewModel viewModelWith(ApiClient client) =>
    DailyQuestionsViewModel(repository: DailyQuestionsRepository(client));

void main() {
  test('AC-002 loading then loaded with the questions', () async {
    final viewModel = viewModelWith(
      fakeBackend({'/daily-questions/random': twoQuestions}),
    );

    final loading = viewModel.load();
    expect(viewModel.state, isA<Loading<List<DailyQuestion>>>());
    await loading;

    final questions = (viewModel.state as Loaded<List<DailyQuestion>>).data;
    expect(questions.map((q) => q.question), [
      'Which article protects the right to life?',
      'What replaced the IPC in 2024?',
    ]);
  });

  test('AC-002 no questions is the empty state', () async {
    final viewModel = viewModelWith(
      fakeBackend({
        '/daily-questions/random': {'items': []},
      }),
    );

    await viewModel.load();

    expect(viewModel.state, isA<Empty<List<DailyQuestion>>>());
  });

  test('AC-002 a failure is the error state and load() recovers', () async {
    var online = false;
    final viewModel = viewModelWith(
      ApiClient(
        httpClient: MockClient((request) async {
          if (!online) {
            throw http.ClientException('offline');
          }
          return http.Response(
            '{"items":[{"id":1,"category":"Civil Law",'
            '"question":"Q?","answer":"A."}]}',
            200,
          );
        }),
      ),
    );

    await viewModel.load();
    final failed = viewModel.state as Failed<List<DailyQuestion>>;
    expect(failed.error, isA<ApiOfflineException>());

    online = true;
    await viewModel.load();
    expect(viewModel.state, isA<Loaded<List<DailyQuestion>>>());
  });

  test('AC-002 an unreadable response is the error state', () async {
    final viewModel = viewModelWith(
      fakeBackend({
        '/daily-questions/random': {
          'items': [
            {'id': 1, 'category': 'Civil Law', 'question': null},
          ],
        },
      }),
    );

    await viewModel.load();

    expect(viewModel.state, isA<Failed<List<DailyQuestion>>>());
  });

  test('AC-002 a newer load wins over a slower earlier one', () async {
    final firstResponse = Completer<http.Response>();
    var calls = 0;
    final viewModel = viewModelWith(
      ApiClient(
        httpClient: MockClient((request) async {
          calls++;
          if (calls == 1) {
            return firstResponse.future;
          }
          return http.Response(
            '{"items":[{"id":2,"category":"C","question":"New?","answer":"A."}]}',
            200,
          );
        }),
      ),
    );

    final slow = viewModel.load();
    await viewModel.load();
    firstResponse.complete(
      http.Response(
        '{"items":[{"id":1,"category":"C","question":"Old?","answer":"A."}]}',
        200,
      ),
    );
    await slow;

    final questions = (viewModel.state as Loaded<List<DailyQuestion>>).data;
    expect(questions.single.question, 'New?');
  });

  test(
    'AC-003 toggling reveals then hides an answer; reload hides all',
    () async {
      final viewModel = viewModelWith(
        fakeBackend({'/daily-questions/random': twoQuestions}),
      );
      await viewModel.load();

      expect(viewModel.isRevealed(1), isFalse);
      viewModel.toggleAnswer(1);
      expect(viewModel.isRevealed(1), isTrue);
      expect(viewModel.isRevealed(2), isFalse);
      viewModel.toggleAnswer(1);
      expect(viewModel.isRevealed(1), isFalse);

      viewModel
        ..toggleAnswer(1)
        ..toggleAnswer(2);
      await viewModel.load();
      expect(viewModel.isRevealed(1), isFalse);
      expect(viewModel.isRevealed(2), isFalse);
    },
  );
}
