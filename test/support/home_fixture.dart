import 'package:flutter_test/flutter_test.dart';
import 'package:nyaya/features/categories/data/categories_repository.dart';
import 'package:nyaya/features/categories/presentation/categories_view_model.dart';
import 'package:nyaya/features/home/data/progress_repository.dart';
import 'package:nyaya/features/home/presentation/learning_progress_view_model.dart';

import 'fake_backend.dart';

/// Home's progress and categories view models on a backend with no
/// attempts and no categories, for tests about other Home sections.
/// Call inside a test; disposal is registered with [addTearDown].
({LearningProgressViewModel progress, CategoriesViewModel categories})
quietHomeSections() {
  final client = fakeBackend({
    '/users/me/progress': {
      'totalQuizzesAttempted': 0,
      'totalQuizzesCompleted': 0,
      'totalPoints': 0,
      'accuracyPercentage': 0,
    },
    '/categories': {'items': []},
  });
  final progress = LearningProgressViewModel(
    repository: ProgressRepository(client),
  );
  final categories = CategoriesViewModel(
    repository: CategoriesRepository(client),
  );
  addTearDown(progress.dispose);
  addTearDown(categories.dispose);
  return (progress: progress, categories: categories);
}
