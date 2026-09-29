import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nyaya/features/goal_selection/presentation/goal_selection_page.dart';
import 'package:nyaya/features/goal_selection/presentation/goal_selection_view_model.dart';

void main() {
  Future<void> pumpGoalSelectionPage(
    WidgetTester tester, {
    ValueChanged<String>? onContinue,
    GoalSelectionViewModel? viewModel,
    Size size = const Size(393, 852),
  }) async {
    tester.view.reset();
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1;
    tester.view.padding = const FakeViewPadding(top: 59, bottom: 34);
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
      tester.view.resetPadding();
    });

    await tester.pumpWidget(
      MaterialApp(
        home: GoalSelectionPage(
          onContinue: onContinue ?? (_) {},
          viewModel: viewModel,
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('shows the heading, helper line, goal cards and footer copy', (
    WidgetTester tester,
  ) async {
    await pumpGoalSelectionPage(tester);

    expect(find.text('What brings you'), findsOneWidget);
    expect(find.text('to Nyaya?'), findsOneWidget);
    expect(
      find.text('Choose your goal — you can change it anytime.'),
      findsOneWidget,
    );
    expect(find.text('Learn law for life'), findsOneWidget);
    expect(
      find.text('Everyday legal know-how for work, family and your rights'),
      findsOneWidget,
    );
    expect(find.text('Crack an exam'), findsOneWidget);
    expect(
      find.text('Sharpen exam-style MCQ practice and statute mastery'),
      findsOneWidget,
    );
    expect(find.text('Study law'), findsOneWidget);
    expect(
      find.text('Master your LLB subjects, concept by concept'),
      findsOneWidget,
    );
    expect(find.text('CONTINUE'), findsOneWidget);
    expect(find.text('You can switch goals later in Profile.'), findsOneWidget);
  });

  testWidgets('Learn law for life starts selected and tapping a card moves '
      'the selection', (WidgetTester tester) async {
    await pumpGoalSelectionPage(tester);

    expect(
      find.byKey(const ValueKey('goal.radio.selected.learn-law-for-life')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey('goal.radio.unselected.crack-an-exam')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey('goal.radio.unselected.study-law')),
      findsOneWidget,
    );

    await tester.tap(find.byKey(const ValueKey('goal.card.study-law')));
    await tester.pumpAndSettle();

    expect(
      find.byKey(const ValueKey('goal.radio.selected.study-law')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey('goal.radio.unselected.learn-law-for-life')),
      findsOneWidget,
    );
  });

  testWidgets('CONTINUE reports the default goal id', (
    WidgetTester tester,
  ) async {
    String? continuedWith;
    await pumpGoalSelectionPage(
      tester,
      onContinue: (goalId) => continuedWith = goalId,
    );

    await tester.ensureVisible(find.byKey(const ValueKey('goal.continue')));
    await tester.tap(find.byKey(const ValueKey('goal.continue')));
    await tester.pumpAndSettle();

    expect(continuedWith, 'learn-law-for-life');
  });

  testWidgets('CONTINUE reports the goal picked before tapping it', (
    WidgetTester tester,
  ) async {
    String? continuedWith;
    await pumpGoalSelectionPage(
      tester,
      onContinue: (goalId) => continuedWith = goalId,
    );

    await tester.tap(find.byKey(const ValueKey('goal.card.crack-an-exam')));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.byKey(const ValueKey('goal.continue')));
    await tester.tap(find.byKey(const ValueKey('goal.continue')));
    await tester.pumpAndSettle();

    expect(continuedWith, 'crack-an-exam');
  });

  testWidgets('shows back arrow, progress indicator and ornaments', (
    WidgetTester tester,
  ) async {
    await pumpGoalSelectionPage(tester);

    expect(find.byKey(const ValueKey('goal.back')), findsOneWidget);
    expect(find.byKey(const ValueKey('goal.progress')), findsOneWidget);
    expect(find.byKey(const ValueKey('goal.temple')), findsOneWidget);
    expect(find.byKey(const ValueKey('goal.star')), findsOneWidget);
  });

  testWidgets('cards expose mutually exclusive selection semantics', (
    WidgetTester tester,
  ) async {
    await pumpGoalSelectionPage(tester);

    expect(
      tester.getSemantics(
        find.byKey(const ValueKey('goal.card.learn-law-for-life')),
      ),
      isSemantics(
        isSelected: true,
        isInMutuallyExclusiveGroup: true,
        isButton: true,
        hasTapAction: true,
      ),
    );
  });

  testWidgets('an injected view model drives the initial selection', (
    WidgetTester tester,
  ) async {
    final viewModel = GoalSelectionViewModel()..select('study-law');
    await pumpGoalSelectionPage(tester, viewModel: viewModel);

    expect(
      find.byKey(const ValueKey('goal.radio.selected.study-law')),
      findsOneWidget,
    );
  });
}
