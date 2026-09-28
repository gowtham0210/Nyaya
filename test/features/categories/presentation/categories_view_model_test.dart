import 'package:flutter_test/flutter_test.dart';
import 'package:nyaya/features/categories/presentation/categories_view_model.dart';

void main() {
  const viewModel = CategoriesViewModel();

  test('exposes categories with labels and topic counts', () {
    expect(viewModel.categories, isNotEmpty);
    expect(
      viewModel.categories.every((category) => category.topicCount > 0),
      isTrue,
    );
  });

  test('activeNavigationIndex points at the Categories tab', () {
    expect(viewModel.activeNavigationIndex, 1);
    expect(viewModel.navigationItems[1].id, 'categories');
  });

  test('filter is case-insensitive and matches substrings', () {
    final result = viewModel.filter(viewModel.categories, 'criminal');
    expect(result.map((c) => c.id), contains('criminal-law'));
    expect(result.map((c) => c.id), contains('criminal-procedure'));
  });

  test('filter with blank query returns the full list', () {
    final result = viewModel.filter(viewModel.categories, '   ');
    expect(result.length, viewModel.categories.length);
  });

  test('filter with no match returns an empty list', () {
    final result = viewModel.filter(viewModel.categories, 'zzz');
    expect(result, isEmpty);
  });
}
