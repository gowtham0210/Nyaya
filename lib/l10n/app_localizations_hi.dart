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
  String quizCount(int count) {
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

  @override
  String get brandTagline => 'कानून आधारित क्विज़ ऐप';

  @override
  String get splashSemanticsLabel => 'न्याय स्प्लैश स्क्रीन';

  @override
  String get splashTapToContinue => 'आगे बढ़ने के लिए टैप करें';

  @override
  String get splashLoadingLabel => 'न्याय लोड हो रहा है';

  @override
  String splashLoadingValue(int percent) {
    return '$percent प्रतिशत';
  }

  @override
  String get commonGetStarted => 'शुरू करें';

  @override
  String get commonSkip => 'छोड़ें';

  @override
  String get commonNext => 'आगे';

  @override
  String get commonSignIn => 'साइन इन करें';

  @override
  String get commonLogin => 'लॉगिन';

  @override
  String get commonSignUp => 'साइन अप';

  @override
  String get commonHaveAccount => 'पहले से खाता है? ';

  @override
  String get welcomeHeadlineLine1 => 'कानून हुआ आसान,';

  @override
  String get welcomeHeadlineLine2 => 'न्याय हुआ सुलभ।';

  @override
  String get welcomeBody =>
      'कानूनों को जानें, अपने ज्ञान को परखें, और खुद अपने कानूनी विशेषज्ञ बनें।';

  @override
  String get welcomeLearnTitle => 'कानून सीखें';

  @override
  String get welcomeLearnBody =>
      'महत्वपूर्ण कानूनों को सरल भाषा में जानें और समझें।';

  @override
  String get welcomeRightsTitle => 'अपने अधिकार जानें';

  @override
  String get welcomeRightsBody =>
      'अपने कानूनी अधिकारों के बारे में जानकार और सशक्त रहें।';

  @override
  String get welcomeTrackTitle => 'ट्रैक करें और अपडेट रहें';

  @override
  String get welcomeTrackBody =>
      'मामले की स्थिति ट्रैक करें और ताज़ा कानूनी अपडेट आसानी से पाएँ।';

  @override
  String get onboarding1Line1 => 'अपना ज्ञान परखें।';

  @override
  String get onboarding1Line2 => 'न्याय में महारत पाएँ।';

  @override
  String get onboarding2Line1 => 'सीखें। समझें।';

  @override
  String get onboarding2Line2 => 'कानून लागू करें।';

  @override
  String get onboarding2Body =>
      'न्याय ऐप मामलों पर आधारित क्विज़, वास्तविक जीवन की स्थितियों और विशेषज्ञों द्वारा तैयार सामग्री से कानूनी पढ़ाई आसान बनाता है।';

  @override
  String get onboarding3Line1 => 'प्रगति ट्रैक करें।';

  @override
  String get onboarding3Line2 => 'उत्कृष्टता पाएँ।';

  @override
  String get onboarding3Body =>
      'अपना प्रदर्शन ट्रैक करें, लगातार सीखने की लय बनाएँ, बैज कमाएँ और अपने कानूनी ज्ञान का सर्वश्रेष्ठ रूप बनें।';

  @override
  String get authJoinSubtitle =>
      'न्याय से जुड़ें और अपनी कानूनी सीखने की यात्रा शुरू करें';

  @override
  String get signInTitle => 'न्याय में फिर से स्वागत है!';

  @override
  String get signInSubtitle =>
      'न्याय में फिर से जुड़ें और अपनी कानूनी सीखने की यात्रा जारी रखें';

  @override
  String get signInNoAccount => 'खाता नहीं है? ';

  @override
  String get signInPhoneMissing => 'अपना फ़ोन नंबर दर्ज करें।';

  @override
  String get signInPasswordMissing => 'अपना पासवर्ड दर्ज करें।';

  @override
  String get fieldPhoneLabel => 'फ़ोन नंबर';

  @override
  String get fieldPhoneHint => 'अपना फ़ोन नंबर दर्ज करें';

  @override
  String get fieldPasswordLabel => 'पासवर्ड';

  @override
  String get fieldPasswordHintCreate => 'एक मज़बूत पासवर्ड बनाएँ';

  @override
  String get fieldPasswordHint => 'अपना पासवर्ड दर्ज करें';

  @override
  String get showPassword => 'पासवर्ड दिखाएँ';

  @override
  String get hidePassword => 'पासवर्ड छिपाएँ';

  @override
  String get fieldFullNameLabel => 'पूरा नाम';

  @override
  String get fieldFullNameHint => 'अपना पूरा नाम दर्ज करें';

  @override
  String get fieldProfessionLabel => 'पेशा';

  @override
  String get fieldProfessionHint => 'अपना पेशा चुनें';

  @override
  String get professionLawStudent => 'कानून का छात्र';

  @override
  String get professionLawyer => 'वकील / अधिवक्ता';

  @override
  String get professionJudge => 'न्यायाधीश / न्यायिक अधिकारी';

  @override
  String get professionLegalProfessional => 'कानूनी पेशेवर';

  @override
  String get professionCitizen => 'आम नागरिक';

  @override
  String get signUpTitle => 'अपना खाता बनाएँ';

  @override
  String get signUpSendOtp => 'OTP भेजें';

  @override
  String get validationNameRequired => 'पूरा नाम आवश्यक है';

  @override
  String get validationNameTooShort => 'नाम कम से कम 3 अक्षरों का होना चाहिए';

  @override
  String get validationProfessionRequired => 'पेशा आवश्यक है';

  @override
  String get validationPasswordRequired => 'पासवर्ड आवश्यक है';

  @override
  String get validationPasswordWeak =>
      'अक्षरों और अंकों के साथ कम से कम 8 वर्ण रखें';

  @override
  String get validationPhoneRequired => 'फ़ोन नंबर आवश्यक है';

  @override
  String get validationPhoneInvalid => 'मान्य फ़ोन नंबर दर्ज करें';

  @override
  String get otpTitle => 'OTP सत्यापित करें';

  @override
  String get otpSentTo => '6 अंकों का OTP इस नंबर पर भेजा गया है:';

  @override
  String get otpChange => 'बदलें';

  @override
  String get otpEnter => 'OTP दर्ज करें';

  @override
  String get otpNotReceived => 'OTP नहीं मिला?';

  @override
  String get otpResend => 'OTP फिर से भेजें';

  @override
  String get otpResending => 'फिर से भेजा जा रहा है…';

  @override
  String otpResendIn(String time) {
    return '$time में OTP फिर से भेजें';
  }

  @override
  String get otpTapToResend => 'फिर से भेजने के लिए टैप करें';

  @override
  String get otpVerifyContinue => 'सत्यापित करें और आगे बढ़ें';

  @override
  String get otpIncomplete => 'पूरा 6 अंकों का कोड दर्ज करें।';

  @override
  String get otpSentAgain => 'नया OTP भेज दिया गया है।';

  @override
  String get authErrorInvalidPhone =>
      'यह फ़ोन नंबर सही नहीं लगता। कृपया जाँचें और पुनः प्रयास करें।';

  @override
  String get authErrorTooManyRequests =>
      'बहुत अधिक प्रयास। कृपया कुछ देर बाद फिर प्रयास करें।';

  @override
  String get authErrorQuotaExceeded =>
      'अभी के लिए SMS सीमा पूरी हो गई है। कृपया बाद में प्रयास करें।';

  @override
  String get authErrorInvalidCode =>
      'गलत OTP। कृपया कोड जाँचें और पुनः प्रयास करें।';

  @override
  String get authErrorCodeExpired =>
      'यह OTP समाप्त हो गया है। कृपया नया OTP मँगाएँ।';

  @override
  String get authErrorUserDisabled =>
      'यह खाता निष्क्रिय कर दिया गया है। कृपया सहायता से संपर्क करें।';

  @override
  String get authErrorNotEnabled =>
      'इस ऐप के लिए फ़ोन साइन-इन अभी चालू नहीं है।';

  @override
  String get authErrorCredentialInUse =>
      'यह फ़ोन नंबर पहले से किसी दूसरे खाते से जुड़ा है।';

  @override
  String get commonContinue => 'जारी रखें';

  @override
  String get commonViewAll => 'सभी देखें';

  @override
  String get commonResume => 'फिर से शुरू करें';

  @override
  String questionCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count प्रश्न',
      one: '1 प्रश्न',
    );
    return '$_temp0';
  }

  @override
  String get difficultyEasy => 'आसान';

  @override
  String get difficultyMedium => 'मध्यम';

  @override
  String get difficultyHard => 'कठिन';

  @override
  String get goalHeadingLead => 'आपको न्याय पर';

  @override
  String get goalHeadingAccent => 'क्या लाया?';

  @override
  String get goalSubtitle => 'अपना लक्ष्य चुनें — आप इसे कभी भी बदल सकते हैं।';

  @override
  String get goalFootnote => 'आप बाद में प्रोफ़ाइल में लक्ष्य बदल सकते हैं।';

  @override
  String get goalLearnLawTitle => 'जीवन के लिए कानून सीखें';

  @override
  String get goalLearnLawBody =>
      'काम, परिवार और आपके अधिकारों के लिए रोज़मर्रा की कानूनी समझ';

  @override
  String get goalExamTitle => 'परीक्षा पास करें';

  @override
  String get goalExamBody =>
      'परीक्षा जैसे MCQ अभ्यास और क़ानूनी धाराओं पर पकड़ मज़बूत करें';

  @override
  String get goalStudyTitle => 'कानून की पढ़ाई';

  @override
  String get goalStudyBody => 'अपने LLB विषयों को एक-एक अवधारणा से समझें';

  @override
  String get homeHeroLead => 'अपने';

  @override
  String get homeHeroAccent => 'कानूनी ज्ञान को परखें।';

  @override
  String get homeHeroTrail => 'न्याय में महारत पाएँ।';

  @override
  String get homeHeroSupport => 'कानून पर क्विज़। जीवन के लिए समझ।';

  @override
  String get homeStartQuiz => 'क्विज़ शुरू करें';

  @override
  String get homeNotifications => 'सूचनाएं';

  @override
  String get homeExploreByCategory => 'श्रेणी के अनुसार देखें';

  @override
  String get homeContinueLearning => 'पढ़ाई जारी रखें';

  @override
  String get homePopularQuizzes => 'लोकप्रिय क्विज़';

  @override
  String get homeDailyQuestions => 'दैनिक प्रश्न';

  @override
  String get homeDailyQuestionsSubtitle =>
      'आज के रैंडम प्रश्नों से अपने दिमाग को तेज़ करें';

  @override
  String get homeDailyQuestionsEmpty => 'अभी तक कोई प्रश्न उपलब्ध नहीं है।';

  @override
  String get homeDailyShowAnswer => 'उत्तर देखें';

  @override
  String get homeDailyHideAnswer => 'उत्तर छिपाएँ';

  @override
  String homeDailyQuestionSemantics(
    int number,
    String question,
    String category,
  ) {
    return 'प्रश्न $number: $question। $category';
  }

  @override
  String get categoriesSubtitle =>
      'विषयों को जानें और अपना कानूनी ज्ञान मज़बूत करें।';

  @override
  String get categoriesSearchHint => 'श्रेणियाँ खोजें';

  @override
  String get categoriesNoMatch => 'आपकी खोज से कोई श्रेणी मेल नहीं खाती।';

  @override
  String get categoriesFilters => 'फ़िल्टर';

  @override
  String get topicBookmark => 'विषय बुकमार्क करें';

  @override
  String get topicRemoveBookmark => 'बुकमार्क हटाएँ';

  @override
  String get topicQuizzesHeading => 'क्विज़';

  @override
  String topicContinueQuiz(int number) {
    return 'क्विज़ $number जारी रखें';
  }

  @override
  String get quizStatusCompleted => 'पूर्ण';

  @override
  String get quizStatusInProgress => 'जारी है';

  @override
  String get quizStatusNotStarted => 'शुरू नहीं हुआ';

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
      other: '$count प्रश्न',
      one: '1 प्रश्न',
    );
    return '$title. $_temp0, $difficulty. $status';
  }

  @override
  String get quizExit => 'क्विज़ से बाहर निकलें';

  @override
  String quizCounter(int current, int total) {
    return 'प्रश्न $current / $total';
  }

  @override
  String get quizSelectAnswer => 'एक उत्तर चुनें';

  @override
  String quizOptionLabel(String letter, String text) {
    return 'विकल्प $letter. $text';
  }

  @override
  String get quizYourAnswerCorrect => 'आपका उत्तर, सही';

  @override
  String get quizYourAnswerWrong => 'आपका उत्तर, गलत';

  @override
  String get quizCorrectAnswer => 'सही उत्तर';

  @override
  String get quizVerdictCorrect => 'सही!';

  @override
  String get quizVerdictWrong => 'पूरी तरह सही नहीं';

  @override
  String get resultHeadline => 'बहुत बढ़िया!';

  @override
  String resultCompleted(String topic) {
    return '$topic — पूर्ण';
  }

  @override
  String get resultThisTopic => 'यह विषय';

  @override
  String resultScoreSemantics(String score, String percent) {
    return 'आपका स्कोर: $score, $percent';
  }

  @override
  String get resultCorrect => 'सही';

  @override
  String get resultWrong => 'गलत';

  @override
  String resultCorrectCount(int count) {
    return '$count सही';
  }

  @override
  String resultWrongCount(int count) {
    return '$count गलत';
  }

  @override
  String resultWeakList(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count प्रश्न आपकी कमज़ोर सूची में जोड़े गए।',
      one: '1 प्रश्न आपकी कमज़ोर सूची में जोड़ा गया।',
    );
    return '$_temp0';
  }

  @override
  String get resultReviewAnswers => 'उत्तर देखें';

  @override
  String get resultBackToTopic => 'विषय पर वापस';

  @override
  String get legalUpdatesTitle => 'कानूनी अपडेट';

  @override
  String get legalUpdatesEmpty => 'कोई कानूनी अपडेट उपलब्ध नहीं है।';

  @override
  String get legalUpdatesCategoryJudgements => 'न्यायादेश';

  @override
  String get legalUpdatesCategoryLegislation => 'विधान';

  @override
  String get legalUpdatesCategoryReforms => 'सुधार';

  @override
  String get legalUpdatesCategoryNotices => 'सूचनाएं';
}
