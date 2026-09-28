// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get appTitle => 'न्याय';

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
  String get commonRetry => 'पुनः प्रयास करें';

  @override
  String get commonCancel => 'रद्द करें';

  @override
  String get commonSave => 'सहेजें';

  @override
  String get commonSeeAll => 'सभी देखें';

  @override
  String get commonComingSoon => 'शीघ्र आ रहा है';

  @override
  String featureComingSoon(String feature) {
    return '$feature जल्द आ रहा है।';
  }

  @override
  String get errorOffline =>
      'न्याय सर्वर तक नहीं पहुँच पा रहे। अपना कनेक्शन जाँचें और पुनः प्रयास करें।';

  @override
  String get errorSessionExpired =>
      'आपका सत्र समाप्त हो गया है। कृपया फिर से साइन इन करें।';

  @override
  String get errorGeneric => 'कुछ गलत हो गया। कृपया पुनः प्रयास करें।';

  @override
  String get emptyNothingHere => 'अभी यहाँ कुछ नहीं है।';

  @override
  String get navHome => 'होम';

  @override
  String get navCategories => 'श्रेणियाँ';

  @override
  String get navLeaderboard => 'लीडरबोर्ड';

  @override
  String get navArticles => 'लेख';

  @override
  String get navProfile => 'प्रोफ़ाइल';

  @override
  String get comingSoonBody => 'हम यह भाग बना रहे हैं। जल्द ही फिर देखें।';

  @override
  String categoryQuizCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count क्विज़',
      one: '1 क्विज़',
    );
    return '$_temp0';
  }

  @override
  String get categoriesEmpty => 'अभी कोई श्रेणी नहीं है।';
}
