import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:nyaya/features/categories/data/categories_repository.dart';
import 'package:nyaya/features/categories/presentation/categories_view_model.dart';
import 'package:nyaya/features/home/data/daily_questions_repository.dart';
import 'package:nyaya/features/home/data/progress_repository.dart';
import 'package:nyaya/features/home/presentation/daily_questions_view_model.dart';
import 'package:nyaya/features/home/presentation/home_page.dart';
import 'package:nyaya/features/home/presentation/home_view_model.dart';
import 'package:nyaya/features/home/presentation/learning_progress_view_model.dart';
import 'package:nyaya/features/home/presentation/widgets/recommended_section.dart';
import 'package:nyaya/features/legal_updates/data/legal_updates_repository.dart';
import 'package:nyaya/features/legal_updates/presentation/legal_updates_view_model.dart';

import '../../../support/fake_backend.dart';
import '../../../support/localized_app.dart';

const progress = {
  'totalQuizzesAttempted': 8,
  'totalQuizzesCompleted': 6,
  'totalPoints': 240,
  'accuracyPercentage': 75,
};

const twoCategories = {
  'items': [
    {'id': 1, 'name': 'Criminal Law', 'slug': 'criminal-law'},
    {'id': 2, 'name': 'Tax Law', 'slug': 'tax-law'},
  ],
};

Map<String, Object> backend({
  Object progressRoute = progress,
  Object categoriesRoute = twoCategories,
}) => {
  '/users/me/progress': progressRoute,
  '/categories': categoriesRoute,
  '/categories/1/quizzes': {
    'items': [
      {'id': 5},
      {'id': 6},
    ],
  },
  '/categories/2/quizzes': {'items': []},
  '/daily-questions/today': {
    'date': '2026-10-06',
    'answered': false,
    'question': null,
    'result': null,
  },
  '/legal-updates': {'items': []},
};

void main() {
  late LearningProgressViewModel progressViewModel;
  late CategoriesViewModel categoriesViewModel;

  Future<void> pumpHome(
    WidgetTester tester,
    Map<String, Object> routes, {
    Locale locale = const Locale('en'),
    VoidCallback? onResumePressed,
    ValueChanged<CategoryData>? onCategorySelected,
    VoidCallback? onViewAllCategoriesPressed,
    VoidCallback? onAskNyayaPressed,
  }) async {
    final client = fakeBackend(routes);
    progressViewModel = LearningProgressViewModel(
      repository: ProgressRepository(client),
    );
    categoriesViewModel = CategoriesViewModel(
      repository: CategoriesRepository(client),
    );
    final dailyQuestions = DailyQuestionsViewModel(
      repository: DailyQuestionsRepository(client),
    );
    final legalUpdates = LegalUpdatesViewModel(
      repository: LegalUpdatesRepository(client),
    );
    addTearDown(progressViewModel.dispose);
    addTearDown(categoriesViewModel.dispose);
    addTearDown(dailyQuestions.dispose);
    addTearDown(legalUpdates.dispose);

    await pumpLocalized(
      tester,
      HomePage(
        viewModel: const HomeViewModel(),
        dailyQuestions: dailyQuestions,
        legalUpdates: legalUpdates,
        progress: progressViewModel,
        categories: categoriesViewModel,
        onResumePressed: onResumePressed,
        onCategorySelected: onCategorySelected,
        onViewAllCategoriesPressed: onViewAllCategoriesPressed,
        onAskNyayaPressed: onAskNyayaPressed,
      ),
      locale: locale,
    );
  }

  Finder page() => find
      .descendant(
        of: find.byKey(const ValueKey('home.scroll')),
        matching: find.byType(Scrollable),
      )
      .first;

  Future<void> scrollTo(WidgetTester tester, Finder target) async {
    await tester.scrollUntilVisible(target, 300, scrollable: page());
    await tester.pumpAndSettle();
  }

  group('Continue Learning', () {
    testWidgets('AC-003 shows accuracy, quizzes completed and points', (
      tester,
    ) async {
      var resumed = 0;
      await pumpHome(tester, backend(), onResumePressed: () => resumed++);
      await scrollTo(tester, find.byKey(const ValueKey('home.continue.card')));

      expect(find.text('6 quizzes completed'), findsOneWidget);
      expect(find.text('240 points · Accuracy 75%'), findsOneWidget);
      expect(find.text('Indian Constitution Quiz'), findsNothing);

      await tester.tap(find.byKey(const ValueKey('home.continue.resume')));
      expect(resumed, 1);
    });

    testWidgets('AC-004 no attempts shows the first-quiz message', (
      tester,
    ) async {
      await pumpHome(
        tester,
        backend(
          progressRoute: {
            'totalQuizzesAttempted': 0,
            'totalQuizzesCompleted': 0,
            'totalPoints': 0,
            'accuracyPercentage': 0,
          },
        ),
      );
      await scrollTo(tester, find.byKey(const ValueKey('home.continue.card')));

      expect(
        find.text('No quizzes yet. Take your first quiz!'),
        findsOneWidget,
      );
    });

    testWidgets('AC-004 a failure shows Retry; Home still renders', (
      tester,
    ) async {
      await pumpHome(
        tester,
        backend(progressRoute: http.Response('{"message":"boom"}', 500)),
      );
      await scrollTo(tester, find.byKey(const ValueKey('home.continue.card')));

      expect(
        find.descendant(
          of: find.byKey(const ValueKey('home.continue.card')),
          matching: find.byKey(const ValueKey('loadState.retry')),
        ),
        findsOneWidget,
      );
      expect(
        find.byKey(const ValueKey('home.section.explore')),
        findsOneWidget,
      );
    });
  });

  testWidgets('AC-005 a wired Ask Nyaya card shows Soon and reports taps', (
    tester,
  ) async {
    var taps = 0;
    await pumpHome(tester, backend(), onAskNyayaPressed: () => taps++);
    final card = find.byKey(const ValueKey('home.askNyaya'));
    await scrollTo(tester, card);

    expect(
      find.descendant(of: card, matching: find.text('Soon')),
      findsOneWidget,
    );
    await tester.tap(card);
    expect(taps, 1);
  });

  testWidgets('spec 035 AC-001 an unwired Ask Nyaya card stays hidden', (
    tester,
  ) async {
    await pumpHome(tester, backend());
    await scrollTo(tester, find.byKey(const ValueKey('home.section.explore')));

    expect(find.byKey(const ValueKey('home.askNyaya')), findsNothing);
  });

  group('Explore by Category (specs 026, 040)', () {
    testWidgets('AC-006 shows categories with quiz counts; taps report', (
      tester,
    ) async {
      final selected = <String>[];
      await pumpHome(
        tester,
        backend(),
        onCategorySelected: (category) => selected.add(category.slug),
      );
      await scrollTo(
        tester,
        find.byKey(const ValueKey('home.section.explore')),
      );

      // One category section: the sample strip is gone (spec 040).
      expect(find.text('Explore by Category'), findsOneWidget);
      expect(find.text('Recommended for you'), findsNothing);
      expect(find.text('Constitutional Law'), findsNothing);
      expect(find.text('2 quizzes'), findsOneWidget);
      expect(find.text('0 quizzes'), findsOneWidget);

      await tester.tap(
        find.byKey(const ValueKey('home.recommended.criminal-law')),
      );
      expect(selected, ['criminal-law']);
    });

    testWidgets('AC-007 View All reports the tap', (tester) async {
      var taps = 0;
      await pumpHome(
        tester,
        backend(),
        onViewAllCategoriesPressed: () => taps++,
      );
      final viewAll = find.byKey(
        const ValueKey('home.section.explore.viewAll'),
      );
      await scrollTo(tester, viewAll);

      await tester.tap(viewAll);
      expect(taps, 1);
    });

    testWidgets('AC-008 no categories shows the empty state', (tester) async {
      await pumpHome(tester, backend(categoriesRoute: {'items': []}));
      await scrollTo(tester, find.byKey(const ValueKey('home.recommended')));

      expect(find.text('No categories yet.'), findsOneWidget);
    });

    testWidgets('AC-008 a failure shows Retry, which reloads', (tester) async {
      final routes = backend(
        categoriesRoute: http.Response('{"message":"boom"}', 500),
      );
      await pumpHome(tester, routes);
      final section = find.byKey(const ValueKey('home.recommended'));
      await scrollTo(tester, section);
      final retry = find.descendant(
        of: section,
        matching: find.byKey(const ValueKey('loadState.retry')),
      );
      expect(retry, findsOneWidget);

      routes['/categories'] = twoCategories;
      await tester.tap(retry);
      await tester.pumpAndSettle();

      expect(
        find.byKey(const ValueKey('home.recommended.criminal-law')),
        findsOneWidget,
      );
    });
  });

  testWidgets('AC-009 new strings are in Hindi', (tester) async {
    await pumpHome(
      tester,
      backend(),
      locale: const Locale('hi'),
      onAskNyayaPressed: () {},
    );
    await scrollTo(tester, find.byKey(const ValueKey('home.continue.card')));
    expect(find.text('6 क्विज़ पूरे हुए'), findsOneWidget);

    await scrollTo(tester, find.byKey(const ValueKey('home.askNyaya')));
    expect(find.text('न्याय से पूछें'), findsOneWidget);
    expect(find.text('Ask Nyaya'), findsNothing);

    await scrollTo(tester, find.byKey(const ValueKey('home.section.explore')));
    expect(find.text('श्रेणी के अनुसार देखें'), findsOneWidget);
  });

  testWidgets('NFR-002 the progress card fits a 360 px phone', (tester) async {
    await pumpHome(tester, backend());
    tester.view.physicalSize = const Size(360, 740);
    await tester.pumpAndSettle();
    await scrollTo(tester, find.byKey(const ValueKey('home.continue.card')));

    expect(tester.takeException(), isNull);
  });

  testWidgets('Ask Nyaya and recommended cards are labelled buttons', (
    tester,
  ) async {
    await pumpHome(tester, backend(), onAskNyayaPressed: () {});
    final ask = find.byKey(const ValueKey('home.askNyaya.button'));
    await scrollTo(tester, ask);

    expect(
      tester.getSemantics(ask),
      isSemantics(
        isButton: true,
        hasTapAction: true,
        label:
            'Ask Nyaya, Soon. Ask your legal questions in simple language. '
            'Get clear answers.',
      ),
    );

    final card = find.byKey(const ValueKey('home.recommended.criminal-law'));
    await scrollTo(tester, card);
    expect(
      tester.getSemantics(card),
      isSemantics(
        isButton: true,
        hasTapAction: true,
        label: 'Criminal Law, 2 quizzes',
      ),
    );
  });

  testWidgets('Recommended cards fit large text on a small phone', (
    tester,
  ) async {
    tester.platformDispatcher.textScaleFactorTestValue = 1.6;
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    final viewModel = CategoriesViewModel(
      repository: CategoriesRepository(
        fakeBackend(
          backend(
            categoriesRoute: {
              'items': [
                {
                  'id': 1,
                  'name': 'Constitutional and Administrative Law',
                  'slug': 'criminal-law',
                },
              ],
            },
          ),
        ),
      ),
    );
    addTearDown(viewModel.dispose);
    await viewModel.load();

    // The section alone: Home's hero has its own large-text limits.
    await pumpLocalized(
      tester,
      Scaffold(
        body: RecommendedSection(
          viewModel: viewModel,
          onCategorySelected: (_) {},
        ),
      ),
      locale: const Locale('en'),
    );
    tester.view.physicalSize = const Size(360, 740);
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.text('Constitutional and Administrative Law'), findsOneWidget);
  });
}
