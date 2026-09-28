import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:nyaya/features/categories/data/categories_repository.dart';

import '../../../support/fake_backend.dart';

void main() {
  test('AC-001 maps active categories with their quiz counts', () async {
    final repository = CategoriesRepository(
      fakeBackend({
        '/categories': {
          'items': [
            {
              'id': 1,
              'name': 'Constitutional Law',
              'slug': 'constitutional-law',
              'description': 'The supreme law.',
              'isActive': true,
            },
            {
              'id': 2,
              'name': 'Retired Topic',
              'slug': 'retired-topic',
              'isActive': false,
            },
          ],
        },
        '/categories/1/quizzes': {
          'items': [
            {'id': 10},
            {'id': 11},
            {'id': 12},
          ],
        },
      }),
    );

    final categories = await repository.fetchCategories();

    expect(categories, hasLength(1));
    expect(categories.single.id, 1);
    expect(categories.single.name, 'Constitutional Law');
    expect(categories.single.slug, 'constitutional-law');
    expect(categories.single.quizCount, 3);
  });

  test('AC-002 a failed quiz count keeps the category with no count', () async {
    final repository = CategoriesRepository(
      fakeBackend({
        '/categories': {
          'items': [
            {'id': 4, 'name': 'Civil Law', 'slug': 'civil-law'},
          ],
        },
        '/categories/4/quizzes': http.Response('{"message":"boom"}', 500),
      }),
    );

    final categories = await repository.fetchCategories();

    expect(categories.single.name, 'Civil Law');
    expect(categories.single.quizCount, isNull);
  });
}
