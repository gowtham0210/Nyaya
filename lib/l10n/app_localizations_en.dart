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

  @override
  String get navHome => 'Home';

  @override
  String get navCategories => 'Categories';

  @override
  String get navLeaderboard => 'Leaderboard';

  @override
  String get navArticles => 'Articles';

  @override
  String get navProfile => 'Profile';

  @override
  String get comingSoonBody => 'We\'re building this section. Check back soon.';

  @override
  String quizCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count quizzes',
      one: '1 quiz',
    );
    return '$_temp0';
  }

  @override
  String get categoriesEmpty => 'No categories yet.';

  @override
  String get brandTagline => 'LAW BASED QUIZ APP';

  @override
  String get splashSemanticsLabel => 'Nyaya splash screen';

  @override
  String get splashTapToContinue => 'Tap to continue';

  @override
  String get splashLoadingLabel => 'Loading Nyaya';

  @override
  String splashLoadingValue(int percent) {
    return '$percent percent';
  }

  @override
  String get commonGetStarted => 'Get Started';

  @override
  String get commonSkip => 'Skip';

  @override
  String get commonNext => 'Next';

  @override
  String get commonSignIn => 'Sign in';

  @override
  String get commonLogin => 'Login';

  @override
  String get commonSignUp => 'Signup';

  @override
  String get commonHaveAccount => 'Already have an account? ';

  @override
  String get welcomeHeadlineLine1 => 'Law Made Easy,';

  @override
  String get welcomeHeadlineLine2 => 'Justice Made Accessible.';

  @override
  String get welcomeBody =>
      'Explore laws, test your knowledge, and become your own legal expert.';

  @override
  String get welcomeLearnTitle => 'Learn Laws';

  @override
  String get welcomeLearnBody =>
      'Explore and understand important laws in simple language.';

  @override
  String get welcomeRightsTitle => 'Know Your Rights';

  @override
  String get welcomeRightsBody =>
      'Stay informed and empowered about your legal rights.';

  @override
  String get welcomeTrackTitle => 'Track & Stay Updated';

  @override
  String get welcomeTrackBody =>
      'Track case status and get the latest legal updates with ease.';

  @override
  String get onboarding1Line1 => 'Test Your Knowledge.';

  @override
  String get onboarding1Line2 => 'Master Justice.';

  @override
  String get onboarding2Line1 => 'Learn. Understand.';

  @override
  String get onboarding2Line2 => 'Apply Law.';

  @override
  String get onboarding2Body =>
      'Nyaya makes legal learning simple with case-based quizzes, real-life scenarios and expertly crafted content.';

  @override
  String get onboarding3Line1 => 'Track Progress.';

  @override
  String get onboarding3Line2 => 'Achieve Excellence.';

  @override
  String get onboarding3Body =>
      'Track your performance, build streaks, earn badges and become the best version of your legal knowledge.';

  @override
  String get authJoinSubtitle =>
      'Join NYAYA and start your legal learning journey';

  @override
  String get signInTitle => 'Welcome Back to NYAYA !';

  @override
  String get signInSubtitle =>
      'Rejoin NYAYA and start your legal learning journey';

  @override
  String get signInNoAccount => 'Don\'t have an account? ';

  @override
  String get signInPhoneMissing => 'Enter your phone number.';

  @override
  String get signInPasswordMissing => 'Enter your password.';

  @override
  String get fieldPhoneLabel => 'Phone Number';

  @override
  String get fieldPhoneHint => 'Enter your phone number';

  @override
  String get fieldPasswordLabel => 'Password';

  @override
  String get fieldPasswordHintCreate => 'Create a strong password';

  @override
  String get fieldPasswordHint => 'Enter your password';

  @override
  String get showPassword => 'Show password';

  @override
  String get hidePassword => 'Hide password';

  @override
  String get fieldFullNameLabel => 'Full Name';

  @override
  String get fieldFullNameHint => 'Enter your full name';

  @override
  String get fieldProfessionLabel => 'Profession';

  @override
  String get fieldProfessionHint => 'Select your profession';

  @override
  String get professionLawStudent => 'Law Student';

  @override
  String get professionLawyer => 'Lawyer / Advocate';

  @override
  String get professionJudge => 'Judge / Judicial Officer';

  @override
  String get professionLegalProfessional => 'Legal Professional';

  @override
  String get professionCitizen => 'General Citizen';

  @override
  String get signUpTitle => 'Create Your Account';

  @override
  String get signUpSendOtp => 'Send OTP';

  @override
  String get validationNameRequired => 'Full name is required';

  @override
  String get validationNameTooShort => 'Name must be at least 3 characters';

  @override
  String get validationProfessionRequired => 'Profession is required';

  @override
  String get validationPasswordRequired => 'Password is required';

  @override
  String get validationPasswordWeak =>
      'Use at least 8 characters with letters and numbers';

  @override
  String get validationPhoneRequired => 'Phone number is required';

  @override
  String get validationPhoneInvalid => 'Enter a valid phone number';

  @override
  String get otpTitle => 'Verify OTP';

  @override
  String get otpSentTo => 'We\'ve sent a 6-digit OTP to';

  @override
  String get otpChange => 'Change';

  @override
  String get otpEnter => 'Enter OTP';

  @override
  String get otpNotReceived => 'Didn\'t receive the OTP?';

  @override
  String get otpResend => 'Resend OTP';

  @override
  String get otpResending => 'Resending…';

  @override
  String otpResendIn(String time) {
    return 'Resend OTP in $time';
  }

  @override
  String get otpTapToResend => 'Tap to resend';

  @override
  String get otpVerifyContinue => 'Verify & Continue';

  @override
  String get otpIncomplete => 'Enter the full 6-digit code.';

  @override
  String get otpSentAgain => 'A new OTP has been sent.';

  @override
  String get authErrorInvalidPhone =>
      'That phone number doesn\'t look right. Please check and try again.';

  @override
  String get authErrorTooManyRequests =>
      'Too many attempts. Please wait a while before trying again.';

  @override
  String get authErrorQuotaExceeded =>
      'SMS quota exceeded for now. Please try again later.';

  @override
  String get authErrorInvalidCode =>
      'Incorrect OTP. Please check the code and try again.';

  @override
  String get authErrorCodeExpired =>
      'This OTP has expired. Please request a new one.';

  @override
  String get authErrorUserDisabled =>
      'This account has been disabled. Please contact support.';

  @override
  String get authErrorNotEnabled =>
      'Phone sign-in isn\'t enabled for this app yet.';

  @override
  String get authErrorCredentialInUse =>
      'This phone number is already linked to another account.';

  @override
  String get commonContinue => 'Continue';

  @override
  String get commonViewAll => 'View All';

  @override
  String get commonResume => 'Resume';

  @override
  String questionCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Questions',
      one: '1 Question',
    );
    return '$_temp0';
  }

  @override
  String get difficultyEasy => 'Easy';

  @override
  String get difficultyMedium => 'Medium';

  @override
  String get difficultyHard => 'Hard';

  @override
  String get goalHeadingLead => 'What brings you';

  @override
  String get goalHeadingAccent => 'to Nyaya?';

  @override
  String get goalSubtitle => 'Choose your goal — you can change it anytime.';

  @override
  String get goalFootnote => 'You can switch goals later in Profile.';

  @override
  String get goalLearnLawTitle => 'Learn law for life';

  @override
  String get goalLearnLawBody =>
      'Everyday legal know-how for work, family and your rights';

  @override
  String get goalExamTitle => 'Crack an exam';

  @override
  String get goalExamBody =>
      'Sharpen exam-style MCQ practice and statute mastery';

  @override
  String get goalStudyTitle => 'Study law';

  @override
  String get goalStudyBody => 'Master your LLB subjects, concept by concept';

  @override
  String get homeHeroLead => 'Test Your';

  @override
  String get homeHeroAccent => 'Legal Knowledge.';

  @override
  String get homeHeroTrail => 'Master Justice.';

  @override
  String get homeHeroSupport => 'Quizzes on Law. Insights for Life.';

  @override
  String get homeStartQuiz => 'Start Quiz';

  @override
  String get homeNotifications => 'Notifications';

  @override
  String get homeExploreByCategory => 'Explore by Category';

  @override
  String get homeContinueLearning => 'Continue Learning';

  @override
  String get homePopularQuizzes => 'Popular Quizzes';

  @override
  String get homeDailyQuestions => 'Daily Questions';

  @override
  String get homeDailyQuestionsSubtitle =>
      'Sharpen your mind with today\'s random questions';

  @override
  String get homeDailyQuestionsEmpty => 'No questions available yet.';

  @override
  String get homeDailyShowAnswer => 'Show answer';

  @override
  String get homeDailyHideAnswer => 'Hide answer';

  @override
  String homeDailyQuestionSemantics(
    int number,
    String question,
    String category,
  ) {
    return 'Question $number: $question. $category';
  }

  @override
  String get categoriesSubtitle =>
      'Explore topics and strengthen your legal knowledge.';

  @override
  String get categoriesSearchHint => 'Search categories';

  @override
  String get categoriesNoMatch => 'No categories match your search.';

  @override
  String get categoriesFilters => 'Filters';

  @override
  String get topicBookmark => 'Bookmark topic';

  @override
  String get topicRemoveBookmark => 'Remove bookmark';

  @override
  String get topicQuizzesHeading => 'Quizzes';

  @override
  String topicContinueQuiz(int number) {
    return 'Continue quiz $number';
  }

  @override
  String get quizStatusCompleted => 'completed';

  @override
  String get quizStatusInProgress => 'in progress';

  @override
  String get quizStatusNotStarted => 'not started';

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
      other: '$count questions',
      one: '1 question',
    );
    return '$title. $_temp0, $difficulty. $status';
  }

  @override
  String get quizExit => 'Exit quiz';

  @override
  String quizCounter(int current, int total) {
    return 'Question $current of $total';
  }

  @override
  String get quizSelectAnswer => 'Select an answer';

  @override
  String quizOptionLabel(String letter, String text) {
    return 'Option $letter. $text';
  }

  @override
  String get quizYourAnswerCorrect => 'Your answer, correct';

  @override
  String get quizYourAnswerWrong => 'Your answer, wrong';

  @override
  String get quizCorrectAnswer => 'Correct answer';

  @override
  String get quizVerdictCorrect => 'Correct!';

  @override
  String get quizVerdictWrong => 'Not quite';

  @override
  String get resultHeadline => 'Well Done!';

  @override
  String resultCompleted(String topic) {
    return '$topic — completed';
  }

  @override
  String get resultThisTopic => 'this topic';

  @override
  String resultScoreSemantics(String score, String percent) {
    return 'Your score: $score, $percent';
  }

  @override
  String get resultCorrect => 'Correct';

  @override
  String get resultWrong => 'Wrong';

  @override
  String resultCorrectCount(int count) {
    return '$count correct';
  }

  @override
  String resultWrongCount(int count) {
    return '$count wrong';
  }

  @override
  String resultWeakList(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count questions added to your weak list.',
      one: '1 question added to your weak list.',
    );
    return '$_temp0';
  }

  @override
  String get resultReviewAnswers => 'Review answers';

  @override
  String get resultBackToTopic => 'Back to topic';

  @override
  String get legalUpdatesTitle => 'Legal Updates';

  @override
  String get legalUpdatesEmpty => 'No legal updates yet.';

  @override
  String get legalUpdatesCategoryJudgements => 'Judgements';

  @override
  String get legalUpdatesCategoryLegislation => 'Legislation';

  @override
  String get legalUpdatesCategoryReforms => 'Reforms';

  @override
  String get legalUpdatesCategoryNotices => 'Notices';

  @override
  String get commonSoon => 'Soon';

  @override
  String homeProgressQuizzesCompleted(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count quizzes completed',
      one: '1 quiz completed',
    );
    return '$_temp0';
  }

  @override
  String homeProgressPoints(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count points',
      one: '1 point',
    );
    return '$_temp0';
  }

  @override
  String homeProgressAccuracy(int percent) {
    return 'Accuracy $percent%';
  }

  @override
  String get homeProgressEmpty => 'No quizzes yet. Take your first quiz!';

  @override
  String get homeAskNyayaTitle => 'Ask Nyaya';

  @override
  String get homeAskNyayaBody =>
      'Ask your legal questions in simple language. Get clear answers.';

  @override
  String get homeRecommended => 'Recommended for you';

  @override
  String get articlesHeroTitle => 'Learn & Stay Updated';

  @override
  String get articlesHeroSubtitle => 'Stay informed. Understand the law.';

  @override
  String articlesPart(String part, String title) {
    return 'Part $part · $title';
  }

  @override
  String get articlesEmpty => 'No articles yet.';

  @override
  String get articlesReadArticle => 'Read article';

  @override
  String get articleWhatItMeans => 'What it means';

  @override
  String get articleWhyItMatters => 'Why it matters';

  @override
  String get articleKeyFeatures => 'Key features';

  @override
  String get profileStatsTitle => 'My statistics';

  @override
  String get profileStatStreak => 'Day streak';

  @override
  String get profileStatCategories => 'Categories explored';

  @override
  String get profileStatQuizzes => 'Quizzes completed';

  @override
  String get profileStatPoints => 'Points earned';

  @override
  String get profileEdit => 'Edit profile';

  @override
  String get profileSettingsTitle => 'Account & settings';

  @override
  String get profileLanguage => 'Language';

  @override
  String get profileReminders => 'Daily reminders';

  @override
  String get profilePrivacy => 'Privacy & security';

  @override
  String get profileHelpSupport => 'Help & support';

  @override
  String get profileHelpResources => 'Legal help resources';

  @override
  String get profileAbout => 'About Nyaya';

  @override
  String get profileLogout => 'Log out';

  @override
  String get profileLogoutConfirmTitle => 'Log out of Nyaya?';

  @override
  String get profileLogoutConfirmBody =>
      'You\'ll need your phone number and a code to sign in again.';

  @override
  String get editProfileSave => 'Save changes';

  @override
  String get editProfileSaved => 'Profile updated';

  @override
  String get editProfileChangePhoto => 'Change photo';

  @override
  String get editProfileCamera => 'Take a photo';

  @override
  String get editProfileGallery => 'Choose from gallery';

  @override
  String get editProfilePhotoUpdated => 'Photo updated';

  @override
  String get editProfilePhotoFailed =>
      'Couldn\'t open the camera or photos. Check Nyaya\'s permissions.';

  @override
  String get remindersToggle => 'Daily reminder';

  @override
  String get remindersToggleSubtitle => 'Get a nudge to practise each day';

  @override
  String get remindersTime => 'Reminder time';

  @override
  String get remindersPermissionDenied =>
      'Notifications are off for Nyaya. Turn them on in your phone\'s settings to get reminders.';

  @override
  String get reminderNotificationBody =>
      'Time for your daily legal practice — keep your streak going.';

  @override
  String get privacySessionsTitle => 'Active sessions';

  @override
  String get privacySessionsBody => 'Sign-ins currently active on your account';

  @override
  String get privacyLogoutAll => 'Log out from all devices';

  @override
  String get privacyLogoutAllConfirm =>
      'This will sign you out on every device, including this one.';

  @override
  String get privacyNoPassword =>
      'You sign in with your phone number and a one-time code, so there\'s no password to change.';

  @override
  String get aboutTagline => 'Law basics, one quiz at a time';

  @override
  String aboutVersion(String version) {
    return 'Version $version';
  }

  @override
  String get aboutDescription =>
      'Nyaya helps you understand Indian law in simple language — learn the Constitution article by article, test your knowledge and stay updated on legal developments.';

  @override
  String get aboutFeaturesTitle => 'What you\'ll find in Nyaya';

  @override
  String get aboutFeatureArticles =>
      'Article-by-article guide to the Indian Constitution';

  @override
  String get aboutFeatureDaily => 'Daily legal questions with clear answers';

  @override
  String get aboutFeatureUpdates => 'Latest legal updates and judgements';

  @override
  String get aboutFeatureQuizzes => 'Quizzes that test what you\'ve learned';

  @override
  String get aboutFeatureLanguages =>
      'Available in English, Hindi, Tamil, Telugu and Kannada';

  @override
  String get remindersFailed => 'Couldn\'t set the reminder. Please try again.';

  @override
  String get reminderChannelName => 'Daily practice reminder';

  @override
  String get supportContactTitle => 'Contact support';

  @override
  String get supportSubject => 'Subject';

  @override
  String get supportMessage => 'Message';

  @override
  String get supportSend => 'Send request';

  @override
  String get supportSent => 'Your request has been sent.';

  @override
  String get supportRequestsTitle => 'Your requests';

  @override
  String get supportRequestsEmpty => 'You haven\'t sent any requests yet.';

  @override
  String get supportStatusOpen => 'Open';

  @override
  String get supportStatusInProgress => 'In progress';

  @override
  String get supportStatusResolved => 'Resolved';

  @override
  String get supportStatusClosed => 'Closed';

  @override
  String get validationRequired => 'Required';

  @override
  String supportMessageTooShort(int min) {
    return 'Please write at least $min characters';
  }

  @override
  String get helpResSubtitle =>
      'Find verified legal help contacts in your state.';

  @override
  String get helpResState => 'State';

  @override
  String get helpResCategory => 'Kind of help';

  @override
  String get helpResEmergency => 'In an emergency, dial 112.';

  @override
  String get helpResNational => 'National helpline';

  @override
  String helpResVerified(String date) {
    return 'Source verified $date';
  }

  @override
  String get helpResNeedsVerification => 'Needs verification';

  @override
  String helpResCall(String number) {
    return 'Call $number';
  }

  @override
  String get helpResTollFree => 'Toll-free';

  @override
  String get helpResPhone => 'Phone';

  @override
  String get helpResEmail => 'Email';

  @override
  String get helpResWebsite => 'Website';

  @override
  String helpResHours(String hours) {
    return 'Hours: $hours';
  }

  @override
  String helpResSource(String name) {
    return 'Source: $name';
  }

  @override
  String get helpResEmpty =>
      'No verified contacts for this choice. Try another kind of help or state.';

  @override
  String get helpResOpenFailed => 'Couldn\'t open this on your phone.';
}
