// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Nyaya';

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
  String get commonRetry => 'Retry';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get commonSave => 'Save';

  @override
  String get commonSeeAll => 'See all';

  @override
  String get commonComingSoon => 'Coming soon';

  @override
  String featureComingSoon(String feature) {
    return '$feature coming soon.';
  }

  @override
  String get errorOffline =>
      'Can\'t reach the Nyaya server. Check your connection and try again.';

  @override
  String get errorSessionExpired =>
      'Your session has ended. Please sign in again.';

  @override
  String get errorGeneric => 'Something went wrong. Please try again.';

  @override
  String get emptyNothingHere => 'Nothing here yet.';
}
