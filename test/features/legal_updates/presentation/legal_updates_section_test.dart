import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:nyaya/core/network/api_client.dart';
import 'package:nyaya/features/home/data/daily_questions_repository.dart';
import 'package:nyaya/features/home/presentation/daily_questions_view_model.dart';
import 'package:nyaya/features/home/presentation/home_page.dart';
import 'package:nyaya/features/home/presentation/home_view_model.dart';
import 'package:nyaya/features/legal_updates/data/legal_updates_repository.dart';
import 'package:nyaya/features/legal_updates/presentation/legal_updates_view_model.dart';

import '../../../support/fake_backend.dart';
import '../../../support/localized_app.dart';

Map<String, Object> update(
  int id,
  String title,
  String date, {
  String category = 'Judgements',
  String? source,
}) => {
  'id': id,
  'category': category,
  'title': title,
  'summary': 'Summary of $title.',
  'updateDate': date,
  'source': ?source,
};

final fourUpdates = {
  '/legal-updates': {
    'items': [
      update(1, 'Oldest', '2026-06-01'),
      update(2, 'Newest', '2026-09-20', source: 'Supreme Court of India'),
      update(3, 'Middle', '2026-08-15', category: 'Legislation'),
      update(4, 'Third', '2026-07-04', category: 'Custom'),
    ],
  },
};

void main() {
  late LegalUpdatesViewModel viewModel;

  Future<void> pumpHome(
    WidgetTester tester,
    ApiClient client, {
    Locale locale = const Locale('en'),
    VoidCallback? onViewAllLegalUpdatesPressed,
  }) async {
    viewModel = LegalUpdatesViewModel(
      repository: LegalUpdatesRepository(client),
    );
    addTearDown(viewModel.dispose);
    final dailyQuestions = DailyQuestionsViewModel(
      repository: DailyQuestionsRepository(
        fakeBackend({
          '/daily-questions/random': {'items': []},
        }),
      ),
    );
    addTearDown(dailyQuestions.dispose);
    await pumpLocalized(
      tester,
      HomePage(
        viewModel: const HomeViewModel(),
        dailyQuestions: dailyQuestions,
        legalUpdates: viewModel,
        onViewAllLegalUpdatesPressed: onViewAllLegalUpdatesPressed,
      ),
      locale: locale,
    );
  }

  Future<void> scrollToSection(WidgetTester tester) async {
    await tester.scrollUntilVisible(
      find.byKey(const ValueKey('home.legalUpdates')),
      300,
      scrollable: find
          .descendant(
            of: find.byKey(const ValueKey('home.scroll')),
            matching: find.byType(Scrollable),
          )
          .first,
    );
  }

  testWidgets(
    'AC-003 Home shows the 3 newest updates with category, date and source',
    (tester) async {
      await pumpHome(tester, fakeBackend(fourUpdates));
      await scrollToSection(tester);

      expect(find.text('Legal Updates'), findsOneWidget);
      expect(find.text('Newest'), findsOneWidget);
      expect(find.text('Middle'), findsOneWidget);
      expect(find.text('Third'), findsOneWidget);
      expect(find.text('Oldest'), findsNothing);
      expect(
        tester.getTopLeft(find.text('Newest')).dy,
        lessThan(tester.getTopLeft(find.text('Middle')).dy),
      );
      expect(find.text('Judgements'), findsOneWidget);
      expect(find.text('Legislation'), findsOneWidget);
      // Unknown categories show as sent.
      expect(find.text('Custom'), findsOneWidget);
      expect(find.text('Sep 20, 2026'), findsOneWidget);
      expect(find.text('Supreme Court of India'), findsOneWidget);
    },
  );

  testWidgets('AC-003 View All reports the tap', (tester) async {
    var taps = 0;
    await pumpHome(
      tester,
      fakeBackend(fourUpdates),
      onViewAllLegalUpdatesPressed: () => taps++,
    );
    await scrollToSection(tester);

    await tester.tap(
      find.byKey(const ValueKey('home.section.legalUpdates.viewAll')),
    );

    expect(taps, 1);
  });

  testWidgets('AC-004 no updates shows the empty state', (tester) async {
    await pumpHome(
      tester,
      fakeBackend({
        '/legal-updates': {'items': []},
      }),
    );
    await scrollToSection(tester);

    expect(find.text('No legal updates yet.'), findsOneWidget);
  });

  testWidgets(
    'AC-004 a failure shows Retry, keeps the rest of Home, and Retry reloads',
    (tester) async {
      var online = false;
      await pumpHome(
        tester,
        ApiClient(
          httpClient: MockClient((request) async {
            if (!online) {
              throw http.ClientException('offline');
            }
            return http.Response(
              '{"items":[{"id":1,"category":"Notices","title":"Back",'
              '"summary":"s","updateDate":"2026-09-01"}]}',
              200,
            );
          }),
        ),
      );

      expect(find.byKey(const ValueKey('home.hero')), findsOneWidget);
      await scrollToSection(tester);
      expect(
        find.text(
          "Can't reach the Nyaya server. Check your connection and try again.",
        ),
        findsOneWidget,
      );
      expect(find.text('Contract Act Quiz'), findsOneWidget);

      online = true;
      final retry = find.byKey(const ValueKey('loadState.retry'));
      await tester.ensureVisible(retry);
      await tester.pumpAndSettle();
      await tester.tap(retry);
      await tester.pumpAndSettle();

      expect(find.text('Back'), findsOneWidget);
    },
  );

  testWidgets('AC-004 the section shows a spinner while loading', (
    tester,
  ) async {
    await pumpHome(
      tester,
      ApiClient(
        httpClient: MockClient(
          (request) => Future<http.Response>.delayed(
            const Duration(seconds: 1),
            () => http.Response('{"items":[]}', 200),
          ),
        ),
      ),
    );

    await scrollToSection(tester);
    expect(find.byKey(const ValueKey('loadState.loading')), findsOneWidget);
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();
  });

  testWidgets('AC-007 categories and dates are localized in Hindi', (
    tester,
  ) async {
    await pumpHome(
      tester,
      fakeBackend(fourUpdates),
      locale: const Locale('hi'),
    );
    await scrollToSection(tester);

    expect(find.text('कानूनी अपडेट'), findsOneWidget);
    expect(find.text('न्यायादेश'), findsOneWidget);
    expect(find.text('Judgements'), findsNothing);
    expect(find.text('Sep 20, 2026'), findsNothing);
    expect(find.text('20 सित॰ 2026'), findsOneWidget);
  });
}
