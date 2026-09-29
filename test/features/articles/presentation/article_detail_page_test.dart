import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nyaya/features/articles/presentation/article_detail_page.dart';
import 'package:nyaya/features/home/presentation/home_view_model.dart';

void main() {
  const category = HomeCategoryData(
    id: 'environmental_law',
    label: 'Environmental Law',
    icon: HomeIconType.environmental,
  );

  Future<void> pumpPage(
    WidgetTester tester, {
    VoidCallback? onBackPressed,
  }) async {
    await tester.pumpWidget(
      MaterialApp(
        home: ArticleDetailPage(
          category: category,
          onBackPressed: onBackPressed,
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('shows the topic title and its brief explanation, no quiz UI', (
    tester,
  ) async {
    await pumpPage(tester);

    expect(find.text('Environmental Law'), findsOneWidget);
    expect(
      find.byKey(const ValueKey('articleDetail.body.environmental_law')),
      findsOneWidget,
    );
    expect(find.text('Quizzes'), findsNothing);
    expect(find.byIcon(Icons.chevron_right_rounded), findsNothing);
  });

  testWidgets('tapping the back button reports it', (tester) async {
    var backPressed = false;
    await pumpPage(tester, onBackPressed: () => backPressed = true);

    await tester.tap(find.byKey(const ValueKey('articleDetail.back')));
    await tester.pumpAndSettle();

    expect(backPressed, isTrue);
  });
}
