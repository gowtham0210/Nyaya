import '../../../core/network/api_client.dart';
import '../presentation/quiz_session_view_model.dart';

/// Plays a backend quiz (spec 038): questions from
/// `GET /quizzes/:id/questions`, then an attempt at `POST /quiz-attempts`
/// that records each answer and is submitted at the end. Submitting is what
/// moves the learner's progress on Home and Profile.
class QuizPlayRepository {
  QuizPlayRepository(this._client);

  final ApiClient _client;

  Future<List<QuizQuestion>> fetchQuestions(int quizId) async {
    final body = await _client.get('/quizzes/$quizId/questions');
    return [
      for (final item in body['items'] as List<dynamic>? ?? const [])
        if (item is Map<String, dynamic>) _question(item),
    ];
  }

  /// Starts an attempt and returns its id.
  Future<int> startAttempt(int quizId) async {
    final body = await _client.post('/quiz-attempts', body: {'quizId': quizId});
    return (body['id'] as num).toInt();
  }

  /// Records one answer; true when it was right.
  Future<bool> answer({
    required int attemptId,
    required int questionId,
    required int optionId,
  }) async {
    final body = await _client.post(
      '/quiz-attempts/$attemptId/answers',
      body: {'questionId': questionId, 'selectedOptionId': optionId},
    );
    return body['isCorrect'] == true;
  }

  Future<void> submit(int attemptId) =>
      _client.post('/quiz-attempts/$attemptId/submit');

  QuizQuestion _question(Map<String, dynamic> json) {
    final options = [
      for (final option in json['options'] as List<dynamic>? ?? const [])
        if (option is Map<String, dynamic>) option,
    ];
    final explanation = (json['explanation'] as String?)?.trim();
    return QuizQuestion(
      id: '${json['id']}',
      stem: json['questionText'] as String? ?? '',
      options: [for (final o in options) o['optionText'] as String? ?? ''],
      optionIds: [for (final o in options) (o['id'] as num).toInt()],
      explanation: QuizExplanation(core: explanation ?? ''),
    );
  }
}
