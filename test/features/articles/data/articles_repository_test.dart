import 'package:flutter_test/flutter_test.dart';
import 'package:nyaya/features/articles/data/articles_repository.dart';

import '../../../support/fake_backend.dart';

void main() {
  test('AC-001 maps articles in display order; splits key features', () async {
    final repository = ArticlesRepository(
      fakeBackend({
        '/articles': {
          'items': [
            {
              'id': 2,
              'part': 'III',
              'partTitle': 'Fundamental Rights',
              'title': 'Right to Equality',
              'slug': 'right-to-equality',
              'articleRange': 'Articles 14–18',
              'description': 'Equality before law.',
              'whatItMeans': 'Everyone is equal.',
              'whyItMatters': 'It stops discrimination.',
              'keyFeatures': 'Equality before law; No discrimination;  ',
              'displayOrder': 2,
            },
            {
              'id': 1,
              'part': 'I',
              'partTitle': 'The Union',
              'title': 'Name of the Union',
              'slug': 'name-of-union',
              'articleRange': 'Article 1',
              'description': 'India, that is Bharat.',
              'whatItMeans': null,
              'whyItMatters': null,
              'keyFeatures': null,
              'displayOrder': 1,
            },
          ],
        },
      }),
    );

    final articles = await repository.fetchArticles();

    expect(articles.map((a) => a.id), [1, 2]);
    final equality = articles.last;
    expect(equality.part, 'III');
    expect(equality.partTitle, 'Fundamental Rights');
    expect(equality.articleRange, 'Articles 14–18');
    expect(equality.whatItMeans, 'Everyone is equal.');
    expect(equality.keyFeatures, ['Equality before law', 'No discrimination']);
    expect(articles.first.whatItMeans, isNull);
    expect(articles.first.keyFeatures, isEmpty);
  });

  test(
    'AC-001 ties and missing order sort by id; missing order goes last',
    () async {
      final repository = ArticlesRepository(
        fakeBackend({
          '/articles': {
            'items': [
              {'id': 9, 'title': 'No order'},
              {'id': 5, 'title': 'B', 'displayOrder': 1},
              {'id': 4, 'title': 'A', 'displayOrder': 1},
            ],
          },
        }),
      );

      final articles = await repository.fetchArticles();

      expect(articles.map((a) => a.id), [4, 5, 9]);
    },
  );
}
