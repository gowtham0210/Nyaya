import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

/// One completed quiz attempt, recorded for the Profile page's stats and
/// recent-activity list.
class QuizAttempt {
  const QuizAttempt({
    required this.topicTitle,
    required this.correctCount,
    required this.total,
    required this.completedAt,
  });

  final String topicTitle;
  final int correctCount;
  final int total;
  final DateTime completedAt;

  /// Fraction correct (0.0-1.0). Zero when [total] is zero, which never
  /// happens for a recorded attempt but keeps this getter total.
  double get scoreFraction => total == 0 ? 0 : correctCount / total;

  Map<String, Object?> toJson() => {
    'topicTitle': topicTitle,
    'correctCount': correctCount,
    'total': total,
    'completedAt': completedAt.toIso8601String(),
  };

  static QuizAttempt fromJson(Map<String, Object?> json) => QuizAttempt(
    topicTitle: json['topicTitle'] as String,
    correctCount: json['correctCount'] as int,
    total: json['total'] as int,
    completedAt: DateTime.parse(json['completedAt'] as String),
  );
}

/// Locally persisted history of every completed quiz attempt, newest first.
/// Powers the Profile page's stats and recent-activity list. Stands in
/// until a real progress-tracking backend exists.
class QuizHistoryStore {
  QuizHistoryStore._();

  static const _key = 'progress.quizHistory';

  /// Caps how many attempts are kept on device — recent activity only
  /// needs the last handful, and this bounds local storage growth.
  static const _maxStored = 50;

  static List<QuizAttempt> attempts = [];

  static Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_key) ?? [];
    attempts = raw
        .map(
          (entry) =>
              QuizAttempt.fromJson(jsonDecode(entry) as Map<String, Object?>),
        )
        .toList();
  }

  static Future<void> recordAttempt({
    required String topicTitle,
    required int correctCount,
    required int total,
  }) async {
    if (total <= 0) {
      return;
    }
    final attempt = QuizAttempt(
      topicTitle: topicTitle,
      correctCount: correctCount,
      total: total,
      completedAt: DateTime.now(),
    );
    attempts = [attempt, ...attempts].take(_maxStored).toList();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      _key,
      attempts.map((a) => jsonEncode(a.toJson())).toList(),
    );
  }

  static Future<void> clear() async {
    attempts = [];
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
