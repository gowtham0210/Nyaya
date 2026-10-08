import '../../../app/theme/app_tokens.dart';
import '../../../core/presentation/load_state_notifier.dart';
import '../../../core/presentation/widgets/nyaya_icon.dart';
import '../data/categories_repository.dart';

class CategoriesViewModel extends LoadStateNotifier<List<CategoryData>> {
  CategoriesViewModel({required CategoriesRepository repository})
    : _repository = repository;

  final CategoriesRepository _repository;

  String get featureId => '013-categories';

  @override
  Future<List<CategoryData>> fetch() async => [
    for (final (index, category)
        in (await _repository.fetchCategories()).indexed)
      _toCard(category, index),
  ];

  @override
  bool isEmpty(List<CategoryData> cards) => cards.isEmpty;

  List<CategoryData> filter(List<CategoryData> categories, String query) {
    final normalized = query.trim().toLowerCase();
    if (normalized.isEmpty) {
      return categories;
    }
    return categories
        .where((category) => category.label.toLowerCase().contains(normalized))
        .toList();
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

// Muted brand tones (spec 036), not rainbow pastels.
final _palette = <_CardStyle>[
  (
    icon: HomeIconType.temple,
    tintHex: NyayaTones.navyTint.toARGB32(),
    iconHex: NyayaTones.navyInk.toARGB32(),
  ),
  (
    icon: HomeIconType.gavel,
    tintHex: NyayaTones.clayTint.toARGB32(),
    iconHex: NyayaTones.clayInk.toARGB32(),
  ),
  (
    icon: HomeIconType.scales,
    tintHex: NyayaTones.oliveTint.toARGB32(),
    iconHex: NyayaTones.oliveInk.toARGB32(),
  ),
  (
    icon: HomeIconType.document,
    tintHex: NyayaTones.plumTint.toARGB32(),
    iconHex: NyayaTones.plumInk.toARGB32(),
  ),
  (
    icon: HomeIconType.community,
    tintHex: NyayaTones.bronzeTint.toARGB32(),
    iconHex: NyayaTones.bronzeInk.toARGB32(),
  ),
  (
    icon: HomeIconType.handcuffs,
    tintHex: NyayaTones.tealTint.toARGB32(),
    iconHex: NyayaTones.tealInk.toARGB32(),
  ),
  (
    icon: HomeIconType.book,
    tintHex: NyayaTones.slateTint.toARGB32(),
    iconHex: NyayaTones.slateInk.toARGB32(),
  ),
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
