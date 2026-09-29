import '../../../app/notifications_store.dart';
import '../../../app/quiz_progress_store.dart';

class HomeViewModel {
  const HomeViewModel();

  String get featureId => '008-home-page';

  String get appTitle => 'Nyaya';

  String get heroLeadLine => 'Test Your';

  String get heroAccentLine => 'Legal Knowledge.';

  String get heroTrailLine => 'Master Justice.';

  String get heroSupportingCopy => 'Quizzes on Law. Insights for Life.';

  String get heroCtaLabel => 'Start Quiz';

  bool get hasUnreadNotifications => NotificationsStore.unreadCount > 0;

  /// Reflects the user's real latest attempt once [QuizProgressStore.refresh]
  /// has reached the backend, and the last score recorded on this device
  /// until then.
  ContinueLearningData get continueLearning {
    final snapshot = QuizProgressStore.snapshot;
    return ContinueLearningData(
      title: snapshot.title,
      questionCount: snapshot.questionCount,
      progress: snapshot.progress,
      canResume: snapshot.canResume,
      answeredCount: snapshot.answeredCount,
    );
  }

  List<HomeCategoryData> get categories => const [
    HomeCategoryData(
      id: 'constitutional_law',
      label: 'Constitutional Law',
      icon: HomeIconType.book,
    ),
    HomeCategoryData(
      id: 'criminal_evidence_law',
      label: 'Criminal & Evidence Law',
      icon: HomeIconType.gavel,
    ),
    HomeCategoryData(
      id: 'civil_general_law',
      label: 'Civil & General Law',
      icon: HomeIconType.scales,
    ),
    HomeCategoryData(
      id: 'marriage_family_law',
      label: 'Marriage & Family Law',
      icon: HomeIconType.community,
    ),
    HomeCategoryData(
      id: 'labor_industrial_law',
      label: 'Labor & Industrial Law',
      icon: HomeIconType.labor,
    ),
    HomeCategoryData(
      id: 'corporate_commercial_law',
      label: 'Corporate & Commercial Law',
      icon: HomeIconType.contract,
    ),
    HomeCategoryData(
      id: 'taxation_law',
      label: 'Taxation Law',
      icon: HomeIconType.taxation,
    ),
    HomeCategoryData(
      id: 'cyber_intellectual_property',
      label: 'Cyber & Intellectual Property',
      icon: HomeIconType.cyber,
    ),
    HomeCategoryData(
      id: 'property_real_estate',
      label: 'Property & Real Estate Law',
      icon: HomeIconType.property,
    ),
    HomeCategoryData(
      id: 'banking_financial_law',
      label: 'Banking & Financial Law',
      icon: HomeIconType.banking,
    ),
    HomeCategoryData(
      id: 'environmental_law',
      label: 'Environmental Law',
      icon: HomeIconType.environmental,
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

  List<HomeNavItemData> get navigationItems => const [
    HomeNavItemData(id: 'home', label: 'Home', icon: HomeIconType.navHome),
    HomeNavItemData(
      id: 'quizzes',
      label: 'Quizzes',
      icon: HomeIconType.navQuizzes,
    ),
    HomeNavItemData(
      id: 'leaderboard',
      label: 'Leaderboard',
      icon: HomeIconType.navLeaderboard,
    ),
    HomeNavItemData(
      id: 'legal_updates',
      label: 'Legal Updates',
      icon: HomeIconType.navLegalUpdates,
    ),
    HomeNavItemData(
      id: 'profile',
      label: 'Profile',
      icon: HomeIconType.navProfile,
    ),
  ];

  int get activeNavigationIndex => 0;
}

enum QuizDifficulty {
  easy('Easy'),
  medium('Medium'),
  hard('Hard');

  const QuizDifficulty(this.label);

  final String label;
}

enum HomeIconType {
  book,
  gavel,
  scales,
  document,
  community,
  temple,
  handcuffs,
  contract,
  labor,
  taxation,
  cyber,
  property,
  banking,
  environmental,
  navHome,
  navQuizzes,
  navLeaderboard,
  navLegalUpdates,
  navProfile,
}

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

class ContinueLearningData {
  const ContinueLearningData({
    required this.title,
    required this.questionCount,
    required this.progress,
    this.canResume = false,
    this.answeredCount = 0,
  });

  final String title;
  final int questionCount;
  final double progress;

  /// True when a half-finished attempt is waiting to be picked up, as
  /// opposed to a finished one to retake.
  final bool canResume;

  /// Questions already answered in that half-finished attempt.
  final int answeredCount;
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

class HomeNavItemData {
  const HomeNavItemData({
    required this.id,
    required this.label,
    required this.icon,
  });

  final String id;
  final String label;
  final HomeIconType icon;
}
