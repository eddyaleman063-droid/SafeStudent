import 'package:flutter/material.dart';
import '../services/sage_emotion_service.dart';

class WizardStepConfig {
  final String question;
  final String type;
  final SageEmotion emotion;
  final String sageMessage;
  final List<WizardOption> options;

  const WizardStepConfig({
    required this.question,
    required this.type,
    required this.emotion,
    required this.sageMessage,
    required this.options,
  });
}

class WizardOption {
  final String label;
  final String value;
  final IconData icon;
  final Color? color;
  final String? subtitle;

  const WizardOption({
    required this.label,
    required this.value,
    required this.icon,
    this.color,
    this.subtitle,
  });
}

class OnboardingWizardConfig {
  OnboardingWizardConfig._();

  static const int totalSteps = 9;

  static List<WizardStepConfig> get steps => _steps;

  static const _steps = <WizardStepConfig>[
    WizardStepConfig(
      question: '¡Bienvenido a SAGEN!',
      type: 'presentation',
      emotion: SageEmotion.excitedWave,
      sageMessage: '¡Hola! Soy Sage, tu guía de seguridad digital. ¿Comenzamos?',
      options: [],
    ),
    WizardStepConfig(
      question: '¿Cómo conociste SAGEN?',
      type: 'single',
      emotion: SageEmotion.curious,
      sageMessage: 'Cuéntame, ¿cómo nos encontraste?',
      options: [
        WizardOption(label: 'Google', value: 'Google', icon: Icons.g_mobiledata_rounded),
        WizardOption(label: 'Facebook', value: 'Facebook', icon: Icons.facebook_rounded),
        WizardOption(label: 'Instagram', value: 'Instagram', icon: Icons.camera_alt_outlined),
        WizardOption(label: 'TikTok', value: 'TikTok', icon: Icons.music_note_rounded),
        WizardOption(label: 'YouTube', value: 'YouTube', icon: Icons.play_circle_outline_rounded),
        WizardOption(label: 'App Store', value: 'App Store', icon: Icons.store_rounded),
        WizardOption(label: 'Amigos', value: 'Amigos', icon: Icons.people_outline_rounded),
        WizardOption(label: 'Noticias', value: 'Noticias', icon: Icons.article_rounded),
        WizardOption(label: 'TV', value: 'TV', icon: Icons.tv_rounded),
        WizardOption(label: 'Otros', value: 'Otros', icon: Icons.more_horiz_rounded),
      ],
    ),
    WizardStepConfig(
      question: '¿Cuánto sabes de seguridad digital?',
      type: 'level',
      emotion: SageEmotion.thinking,
      sageMessage: '¿Qué tanto sabes del tema?',
      options: [
        WizardOption(label: 'Estoy empezando', value: '1', icon: Icons.eco_rounded, color: Color(0xFF66BB6A), subtitle: 'Nunca he explorado este tema'),
        WizardOption(label: 'Conozco algunos conceptos', value: '2', icon: Icons.grass_rounded, color: Color(0xFF42A5F5), subtitle: 'Reconozco algunos términos'),
        WizardOption(label: 'Puedo defendereme', value: '3', icon: Icons.park_rounded, color: Color(0xFFFFB300), subtitle: 'Entiendo y practico lo básico'),
        WizardOption(label: 'Entiendo varios temas', value: '4', icon: Icons.forest_rounded, color: Color(0xFFE65100), subtitle: 'Manejo varios conceptos'),
        WizardOption(label: 'Se bastante del tema', value: '5', icon: Icons.landslide_rounded, color: Color(0xFF7C3AED), subtitle: 'Puedo debatir temas avanzados'),
      ],
    ),
    WizardStepConfig(
      question: '¿Por qué quieres aprender?',
      type: 'multi',
      emotion: SageEmotion.curious,
      sageMessage: '¿Por qué quieres aprender seguridad digital?',
      options: [
        WizardOption(label: 'Protegerme', value: 'shield', icon: Icons.shield_rounded),
        WizardOption(label: 'Impulsar mis estudios', value: 'school', icon: Icons.school_rounded),
        WizardOption(label: 'Por curiosidad', value: 'curiosity', icon: Icons.lightbulb_outline_rounded),
        WizardOption(label: 'Prepararme para el trabajo', value: 'work', icon: Icons.work_outline_rounded),
        WizardOption(label: 'Proteger a mi familia', value: 'family', icon: Icons.family_restroom_rounded),
        WizardOption(label: 'Para divertirme', value: 'fun', icon: Icons.celebration_outlined),
      ],
    ),
    WizardStepConfig(
      question: '¿Qué te gustaría aprender?',
      type: 'single',
      emotion: SageEmotion.curious,
      sageMessage: '¿Qué te gustaría aprender primero?',
      options: [
        WizardOption(label: 'Proteger mis cuentas', value: 'accounts', icon: Icons.lock_outline_rounded),
        WizardOption(label: 'Detectar estafas', value: 'scams', icon: Icons.warning_amber_rounded),
        WizardOption(label: 'Navegar seguro', value: 'browsing', icon: Icons.language_rounded),
        WizardOption(label: 'Proteger mi privacidad', value: 'privacy', icon: Icons.visibility_off_rounded),
        WizardOption(label: 'Todo lo anterior', value: 'all', icon: Icons.auto_awesome_rounded),
      ],
    ),
    WizardStepConfig(
      question: '¿Cómo prefieres aprender?',
      type: 'multi',
      emotion: SageEmotion.calm,
      sageMessage: 'Elige tus formas favoritas de aprender',
      options: [
        WizardOption(label: 'Practicar con quizzes', value: 'quiz', icon: Icons.quiz_rounded),
        WizardOption(label: 'Leer artículos', value: 'article', icon: Icons.article_rounded),
        WizardOption(label: 'Ver videos educativos', value: 'video', icon: Icons.ondemand_video_rounded),
        WizardOption(label: 'Analizar enlaces', value: 'link', icon: Icons.link_rounded),
        WizardOption(label: 'Chat con Sage', value: 'chat', icon: Icons.chat_rounded),
      ],
    ),
    WizardStepConfig(
      question: '¿Cuánto tiempo puedes dedicar al día?',
      type: 'goal',
      emotion: SageEmotion.calm,
      sageMessage: 'Elige tu ritmo ideal de aprendizaje',
      options: [
        WizardOption(label: '3 min', value: '3', icon: Icons.coffee_rounded, color: Color(0xFF66BB6A), subtitle: 'Relajado'),
        WizardOption(label: '10 min', value: '10', icon: Icons.timer_rounded, color: Color(0xFF42A5F5), subtitle: 'Normal'),
        WizardOption(label: '15 min', value: '15', icon: Icons.bolt_rounded, color: Color(0xFFFFB300), subtitle: 'Serio'),
        WizardOption(label: '30 min', value: '30', icon: Icons.local_fire_department_rounded, color: Color(0xFFE53935), subtitle: 'Intenso'),
      ],
    ),
    WizardStepConfig(
      question: 'Elige tu compromiso',
      type: 'multi',
      emotion: SageEmotion.excited,
      sageMessage: 'Selecciona tus metas de constancia',
      options: [
        WizardOption(label: '7 días', value: '7', icon: Icons.local_fire_department_rounded, color: Color(0xFFFFB300), subtitle: '30 gemas'),
        WizardOption(label: '14 días', value: '14', icon: Icons.local_fire_department_rounded, color: Color(0xFFFF8F00), subtitle: '80 gemas'),
        WizardOption(label: '30 días', value: '30', icon: Icons.local_fire_department_rounded, color: Color(0xFFFF6D00), subtitle: '200 gemas'),
        WizardOption(label: '50 días', value: '50', icon: Icons.local_fire_department_rounded, color: Color(0xFFE53935), subtitle: '400 gemas'),
      ],
    ),
    WizardStepConfig(
      question: 'Compromiso confirmado',
      type: 'confirmation',
      emotion: SageEmotion.excitedWave,
      sageMessage: '¡Has configurado tu ruta de aprendizaje!',
      options: [],
    ),
  ];
}
