import '../../../core/network/api_client.dart';

/// One choice in today's question.
class DailyOption {
  const DailyOption({required this.id, required this.text});

  final int id;
  final String text;
}

/// Today's question (spec 045). The answer key isn't sent until it's
/// answered.
class DailyQuestion {
  const DailyQuestion({
    required this.id,
    required this.category,
    required this.question,
    required this.pointsReward,
    required this.options,
  });

  final int id;
  final String category;
  final String question;
  final int pointsReward;
  final List<DailyOption> options;
}

/// The graded answer, once the learner has answered today.
class DailyResult {
  const DailyResult({
    required this.selectedOptionId,
    required this.correctOptionId,
    required this.isCorrect,
    required this.pointsEarned,
    required this.explanation,
  });

  final int? selectedOptionId;
  final int? correctOptionId;
  final bool isCorrect;
  final int pointsEarned;
  final String explanation;
}

/// Today: the question (null when there's none) and the result (null until
/// answered).
class DailyToday {
  const DailyToday({required this.question, required this.result});

  final DailyQuestion? question;
  final DailyResult? result;

  bool get answered => result != null;
}

/// Today's question from `GET /daily-questions/today`, answered once with
/// `POST /daily-questions/today/answer` (backend 430886e).
class DailyQuestionsRepository {
  DailyQuestionsRepository(this._client);

  final ApiClient _client;

  Future<DailyToday> fetchToday() async =>
      _today(await _client.get('/daily-questions/today'));

  /// Grades [optionId]. A second answer the same day fails with 409.
  Future<DailyToday> answer(int optionId) async => _today(
    await _client.post(
      '/daily-questions/today/answer',
      body: {'selectedOptionId': optionId},
    ),
  );

  static DailyToday _today(Map<String, dynamic> body) {
    final question = body['question'] as Map<String, dynamic>?;
    final result = body['result'] as Map<String, dynamic>?;
    return DailyToday(
      question: question == null
          ? null
          : DailyQuestion(
              id: _int(question['id'])!,
              category: question['category'] as String? ?? '',
              question: question['question'] as String,
              pointsReward: _int(question['pointsReward']) ?? 0,
              options: [
                for (final option in question['options'] as List<dynamic>)
                  DailyOption(
                    id: _int(option['id'])!,
                    text: option['optionText'] as String,
                  ),
              ],
            ),
      result: result == null
          ? null
          : DailyResult(
              selectedOptionId: _int(result['selectedOptionId']),
              correctOptionId: _int(result['correctOptionId']),
              isCorrect: result['isCorrect'] as bool? ?? false,
              pointsEarned: _int(result['pointsEarned']) ?? 0,
              explanation: result['explanation'] as String? ?? '',
            ),
    );
  }

  static int? _int(Object? value) => (value as num?)?.toInt();
}
