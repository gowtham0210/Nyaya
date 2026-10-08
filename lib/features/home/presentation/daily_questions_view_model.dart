import 'package:flutter/foundation.dart';

import '../../../core/network/api_client.dart';
import '../../../core/presentation/load_state_notifier.dart';
import '../data/daily_questions_repository.dart';

export '../data/daily_questions_repository.dart'
    show DailyOption, DailyQuestion, DailyResult, DailyToday;

/// Home's daily question (spec 045): one a day, graded by the backend.
class DailyQuestionsViewModel extends LoadStateNotifier<DailyToday> {
  DailyQuestionsViewModel({
    required DailyQuestionsRepository repository,
    this.onAnswered,
  }) : _repository = repository;

  final DailyQuestionsRepository _repository;

  /// Runs after a graded answer, e.g. to refresh points and the streak.
  final VoidCallback? onAnswered;

  /// The option being sent, while its answer is in flight.
  int? get sending => _sending;
  int? _sending;

  @override
  Future<DailyToday> fetch() => _repository.fetchToday();

  @override
  bool isEmpty(DailyToday today) => today.question == null;

  /// Sends [optionId] as today's answer. Returns the result, or null when
  /// it failed (the question stays open) or was already answered (today
  /// reloads to show that answer).
  Future<DailyResult?> answer(int optionId) async {
    if (_sending != null) return null;
    _sending = optionId;
    notifyIfActive();
    try {
      final today = await _repository.answer(optionId);
      _sending = null;
      setData(today);
      onAnswered?.call();
      return today.result;
    } on ApiServerException catch (error) {
      _sending = null;
      notifyIfActive();
      // Answered on another device: show that answer.
      if (error.statusCode == 409) {
        await load();
        return null;
      }
      rethrow;
    } catch (_) {
      _sending = null;
      notifyIfActive();
      rethrow;
    }
  }
}
