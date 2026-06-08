// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'SAGEN';

  @override
  String get appSlogan => 'Your digital shield';

  @override
  String get greetingMorning => 'Good morning';

  @override
  String get greetingAfternoon => 'Good afternoon';

  @override
  String get greetingEvening => 'Good evening';

  @override
  String get homeTitle => 'Your digital shield is active';

  @override
  String get learnTitle => 'Learn';

  @override
  String get learnSubtitle => 'Interactive cybersecurity lessons';

  @override
  String get streakTitle => 'My Streak';

  @override
  String streakDays(Object count) {
    return '$count days';
  }

  @override
  String get streakCurrent => 'Current streak';

  @override
  String get streakLongest => 'Best streak';

  @override
  String get streakFreeze => 'Streak Shield';

  @override
  String get analyzeLink => 'Analyze link';

  @override
  String get analyzeFile => 'Analyze file';

  @override
  String get fileAnalyzer => 'File Analyzer';

  @override
  String get tutorTitle => 'AI Tutor';

  @override
  String get historyTitle => 'History';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get profileTitle => 'My Profile';

  @override
  String get languageTitle => 'Language';

  @override
  String get themeTitle => 'Appearance';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get themeSystem => 'System';

  @override
  String get spanish => 'Spanish';

  @override
  String get english => 'English';

  @override
  String get offlineMessage => 'No internet connection.';

  @override
  String get offlineAction => 'Connect and try again.';

  @override
  String get chatFallback => 'I couldn\'t respond right now. Please try again.';

  @override
  String get summarizeButton => 'Quick summary';

  @override
  String get lessonComplete => 'Lesson complete';

  @override
  String correctAnswers(Object correct, Object total) {
    return '$correct of $total correct';
  }

  @override
  String xpReward(Object xp) {
    return '+$xp XP';
  }

  @override
  String gemReward(Object gems) {
    return '+$gems gems';
  }

  @override
  String get continueText => 'Continue';

  @override
  String get nextText => 'Next';

  @override
  String get finishText => 'Finish';

  @override
  String get startText => 'Start';

  @override
  String get viewAll => 'View all';

  @override
  String get yourLearning => 'Your learning';

  @override
  String get quickActions => 'Quick actions';

  @override
  String get yourActivity => 'Your activity';

  @override
  String get totalProgress => 'Total progress';

  @override
  String lessonsCompleted(Object count) {
    return '$count lessons completed';
  }

  @override
  String get learningPath => 'Your learning path';

  @override
  String get completePrevious => 'Complete previous stage';

  @override
  String lessonsCount(Object count) {
    return '$count lessons';
  }

  @override
  String minutes(Object min) {
    return '$min min';
  }

  @override
  String questions(Object count) {
    return '$count questions';
  }

  @override
  String get noConnection => 'No internet connection.';

  @override
  String get tryAgain => 'Connect and try again.';

  @override
  String get challengeTrueFalse => 'True / False';

  @override
  String get challengeMultiple => 'Multiple choice';

  @override
  String get challengeComplete => 'Complete the phrase';

  @override
  String get challengeDetectRisk => 'Detect risk';

  @override
  String get challengeCreatePassword => 'Create password';

  @override
  String get challengeWhatWouldYouDo => 'What would you do?';

  @override
  String get challengeMiniCase => 'Real case';

  @override
  String get fileSafe => 'Safe';

  @override
  String get fileLowRisk => 'Low risk';

  @override
  String get fileMediumRisk => 'Medium risk';

  @override
  String get fileHighRisk => 'High risk';

  @override
  String get fileDangerous => 'Dangerous';

  @override
  String get selectFile => 'Select file';

  @override
  String get analyzing => 'Analyzing...';

  @override
  String get notificationStreakAlive => 'Your streak is still alive!';

  @override
  String get notificationStreakLoss => 'It\'s never too late to start again.';

  @override
  String get notificationTip => 'Your digital shield is waiting for you.';

  @override
  String get notificationReminder =>
      'Five minutes today can help you tomorrow.';

  @override
  String get authTitle => 'Your digital protection starts here';

  @override
  String get authSubtitle =>
      'Learn, protect yourself, and browse the internet more safely.';

  @override
  String get authGoogleButton => 'Continue with Google';

  @override
  String get authPrivacy => 'Your information is protected.';

  @override
  String get skipText => 'Skip';

  @override
  String get onboardingWelcome => 'Learn to protect yourself';

  @override
  String get onboardingWelcomeDesc =>
      'SAGEN teaches you to browse, detect risks, and protect your information online.';

  @override
  String get challengeSafe => 'Safe';

  @override
  String get challengeSuspicious => 'Suspicious';

  @override
  String get onboardingComplete => 'Great! You can now detect basic phishing.';

  @override
  String get onboardingError =>
      'That\'s how they operate. They always verify before trusting.';

  @override
  String get challenge_complete_lesson_title => 'Complete Lessons';

  @override
  String challenge_complete_lesson_desc(Object count) {
    return 'Complete $count lesson(s)';
  }

  @override
  String get challenge_analyze_link_title => 'Analyze Links';

  @override
  String challenge_analyze_link_desc(Object count) {
    return 'Analyze $count link(s)';
  }

  @override
  String get challenge_talk_sage_title => 'Chat with Sage';

  @override
  String challenge_talk_sage_desc(Object count) {
    return 'Chat with Sage $count time(s)';
  }

  @override
  String get challenge_check_in_title => 'Daily Check-in';

  @override
  String challenge_check_in_desc(Object count) {
    return 'Check in $count time(s)';
  }

  @override
  String get challenge_answer_questions_title => 'Answer Questions';

  @override
  String challenge_answer_questions_desc(Object count) {
    return 'Answer $count question(s)';
  }

  @override
  String get challenge_detect_phishing_title => 'Detect Phishing';

  @override
  String challenge_detect_phishing_desc(Object count) {
    return 'Detect $count phishing attempt(s)';
  }

  @override
  String get challenge_review_tips_title => 'Review Security Tips';

  @override
  String challenge_review_tips_desc(Object count) {
    return 'Review $count security tip(s)';
  }

  @override
  String get challenge_complete_session_title => 'Learning Sessions';

  @override
  String challenge_complete_session_desc(Object count) {
    return 'Complete $count learning session(s)';
  }

  @override
  String get challenge_share_knowledge_title => 'Share Knowledge';

  @override
  String challenge_share_knowledge_desc(Object count) {
    return 'Share $count tip(s)';
  }

  @override
  String get challenge_streak_milestone_title => 'Streak Milestone';

  @override
  String challenge_streak_milestone_desc(Object count) {
    return 'Maintain a $count-day streak';
  }

  @override
  String get challenge_privacy_check_title => 'Privacy Check';

  @override
  String challenge_privacy_check_desc(Object count) {
    return 'Review privacy settings $count time(s)';
  }

  @override
  String get challenge_security_audit_title => 'Security Audit';

  @override
  String challenge_security_audit_desc(Object count) {
    return 'Complete $count security audit(s)';
  }

  @override
  String get challenge_learn_topic_title => 'Learn a Topic';

  @override
  String challenge_learn_topic_desc(Object count) {
    return 'Learn $count topic(s)';
  }

  @override
  String get challenge_quiz_night_title => 'Mini Quiz';

  @override
  String challenge_quiz_night_desc(Object count) {
    return 'Complete $count mini quiz(es)';
  }

  @override
  String get challenge_social_awareness_title => 'Social Awareness';

  @override
  String challenge_social_awareness_desc(Object count) {
    return 'Complete $count social awareness challenge(s)';
  }

  @override
  String get challenge_test_password_title => 'Test Passwords';

  @override
  String challenge_test_password_desc(Object count) {
    return 'Test $count password(s)';
  }

  @override
  String get challenge_use_dark_mode_title => 'Dark Mode';

  @override
  String get challenge_use_dark_mode_desc => 'Use dark mode';

  @override
  String get challenge_earn_xp_title => 'Earn XP';

  @override
  String challenge_earn_xp_desc(Object xp) {
    return 'Earn $xp XP';
  }

  @override
  String get challenge_learn_minutes_title => 'Learning Time';

  @override
  String challenge_learn_minutes_desc(Object count) {
    return 'Learn for $count minutes';
  }

  @override
  String get challenge_correct_streak_title => 'Correct Streak';

  @override
  String challenge_correct_streak_desc(Object count) {
    return 'Get $count correct answers in a row';
  }

  @override
  String get challenge_perfect_lesson_title => 'Perfect Lesson';

  @override
  String get challenge_perfect_lesson_desc =>
      'Complete a lesson with no errors';

  @override
  String get challenge_complete_stage_title => 'Complete Stage';

  @override
  String get challenge_complete_stage_desc => 'Complete 1 stage';

  @override
  String get myAccount => 'My Account';

  @override
  String get cloudSync => 'Cloud Sync';

  @override
  String get experience => 'Experience';

  @override
  String get infoSection => 'Information';

  @override
  String get privacyLegal => 'Privacy & Legal';

  @override
  String get updates => 'Updates';

  @override
  String get aboutSection => 'About';

  @override
  String get howItWorks => 'How SAGEN works';

  @override
  String get ourMission => 'Our Mission';

  @override
  String get aboutSage => 'About Sage';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get termsConditions => 'Terms & Conditions';

  @override
  String get deleteHistory => 'Delete Analysis History';

  @override
  String get newsUpdates => 'News & Updates';

  @override
  String get newBadge => 'NEW';

  @override
  String get deleteHistoryTitle => 'Delete History';

  @override
  String get deleteHistoryDesc =>
      'All saved link analyses will be deleted. This action cannot be undone.';

  @override
  String get cancel => 'Cancel';

  @override
  String get deleteAction => 'Delete';

  @override
  String get historyDeleted => 'History deleted';

  @override
  String get developedWith => 'Built with Flutter';

  @override
  String get madeWithLove => 'Made with ♥ for students';

  @override
  String get syncStatus => 'Sync Status';

  @override
  String get syncing => 'Syncing...';

  @override
  String get lastSync => 'Last sync';

  @override
  String get never => 'Never';

  @override
  String get forceSync => 'Force Sync';

  @override
  String get restoreCloud => 'Restore from Cloud';

  @override
  String get deleteCloudData => 'Delete Cloud Data';

  @override
  String get sounds => 'Sounds';

  @override
  String get soundsSubtitle => 'App sound effects';

  @override
  String get hapticFeedback => 'Haptic Feedback';

  @override
  String get hapticSubtitle => 'Haptic response on interactions';

  @override
  String get reduceAnimations => 'Reduce Animations';

  @override
  String get reduceAnimationsSubtitle => 'Reduces animation intensity';

  @override
  String get restoreTitle => 'Restore Progress';

  @override
  String get restoreDesc =>
      'Do you want to restore your progress from the cloud? This will replace local data with your saved account data.';

  @override
  String get restoreAction => 'Restore';

  @override
  String get deleteCloudTitle => 'Delete Cloud Data';

  @override
  String get deleteCloudDesc =>
      'Are you sure? This will permanently delete your saved cloud progress. Local data will not be affected.';

  @override
  String get cloudDataDeleted => 'Cloud data deleted';

  @override
  String get progressRestored => 'Progress restored from cloud';

  @override
  String get syncSnackbar => 'Progress synced';

  @override
  String get scheduledDarkMode => 'Scheduled Dark Mode';

  @override
  String get scheduledDarkModeSubtitle => 'Auto on/off based on schedule';

  @override
  String get darkModeStart => 'Start dark mode';

  @override
  String get darkModeEnd => 'End dark mode';

  @override
  String darkModeScheduleInfo(Object end, Object start) {
    return 'Dark mode will be active from $start:00 to $end:00';
  }

  @override
  String get authLoginTitle => 'Enter your details';

  @override
  String get authLoginButton => 'LOG IN';

  @override
  String get authEmailLabel => 'Email';

  @override
  String get authEmailError => 'Enter your email';

  @override
  String get authPasswordLabel => 'Password';

  @override
  String get authPasswordError => 'Enter your password';

  @override
  String get authForgotPasswordButton => 'RESET PASSWORD';

  @override
  String get authForgotPasswordTitle => 'Reset password';

  @override
  String get authForgotPasswordDesc =>
      'We\'ll send you a link to reset your password.';

  @override
  String get authSendLink => 'Send link';

  @override
  String get authRecoveryEmailSentTitle => 'Email sent';

  @override
  String get authRecoveryEmailSentDesc =>
      'Check your inbox and follow the instructions to reset your password.';

  @override
  String get authRecoveryEmailSentMessage => 'Recovery email sent';

  @override
  String get authEnterEmailError => 'Enter your email';

  @override
  String get authBack => 'Back';

  @override
  String get authNoAccount => 'Don\'t have an account? ';

  @override
  String get authCreateAccount => 'Create account';

  @override
  String get authRegisterTitle => 'Create your account';

  @override
  String get authFullName => 'Full name';

  @override
  String get authNameError => 'Enter your name';

  @override
  String get authAge => 'Age';

  @override
  String get authPasswordMinHint => 'Password (min. 6 characters)';

  @override
  String get authPasswordMinError => 'Password must be at least 6 characters';

  @override
  String get authOrRegisterWith => 'or sign up with';

  @override
  String get authHaveAccount => 'Already have an account? ';

  @override
  String get authLoginLink => 'Log in';

  @override
  String get authEmailVerificationSent =>
      'Check your email to verify your account';

  @override
  String get authLoginError => 'Error logging in';

  @override
  String get authGoogleError => 'Error signing in with Google';

  @override
  String get authFacebookError => 'Error signing in with Facebook';

  @override
  String get authCreateAccountError => 'Error creating account';

  @override
  String get authRegisterGoogleError => 'Error signing up with Google';

  @override
  String get authRegisterFacebookError => 'Error signing up with Facebook';

  @override
  String get authSendEmailError => 'Error sending email';

  @override
  String get authFirebaseUnavailable => 'Firebase is not available';

  @override
  String get authCanceled => 'Sign in canceled';

  @override
  String get authNullUser => 'Could not get user';

  @override
  String get authUnknown => 'An unexpected error occurred';

  @override
  String get authNullToken => 'Could not get Facebook token';

  @override
  String get authNotFound => 'No account found with this email';

  @override
  String get authWrongPassword => 'Incorrect password';

  @override
  String get authInvalidCredential => 'Incorrect email or password';

  @override
  String get authEmailInUse => 'An account already exists with this email';

  @override
  String get authWeakPassword => 'Password must be at least 6 characters';

  @override
  String get authInvalidEmail => 'Invalid email format';

  @override
  String get authTooManyRequests => 'Too many attempts. Please wait.';

  @override
  String get authNetworkError => 'No internet connection';

  @override
  String get authDefault => 'Authentication error';

  @override
  String get authNotVerified => 'Email not verified yet. Check your inbox.';

  @override
  String get authVerifyError => 'Could not verify. Try again.';

  @override
  String get authRecoveryError => 'Could not send recovery email';

  @override
  String get authNotAuthenticated => 'No authenticated user';

  @override
  String get authResendEmailError => 'Could not resend verification email';

  @override
  String get welcomeSubtitle =>
      'Intelligent analysis and digital security.\nFree forever.';

  @override
  String get welcomeStartButton => 'START NOW';

  @override
  String get welcomeLoginButton => 'I ALREADY HAVE AN ACCOUNT';

  @override
  String get navHome => 'Home';

  @override
  String get navChest => 'Chest';

  @override
  String get navSage => 'Sage';

  @override
  String get navRanking => 'Ranking';

  @override
  String get navProfile => 'Profile';

  @override
  String get homeAllComplete => 'All complete!';

  @override
  String get homeAllCompleteDesc => 'You have mastered all lessons.';

  @override
  String get homeContinue => 'Continue';

  @override
  String get homeViewAchievements => 'View achievements';

  @override
  String get homeLearningPath => 'Learning path';

  @override
  String get lessonsYourPath => 'Your learning path';

  @override
  String lessonsLevel(Object level) {
    return 'Level $level';
  }

  @override
  String get profileStreak => 'Streak';

  @override
  String get profileXpLabel => 'XP';

  @override
  String get profileGems => 'Gems';

  @override
  String get profileAchievements => 'Achievements';

  @override
  String get storeNotEnoughGems => 'You don\'t have enough gems';

  @override
  String get storePurchaseSuccess => 'Purchase successful!';

  @override
  String get storeProtectStreak => 'Protect your streak';

  @override
  String get storeGetGems => 'Get gems';

  @override
  String get storePersonalization => 'Personalization';

  @override
  String get rankingTitle => 'The Coliseum';

  @override
  String get rankingSubtitle => 'Global ranking · Top 50';

  @override
  String get rankingError => 'Error loading ranking';

  @override
  String get rankingShareSubtitle => 'Beat my rank on SAGEN';

  @override
  String get rankingShareButton => 'Share Flex Card';

  @override
  String get rankingSharing => 'Sharing...';

  @override
  String get rankingEmptyMessage => 'Complete lessons to enter the ranking';

  @override
  String get regHowContinue => 'How would you like to continue?';

  @override
  String get regChooseMethod => 'Choose a method to create your account.';

  @override
  String get regEmailOption => 'Email';

  @override
  String get regAgeQuestion => 'How old are you?';

  @override
  String get regAgeValidation => 'Please enter your real age';

  @override
  String get regEmailTitle => 'Your email';

  @override
  String get regEmailDesc => 'We\'ll send you a verification code.';

  @override
  String get regEmailHint => 'example@email.com';

  @override
  String get regPasswordTitle => 'Create a password';

  @override
  String get regPasswordDesc => 'Minimum 6 characters to protect your account.';

  @override
  String get regNameQuestion => 'What\'s your name?';

  @override
  String get regNameHint => 'First name';

  @override
  String get regSurnameHint => 'Last name';

  @override
  String get regProfileAlmostReady => 'Almost ready!';

  @override
  String get regProfileDesc =>
      'Create a profile to save your progress and keep your streak.';

  @override
  String get regCloudSave => 'Cloud-saved progress';

  @override
  String get regStreakSync => 'Streak synced across devices';

  @override
  String get regRewards => 'Personal rewards and achievements';

  @override
  String get regCreateProfile => 'CREATE PROFILE';

  @override
  String get regLater => 'Later';

  @override
  String get regProfileCreated => 'PROFILE CREATED';

  @override
  String get regWelcomeSagen => 'Welcome to SAGEN!';

  @override
  String get regReadyForLesson => 'Get ready for your first lesson';

  @override
  String get lessonPreparing => 'Preparing your questions...';

  @override
  String get lessonNoQuestions => 'No questions available for this lesson';

  @override
  String get sessionLoading => 'Loading...';

  @override
  String get sessionSelectAnswer => 'Select an answer';

  @override
  String get sessionCorrect => 'Correct!';

  @override
  String get sessionIncorrect => 'Incorrect';

  @override
  String sessionCorrectAnswer(Object answer) {
    return 'Correct answer: $answer';
  }

  @override
  String get sessionLivesExhausted => 'Lives exhausted';

  @override
  String get sessionLivesExhaustedDesc => 'You lost all your lives. Try again.';

  @override
  String sessionScore(Object correct, Object total) {
    return '$correct/$total correct';
  }

  @override
  String get sessionRetry => 'Retry';

  @override
  String get sessionBackToMap => 'Back to map';

  @override
  String get resultPerfectBadge => 'PERFECT SESSION';

  @override
  String get resultPerfectTitle => 'Flawless result!';

  @override
  String get resultCompleteTitle => 'Lesson completed!';

  @override
  String get resultPerfectDesc =>
      'You made no mistakes. You are a digital guardian.';

  @override
  String get resultNotPerfectDesc =>
      'Keep practicing to achieve a perfect session.';

  @override
  String get resultAccuracy => 'Accuracy';

  @override
  String get resultLives => 'Lives';

  @override
  String get statsNoData => 'No lesson data';

  @override
  String get statsReceiveXp => 'RECEIVE XP';

  @override
  String get statsSpeed => 'Speed';

  @override
  String get statsNoErrors => 'No errors!';

  @override
  String get statsIncredible => 'Incredible!';

  @override
  String get statsExcellent => 'Excellent!';

  @override
  String get statsWellDone => 'Well done!';

  @override
  String get statsKeepTrying => 'Keep trying.';

  @override
  String get reviewTitle => 'Review';

  @override
  String get reviewNoErrors => 'No errors to review';

  @override
  String get reviewKeepGoing => 'Keep it up!';

  @override
  String get reviewComplete => 'Review complete!';

  @override
  String get reviewGoodProgress => 'Good progress';

  @override
  String get reviewKeepPracticing => 'Keep practicing';

  @override
  String get reviewSagePerfect =>
      'Your weak areas are improving. I can see your effort.';

  @override
  String get reviewSageGood =>
      'Each review strengthens your shield. Ready for more?';

  @override
  String get reviewSageKeep =>
      'Reviewing is part of learning. You can try again anytime.';

  @override
  String get reviewCorrect => 'correct';

  @override
  String get reviewFinish => 'Finish review';

  @override
  String firstLessonProgress(Object current, Object total) {
    return 'Lesson $current of $total';
  }

  @override
  String get firstLessonSeeResults => 'SEE RESULTS';

  @override
  String get back => 'Back';

  @override
  String get splashTitle => 'SAGEN';

  @override
  String get streakBadge => 'STREAK';

  @override
  String get streakKeepAlive => 'Keep your streak alive!';

  @override
  String get streakKeepAliveDesc =>
      'Complete a lesson each day to keep your streak.\nEvery day counts to strengthen your digital shield.';

  @override
  String get streakStrongerShield => 'Stronger shield every day';

  @override
  String get streakRewards => 'Exclusive rewards when reaching goals';

  @override
  String get streakAchievements => 'Achievements and medals for consistency';

  @override
  String get streakGotIt => 'GOT IT';

  @override
  String get commitChooseGoal => 'Choose your goal';

  @override
  String get commitChooseGoalDesc =>
      'Select how many days you will follow your learning plan.';

  @override
  String get commit1Week => '1 week';

  @override
  String get commit2Weeks => '2 weeks';

  @override
  String get commit1Month => '1 month';

  @override
  String commitDays(Object days) {
    return '$days days';
  }

  @override
  String get commitSelected => 'SELECTED';

  @override
  String commitYourGoal(Object days) {
    return 'Your goal: $days days';
  }

  @override
  String get commitButton => 'COMMIT TO MY GOAL';

  @override
  String commitGoalLabel(Object days) {
    return 'Your goal: $days days';
  }

  @override
  String get onboardingDesc =>
      'Your personal digital security assistant.\nLearn, analyze and protect yourself for free.';

  @override
  String get onboardingSageStart => 'A great start! Every day counts.';

  @override
  String get onboardingSageTwoWeeks =>
      'Two weeks of consistency. You are unstoppable!';

  @override
  String get onboardingSageMonth =>
      'One month of discipline. Habits are forged.';

  @override
  String get onboardingSage50Days =>
      '50 days of dedication. Legend in the making!';

  @override
  String get onboardingSageExcellent => 'Excellent reasons, aim high!';

  @override
  String get summaryOrigin => 'Origin';

  @override
  String get summaryKnowledge => 'Knowledge';

  @override
  String get summaryInterest => 'Interest';

  @override
  String get summaryMotivations => 'Motivations';

  @override
  String get summaryLearning => 'Learning';

  @override
  String get summaryDailyGoal => 'Daily goal';

  @override
  String get summaryCommitment => 'Commitment';

  @override
  String get summaryReady => 'All set to start your digital security journey.';

  @override
  String get profileError => 'Error loading profile';

  @override
  String get profileLevel => 'Level';

  @override
  String get profileTotalXp => 'Total XP';

  @override
  String get settingsLogout => 'Log out';

  @override
  String get settingsLogoutConfirm => 'Are you sure you want to log out?';

  @override
  String get rewardAdTitle => 'Earn extra gems';

  @override
  String get rewardAdSubtitle => 'Watch an ad and receive gems instantly';

  @override
  String get rewardAdWatch => 'Watch';

  @override
  String rewardAdEarned(Object count) {
    return 'You earned $count gems!';
  }

  @override
  String get rewardAdNotAvailable =>
      'The ad is not available now. Try again later.';

  @override
  String get rankCybersecurityLegend => 'Cybersecurity Legend';

  @override
  String get rankEliteDefender => 'Elite Defender';

  @override
  String get rankExperiencedWarrior => 'Experienced Warrior';

  @override
  String get rankActiveLearner => 'Active Learner';

  @override
  String get rankNovice => 'Novice';

  @override
  String get profileDefaultName => 'Guardian';

  @override
  String profileLevelValue(Object level) {
    return 'Level $level';
  }

  @override
  String get profileDay => 'day';

  @override
  String get profileDays => 'days';

  @override
  String rankingPosition(Object rank) {
    return 'Rank #$rank';
  }

  @override
  String get flexCardJoinAlliance => 'Join my alliance on SAGEN';

  @override
  String get raritySilver => 'Silver';

  @override
  String get rarityGold => 'Gold';

  @override
  String get rarityPlatinum => 'Platinum';

  @override
  String get achievementLocked => '???';

  @override
  String get streakFrozen => 'Streak frozen';

  @override
  String streakDaysCount(Object count) {
    return '$count day streak';
  }

  @override
  String get streakNoActiveStreak => 'No active streak';

  @override
  String get streakFreezeDescription => 'Keep your streak when you miss a day';

  @override
  String get storeShieldLimitReached => 'Shield limit reached';

  @override
  String get storeChestAvailable => 'Daily Chest Available!';

  @override
  String get storeChestComeBack => 'Come back tomorrow';

  @override
  String storeChestGemsExpire(Object gems) {
    return '$gems gems — expires at midnight';
  }

  @override
  String get storeChestRenews => 'Your chest renews every day';

  @override
  String get storeOpen => 'Open';

  @override
  String get storeTitle => 'Store';

  @override
  String get storeGemsLabel => 'gems';

  @override
  String get storeBuyGems => 'Buy gems';

  @override
  String storeWhatsappPackages(Object price) {
    return 'Packages from $price — Pay via WhatsApp';
  }

  @override
  String get storeAdEarnGem => 'Earn 1 extra gem';

  @override
  String get storeAdWatchVideo => 'Watch a 30-second video';

  @override
  String get storeAdRewardMessage => '+1 Gem for watching the ad';

  @override
  String get storeWatch => 'Watch';

  @override
  String get paywallBasic => 'Basic';

  @override
  String get paywallPopular => 'Popular';

  @override
  String get paywallPremium => 'Premium';

  @override
  String paywallWhatsAppMessage(Object gems, Object price, Object userId) {
    return 'Hi, I want to buy the $gems gems package for S/$price in SAGEN. My user ID is: $userId';
  }

  @override
  String paywallWhatsAppFallback(Object message) {
    return 'Open WhatsApp and send: $message';
  }

  @override
  String paywallWhatsAppError(Object link) {
    return 'Error opening WhatsApp. Pay via: $link';
  }

  @override
  String get paywallGetMoreGems => 'Get more gems';

  @override
  String get paywallDescription =>
      'Choose your package and we\'ll contact you via WhatsApp to coordinate payment.';

  @override
  String get paywallPaymentMethods =>
      'Pay with Yape, Plin, MercadoPago or transfer';

  @override
  String paywallPackageGems(Object gems) {
    return '$gems gems';
  }

  @override
  String paywallPackageLabel(Object label) {
    return 'Package $label';
  }

  @override
  String get summaryPerfect => 'Perfect!';

  @override
  String get summaryGoodWork => 'Good work!';

  @override
  String get summaryKeepPracticing => 'Keep practicing';

  @override
  String get summaryXpEarned => 'XP earned';

  @override
  String get summaryGemsEarned => 'Gems earned';

  @override
  String summaryStreakDays(Object days) {
    return '+$days day(s)';
  }

  @override
  String get legalRegisterAgree => 'By registering you accept our ';

  @override
  String get legalTerms => 'Terms';

  @override
  String get legalAnd => ' and ';

  @override
  String get onboardingCommitButton => 'KEEP MY COMMITMENT';

  @override
  String get onboardingHaveAccount => 'I already have an account';

  @override
  String get exitText => 'Exit';

  @override
  String get dayShortMon => 'M';

  @override
  String get dayShortTue => 'T';

  @override
  String get dayShortWed => 'W';

  @override
  String get dayShortThu => 'T';

  @override
  String get dayShortFri => 'F';

  @override
  String get dayShortSat => 'S';

  @override
  String get dayShortSun => 'S';

  @override
  String streakCurrentProgress(Object current, Object goal) {
    return 'Current streak: $current / $goal days';
  }

  @override
  String rankingYourPosition(Object rank, Object xp) {
    return 'Your position: #$rank · $xp XP';
  }

  @override
  String rankingXpToTop50(Object xp) {
    return 'You need $xp XP to enter the Top 50';
  }

  @override
  String get unknownLabel => 'Unknown';

  @override
  String get homeDefaultName => 'Guardian';

  @override
  String get daysLabel => 'days';

  @override
  String chestTitle(Object type) {
    return '$type Chest';
  }

  @override
  String get chestTapToOpen => 'Tap to open';

  @override
  String chestOpenedTitle(Object type) {
    return '$type Chest!';
  }

  @override
  String get chestCollect => 'Collect';

  @override
  String get gemMultiplierLabel => 'x2 Gems';

  @override
  String get chestTypeBronze => 'Bronze';

  @override
  String get chestTypeSilver => 'Silver';

  @override
  String get chestTypeGold => 'Gold';

  @override
  String get chestTypeLegendary => 'Legendary';

  @override
  String get tutorLocked => 'AI Tutor Locked';

  @override
  String get tutorLockedDescription =>
      'Complete at least 10 lessons to unlock Sage, your personal cybersecurity tutor.';

  @override
  String tutorLessonsProgress(Object completed, Object required) {
    return '$completed / $required lessons';
  }

  @override
  String tutorMotivationAlmost(Object count) {
    return 'Almost there, only $count lessons to go. Keep it up!';
  }

  @override
  String tutorMotivationGood(Object count) {
    return 'Great pace! You need $count more lessons to access Sage.';
  }

  @override
  String get tutorMotivationGeneral =>
      'Each lesson brings you closer to your personal cybersecurity tutor.';

  @override
  String get errorSomethingWrong => 'Something went wrong';

  @override
  String get errorUnexpected =>
      'An unexpected error occurred. You can try again.';

  @override
  String get errorRestartApp => 'Restart app';

  @override
  String get profileDefaultFirstName => 'Warrior';

  @override
  String get profileDefaultLastName => 'Anonymous';
}
