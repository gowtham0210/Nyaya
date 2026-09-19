/// A daily question, matching the backend's `DailyQuestion` schema exactly
/// (see serializeDailyQuestion in nyaya_backend src/utils/serializers.js).
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

  factory DailyQuestion.fromJson(Map<String, dynamic> json) {
    return DailyQuestion(
      id: json['id'] as int,
      category: json['category'] as String,
      question: json['question'] as String,
      answer: json['answer'] as String,
    );
  }
}
