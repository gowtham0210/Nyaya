import 'dart:convert';

import 'package:http/http.dart' as http;

/// Fake backend routes for a topic (category 3) with three quizzes and a
/// two-question quiz to play (spec 038). Quiz 11 is completed, 12 is in
/// progress, 13 is new. Option 102 is right for question 1, 202 for 2.
Map<String, Object> quizRoutes({
  List<Map<String, Object?>>? attempts,
  Object? categoryQuizzes,
  List<String>? answers,
  List<String>? submits,
  bool lockLast = false,
}) => {
  '/categories/3/quizzes':
      categoryQuizzes ??
      {
        'items': [
          // Newest first, as the backend sends them.
          _quiz(13, 'Bail: When & How', 'hard', 14, locked: lockLast),
          _quiz(12, 'Arrest & Your Rights', 'medium', 12),
          _quiz(11, 'FIR Basics', 'easy', 10),
        ],
      },
  '/quiz-attempts': {
    'items':
        attempts ??
        [
          {'id': 7, 'quizId': 12, 'status': 'in_progress'},
          {'id': 6, 'quizId': 11, 'status': 'submitted'},
          {'id': 5, 'quizId': 12, 'status': 'in_progress'},
        ],
  },
  '/quizzes/12': {'id': 12, 'categoryId': 3, 'title': 'Arrest & Your Rights'},
  '/quizzes/12/questions': {
    'quizId': 12,
    'items': [
      _question(1, 'Who files an FIR?', [101, 102], 'Anyone can file one.'),
      _question(2, 'Is a Zero FIR valid?', [201, 202], 'Yes, anywhere.'),
    ],
  },
  'POST /quiz-attempts': {'id': 99, 'quizId': 12, 'status': 'in_progress'},
  '/quiz-attempts/99/answers': (http.Request request) {
    answers?.add(request.body);
    final body = jsonDecode(request.body) as Map<String, dynamic>;
    final right = {1: 102, 2: 202}[body['questionId']];
    return {'isCorrect': body['selectedOptionId'] == right};
  },
  '/quiz-attempts/99/submit': (http.Request request) {
    submits?.add(request.url.path);
    return {
      'attempt': {'id': 99, 'status': 'submitted'},
    };
  },
};

Map<String, Object?> _quiz(
  int id,
  String title,
  String difficulty,
  int questions, {
  bool locked = false,
}) => {
  'id': id,
  'categoryId': 3,
  'title': title,
  'difficulty': difficulty,
  'totalQuestions': questions,
  'isLocked': locked,
  'requiredPoints': locked ? 200 : null,
};

Map<String, Object?> _question(
  int id,
  String text,
  List<int> optionIds,
  String explanation,
) => {
  'id': id,
  'questionText': text,
  'explanation': explanation,
  'options': [
    for (final optionId in optionIds)
      {'id': optionId, 'optionText': 'Option $optionId'},
  ],
};
