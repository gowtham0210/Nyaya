// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Kannada (`kn`).
class AppLocalizationsKn extends AppLocalizations {
  AppLocalizationsKn([String locale = 'kn']) : super(locale);

  @override
  String get appTitle => 'ನ್ಯಾಯ';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageHindi => 'हिन्दी';

  @override
  String get languageTamil => 'தமிழ்';

  @override
  String get languageTelugu => 'తెలుగు';

  @override
  String get languageKannada => 'ಕನ್ನಡ';

  @override
  String get commonRetry => 'ಮತ್ತೆ ಪ್ರಯತ್ನಿಸಿ';

  @override
  String get commonCancel => 'ರದ್ದುಮಾಡಿ';

  @override
  String get commonSave => 'ಉಳಿಸಿ';

  @override
  String get commonSeeAll => 'ಎಲ್ಲವನ್ನೂ ನೋಡಿ';

  @override
  String get commonComingSoon => 'ಶೀಘ್ರದಲ್ಲಿ ಬರುತ್ತಿದೆ';

  @override
  String featureComingSoon(String feature) {
    return '$feature ಶೀಘ್ರದಲ್ಲಿ ಬರುತ್ತಿದೆ.';
  }

  @override
  String get errorOffline =>
      'ನ್ಯಾಯ ಸರ್ವರ್ ತಲುಪಲು ಆಗುತ್ತಿಲ್ಲ. ನಿಮ್ಮ ಸಂಪರ್ಕ ಪರಿಶೀಲಿಸಿ ಮತ್ತೆ ಪ್ರಯತ್ನಿಸಿ.';

  @override
  String get errorSessionExpired =>
      'ನಿಮ್ಮ ಸೆಷನ್ ಮುಗಿದಿದೆ. ದಯವಿಟ್ಟು ಮತ್ತೆ ಸೈನ್ ಇನ್ ಮಾಡಿ.';

  @override
  String get errorGeneric => 'ಏನೋ ತಪ್ಪಾಗಿದೆ. ದಯವಿಟ್ಟು ಮತ್ತೆ ಪ್ರಯತ್ನಿಸಿ.';

  @override
  String get emptyNothingHere => 'ಇಲ್ಲಿ ಇನ್ನೂ ಏನೂ ಇಲ್ಲ.';

  @override
  String get navHome => 'ಮುಖಪುಟ';

  @override
  String get navCategories => 'ವರ್ಗಗಳು';

  @override
  String get navLeaderboard => 'ಲೀಡರ್‌ಬೋರ್ಡ್';

  @override
  String get navArticles => 'ಲೇಖನಗಳು';

  @override
  String get navProfile => 'ಪ್ರೊಫೈಲ್';

  @override
  String get comingSoonBody =>
      'ನಾವು ಈ ವಿಭಾಗವನ್ನು ನಿರ್ಮಿಸುತ್ತಿದ್ದೇವೆ. ಶೀಘ್ರದಲ್ಲೇ ಮತ್ತೆ ನೋಡಿ.';

  @override
  String categoryQuizCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ಕ್ವಿಜ್‌ಗಳು',
      one: '1 ಕ್ವಿಜ್',
    );
    return '$_temp0';
  }

  @override
  String get categoriesEmpty => 'ಇನ್ನೂ ಯಾವುದೇ ವರ್ಗಗಳಿಲ್ಲ.';
}
