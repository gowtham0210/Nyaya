import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:nyaya/app/api_client.dart';
import 'package:nyaya/app/app_session.dart';
import 'package:nyaya/app/quiz_catalog.dart';
import 'package:nyaya/features/quiz_question/data/quiz_api.dart';
import 'package:nyaya/features/quiz_question/presentation/quiz_session_view_model.dart';

void main() {
  const bundled = [
    QuizQuestion(
      id: 'supreme-law',
      stem: 'What is the supreme law of India?',
      options: ['An Act of Parliament', 'The Constitution'],
      correctOption: 1,
      explanation: QuizExplanation(core: 'The Constitution is supreme.'),
    ),
  ];

  final quizPayload = {
    'page': 1,
    'size': 100,
    'total': 1,
    'items': [
      {
        'id': 9,
        'categoryId': 1,
        'slug': 'indian-constitution-quiz',
        'title': 'Indian Constitution Quiz',
        'difficulty': 'medium',
        'totalQuestions': 3,
      },
    ],
  };

  Map<String, Object?> questionsPayload(int count) => {
    'quizId': 9,
    'items': [
      for (var i = 0; i < count; i++)
        {
          'id': 100 + i,
          'questionText': 'Question ${i + 1}',
          'explanation': 'Because.',
          'options': [
            {'id': 200 + i * 2, 'optionText': 'A', 'displayOrder': 1},
            {'id': 201 + i * 2, 'optionText': 'B', 'displayOrder': 2},
          ],
        },
    ],
  };

  QuizCatalog catalogOn(MockClient client) => QuizCatalog(
    api: QuizApi(
      client: ApiClient(baseUrl: 'http://test/api/v1', httpClient: client),
    ),
  );

  Future<QuizLaunch> prepare(QuizCatalog catalog, {bool resume = false}) {
    return catalog.prepare(
      slug: 'indian-constitution-quiz',
      fallbackQuestions: bundled,
      fallbackTitle: 'Indian Constitution Quiz',
      resume: resume,
    );
  }

  setUp(() => AppSession.accessToken = 'test-token');
  tearDown(() => AppSession.accessToken = null);

  test('a signed-out user studies the bundled questions offline', () async {
    AppSession.accessToken = null;
    final catalog = catalogOn(
      MockClient((_) async => throw StateError('should not be called')),
    );

    final launch = await prepare(catalog);

    expect(launch.isOffline, isTrue);
    expect(launch.questions, same(bundled));
    expect(launch.buildSession().currentQuestion.correctOption, 1);
  });

  test('an unreachable server falls back to the bundled questions', () async {
    final catalog = catalogOn(
      MockClient((_) async => throw http.ClientException('offline')),
    );

    final launch = await prepare(catalog);

    expect(launch.isOffline, isTrue);
    expect(launch.questions, same(bundled));
  });

  test('a quiz missing from the catalogue falls back too', () async {
    final catalog = catalogOn(
      MockClient(
        (_) async => http.Response(
          jsonEncode({'page': 1, 'size': 100, 'total': 0, 'items': []}),
          200,
          headers: {'content-type': 'application/json'},
        ),
      ),
    );

    final launch = await prepare(catalog);

    expect(launch.isOffline, isTrue);
  });

  test('a reachable server starts an attempt over its own questions', () async {
    final requestedPaths = <String>[];
    final catalog = catalogOn(
      MockClient((request) async {
        requestedPaths.add(request.url.path);
        final body = switch (request.url.path) {
          '/api/v1/quizzes' => quizPayload,
          '/api/v1/quizzes/9/questions' => questionsPayload(3),
          _ => {
            'id': 55,
            'quizId': 9,
            'status': 'in_progress',
            'totalQuestions': 3,
            'answeredQuestions': 0,
            'correctAnswers': 0,
          },
        };
        return http.Response(
          jsonEncode(body),
          200,
          headers: {'content-type': 'application/json'},
        );
      }),
    );

    final launch = await prepare(catalog);

    expect(launch.isOffline, isFalse);
    expect(launch.attemptId, 55);
    expect(launch.startIndex, 0);
    expect(launch.questions, hasLength(3));
    expect(launch.questions.first.remoteId, 100);
    expect(requestedPaths, contains('/api/v1/quiz-attempts'));
  });

  test('resuming picks up at the first unanswered question', () async {
    var startedAttempt = false;
    final catalog = catalogOn(
      MockClient((request) async {
        Object body;
        switch (request.url.path) {
          case '/api/v1/quizzes':
            body = quizPayload;
          case '/api/v1/quizzes/9/questions':
            body = questionsPayload(3);
          case '/api/v1/quiz-attempts' when request.method == 'GET':
            body = {
              'page': 1,
              'size': 20,
              'total': 1,
              'items': [
                {
                  'id': 77,
                  'quizId': 9,
                  'status': 'in_progress',
                  'totalQuestions': 3,
                  'answeredQuestions': 2,
                  'correctAnswers': 1,
                },
              ],
            };
          default:
            startedAttempt = true;
            body = const <String, Object?>{};
        }
        return http.Response(
          jsonEncode(body),
          200,
          headers: {'content-type': 'application/json'},
        );
      }),
    );

    final launch = await prepare(catalog, resume: true);

    expect(launch.attemptId, 77);
    expect(launch.isResumed, isTrue);
    expect(launch.startIndex, 2);
    expect(startedAttempt, isFalse, reason: 'should reuse the open attempt');
    expect(launch.buildSession().counterLabel, 'Question 3 of 3');
  });

  test('a fully answered but unsubmitted attempt is not resumed', () async {
    final catalog = catalogOn(
      MockClient((request) async {
        Object body;
        switch (request.url.path) {
          case '/api/v1/quizzes':
            body = quizPayload;
          case '/api/v1/quizzes/9/questions':
            body = questionsPayload(3);
          case '/api/v1/quiz-attempts' when request.method == 'GET':
            body = {
              'page': 1,
              'size': 20,
              'total': 1,
              'items': [
                {
                  'id': 77,
                  'quizId': 9,
                  'status': 'in_progress',
                  'totalQuestions': 3,
                  'answeredQuestions': 3,
                  'correctAnswers': 2,
                },
              ],
            };
          default:
            body = {
              'id': 78,
              'quizId': 9,
              'status': 'in_progress',
              'totalQuestions': 3,
              'answeredQuestions': 0,
              'correctAnswers': 0,
            };
        }
        return http.Response(
          jsonEncode(body),
          200,
          headers: {'content-type': 'application/json'},
        );
      }),
    );

    final launch = await prepare(catalog, resume: true);

    expect(launch.attemptId, 78, reason: 'a fresh attempt should be started');
    expect(launch.startIndex, 0);
  });

  test(
    'prepareCustom: a signed-out user gets an empty, offline launch',
    () async {
      AppSession.accessToken = null;
      final catalog = catalogOn(
        MockClient((_) async => throw StateError('should not be called')),
      );

      final launch = await catalog.prepareCustom('medium');

      expect(launch.isOffline, isTrue);
      expect(launch.questions, isEmpty);
    },
  );

  test(
    'prepareCustom: an unreachable server also yields an empty, offline launch',
    () async {
      final catalog = catalogOn(
        MockClient((_) async => throw http.ClientException('offline')),
      );

      final launch = await catalog.prepareCustom('medium');

      expect(launch.isOffline, isTrue);
      expect(launch.questions, isEmpty);
    },
  );

  test(
    'prepareCustom: a reachable server starts an attempt over the drawn questions',
    () async {
      final catalog = catalogOn(
        MockClient(
          (request) async => http.Response(
            jsonEncode({
              'attempt': {
                'id': 61,
                'quizId': null,
                'status': 'in_progress',
                'totalQuestions': 2,
                'answeredQuestions': 0,
                'correctAnswers': 0,
              },
              'questions': [
                for (var i = 0; i < 2; i++)
                  {
                    'id': 300 + i,
                    'questionText': 'Question ${i + 1}',
                    'explanation': 'Because.',
                    'options': [
                      {'id': 400 + i * 2, 'optionText': 'A', 'displayOrder': 1},
                      {'id': 401 + i * 2, 'optionText': 'B', 'displayOrder': 2},
                    ],
                  },
              ],
            }),
            200,
            headers: {'content-type': 'application/json'},
          ),
        ),
      );

      final launch = await catalog.prepareCustom('medium');

      expect(launch.isOffline, isFalse);
      expect(launch.attemptId, 61);
      expect(launch.questions, hasLength(2));
      expect(launch.questions.first.remoteId, 300);
    },
  );
}
