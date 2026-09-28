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

  @override
  String categoryQuizCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count క్విజ్‌లు',
      one: '1 క్విజ్',
    );
    return '$_temp0';
  }

  @override
  String get categoriesEmpty => 'ఇంకా వర్గాలు ఏవీ లేవు.';

  @override
  String get brandTagline => 'చట్ట ఆధారిత క్విజ్ యాప్';

  @override
  String get splashSemanticsLabel => 'న్యాయ ప్రారంభ స్క్రీన్';

  @override
  String get splashTapToContinue => 'కొనసాగడానికి నొక్కండి';

  @override
  String get splashLoadingLabel => 'న్యాయ లోడ్ అవుతోంది';

  @override
  String splashLoadingValue(int percent) {
    return '$percent శాతం';
  }

  @override
  String get commonGetStarted => 'ప్రారంభించండి';

  @override
  String get commonSkip => 'దాటవేయి';

  @override
  String get commonNext => 'తదుపరి';

  @override
  String get commonSignIn => 'సైన్ ఇన్ చేయండి';

  @override
  String get commonLogin => 'లాగిన్';

  @override
  String get commonSignUp => 'సైన్ అప్';

  @override
  String get commonHaveAccount => 'ఇప్పటికే ఖాతా ఉందా? ';

  @override
  String get welcomeHeadlineLine1 => 'చట్టం సులభం,';

  @override
  String get welcomeHeadlineLine2 => 'న్యాయం అందరికీ అందుబాటులో.';

  @override
  String get welcomeBody =>
      'చట్టాలను తెలుసుకోండి, మీ జ్ఞానాన్ని పరీక్షించుకోండి, మీరే మీ న్యాయ నిపుణులు అవ్వండి.';

  @override
  String get welcomeLearnTitle => 'చట్టాలు నేర్చుకోండి';

  @override
  String get welcomeLearnBody =>
      'ముఖ్యమైన చట్టాలను సరళమైన భాషలో తెలుసుకుని అర్థం చేసుకోండి.';

  @override
  String get welcomeRightsTitle => 'మీ హక్కులు తెలుసుకోండి';

  @override
  String get welcomeRightsBody =>
      'మీ న్యాయ హక్కుల గురించి తెలుసుకుని శక్తివంతంగా ఉండండి.';

  @override
  String get welcomeTrackTitle => 'ట్రాక్ చేయండి, తాజాగా ఉండండి';

  @override
  String get welcomeTrackBody =>
      'కేసు స్థితిని ట్రాక్ చేసి, తాజా న్యాయ సమాచారాన్ని సులభంగా పొందండి.';

  @override
  String get onboarding1Line1 => 'మీ జ్ఞానాన్ని పరీక్షించుకోండి.';

  @override
  String get onboarding1Line2 => 'న్యాయంలో నైపుణ్యం సాధించండి.';

  @override
  String get onboarding2Line1 => 'నేర్చుకోండి. అర్థం చేసుకోండి.';

  @override
  String get onboarding2Line2 => 'చట్టాన్ని అమలు చేయండి.';

  @override
  String get onboarding2Body =>
      'కేసు ఆధారిత క్విజ్‌లు, నిజ జీవిత సందర్భాలు, నిపుణులు రూపొందించిన కంటెంట్‌తో న్యాయ యాప్ చట్ట విద్యను సులభం చేస్తుంది.';

  @override
  String get onboarding3Line1 => 'పురోగతిని ట్రాక్ చేయండి.';

  @override
  String get onboarding3Line2 => 'శ్రేష్ఠతను సాధించండి.';

  @override
  String get onboarding3Body =>
      'మీ పనితీరును ట్రాక్ చేయండి, వరుస రోజుల అలవాటు పెంచుకోండి, బ్యాడ్జ్‌లు గెలవండి, మీ న్యాయ జ్ఞానంలో అత్యుత్తమంగా ఎదగండి.';

  @override
  String get authJoinSubtitle =>
      'న్యాయలో చేరి మీ న్యాయ విద్యా ప్రయాణాన్ని ప్రారంభించండి';

  @override
  String get signInTitle => 'న్యాయకు తిరిగి స్వాగతం!';

  @override
  String get signInSubtitle =>
      'న్యాయలో మళ్లీ చేరి మీ న్యాయ విద్యా ప్రయాణాన్ని కొనసాగించండి';

  @override
  String get signInNoAccount => 'ఖాతా లేదా? ';

  @override
  String get signInPhoneMissing => 'మీ ఫోన్ నంబర్ నమోదు చేయండి.';

  @override
  String get signInPasswordMissing => 'మీ పాస్‌వర్డ్ నమోదు చేయండి.';

  @override
  String get fieldPhoneLabel => 'ఫోన్ నంబర్';

  @override
  String get fieldPhoneHint => 'మీ ఫోన్ నంబర్ నమోదు చేయండి';

  @override
  String get fieldPasswordLabel => 'పాస్‌వర్డ్';

  @override
  String get fieldPasswordHintCreate => 'బలమైన పాస్‌వర్డ్ సృష్టించండి';

  @override
  String get fieldPasswordHint => 'మీ పాస్‌వర్డ్ నమోదు చేయండి';

  @override
  String get showPassword => 'పాస్‌వర్డ్ చూపించు';

  @override
  String get hidePassword => 'పాస్‌వర్డ్ దాచు';

  @override
  String get fieldFullNameLabel => 'పూర్తి పేరు';

  @override
  String get fieldFullNameHint => 'మీ పూర్తి పేరు నమోదు చేయండి';

  @override
  String get fieldProfessionLabel => 'వృత్తి';

  @override
  String get fieldProfessionHint => 'మీ వృత్తిని ఎంచుకోండి';

  @override
  String get professionLawStudent => 'లా విద్యార్థి';

  @override
  String get professionLawyer => 'న్యాయవాది';

  @override
  String get professionJudge => 'న్యాయమూర్తి / న్యాయ అధికారి';

  @override
  String get professionLegalProfessional => 'న్యాయ నిపుణుడు';

  @override
  String get professionCitizen => 'సాధారణ పౌరుడు';

  @override
  String get signUpTitle => 'మీ ఖాతాను సృష్టించండి';

  @override
  String get signUpSendOtp => 'OTP పంపండి';

  @override
  String get validationNameRequired => 'పూర్తి పేరు అవసరం';

  @override
  String get validationNameTooShort => 'పేరు కనీసం 3 అక్షరాలు ఉండాలి';

  @override
  String get validationProfessionRequired => 'వృత్తి అవసరం';

  @override
  String get validationPasswordRequired => 'పాస్‌వర్డ్ అవసరం';

  @override
  String get validationPasswordWeak =>
      'అక్షరాలు, అంకెలతో కనీసం 8 అక్షరాలు వాడండి';

  @override
  String get validationPhoneRequired => 'ఫోన్ నంబర్ అవసరం';

  @override
  String get validationPhoneInvalid => 'సరైన ఫోన్ నంబర్ నమోదు చేయండి';

  @override
  String get otpTitle => 'OTP ధృవీకరించండి';

  @override
  String get otpSentTo => '6 అంకెల OTP ఈ నంబర్‌కు పంపబడింది:';

  @override
  String get otpChange => 'మార్చండి';

  @override
  String get otpEnter => 'OTP నమోదు చేయండి';

  @override
  String get otpNotReceived => 'OTP అందలేదా?';

  @override
  String get otpResend => 'OTP మళ్లీ పంపండి';

  @override
  String get otpResending => 'మళ్లీ పంపుతోంది…';

  @override
  String otpResendIn(String time) {
    return '$timeలో OTP మళ్లీ పంపవచ్చు';
  }

  @override
  String get otpTapToResend => 'మళ్లీ పంపడానికి నొక్కండి';

  @override
  String get otpVerifyContinue => 'ధృవీకరించి కొనసాగండి';

  @override
  String get otpIncomplete => 'పూర్తి 6 అంకెల కోడ్ నమోదు చేయండి.';

  @override
  String get otpSentAgain => 'కొత్త OTP పంపబడింది.';

  @override
  String get authErrorInvalidPhone =>
      'ఈ ఫోన్ నంబర్ సరిగ్గా లేదు. దయచేసి తనిఖీ చేసి మళ్లీ ప్రయత్నించండి.';

  @override
  String get authErrorTooManyRequests =>
      'చాలా ప్రయత్నాలు జరిగాయి. కొంతసేపు ఆగి మళ్లీ ప్రయత్నించండి.';

  @override
  String get authErrorQuotaExceeded =>
      'ప్రస్తుతానికి SMS పరిమితి మించిపోయింది. దయచేసి తర్వాత ప్రయత్నించండి.';

  @override
  String get authErrorInvalidCode =>
      'తప్పు OTP. దయచేసి కోడ్ తనిఖీ చేసి మళ్లీ ప్రయత్నించండి.';

  @override
  String get authErrorCodeExpired =>
      'ఈ OTP గడువు ముగిసింది. దయచేసి కొత్తది అభ్యర్థించండి.';

  @override
  String get authErrorUserDisabled =>
      'ఈ ఖాతా నిలిపివేయబడింది. దయచేసి సహాయాన్ని సంప్రదించండి.';

  @override
  String get authErrorNotEnabled =>
      'ఈ యాప్‌కు ఫోన్ సైన్-ఇన్ ఇంకా ప్రారంభించబడలేదు.';

  @override
  String get authErrorCredentialInUse =>
      'ఈ ఫోన్ నంబర్ ఇప్పటికే మరో ఖాతాకు లింక్ చేయబడింది.';
}
