import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_kn.dart';
import 'app_localizations_ta.dart';
import 'app_localizations_te.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('hi'),
    Locale('kn'),
    Locale('ta'),
    Locale('te'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Nyaya'**
  String get appTitle;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languageHindi.
  ///
  /// In en, this message translates to:
  /// **'हिन्दी'**
  String get languageHindi;

  /// No description provided for @languageTamil.
  ///
  /// In en, this message translates to:
  /// **'தமிழ்'**
  String get languageTamil;

  /// No description provided for @languageTelugu.
  ///
  /// In en, this message translates to:
  /// **'తెలుగు'**
  String get languageTelugu;

  /// No description provided for @languageKannada.
  ///
  /// In en, this message translates to:
  /// **'ಕನ್ನಡ'**
  String get languageKannada;

  /// No description provided for @commonRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get commonRetry;

  /// No description provided for @commonCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get commonCancel;

  /// No description provided for @commonSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get commonSave;

  /// No description provided for @commonSeeAll.
  ///
  /// In en, this message translates to:
  /// **'See all'**
  String get commonSeeAll;

  /// No description provided for @commonComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming soon'**
  String get commonComingSoon;

  /// No description provided for @featureComingSoon.
  ///
  /// In en, this message translates to:
  /// **'{feature} coming soon.'**
  String featureComingSoon(String feature);

  /// No description provided for @errorOffline.
  ///
  /// In en, this message translates to:
  /// **'Can\'t reach the Nyaya server. Check your connection and try again.'**
  String get errorOffline;

  /// No description provided for @errorSessionExpired.
  ///
  /// In en, this message translates to:
  /// **'Your session has ended. Please sign in again.'**
  String get errorSessionExpired;

  /// No description provided for @errorGeneric.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get errorGeneric;

  /// No description provided for @emptyNothingHere.
  ///
  /// In en, this message translates to:
  /// **'Nothing here yet.'**
  String get emptyNothingHere;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navCategories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get navCategories;

  /// No description provided for @navLeaderboard.
  ///
  /// In en, this message translates to:
  /// **'Leaderboard'**
  String get navLeaderboard;

  /// No description provided for @navArticles.
  ///
  /// In en, this message translates to:
  /// **'Articles'**
  String get navArticles;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// No description provided for @comingSoonBody.
  ///
  /// In en, this message translates to:
  /// **'We\'re building this section. Check back soon.'**
  String get comingSoonBody;

  /// No description provided for @categoryQuizCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 quiz} other{{count} quizzes}}'**
  String categoryQuizCount(int count);

  /// No description provided for @categoriesEmpty.
  ///
  /// In en, this message translates to:
  /// **'No categories yet.'**
  String get categoriesEmpty;

  /// No description provided for @brandTagline.
  ///
  /// In en, this message translates to:
  /// **'LAW BASED QUIZ APP'**
  String get brandTagline;

  /// No description provided for @splashSemanticsLabel.
  ///
  /// In en, this message translates to:
  /// **'Nyaya splash screen'**
  String get splashSemanticsLabel;

  /// No description provided for @splashTapToContinue.
  ///
  /// In en, this message translates to:
  /// **'Tap to continue'**
  String get splashTapToContinue;

  /// No description provided for @splashLoadingLabel.
  ///
  /// In en, this message translates to:
  /// **'Loading Nyaya'**
  String get splashLoadingLabel;

  /// No description provided for @splashLoadingValue.
  ///
  /// In en, this message translates to:
  /// **'{percent} percent'**
  String splashLoadingValue(int percent);

  /// No description provided for @commonGetStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get commonGetStarted;

  /// No description provided for @commonSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get commonSkip;

  /// No description provided for @commonNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get commonNext;

  /// No description provided for @commonSignIn.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get commonSignIn;

  /// No description provided for @commonLogin.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get commonLogin;

  /// No description provided for @commonSignUp.
  ///
  /// In en, this message translates to:
  /// **'Signup'**
  String get commonSignUp;

  /// No description provided for @commonHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? '**
  String get commonHaveAccount;

  /// No description provided for @welcomeHeadlineLine1.
  ///
  /// In en, this message translates to:
  /// **'Law Made Easy,'**
  String get welcomeHeadlineLine1;

  /// No description provided for @welcomeHeadlineLine2.
  ///
  /// In en, this message translates to:
  /// **'Justice Made Accessible.'**
  String get welcomeHeadlineLine2;

  /// No description provided for @welcomeBody.
  ///
  /// In en, this message translates to:
  /// **'Explore laws, test your knowledge, and become your own legal expert.'**
  String get welcomeBody;

  /// No description provided for @welcomeLearnTitle.
  ///
  /// In en, this message translates to:
  /// **'Learn Laws'**
  String get welcomeLearnTitle;

  /// No description provided for @welcomeLearnBody.
  ///
  /// In en, this message translates to:
  /// **'Explore and understand important laws in simple language.'**
  String get welcomeLearnBody;

  /// No description provided for @welcomeRightsTitle.
  ///
  /// In en, this message translates to:
  /// **'Know Your Rights'**
  String get welcomeRightsTitle;

  /// No description provided for @welcomeRightsBody.
  ///
  /// In en, this message translates to:
  /// **'Stay informed and empowered about your legal rights.'**
  String get welcomeRightsBody;

  /// No description provided for @welcomeTrackTitle.
  ///
  /// In en, this message translates to:
  /// **'Track & Stay Updated'**
  String get welcomeTrackTitle;

  /// No description provided for @welcomeTrackBody.
  ///
  /// In en, this message translates to:
  /// **'Track case status and get the latest legal updates with ease.'**
  String get welcomeTrackBody;

  /// No description provided for @onboarding1Line1.
  ///
  /// In en, this message translates to:
  /// **'Test Your Knowledge.'**
  String get onboarding1Line1;

  /// No description provided for @onboarding1Line2.
  ///
  /// In en, this message translates to:
  /// **'Master Justice.'**
  String get onboarding1Line2;

  /// No description provided for @onboarding2Line1.
  ///
  /// In en, this message translates to:
  /// **'Learn. Understand.'**
  String get onboarding2Line1;

  /// No description provided for @onboarding2Line2.
  ///
  /// In en, this message translates to:
  /// **'Apply Law.'**
  String get onboarding2Line2;

  /// No description provided for @onboarding2Body.
  ///
  /// In en, this message translates to:
  /// **'Nyaya makes legal learning simple with case-based quizzes, real-life scenarios and expertly crafted content.'**
  String get onboarding2Body;

  /// No description provided for @onboarding3Line1.
  ///
  /// In en, this message translates to:
  /// **'Track Progress.'**
  String get onboarding3Line1;

  /// No description provided for @onboarding3Line2.
  ///
  /// In en, this message translates to:
  /// **'Achieve Excellence.'**
  String get onboarding3Line2;

  /// No description provided for @onboarding3Body.
  ///
  /// In en, this message translates to:
  /// **'Track your performance, build streaks, earn badges and become the best version of your legal knowledge.'**
  String get onboarding3Body;

  /// No description provided for @authJoinSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Join NYAYA and start your legal learning journey'**
  String get authJoinSubtitle;

  /// No description provided for @signInTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back to NYAYA !'**
  String get signInTitle;

  /// No description provided for @signInSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Rejoin NYAYA and start your legal learning journey'**
  String get signInSubtitle;

  /// No description provided for @signInNoAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? '**
  String get signInNoAccount;

  /// No description provided for @signInPhoneMissing.
  ///
  /// In en, this message translates to:
  /// **'Enter your phone number.'**
  String get signInPhoneMissing;

  /// No description provided for @signInPasswordMissing.
  ///
  /// In en, this message translates to:
  /// **'Enter your password.'**
  String get signInPasswordMissing;

  /// No description provided for @fieldPhoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get fieldPhoneLabel;

  /// No description provided for @fieldPhoneHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your phone number'**
  String get fieldPhoneHint;

  /// No description provided for @fieldPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get fieldPasswordLabel;

  /// No description provided for @fieldPasswordHintCreate.
  ///
  /// In en, this message translates to:
  /// **'Create a strong password'**
  String get fieldPasswordHintCreate;

  /// No description provided for @fieldPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get fieldPasswordHint;

  /// No description provided for @showPassword.
  ///
  /// In en, this message translates to:
  /// **'Show password'**
  String get showPassword;

  /// No description provided for @hidePassword.
  ///
  /// In en, this message translates to:
  /// **'Hide password'**
  String get hidePassword;

  /// No description provided for @fieldFullNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fieldFullNameLabel;

  /// No description provided for @fieldFullNameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your full name'**
  String get fieldFullNameHint;

  /// No description provided for @fieldProfessionLabel.
  ///
  /// In en, this message translates to:
  /// **'Profession'**
  String get fieldProfessionLabel;

  /// No description provided for @fieldProfessionHint.
  ///
  /// In en, this message translates to:
  /// **'Select your profession'**
  String get fieldProfessionHint;

  /// No description provided for @professionLawStudent.
  ///
  /// In en, this message translates to:
  /// **'Law Student'**
  String get professionLawStudent;

  /// No description provided for @professionLawyer.
  ///
  /// In en, this message translates to:
  /// **'Lawyer / Advocate'**
  String get professionLawyer;

  /// No description provided for @professionJudge.
  ///
  /// In en, this message translates to:
  /// **'Judge / Judicial Officer'**
  String get professionJudge;

  /// No description provided for @professionLegalProfessional.
  ///
  /// In en, this message translates to:
  /// **'Legal Professional'**
  String get professionLegalProfessional;

  /// No description provided for @professionCitizen.
  ///
  /// In en, this message translates to:
  /// **'General Citizen'**
  String get professionCitizen;

  /// No description provided for @signUpTitle.
  ///
  /// In en, this message translates to:
  /// **'Create Your Account'**
  String get signUpTitle;

  /// No description provided for @signUpSendOtp.
  ///
  /// In en, this message translates to:
  /// **'Send OTP'**
  String get signUpSendOtp;

  /// No description provided for @validationNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Full name is required'**
  String get validationNameRequired;

  /// No description provided for @validationNameTooShort.
  ///
  /// In en, this message translates to:
  /// **'Name must be at least 3 characters'**
  String get validationNameTooShort;

  /// No description provided for @validationProfessionRequired.
  ///
  /// In en, this message translates to:
  /// **'Profession is required'**
  String get validationProfessionRequired;

  /// No description provided for @validationPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Password is required'**
  String get validationPasswordRequired;

  /// No description provided for @validationPasswordWeak.
  ///
  /// In en, this message translates to:
  /// **'Use at least 8 characters with letters and numbers'**
  String get validationPasswordWeak;

  /// No description provided for @validationPhoneRequired.
  ///
  /// In en, this message translates to:
  /// **'Phone number is required'**
  String get validationPhoneRequired;

  /// No description provided for @validationPhoneInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid phone number'**
  String get validationPhoneInvalid;

  /// No description provided for @otpTitle.
  ///
  /// In en, this message translates to:
  /// **'Verify OTP'**
  String get otpTitle;

  /// No description provided for @otpSentTo.
  ///
  /// In en, this message translates to:
  /// **'We\'ve sent a 6-digit OTP to'**
  String get otpSentTo;

  /// No description provided for @otpChange.
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get otpChange;

  /// No description provided for @otpEnter.
  ///
  /// In en, this message translates to:
  /// **'Enter OTP'**
  String get otpEnter;

  /// No description provided for @otpNotReceived.
  ///
  /// In en, this message translates to:
  /// **'Didn\'t receive the OTP?'**
  String get otpNotReceived;

  /// No description provided for @otpResend.
  ///
  /// In en, this message translates to:
  /// **'Resend OTP'**
  String get otpResend;

  /// No description provided for @otpResending.
  ///
  /// In en, this message translates to:
  /// **'Resending…'**
  String get otpResending;

  /// No description provided for @otpResendIn.
  ///
  /// In en, this message translates to:
  /// **'Resend OTP in {time}'**
  String otpResendIn(String time);

  /// No description provided for @otpTapToResend.
  ///
  /// In en, this message translates to:
  /// **'Tap to resend'**
  String get otpTapToResend;

  /// No description provided for @otpVerifyContinue.
  ///
  /// In en, this message translates to:
  /// **'Verify & Continue'**
  String get otpVerifyContinue;

  /// No description provided for @otpIncomplete.
  ///
  /// In en, this message translates to:
  /// **'Enter the full 6-digit code.'**
  String get otpIncomplete;

  /// No description provided for @otpSentAgain.
  ///
  /// In en, this message translates to:
  /// **'A new OTP has been sent.'**
  String get otpSentAgain;

  /// No description provided for @authErrorInvalidPhone.
  ///
  /// In en, this message translates to:
  /// **'That phone number doesn\'t look right. Please check and try again.'**
  String get authErrorInvalidPhone;

  /// No description provided for @authErrorTooManyRequests.
  ///
  /// In en, this message translates to:
  /// **'Too many attempts. Please wait a while before trying again.'**
  String get authErrorTooManyRequests;

  /// No description provided for @authErrorQuotaExceeded.
  ///
  /// In en, this message translates to:
  /// **'SMS quota exceeded for now. Please try again later.'**
  String get authErrorQuotaExceeded;

  /// No description provided for @authErrorInvalidCode.
  ///
  /// In en, this message translates to:
  /// **'Incorrect OTP. Please check the code and try again.'**
  String get authErrorInvalidCode;

  /// No description provided for @authErrorCodeExpired.
  ///
  /// In en, this message translates to:
  /// **'This OTP has expired. Please request a new one.'**
  String get authErrorCodeExpired;

  /// No description provided for @authErrorUserDisabled.
  ///
  /// In en, this message translates to:
  /// **'This account has been disabled. Please contact support.'**
  String get authErrorUserDisabled;

  /// No description provided for @authErrorNotEnabled.
  ///
  /// In en, this message translates to:
  /// **'Phone sign-in isn\'t enabled for this app yet.'**
  String get authErrorNotEnabled;

  /// No description provided for @authErrorCredentialInUse.
  ///
  /// In en, this message translates to:
  /// **'This phone number is already linked to another account.'**
  String get authErrorCredentialInUse;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'hi', 'kn', 'ta', 'te'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'hi':
      return AppLocalizationsHi();
    case 'kn':
      return AppLocalizationsKn();
    case 'ta':
      return AppLocalizationsTa();
    case 'te':
      return AppLocalizationsTe();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
