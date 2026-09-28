// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Tamil (`ta`).
class AppLocalizationsTa extends AppLocalizations {
  AppLocalizationsTa([String locale = 'ta']) : super(locale);

  @override
  String get appTitle => 'நியாயா';

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
  String get commonRetry => 'மீண்டும் முயற்சி';

  @override
  String get commonCancel => 'ரத்து செய்';

  @override
  String get commonSave => 'சேமி';

  @override
  String get commonSeeAll => 'அனைத்தையும் காண்க';

  @override
  String get commonComingSoon => 'விரைவில் வருகிறது';

  @override
  String featureComingSoon(String feature) {
    return '$feature விரைவில் வருகிறது.';
  }

  @override
  String get errorOffline =>
      'நியாயா சேவையகத்தை அடைய முடியவில்லை. இணைப்பைச் சரிபார்த்து மீண்டும் முயற்சிக்கவும்.';

  @override
  String get errorSessionExpired =>
      'உங்கள் அமர்வு முடிந்தது. மீண்டும் உள்நுழையவும்.';

  @override
  String get errorGeneric => 'ஏதோ தவறு நடந்தது. மீண்டும் முயற்சிக்கவும்.';

  @override
  String get emptyNothingHere => 'இங்கே இன்னும் எதுவும் இல்லை.';
}
