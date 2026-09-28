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

  @override
  String get navHome => 'முகப்பு';

  @override
  String get navCategories => 'வகைகள்';

  @override
  String get navLeaderboard => 'தலைமை பலகை';

  @override
  String get navArticles => 'கட்டுரைகள்';

  @override
  String get navProfile => 'சுயவிவரம்';

  @override
  String get comingSoonBody =>
      'இந்தப் பகுதியை உருவாக்கி வருகிறோம். விரைவில் மீண்டும் பாருங்கள்.';

  @override
  String quizCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count வினாடி வினாக்கள்',
      one: '1 வினாடி வினா',
    );
    return '$_temp0';
  }

  @override
  String get categoriesEmpty => 'இன்னும் வகைகள் எதுவும் இல்லை.';

  @override
  String get brandTagline => 'சட்ட அடிப்படையிலான வினாடி வினா செயலி';

  @override
  String get splashSemanticsLabel => 'நியாயா தொடக்கத் திரை';

  @override
  String get splashTapToContinue => 'தொடர தட்டவும்';

  @override
  String get splashLoadingLabel => 'நியாயா ஏற்றப்படுகிறது';

  @override
  String splashLoadingValue(int percent) {
    return '$percent சதவீதம்';
  }

  @override
  String get commonGetStarted => 'தொடங்குங்கள்';

  @override
  String get commonSkip => 'தவிர்';

  @override
  String get commonNext => 'அடுத்து';

  @override
  String get commonSignIn => 'உள்நுழையவும்';

  @override
  String get commonLogin => 'உள்நுழை';

  @override
  String get commonSignUp => 'பதிவு செய்';

  @override
  String get commonHaveAccount => 'ஏற்கனவே கணக்கு உள்ளதா? ';

  @override
  String get welcomeHeadlineLine1 => 'சட்டம் எளிதாக,';

  @override
  String get welcomeHeadlineLine2 => 'நீதி அனைவருக்கும்.';

  @override
  String get welcomeBody =>
      'சட்டங்களை அறியுங்கள், உங்கள் அறிவைச் சோதியுங்கள், நீங்களே உங்கள் சட்ட நிபுணராகுங்கள்.';

  @override
  String get welcomeLearnTitle => 'சட்டங்களைக் கற்றுக்கொள்ளுங்கள்';

  @override
  String get welcomeLearnBody =>
      'முக்கியமான சட்டங்களை எளிய மொழியில் அறிந்து புரிந்துகொள்ளுங்கள்.';

  @override
  String get welcomeRightsTitle => 'உங்கள் உரிமைகளை அறியுங்கள்';

  @override
  String get welcomeRightsBody =>
      'உங்கள் சட்ட உரிமைகள் பற்றி அறிந்து வலுவாக இருங்கள்.';

  @override
  String get welcomeTrackTitle => 'கண்காணித்து புதுப்பித்த நிலையில் இருங்கள்';

  @override
  String get welcomeTrackBody =>
      'வழக்கு நிலையைக் கண்காணித்து சமீபத்திய சட்டச் செய்திகளை எளிதாகப் பெறுங்கள்.';

  @override
  String get onboarding1Line1 => 'உங்கள் அறிவைச் சோதியுங்கள்.';

  @override
  String get onboarding1Line2 => 'நீதியில் தேர்ச்சி பெறுங்கள்.';

  @override
  String get onboarding2Line1 => 'கற்றுக்கொள்ளுங்கள். புரிந்துகொள்ளுங்கள்.';

  @override
  String get onboarding2Line2 => 'சட்டத்தைப் பயன்படுத்துங்கள்.';

  @override
  String get onboarding2Body =>
      'வழக்கு அடிப்படையிலான வினாடி வினாக்கள், நிஜ வாழ்க்கைச் சூழல்கள், நிபுணர்கள் உருவாக்கிய உள்ளடக்கம் மூலம் நியாயா செயலி சட்டக் கல்வியை எளிதாக்குகிறது.';

  @override
  String get onboarding3Line1 => 'முன்னேற்றத்தைக் கண்காணியுங்கள்.';

  @override
  String get onboarding3Line2 => 'சிறப்பை அடையுங்கள்.';

  @override
  String get onboarding3Body =>
      'உங்கள் செயல்திறனைக் கண்காணியுங்கள், தொடர் நாட்களை உருவாக்குங்கள், பதக்கங்களைப் பெறுங்கள், உங்கள் சட்ட அறிவின் சிறந்த வடிவமாகுங்கள்.';

  @override
  String get authJoinSubtitle =>
      'நியாயாவில் சேர்ந்து உங்கள் சட்டக் கற்றல் பயணத்தைத் தொடங்குங்கள்';

  @override
  String get signInTitle => 'நியாயாவுக்கு மீண்டும் வரவேற்கிறோம்!';

  @override
  String get signInSubtitle =>
      'நியாயாவில் மீண்டும் இணைந்து உங்கள் சட்டக் கற்றல் பயணத்தைத் தொடருங்கள்';

  @override
  String get signInNoAccount => 'கணக்கு இல்லையா? ';

  @override
  String get signInPhoneMissing => 'உங்கள் தொலைபேசி எண்ணை உள்ளிடவும்.';

  @override
  String get signInPasswordMissing => 'உங்கள் கடவுச்சொல்லை உள்ளிடவும்.';

  @override
  String get fieldPhoneLabel => 'தொலைபேசி எண்';

  @override
  String get fieldPhoneHint => 'உங்கள் தொலைபேசி எண்ணை உள்ளிடவும்';

  @override
  String get fieldPasswordLabel => 'கடவுச்சொல்';

  @override
  String get fieldPasswordHintCreate => 'வலுவான கடவுச்சொல்லை உருவாக்கவும்';

  @override
  String get fieldPasswordHint => 'உங்கள் கடவுச்சொல்லை உள்ளிடவும்';

  @override
  String get showPassword => 'கடவுச்சொல்லைக் காட்டு';

  @override
  String get hidePassword => 'கடவுச்சொல்லை மறை';

  @override
  String get fieldFullNameLabel => 'முழு பெயர்';

  @override
  String get fieldFullNameHint => 'உங்கள் முழுப் பெயரை உள்ளிடவும்';

  @override
  String get fieldProfessionLabel => 'தொழில்';

  @override
  String get fieldProfessionHint => 'உங்கள் தொழிலைத் தேர்ந்தெடுக்கவும்';

  @override
  String get professionLawStudent => 'சட்ட மாணவர்';

  @override
  String get professionLawyer => 'வழக்கறிஞர்';

  @override
  String get professionJudge => 'நீதிபதி / நீதித்துறை அலுவலர்';

  @override
  String get professionLegalProfessional => 'சட்டத் துறை நிபுணர்';

  @override
  String get professionCitizen => 'பொதுமக்கள்';

  @override
  String get signUpTitle => 'உங்கள் கணக்கை உருவாக்குங்கள்';

  @override
  String get signUpSendOtp => 'OTP அனுப்பு';

  @override
  String get validationNameRequired => 'முழுப் பெயர் தேவை';

  @override
  String get validationNameTooShort =>
      'பெயர் குறைந்தது 3 எழுத்துகள் இருக்க வேண்டும்';

  @override
  String get validationProfessionRequired => 'தொழில் தேவை';

  @override
  String get validationPasswordRequired => 'கடவுச்சொல் தேவை';

  @override
  String get validationPasswordWeak =>
      'எழுத்துகளும் எண்களும் கொண்ட குறைந்தது 8 எழுத்துகளைப் பயன்படுத்தவும்';

  @override
  String get validationPhoneRequired => 'தொலைபேசி எண் தேவை';

  @override
  String get validationPhoneInvalid => 'சரியான தொலைபேசி எண்ணை உள்ளிடவும்';

  @override
  String get otpTitle => 'OTP ஐச் சரிபார்க்கவும்';

  @override
  String get otpSentTo => '6 இலக்க OTP இந்த எண்ணுக்கு அனுப்பப்பட்டது:';

  @override
  String get otpChange => 'மாற்று';

  @override
  String get otpEnter => 'OTP ஐ உள்ளிடவும்';

  @override
  String get otpNotReceived => 'OTP கிடைக்கவில்லையா?';

  @override
  String get otpResend => 'OTP ஐ மீண்டும் அனுப்பு';

  @override
  String get otpResending => 'மீண்டும் அனுப்புகிறது…';

  @override
  String otpResendIn(String time) {
    return '$time இல் OTP ஐ மீண்டும் அனுப்பலாம்';
  }

  @override
  String get otpTapToResend => 'மீண்டும் அனுப்ப தட்டவும்';

  @override
  String get otpVerifyContinue => 'சரிபார்த்து தொடரவும்';

  @override
  String get otpIncomplete => 'முழு 6 இலக்கக் குறியீட்டை உள்ளிடவும்.';

  @override
  String get otpSentAgain => 'புதிய OTP அனுப்பப்பட்டது.';

  @override
  String get authErrorInvalidPhone =>
      'இந்தத் தொலைபேசி எண் சரியாகத் தெரியவில்லை. சரிபார்த்து மீண்டும் முயற்சிக்கவும்.';

  @override
  String get authErrorTooManyRequests =>
      'அதிகமான முயற்சிகள். சிறிது நேரம் கழித்து மீண்டும் முயற்சிக்கவும்.';

  @override
  String get authErrorQuotaExceeded =>
      'தற்போதைக்கு SMS வரம்பு தீர்ந்துவிட்டது. பின்னர் முயற்சிக்கவும்.';

  @override
  String get authErrorInvalidCode =>
      'தவறான OTP. குறியீட்டைச் சரிபார்த்து மீண்டும் முயற்சிக்கவும்.';

  @override
  String get authErrorCodeExpired =>
      'இந்த OTP காலாவதியாகிவிட்டது. புதியதைக் கோரவும்.';

  @override
  String get authErrorUserDisabled =>
      'இந்தக் கணக்கு முடக்கப்பட்டுள்ளது. உதவியைத் தொடர்பு கொள்ளவும்.';

  @override
  String get authErrorNotEnabled =>
      'இந்தச் செயலியில் தொலைபேசி உள்நுழைவு இன்னும் இயக்கப்படவில்லை.';

  @override
  String get authErrorCredentialInUse =>
      'இந்தத் தொலைபேசி எண் ஏற்கனவே வேறு கணக்குடன் இணைக்கப்பட்டுள்ளது.';

  @override
  String get commonContinue => 'தொடரவும்';

  @override
  String get commonViewAll => 'அனைத்தையும் காண்க';

  @override
  String get commonResume => 'தொடரவும்';

  @override
  String questionCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count கேள்விகள்',
      one: '1 கேள்வி',
    );
    return '$_temp0';
  }

  @override
  String get difficultyEasy => 'எளிது';

  @override
  String get difficultyMedium => 'நடுத்தரம்';

  @override
  String get difficultyHard => 'கடினம்';

  @override
  String get goalHeadingLead => 'உங்களை நியாயாவிற்கு';

  @override
  String get goalHeadingAccent => 'அழைத்து வந்தது எது?';

  @override
  String get goalSubtitle =>
      'உங்கள் இலக்கைத் தேர்ந்தெடுங்கள் — எப்போது வேண்டுமானாலும் மாற்றலாம்.';

  @override
  String get goalFootnote => 'பின்னர் சுயவிவரத்தில் இலக்கை மாற்றலாம்.';

  @override
  String get goalLearnLawTitle => 'வாழ்க்கைக்கான சட்டம் கற்க';

  @override
  String get goalLearnLawBody =>
      'வேலை, குடும்பம் மற்றும் உங்கள் உரிமைகளுக்கான அன்றாட சட்ட அறிவு';

  @override
  String get goalExamTitle => 'தேர்வில் வெல்லுங்கள்';

  @override
  String get goalExamBody =>
      'தேர்வு பாணி MCQ பயிற்சி மற்றும் சட்டப் பிரிவுகளில் தேர்ச்சி பெறுங்கள்';

  @override
  String get goalStudyTitle => 'சட்டம் படிக்க';

  @override
  String get goalStudyBody =>
      'உங்கள் LLB பாடங்களை ஒவ்வொரு கருத்தாகக் கற்றுத் தேருங்கள்';

  @override
  String get homeHeroLead => 'உங்கள்';

  @override
  String get homeHeroAccent => 'சட்ட அறிவைச் சோதியுங்கள்.';

  @override
  String get homeHeroTrail => 'நீதியில் தேர்ச்சி பெறுங்கள்.';

  @override
  String get homeHeroSupport => 'சட்ட வினாடி வினாக்கள். வாழ்க்கைக்கான புரிதல்.';

  @override
  String get homeStartQuiz => 'வினாடி வினா தொடங்கு';

  @override
  String get homeNotifications => 'அறிவிப்புகள்';

  @override
  String get homeExploreByCategory => 'வகை வாரியாக ஆராயுங்கள்';

  @override
  String get homeContinueLearning => 'கற்றலைத் தொடரவும்';

  @override
  String get homePopularQuizzes => 'பிரபலமான வினாடி வினாக்கள்';

  @override
  String get homeDailyQuestions => 'தினசரி கேள்விகள்';

  @override
  String get homeDailyQuestionsSubtitle =>
      'இன்றைய சீரற்ற கேள்விகளுடன் உங்கள் மனதைக் கூர்மைப்படுத்துங்கள்';

  @override
  String get homeDailyQuestionsEmpty => 'இன்னும் கேள்விகள் இல்லை.';

  @override
  String get homeDailyShowAnswer => 'பதிலைக் காட்டு';

  @override
  String get homeDailyHideAnswer => 'பதிலை மறை';

  @override
  String homeDailyQuestionSemantics(
    int number,
    String question,
    String category,
  ) {
    return 'கேள்வி $number: $question. $category';
  }

  @override
  String get categoriesSubtitle =>
      'தலைப்புகளை ஆராய்ந்து உங்கள் சட்ட அறிவை வலுப்படுத்துங்கள்.';

  @override
  String get categoriesSearchHint => 'வகைகளைத் தேடுங்கள்';

  @override
  String get categoriesNoMatch => 'உங்கள் தேடலுக்குப் பொருந்தும் வகைகள் இல்லை.';

  @override
  String get categoriesFilters => 'வடிப்பான்கள்';

  @override
  String get topicBookmark => 'தலைப்பைப் புக்மார்க் செய்';

  @override
  String get topicRemoveBookmark => 'புக்மார்க்கை நீக்கு';

  @override
  String get topicQuizzesHeading => 'வினாடி வினாக்கள்';

  @override
  String topicContinueQuiz(int number) {
    return 'வினாடி வினா $number தொடரவும்';
  }

  @override
  String get quizStatusCompleted => 'முடிந்தது';

  @override
  String get quizStatusInProgress => 'நடந்துகொண்டிருக்கிறது';

  @override
  String get quizStatusNotStarted => 'தொடங்கவில்லை';

  @override
  String topicQuizSemantics(
    String title,
    int count,
    String difficulty,
    String status,
  ) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count கேள்விகள்',
      one: '1 கேள்வி',
    );
    return '$title. $_temp0, $difficulty. $status';
  }

  @override
  String get quizExit => 'வினாடி வினாவிலிருந்து வெளியேறு';

  @override
  String quizCounter(int current, int total) {
    return 'கேள்வி $current / $total';
  }

  @override
  String get quizSelectAnswer => 'ஒரு பதிலைத் தேர்ந்தெடுங்கள்';

  @override
  String quizOptionLabel(String letter, String text) {
    return 'விருப்பம் $letter. $text';
  }

  @override
  String get quizYourAnswerCorrect => 'உங்கள் பதில், சரி';

  @override
  String get quizYourAnswerWrong => 'உங்கள் பதில், தவறு';

  @override
  String get quizCorrectAnswer => 'சரியான பதில்';

  @override
  String get quizVerdictCorrect => 'சரி!';

  @override
  String get quizVerdictWrong => 'சரியில்லை';

  @override
  String get resultHeadline => 'அருமை!';

  @override
  String resultCompleted(String topic) {
    return '$topic — முடிந்தது';
  }

  @override
  String get resultThisTopic => 'இந்தத் தலைப்பு';

  @override
  String resultScoreSemantics(String score, String percent) {
    return 'உங்கள் மதிப்பெண்: $score, $percent';
  }

  @override
  String get resultCorrect => 'சரி';

  @override
  String get resultWrong => 'தவறு';

  @override
  String resultCorrectCount(int count) {
    return '$count சரி';
  }

  @override
  String resultWrongCount(int count) {
    return '$count தவறு';
  }

  @override
  String resultWeakList(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count கேள்விகள் உங்கள் பலவீனப் பட்டியலில் சேர்க்கப்பட்டன.',
      one: '1 கேள்வி உங்கள் பலவீனப் பட்டியலில் சேர்க்கப்பட்டது.',
    );
    return '$_temp0';
  }

  @override
  String get resultReviewAnswers => 'பதில்களை மதிப்பாய்வு செய்';

  @override
  String get resultBackToTopic => 'தலைப்புக்குத் திரும்பு';

  @override
  String get legalUpdatesTitle => 'சட்ட புதுப்பிப்புகள்';

  @override
  String get legalUpdatesEmpty => 'சட்ட புதுப்பிப்புகள் எதுவும் இல்லை.';

  @override
  String get legalUpdatesCategoryJudgements => 'தீர்ப்புகள்';

  @override
  String get legalUpdatesCategoryLegislation => 'சட்டமியற்றுதல்';

  @override
  String get legalUpdatesCategoryReforms => 'சீர்திருத்தங்கள்';

  @override
  String get legalUpdatesCategoryNotices => 'அறிவிப்புகள்';

  @override
  String get commonSoon => 'விரைவில்';

  @override
  String homeProgressQuizzesCompleted(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count வினாடி வினாக்கள் முடிந்தன',
      one: '1 வினாடி வினா முடிந்தது',
    );
    return '$_temp0';
  }

  @override
  String homeProgressPoints(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count புள்ளிகள்',
      one: '1 புள்ளி',
    );
    return '$_temp0';
  }

  @override
  String homeProgressAccuracy(int percent) {
    return 'துல்லியம் $percent%';
  }

  @override
  String get homeProgressEmpty =>
      'இன்னும் வினாடி வினா இல்லை. உங்கள் முதல் வினாடி வினாவை எழுதுங்கள்!';

  @override
  String get homeAskNyayaTitle => 'நியாயா-விடம் கேளுங்கள்';

  @override
  String get homeAskNyayaBody =>
      'உங்கள் சட்ட கேள்விகளை எளிய மொழியில் கேளுங்கள். தெளிவான பதில்கள் பெறுங்கள்.';

  @override
  String get homeRecommended => 'உங்களுக்கான பரிந்துரைகள்';

  @override
  String get articlesHeroTitle => 'கற்றுக்கொண்டு புதுப்பித்த நிலையில் இருங்கள்';

  @override
  String get articlesHeroSubtitle =>
      'தகவலறிந்திருங்கள். சட்டத்தைப் புரிந்துகொள்ளுங்கள்.';

  @override
  String articlesPart(String part, String title) {
    return 'பகுதி $part · $title';
  }

  @override
  String get articlesEmpty => 'கட்டுரைகள் எதுவும் இல்லை.';

  @override
  String get articlesReadArticle => 'கட்டுரையைப் படியுங்கள்';

  @override
  String get articleWhatItMeans => 'இதன் பொருள் என்ன';

  @override
  String get articleWhyItMatters => 'இது ஏன் முக்கியம்';

  @override
  String get articleKeyFeatures => 'முக்கிய அம்சங்கள்';

  @override
  String get profileStatsTitle => 'எனது புள்ளிவிவரங்கள்';

  @override
  String get profileStatStreak => 'நாள் தொடர்ச்சி';

  @override
  String get profileStatCategories => 'ஆராயப்பட்ட வகைகள்';

  @override
  String get profileStatQuizzes => 'முடிக்கப்பட்ட வினாடி வினாக்கள்';

  @override
  String get profileStatPoints => 'பெறப்பட்ட புள்ளிகள்';

  @override
  String get profileEdit => 'சுயவிவரத்தைத் திருத்து';

  @override
  String get profileSettingsTitle => 'கணக்கு & அமைப்புகள்';

  @override
  String get profileLanguage => 'மொழி';

  @override
  String get profileReminders => 'தினசரி நினைவூட்டல்கள்';

  @override
  String get profilePrivacy => 'தனியுரிமை & பாதுகாப்பு';

  @override
  String get profileHelpSupport => 'உதவி & ஆதரவு';

  @override
  String get profileHelpResources => 'சட்ட உதவி ஆதாரங்கள்';

  @override
  String get profileAbout => 'நியாயா பற்றி';

  @override
  String get profileLogout => 'வெளியேறு';

  @override
  String get profileLogoutConfirmTitle => 'நியாயாவிலிருந்து வெளியேறவா?';

  @override
  String get profileLogoutConfirmBody =>
      'மீண்டும் உள்நுழைய உங்கள் தொலைபேசி எண்ணும் குறியீடும் தேவை.';

  @override
  String get editProfileSave => 'மாற்றங்களைச் சேமி';

  @override
  String get editProfileSaved => 'சுயவிவரம் புதுப்பிக்கப்பட்டது';

  @override
  String get editProfileChangePhoto => 'புகைப்படத்தை மாற்று';

  @override
  String get editProfileCamera => 'புகைப்படம் எடு';

  @override
  String get editProfileGallery => 'கேலரியிலிருந்து தேர்வு செய்';

  @override
  String get editProfilePhotoUpdated => 'புகைப்படம் புதுப்பிக்கப்பட்டது';

  @override
  String get editProfilePhotoFailed =>
      'கேமரா அல்லது புகைப்படங்களைத் திறக்க முடியவில்லை. நியாயாவின் அனுமதிகளைச் சரிபார்க்கவும்.';

  @override
  String get remindersToggle => 'தினசரி நினைவூட்டல்';

  @override
  String get remindersToggleSubtitle =>
      'தினமும் பயிற்சி செய்ய நினைவூட்டல் பெறுங்கள்';

  @override
  String get remindersTime => 'நினைவூட்டல் நேரம்';

  @override
  String get remindersPermissionDenied =>
      'நியாயாவுக்கு அறிவிப்புகள் முடக்கப்பட்டுள்ளன. நினைவூட்டல்களைப் பெற உங்கள் தொலைபேசி அமைப்புகளில் அவற்றை இயக்கவும்.';

  @override
  String get reminderNotificationBody =>
      'உங்கள் தினசரி சட்டப் பயிற்சிக்கான நேரம் — தொடர்ச்சியைத் தக்கவைத்துக் கொள்ளுங்கள்.';
}
