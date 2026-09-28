import '../../../core/network/api_client.dart';

/// A short question with its answer, for daily practice on Home.
class DailyQuestion {
  const DailyQuestion({
    required this.id,
    required this.category,
    required this.question,
    required this.answer,
  });

  final int id;
  final String category;
  final String question;
  final String answer;
}

/// Random daily questions from `GET /daily-questions/random`.
class DailyQuestionsRepository {
  DailyQuestionsRepository(this._client);

  final ApiClient _client;

  static const questionCount = 3;

  Future<List<DailyQuestion>> fetchDailyQuestions() async {
    final body = await _client.get(
      '/daily-questions/random',
      query: const {'count': '$questionCount'},
    );
    return [
      for (final item in body['items'] as List<dynamic>? ?? const [])
        DailyQuestion(
          id: item['id'] as int,
          category: item['category'] as String,
          question: item['question'] as String,
          answer: item['answer'] as String,
        ),
    ];
  }
}
