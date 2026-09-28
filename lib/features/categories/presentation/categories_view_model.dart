import 'package:flutter/foundation.dart';

import '../../../core/presentation/load_state.dart';
import '../../../core/presentation/widgets/nyaya_icon.dart';
import '../data/categories_repository.dart';

class CategoriesViewModel extends ChangeNotifier {
  CategoriesViewModel({required CategoriesRepository repository})
    : _repository = repository;

  final CategoriesRepository _repository;
  var _disposed = false;
  var _loadId = 0;

  String get featureId => '013-categories';

  LoadState<List<CategoryData>> get state => _state;
  LoadState<List<CategoryData>> _state = const Loading();

  /// Loads categories. When loads overlap (Retry during a load), only the
  /// latest one's result is kept.
  Future<void> load() async {
    final loadId = ++_loadId;
    _setState(const Loading());
    final result = await LoadState.run(
      () async => [
        for (final (index, category)
            in (await _repository.fetchCategories()).indexed)
          _toCard(category, index),
      ],
      isEmpty: (cards) => cards.isEmpty,
    );
    if (loadId == _loadId) {
      _setState(result);
    }
  }

  List<CategoryData> filter(List<CategoryData> categories, String query) {
    final normalized = query.trim().toLowerCase();
    if (normalized.isEmpty) {
      return categories;
    }
    return categories
        .where((category) => category.label.toLowerCase().contains(normalized))
        .toList();
  }

  void _setState(LoadState<List<CategoryData>> state) {
    if (_disposed) {
      return;
    }
    _state = state;
    notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}

/// The backend has no icon or colour per category, so known slugs keep the
/// designed look (spec 013) and others cycle through the palette.
CategoryData _toCard(LawCategory category, int index) {
  final style =
      _palette[_paletteIndexBySlug[category.slug] ?? index % _palette.length];
  return CategoryData(
    id: category.id,
    slug: category.slug,
    label: category.name,
    quizCount: category.quizCount,
    icon: style.icon,
    tintHex: style.tintHex,
    iconHex: style.iconHex,
  );
}

typedef _CardStyle = ({HomeIconType icon, int tintHex, int iconHex});

const _palette = <_CardStyle>[
  (icon: HomeIconType.temple, tintHex: 0xFFE8F1FC, iconHex: 0xFF2F6FED),
  (icon: HomeIconType.gavel, tintHex: 0xFFFBEAEA, iconHex: 0xFFD64545),
  (icon: HomeIconType.scales, tintHex: 0xFFE8F5EC, iconHex: 0xFF1FA35B),
  (icon: HomeIconType.document, tintHex: 0xFFF1EAFB, iconHex: 0xFF7C4DFF),
  (icon: HomeIconType.community, tintHex: 0xFFFDF1DF, iconHex: 0xFFE08A2B),
  (icon: HomeIconType.handcuffs, tintHex: 0xFFE6F6F5, iconHex: 0xFF1C9C90),
  (icon: HomeIconType.book, tintHex: 0xFFFBEAF0, iconHex: 0xFFD6467D),
];

/// Designed looks for known slugs, as indexes into [_palette].
const _paletteIndexBySlug = {
  'constitutional-law': 0,
  'criminal-law': 1,
  'civil-law': 2,
  'contract-law': 3,
  'legal-reasoning': 4,
  'criminal-procedure': 5,
  'consumer-law': 6,
};

class CategoryData {
  const CategoryData({
    required this.id,
    required this.slug,
    required this.label,
    required this.icon,
    required this.tintHex,
    required this.iconHex,
    this.quizCount,
  });

  final int id;
  final String slug;
  final String label;
  final HomeIconType icon;
  final int tintHex;
  final int iconHex;

  /// Null when the backend count couldn't load; the card then shows none.
  final int? quizCount;
}
