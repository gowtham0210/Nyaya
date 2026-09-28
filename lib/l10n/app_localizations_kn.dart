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
  String quizCount(int count) {
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

  @override
  String get brandTagline => 'ಕಾನೂನು ಆಧಾರಿತ ಕ್ವಿಜ್ ಆ್ಯಪ್';

  @override
  String get splashSemanticsLabel => 'ನ್ಯಾಯ ಆರಂಭಿಕ ಪರದೆ';

  @override
  String get splashTapToContinue => 'ಮುಂದುವರಿಯಲು ಟ್ಯಾಪ್ ಮಾಡಿ';

  @override
  String get splashLoadingLabel => 'ನ್ಯಾಯ ಲೋಡ್ ಆಗುತ್ತಿದೆ';

  @override
  String splashLoadingValue(int percent) {
    return 'ಶೇಕಡ $percent';
  }

  @override
  String get commonGetStarted => 'ಪ್ರಾರಂಭಿಸಿ';

  @override
  String get commonSkip => 'ಬಿಟ್ಟುಬಿಡಿ';

  @override
  String get commonNext => 'ಮುಂದೆ';

  @override
  String get commonSignIn => 'ಸೈನ್ ಇನ್ ಮಾಡಿ';

  @override
  String get commonLogin => 'ಲಾಗಿನ್';

  @override
  String get commonSignUp => 'ಸೈನ್ ಅಪ್';

  @override
  String get commonHaveAccount => 'ಈಗಾಗಲೇ ಖಾತೆ ಇದೆಯೇ? ';

  @override
  String get welcomeHeadlineLine1 => 'ಕಾನೂನು ಸುಲಭ,';

  @override
  String get welcomeHeadlineLine2 => 'ನ್ಯಾಯ ಎಲ್ಲರಿಗೂ ಲಭ್ಯ.';

  @override
  String get welcomeBody =>
      'ಕಾನೂನುಗಳನ್ನು ತಿಳಿಯಿರಿ, ನಿಮ್ಮ ಜ್ಞಾನವನ್ನು ಪರೀಕ್ಷಿಸಿ, ನೀವೇ ನಿಮ್ಮ ಕಾನೂನು ತಜ್ಞರಾಗಿ.';

  @override
  String get welcomeLearnTitle => 'ಕಾನೂನುಗಳನ್ನು ಕಲಿಯಿರಿ';

  @override
  String get welcomeLearnBody =>
      'ಮುಖ್ಯ ಕಾನೂನುಗಳನ್ನು ಸರಳ ಭಾಷೆಯಲ್ಲಿ ತಿಳಿದು ಅರ್ಥಮಾಡಿಕೊಳ್ಳಿ.';

  @override
  String get welcomeRightsTitle => 'ನಿಮ್ಮ ಹಕ್ಕುಗಳನ್ನು ತಿಳಿಯಿರಿ';

  @override
  String get welcomeRightsBody =>
      'ನಿಮ್ಮ ಕಾನೂನು ಹಕ್ಕುಗಳ ಬಗ್ಗೆ ತಿಳಿದು ಸಶಕ್ತರಾಗಿರಿ.';

  @override
  String get welcomeTrackTitle => 'ಟ್ರ್ಯಾಕ್ ಮಾಡಿ, ನವೀಕೃತವಾಗಿರಿ';

  @override
  String get welcomeTrackBody =>
      'ಪ್ರಕರಣದ ಸ್ಥಿತಿಯನ್ನು ಟ್ರ್ಯಾಕ್ ಮಾಡಿ ಮತ್ತು ಇತ್ತೀಚಿನ ಕಾನೂನು ಮಾಹಿತಿಯನ್ನು ಸುಲಭವಾಗಿ ಪಡೆಯಿರಿ.';

  @override
  String get onboarding1Line1 => 'ನಿಮ್ಮ ಜ್ಞಾನವನ್ನು ಪರೀಕ್ಷಿಸಿ.';

  @override
  String get onboarding1Line2 => 'ನ್ಯಾಯದಲ್ಲಿ ಪರಿಣತಿ ಪಡೆಯಿರಿ.';

  @override
  String get onboarding2Line1 => 'ಕಲಿಯಿರಿ. ಅರ್ಥಮಾಡಿಕೊಳ್ಳಿ.';

  @override
  String get onboarding2Line2 => 'ಕಾನೂನನ್ನು ಅನ್ವಯಿಸಿ.';

  @override
  String get onboarding2Body =>
      'ಪ್ರಕರಣ ಆಧಾರಿತ ಕ್ವಿಜ್‌ಗಳು, ನಿಜ ಜೀವನದ ಸನ್ನಿವೇಶಗಳು ಮತ್ತು ತಜ್ಞರು ರೂಪಿಸಿದ ವಿಷಯದೊಂದಿಗೆ ನ್ಯಾಯ ಆ್ಯಪ್ ಕಾನೂನು ಕಲಿಕೆಯನ್ನು ಸುಲಭಗೊಳಿಸುತ್ತದೆ.';

  @override
  String get onboarding3Line1 => 'ಪ್ರಗತಿಯನ್ನು ಟ್ರ್ಯಾಕ್ ಮಾಡಿ.';

  @override
  String get onboarding3Line2 => 'ಶ್ರೇಷ್ಠತೆಯನ್ನು ಸಾಧಿಸಿ.';

  @override
  String get onboarding3Body =>
      'ನಿಮ್ಮ ಸಾಧನೆಯನ್ನು ಟ್ರ್ಯಾಕ್ ಮಾಡಿ, ನಿರಂತರತೆ ಬೆಳೆಸಿ, ಬ್ಯಾಡ್ಜ್‌ಗಳನ್ನು ಗಳಿಸಿ ಮತ್ತು ನಿಮ್ಮ ಕಾನೂನು ಜ್ಞಾನದ ಅತ್ಯುತ್ತಮ ರೂಪವಾಗಿ.';

  @override
  String get authJoinSubtitle =>
      'ನ್ಯಾಯಕ್ಕೆ ಸೇರಿ ಮತ್ತು ನಿಮ್ಮ ಕಾನೂನು ಕಲಿಕೆಯ ಪ್ರಯಾಣವನ್ನು ಆರಂಭಿಸಿ';

  @override
  String get signInTitle => 'ನ್ಯಾಯಕ್ಕೆ ಮರಳಿ ಸ್ವಾಗತ!';

  @override
  String get signInSubtitle =>
      'ನ್ಯಾಯಕ್ಕೆ ಮತ್ತೆ ಸೇರಿ ಮತ್ತು ನಿಮ್ಮ ಕಾನೂನು ಕಲಿಕೆಯ ಪ್ರಯಾಣವನ್ನು ಮುಂದುವರಿಸಿ';

  @override
  String get signInNoAccount => 'ಖಾತೆ ಇಲ್ಲವೇ? ';

  @override
  String get signInPhoneMissing => 'ನಿಮ್ಮ ಫೋನ್ ಸಂಖ್ಯೆಯನ್ನು ನಮೂದಿಸಿ.';

  @override
  String get signInPasswordMissing => 'ನಿಮ್ಮ ಪಾಸ್‌ವರ್ಡ್ ನಮೂದಿಸಿ.';

  @override
  String get fieldPhoneLabel => 'ಫೋನ್ ಸಂಖ್ಯೆ';

  @override
  String get fieldPhoneHint => 'ನಿಮ್ಮ ಫೋನ್ ಸಂಖ್ಯೆಯನ್ನು ನಮೂದಿಸಿ';

  @override
  String get fieldPasswordLabel => 'ಪಾಸ್‌ವರ್ಡ್';

  @override
  String get fieldPasswordHintCreate => 'ಬಲವಾದ ಪಾಸ್‌ವರ್ಡ್ ರಚಿಸಿ';

  @override
  String get fieldPasswordHint => 'ನಿಮ್ಮ ಪಾಸ್‌ವರ್ಡ್ ನಮೂದಿಸಿ';

  @override
  String get showPassword => 'ಪಾಸ್‌ವರ್ಡ್ ತೋರಿಸಿ';

  @override
  String get hidePassword => 'ಪಾಸ್‌ವರ್ಡ್ ಮರೆಮಾಡಿ';

  @override
  String get fieldFullNameLabel => 'ಪೂರ್ಣ ಹೆಸರು';

  @override
  String get fieldFullNameHint => 'ನಿಮ್ಮ ಪೂರ್ಣ ಹೆಸರನ್ನು ನಮೂದಿಸಿ';

  @override
  String get fieldProfessionLabel => 'ವೃತ್ತಿ';

  @override
  String get fieldProfessionHint => 'ನಿಮ್ಮ ವೃತ್ತಿಯನ್ನು ಆಯ್ಕೆಮಾಡಿ';

  @override
  String get professionLawStudent => 'ಕಾನೂನು ವಿದ್ಯಾರ್ಥಿ';

  @override
  String get professionLawyer => 'ವಕೀಲ';

  @override
  String get professionJudge => 'ನ್ಯಾಯಾಧೀಶ / ನ್ಯಾಯಾಂಗ ಅಧಿಕಾರಿ';

  @override
  String get professionLegalProfessional => 'ಕಾನೂನು ವೃತ್ತಿಪರ';

  @override
  String get professionCitizen => 'ಸಾಮಾನ್ಯ ನಾಗರಿಕ';

  @override
  String get signUpTitle => 'ನಿಮ್ಮ ಖಾತೆಯನ್ನು ರಚಿಸಿ';

  @override
  String get signUpSendOtp => 'OTP ಕಳುಹಿಸಿ';

  @override
  String get validationNameRequired => 'ಪೂರ್ಣ ಹೆಸರು ಅಗತ್ಯ';

  @override
  String get validationNameTooShort => 'ಹೆಸರು ಕನಿಷ್ಠ 3 ಅಕ್ಷರಗಳಿರಬೇಕು';

  @override
  String get validationProfessionRequired => 'ವೃತ್ತಿ ಅಗತ್ಯ';

  @override
  String get validationPasswordRequired => 'ಪಾಸ್‌ವರ್ಡ್ ಅಗತ್ಯ';

  @override
  String get validationPasswordWeak =>
      'ಅಕ್ಷರಗಳು ಮತ್ತು ಸಂಖ್ಯೆಗಳೊಂದಿಗೆ ಕನಿಷ್ಠ 8 ಅಕ್ಷರಗಳನ್ನು ಬಳಸಿ';

  @override
  String get validationPhoneRequired => 'ಫೋನ್ ಸಂಖ್ಯೆ ಅಗತ್ಯ';

  @override
  String get validationPhoneInvalid => 'ಮಾನ್ಯ ಫೋನ್ ಸಂಖ್ಯೆಯನ್ನು ನಮೂದಿಸಿ';

  @override
  String get otpTitle => 'OTP ಪರಿಶೀಲಿಸಿ';

  @override
  String get otpSentTo => '6 ಅಂಕಿಯ OTP ಈ ಸಂಖ್ಯೆಗೆ ಕಳುಹಿಸಲಾಗಿದೆ:';

  @override
  String get otpChange => 'ಬದಲಾಯಿಸಿ';

  @override
  String get otpEnter => 'OTP ನಮೂದಿಸಿ';

  @override
  String get otpNotReceived => 'OTP ಬರಲಿಲ್ಲವೇ?';

  @override
  String get otpResend => 'OTP ಮತ್ತೆ ಕಳುಹಿಸಿ';

  @override
  String get otpResending => 'ಮತ್ತೆ ಕಳುಹಿಸಲಾಗುತ್ತಿದೆ…';

  @override
  String otpResendIn(String time) {
    return '$time ನಲ್ಲಿ OTP ಮತ್ತೆ ಕಳುಹಿಸಬಹುದು';
  }

  @override
  String get otpTapToResend => 'ಮತ್ತೆ ಕಳುಹಿಸಲು ಟ್ಯಾಪ್ ಮಾಡಿ';

  @override
  String get otpVerifyContinue => 'ಪರಿಶೀಲಿಸಿ ಮುಂದುವರಿಯಿರಿ';

  @override
  String get otpIncomplete => 'ಪೂರ್ಣ 6 ಅಂಕಿಯ ಕೋಡ್ ನಮೂದಿಸಿ.';

  @override
  String get otpSentAgain => 'ಹೊಸ OTP ಕಳುಹಿಸಲಾಗಿದೆ.';

  @override
  String get authErrorInvalidPhone =>
      'ಈ ಫೋನ್ ಸಂಖ್ಯೆ ಸರಿಯಾಗಿಲ್ಲ. ದಯವಿಟ್ಟು ಪರಿಶೀಲಿಸಿ ಮತ್ತೆ ಪ್ರಯತ್ನಿಸಿ.';

  @override
  String get authErrorTooManyRequests =>
      'ಹಲವಾರು ಪ್ರಯತ್ನಗಳು. ಸ್ವಲ್ಪ ಸಮಯದ ನಂತರ ಮತ್ತೆ ಪ್ರಯತ್ನಿಸಿ.';

  @override
  String get authErrorQuotaExceeded =>
      'ಸದ್ಯಕ್ಕೆ SMS ಮಿತಿ ಮೀರಿದೆ. ದಯವಿಟ್ಟು ನಂತರ ಪ್ರಯತ್ನಿಸಿ.';

  @override
  String get authErrorInvalidCode =>
      'ತಪ್ಪಾದ OTP. ದಯವಿಟ್ಟು ಕೋಡ್ ಪರಿಶೀಲಿಸಿ ಮತ್ತೆ ಪ್ರಯತ್ನಿಸಿ.';

  @override
  String get authErrorCodeExpired =>
      'ಈ OTP ಅವಧಿ ಮುಗಿದಿದೆ. ದಯವಿಟ್ಟು ಹೊಸದನ್ನು ಕೇಳಿ.';

  @override
  String get authErrorUserDisabled =>
      'ಈ ಖಾತೆಯನ್ನು ನಿಷ್ಕ್ರಿಯಗೊಳಿಸಲಾಗಿದೆ. ದಯವಿಟ್ಟು ಸಹಾಯವನ್ನು ಸಂಪರ್ಕಿಸಿ.';

  @override
  String get authErrorNotEnabled =>
      'ಈ ಆ್ಯಪ್‌ಗೆ ಫೋನ್ ಸೈನ್-ಇನ್ ಇನ್ನೂ ಸಕ್ರಿಯಗೊಂಡಿಲ್ಲ.';

  @override
  String get authErrorCredentialInUse =>
      'ಈ ಫೋನ್ ಸಂಖ್ಯೆ ಈಗಾಗಲೇ ಬೇರೆ ಖಾತೆಗೆ ಲಿಂಕ್ ಆಗಿದೆ.';

  @override
  String get commonContinue => 'ಮುಂದುವರಿಸಿ';

  @override
  String get commonViewAll => 'ಎಲ್ಲವನ್ನೂ ವೀಕ್ಷಿಸಿ';

  @override
  String get commonResume => 'ಮುಂದುವರಿಸಿ';

  @override
  String questionCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ಪ್ರಶ್ನೆಗಳು',
      one: '1 ಪ್ರಶ್ನೆ',
    );
    return '$_temp0';
  }

  @override
  String get difficultyEasy => 'ಸುಲಭ';

  @override
  String get difficultyMedium => 'ಮಧ್ಯಮ';

  @override
  String get difficultyHard => 'ಕಠಿಣ';

  @override
  String get goalHeadingLead => 'ನಿಮ್ಮನ್ನು ನ್ಯಾಯಕ್ಕೆ';

  @override
  String get goalHeadingAccent => 'ಕರೆತಂದದ್ದು ಏನು?';

  @override
  String get goalSubtitle =>
      'ನಿಮ್ಮ ಗುರಿಯನ್ನು ಆಯ್ಕೆಮಾಡಿ — ಯಾವಾಗ ಬೇಕಾದರೂ ಬದಲಾಯಿಸಬಹುದು.';

  @override
  String get goalFootnote => 'ನಂತರ ಪ್ರೊಫೈಲ್‌ನಲ್ಲಿ ಗುರಿಯನ್ನು ಬದಲಾಯಿಸಬಹುದು.';

  @override
  String get goalLearnLawTitle => 'ಜೀವನಕ್ಕಾಗಿ ಕಾನೂನು ಕಲಿಯಿರಿ';

  @override
  String get goalLearnLawBody =>
      'ಕೆಲಸ, ಕುಟುಂಬ ಮತ್ತು ನಿಮ್ಮ ಹಕ್ಕುಗಳಿಗಾಗಿ ದೈನಂದಿನ ಕಾನೂನು ಜ್ಞಾನ';

  @override
  String get goalExamTitle => 'ಪರೀಕ್ಷೆಯಲ್ಲಿ ಗೆಲ್ಲಿರಿ';

  @override
  String get goalExamBody =>
      'ಪರೀಕ್ಷಾ ಶೈಲಿಯ MCQ ಅಭ್ಯಾಸ ಮತ್ತು ಕಾನೂನು ವಿಧಿಗಳ ಮೇಲೆ ಹಿಡಿತ ಸಾಧಿಸಿ';

  @override
  String get goalStudyTitle => 'ಕಾನೂನು ಅಧ್ಯಯನ';

  @override
  String get goalStudyBody =>
      'ನಿಮ್ಮ LLB ವಿಷಯಗಳನ್ನು ಒಂದೊಂದೇ ಪರಿಕಲ್ಪನೆಯಾಗಿ ಕಲಿಯಿರಿ';

  @override
  String get homeHeroLead => 'ನಿಮ್ಮ';

  @override
  String get homeHeroAccent => 'ಕಾನೂನು ಜ್ಞಾನವನ್ನು ಪರೀಕ್ಷಿಸಿ.';

  @override
  String get homeHeroTrail => 'ನ್ಯಾಯದಲ್ಲಿ ಪರಿಣತಿ ಪಡೆಯಿರಿ.';

  @override
  String get homeHeroSupport => 'ಕಾನೂನಿನ ಕ್ವಿಜ್‌ಗಳು. ಜೀವನಕ್ಕೆ ಒಳನೋಟ.';

  @override
  String get homeStartQuiz => 'ಕ್ವಿಜ್ ಪ್ರಾರಂಭಿಸಿ';

  @override
  String get homeNotifications => 'ಅಧಿಸೂಚನೆಗಳು';

  @override
  String get homeExploreByCategory => 'ವರ್ಗವಾರು ಅನ್ವೇಷಿಸಿ';

  @override
  String get homeContinueLearning => 'ಕಲಿಕೆ ಮುಂದುವರಿಸಿ';

  @override
  String get homePopularQuizzes => 'ಜನಪ್ರಿಯ ಕ್ವಿಜ್‌ಗಳು';

  @override
  String get homeDailyQuestions => 'ದೈನಂದಿನ ಪ್ರಶ್ನೆಗಳು';

  @override
  String get homeDailyQuestionsSubtitle =>
      'ಇಂದಿನ ಯಾದೃಚ್ಛಿಕ ಪ್ರಶ್ನೆಗಳೊಂದಿಗೆ ನಿಮ್ಮ ಮನಸ್ಸನ್ನು ಚುರುಕುಗೊಳಿಸಿ';

  @override
  String get homeDailyQuestionsEmpty => 'ಇನ್ನೂ ಯಾವುದೇ ಪ್ರಶ್ನೆಗಳು ಲಭ್ಯವಿಲ್ಲ.';

  @override
  String get homeDailyShowAnswer => 'ಉತ್ತರ ತೋರಿಸಿ';

  @override
  String get homeDailyHideAnswer => 'ಉತ್ತರ ಮರೆಮಾಡಿ';

  @override
  String homeDailyQuestionSemantics(
    int number,
    String question,
    String category,
  ) {
    return 'ಪ್ರಶ್ನೆ $number: $question. $category';
  }

  @override
  String get categoriesSubtitle =>
      'ವಿಷಯಗಳನ್ನು ಅನ್ವೇಷಿಸಿ ಮತ್ತು ನಿಮ್ಮ ಕಾನೂನು ಜ್ಞಾನವನ್ನು ಬಲಪಡಿಸಿ.';

  @override
  String get categoriesSearchHint => 'ವರ್ಗಗಳನ್ನು ಹುಡುಕಿ';

  @override
  String get categoriesNoMatch => 'ನಿಮ್ಮ ಹುಡುಕಾಟಕ್ಕೆ ಹೊಂದುವ ವರ್ಗಗಳಿಲ್ಲ.';

  @override
  String get categoriesFilters => 'ಫಿಲ್ಟರ್‌ಗಳು';

  @override
  String get topicBookmark => 'ವಿಷಯವನ್ನು ಬುಕ್‌ಮಾರ್ಕ್ ಮಾಡಿ';

  @override
  String get topicRemoveBookmark => 'ಬುಕ್‌ಮಾರ್ಕ್ ತೆಗೆದುಹಾಕಿ';

  @override
  String get topicQuizzesHeading => 'ಕ್ವಿಜ್‌ಗಳು';

  @override
  String topicContinueQuiz(int number) {
    return 'ಕ್ವಿಜ್ $number ಮುಂದುವರಿಸಿ';
  }

  @override
  String get quizStatusCompleted => 'ಪೂರ್ಣಗೊಂಡಿದೆ';

  @override
  String get quizStatusInProgress => 'ಪ್ರಗತಿಯಲ್ಲಿದೆ';

  @override
  String get quizStatusNotStarted => 'ಪ್ರಾರಂಭಿಸಿಲ್ಲ';

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
      other: '$count ಪ್ರಶ್ನೆಗಳು',
      one: '1 ಪ್ರಶ್ನೆ',
    );
    return '$title. $_temp0, $difficulty. $status';
  }

  @override
  String get quizExit => 'ಕ್ವಿಜ್‌ನಿಂದ ನಿರ್ಗಮಿಸಿ';

  @override
  String quizCounter(int current, int total) {
    return 'ಪ್ರಶ್ನೆ $current / $total';
  }

  @override
  String get quizSelectAnswer => 'ಒಂದು ಉತ್ತರ ಆಯ್ಕೆಮಾಡಿ';

  @override
  String quizOptionLabel(String letter, String text) {
    return 'ಆಯ್ಕೆ $letter. $text';
  }

  @override
  String get quizYourAnswerCorrect => 'ನಿಮ್ಮ ಉತ್ತರ, ಸರಿ';

  @override
  String get quizYourAnswerWrong => 'ನಿಮ್ಮ ಉತ್ತರ, ತಪ್ಪು';

  @override
  String get quizCorrectAnswer => 'ಸರಿಯಾದ ಉತ್ತರ';

  @override
  String get quizVerdictCorrect => 'ಸರಿ!';

  @override
  String get quizVerdictWrong => 'ಸರಿಯಾಗಿಲ್ಲ';

  @override
  String get resultHeadline => 'ಶಾಭಾಷ್!';

  @override
  String resultCompleted(String topic) {
    return '$topic — ಪೂರ್ಣಗೊಂಡಿದೆ';
  }

  @override
  String get resultThisTopic => 'ಈ ವಿಷಯ';

  @override
  String resultScoreSemantics(String score, String percent) {
    return 'ನಿಮ್ಮ ಅಂಕ: $score, $percent';
  }

  @override
  String get resultCorrect => 'ಸರಿ';

  @override
  String get resultWrong => 'ತಪ್ಪು';

  @override
  String resultCorrectCount(int count) {
    return '$count ಸರಿ';
  }

  @override
  String resultWrongCount(int count) {
    return '$count ತಪ್ಪು';
  }

  @override
  String resultWeakList(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ಪ್ರಶ್ನೆಗಳನ್ನು ನಿಮ್ಮ ದುರ್ಬಲ ಪಟ್ಟಿಗೆ ಸೇರಿಸಲಾಗಿದೆ.',
      one: '1 ಪ್ರಶ್ನೆಯನ್ನು ನಿಮ್ಮ ದುರ್ಬಲ ಪಟ್ಟಿಗೆ ಸೇರಿಸಲಾಗಿದೆ.',
    );
    return '$_temp0';
  }

  @override
  String get resultReviewAnswers => 'ಉತ್ತರಗಳನ್ನು ಪರಿಶೀಲಿಸಿ';

  @override
  String get resultBackToTopic => 'ವಿಷಯಕ್ಕೆ ಹಿಂತಿರುಗಿ';

  @override
  String get legalUpdatesTitle => 'ಕಾನೂನು ಅಪ್‌ಡೇಟ್‌ಗಳು';

  @override
  String get legalUpdatesEmpty => 'ಯಾವುದೇ ಕಾನೂನು ಅಪ್‌ಡೇಟ್‌ಗಳು ಲಭ್ಯವಿಲ್ಲ.';

  @override
  String get legalUpdatesCategoryJudgements => 'ತೀರ್ಪುಗಳು';

  @override
  String get legalUpdatesCategoryLegislation => 'ಶಾಸನ';

  @override
  String get legalUpdatesCategoryReforms => 'ಸುಧಾರಣೆಗಳು';

  @override
  String get legalUpdatesCategoryNotices => 'ಸೂಚನೆಗಳು';

  @override
  String get commonSoon => 'ಶೀಘ್ರದಲ್ಲಿ';

  @override
  String homeProgressQuizzesCompleted(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ಕ್ವಿಜ್‌ಗಳು ಪೂರ್ಣಗೊಂಡಿವೆ',
      one: '1 ಕ್ವಿಜ್ ಪೂರ್ಣಗೊಂಡಿದೆ',
    );
    return '$_temp0';
  }

  @override
  String homeProgressPoints(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ಅಂಕಗಳು',
      one: '1 ಅಂಕ',
    );
    return '$_temp0';
  }

  @override
  String homeProgressAccuracy(int percent) {
    return 'ನಿಖರತೆ $percent%';
  }

  @override
  String get homeProgressEmpty =>
      'ಇನ್ನೂ ಯಾವುದೇ ಕ್ವಿಜ್ ಇಲ್ಲ. ನಿಮ್ಮ ಮೊದಲ ಕ್ವಿಜ್ ತೆಗೆದುಕೊಳ್ಳಿ!';

  @override
  String get homeAskNyayaTitle => 'ನ್ಯಾಯ ಅನ್ನು ಕೇಳಿ';

  @override
  String get homeAskNyayaBody =>
      'ನಿಮ್ಮ ಕಾನೂನು ಪ್ರಶ್ನೆಗಳನ್ನು ಸರಳ ಭಾಷೆಯಲ್ಲಿ ಕೇಳಿ. ಸ್ಪಷ್ಟ ಉತ್ತರಗಳನ್ನು ಪಡೆಯಿರಿ.';

  @override
  String get homeRecommended => 'ನಿಮಗಾಗಿ ಶಿಫಾರಸು ಮಾಡಲಾಗಿದೆ';

  @override
  String get articlesHeroTitle => 'ಕಲಿಯಿರಿ ಮತ್ತು ಅಪ್‌ಡೇಟ್ ಆಗಿರಿ';

  @override
  String get articlesHeroSubtitle =>
      'ಮಾಹಿತಿ ಪಡೆಯಿರಿ. ಕಾನೂನನ್ನು ಅರ್ಥಮಾಡಿಕೊಳ್ಳಿ.';

  @override
  String articlesPart(String part, String title) {
    return 'ಭಾಗ $part · $title';
  }

  @override
  String get articlesEmpty => 'ಯಾವುದೇ ಲೇಖನಗಳು ಲಭ್ಯವಿಲ್ಲ.';

  @override
  String get articlesReadArticle => 'ಲೇಖನ ಓದಿ';

  @override
  String get articleWhatItMeans => 'ಇದರ ಅರ್ಥವೇನು';

  @override
  String get articleWhyItMatters => 'ಇದು ಏಕೆ ಮುಖ್ಯ';

  @override
  String get articleKeyFeatures => 'ಪ್ರಮುಖ ಲಕ್ಷಣಗಳು';

  @override
  String get profileStatsTitle => 'ನನ್ನ ಅಂಕಿಅಂಶಗಳು';

  @override
  String get profileStatStreak => 'ದಿನದ ಸ್ಟ್ರೀಕ್';

  @override
  String get profileStatCategories => 'ಅನ್ವೇಷಿಸಿದ ವರ್ಗಗಳು';

  @override
  String get profileStatQuizzes => 'ಪೂರ್ಣಗೊಂಡ ಕ್ವಿಜ್‌ಗಳು';

  @override
  String get profileStatPoints => 'ಗಳಿಸಿದ ಪಾಯಿಂಟ್‌ಗಳು';

  @override
  String get profileEdit => 'ಪ್ರೊಫೈಲ್ ಸಂಪಾದಿಸಿ';

  @override
  String get profileSettingsTitle => 'ಖಾತೆ ಮತ್ತು ಸೆಟ್ಟಿಂಗ್‌ಗಳು';

  @override
  String get profileLanguage => 'ಭಾಷೆ';

  @override
  String get profileReminders => 'ದೈನಂದಿನ ಜ್ಞಾಪನೆಗಳು';

  @override
  String get profilePrivacy => 'ಗೌಪ್ಯತೆ ಮತ್ತು ಸುರಕ್ಷತೆ';

  @override
  String get profileHelpSupport => 'ಸಹಾಯ ಮತ್ತು ಬೆಂಬಲ';

  @override
  String get profileHelpResources => 'ಕಾನೂನು ಸಹಾಯ ಸಂಪನ್ಮೂಲಗಳು';

  @override
  String get profileAbout => 'ನ್ಯಾಯ ಬಗ್ಗೆ';

  @override
  String get profileLogout => 'ಲಾಗ್ ಔಟ್';

  @override
  String get profileLogoutConfirmTitle => 'ನ್ಯಾಯದಿಂದ ಲಾಗ್ ಔಟ್ ಮಾಡಬೇಕೆ?';

  @override
  String get profileLogoutConfirmBody =>
      'ಮತ್ತೆ ಸೈನ್ ಇನ್ ಮಾಡಲು ನಿಮ್ಮ ಫೋನ್ ಸಂಖ್ಯೆ ಮತ್ತು ಕೋಡ್ ಬೇಕು.';

  @override
  String get editProfileSave => 'ಬದಲಾವಣೆಗಳನ್ನು ಉಳಿಸಿ';

  @override
  String get editProfileSaved => 'ಪ್ರೊಫೈಲ್ ನವೀಕರಿಸಲಾಗಿದೆ';

  @override
  String get editProfileChangePhoto => 'ಫೋಟೋ ಬದಲಿಸಿ';

  @override
  String get editProfileCamera => 'ಫೋಟೋ ತೆಗೆಯಿರಿ';

  @override
  String get editProfileGallery => 'ಗ್ಯಾಲರಿಯಿಂದ ಆಯ್ಕೆಮಾಡಿ';

  @override
  String get editProfilePhotoUpdated => 'ಫೋಟೋ ನವೀಕರಿಸಲಾಗಿದೆ';

  @override
  String get editProfilePhotoFailed =>
      'ಕ್ಯಾಮೆರಾ ಅಥವಾ ಫೋಟೋಗಳನ್ನು ತೆರೆಯಲಾಗಲಿಲ್ಲ. ನ್ಯಾಯದ ಅನುಮತಿಗಳನ್ನು ಪರಿಶೀಲಿಸಿ.';

  @override
  String get remindersToggle => 'ದೈನಂದಿನ ಜ್ಞಾಪನೆ';

  @override
  String get remindersToggleSubtitle => 'ಪ್ರತಿದಿನ ಅಭ್ಯಾಸ ಮಾಡಲು ಜ್ಞಾಪನೆ ಪಡೆಯಿರಿ';

  @override
  String get remindersTime => 'ಜ್ಞಾಪನೆಯ ಸಮಯ';

  @override
  String get remindersPermissionDenied =>
      'ನ್ಯಾಯಕ್ಕೆ ಅಧಿಸೂಚನೆಗಳು ಆಫ್ ಆಗಿವೆ. ಜ್ಞಾಪನೆಗಳನ್ನು ಪಡೆಯಲು ನಿಮ್ಮ ಫೋನ್ ಸೆಟ್ಟಿಂಗ್‌ಗಳಲ್ಲಿ ಅವುಗಳನ್ನು ಆನ್ ಮಾಡಿ.';

  @override
  String get reminderNotificationBody =>
      'ನಿಮ್ಮ ದೈನಂದಿನ ಕಾನೂನು ಅಭ್ಯಾಸದ ಸಮಯ — ನಿಮ್ಮ ಸ್ಟ್ರೀಕ್ ಮುಂದುವರಿಸಿ.';

  @override
  String get privacySessionsTitle => 'ಸಕ್ರಿಯ ಸೆಷನ್‌ಗಳು';

  @override
  String get privacySessionsBody =>
      'ನಿಮ್ಮ ಖಾತೆಯಲ್ಲಿ ಪ್ರಸ್ತುತ ಸಕ್ರಿಯವಾಗಿರುವ ಸೈನ್-ಇನ್‌ಗಳು';

  @override
  String get privacyLogoutAll => 'ಎಲ್ಲಾ ಸಾಧನಗಳಿಂದ ಲಾಗ್ ಔಟ್ ಮಾಡಿ';

  @override
  String get privacyLogoutAllConfirm =>
      'ಇದು ಈ ಸಾಧನ ಸೇರಿದಂತೆ ಎಲ್ಲಾ ಸಾಧನಗಳಿಂದ ನಿಮ್ಮನ್ನು ಸೈನ್ ಔಟ್ ಮಾಡುತ್ತದೆ.';

  @override
  String get privacyNoPassword =>
      'ನೀವು ನಿಮ್ಮ ಫೋನ್ ಸಂಖ್ಯೆ ಮತ್ತು ಒಂದು ಬಾರಿಯ ಕೋಡ್‌ನಿಂದ ಸೈನ್ ಇನ್ ಮಾಡುತ್ತೀರಿ, ಆದ್ದರಿಂದ ಬದಲಾಯಿಸಲು ಯಾವುದೇ ಪಾಸ್‌ವರ್ಡ್ ಇಲ್ಲ.';

  @override
  String get aboutTagline => 'ಒಂದೊಂದು ಕ್ವಿಜ್‌ನಲ್ಲಿ ಕಾನೂನಿನ ಮೂಲಾಂಶಗಳು';

  @override
  String aboutVersion(String version) {
    return 'ಆವೃತ್ತಿ $version';
  }

  @override
  String get aboutDescription =>
      'ನ್ಯಾಯ ಭಾರತೀಯ ಕಾನೂನನ್ನು ಸರಳ ಭಾಷೆಯಲ್ಲಿ ಅರ್ಥಮಾಡಿಕೊಳ್ಳಲು ಸಹಾಯ ಮಾಡುತ್ತದೆ — ಸಂವಿಧಾನವನ್ನು ಲೇಖನ ಲೇಖನವಾಗಿ ಕಲಿಯಿರಿ, ನಿಮ್ಮ ಜ್ಞಾನವನ್ನು ಪರೀಕ್ಷಿಸಿ ಮತ್ತು ಕಾನೂನು ಬೆಳವಣಿಗೆಗಳ ಬಗ್ಗೆ ಅಪ್‌ಡೇಟ್ ಆಗಿರಿ.';

  @override
  String get aboutFeaturesTitle => 'ನ್ಯಾಯದಲ್ಲಿ ನಿಮಗೆ ಸಿಗುವುದು';

  @override
  String get aboutFeatureArticles => 'ಭಾರತೀಯ ಸಂವಿಧಾನದ ಲೇಖನ-ವಾರು ಮಾರ್ಗದರ್ಶಿ';

  @override
  String get aboutFeatureDaily =>
      'ಸ್ಪಷ್ಟ ಉತ್ತರಗಳೊಂದಿಗೆ ದೈನಂದಿನ ಕಾನೂನು ಪ್ರಶ್ನೆಗಳು';

  @override
  String get aboutFeatureUpdates =>
      'ಇತ್ತೀಚಿನ ಕಾನೂನು ಅಪ್‌ಡೇಟ್‌ಗಳು ಮತ್ತು ತೀರ್ಪುಗಳು';

  @override
  String get aboutFeatureQuizzes => 'ನೀವು ಕಲಿತದ್ದನ್ನು ಪರೀಕ್ಷಿಸುವ ಕ್ವಿಜ್‌ಗಳು';

  @override
  String get aboutFeatureLanguages =>
      'ಇಂಗ್ಲಿಷ್, ಹಿಂದಿ, ತಮಿಳು, ತೆಲುಗು ಮತ್ತು ಕನ್ನಡದಲ್ಲಿ ಲಭ್ಯ';

  @override
  String get remindersFailed =>
      'ಜ್ಞಾಪನೆಯನ್ನು ಹೊಂದಿಸಲಾಗಲಿಲ್ಲ. ದಯವಿಟ್ಟು ಮತ್ತೆ ಪ್ರಯತ್ನಿಸಿ.';

  @override
  String get reminderChannelName => 'ದೈನಂದಿನ ಅಭ್ಯಾಸ ಜ್ಞಾಪನೆ';

  @override
  String get supportContactTitle => 'ಬೆಂಬಲವನ್ನು ಸಂಪರ್ಕಿಸಿ';

  @override
  String get supportSubject => 'ವಿಷಯ';

  @override
  String get supportMessage => 'ಸಂದೇಶ';

  @override
  String get supportSend => 'ವಿನಂತಿ ಕಳುಹಿಸಿ';

  @override
  String get supportSent => 'ನಿಮ್ಮ ವಿನಂತಿಯನ್ನು ಕಳುಹಿಸಲಾಗಿದೆ.';

  @override
  String get supportRequestsTitle => 'ನಿಮ್ಮ ವಿನಂತಿಗಳು';

  @override
  String get supportRequestsEmpty =>
      'ನೀವು ಇನ್ನೂ ಯಾವುದೇ ವಿನಂತಿಗಳನ್ನು ಕಳುಹಿಸಿಲ್ಲ.';

  @override
  String get supportStatusOpen => 'ತೆರೆದಿದೆ';

  @override
  String get supportStatusInProgress => 'ಪ್ರಗತಿಯಲ್ಲಿದೆ';

  @override
  String get supportStatusResolved => 'ಪರಿಹರಿಸಲಾಗಿದೆ';

  @override
  String get supportStatusClosed => 'ಮುಚ್ಚಲಾಗಿದೆ';

  @override
  String get validationRequired => 'ಅಗತ್ಯ';

  @override
  String supportMessageTooShort(int min) {
    return 'ದಯವಿಟ್ಟು ಕನಿಷ್ಠ $min ಅಕ್ಷರಗಳನ್ನು ಬರೆಯಿರಿ';
  }

  @override
  String get helpResSubtitle =>
      'ನಿಮ್ಮ ರಾಜ್ಯದಲ್ಲಿ ಪರಿಶೀಲಿಸಿದ ಕಾನೂನು ಸಹಾಯ ಸಂಪರ್ಕಗಳನ್ನು ಹುಡುಕಿ.';

  @override
  String get helpResState => 'ರಾಜ್ಯ';

  @override
  String get helpResCategory => 'ಸಹಾಯದ ಪ್ರಕಾರ';

  @override
  String get helpResEmergency => 'ತುರ್ತು ಸಂದರ್ಭದಲ್ಲಿ 112 ಗೆ ಕರೆ ಮಾಡಿ.';

  @override
  String get helpResNational => 'ರಾಷ್ಟ್ರೀಯ ಸಹಾಯವಾಣಿ';

  @override
  String helpResVerified(String date) {
    return 'ಮೂಲ ಪರಿಶೀಲಿಸಲಾಗಿದೆ $date';
  }

  @override
  String get helpResNeedsVerification => 'ಪರಿಶೀಲನೆ ಅಗತ್ಯ';

  @override
  String helpResCall(String number) {
    return '$number ಗೆ ಕರೆ ಮಾಡಿ';
  }

  @override
  String get helpResTollFree => 'ಟೋಲ್-ಫ್ರೀ';

  @override
  String get helpResPhone => 'ಫೋನ್';

  @override
  String get helpResEmail => 'ಇಮೇಲ್';

  @override
  String get helpResWebsite => 'ವೆಬ್‌ಸೈಟ್';

  @override
  String helpResHours(String hours) {
    return 'ಸಮಯ: $hours';
  }

  @override
  String helpResSource(String name) {
    return 'ಮೂಲ: $name';
  }

  @override
  String get helpResEmpty =>
      'ಈ ಆಯ್ಕೆಗೆ ಪರಿಶೀಲಿಸಿದ ಸಂಪರ್ಕಗಳಿಲ್ಲ. ಬೇರೆ ಪ್ರಕಾರ ಅಥವಾ ರಾಜ್ಯವನ್ನು ಪ್ರಯತ್ನಿಸಿ.';

  @override
  String get helpResOpenFailed => 'ಇದನ್ನು ನಿಮ್ಮ ಫೋನ್‌ನಲ್ಲಿ ತೆರೆಯಲಾಗಲಿಲ್ಲ.';

  @override
  String get searchHint =>
      'ಕಾನೂನುಗಳು, ಹಕ್ಕುಗಳು ಮತ್ತು ಇತ್ತೀಚಿನ ಅಪ್‌ಡೇಟ್‌ಗಳನ್ನು ಹುಡುಕಿ';

  @override
  String get searchFilters => 'ಫಿಲ್ಟರ್‌ಗಳು';

  @override
  String searchFiltersActive(int count) {
    return '$count ಫಿಲ್ಟರ್‌ಗಳು';
  }

  @override
  String get searchClearFilters => 'ಫಿಲ್ಟರ್‌ಗಳನ್ನು ತೆರವುಗೊಳಿಸಿ';

  @override
  String get searchNoResults =>
      'ಯಾವುದೂ ಹೊಂದಿಕೆಯಾಗಲಿಲ್ಲ. ಬೇರೆ ಪದಗಳನ್ನು ಪ್ರಯತ್ನಿಸಿ ಅಥವಾ ಫಿಲ್ಟರ್‌ಗಳನ್ನು ತೆರವುಗೊಳಿಸಿ.';

  @override
  String get filterTitle => 'ಫಿಲ್ಟರ್';

  @override
  String get filterContentType => 'ವಿಷಯ ಪ್ರಕಾರ';

  @override
  String get filterCategory => 'ವರ್ಗ';

  @override
  String get filterClearAll => 'ಎಲ್ಲವನ್ನೂ ತೆರವುಗೊಳಿಸಿ';

  @override
  String get filterApply => 'ಫಿಲ್ಟರ್‌ಗಳನ್ನು ಅನ್ವಯಿಸಿ';

  @override
  String get searchTypeQuizTopics => 'ಕ್ವಿಜ್ ವಿಷಯಗಳು';
}
