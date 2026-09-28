import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:nyaya/core/network/api_client.dart';
import 'package:nyaya/features/home/data/daily_questions_repository.dart';

void main() {
  test(
    'AC-001 requests 3 questions in the current language and maps them',
    () async {
      late Uri requested;
      final repository = DailyQuestionsRepository(
        ApiClient(
          languageCode: () => 'hi',
          httpClient: MockClient((request) async {
            requested = request.url;
            return http.Response(
              jsonEncode({
                'items': [
                  {
                    'id': 7,
                    'category': 'संविधान',
                    'question': 'अनुच्छेद 21 क्या है?',
                    'answer': 'जीवन का अधिकार।',
                  },
                ],
              }),
              200,
              headers: const {
                'content-type': 'application/json; charset=utf-8',
              },
            );
          }),
        ),
      );

      final questions = await repository.fetchDailyQuestions();

      expect(requested.path, '/api/v1/daily-questions/random');
      expect(requested.queryParameters, {'count': '3', 'lang': 'hi'});
      expect(questions, hasLength(1));
      expect(questions.single.id, 7);
      expect(questions.single.category, 'संविधान');
      expect(questions.single.question, 'अनुच्छेद 21 क्या है?');
      expect(questions.single.answer, 'जीवन का अधिकार।');
    },
  );
}
