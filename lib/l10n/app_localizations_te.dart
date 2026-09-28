// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Telugu (`te`).
class AppLocalizationsTe extends AppLocalizations {
  AppLocalizationsTe([String locale = 'te']) : super(locale);

  @override
  String get appTitle => 'న్యాయ';

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
  String get commonRetry => 'మళ్లీ ప్రయత్నించండి';

  @override
  String get commonCancel => 'రద్దు చేయండి';

  @override
  String get commonSave => 'సేవ్ చేయండి';

  @override
  String get commonSeeAll => 'అన్నీ చూడండి';

  @override
  String get commonComingSoon => 'త్వరలో వస్తుంది';

  @override
  String featureComingSoon(String feature) {
    return '$feature త్వరలో వస్తుంది.';
  }

  @override
  String get errorOffline =>
      'న్యాయ సర్వర్‌ను చేరుకోలేకపోయాము. మీ కనెక్షన్‌ను తనిఖీ చేసి మళ్లీ ప్రయత్నించండి.';

  @override
  String get errorSessionExpired =>
      'మీ సెషన్ ముగిసింది. దయచేసి మళ్లీ సైన్ ఇన్ చేయండి.';

  @override
  String get errorGeneric => 'ఏదో తప్పు జరిగింది. దయచేసి మళ్లీ ప్రయత్నించండి.';

  @override
  String get emptyNothingHere => 'ఇక్కడ ఇంకా ఏమీ లేదు.';

  @override
  String get navHome => 'హోమ్';

  @override
  String get navCategories => 'వర్గాలు';

  @override
  String get navLeaderboard => 'లీడర్‌బోర్డ్';

  @override
  String get navArticles => 'ఆర్టికల్స్';

  @override
  String get navProfile => 'ప్రొఫైల్';

  @override
  String get comingSoonBody =>
      'మేము ఈ విభాగాన్ని రూపొందిస్తున్నాము. త్వరలో మళ్లీ చూడండి.';
}
