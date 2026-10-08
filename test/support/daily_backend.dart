import 'dart:convert';

import 'package:http/http.dart' as http;

/// Today's daily question as the backend sends it (spec 045). Options 11,
/// 12 and 13; 12 is right and earns 10 points.
Map<String, Object?> dailyToday({int? selectedOptionId, String? category}) => {
  'date': '2026-10-06',
  'answered': selectedOptionId != null,
  'question': {
    'id': 1,
    'category': category ?? 'Constitutional Law',
    'question': 'Which article protects the right to life?',
    'pointsReward': 10,
    'options': [
      {'id': 11, 'optionText': 'Article 14'},
      {'id': 12, 'optionText': 'Article 21'},
      {'id': 13, 'optionText': 'Article 32'},
    ],
  },
  'result': selectedOptionId == null
      ? null
      : {
          'selectedOptionId': selectedOptionId,
          'correctOptionId': 12,
          'isCorrect': selectedOptionId == 12,
          'pointsEarned': selectedOptionId == 12 ? 10 : 0,
          'explanation': 'Article 21 protects life and personal liberty.',
        },
};

/// A day with no question scheduled.
const noDailyQuestion = {
  'date': '2026-10-06',
  'answered': false,
  'question': null,
  'result': null,
};

/// Routes for today's question; answering grades the posted option.
/// [answers] records each posted option; [answerResponse] overrides the
/// reply (e.g. a 409 or 500).
Map<String, Object> dailyRoutes({
  List<int>? answers,
  http.Response? answerResponse,
  int? answeredWith,
}) => {
  '/daily-questions/today': (http.Request _) =>
      dailyToday(selectedOptionId: answeredWith),
  'POST /daily-questions/today/answer': (http.Request request) {
    final option =
        (jsonDecode(request.body) as Map<String, dynamic>)['selectedOptionId']
            as int;
    answers?.add(option);
    if (answerResponse != null) return answerResponse;
    answeredWith = option;
    return http.Response(
      jsonEncode({
        ...dailyToday(selectedOptionId: option),
        'totalPoints': 65,
        'currentStreak': 2,
        'unlockedAchievements': [],
      }),
      201,
      headers: const {'content-type': 'application/json; charset=utf-8'},
    );
  },
};
