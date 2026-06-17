import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

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

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
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
    Locale('es'),
    Locale('en'),
  ];

  /// No description provided for @appName.
  ///
  /// In es, this message translates to:
  /// **'SAGEN'**
  String get appName;

  /// No description provided for @appSlogan.
  ///
  /// In es, this message translates to:
  /// **'Tu escudo digital'**
  String get appSlogan;

  /// No description provided for @greetingMorning.
  ///
  /// In es, this message translates to:
  /// **'Buenos días'**
  String get greetingMorning;

  /// No description provided for @greetingAfternoon.
  ///
  /// In es, this message translates to:
  /// **'Buenas tardes'**
  String get greetingAfternoon;

  /// No description provided for @greetingEvening.
  ///
  /// In es, this message translates to:
  /// **'Buenas noches'**
  String get greetingEvening;

  /// No description provided for @homeTitle.
  ///
  /// In es, this message translates to:
  /// **'Tu escudo digital está activo'**
  String get homeTitle;

  /// No description provided for @learnTitle.
  ///
  /// In es, this message translates to:
  /// **'Aprender'**
  String get learnTitle;

  /// No description provided for @learnSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Lecciones interactivas de seguridad digital'**
  String get learnSubtitle;

  /// No description provided for @streakTitle.
  ///
  /// In es, this message translates to:
  /// **'Mi Racha'**
  String get streakTitle;

  /// No description provided for @streakDays.
  ///
  /// In es, this message translates to:
  /// **'{count} días'**
  String streakDays(Object count);

  /// No description provided for @streakCurrent.
  ///
  /// In es, this message translates to:
  /// **'Racha actual'**
  String get streakCurrent;

  /// No description provided for @streakLongest.
  ///
  /// In es, this message translates to:
  /// **'Mejor racha'**
  String get streakLongest;

  /// No description provided for @streakFreeze.
  ///
  /// In es, this message translates to:
  /// **'Protector de racha'**
  String get streakFreeze;

  /// No description provided for @analyzeLink.
  ///
  /// In es, this message translates to:
  /// **'Analizar enlace'**
  String get analyzeLink;

  /// No description provided for @analyzeFile.
  ///
  /// In es, this message translates to:
  /// **'Analizar archivo'**
  String get analyzeFile;

  /// No description provided for @fileAnalyzer.
  ///
  /// In es, this message translates to:
  /// **'Analizar archivo'**
  String get fileAnalyzer;

  /// No description provided for @tutorTitle.
  ///
  /// In es, this message translates to:
  /// **'Tutor IA'**
  String get tutorTitle;

  /// No description provided for @historyTitle.
  ///
  /// In es, this message translates to:
  /// **'Historial'**
  String get historyTitle;

  /// No description provided for @settingsTitle.
  ///
  /// In es, this message translates to:
  /// **'Ajustes'**
  String get settingsTitle;

  /// No description provided for @profileTitle.
  ///
  /// In es, this message translates to:
  /// **'Mi Perfil'**
  String get profileTitle;

  /// No description provided for @languageTitle.
  ///
  /// In es, this message translates to:
  /// **'Idioma'**
  String get languageTitle;

  /// No description provided for @themeTitle.
  ///
  /// In es, this message translates to:
  /// **'Apariencia'**
  String get themeTitle;

  /// No description provided for @themeLight.
  ///
  /// In es, this message translates to:
  /// **'Claro'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In es, this message translates to:
  /// **'Oscuro'**
  String get themeDark;

  /// No description provided for @themeSystem.
  ///
  /// In es, this message translates to:
  /// **'Según el sistema'**
  String get themeSystem;

  /// No description provided for @spanish.
  ///
  /// In es, this message translates to:
  /// **'Español'**
  String get spanish;

  /// No description provided for @english.
  ///
  /// In es, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @offlineMessage.
  ///
  /// In es, this message translates to:
  /// **'Sin conexión a internet.'**
  String get offlineMessage;

  /// No description provided for @offlineAction.
  ///
  /// In es, this message translates to:
  /// **'Conéctate e inténtalo nuevamente.'**
  String get offlineAction;

  /// No description provided for @chatFallback.
  ///
  /// In es, this message translates to:
  /// **'Ahora mismo no pude responder. Intenta de nuevo.'**
  String get chatFallback;

  /// No description provided for @summarizeButton.
  ///
  /// In es, this message translates to:
  /// **'Resumen rápido'**
  String get summarizeButton;

  /// No description provided for @lessonComplete.
  ///
  /// In es, this message translates to:
  /// **'Lección completada'**
  String get lessonComplete;

  /// No description provided for @correctAnswers.
  ///
  /// In es, this message translates to:
  /// **'{correct} de {total} correctas'**
  String correctAnswers(Object correct, Object total);

  /// No description provided for @xpReward.
  ///
  /// In es, this message translates to:
  /// **'+{xp} XP'**
  String xpReward(Object xp);

  /// No description provided for @gemReward.
  ///
  /// In es, this message translates to:
  /// **'+{gems} gemas'**
  String gemReward(Object gems);

  /// No description provided for @continueText.
  ///
  /// In es, this message translates to:
  /// **'Continuar'**
  String get continueText;

  /// No description provided for @nextText.
  ///
  /// In es, this message translates to:
  /// **'Siguiente'**
  String get nextText;

  /// No description provided for @finishText.
  ///
  /// In es, this message translates to:
  /// **'Finalizar'**
  String get finishText;

  /// No description provided for @startText.
  ///
  /// In es, this message translates to:
  /// **'Comenzar'**
  String get startText;

  /// No description provided for @viewAll.
  ///
  /// In es, this message translates to:
  /// **'Ver todo'**
  String get viewAll;

  /// No description provided for @yourLearning.
  ///
  /// In es, this message translates to:
  /// **'Tu aprendizaje'**
  String get yourLearning;

  /// No description provided for @quickActions.
  ///
  /// In es, this message translates to:
  /// **'Acciones rápidas'**
  String get quickActions;

  /// No description provided for @yourActivity.
  ///
  /// In es, this message translates to:
  /// **'Tu actividad'**
  String get yourActivity;

  /// No description provided for @totalProgress.
  ///
  /// In es, this message translates to:
  /// **'Progreso total'**
  String get totalProgress;

  /// No description provided for @lessonsCompleted.
  ///
  /// In es, this message translates to:
  /// **'{count} lecciones completadas'**
  String lessonsCompleted(Object count);

  /// No description provided for @learningPath.
  ///
  /// In es, this message translates to:
  /// **'Tu camino de aprendizaje'**
  String get learningPath;

  /// No description provided for @completePrevious.
  ///
  /// In es, this message translates to:
  /// **'Completa la etapa anterior'**
  String get completePrevious;

  /// No description provided for @lessonsCount.
  ///
  /// In es, this message translates to:
  /// **'{count} lecciones'**
  String lessonsCount(Object count);

  /// No description provided for @minutes.
  ///
  /// In es, this message translates to:
  /// **'{min} min'**
  String minutes(Object min);

  /// No description provided for @questions.
  ///
  /// In es, this message translates to:
  /// **'{count} preguntas'**
  String questions(Object count);

  /// No description provided for @noConnection.
  ///
  /// In es, this message translates to:
  /// **'Sin conexión a internet.'**
  String get noConnection;

  /// No description provided for @tryAgain.
  ///
  /// In es, this message translates to:
  /// **'Conéctate e inténtalo nuevamente.'**
  String get tryAgain;

  /// No description provided for @challengeTrueFalse.
  ///
  /// In es, this message translates to:
  /// **'Verdadero / Falso'**
  String get challengeTrueFalse;

  /// No description provided for @challengeMultiple.
  ///
  /// In es, this message translates to:
  /// **'Opción múltiple'**
  String get challengeMultiple;

  /// No description provided for @challengeComplete.
  ///
  /// In es, this message translates to:
  /// **'Completa la frase'**
  String get challengeComplete;

  /// No description provided for @challengeDetectRisk.
  ///
  /// In es, this message translates to:
  /// **'Detectar riesgo'**
  String get challengeDetectRisk;

  /// No description provided for @challengeCreatePassword.
  ///
  /// In es, this message translates to:
  /// **'Crear contraseña'**
  String get challengeCreatePassword;

  /// No description provided for @challengeWhatWouldYouDo.
  ///
  /// In es, this message translates to:
  /// **'¿Qué harías aquí?'**
  String get challengeWhatWouldYouDo;

  /// No description provided for @challengeMiniCase.
  ///
  /// In es, this message translates to:
  /// **'Caso real'**
  String get challengeMiniCase;

  /// No description provided for @fileSafe.
  ///
  /// In es, this message translates to:
  /// **'Seguro'**
  String get fileSafe;

  /// No description provided for @fileLowRisk.
  ///
  /// In es, this message translates to:
  /// **'Bajo riesgo'**
  String get fileLowRisk;

  /// No description provided for @fileMediumRisk.
  ///
  /// In es, this message translates to:
  /// **'Riesgo medio'**
  String get fileMediumRisk;

  /// No description provided for @fileHighRisk.
  ///
  /// In es, this message translates to:
  /// **'Alto riesgo'**
  String get fileHighRisk;

  /// No description provided for @fileDangerous.
  ///
  /// In es, this message translates to:
  /// **'Peligroso'**
  String get fileDangerous;

  /// No description provided for @selectFile.
  ///
  /// In es, this message translates to:
  /// **'Seleccionar archivo'**
  String get selectFile;

  /// No description provided for @analyzing.
  ///
  /// In es, this message translates to:
  /// **'Analizando...'**
  String get analyzing;

  /// No description provided for @notificationStreakAlive.
  ///
  /// In es, this message translates to:
  /// **'Tu racha sigue viva'**
  String get notificationStreakAlive;

  /// No description provided for @notificationStreakLoss.
  ///
  /// In es, this message translates to:
  /// **'Nunca es tarde para empezar otra vez.'**
  String get notificationStreakLoss;

  /// No description provided for @notificationTip.
  ///
  /// In es, this message translates to:
  /// **'Tu escudo digital te espera.'**
  String get notificationTip;

  /// No description provided for @notificationReminder.
  ///
  /// In es, this message translates to:
  /// **'Cinco minutos hoy pueden ayudarte mañana.'**
  String get notificationReminder;

  /// No description provided for @authTitle.
  ///
  /// In es, this message translates to:
  /// **'Tu protección digital comienza aquí'**
  String get authTitle;

  /// No description provided for @authSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Aprende, protégete y navega internet de forma más segura.'**
  String get authSubtitle;

  /// No description provided for @authGoogleButton.
  ///
  /// In es, this message translates to:
  /// **'Continuar con Google'**
  String get authGoogleButton;

  /// No description provided for @authPrivacy.
  ///
  /// In es, this message translates to:
  /// **'Tu información está protegida.'**
  String get authPrivacy;

  /// No description provided for @skipText.
  ///
  /// In es, this message translates to:
  /// **'Saltar'**
  String get skipText;

  /// No description provided for @onboardingWelcome.
  ///
  /// In es, this message translates to:
  /// **'Aprende a protegerte'**
  String get onboardingWelcome;

  /// No description provided for @onboardingWelcomeDesc.
  ///
  /// In es, this message translates to:
  /// **'SAGEN te enseña a navegar, detectar riesgos y proteger tu información en internet.'**
  String get onboardingWelcomeDesc;

  /// No description provided for @challengeSafe.
  ///
  /// In es, this message translates to:
  /// **'Seguro'**
  String get challengeSafe;

  /// No description provided for @challengeSuspicious.
  ///
  /// In es, this message translates to:
  /// **'Sospechoso'**
  String get challengeSuspicious;

  /// No description provided for @onboardingComplete.
  ///
  /// In es, this message translates to:
  /// **'¡Listo! Ya sabes detectar phishing básico.'**
  String get onboardingComplete;

  /// No description provided for @onboardingError.
  ///
  /// In es, this message translates to:
  /// **'Así actúan. Siempre verifican antes de confiar.'**
  String get onboardingError;

  /// No description provided for @challenge_complete_lesson_title.
  ///
  /// In es, this message translates to:
  /// **'Completar Lecciones'**
  String get challenge_complete_lesson_title;

  /// No description provided for @challenge_complete_lesson_desc.
  ///
  /// In es, this message translates to:
  /// **'Completa {count} lección(es)'**
  String challenge_complete_lesson_desc(Object count);

  /// No description provided for @challenge_analyze_link_title.
  ///
  /// In es, this message translates to:
  /// **'Analizar Enlaces'**
  String get challenge_analyze_link_title;

  /// No description provided for @challenge_analyze_link_desc.
  ///
  /// In es, this message translates to:
  /// **'Analiza {count} enlace(s)'**
  String challenge_analyze_link_desc(Object count);

  /// No description provided for @challenge_talk_sage_title.
  ///
  /// In es, this message translates to:
  /// **'Charla con Sage'**
  String get challenge_talk_sage_title;

  /// No description provided for @challenge_talk_sage_desc.
  ///
  /// In es, this message translates to:
  /// **'Charla con Sage {count} vez(veces)'**
  String challenge_talk_sage_desc(Object count);

  /// No description provided for @challenge_check_in_title.
  ///
  /// In es, this message translates to:
  /// **'Registro Diario'**
  String get challenge_check_in_title;

  /// No description provided for @challenge_check_in_desc.
  ///
  /// In es, this message translates to:
  /// **'Regístrate {count} vez(veces)'**
  String challenge_check_in_desc(Object count);

  /// No description provided for @challenge_answer_questions_title.
  ///
  /// In es, this message translates to:
  /// **'Responder Preguntas'**
  String get challenge_answer_questions_title;

  /// No description provided for @challenge_answer_questions_desc.
  ///
  /// In es, this message translates to:
  /// **'Responde {count} pregunta(s)'**
  String challenge_answer_questions_desc(Object count);

  /// No description provided for @challenge_detect_phishing_title.
  ///
  /// In es, this message translates to:
  /// **'Detectar Phishing'**
  String get challenge_detect_phishing_title;

  /// No description provided for @challenge_detect_phishing_desc.
  ///
  /// In es, this message translates to:
  /// **'Detecta {count} intento(s) de phishing'**
  String challenge_detect_phishing_desc(Object count);

  /// No description provided for @challenge_review_tips_title.
  ///
  /// In es, this message translates to:
  /// **'Revisar Consejos'**
  String get challenge_review_tips_title;

  /// No description provided for @challenge_review_tips_desc.
  ///
  /// In es, this message translates to:
  /// **'Revisa {count} consejo(s) de seguridad'**
  String challenge_review_tips_desc(Object count);

  /// No description provided for @challenge_complete_session_title.
  ///
  /// In es, this message translates to:
  /// **'Sesiones de Aprendizaje'**
  String get challenge_complete_session_title;

  /// No description provided for @challenge_complete_session_desc.
  ///
  /// In es, this message translates to:
  /// **'Completa {count} sesión(es)'**
  String challenge_complete_session_desc(Object count);

  /// No description provided for @challenge_share_knowledge_title.
  ///
  /// In es, this message translates to:
  /// **'Compartir Conocimiento'**
  String get challenge_share_knowledge_title;

  /// No description provided for @challenge_share_knowledge_desc.
  ///
  /// In es, this message translates to:
  /// **'Comparte {count} consejo(s)'**
  String challenge_share_knowledge_desc(Object count);

  /// No description provided for @challenge_streak_milestone_title.
  ///
  /// In es, this message translates to:
  /// **'Hito de Racha'**
  String get challenge_streak_milestone_title;

  /// No description provided for @challenge_streak_milestone_desc.
  ///
  /// In es, this message translates to:
  /// **'Mantén una racha de {count} días'**
  String challenge_streak_milestone_desc(Object count);

  /// No description provided for @challenge_privacy_check_title.
  ///
  /// In es, this message translates to:
  /// **'Verificación de Privacidad'**
  String get challenge_privacy_check_title;

  /// No description provided for @challenge_privacy_check_desc.
  ///
  /// In es, this message translates to:
  /// **'Revisa ajustes de privacidad {count} vez(veces)'**
  String challenge_privacy_check_desc(Object count);

  /// No description provided for @challenge_security_audit_title.
  ///
  /// In es, this message translates to:
  /// **'Auditoría de Seguridad'**
  String get challenge_security_audit_title;

  /// No description provided for @challenge_security_audit_desc.
  ///
  /// In es, this message translates to:
  /// **'Completa {count} auditoría(s)'**
  String challenge_security_audit_desc(Object count);

  /// No description provided for @challenge_learn_topic_title.
  ///
  /// In es, this message translates to:
  /// **'Aprender un Tema'**
  String get challenge_learn_topic_title;

  /// No description provided for @challenge_learn_topic_desc.
  ///
  /// In es, this message translates to:
  /// **'Aprende {count} tema(s)'**
  String challenge_learn_topic_desc(Object count);

  /// No description provided for @challenge_quiz_night_title.
  ///
  /// In es, this message translates to:
  /// **'Mini Quiz'**
  String get challenge_quiz_night_title;

  /// No description provided for @challenge_quiz_night_desc.
  ///
  /// In es, this message translates to:
  /// **'Completa {count} mini quiz'**
  String challenge_quiz_night_desc(Object count);

  /// No description provided for @challenge_social_awareness_title.
  ///
  /// In es, this message translates to:
  /// **'Conciencia Social'**
  String get challenge_social_awareness_title;

  /// No description provided for @challenge_social_awareness_desc.
  ///
  /// In es, this message translates to:
  /// **'Completa {count} desafío(s) de conciencia social'**
  String challenge_social_awareness_desc(Object count);

  /// No description provided for @challenge_test_password_title.
  ///
  /// In es, this message translates to:
  /// **'Probar Contraseñas'**
  String get challenge_test_password_title;

  /// No description provided for @challenge_test_password_desc.
  ///
  /// In es, this message translates to:
  /// **'Prueba {count} contraseña(s)'**
  String challenge_test_password_desc(Object count);

  /// No description provided for @challenge_use_dark_mode_title.
  ///
  /// In es, this message translates to:
  /// **'Modo Oscuro'**
  String get challenge_use_dark_mode_title;

  /// No description provided for @challenge_use_dark_mode_desc.
  ///
  /// In es, this message translates to:
  /// **'Usar modo oscuro'**
  String get challenge_use_dark_mode_desc;

  /// No description provided for @challenge_earn_xp_title.
  ///
  /// In es, this message translates to:
  /// **'Ganar XP'**
  String get challenge_earn_xp_title;

  /// No description provided for @challenge_earn_xp_desc.
  ///
  /// In es, this message translates to:
  /// **'Gana {xp} XP'**
  String challenge_earn_xp_desc(Object xp);

  /// No description provided for @challenge_learn_minutes_title.
  ///
  /// In es, this message translates to:
  /// **'Tiempo de Aprendizaje'**
  String get challenge_learn_minutes_title;

  /// No description provided for @challenge_learn_minutes_desc.
  ///
  /// In es, this message translates to:
  /// **'Aprende durante {count} minutos'**
  String challenge_learn_minutes_desc(Object count);

  /// No description provided for @challenge_correct_streak_title.
  ///
  /// In es, this message translates to:
  /// **'Racha Correcta'**
  String get challenge_correct_streak_title;

  /// No description provided for @challenge_correct_streak_desc.
  ///
  /// In es, this message translates to:
  /// **'Obtén {count} respuestas correctas seguidas'**
  String challenge_correct_streak_desc(Object count);

  /// No description provided for @challenge_perfect_lesson_title.
  ///
  /// In es, this message translates to:
  /// **'Lección Perfecta'**
  String get challenge_perfect_lesson_title;

  /// No description provided for @challenge_perfect_lesson_desc.
  ///
  /// In es, this message translates to:
  /// **'Completa una lección sin errores'**
  String get challenge_perfect_lesson_desc;

  /// No description provided for @challenge_complete_stage_title.
  ///
  /// In es, this message translates to:
  /// **'Completar Etapa'**
  String get challenge_complete_stage_title;

  /// No description provided for @challenge_complete_stage_desc.
  ///
  /// In es, this message translates to:
  /// **'Completa 1 etapa'**
  String get challenge_complete_stage_desc;

  /// No description provided for @myAccount.
  ///
  /// In es, this message translates to:
  /// **'Mi cuenta'**
  String get myAccount;

  /// No description provided for @cloudSync.
  ///
  /// In es, this message translates to:
  /// **'Cloud y sincronización'**
  String get cloudSync;

  /// No description provided for @experience.
  ///
  /// In es, this message translates to:
  /// **'Experiencia'**
  String get experience;

  /// No description provided for @infoSection.
  ///
  /// In es, this message translates to:
  /// **'Información'**
  String get infoSection;

  /// No description provided for @privacyLegal.
  ///
  /// In es, this message translates to:
  /// **'Privacidad y legal'**
  String get privacyLegal;

  /// No description provided for @updates.
  ///
  /// In es, this message translates to:
  /// **'Actualizaciones'**
  String get updates;

  /// No description provided for @aboutSection.
  ///
  /// In es, this message translates to:
  /// **'Acerca de'**
  String get aboutSection;

  /// No description provided for @howItWorks.
  ///
  /// In es, this message translates to:
  /// **'Cómo funciona SAGEN'**
  String get howItWorks;

  /// No description provided for @ourMission.
  ///
  /// In es, this message translates to:
  /// **'Nuestra misión'**
  String get ourMission;

  /// No description provided for @aboutSage.
  ///
  /// In es, this message translates to:
  /// **'Sobre Sage'**
  String get aboutSage;

  /// No description provided for @privacyPolicy.
  ///
  /// In es, this message translates to:
  /// **'Política de privacidad'**
  String get privacyPolicy;

  /// No description provided for @termsConditions.
  ///
  /// In es, this message translates to:
  /// **'Términos y condiciones'**
  String get termsConditions;

  /// No description provided for @deleteHistory.
  ///
  /// In es, this message translates to:
  /// **'Borrar historial de análisis'**
  String get deleteHistory;

  /// No description provided for @newsUpdates.
  ///
  /// In es, this message translates to:
  /// **'Novedades y actualizaciones'**
  String get newsUpdates;

  /// No description provided for @newBadge.
  ///
  /// In es, this message translates to:
  /// **'NUEVO'**
  String get newBadge;

  /// No description provided for @deleteHistoryTitle.
  ///
  /// In es, this message translates to:
  /// **'Borrar historial'**
  String get deleteHistoryTitle;

  /// No description provided for @deleteHistoryDesc.
  ///
  /// In es, this message translates to:
  /// **'Se eliminarán todos los análisis de enlaces guardados. Esta acción no se puede deshacer.'**
  String get deleteHistoryDesc;

  /// No description provided for @cancel.
  ///
  /// In es, this message translates to:
  /// **'Cancelar'**
  String get cancel;

  /// No description provided for @deleteAction.
  ///
  /// In es, this message translates to:
  /// **'Eliminar'**
  String get deleteAction;

  /// No description provided for @historyDeleted.
  ///
  /// In es, this message translates to:
  /// **'Historial eliminado'**
  String get historyDeleted;

  /// No description provided for @developedWith.
  ///
  /// In es, this message translates to:
  /// **'Desarrollado con Flutter'**
  String get developedWith;

  /// No description provided for @madeWithLove.
  ///
  /// In es, this message translates to:
  /// **'Hecho con ♥ para estudiantes'**
  String get madeWithLove;

  /// No description provided for @syncStatus.
  ///
  /// In es, this message translates to:
  /// **'Estado de sincronización'**
  String get syncStatus;

  /// No description provided for @syncing.
  ///
  /// In es, this message translates to:
  /// **'Sincronizando...'**
  String get syncing;

  /// No description provided for @lastSync.
  ///
  /// In es, this message translates to:
  /// **'Última sincronización'**
  String get lastSync;

  /// No description provided for @never.
  ///
  /// In es, this message translates to:
  /// **'Nunca'**
  String get never;

  /// No description provided for @forceSync.
  ///
  /// In es, this message translates to:
  /// **'Forzar sincronización'**
  String get forceSync;

  /// No description provided for @restoreCloud.
  ///
  /// In es, this message translates to:
  /// **'Restaurar desde la nube'**
  String get restoreCloud;

  /// No description provided for @deleteCloudData.
  ///
  /// In es, this message translates to:
  /// **'Eliminar datos cloud'**
  String get deleteCloudData;

  /// No description provided for @sounds.
  ///
  /// In es, this message translates to:
  /// **'Sonidos'**
  String get sounds;

  /// No description provided for @soundsSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Efectos de sonido de la app'**
  String get soundsSubtitle;

  /// No description provided for @hapticFeedback.
  ///
  /// In es, this message translates to:
  /// **'Vibración háptica'**
  String get hapticFeedback;

  /// No description provided for @hapticSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Respuesta háptica en interacciones'**
  String get hapticSubtitle;

  /// No description provided for @reduceAnimations.
  ///
  /// In es, this message translates to:
  /// **'Reducir animaciones'**
  String get reduceAnimations;

  /// No description provided for @reduceAnimationsSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Reduce la intensidad de animaciones'**
  String get reduceAnimationsSubtitle;

  /// No description provided for @restoreTitle.
  ///
  /// In es, this message translates to:
  /// **'Restaurar progreso'**
  String get restoreTitle;

  /// No description provided for @restoreDesc.
  ///
  /// In es, this message translates to:
  /// **'¿Quieres restaurar tu progreso desde la nube? Esto reemplazará los datos locales con los datos guardados en tu cuenta.'**
  String get restoreDesc;

  /// No description provided for @restoreAction.
  ///
  /// In es, this message translates to:
  /// **'Restaurar'**
  String get restoreAction;

  /// No description provided for @deleteCloudTitle.
  ///
  /// In es, this message translates to:
  /// **'Eliminar datos cloud'**
  String get deleteCloudTitle;

  /// No description provided for @deleteCloudDesc.
  ///
  /// In es, this message translates to:
  /// **'¿Estás seguro? Esta acción eliminará permanentemente tu progreso guardado en la nube. Los datos locales no se verán afectados.'**
  String get deleteCloudDesc;

  /// No description provided for @cloudDataDeleted.
  ///
  /// In es, this message translates to:
  /// **'Datos cloud eliminados'**
  String get cloudDataDeleted;

  /// No description provided for @progressRestored.
  ///
  /// In es, this message translates to:
  /// **'Progreso restaurado desde la nube'**
  String get progressRestored;

  /// No description provided for @syncSnackbar.
  ///
  /// In es, this message translates to:
  /// **'Progreso sincronizado'**
  String get syncSnackbar;

  /// No description provided for @scheduledDarkMode.
  ///
  /// In es, this message translates to:
  /// **'Modo oscuro programado'**
  String get scheduledDarkMode;

  /// No description provided for @scheduledDarkModeSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Activo/desactivo según horario'**
  String get scheduledDarkModeSubtitle;

  /// No description provided for @darkModeStart.
  ///
  /// In es, this message translates to:
  /// **'Inicia modo oscuro'**
  String get darkModeStart;

  /// No description provided for @darkModeEnd.
  ///
  /// In es, this message translates to:
  /// **'Termina modo oscuro'**
  String get darkModeEnd;

  /// No description provided for @darkModeScheduleInfo.
  ///
  /// In es, this message translates to:
  /// **'El modo oscuro estará activo de {start}:00 a {end}:00'**
  String darkModeScheduleInfo(Object end, Object start);

  /// No description provided for @authLoginTitle.
  ///
  /// In es, this message translates to:
  /// **'Ingresa tus datos'**
  String get authLoginTitle;

  /// No description provided for @authLoginButton.
  ///
  /// In es, this message translates to:
  /// **'INGRESAR'**
  String get authLoginButton;

  /// No description provided for @authEmailLabel.
  ///
  /// In es, this message translates to:
  /// **'Correo electrónico'**
  String get authEmailLabel;

  /// No description provided for @authEmailError.
  ///
  /// In es, this message translates to:
  /// **'Ingresa tu correo'**
  String get authEmailError;

  /// No description provided for @authPasswordLabel.
  ///
  /// In es, this message translates to:
  /// **'Contraseña'**
  String get authPasswordLabel;

  /// No description provided for @authPasswordError.
  ///
  /// In es, this message translates to:
  /// **'Ingresa tu contraseña'**
  String get authPasswordError;

  /// No description provided for @authForgotPasswordButton.
  ///
  /// In es, this message translates to:
  /// **'RESTABLECER CONTRASEÑA'**
  String get authForgotPasswordButton;

  /// No description provided for @authForgotPasswordTitle.
  ///
  /// In es, this message translates to:
  /// **'Restablecer contraseña'**
  String get authForgotPasswordTitle;

  /// No description provided for @authForgotPasswordDesc.
  ///
  /// In es, this message translates to:
  /// **'Te enviaremos un enlace a tu correo para restablecer tu contraseña.'**
  String get authForgotPasswordDesc;

  /// No description provided for @authSendLink.
  ///
  /// In es, this message translates to:
  /// **'Enviar enlace'**
  String get authSendLink;

  /// No description provided for @authRecoveryEmailSentTitle.
  ///
  /// In es, this message translates to:
  /// **'Correo enviado'**
  String get authRecoveryEmailSentTitle;

  /// No description provided for @authRecoveryEmailSentDesc.
  ///
  /// In es, this message translates to:
  /// **'Revisa tu bandeja de entrada y sigue las instrucciones para restablecer tu contraseña.'**
  String get authRecoveryEmailSentDesc;

  /// No description provided for @authRecoveryEmailSentMessage.
  ///
  /// In es, this message translates to:
  /// **'Correo de recuperación enviado'**
  String get authRecoveryEmailSentMessage;

  /// No description provided for @authEnterEmailError.
  ///
  /// In es, this message translates to:
  /// **'Ingresa tu correo electrónico'**
  String get authEnterEmailError;

  /// No description provided for @authBack.
  ///
  /// In es, this message translates to:
  /// **'Volver'**
  String get authBack;

  /// No description provided for @authNoAccount.
  ///
  /// In es, this message translates to:
  /// **'¿No tienes cuenta? '**
  String get authNoAccount;

  /// No description provided for @authCreateAccount.
  ///
  /// In es, this message translates to:
  /// **'Crear cuenta'**
  String get authCreateAccount;

  /// No description provided for @authRegisterTitle.
  ///
  /// In es, this message translates to:
  /// **'Crea tu cuenta'**
  String get authRegisterTitle;

  /// No description provided for @authFullName.
  ///
  /// In es, this message translates to:
  /// **'Nombre completo'**
  String get authFullName;

  /// No description provided for @authNameError.
  ///
  /// In es, this message translates to:
  /// **'Ingresa tu nombre'**
  String get authNameError;

  /// No description provided for @authAge.
  ///
  /// In es, this message translates to:
  /// **'Edad'**
  String get authAge;

  /// No description provided for @authPasswordMinHint.
  ///
  /// In es, this message translates to:
  /// **'Contraseña (mín. 6 caracteres)'**
  String get authPasswordMinHint;

  /// No description provided for @authPasswordMinError.
  ///
  /// In es, this message translates to:
  /// **'La contraseña debe tener al menos 6 caracteres'**
  String get authPasswordMinError;

  /// No description provided for @authOrRegisterWith.
  ///
  /// In es, this message translates to:
  /// **'o regístrate con'**
  String get authOrRegisterWith;

  /// No description provided for @authHaveAccount.
  ///
  /// In es, this message translates to:
  /// **'¿Ya tienes cuenta? '**
  String get authHaveAccount;

  /// No description provided for @authLoginLink.
  ///
  /// In es, this message translates to:
  /// **'Iniciar sesión'**
  String get authLoginLink;

  /// No description provided for @authEmailVerificationSent.
  ///
  /// In es, this message translates to:
  /// **'Revisa tu correo para verificar tu cuenta'**
  String get authEmailVerificationSent;

  /// No description provided for @authLoginError.
  ///
  /// In es, this message translates to:
  /// **'Error al iniciar sesión'**
  String get authLoginError;

  /// No description provided for @authGoogleError.
  ///
  /// In es, this message translates to:
  /// **'Error al iniciar sesión con Google'**
  String get authGoogleError;

  /// No description provided for @authFacebookError.
  ///
  /// In es, this message translates to:
  /// **'Error al iniciar sesión con Facebook'**
  String get authFacebookError;

  /// No description provided for @authCreateAccountError.
  ///
  /// In es, this message translates to:
  /// **'Error al crear cuenta'**
  String get authCreateAccountError;

  /// No description provided for @authRegisterGoogleError.
  ///
  /// In es, this message translates to:
  /// **'Error al registrarse con Google'**
  String get authRegisterGoogleError;

  /// No description provided for @authRegisterFacebookError.
  ///
  /// In es, this message translates to:
  /// **'Error al registrarse con Facebook'**
  String get authRegisterFacebookError;

  /// No description provided for @authSendEmailError.
  ///
  /// In es, this message translates to:
  /// **'Error al enviar correo'**
  String get authSendEmailError;

  /// No description provided for @authFirebaseUnavailable.
  ///
  /// In es, this message translates to:
  /// **'Firebase no está disponible'**
  String get authFirebaseUnavailable;

  /// No description provided for @authCanceled.
  ///
  /// In es, this message translates to:
  /// **'Inicio de sesión cancelado'**
  String get authCanceled;

  /// No description provided for @authNullUser.
  ///
  /// In es, this message translates to:
  /// **'No se pudo obtener el usuario'**
  String get authNullUser;

  /// No description provided for @authUnknown.
  ///
  /// In es, this message translates to:
  /// **'Ocurrió un error inesperado'**
  String get authUnknown;

  /// No description provided for @authNullToken.
  ///
  /// In es, this message translates to:
  /// **'No se pudo obtener el token de Facebook'**
  String get authNullToken;

  /// No description provided for @authNotFound.
  ///
  /// In es, this message translates to:
  /// **'No hay cuenta registrada con este correo'**
  String get authNotFound;

  /// No description provided for @authWrongPassword.
  ///
  /// In es, this message translates to:
  /// **'Contraseña incorrecta'**
  String get authWrongPassword;

  /// No description provided for @authInvalidCredential.
  ///
  /// In es, this message translates to:
  /// **'Correo o contraseña incorrectos'**
  String get authInvalidCredential;

  /// No description provided for @authEmailInUse.
  ///
  /// In es, this message translates to:
  /// **'Ya existe una cuenta con este correo'**
  String get authEmailInUse;

  /// No description provided for @authWeakPassword.
  ///
  /// In es, this message translates to:
  /// **'La contraseña debe tener al menos 6 caracteres'**
  String get authWeakPassword;

  /// No description provided for @authInvalidEmail.
  ///
  /// In es, this message translates to:
  /// **'El formato del correo no es válido'**
  String get authInvalidEmail;

  /// No description provided for @authTooManyRequests.
  ///
  /// In es, this message translates to:
  /// **'Demasiados intentos. Espera un momento.'**
  String get authTooManyRequests;

  /// No description provided for @authNetworkError.
  ///
  /// In es, this message translates to:
  /// **'Sin conexión a internet'**
  String get authNetworkError;

  /// No description provided for @authDefault.
  ///
  /// In es, this message translates to:
  /// **'Error de autenticación'**
  String get authDefault;

  /// No description provided for @authNotVerified.
  ///
  /// In es, this message translates to:
  /// **'Aún no has verificado tu correo. Revisa tu bandeja de entrada.'**
  String get authNotVerified;

  /// No description provided for @authVerifyError.
  ///
  /// In es, this message translates to:
  /// **'No se pudo verificar. Intenta de nuevo.'**
  String get authVerifyError;

  /// No description provided for @authRecoveryError.
  ///
  /// In es, this message translates to:
  /// **'No se pudo enviar el correo de recuperación'**
  String get authRecoveryError;

  /// No description provided for @authNotAuthenticated.
  ///
  /// In es, this message translates to:
  /// **'No hay usuario autenticado'**
  String get authNotAuthenticated;

  /// No description provided for @authResendEmailError.
  ///
  /// In es, this message translates to:
  /// **'No se pudo reenviar el correo de verificación'**
  String get authResendEmailError;

  /// No description provided for @welcomeSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Análisis inteligente y seguridad digital.\nGratis de por vida.'**
  String get welcomeSubtitle;

  /// No description provided for @welcomeStartButton.
  ///
  /// In es, this message translates to:
  /// **'EMPIEZA AHORA'**
  String get welcomeStartButton;

  /// No description provided for @welcomeLoginButton.
  ///
  /// In es, this message translates to:
  /// **'YA TENGO UNA CUENTA'**
  String get welcomeLoginButton;

  /// No description provided for @navHome.
  ///
  /// In es, this message translates to:
  /// **'Inicio'**
  String get navHome;

  /// No description provided for @navChest.
  ///
  /// In es, this message translates to:
  /// **'Cofre'**
  String get navChest;

  /// No description provided for @navSage.
  ///
  /// In es, this message translates to:
  /// **'Sage'**
  String get navSage;

  /// No description provided for @navRanking.
  ///
  /// In es, this message translates to:
  /// **'Clasificación'**
  String get navRanking;

  /// No description provided for @navProfile.
  ///
  /// In es, this message translates to:
  /// **'Perfil'**
  String get navProfile;

  /// No description provided for @homeAllComplete.
  ///
  /// In es, this message translates to:
  /// **'¡Todo completo!'**
  String get homeAllComplete;

  /// No description provided for @homeAllCompleteDesc.
  ///
  /// In es, this message translates to:
  /// **'Has dominado todas las lecciones.'**
  String get homeAllCompleteDesc;

  /// No description provided for @homeContinue.
  ///
  /// In es, this message translates to:
  /// **'Seguir'**
  String get homeContinue;

  /// No description provided for @homeViewAchievements.
  ///
  /// In es, this message translates to:
  /// **'Ver logros'**
  String get homeViewAchievements;

  /// No description provided for @homeLearningPath.
  ///
  /// In es, this message translates to:
  /// **'Ruta de aprendizaje'**
  String get homeLearningPath;

  /// No description provided for @lessonsYourPath.
  ///
  /// In es, this message translates to:
  /// **'Tu ruta de aprendizaje'**
  String get lessonsYourPath;

  /// No description provided for @lessonsLevel.
  ///
  /// In es, this message translates to:
  /// **'Nivel {level}'**
  String lessonsLevel(Object level);

  /// No description provided for @profileStreak.
  ///
  /// In es, this message translates to:
  /// **'Racha'**
  String get profileStreak;

  /// No description provided for @profileXpLabel.
  ///
  /// In es, this message translates to:
  /// **'XP'**
  String get profileXpLabel;

  /// No description provided for @profileGems.
  ///
  /// In es, this message translates to:
  /// **'Gemas'**
  String get profileGems;

  /// No description provided for @profileAchievements.
  ///
  /// In es, this message translates to:
  /// **'Logros'**
  String get profileAchievements;

  /// No description provided for @storeNotEnoughGems.
  ///
  /// In es, this message translates to:
  /// **'No tienes suficientes gemas'**
  String get storeNotEnoughGems;

  /// No description provided for @storePurchaseSuccess.
  ///
  /// In es, this message translates to:
  /// **'¡Compra exitosa!'**
  String get storePurchaseSuccess;

  /// No description provided for @storeProtectStreak.
  ///
  /// In es, this message translates to:
  /// **'Protege tu racha'**
  String get storeProtectStreak;

  /// No description provided for @storeGetGems.
  ///
  /// In es, this message translates to:
  /// **'Consigue gemas'**
  String get storeGetGems;

  /// No description provided for @storePersonalization.
  ///
  /// In es, this message translates to:
  /// **'Personalización'**
  String get storePersonalization;

  /// No description provided for @rankingTitle.
  ///
  /// In es, this message translates to:
  /// **'El Coliseo'**
  String get rankingTitle;

  /// No description provided for @rankingSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Clasificación global · Top 50'**
  String get rankingSubtitle;

  /// No description provided for @rankingError.
  ///
  /// In es, this message translates to:
  /// **'Error al cargar clasificación'**
  String get rankingError;

  /// No description provided for @rankingShareSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Supera mi rango en SAGEN'**
  String get rankingShareSubtitle;

  /// No description provided for @rankingShareButton.
  ///
  /// In es, this message translates to:
  /// **'Compartir Flex Card'**
  String get rankingShareButton;

  /// No description provided for @rankingSharing.
  ///
  /// In es, this message translates to:
  /// **'Compartiendo...'**
  String get rankingSharing;

  /// No description provided for @rankingEmptyMessage.
  ///
  /// In es, this message translates to:
  /// **'Completa lecciones para entrar al ranking'**
  String get rankingEmptyMessage;

  /// No description provided for @regHowContinue.
  ///
  /// In es, this message translates to:
  /// **'¿Cómo quieres continuar?'**
  String get regHowContinue;

  /// No description provided for @regChooseMethod.
  ///
  /// In es, this message translates to:
  /// **'Elige un método para crear tu cuenta.'**
  String get regChooseMethod;

  /// No description provided for @regEmailOption.
  ///
  /// In es, this message translates to:
  /// **'Correo Electrónico'**
  String get regEmailOption;

  /// No description provided for @regAgeQuestion.
  ///
  /// In es, this message translates to:
  /// **'¿Cuántos años tienes?'**
  String get regAgeQuestion;

  /// No description provided for @regAgeValidation.
  ///
  /// In es, this message translates to:
  /// **'Por favor, ingresa tu verdadera edad'**
  String get regAgeValidation;

  /// No description provided for @regEmailTitle.
  ///
  /// In es, this message translates to:
  /// **'Tu correo electrónico'**
  String get regEmailTitle;

  /// No description provided for @regEmailDesc.
  ///
  /// In es, this message translates to:
  /// **'Te enviaremos un código de verificación.'**
  String get regEmailDesc;

  /// No description provided for @regEmailHint.
  ///
  /// In es, this message translates to:
  /// **'ejemplo@correo.com'**
  String get regEmailHint;

  /// No description provided for @regPasswordTitle.
  ///
  /// In es, this message translates to:
  /// **'Crea una contraseña'**
  String get regPasswordTitle;

  /// No description provided for @regPasswordDesc.
  ///
  /// In es, this message translates to:
  /// **'Mínimo 6 caracteres para proteger tu cuenta.'**
  String get regPasswordDesc;

  /// No description provided for @regNameQuestion.
  ///
  /// In es, this message translates to:
  /// **'¿Cómo te llamas?'**
  String get regNameQuestion;

  /// No description provided for @regNameHint.
  ///
  /// In es, this message translates to:
  /// **'Nombre'**
  String get regNameHint;

  /// No description provided for @regSurnameHint.
  ///
  /// In es, this message translates to:
  /// **'Apellido'**
  String get regSurnameHint;

  /// No description provided for @regProfileAlmostReady.
  ///
  /// In es, this message translates to:
  /// **'¡Casi listo!'**
  String get regProfileAlmostReady;

  /// No description provided for @regProfileDesc.
  ///
  /// In es, this message translates to:
  /// **'Crea un perfil para guardar tu progreso y no perder tu racha.'**
  String get regProfileDesc;

  /// No description provided for @regCloudSave.
  ///
  /// In es, this message translates to:
  /// **'Progreso guardado en la nube'**
  String get regCloudSave;

  /// No description provided for @regStreakSync.
  ///
  /// In es, this message translates to:
  /// **'Racha sincronizada entre dispositivos'**
  String get regStreakSync;

  /// No description provided for @regRewards.
  ///
  /// In es, this message translates to:
  /// **'Recompensas y logros personales'**
  String get regRewards;

  /// No description provided for @regCreateProfile.
  ///
  /// In es, this message translates to:
  /// **'CREAR PERFIL'**
  String get regCreateProfile;

  /// No description provided for @regLater.
  ///
  /// In es, this message translates to:
  /// **'Más adelante'**
  String get regLater;

  /// No description provided for @regProfileCreated.
  ///
  /// In es, this message translates to:
  /// **'PERFIL CREADO'**
  String get regProfileCreated;

  /// No description provided for @regWelcomeSagen.
  ///
  /// In es, this message translates to:
  /// **'¡Bienvenido a SAGEN!'**
  String get regWelcomeSagen;

  /// No description provided for @regReadyForLesson.
  ///
  /// In es, this message translates to:
  /// **'Prepara para tu primera lección'**
  String get regReadyForLesson;

  /// No description provided for @lessonPreparing.
  ///
  /// In es, this message translates to:
  /// **'Preparando tus preguntas...'**
  String get lessonPreparing;

  /// No description provided for @lessonNoQuestions.
  ///
  /// In es, this message translates to:
  /// **'No hay preguntas disponibles para esta lección'**
  String get lessonNoQuestions;

  /// No description provided for @sessionLoading.
  ///
  /// In es, this message translates to:
  /// **'Cargando...'**
  String get sessionLoading;

  /// No description provided for @sessionSelectAnswer.
  ///
  /// In es, this message translates to:
  /// **'Selecciona una respuesta'**
  String get sessionSelectAnswer;

  /// No description provided for @sessionCorrect.
  ///
  /// In es, this message translates to:
  /// **'¡Correcto!'**
  String get sessionCorrect;

  /// No description provided for @sessionIncorrect.
  ///
  /// In es, this message translates to:
  /// **'Incorrecto'**
  String get sessionIncorrect;

  /// No description provided for @sessionCorrectAnswer.
  ///
  /// In es, this message translates to:
  /// **'Respuesta correcta: {answer}'**
  String sessionCorrectAnswer(Object answer);

  /// No description provided for @sessionLivesExhausted.
  ///
  /// In es, this message translates to:
  /// **'Vidas agotadas'**
  String get sessionLivesExhausted;

  /// No description provided for @sessionLivesExhaustedDesc.
  ///
  /// In es, this message translates to:
  /// **'Has perdido todas tus vidas. Vuelve a intentarlo.'**
  String get sessionLivesExhaustedDesc;

  /// No description provided for @sessionScore.
  ///
  /// In es, this message translates to:
  /// **'{correct}/{total} correctas'**
  String sessionScore(Object correct, Object total);

  /// No description provided for @sessionRetry.
  ///
  /// In es, this message translates to:
  /// **'Reintentar'**
  String get sessionRetry;

  /// No description provided for @sessionBackToMap.
  ///
  /// In es, this message translates to:
  /// **'Volver al mapa'**
  String get sessionBackToMap;

  /// No description provided for @resultPerfectBadge.
  ///
  /// In es, this message translates to:
  /// **'SESIÓN PERFECTA'**
  String get resultPerfectBadge;

  /// No description provided for @resultPerfectTitle.
  ///
  /// In es, this message translates to:
  /// **'¡Resultado impecable!'**
  String get resultPerfectTitle;

  /// No description provided for @resultCompleteTitle.
  ///
  /// In es, this message translates to:
  /// **'¡Lección completada!'**
  String get resultCompleteTitle;

  /// No description provided for @resultPerfectDesc.
  ///
  /// In es, this message translates to:
  /// **'No cometiste ningún error. Eres un guardián digital.'**
  String get resultPerfectDesc;

  /// No description provided for @resultNotPerfectDesc.
  ///
  /// In es, this message translates to:
  /// **'Sigue practicando para lograr una sesión perfecta.'**
  String get resultNotPerfectDesc;

  /// No description provided for @resultAccuracy.
  ///
  /// In es, this message translates to:
  /// **'Precisión'**
  String get resultAccuracy;

  /// No description provided for @resultLives.
  ///
  /// In es, this message translates to:
  /// **'Vidas'**
  String get resultLives;

  /// No description provided for @statsNoData.
  ///
  /// In es, this message translates to:
  /// **'No hay datos de lección'**
  String get statsNoData;

  /// No description provided for @statsReceiveXp.
  ///
  /// In es, this message translates to:
  /// **'RECIBIR XP'**
  String get statsReceiveXp;

  /// No description provided for @statsSpeed.
  ///
  /// In es, this message translates to:
  /// **'Velocidad'**
  String get statsSpeed;

  /// No description provided for @statsNoErrors.
  ///
  /// In es, this message translates to:
  /// **'¡Sin errores!'**
  String get statsNoErrors;

  /// No description provided for @statsIncredible.
  ///
  /// In es, this message translates to:
  /// **'¡Increíble!'**
  String get statsIncredible;

  /// No description provided for @statsExcellent.
  ///
  /// In es, this message translates to:
  /// **'¡Excelente!'**
  String get statsExcellent;

  /// No description provided for @statsWellDone.
  ///
  /// In es, this message translates to:
  /// **'¡Bien hecho!'**
  String get statsWellDone;

  /// No description provided for @statsKeepTrying.
  ///
  /// In es, this message translates to:
  /// **'Sigue intentándolo.'**
  String get statsKeepTrying;

  /// No description provided for @reviewTitle.
  ///
  /// In es, this message translates to:
  /// **'Repaso'**
  String get reviewTitle;

  /// No description provided for @reviewNoErrors.
  ///
  /// In es, this message translates to:
  /// **'No hay errores que repasar'**
  String get reviewNoErrors;

  /// No description provided for @reviewKeepGoing.
  ///
  /// In es, this message translates to:
  /// **'¡Sigue así!'**
  String get reviewKeepGoing;

  /// No description provided for @reviewComplete.
  ///
  /// In es, this message translates to:
  /// **'¡Repaso completo!'**
  String get reviewComplete;

  /// No description provided for @reviewGoodProgress.
  ///
  /// In es, this message translates to:
  /// **'Buen avance'**
  String get reviewGoodProgress;

  /// No description provided for @reviewKeepPracticing.
  ///
  /// In es, this message translates to:
  /// **'Sigue practicando'**
  String get reviewKeepPracticing;

  /// No description provided for @reviewSagePerfect.
  ///
  /// In es, this message translates to:
  /// **'Tus áreas débiles están mejorando. Noto tu esfuerzo.'**
  String get reviewSagePerfect;

  /// No description provided for @reviewSageGood.
  ///
  /// In es, this message translates to:
  /// **'Cada repaso fortalece tu escudo. ¿Listo para más?'**
  String get reviewSageGood;

  /// No description provided for @reviewSageKeep.
  ///
  /// In es, this message translates to:
  /// **'Repasar es parte del aprendizaje. Puedes volver a intentarlo cuando quieras.'**
  String get reviewSageKeep;

  /// No description provided for @reviewCorrect.
  ///
  /// In es, this message translates to:
  /// **'correctas'**
  String get reviewCorrect;

  /// No description provided for @reviewFinish.
  ///
  /// In es, this message translates to:
  /// **'Finalizar repaso'**
  String get reviewFinish;

  /// No description provided for @firstLessonProgress.
  ///
  /// In es, this message translates to:
  /// **'Lección {current} de {total}'**
  String firstLessonProgress(Object current, Object total);

  /// No description provided for @firstLessonSeeResults.
  ///
  /// In es, this message translates to:
  /// **'VER RESULTADOS'**
  String get firstLessonSeeResults;

  /// No description provided for @back.
  ///
  /// In es, this message translates to:
  /// **'Volver'**
  String get back;

  /// No description provided for @splashTitle.
  ///
  /// In es, this message translates to:
  /// **'SAGEN'**
  String get splashTitle;

  /// No description provided for @streakBadge.
  ///
  /// In es, this message translates to:
  /// **'RACHA'**
  String get streakBadge;

  /// No description provided for @streakKeepAlive.
  ///
  /// In es, this message translates to:
  /// **'¡Mantén tu racha activa!'**
  String get streakKeepAlive;

  /// No description provided for @streakKeepAliveDesc.
  ///
  /// In es, this message translates to:
  /// **'Completa una lección cada día para mantener tu racha.\nCada día cuenta para fortalecer tu escudo digital.'**
  String get streakKeepAliveDesc;

  /// No description provided for @streakStrongerShield.
  ///
  /// In es, this message translates to:
  /// **'Escudo más fuerte cada día'**
  String get streakStrongerShield;

  /// No description provided for @streakRewards.
  ///
  /// In es, this message translates to:
  /// **'Recompensas exclusivas al alcanzar metas'**
  String get streakRewards;

  /// No description provided for @streakAchievements.
  ///
  /// In es, this message translates to:
  /// **'Logros y medallas por constancia'**
  String get streakAchievements;

  /// No description provided for @streakGotIt.
  ///
  /// In es, this message translates to:
  /// **'ENTENDIDO'**
  String get streakGotIt;

  /// No description provided for @commitChooseGoal.
  ///
  /// In es, this message translates to:
  /// **'Elige tu meta'**
  String get commitChooseGoal;

  /// No description provided for @commitChooseGoalDesc.
  ///
  /// In es, this message translates to:
  /// **'Selecciona cuántos días seguirás tu plan de aprendizaje.'**
  String get commitChooseGoalDesc;

  /// No description provided for @commit1Week.
  ///
  /// In es, this message translates to:
  /// **'1 semana'**
  String get commit1Week;

  /// No description provided for @commit2Weeks.
  ///
  /// In es, this message translates to:
  /// **'2 semanas'**
  String get commit2Weeks;

  /// No description provided for @commit1Month.
  ///
  /// In es, this message translates to:
  /// **'1 mes'**
  String get commit1Month;

  /// No description provided for @commitDays.
  ///
  /// In es, this message translates to:
  /// **'{days} días'**
  String commitDays(Object days);

  /// No description provided for @commitSelected.
  ///
  /// In es, this message translates to:
  /// **'SELECCIONADO'**
  String get commitSelected;

  /// No description provided for @commitYourGoal.
  ///
  /// In es, this message translates to:
  /// **'Tu meta: {days} días'**
  String commitYourGoal(Object days);

  /// No description provided for @commitButton.
  ///
  /// In es, this message translates to:
  /// **'COMPROMETERME CON MI META'**
  String get commitButton;

  /// No description provided for @commitGoalLabel.
  ///
  /// In es, this message translates to:
  /// **'Tu meta: {days} días'**
  String commitGoalLabel(Object days);

  /// No description provided for @onboardingDesc.
  ///
  /// In es, this message translates to:
  /// **'Tu asistente personal de seguridad digital.\nAprende, analiza y protégete gratis.'**
  String get onboardingDesc;

  /// No description provided for @onboardingSageStart.
  ///
  /// In es, this message translates to:
  /// **'¡Un gran comienzo! Cada día cuenta.'**
  String get onboardingSageStart;

  /// No description provided for @onboardingSageTwoWeeks.
  ///
  /// In es, this message translates to:
  /// **'Dos semanas de constancia. ¡Eres imparable!'**
  String get onboardingSageTwoWeeks;

  /// No description provided for @onboardingSageMonth.
  ///
  /// In es, this message translates to:
  /// **'Un mes de disciplina. Los hábitos se forjan.'**
  String get onboardingSageMonth;

  /// No description provided for @onboardingSage50Days.
  ///
  /// In es, this message translates to:
  /// **'50 días de dedicación. ¡Leyenda en formación!'**
  String get onboardingSage50Days;

  /// No description provided for @onboardingSageExcellent.
  ///
  /// In es, this message translates to:
  /// **'Excelentes motivos, ¡apunta alto!'**
  String get onboardingSageExcellent;

  /// No description provided for @summaryOrigin.
  ///
  /// In es, this message translates to:
  /// **'Origen'**
  String get summaryOrigin;

  /// No description provided for @summaryKnowledge.
  ///
  /// In es, this message translates to:
  /// **'Conocimiento'**
  String get summaryKnowledge;

  /// No description provided for @summaryInterest.
  ///
  /// In es, this message translates to:
  /// **'Interés'**
  String get summaryInterest;

  /// No description provided for @summaryMotivations.
  ///
  /// In es, this message translates to:
  /// **'Motivaciones'**
  String get summaryMotivations;

  /// No description provided for @summaryLearning.
  ///
  /// In es, this message translates to:
  /// **'Aprendizaje'**
  String get summaryLearning;

  /// No description provided for @summaryDailyGoal.
  ///
  /// In es, this message translates to:
  /// **'Meta diaria'**
  String get summaryDailyGoal;

  /// No description provided for @summaryCommitment.
  ///
  /// In es, this message translates to:
  /// **'Compromiso'**
  String get summaryCommitment;

  /// No description provided for @summaryReady.
  ///
  /// In es, this message translates to:
  /// **'Todo listo para empezar tu viaje en seguridad digital.'**
  String get summaryReady;

  /// No description provided for @profileError.
  ///
  /// In es, this message translates to:
  /// **'Error al cargar perfil'**
  String get profileError;

  /// No description provided for @profileLevel.
  ///
  /// In es, this message translates to:
  /// **'Nivel'**
  String get profileLevel;

  /// No description provided for @profileTotalXp.
  ///
  /// In es, this message translates to:
  /// **'XP Total'**
  String get profileTotalXp;

  /// No description provided for @settingsLogout.
  ///
  /// In es, this message translates to:
  /// **'Cerrar sesión'**
  String get settingsLogout;

  /// No description provided for @settingsLogoutConfirm.
  ///
  /// In es, this message translates to:
  /// **'¿Estás seguro de que quieres cerrar sesión?'**
  String get settingsLogoutConfirm;

  /// No description provided for @rewardAdTitle.
  ///
  /// In es, this message translates to:
  /// **'Gana gemas extra'**
  String get rewardAdTitle;

  /// No description provided for @rewardAdSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Mira un anuncio y recibe gemas al instante'**
  String get rewardAdSubtitle;

  /// No description provided for @rewardAdWatch.
  ///
  /// In es, this message translates to:
  /// **'Ver'**
  String get rewardAdWatch;

  /// No description provided for @rewardAdEarned.
  ///
  /// In es, this message translates to:
  /// **'¡Ganaste {count} gemas!'**
  String rewardAdEarned(Object count);

  /// No description provided for @rewardAdCooldown.
  ///
  /// In es, this message translates to:
  /// **'Espera {seconds} segundos antes de ver otro anuncio.'**
  String rewardAdCooldown(Object seconds);

  /// No description provided for @rewardAdNotAvailable.
  ///
  /// In es, this message translates to:
  /// **'El anuncio no está disponible ahora. Intenta más tarde.'**
  String get rewardAdNotAvailable;

  /// No description provided for @rankCybersecurityLegend.
  ///
  /// In es, this message translates to:
  /// **'Leyenda de Ciberseguridad'**
  String get rankCybersecurityLegend;

  /// No description provided for @rankEliteDefender.
  ///
  /// In es, this message translates to:
  /// **'Defensor Élite'**
  String get rankEliteDefender;

  /// No description provided for @rankExperiencedWarrior.
  ///
  /// In es, this message translates to:
  /// **'Guerrero Experimentado'**
  String get rankExperiencedWarrior;

  /// No description provided for @rankActiveLearner.
  ///
  /// In es, this message translates to:
  /// **'Aprendiz Activo'**
  String get rankActiveLearner;

  /// No description provided for @rankNovice.
  ///
  /// In es, this message translates to:
  /// **'Novato'**
  String get rankNovice;

  /// No description provided for @profileDefaultName.
  ///
  /// In es, this message translates to:
  /// **'Guardián'**
  String get profileDefaultName;

  /// No description provided for @profileLevelValue.
  ///
  /// In es, this message translates to:
  /// **'Nivel {level}'**
  String profileLevelValue(Object level);

  /// No description provided for @profileDay.
  ///
  /// In es, this message translates to:
  /// **'día'**
  String get profileDay;

  /// No description provided for @profileDays.
  ///
  /// In es, this message translates to:
  /// **'días'**
  String get profileDays;

  /// No description provided for @rankingPosition.
  ///
  /// In es, this message translates to:
  /// **'Rank #{rank}'**
  String rankingPosition(Object rank);

  /// No description provided for @flexCardJoinAlliance.
  ///
  /// In es, this message translates to:
  /// **'Únete a mi alianza en SAGEN'**
  String get flexCardJoinAlliance;

  /// No description provided for @raritySilver.
  ///
  /// In es, this message translates to:
  /// **'Plata'**
  String get raritySilver;

  /// No description provided for @rarityGold.
  ///
  /// In es, this message translates to:
  /// **'Oro'**
  String get rarityGold;

  /// No description provided for @rarityPlatinum.
  ///
  /// In es, this message translates to:
  /// **'Platino'**
  String get rarityPlatinum;

  /// No description provided for @achievementLocked.
  ///
  /// In es, this message translates to:
  /// **'???'**
  String get achievementLocked;

  /// No description provided for @streakFrozen.
  ///
  /// In es, this message translates to:
  /// **'Racha congelada'**
  String get streakFrozen;

  /// No description provided for @streakDaysCount.
  ///
  /// In es, this message translates to:
  /// **'{count} días de racha'**
  String streakDaysCount(Object count);

  /// No description provided for @streakNoActiveStreak.
  ///
  /// In es, this message translates to:
  /// **'Sin racha activa'**
  String get streakNoActiveStreak;

  /// No description provided for @streakFreezeDescription.
  ///
  /// In es, this message translates to:
  /// **'Mantén tu racha al fallar un día'**
  String get streakFreezeDescription;

  /// No description provided for @storeShieldLimitReached.
  ///
  /// In es, this message translates to:
  /// **'Límite de protectores alcanzado'**
  String get storeShieldLimitReached;

  /// No description provided for @storeChestAvailable.
  ///
  /// In es, this message translates to:
  /// **'¡Cofre Diario Disponible!'**
  String get storeChestAvailable;

  /// No description provided for @storeChestComeBack.
  ///
  /// In es, this message translates to:
  /// **'Vuelve mañana'**
  String get storeChestComeBack;

  /// No description provided for @storeChestGemsExpire.
  ///
  /// In es, this message translates to:
  /// **'{gems} gemas — expira a medianoche'**
  String storeChestGemsExpire(Object gems);

  /// No description provided for @storeChestRenews.
  ///
  /// In es, this message translates to:
  /// **'Tu cofre se renueva cada día'**
  String get storeChestRenews;

  /// No description provided for @storeOpen.
  ///
  /// In es, this message translates to:
  /// **'Abrir'**
  String get storeOpen;

  /// No description provided for @storeTitle.
  ///
  /// In es, this message translates to:
  /// **'Tienda'**
  String get storeTitle;

  /// No description provided for @storeGemsLabel.
  ///
  /// In es, this message translates to:
  /// **'gemas'**
  String get storeGemsLabel;

  /// No description provided for @storeBuyGems.
  ///
  /// In es, this message translates to:
  /// **'Comprar gemas'**
  String get storeBuyGems;

  /// No description provided for @storeWhatsappPackages.
  ///
  /// In es, this message translates to:
  /// **'Paquetes desde {price} — Pago por WhatsApp'**
  String storeWhatsappPackages(Object price);

  /// No description provided for @storeAdEarnGem.
  ///
  /// In es, this message translates to:
  /// **'Gana 1 gema extra'**
  String get storeAdEarnGem;

  /// No description provided for @storeAdWatchVideo.
  ///
  /// In es, this message translates to:
  /// **'Ve un video de 30 segundos'**
  String get storeAdWatchVideo;

  /// No description provided for @storeAdRewardMessage.
  ///
  /// In es, this message translates to:
  /// **'+1 Gema por ver el anuncio'**
  String get storeAdRewardMessage;

  /// No description provided for @storeWatch.
  ///
  /// In es, this message translates to:
  /// **'Ver'**
  String get storeWatch;

  /// No description provided for @paywallBasic.
  ///
  /// In es, this message translates to:
  /// **'Básico'**
  String get paywallBasic;

  /// No description provided for @paywallPopular.
  ///
  /// In es, this message translates to:
  /// **'Popular'**
  String get paywallPopular;

  /// No description provided for @paywallPremium.
  ///
  /// In es, this message translates to:
  /// **'Premium'**
  String get paywallPremium;

  /// No description provided for @paywallWhatsAppMessage.
  ///
  /// In es, this message translates to:
  /// **'Hola, quiero comprar el paquete de {gems} gemas por S/{price} en SAGEN. Mi ID de usuario es: {userId}'**
  String paywallWhatsAppMessage(Object gems, Object price, Object userId);

  /// No description provided for @paywallWhatsAppFallback.
  ///
  /// In es, this message translates to:
  /// **'Abre WhatsApp y envía: {message}'**
  String paywallWhatsAppFallback(Object message);

  /// No description provided for @paywallWhatsAppError.
  ///
  /// In es, this message translates to:
  /// **'Error al abrir WhatsApp. Paga vía: {link}'**
  String paywallWhatsAppError(Object link);

  /// No description provided for @paywallGetMoreGems.
  ///
  /// In es, this message translates to:
  /// **'Consigue más gemas'**
  String get paywallGetMoreGems;

  /// No description provided for @paywallDescription.
  ///
  /// In es, this message translates to:
  /// **'Elige tu paquete y te contactamos por WhatsApp para coordinar el pago.'**
  String get paywallDescription;

  /// No description provided for @paywallPaymentMethods.
  ///
  /// In es, this message translates to:
  /// **'Paga con Yape, Plin, MercadoPago o transferencia'**
  String get paywallPaymentMethods;

  /// No description provided for @paywallPackageGems.
  ///
  /// In es, this message translates to:
  /// **'{gems} gemas'**
  String paywallPackageGems(Object gems);

  /// No description provided for @paywallPackageLabel.
  ///
  /// In es, this message translates to:
  /// **'Paquete {label}'**
  String paywallPackageLabel(Object label);

  /// No description provided for @summaryPerfect.
  ///
  /// In es, this message translates to:
  /// **'¡Perfecto!'**
  String get summaryPerfect;

  /// No description provided for @summaryGoodWork.
  ///
  /// In es, this message translates to:
  /// **'¡Buen trabajo!'**
  String get summaryGoodWork;

  /// No description provided for @summaryKeepPracticing.
  ///
  /// In es, this message translates to:
  /// **'Sigue practicando'**
  String get summaryKeepPracticing;

  /// No description provided for @summaryXpEarned.
  ///
  /// In es, this message translates to:
  /// **'XP ganado'**
  String get summaryXpEarned;

  /// No description provided for @summaryGemsEarned.
  ///
  /// In es, this message translates to:
  /// **'Gemas obtenidas'**
  String get summaryGemsEarned;

  /// No description provided for @summaryStreakDays.
  ///
  /// In es, this message translates to:
  /// **'+{days} día(s)'**
  String summaryStreakDays(Object days);

  /// No description provided for @legalRegisterAgree.
  ///
  /// In es, this message translates to:
  /// **'Al registrarte aceptas nuestros '**
  String get legalRegisterAgree;

  /// No description provided for @legalTerms.
  ///
  /// In es, this message translates to:
  /// **'Términos'**
  String get legalTerms;

  /// No description provided for @legalAnd.
  ///
  /// In es, this message translates to:
  /// **' y '**
  String get legalAnd;

  /// No description provided for @onboardingCommitButton.
  ///
  /// In es, this message translates to:
  /// **'MANTENER MI COMPROMISO'**
  String get onboardingCommitButton;

  /// No description provided for @onboardingHaveAccount.
  ///
  /// In es, this message translates to:
  /// **'Ya tengo una cuenta'**
  String get onboardingHaveAccount;

  /// No description provided for @exitText.
  ///
  /// In es, this message translates to:
  /// **'Salir'**
  String get exitText;

  /// No description provided for @dayShortMon.
  ///
  /// In es, this message translates to:
  /// **'L'**
  String get dayShortMon;

  /// No description provided for @dayShortTue.
  ///
  /// In es, this message translates to:
  /// **'M'**
  String get dayShortTue;

  /// No description provided for @dayShortWed.
  ///
  /// In es, this message translates to:
  /// **'M'**
  String get dayShortWed;

  /// No description provided for @dayShortThu.
  ///
  /// In es, this message translates to:
  /// **'J'**
  String get dayShortThu;

  /// No description provided for @dayShortFri.
  ///
  /// In es, this message translates to:
  /// **'V'**
  String get dayShortFri;

  /// No description provided for @dayShortSat.
  ///
  /// In es, this message translates to:
  /// **'S'**
  String get dayShortSat;

  /// No description provided for @dayShortSun.
  ///
  /// In es, this message translates to:
  /// **'D'**
  String get dayShortSun;

  /// No description provided for @streakCurrentProgress.
  ///
  /// In es, this message translates to:
  /// **'Racha actual: {current} / {goal} días'**
  String streakCurrentProgress(Object current, Object goal);

  /// No description provided for @rankingYourPosition.
  ///
  /// In es, this message translates to:
  /// **'Tu posición: #{rank} · {xp} XP'**
  String rankingYourPosition(Object rank, Object xp);

  /// No description provided for @rankingXpToTop50.
  ///
  /// In es, this message translates to:
  /// **'Te faltan {xp} XP para entrar al Top 50'**
  String rankingXpToTop50(Object xp);

  /// No description provided for @unknownLabel.
  ///
  /// In es, this message translates to:
  /// **'Desconocido'**
  String get unknownLabel;

  /// No description provided for @homeDefaultName.
  ///
  /// In es, this message translates to:
  /// **'Guardián'**
  String get homeDefaultName;

  /// No description provided for @daysLabel.
  ///
  /// In es, this message translates to:
  /// **'días'**
  String get daysLabel;

  /// No description provided for @chestTitle.
  ///
  /// In es, this message translates to:
  /// **'Cofre {type}'**
  String chestTitle(Object type);

  /// No description provided for @chestTapToOpen.
  ///
  /// In es, this message translates to:
  /// **'Toca para abrir'**
  String get chestTapToOpen;

  /// No description provided for @chestOpenedTitle.
  ///
  /// In es, this message translates to:
  /// **'¡Cofre {type}!'**
  String chestOpenedTitle(Object type);

  /// No description provided for @chestCollect.
  ///
  /// In es, this message translates to:
  /// **'Recoger'**
  String get chestCollect;

  /// No description provided for @gemMultiplierLabel.
  ///
  /// In es, this message translates to:
  /// **'×2 Gemas'**
  String get gemMultiplierLabel;

  /// No description provided for @chestTypeBronze.
  ///
  /// In es, this message translates to:
  /// **'Bronce'**
  String get chestTypeBronze;

  /// No description provided for @chestTypeSilver.
  ///
  /// In es, this message translates to:
  /// **'Plata'**
  String get chestTypeSilver;

  /// No description provided for @chestTypeGold.
  ///
  /// In es, this message translates to:
  /// **'Oro'**
  String get chestTypeGold;

  /// No description provided for @chestTypeLegendary.
  ///
  /// In es, this message translates to:
  /// **'Legendario'**
  String get chestTypeLegendary;

  /// No description provided for @tutorLocked.
  ///
  /// In es, this message translates to:
  /// **'Tutor IA Bloqueado'**
  String get tutorLocked;

  /// No description provided for @tutorLockedDescription.
  ///
  /// In es, this message translates to:
  /// **'Completa al menos 10 lecciones para desbloquear a Sage, tu tutor personal de ciberseguridad.'**
  String get tutorLockedDescription;

  /// No description provided for @tutorLessonsProgress.
  ///
  /// In es, this message translates to:
  /// **'{completed} / {required} lecciones'**
  String tutorLessonsProgress(Object completed, Object required);

  /// No description provided for @tutorMotivationAlmost.
  ///
  /// In es, this message translates to:
  /// **'Ya casi, solo te faltan {count} lecciones. ¡Sigue así!'**
  String tutorMotivationAlmost(Object count);

  /// No description provided for @tutorMotivationGood.
  ///
  /// In es, this message translates to:
  /// **'¡Buen ritmo! Te faltan {count} lecciones para acceder a Sage.'**
  String tutorMotivationGood(Object count);

  /// No description provided for @tutorMotivationGeneral.
  ///
  /// In es, this message translates to:
  /// **'Cada lección te acerca más a tu tutor personal de ciberseguridad.'**
  String get tutorMotivationGeneral;

  /// No description provided for @errorSomethingWrong.
  ///
  /// In es, this message translates to:
  /// **'Algo salió mal'**
  String get errorSomethingWrong;

  /// No description provided for @errorUnexpected.
  ///
  /// In es, this message translates to:
  /// **'Ocurrió un error inesperado. Puedes intentar de nuevo.'**
  String get errorUnexpected;

  /// No description provided for @errorRestartApp.
  ///
  /// In es, this message translates to:
  /// **'Reiniciar app'**
  String get errorRestartApp;

  /// No description provided for @profileDefaultFirstName.
  ///
  /// In es, this message translates to:
  /// **'Guerrero'**
  String get profileDefaultFirstName;

  /// No description provided for @profileDefaultLastName.
  ///
  /// In es, this message translates to:
  /// **'Anónimo'**
  String get profileDefaultLastName;
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
      <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
