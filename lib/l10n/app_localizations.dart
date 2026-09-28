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

  /// No description provided for @quizCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 quiz} other{{count} quizzes}}'**
  String quizCount(int count);

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

  /// No description provided for @commonContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get commonContinue;

  /// No description provided for @commonViewAll.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get commonViewAll;

  /// No description provided for @commonResume.
  ///
  /// In en, this message translates to:
  /// **'Resume'**
  String get commonResume;

  /// No description provided for @questionCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 Question} other{{count} Questions}}'**
  String questionCount(int count);

  /// No description provided for @difficultyEasy.
  ///
  /// In en, this message translates to:
  /// **'Easy'**
  String get difficultyEasy;

  /// No description provided for @difficultyMedium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get difficultyMedium;

  /// No description provided for @difficultyHard.
  ///
  /// In en, this message translates to:
  /// **'Hard'**
  String get difficultyHard;

  /// No description provided for @goalHeadingLead.
  ///
  /// In en, this message translates to:
  /// **'What brings you'**
  String get goalHeadingLead;

  /// No description provided for @goalHeadingAccent.
  ///
  /// In en, this message translates to:
  /// **'to Nyaya?'**
  String get goalHeadingAccent;

  /// No description provided for @goalSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose your goal — you can change it anytime.'**
  String get goalSubtitle;

  /// No description provided for @goalFootnote.
  ///
  /// In en, this message translates to:
  /// **'You can switch goals later in Profile.'**
  String get goalFootnote;

  /// No description provided for @goalLearnLawTitle.
  ///
  /// In en, this message translates to:
  /// **'Learn law for life'**
  String get goalLearnLawTitle;

  /// No description provided for @goalLearnLawBody.
  ///
  /// In en, this message translates to:
  /// **'Everyday legal know-how for work, family and your rights'**
  String get goalLearnLawBody;

  /// No description provided for @goalExamTitle.
  ///
  /// In en, this message translates to:
  /// **'Crack an exam'**
  String get goalExamTitle;

  /// No description provided for @goalExamBody.
  ///
  /// In en, this message translates to:
  /// **'Sharpen exam-style MCQ practice and statute mastery'**
  String get goalExamBody;

  /// No description provided for @goalStudyTitle.
  ///
  /// In en, this message translates to:
  /// **'Study law'**
  String get goalStudyTitle;

  /// No description provided for @goalStudyBody.
  ///
  /// In en, this message translates to:
  /// **'Master your LLB subjects, concept by concept'**
  String get goalStudyBody;

  /// No description provided for @homeHeroLead.
  ///
  /// In en, this message translates to:
  /// **'Test Your'**
  String get homeHeroLead;

  /// No description provided for @homeHeroAccent.
  ///
  /// In en, this message translates to:
  /// **'Legal Knowledge.'**
  String get homeHeroAccent;

  /// No description provided for @homeHeroTrail.
  ///
  /// In en, this message translates to:
  /// **'Master Justice.'**
  String get homeHeroTrail;

  /// No description provided for @homeHeroSupport.
  ///
  /// In en, this message translates to:
  /// **'Quizzes on Law. Insights for Life.'**
  String get homeHeroSupport;

  /// No description provided for @homeStartQuiz.
  ///
  /// In en, this message translates to:
  /// **'Start Quiz'**
  String get homeStartQuiz;

  /// No description provided for @homeNotifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get homeNotifications;

  /// No description provided for @homeExploreByCategory.
  ///
  /// In en, this message translates to:
  /// **'Explore by Category'**
  String get homeExploreByCategory;

  /// No description provided for @homeContinueLearning.
  ///
  /// In en, this message translates to:
  /// **'Continue Learning'**
  String get homeContinueLearning;

  /// No description provided for @homePopularQuizzes.
  ///
  /// In en, this message translates to:
  /// **'Popular Quizzes'**
  String get homePopularQuizzes;

  /// No description provided for @homeDailyQuestions.
  ///
  /// In en, this message translates to:
  /// **'Daily Questions'**
  String get homeDailyQuestions;

  /// No description provided for @homeDailyQuestionsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sharpen your mind with today\'s random questions'**
  String get homeDailyQuestionsSubtitle;

  /// No description provided for @homeDailyQuestionsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No questions available yet.'**
  String get homeDailyQuestionsEmpty;

  /// No description provided for @homeDailyShowAnswer.
  ///
  /// In en, this message translates to:
  /// **'Show answer'**
  String get homeDailyShowAnswer;

  /// No description provided for @homeDailyHideAnswer.
  ///
  /// In en, this message translates to:
  /// **'Hide answer'**
  String get homeDailyHideAnswer;

  /// No description provided for @homeDailyQuestionSemantics.
  ///
  /// In en, this message translates to:
  /// **'Question {number}: {question}. {category}'**
  String homeDailyQuestionSemantics(
    int number,
    String question,
    String category,
  );

  /// No description provided for @categoriesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Explore topics and strengthen your legal knowledge.'**
  String get categoriesSubtitle;

  /// No description provided for @categoriesSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search categories'**
  String get categoriesSearchHint;

  /// No description provided for @categoriesNoMatch.
  ///
  /// In en, this message translates to:
  /// **'No categories match your search.'**
  String get categoriesNoMatch;

  /// No description provided for @categoriesFilters.
  ///
  /// In en, this message translates to:
  /// **'Filters'**
  String get categoriesFilters;

  /// No description provided for @topicBookmark.
  ///
  /// In en, this message translates to:
  /// **'Bookmark topic'**
  String get topicBookmark;

  /// No description provided for @topicRemoveBookmark.
  ///
  /// In en, this message translates to:
  /// **'Remove bookmark'**
  String get topicRemoveBookmark;

  /// No description provided for @topicQuizzesHeading.
  ///
  /// In en, this message translates to:
  /// **'Quizzes'**
  String get topicQuizzesHeading;

  /// No description provided for @topicContinueQuiz.
  ///
  /// In en, this message translates to:
  /// **'Continue quiz {number}'**
  String topicContinueQuiz(int number);

  /// No description provided for @quizStatusCompleted.
  ///
  /// In en, this message translates to:
  /// **'completed'**
  String get quizStatusCompleted;

  /// No description provided for @quizStatusInProgress.
  ///
  /// In en, this message translates to:
  /// **'in progress'**
  String get quizStatusInProgress;

  /// No description provided for @quizStatusNotStarted.
  ///
  /// In en, this message translates to:
  /// **'not started'**
  String get quizStatusNotStarted;

  /// No description provided for @topicQuizSemantics.
  ///
  /// In en, this message translates to:
  /// **'{title}. {count, plural, =1{1 question} other{{count} questions}}, {difficulty}. {status}'**
  String topicQuizSemantics(
    String title,
    int count,
    String difficulty,
    String status,
  );

  /// No description provided for @quizExit.
  ///
  /// In en, this message translates to:
  /// **'Exit quiz'**
  String get quizExit;

  /// No description provided for @quizCounter.
  ///
  /// In en, this message translates to:
  /// **'Question {current} of {total}'**
  String quizCounter(int current, int total);

  /// No description provided for @quizSelectAnswer.
  ///
  /// In en, this message translates to:
  /// **'Select an answer'**
  String get quizSelectAnswer;

  /// No description provided for @quizOptionLabel.
  ///
  /// In en, this message translates to:
  /// **'Option {letter}. {text}'**
  String quizOptionLabel(String letter, String text);

  /// No description provided for @quizYourAnswerCorrect.
  ///
  /// In en, this message translates to:
  /// **'Your answer, correct'**
  String get quizYourAnswerCorrect;

  /// No description provided for @quizYourAnswerWrong.
  ///
  /// In en, this message translates to:
  /// **'Your answer, wrong'**
  String get quizYourAnswerWrong;

  /// No description provided for @quizCorrectAnswer.
  ///
  /// In en, this message translates to:
  /// **'Correct answer'**
  String get quizCorrectAnswer;

  /// No description provided for @quizVerdictCorrect.
  ///
  /// In en, this message translates to:
  /// **'Correct!'**
  String get quizVerdictCorrect;

  /// No description provided for @quizVerdictWrong.
  ///
  /// In en, this message translates to:
  /// **'Not quite'**
  String get quizVerdictWrong;

  /// No description provided for @resultHeadline.
  ///
  /// In en, this message translates to:
  /// **'Well Done!'**
  String get resultHeadline;

  /// No description provided for @resultCompleted.
  ///
  /// In en, this message translates to:
  /// **'{topic} — completed'**
  String resultCompleted(String topic);

  /// No description provided for @resultThisTopic.
  ///
  /// In en, this message translates to:
  /// **'this topic'**
  String get resultThisTopic;

  /// No description provided for @resultScoreSemantics.
  ///
  /// In en, this message translates to:
  /// **'Your score: {score}, {percent}'**
  String resultScoreSemantics(String score, String percent);

  /// No description provided for @resultCorrect.
  ///
  /// In en, this message translates to:
  /// **'Correct'**
  String get resultCorrect;

  /// No description provided for @resultWrong.
  ///
  /// In en, this message translates to:
  /// **'Wrong'**
  String get resultWrong;

  /// No description provided for @resultCorrectCount.
  ///
  /// In en, this message translates to:
  /// **'{count} correct'**
  String resultCorrectCount(int count);

  /// No description provided for @resultWrongCount.
  ///
  /// In en, this message translates to:
  /// **'{count} wrong'**
  String resultWrongCount(int count);

  /// No description provided for @resultWeakList.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 question added to your weak list.} other{{count} questions added to your weak list.}}'**
  String resultWeakList(int count);

  /// No description provided for @resultReviewAnswers.
  ///
  /// In en, this message translates to:
  /// **'Review answers'**
  String get resultReviewAnswers;

  /// No description provided for @resultBackToTopic.
  ///
  /// In en, this message translates to:
  /// **'Back to topic'**
  String get resultBackToTopic;

  /// No description provided for @legalUpdatesTitle.
  ///
  /// In en, this message translates to:
  /// **'Legal Updates'**
  String get legalUpdatesTitle;

  /// No description provided for @legalUpdatesEmpty.
  ///
  /// In en, this message translates to:
  /// **'No legal updates yet.'**
  String get legalUpdatesEmpty;

  /// No description provided for @legalUpdatesCategoryJudgements.
  ///
  /// In en, this message translates to:
  /// **'Judgements'**
  String get legalUpdatesCategoryJudgements;

  /// No description provided for @legalUpdatesCategoryLegislation.
  ///
  /// In en, this message translates to:
  /// **'Legislation'**
  String get legalUpdatesCategoryLegislation;

  /// No description provided for @legalUpdatesCategoryReforms.
  ///
  /// In en, this message translates to:
  /// **'Reforms'**
  String get legalUpdatesCategoryReforms;

  /// No description provided for @legalUpdatesCategoryNotices.
  ///
  /// In en, this message translates to:
  /// **'Notices'**
  String get legalUpdatesCategoryNotices;

  /// No description provided for @commonSoon.
  ///
  /// In en, this message translates to:
  /// **'Soon'**
  String get commonSoon;

  /// No description provided for @homeProgressQuizzesCompleted.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 quiz completed} other{{count} quizzes completed}}'**
  String homeProgressQuizzesCompleted(int count);

  /// No description provided for @homeProgressPoints.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 point} other{{count} points}}'**
  String homeProgressPoints(int count);

  /// No description provided for @homeProgressAccuracy.
  ///
  /// In en, this message translates to:
  /// **'Accuracy {percent}%'**
  String homeProgressAccuracy(int percent);

  /// No description provided for @homeProgressEmpty.
  ///
  /// In en, this message translates to:
  /// **'No quizzes yet. Take your first quiz!'**
  String get homeProgressEmpty;

  /// No description provided for @homeAskNyayaTitle.
  ///
  /// In en, this message translates to:
  /// **'Ask Nyaya'**
  String get homeAskNyayaTitle;

  /// No description provided for @homeAskNyayaBody.
  ///
  /// In en, this message translates to:
  /// **'Ask your legal questions in simple language. Get clear answers.'**
  String get homeAskNyayaBody;

  /// No description provided for @homeRecommended.
  ///
  /// In en, this message translates to:
  /// **'Recommended for you'**
  String get homeRecommended;

  /// No description provided for @articlesHeroTitle.
  ///
  /// In en, this message translates to:
  /// **'Learn & Stay Updated'**
  String get articlesHeroTitle;

  /// No description provided for @articlesHeroSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Stay informed. Understand the law.'**
  String get articlesHeroSubtitle;

  /// No description provided for @articlesPart.
  ///
  /// In en, this message translates to:
  /// **'Part {part} · {title}'**
  String articlesPart(String part, String title);

  /// No description provided for @articlesEmpty.
  ///
  /// In en, this message translates to:
  /// **'No articles yet.'**
  String get articlesEmpty;

  /// No description provided for @articlesReadArticle.
  ///
  /// In en, this message translates to:
  /// **'Read article'**
  String get articlesReadArticle;

  /// No description provided for @articleWhatItMeans.
  ///
  /// In en, this message translates to:
  /// **'What it means'**
  String get articleWhatItMeans;

  /// No description provided for @articleWhyItMatters.
  ///
  /// In en, this message translates to:
  /// **'Why it matters'**
  String get articleWhyItMatters;

  /// No description provided for @articleKeyFeatures.
  ///
  /// In en, this message translates to:
  /// **'Key features'**
  String get articleKeyFeatures;

  /// No description provided for @profileStatsTitle.
  ///
  /// In en, this message translates to:
  /// **'My statistics'**
  String get profileStatsTitle;

  /// No description provided for @profileStatStreak.
  ///
  /// In en, this message translates to:
  /// **'Day streak'**
  String get profileStatStreak;

  /// No description provided for @profileStatCategories.
  ///
  /// In en, this message translates to:
  /// **'Categories explored'**
  String get profileStatCategories;

  /// No description provided for @profileStatQuizzes.
  ///
  /// In en, this message translates to:
  /// **'Quizzes completed'**
  String get profileStatQuizzes;

  /// No description provided for @profileStatPoints.
  ///
  /// In en, this message translates to:
  /// **'Points earned'**
  String get profileStatPoints;

  /// No description provided for @profileEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit profile'**
  String get profileEdit;

  /// No description provided for @profileSettingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Account & settings'**
  String get profileSettingsTitle;

  /// No description provided for @profileLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get profileLanguage;

  /// No description provided for @profileReminders.
  ///
  /// In en, this message translates to:
  /// **'Daily reminders'**
  String get profileReminders;

  /// No description provided for @profilePrivacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy & security'**
  String get profilePrivacy;

  /// No description provided for @profileHelpSupport.
  ///
  /// In en, this message translates to:
  /// **'Help & support'**
  String get profileHelpSupport;

  /// No description provided for @profileHelpResources.
  ///
  /// In en, this message translates to:
  /// **'Legal help resources'**
  String get profileHelpResources;

  /// No description provided for @profileAbout.
  ///
  /// In en, this message translates to:
  /// **'About Nyaya'**
  String get profileAbout;

  /// No description provided for @profileLogout.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get profileLogout;

  /// No description provided for @profileLogoutConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Log out of Nyaya?'**
  String get profileLogoutConfirmTitle;

  /// No description provided for @profileLogoutConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'You\'ll need your phone number and a code to sign in again.'**
  String get profileLogoutConfirmBody;

  /// No description provided for @editProfileSave.
  ///
  /// In en, this message translates to:
  /// **'Save changes'**
  String get editProfileSave;

  /// No description provided for @editProfileSaved.
  ///
  /// In en, this message translates to:
  /// **'Profile updated'**
  String get editProfileSaved;

  /// No description provided for @editProfileChangePhoto.
  ///
  /// In en, this message translates to:
  /// **'Change photo'**
  String get editProfileChangePhoto;

  /// No description provided for @editProfileCamera.
  ///
  /// In en, this message translates to:
  /// **'Take a photo'**
  String get editProfileCamera;

  /// No description provided for @editProfileGallery.
  ///
  /// In en, this message translates to:
  /// **'Choose from gallery'**
  String get editProfileGallery;

  /// No description provided for @editProfilePhotoUpdated.
  ///
  /// In en, this message translates to:
  /// **'Photo updated'**
  String get editProfilePhotoUpdated;

  /// No description provided for @editProfilePhotoFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t open the camera or photos. Check Nyaya\'s permissions.'**
  String get editProfilePhotoFailed;

  /// No description provided for @remindersToggle.
  ///
  /// In en, this message translates to:
  /// **'Daily reminder'**
  String get remindersToggle;

  /// No description provided for @remindersToggleSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Get a nudge to practise each day'**
  String get remindersToggleSubtitle;

  /// No description provided for @remindersTime.
  ///
  /// In en, this message translates to:
  /// **'Reminder time'**
  String get remindersTime;

  /// No description provided for @remindersPermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Notifications are off for Nyaya. Turn them on in your phone\'s settings to get reminders.'**
  String get remindersPermissionDenied;

  /// No description provided for @reminderNotificationBody.
  ///
  /// In en, this message translates to:
  /// **'Time for your daily legal practice — keep your streak going.'**
  String get reminderNotificationBody;
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
