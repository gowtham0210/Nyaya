import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:nyaya/core/network/api_client.dart';
import 'package:nyaya/features/home/data/daily_questions_repository.dart';

import '../../../support/daily_backend.dart';

/// Spec 045 AC-001.
void main() {
  late List<http.Request> requests;

  DailyQuestionsRepository repositoryReplying(Object body, {int status = 200}) {
    requests = [];
    return DailyQuestionsRepository(
      ApiClient(
        languageCode: () => 'hi',
        httpClient: MockClient((request) async {
          requests.add(request);
          return http.Response(jsonEncode(body), status);
        }),
      ),
    );
  }

  test('today, unanswered: the question and options, no key', () async {
    final today = await repositoryReplying(dailyToday()).fetchToday();

    expect(requests.single.url.path, '/api/v1/daily-questions/today');
    expect(requests.single.url.queryParameters, {'lang': 'hi'});
    final question = today.question!;
    expect(question.question, 'Which article protects the right to life?');
    expect(question.pointsReward, 10);
    expect(question.options.map((o) => (o.id, o.text)), [
      (11, 'Article 14'),
      (12, 'Article 21'),
      (13, 'Article 32'),
    ]);
    expect(today.answered, isFalse);
  });

  test('today, answered: the graded result', () async {
    final today = await repositoryReplying(
      dailyToday(selectedOptionId: 13),
    ).fetchToday();

    final result = today.result!;
    expect(result.selectedOptionId, 13);
    expect(result.correctOptionId, 12);
    expect(result.isCorrect, isFalse);
    expect(result.pointsEarned, 0);
    expect(result.explanation, startsWith('Article 21'));
  });

  test('no question today', () async {
    final today = await repositoryReplying(noDailyQuestion).fetchToday();

    expect(today.question, isNull);
    expect(today.result, isNull);
  });

  test('answer posts the option and returns the result', () async {
    final today = await repositoryReplying(
      dailyToday(selectedOptionId: 12),
      status: 201,
    ).answer(12);

    expect(requests.single.method, 'POST');
    expect(requests.single.url.path, '/api/v1/daily-questions/today/answer');
    expect(jsonDecode(requests.single.body), {'selectedOptionId': 12});
    expect(today.result!.isCorrect, isTrue);
    expect(today.result!.pointsEarned, 10);
  });
}
