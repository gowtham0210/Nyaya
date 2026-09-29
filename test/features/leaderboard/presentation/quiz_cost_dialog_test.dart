import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nyaya/app/leaderboard_progress_store.dart';
import 'package:nyaya/features/leaderboard/presentation/journey_widgets.dart';

void main() {
  Future<bool?> openDialog(WidgetTester tester, {required int credits}) async {
    LeaderboardProgressStore.credits = credits;
    bool? result;
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => TextButton(
            onPressed: () async => result = await showQuizCostDialog(
              context,
              title: 'Constitutional Law Quiz',
              subtitle: 'Constitutional Law',
            ),
            child: const Text('open'),
          ),
        ),
      ),
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    return result;
  }

  testWidgets('with enough credits, Start confirms the spend', (tester) async {
    bool? result;
    LeaderboardProgressStore.credits = 60;
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => TextButton(
            onPressed: () async => result = await showQuizCostDialog(
              context,
              title: 'Constitutional Law Quiz',
              subtitle: 'Constitutional Law',
            ),
            child: const Text('open'),
          ),
        ),
      ),
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    expect(
      find.textContaining(
        "you'll have ${60 - LeaderboardProgressStore.quizCost} left",
      ),
      findsOneWidget,
    );

    await tester.tap(find.byKey(const ValueKey('quizCost.start')));
    await tester.pumpAndSettle();

    expect(result, isTrue);
  });

  testWidgets('without enough credits, Start is disabled', (tester) async {
    await openDialog(tester, credits: LeaderboardProgressStore.quizCost - 1);

    final start = tester.widget<ElevatedButton>(
      find.byKey(const ValueKey('quizCost.start')),
    );
    expect(start.onPressed, isNull);
  });

  testWidgets('Maybe later declines', (tester) async {
    bool? result;
    LeaderboardProgressStore.credits = 100;
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => TextButton(
            onPressed: () async => result = await showQuizCostDialog(
              context,
              title: 'Quiz',
              subtitle: 'Category',
            ),
            child: const Text('open'),
          ),
        ),
      ),
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('quizCost.cancel')));
    await tester.pumpAndSettle();

    expect(result, isFalse);
  });
}
