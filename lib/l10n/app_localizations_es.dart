// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appName => 'SAGEN';

  @override
  String get appSlogan => 'Tu escudo digital';

  @override
  String get greetingMorning => 'Buenos días';

  @override
  String get greetingAfternoon => 'Buenas tardes';

  @override
  String get greetingEvening => 'Buenas noches';

  @override
  String get homeTitle => 'Tu escudo digital está activo';

  @override
  String get learnTitle => 'Aprender';

  @override
  String get learnSubtitle => 'Lecciones interactivas de seguridad digital';

  @override
  String get streakTitle => 'Mi Racha';

  @override
  String streakDays(Object count) {
    return '$count días';
  }

  @override
  String get streakCurrent => 'Racha actual';

  @override
  String get streakLongest => 'Mejor racha';

  @override
  String get streakFreeze => 'Protector de racha';

  @override
  String get analyzeLink => 'Analizar enlace';

  @override
  String get analyzeFile => 'Analizar archivo';

  @override
  String get fileAnalyzer => 'Analizar archivo';

  @override
  String get tutorTitle => 'Tutor IA';

  @override
  String get historyTitle => 'Historial';

  @override
  String get settingsTitle => 'Ajustes';

  @override
  String get profileTitle => 'Mi Perfil';

  @override
  String get languageTitle => 'Idioma';

  @override
  String get themeTitle => 'Apariencia';

  @override
  String get themeLight => 'Claro';

  @override
  String get themeDark => 'Oscuro';

  @override
  String get themeSystem => 'Según el sistema';

  @override
  String get spanish => 'Español';

  @override
  String get english => 'English';

  @override
  String get offlineMessage => 'Sin conexión a internet.';

  @override
  String get offlineAction => 'Conéctate e inténtalo nuevamente.';

  @override
  String get chatFallback => 'Ahora mismo no pude responder. Intenta de nuevo.';

  @override
  String get summarizeButton => 'Resumen rápido';

  @override
  String get lessonComplete => 'Lección completada';

  @override
  String correctAnswers(Object correct, Object total) {
    return '$correct de $total correctas';
  }

  @override
  String xpReward(Object xp) {
    return '+$xp XP';
  }

  @override
  String gemReward(Object gems) {
    return '+$gems gemas';
  }

  @override
  String get continueText => 'Continuar';

  @override
  String get nextText => 'Siguiente';

  @override
  String get finishText => 'Finalizar';

  @override
  String get startText => 'Comenzar';

  @override
  String get viewAll => 'Ver todo';

  @override
  String get yourLearning => 'Tu aprendizaje';

  @override
  String get quickActions => 'Acciones rápidas';

  @override
  String get yourActivity => 'Tu actividad';

  @override
  String get totalProgress => 'Progreso total';

  @override
  String lessonsCompleted(Object count) {
    return '$count lecciones completadas';
  }

  @override
  String get learningPath => 'Tu camino de aprendizaje';

  @override
  String get completePrevious => 'Completa la etapa anterior';

  @override
  String lessonsCount(Object count) {
    return '$count lecciones';
  }

  @override
  String minutes(Object min) {
    return '$min min';
  }

  @override
  String questions(Object count) {
    return '$count preguntas';
  }

  @override
  String get noConnection => 'Sin conexión a internet.';

  @override
  String get tryAgain => 'Conéctate e inténtalo nuevamente.';

  @override
  String get challengeTrueFalse => 'Verdadero / Falso';

  @override
  String get challengeMultiple => 'Opción múltiple';

  @override
  String get challengeComplete => 'Completa la frase';

  @override
  String get challengeDetectRisk => 'Detectar riesgo';

  @override
  String get challengeCreatePassword => 'Crear contraseña';

  @override
  String get challengeWhatWouldYouDo => '¿Qué harías aquí?';

  @override
  String get challengeMiniCase => 'Caso real';

  @override
  String get fileSafe => 'Seguro';

  @override
  String get fileLowRisk => 'Bajo riesgo';

  @override
  String get fileMediumRisk => 'Riesgo medio';

  @override
  String get fileHighRisk => 'Alto riesgo';

  @override
  String get fileDangerous => 'Peligroso';

  @override
  String get selectFile => 'Seleccionar archivo';

  @override
  String get analyzing => 'Analizando...';

  @override
  String get notificationStreakAlive => 'Tu racha sigue viva';

  @override
  String get notificationStreakLoss => 'Nunca es tarde para empezar otra vez.';

  @override
  String get notificationTip => 'Tu escudo digital te espera.';

  @override
  String get notificationReminder =>
      'Cinco minutos hoy pueden ayudarte mañana.';

  @override
  String get authTitle => 'Tu protección digital comienza aquí';

  @override
  String get authSubtitle =>
      'Aprende, protégete y navega internet de forma más segura.';

  @override
  String get authGoogleButton => 'Continuar con Google';

  @override
  String get authPrivacy => 'Tu información está protegida.';

  @override
  String get skipText => 'Saltar';

  @override
  String get onboardingWelcome => 'Aprende a protegerte';

  @override
  String get onboardingWelcomeDesc =>
      'SAGEN te enseña a navegar, detectar riesgos y proteger tu información en internet.';

  @override
  String get challengeSafe => 'Seguro';

  @override
  String get challengeSuspicious => 'Sospechoso';

  @override
  String get onboardingComplete => '¡Listo! Ya sabes detectar phishing básico.';

  @override
  String get onboardingError =>
      'Así actúan. Siempre verifican antes de confiar.';

  @override
  String get challenge_complete_lesson_title => 'Completar Lecciones';

  @override
  String challenge_complete_lesson_desc(Object count) {
    return 'Completa $count lección(es)';
  }

  @override
  String get challenge_analyze_link_title => 'Analizar Enlaces';

  @override
  String challenge_analyze_link_desc(Object count) {
    return 'Analiza $count enlace(s)';
  }

  @override
  String get challenge_talk_sage_title => 'Charla con Sage';

  @override
  String challenge_talk_sage_desc(Object count) {
    return 'Charla con Sage $count vez(veces)';
  }

  @override
  String get challenge_check_in_title => 'Registro Diario';

  @override
  String challenge_check_in_desc(Object count) {
    return 'Regístrate $count vez(veces)';
  }

  @override
  String get challenge_answer_questions_title => 'Responder Preguntas';

  @override
  String challenge_answer_questions_desc(Object count) {
    return 'Responde $count pregunta(s)';
  }

  @override
  String get challenge_detect_phishing_title => 'Detectar Phishing';

  @override
  String challenge_detect_phishing_desc(Object count) {
    return 'Detecta $count intento(s) de phishing';
  }

  @override
  String get challenge_review_tips_title => 'Revisar Consejos';

  @override
  String challenge_review_tips_desc(Object count) {
    return 'Revisa $count consejo(s) de seguridad';
  }

  @override
  String get challenge_complete_session_title => 'Sesiones de Aprendizaje';

  @override
  String challenge_complete_session_desc(Object count) {
    return 'Completa $count sesión(es)';
  }

  @override
  String get challenge_share_knowledge_title => 'Compartir Conocimiento';

  @override
  String challenge_share_knowledge_desc(Object count) {
    return 'Comparte $count consejo(s)';
  }

  @override
  String get challenge_streak_milestone_title => 'Hito de Racha';

  @override
  String challenge_streak_milestone_desc(Object count) {
    return 'Mantén una racha de $count días';
  }

  @override
  String get challenge_privacy_check_title => 'Verificación de Privacidad';

  @override
  String challenge_privacy_check_desc(Object count) {
    return 'Revisa ajustes de privacidad $count vez(veces)';
  }

  @override
  String get challenge_security_audit_title => 'Auditoría de Seguridad';

  @override
  String challenge_security_audit_desc(Object count) {
    return 'Completa $count auditoría(s)';
  }

  @override
  String get challenge_learn_topic_title => 'Aprender un Tema';

  @override
  String challenge_learn_topic_desc(Object count) {
    return 'Aprende $count tema(s)';
  }

  @override
  String get challenge_quiz_night_title => 'Mini Quiz';

  @override
  String challenge_quiz_night_desc(Object count) {
    return 'Completa $count mini quiz';
  }

  @override
  String get challenge_social_awareness_title => 'Conciencia Social';

  @override
  String challenge_social_awareness_desc(Object count) {
    return 'Completa $count desafío(s) de conciencia social';
  }

  @override
  String get challenge_test_password_title => 'Probar Contraseñas';

  @override
  String challenge_test_password_desc(Object count) {
    return 'Prueba $count contraseña(s)';
  }

  @override
  String get challenge_use_dark_mode_title => 'Modo Oscuro';

  @override
  String get challenge_use_dark_mode_desc => 'Usar modo oscuro';

  @override
  String get challenge_earn_xp_title => 'Ganar XP';

  @override
  String challenge_earn_xp_desc(Object xp) {
    return 'Gana $xp XP';
  }

  @override
  String get challenge_learn_minutes_title => 'Tiempo de Aprendizaje';

  @override
  String challenge_learn_minutes_desc(Object count) {
    return 'Aprende durante $count minutos';
  }

  @override
  String get challenge_correct_streak_title => 'Racha Correcta';

  @override
  String challenge_correct_streak_desc(Object count) {
    return 'Obtén $count respuestas correctas seguidas';
  }

  @override
  String get challenge_perfect_lesson_title => 'Lección Perfecta';

  @override
  String get challenge_perfect_lesson_desc =>
      'Completa una lección sin errores';

  @override
  String get challenge_complete_stage_title => 'Completar Etapa';

  @override
  String get challenge_complete_stage_desc => 'Completa 1 etapa';

  @override
  String get myAccount => 'Mi cuenta';

  @override
  String get cloudSync => 'Cloud y sincronización';

  @override
  String get experience => 'Experiencia';

  @override
  String get infoSection => 'Información';

  @override
  String get privacyLegal => 'Privacidad y legal';

  @override
  String get updates => 'Actualizaciones';

  @override
  String get aboutSection => 'Acerca de';

  @override
  String get howItWorks => 'Cómo funciona SAGEN';

  @override
  String get ourMission => 'Nuestra misión';

  @override
  String get aboutSage => 'Sobre Sage';

  @override
  String get privacyPolicy => 'Política de privacidad';

  @override
  String get termsConditions => 'Términos y condiciones';

  @override
  String get deleteHistory => 'Borrar historial de análisis';

  @override
  String get newsUpdates => 'Novedades y actualizaciones';

  @override
  String get newBadge => 'NUEVO';

  @override
  String get deleteHistoryTitle => 'Borrar historial';

  @override
  String get deleteHistoryDesc =>
      'Se eliminarán todos los análisis de enlaces guardados. Esta acción no se puede deshacer.';

  @override
  String get cancel => 'Cancelar';

  @override
  String get deleteAction => 'Eliminar';

  @override
  String get historyDeleted => 'Historial eliminado';

  @override
  String get developedWith => 'Desarrollado con Flutter';

  @override
  String get madeWithLove => 'Hecho con ♥ para estudiantes';

  @override
  String get syncStatus => 'Estado de sincronización';

  @override
  String get syncing => 'Sincronizando...';

  @override
  String get lastSync => 'Última sincronización';

  @override
  String get never => 'Nunca';

  @override
  String get forceSync => 'Forzar sincronización';

  @override
  String get restoreCloud => 'Restaurar desde la nube';

  @override
  String get deleteCloudData => 'Eliminar datos cloud';

  @override
  String get sounds => 'Sonidos';

  @override
  String get soundsSubtitle => 'Efectos de sonido de la app';

  @override
  String get hapticFeedback => 'Vibración háptica';

  @override
  String get hapticSubtitle => 'Respuesta háptica en interacciones';

  @override
  String get reduceAnimations => 'Reducir animaciones';

  @override
  String get reduceAnimationsSubtitle => 'Reduce la intensidad de animaciones';

  @override
  String get restoreTitle => 'Restaurar progreso';

  @override
  String get restoreDesc =>
      '¿Quieres restaurar tu progreso desde la nube? Esto reemplazará los datos locales con los datos guardados en tu cuenta.';

  @override
  String get restoreAction => 'Restaurar';

  @override
  String get deleteCloudTitle => 'Eliminar datos cloud';

  @override
  String get deleteCloudDesc =>
      '¿Estás seguro? Esta acción eliminará permanentemente tu progreso guardado en la nube. Los datos locales no se verán afectados.';

  @override
  String get cloudDataDeleted => 'Datos cloud eliminados';

  @override
  String get progressRestored => 'Progreso restaurado desde la nube';

  @override
  String get syncSnackbar => 'Progreso sincronizado';

  @override
  String get scheduledDarkMode => 'Modo oscuro programado';

  @override
  String get scheduledDarkModeSubtitle => 'Activo/desactivo según horario';

  @override
  String get darkModeStart => 'Inicia modo oscuro';

  @override
  String get darkModeEnd => 'Termina modo oscuro';

  @override
  String darkModeScheduleInfo(Object end, Object start) {
    return 'El modo oscuro estará activo de $start:00 a $end:00';
  }

  @override
  String get authLoginTitle => 'Ingresa tus datos';

  @override
  String get authLoginButton => 'INGRESAR';

  @override
  String get authEmailLabel => 'Correo electrónico';

  @override
  String get authEmailError => 'Ingresa tu correo';

  @override
  String get authPasswordLabel => 'Contraseña';

  @override
  String get authPasswordError => 'Ingresa tu contraseña';

  @override
  String get authForgotPasswordButton => 'RESTABLECER CONTRASEÑA';

  @override
  String get authForgotPasswordTitle => 'Restablecer contraseña';

  @override
  String get authForgotPasswordDesc =>
      'Te enviaremos un enlace a tu correo para restablecer tu contraseña.';

  @override
  String get authSendLink => 'Enviar enlace';

  @override
  String get authRecoveryEmailSentTitle => 'Correo enviado';

  @override
  String get authRecoveryEmailSentDesc =>
      'Revisa tu bandeja de entrada y sigue las instrucciones para restablecer tu contraseña.';

  @override
  String get authRecoveryEmailSentMessage => 'Correo de recuperación enviado';

  @override
  String get authEnterEmailError => 'Ingresa tu correo electrónico';

  @override
  String get authBack => 'Volver';

  @override
  String get authNoAccount => '¿No tienes cuenta? ';

  @override
  String get authCreateAccount => 'Crear cuenta';

  @override
  String get authRegisterTitle => 'Crea tu cuenta';

  @override
  String get authFullName => 'Nombre completo';

  @override
  String get authNameError => 'Ingresa tu nombre';

  @override
  String get authAge => 'Edad';

  @override
  String get authPasswordMinHint => 'Contraseña (mín. 6 caracteres)';

  @override
  String get authPasswordMinError =>
      'La contraseña debe tener al menos 6 caracteres';

  @override
  String get authOrRegisterWith => 'o regístrate con';

  @override
  String get authHaveAccount => '¿Ya tienes cuenta? ';

  @override
  String get authLoginLink => 'Iniciar sesión';

  @override
  String get authEmailVerificationSent =>
      'Revisa tu correo para verificar tu cuenta';

  @override
  String get authLoginError => 'Error al iniciar sesión';

  @override
  String get authGoogleError => 'Error al iniciar sesión con Google';

  @override
  String get authFacebookError => 'Error al iniciar sesión con Facebook';

  @override
  String get authCreateAccountError => 'Error al crear cuenta';

  @override
  String get authRegisterGoogleError => 'Error al registrarse con Google';

  @override
  String get authRegisterFacebookError => 'Error al registrarse con Facebook';

  @override
  String get authSendEmailError => 'Error al enviar correo';

  @override
  String get authFirebaseUnavailable => 'Firebase no está disponible';

  @override
  String get authCanceled => 'Inicio de sesión cancelado';

  @override
  String get authNullUser => 'No se pudo obtener el usuario';

  @override
  String get authUnknown => 'Ocurrió un error inesperado';

  @override
  String get authNullToken => 'No se pudo obtener el token de Facebook';

  @override
  String get authNotFound => 'No hay cuenta registrada con este correo';

  @override
  String get authWrongPassword => 'Contraseña incorrecta';

  @override
  String get authInvalidCredential => 'Correo o contraseña incorrectos';

  @override
  String get authEmailInUse => 'Ya existe una cuenta con este correo';

  @override
  String get authWeakPassword =>
      'La contraseña debe tener al menos 6 caracteres';

  @override
  String get authInvalidEmail => 'El formato del correo no es válido';

  @override
  String get authTooManyRequests => 'Demasiados intentos. Espera un momento.';

  @override
  String get authNetworkError => 'Sin conexión a internet';

  @override
  String get authDefault => 'Error de autenticación';

  @override
  String get authNotVerified =>
      'Aún no has verificado tu correo. Revisa tu bandeja de entrada.';

  @override
  String get authVerifyError => 'No se pudo verificar. Intenta de nuevo.';

  @override
  String get authRecoveryError => 'No se pudo enviar el correo de recuperación';

  @override
  String get authNotAuthenticated => 'No hay usuario autenticado';

  @override
  String get authResendEmailError =>
      'No se pudo reenviar el correo de verificación';

  @override
  String get welcomeSubtitle =>
      'Análisis inteligente y seguridad digital.\nGratis de por vida.';

  @override
  String get welcomeStartButton => 'EMPIEZA AHORA';

  @override
  String get welcomeLoginButton => 'YA TENGO UNA CUENTA';

  @override
  String get navHome => 'Inicio';

  @override
  String get navChest => 'Cofre';

  @override
  String get navSage => 'Sage';

  @override
  String get navRanking => 'Clasificación';

  @override
  String get navProfile => 'Perfil';

  @override
  String get homeAllComplete => '¡Todo completo!';

  @override
  String get homeAllCompleteDesc => 'Has dominado todas las lecciones.';

  @override
  String get homeContinue => 'Seguir';

  @override
  String get homeViewAchievements => 'Ver logros';

  @override
  String get homeLearningPath => 'Ruta de aprendizaje';

  @override
  String get lessonsYourPath => 'Tu ruta de aprendizaje';

  @override
  String lessonsLevel(Object level) {
    return 'Nivel $level';
  }

  @override
  String get profileStreak => 'Racha';

  @override
  String get profileXpLabel => 'XP';

  @override
  String get profileGems => 'Gemas';

  @override
  String get profileAchievements => 'Logros';

  @override
  String get storeNotEnoughGems => 'No tienes suficientes gemas';

  @override
  String get storePurchaseSuccess => '¡Compra exitosa!';

  @override
  String get storeProtectStreak => 'Protege tu racha';

  @override
  String get storeGetGems => 'Consigue gemas';

  @override
  String get storePersonalization => 'Personalización';

  @override
  String get rankingTitle => 'El Coliseo';

  @override
  String get rankingSubtitle => 'Clasificación global · Top 50';

  @override
  String get rankingError => 'Error al cargar clasificación';

  @override
  String get rankingShareSubtitle => 'Supera mi rango en SAGEN';

  @override
  String get rankingShareButton => 'Compartir Flex Card';

  @override
  String get rankingSharing => 'Compartiendo...';

  @override
  String get rankingEmptyMessage => 'Completa lecciones para entrar al ranking';

  @override
  String get regHowContinue => '¿Cómo quieres continuar?';

  @override
  String get regChooseMethod => 'Elige un método para crear tu cuenta.';

  @override
  String get regEmailOption => 'Correo Electrónico';

  @override
  String get regAgeQuestion => '¿Cuántos años tienes?';

  @override
  String get regAgeValidation => 'Por favor, ingresa tu verdadera edad';

  @override
  String get regEmailTitle => 'Tu correo electrónico';

  @override
  String get regEmailDesc => 'Te enviaremos un código de verificación.';

  @override
  String get regEmailHint => 'ejemplo@correo.com';

  @override
  String get regPasswordTitle => 'Crea una contraseña';

  @override
  String get regPasswordDesc => 'Mínimo 6 caracteres para proteger tu cuenta.';

  @override
  String get regNameQuestion => '¿Cómo te llamas?';

  @override
  String get regNameHint => 'Nombre';

  @override
  String get regSurnameHint => 'Apellido';

  @override
  String get regProfileAlmostReady => '¡Casi listo!';

  @override
  String get regProfileDesc =>
      'Crea un perfil para guardar tu progreso y no perder tu racha.';

  @override
  String get regCloudSave => 'Progreso guardado en la nube';

  @override
  String get regStreakSync => 'Racha sincronizada entre dispositivos';

  @override
  String get regRewards => 'Recompensas y logros personales';

  @override
  String get regCreateProfile => 'CREAR PERFIL';

  @override
  String get regLater => 'Más adelante';

  @override
  String get regProfileCreated => 'PERFIL CREADO';

  @override
  String get regWelcomeSagen => '¡Bienvenido a SAGEN!';

  @override
  String get regReadyForLesson => 'Prepara para tu primera lección';

  @override
  String get lessonPreparing => 'Preparando tus preguntas...';

  @override
  String get lessonNoQuestions =>
      'No hay preguntas disponibles para esta lección';

  @override
  String get sessionLoading => 'Cargando...';

  @override
  String get sessionSelectAnswer => 'Selecciona una respuesta';

  @override
  String get sessionCorrect => '¡Correcto!';

  @override
  String get sessionIncorrect => 'Incorrecto';

  @override
  String sessionCorrectAnswer(Object answer) {
    return 'Respuesta correcta: $answer';
  }

  @override
  String get sessionLivesExhausted => 'Vidas agotadas';

  @override
  String get sessionLivesExhaustedDesc =>
      'Has perdido todas tus vidas. Vuelve a intentarlo.';

  @override
  String sessionScore(Object correct, Object total) {
    return '$correct/$total correctas';
  }

  @override
  String get sessionRetry => 'Reintentar';

  @override
  String get sessionBackToMap => 'Volver al mapa';

  @override
  String get resultPerfectBadge => 'SESIÓN PERFECTA';

  @override
  String get resultPerfectTitle => '¡Resultado impecable!';

  @override
  String get resultCompleteTitle => '¡Lección completada!';

  @override
  String get resultPerfectDesc =>
      'No cometiste ningún error. Eres un guardián digital.';

  @override
  String get resultNotPerfectDesc =>
      'Sigue practicando para lograr una sesión perfecta.';

  @override
  String get resultAccuracy => 'Precisión';

  @override
  String get resultLives => 'Vidas';

  @override
  String get statsNoData => 'No hay datos de lección';

  @override
  String get statsReceiveXp => 'RECIBIR XP';

  @override
  String get statsSpeed => 'Velocidad';

  @override
  String get statsNoErrors => '¡Sin errores!';

  @override
  String get statsIncredible => '¡Increíble!';

  @override
  String get statsExcellent => '¡Excelente!';

  @override
  String get statsWellDone => '¡Bien hecho!';

  @override
  String get statsKeepTrying => 'Sigue intentándolo.';

  @override
  String get reviewTitle => 'Repaso';

  @override
  String get reviewNoErrors => 'No hay errores que repasar';

  @override
  String get reviewKeepGoing => '¡Sigue así!';

  @override
  String get reviewComplete => '¡Repaso completo!';

  @override
  String get reviewGoodProgress => 'Buen avance';

  @override
  String get reviewKeepPracticing => 'Sigue practicando';

  @override
  String get reviewSagePerfect =>
      'Tus áreas débiles están mejorando. Noto tu esfuerzo.';

  @override
  String get reviewSageGood =>
      'Cada repaso fortalece tu escudo. ¿Listo para más?';

  @override
  String get reviewSageKeep =>
      'Repasar es parte del aprendizaje. Puedes volver a intentarlo cuando quieras.';

  @override
  String get reviewCorrect => 'correctas';

  @override
  String get reviewFinish => 'Finalizar repaso';

  @override
  String firstLessonProgress(Object current, Object total) {
    return 'Lección $current de $total';
  }

  @override
  String get firstLessonSeeResults => 'VER RESULTADOS';

  @override
  String get back => 'Volver';

  @override
  String get splashTitle => 'SAGEN';

  @override
  String get streakBadge => 'RACHA';

  @override
  String get streakKeepAlive => '¡Mantén tu racha activa!';

  @override
  String get streakKeepAliveDesc =>
      'Completa una lección cada día para mantener tu racha.\nCada día cuenta para fortalecer tu escudo digital.';

  @override
  String get streakStrongerShield => 'Escudo más fuerte cada día';

  @override
  String get streakRewards => 'Recompensas exclusivas al alcanzar metas';

  @override
  String get streakAchievements => 'Logros y medallas por constancia';

  @override
  String get streakGotIt => 'ENTENDIDO';

  @override
  String get commitChooseGoal => 'Elige tu meta';

  @override
  String get commitChooseGoalDesc =>
      'Selecciona cuántos días seguirás tu plan de aprendizaje.';

  @override
  String get commit1Week => '1 semana';

  @override
  String get commit2Weeks => '2 semanas';

  @override
  String get commit1Month => '1 mes';

  @override
  String commitDays(Object days) {
    return '$days días';
  }

  @override
  String get commitSelected => 'SELECCIONADO';

  @override
  String commitYourGoal(Object days) {
    return 'Tu meta: $days días';
  }

  @override
  String get commitButton => 'COMPROMETERME CON MI META';

  @override
  String commitGoalLabel(Object days) {
    return 'Tu meta: $days días';
  }

  @override
  String get onboardingDesc =>
      'Tu asistente personal de seguridad digital.\nAprende, analiza y protégete gratis.';

  @override
  String get onboardingSageStart => '¡Un gran comienzo! Cada día cuenta.';

  @override
  String get onboardingSageTwoWeeks =>
      'Dos semanas de constancia. ¡Eres imparable!';

  @override
  String get onboardingSageMonth =>
      'Un mes de disciplina. Los hábitos se forjan.';

  @override
  String get onboardingSage50Days =>
      '50 días de dedicación. ¡Leyenda en formación!';

  @override
  String get onboardingSageExcellent => 'Excelentes motivos, ¡apunta alto!';

  @override
  String get summaryOrigin => 'Origen';

  @override
  String get summaryKnowledge => 'Conocimiento';

  @override
  String get summaryInterest => 'Interés';

  @override
  String get summaryMotivations => 'Motivaciones';

  @override
  String get summaryLearning => 'Aprendizaje';

  @override
  String get summaryDailyGoal => 'Meta diaria';

  @override
  String get summaryCommitment => 'Compromiso';

  @override
  String get summaryReady =>
      'Todo listo para empezar tu viaje en seguridad digital.';

  @override
  String get profileError => 'Error al cargar perfil';

  @override
  String get profileLevel => 'Nivel';

  @override
  String get profileTotalXp => 'XP Total';

  @override
  String get settingsLogout => 'Cerrar sesión';

  @override
  String get settingsLogoutConfirm =>
      '¿Estás seguro de que quieres cerrar sesión?';

  @override
  String get rewardAdTitle => 'Gana gemas extra';

  @override
  String get rewardAdSubtitle => 'Mira un anuncio y recibe gemas al instante';

  @override
  String get rewardAdWatch => 'Ver';

  @override
  String rewardAdEarned(Object count) {
    return '¡Ganaste $count gemas!';
  }

  @override
  String get rewardAdNotAvailable =>
      'El anuncio no está disponible ahora. Intenta más tarde.';

  @override
  String get rankCybersecurityLegend => 'Leyenda de Ciberseguridad';

  @override
  String get rankEliteDefender => 'Defensor Élite';

  @override
  String get rankExperiencedWarrior => 'Guerrero Experimentado';

  @override
  String get rankActiveLearner => 'Aprendiz Activo';

  @override
  String get rankNovice => 'Novato';

  @override
  String get profileDefaultName => 'Guardián';

  @override
  String profileLevelValue(Object level) {
    return 'Nivel $level';
  }

  @override
  String get profileDay => 'día';

  @override
  String get profileDays => 'días';

  @override
  String rankingPosition(Object rank) {
    return 'Rank #$rank';
  }

  @override
  String get flexCardJoinAlliance => 'Únete a mi alianza en SAGEN';

  @override
  String get raritySilver => 'Plata';

  @override
  String get rarityGold => 'Oro';

  @override
  String get rarityPlatinum => 'Platino';

  @override
  String get achievementLocked => '???';

  @override
  String get streakFrozen => 'Racha congelada';

  @override
  String streakDaysCount(Object count) {
    return '$count días de racha';
  }

  @override
  String get streakNoActiveStreak => 'Sin racha activa';

  @override
  String get streakFreezeDescription => 'Mantén tu racha al fallar un día';

  @override
  String get storeShieldLimitReached => 'Límite de protectores alcanzado';

  @override
  String get storeChestAvailable => '¡Cofre Diario Disponible!';

  @override
  String get storeChestComeBack => 'Vuelve mañana';

  @override
  String storeChestGemsExpire(Object gems) {
    return '$gems gemas — expira a medianoche';
  }

  @override
  String get storeChestRenews => 'Tu cofre se renueva cada día';

  @override
  String get storeOpen => 'Abrir';

  @override
  String get storeTitle => 'Tienda';

  @override
  String get storeGemsLabel => 'gemas';

  @override
  String get storeBuyGems => 'Comprar gemas';

  @override
  String storeWhatsappPackages(Object price) {
    return 'Paquetes desde $price — Pago por WhatsApp';
  }

  @override
  String get storeAdEarnGem => 'Gana 1 gema extra';

  @override
  String get storeAdWatchVideo => 'Ve un video de 30 segundos';

  @override
  String get storeAdRewardMessage => '+1 Gema por ver el anuncio';

  @override
  String get storeWatch => 'Ver';

  @override
  String get paywallBasic => 'Básico';

  @override
  String get paywallPopular => 'Popular';

  @override
  String get paywallPremium => 'Premium';

  @override
  String paywallWhatsAppMessage(Object gems, Object price, Object userId) {
    return 'Hola, quiero comprar el paquete de $gems gemas por S/$price en SAGEN. Mi ID de usuario es: $userId';
  }

  @override
  String paywallWhatsAppFallback(Object message) {
    return 'Abre WhatsApp y envía: $message';
  }

  @override
  String paywallWhatsAppError(Object link) {
    return 'Error al abrir WhatsApp. Paga vía: $link';
  }

  @override
  String get paywallGetMoreGems => 'Consigue más gemas';

  @override
  String get paywallDescription =>
      'Elige tu paquete y te contactamos por WhatsApp para coordinar el pago.';

  @override
  String get paywallPaymentMethods =>
      'Paga con Yape, Plin, MercadoPago o transferencia';

  @override
  String paywallPackageGems(Object gems) {
    return '$gems gemas';
  }

  @override
  String paywallPackageLabel(Object label) {
    return 'Paquete $label';
  }

  @override
  String get summaryPerfect => '¡Perfecto!';

  @override
  String get summaryGoodWork => '¡Buen trabajo!';

  @override
  String get summaryKeepPracticing => 'Sigue practicando';

  @override
  String get summaryXpEarned => 'XP ganado';

  @override
  String get summaryGemsEarned => 'Gemas obtenidas';

  @override
  String summaryStreakDays(Object days) {
    return '+$days día(s)';
  }

  @override
  String get legalRegisterAgree => 'Al registrarte aceptas nuestros ';

  @override
  String get legalTerms => 'Términos';

  @override
  String get legalAnd => ' y ';

  @override
  String get onboardingCommitButton => 'MANTENER MI COMPROMISO';

  @override
  String get onboardingHaveAccount => 'Ya tengo una cuenta';

  @override
  String get exitText => 'Salir';

  @override
  String get dayShortMon => 'L';

  @override
  String get dayShortTue => 'M';

  @override
  String get dayShortWed => 'M';

  @override
  String get dayShortThu => 'J';

  @override
  String get dayShortFri => 'V';

  @override
  String get dayShortSat => 'S';

  @override
  String get dayShortSun => 'D';

  @override
  String streakCurrentProgress(Object current, Object goal) {
    return 'Racha actual: $current / $goal días';
  }

  @override
  String rankingYourPosition(Object rank, Object xp) {
    return 'Tu posición: #$rank · $xp XP';
  }

  @override
  String rankingXpToTop50(Object xp) {
    return 'Te faltan $xp XP para entrar al Top 50';
  }

  @override
  String get unknownLabel => 'Desconocido';

  @override
  String get homeDefaultName => 'Guardián';

  @override
  String get daysLabel => 'días';

  @override
  String chestTitle(Object type) {
    return 'Cofre $type';
  }

  @override
  String get chestTapToOpen => 'Toca para abrir';

  @override
  String chestOpenedTitle(Object type) {
    return '¡Cofre $type!';
  }

  @override
  String get chestCollect => 'Recoger';

  @override
  String get gemMultiplierLabel => '×2 Gemas';

  @override
  String get chestTypeBronze => 'Bronce';

  @override
  String get chestTypeSilver => 'Plata';

  @override
  String get chestTypeGold => 'Oro';

  @override
  String get chestTypeLegendary => 'Legendario';

  @override
  String get tutorLocked => 'Tutor IA Bloqueado';

  @override
  String get tutorLockedDescription =>
      'Completa al menos 10 lecciones para desbloquear a Sage, tu tutor personal de ciberseguridad.';

  @override
  String tutorLessonsProgress(Object completed, Object required) {
    return '$completed / $required lecciones';
  }

  @override
  String tutorMotivationAlmost(Object count) {
    return 'Ya casi, solo te faltan $count lecciones. ¡Sigue así!';
  }

  @override
  String tutorMotivationGood(Object count) {
    return '¡Buen ritmo! Te faltan $count lecciones para acceder a Sage.';
  }

  @override
  String get tutorMotivationGeneral =>
      'Cada lección te acerca más a tu tutor personal de ciberseguridad.';

  @override
  String get errorSomethingWrong => 'Algo salió mal';

  @override
  String get errorUnexpected =>
      'Ocurrió un error inesperado. Puedes intentar de nuevo.';

  @override
  String get errorRestartApp => 'Reiniciar app';

  @override
  String get profileDefaultFirstName => 'Guerrero';

  @override
  String get profileDefaultLastName => 'Anónimo';
}
