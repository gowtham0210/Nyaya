import '../models/daily_question.dart';
import '../services/api_exceptions.dart';
import '../services/auth_storage.dart';
import '../services/daily_questions_api_service.dart';

/// The single source of truth for the Home screen's "Daily Questions"
/// section, backed entirely by GET /api/v1/daily-questions/random. Never
/// returns invented data — callers get real questions or a thrown
/// exception.
class DailyQuestionsRepository {
  DailyQuestionsRepository({DailyQuestionsApiService? api, AuthStorage? authStorage})
      : _api = api ?? DailyQuestionsApiService(),
        _authStorage = authStorage ?? AuthStorage();

  final DailyQuestionsApiService _api;
  final AuthStorage _authStorage;

  /// Throws [UnauthenticatedException] if there's no session, or
  /// [ApiException]/[NetworkException] if the request fails.
  Future<List<DailyQuestion>> getRandom({int count = 2}) async {
    final token = await _authStorage.readToken();
    if (token == null) {
      throw UnauthenticatedException();
    }
    return _api.fetchRandom(token, count: count);
  }
}
