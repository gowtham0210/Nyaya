import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:nyaya/app/api_client.dart';
import 'package:nyaya/app/user_api.dart';
import 'package:nyaya/features/leaderboard/presentation/leaderboard_page.dart';
import 'package:nyaya/features/leaderboard/presentation/leaderboard_view_model.dart';

void main() {
  final viewModel = LeaderboardViewModel(
    currentUserName: 'Test User',
    attempts: const [],
  );

  http.Response ok(Object body) => http.Response(
    jsonEncode(body),
    200,
    headers: {'content-type': 'application/json'},
  );

  /// A backend whose weekly/monthly boards are empty unless [entries] says
  /// otherwise.
  UserApi fakeUserApi({List<Map<String, Object?>> entries = const []}) {
    return UserApi(
      client: ApiClient(
        httpClient: MockClient((request) async {
          if (request.url.path.startsWith('/api/v1/leaderboards/')) {
            return ok({'items': entries});
          }
          return http.Response('{"message":"not found"}', 404);
        }),
      ),
    );
  }

  Future<void> pumpPage(
    WidgetTester tester, {
    VoidCallback? onBackPressed,
    ValueChanged<int>? onNavigationSelected,
    UserApi? userApi,
  }) async {
    tester.view.physicalSize = const Size(393, 1600);
    tester.view.devicePixelRatio = 1;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      MaterialApp(
        home: LeaderboardPage(
          viewModel: viewModel,
          onBackPressed: onBackPressed,
          onNavigationSelected: onNavigationSelected,
          userApi: userApi ?? fakeUserApi(),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('shows the banner, a podium of three and ranked rows', (
    tester,
  ) async {
    await pumpPage(tester);

    expect(find.byKey(const ValueKey('leaderboard.banner')), findsOneWidget);
    for (final rank in [1, 2, 3]) {
      expect(find.byKey(ValueKey('leaderboard.podium.$rank')), findsOneWidget);
    }
    expect(find.byKey(const ValueKey('leaderboard.row.4')), findsOneWidget);
    // The offline sample ranking says so.
    expect(
      find.byKey(const ValueKey('leaderboard.sampleNote')),
      findsOneWidget,
    );
  });

  testWidgets('marks the current user in the ranking', (tester) async {
    await pumpPage(tester);

    final self = viewModel.entries.singleWhere((e) => e.isCurrentUser);
    final row = find.byKey(ValueKey('leaderboard.row.${self.rank}'));
    await tester.ensureVisible(row);
    await tester.pumpAndSettle();

    expect(
      find.descendant(of: row, matching: find.text('YOU')),
      findsOneWidget,
    );
  });

  testWidgets(
    'Weekly fetches the live board and renders its podium and rows',
    (tester) async {
      await pumpPage(
        tester,
        userApi: fakeUserApi(
          entries: [
            for (var rank = 1; rank <= 4; rank++)
              {
                'rank': rank,
                'userId': rank,
                'fullName': 'Learner $rank',
                'totalPoints': 100 - rank,
              },
          ],
        ),
      );

      await tester.tap(find.byKey(const ValueKey('leaderboard.tab.weekly')));
      await tester.pumpAndSettle();

      expect(find.byKey(const ValueKey('leaderboard.podium.1')), findsOneWidget);
      expect(find.byKey(const ValueKey('leaderboard.podium.2')), findsOneWidget);
      expect(find.byKey(const ValueKey('leaderboard.podium.3')), findsOneWidget);
      expect(find.byKey(const ValueKey('leaderboard.row.4')), findsOneWidget);
      // Weekly is live data, not the offline sample list.
      expect(
        find.byKey(const ValueKey('leaderboard.sampleNote')),
        findsNothing,
      );
    },
  );

  testWidgets(
    'Weekly with no activity offers a way back to Top Learners',
    (tester) async {
      await pumpPage(tester); // fakeUserApi() defaults to an empty board

      await tester.tap(find.byKey(const ValueKey('leaderboard.tab.weekly')));
      await tester.pumpAndSettle();

      expect(find.byKey(const ValueKey('leaderboard.empty')), findsOneWidget);
      expect(find.byKey(const ValueKey('leaderboard.podium.1')), findsNothing);

      await tester.tap(find.text('View Top Learners'));
      await tester.pumpAndSettle();

      expect(find.byKey(const ValueKey('leaderboard.podium.1')), findsOneWidget);
    },
  );

  testWidgets(
    'Monthly surfaces a backend failure with a retry that recovers',
    (tester) async {
      var shouldFail = true;
      await pumpPage(
        tester,
        userApi: UserApi(
          client: ApiClient(
            httpClient: MockClient((request) async {
              if (shouldFail) {
                return http.Response('{"message":"down"}', 500);
              }
              return ok({
                'items': [
                  {
                    'rank': 1,
                    'userId': 1,
                    'fullName': 'Learner 1',
                    'totalPoints': 50,
                  },
                ],
              });
            }),
          ),
        ),
      );

      await tester.tap(find.byKey(const ValueKey('leaderboard.tab.monthly')));
      await tester.pumpAndSettle();

      expect(find.text("Couldn't load the Monthly ranking."), findsOneWidget);

      shouldFail = false;
      await tester.tap(find.text('Try again'));
      await tester.pumpAndSettle();

      expect(find.byKey(const ValueKey('leaderboard.row.1')), findsOneWidget);
    },
  );

  testWidgets('tapping the back button reports it', (tester) async {
    var backPressed = false;
    await pumpPage(tester, onBackPressed: () => backPressed = true);

    await tester.tap(find.byKey(const ValueKey('leaderboard.back')));
    await tester.pumpAndSettle();

    expect(backPressed, isTrue);
  });

  testWidgets('tapping a bottom nav tab reports its index', (tester) async {
    int? selectedIndex;
    await pumpPage(
      tester,
      onNavigationSelected: (index) => selectedIndex = index,
    );

    await tester.tap(find.byKey(const ValueKey('home.nav.home')));
    await tester.pumpAndSettle();

    expect(selectedIndex, 0);
  });
}
