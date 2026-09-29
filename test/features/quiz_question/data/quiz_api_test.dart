import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:nyaya/app/api_client.dart';
import 'package:nyaya/features/quiz_question/data/quiz_api.dart';
import 'package:nyaya/features/quiz_question/presentation/quiz_session_view_model.dart';

void main() {
  QuizApi apiReturning(Map<String, Object?> Function(http.Request) handler) {
    return QuizApi(
      client: ApiClient(
        baseUrl: 'http://test/api/v1',
        httpClient: MockClient(
          (request) async => http.Response(
            jsonEncode(handler(request)),
            200,
            headers: {'content-type': 'application/json'},
          ),
        ),
      ),
    );
  }

  Map<String, Object?> playableQuestion({required String explanation}) => {
    'id': 42,
    'questionText': 'What is the supreme law of India?',
    'explanation': explanation,
    'options': [
      {'id': 101, 'optionText': 'An Act of Parliament', 'displayOrder': 1},
      {'id': 102, 'optionText': 'The Constitution', 'displayOrder': 2},
    ],
  };

  test(
    'questions arrive without an answer key and carry their backend ids',
    () async {
      final api = apiReturning(
        (_) => {
          'quizId': 1,
          'items': [
            playableQuestion(
              explanation: jsonEncode({
                'core': 'The Constitution is supreme.',
                'reference': 'Article 13',
                'takeaway': 'Everything else bends to it.',
              }),
            ),
          ],
        },
      );

      final questions = await api.fetchQuestions(1);

      expect(questions, hasLength(1));
      final question = questions.single;
      expect(question.remoteId, 42);
      expect(question.optionIds, [101, 102]);
      expect(question.options, ['An Act of Parliament', 'The Constitution']);
      // Nothing in the payload says which option is right.
      expect(question.correctOption, -1);
      expect(question.explanation.core, 'The Constitution is supreme.');
      expect(question.explanation.reference, 'Article 13');
      expect(question.explanation.takeaway, 'Everything else bends to it.');
    },
  );

  test('an explanation that is not JSON is read as plain body text', () async {
    final api = apiReturning(
      (_) => {
        'quizId': 1,
        'items': [playableQuestion(explanation: 'Just a sentence.')],
      },
    );

    final questions = await api.fetchQuestions(1);

    expect(questions.single.explanation.core, 'Just a sentence.');
    expect(questions.single.explanation.reference, isNull);
  });

  test(
    'submitting an answer maps the correct option id back to its index',
    () async {
      late http.Request captured;
      final api = apiReturning((request) {
        if (request.url.path.endsWith('/questions')) {
          return {
            'quizId': 1,
            'items': [playableQuestion(explanation: 'Because it is.')],
          };
        }
        captured = request;
        return {
          'id': 7,
          'quizAttemptId': 3,
          'userId': 1,
          'questionId': 42,
          'selectedOptionId': 101,
          'isCorrect': false,
          'pointsEarned': 0,
          'answeredAt': '2026-01-01T00:00:00.000Z',
          'createdAt': '2026-01-01T00:00:00.000Z',
          'correctOptionId': 102,
        };
      });
      final question = (await api.fetchQuestions(1)).single;

      final verdict = await api.submitAnswer(
        attemptId: 3,
        question: question,
        optionIndex: 0,
      );

      expect(verdict.isCorrect, isFalse);
      // Option id 102 is the second option, so the card highlights index 1.
      expect(verdict.correctOption, 1);
      expect(captured.url.path, '/api/v1/quiz-attempts/3/answers');
      expect(jsonDecode(captured.body), containsPair('selectedOptionId', 101));
    },
  );

  test('a correct answer marks the picked option correct even without '
      'correctOptionId, as the real backend replies', () async {
    final api = apiReturning((request) {
      if (request.url.path.endsWith('/questions')) {
        return {
          'quizId': 1,
          'items': [playableQuestion(explanation: 'Because it is.')],
        };
      }
      // The answer endpoint's actual shape: a serialized question attempt,
      // with no `correctOptionId`.
      return {
        'id': 7,
        'quizAttemptId': 3,
        'userId': 1,
        'questionId': 42,
        'selectedOptionId': 102,
        'isCorrect': true,
        'pointsEarned': 10,
        'answeredAt': '2026-01-01T00:00:00.000Z',
      };
    });
    final question = (await api.fetchQuestions(1)).single;

    final verdict = await api.submitAnswer(
      attemptId: 3,
      question: question,
      optionIndex: 1,
    );

    expect(verdict.isCorrect, isTrue);
    // Was -1, which drew the right pick in red.
    expect(verdict.correctOption, 1);
  });

  test('a bundled question cannot be submitted to an attempt', () async {
    final api = apiReturning((_) => const {});

    expect(
      () => api.submitAnswer(
        attemptId: 3,
        // A bundled question carries no backend ids, so there is nothing to
        // post it against.
        question: const QuizQuestion(
          id: 'supreme-law',
          stem: 'What is the supreme law of India?',
          options: ['An Act of Parliament', 'The Constitution'],
          correctOption: 1,
          explanation: QuizExplanation(core: 'The Constitution is supreme.'),
        ),
        optionIndex: 0,
      ),
      throwsA(isA<ApiException>()),
    );
  });

  test('fetchPracticeSettings parses the enabled difficulties', () async {
    final api = apiReturning(
      (_) => {
        'items': [
          {'difficulty': 'easy', 'questionCount': 10},
          {'difficulty': 'medium', 'questionCount': 10},
        ],
      },
    );

    final settings = await api.fetchPracticeSettings();

    expect(settings, hasLength(2));
    expect(settings.first.difficulty, 'easy');
    expect(settings.first.questionCount, 10);
  });

  test(
    'startCustomAttempt returns a null-quizId attempt and its questions',
    () async {
      final api = apiReturning(
        (_) => {
          'attempt': {
            'id': 99,
            'quizId': null,
            'status': 'in_progress',
            'totalQuestions': 1,
            'answeredQuestions': 0,
            'correctAnswers': 0,
          },
          'questions': [playableQuestion(explanation: 'Because.')],
        },
      );

      final result = await api.startCustomAttempt('medium');

      expect(result.attempt.id, 99);
      expect(result.attempt.quizId, isNull);
      expect(result.questions, hasLength(1));
      expect(result.questions.single.remoteId, 42);
    },
  );
}
