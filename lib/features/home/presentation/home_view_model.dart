import '../../../core/presentation/widgets/nyaya_icon.dart';

export '../../../core/presentation/widgets/nyaya_icon.dart' show HomeIconType;

class HomeViewModel {
  const HomeViewModel();

  String get featureId => '008-home-page';

  bool get hasUnreadNotifications => true;

  List<HomeCategoryData> get categories => const [
    HomeCategoryData(
      id: 'constitutional-law',
      label: 'Constitutional Law',
      icon: HomeIconType.book,
    ),
    HomeCategoryData(
      id: 'criminal-law',
      label: 'Criminal Law',
      icon: HomeIconType.gavel,
    ),
    HomeCategoryData(
      id: 'civil-law',
      label: 'Civil Law',
      icon: HomeIconType.scales,
    ),
    HomeCategoryData(
      id: 'contract-law',
      label: 'Contract Law',
      icon: HomeIconType.document,
    ),
    HomeCategoryData(
      id: 'legal-reasoning',
      label: 'Legal Reasoning',
      icon: HomeIconType.community,
    ),
  ];

  List<PopularQuizData> get popularQuizzes => const [
    PopularQuizData(
      id: 'fundamental-rights-quiz',
      title: 'Fundamental Rights Quiz',
      questionCount: 10,
      difficulty: QuizDifficulty.medium,
      description:
          'Test your knowledge on Fundamental Rights guaranteed by the Constitution.',
      rating: 4.6,
      tileBackgroundHex: 0xFF11233B,
      tileForegroundHex: 0xFFD3A247,
      icon: HomeIconType.temple,
    ),
    PopularQuizData(
      id: 'indian-penal-code-quiz',
      title: 'Indian Penal Code Quiz',
      questionCount: 15,
      difficulty: QuizDifficulty.hard,
      description:
          'Challenge yourself with questions from the Indian Penal Code.',
      rating: 4.7,
      tileBackgroundHex: 0xFFD3A247,
      tileForegroundHex: 0xFFFFFFFF,
      icon: HomeIconType.handcuffs,
    ),
    PopularQuizData(
      id: 'contract-act-quiz',
      title: 'Contract Act Quiz',
      questionCount: 12,
      difficulty: QuizDifficulty.easy,
      description: 'Test your understanding of the Indian Contract Act, 1872.',
      rating: 4.5,
      tileBackgroundHex: 0xFF11233B,
      tileForegroundHex: 0xFFD3A247,
      icon: HomeIconType.contract,
    ),
  ];
}

enum QuizDifficulty { easy, medium, hard }

class HomeCategoryData {
  const HomeCategoryData({
    required this.id,
    required this.label,
    required this.icon,
  });

  final String id;
  final String label;
  final HomeIconType icon;
}

class PopularQuizData {
  const PopularQuizData({
    required this.id,
    required this.title,
    required this.questionCount,
    required this.difficulty,
    required this.description,
    required this.rating,
    required this.tileBackgroundHex,
    required this.tileForegroundHex,
    required this.icon,
  });

  final String id;
  final String title;
  final int questionCount;
  final QuizDifficulty difficulty;
  final String description;
  final double rating;
  final int tileBackgroundHex;
  final int tileForegroundHex;
  final HomeIconType icon;
}
