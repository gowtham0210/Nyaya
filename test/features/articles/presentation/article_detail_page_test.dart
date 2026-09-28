import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nyaya/features/articles/data/articles_repository.dart';
import 'package:nyaya/features/articles/presentation/article_detail_page.dart';

import '../../../support/localized_app.dart';

void main() {
  testWidgets('AC-005 shows every non-empty section', (tester) async {
    await pumpLocalized(
      tester,
      const ArticleDetailPage(
        number: 2,
        article: Article(
          id: 2,
          part: 'III',
          partTitle: 'Fundamental Rights',
          title: 'Right to Equality',
          articleRange: 'Articles 14–18',
          description: 'Equality before law.',
          whatItMeans: 'Everyone is equal before the law.',
          whyItMatters: 'It stops discrimination.',
          keyFeatures: ['Equality before law', 'No discrimination'],
        ),
      ),
      locale: const Locale('en'),
    );

    expect(find.text('Part III · Fundamental Rights'), findsOneWidget);
    expect(find.text('2. Right to Equality'), findsOneWidget);
    expect(find.text('Articles 14–18'), findsOneWidget);
    expect(find.text('What it means'), findsOneWidget);
    expect(find.text('Everyone is equal before the law.'), findsOneWidget);
    expect(find.text('Why it matters'), findsOneWidget);
    expect(find.text('Key features'), findsOneWidget);
    expect(find.text('No discrimination'), findsOneWidget);
  });

  testWidgets('AC-005 empty sections are hidden; description shows', (
    tester,
  ) async {
    await pumpLocalized(
      tester,
      const ArticleDetailPage(
        number: 1,
        article: Article(
          id: 1,
          part: 'I',
          partTitle: 'The Union',
          title: 'Name of the Union',
          articleRange: 'Article 1',
          description: 'India, that is Bharat.',
          keyFeatures: [],
        ),
      ),
      locale: const Locale('en'),
    );

    expect(find.text('India, that is Bharat.'), findsOneWidget);
    expect(find.text('Why it matters'), findsNothing);
    expect(find.text('Key features'), findsNothing);
  });
}
