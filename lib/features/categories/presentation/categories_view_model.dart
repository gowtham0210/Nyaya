import '../../../core/presentation/widgets/nyaya_icon.dart';

class CategoriesViewModel {
  const CategoriesViewModel();

  String get featureId => '013-categories';

  String get title => 'Categories';

  String get supportingCopy =>
      'Explore topics and strengthen your legal knowledge.';

  String get searchHint => 'Search categories';

  String get emptySearchMessage => 'No categories match your search.';

  List<CategoryData> get categories => const [
    CategoryData(
      id: 'constitutional-law',
      label: 'Constitutional Law',
      icon: HomeIconType.temple,
      topicCount: 8,
      tintHex: 0xFFE8F1FC,
      iconHex: 0xFF2F6FED,
    ),
    CategoryData(
      id: 'criminal-law',
      label: 'Criminal Law',
      icon: HomeIconType.gavel,
      topicCount: 12,
      tintHex: 0xFFFBEAEA,
      iconHex: 0xFFD64545,
    ),
    CategoryData(
      id: 'civil-law',
      label: 'Civil Law',
      icon: HomeIconType.scales,
      topicCount: 9,
      tintHex: 0xFFE8F5EC,
      iconHex: 0xFF1FA35B,
    ),
    CategoryData(
      id: 'contract-law',
      label: 'Contract Law',
      icon: HomeIconType.document,
      topicCount: 6,
      tintHex: 0xFFF1EAFB,
      iconHex: 0xFF7C4DFF,
    ),
    CategoryData(
      id: 'legal-reasoning',
      label: 'Legal Reasoning',
      icon: HomeIconType.community,
      topicCount: 5,
      tintHex: 0xFFFDF1DF,
      iconHex: 0xFFE08A2B,
    ),
    CategoryData(
      id: 'constitutional-history',
      label: 'Constitutional History',
      icon: HomeIconType.temple,
      topicCount: 4,
      tintHex: 0xFFE8F1FC,
      iconHex: 0xFF2F6FED,
    ),
    CategoryData(
      id: 'criminal-procedure',
      label: 'Criminal Procedure',
      icon: HomeIconType.handcuffs,
      topicCount: 7,
      tintHex: 0xFFE6F6F5,
      iconHex: 0xFF1C9C90,
    ),
    CategoryData(
      id: 'consumer-law',
      label: 'Consumer Law',
      icon: HomeIconType.book,
      topicCount: 3,
      tintHex: 0xFFFBEAF0,
      iconHex: 0xFFD6467D,
    ),
  ];

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

class CategoryData {
  const CategoryData({
    required this.id,
    required this.label,
    required this.icon,
    required this.topicCount,
    required this.tintHex,
    required this.iconHex,
  });

  final String id;
  final String label;
  final HomeIconType icon;
  final int topicCount;
  final int tintHex;
  final int iconHex;
}
