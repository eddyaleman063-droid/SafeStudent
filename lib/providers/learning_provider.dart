import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/theme/theme_constants.dart';
import '../models/learning/stage.dart';
import '../models/learning/lesson.dart';
import '../models/chest_type.dart' as chest_model;
import '../models/chest_reward.dart';
import '../services/analytics_service.dart';
import '../services/chest_event_bus.dart';
import '../services/learning_stage_service.dart';
import '../services/notification_service.dart';
import 'prefs_provider.dart';
import 'achievement_provider.dart';
import 'streak_provider.dart';
import 'service_providers.dart';
import '../repositories/learning_repository.dart';

final learningProvider = NotifierProvider<LearningNotifier, LearningState>(
  LearningNotifier.new,
);

class LearningState {
  final List<Stage> stages;
  final int gems;
  final int xp;
  final int currentLevel;
  final int lessonsCompleted;
  final List<String> achievements;
  final int totalXpEarned;
  final int totalGemsEarned;
  final bool isLoading;
  final String? errorMessage;

  const LearningState({
    this.stages = const [],
    this.gems = 0,
    this.xp = 0,
    this.currentLevel = 1,
    this.lessonsCompleted = 0,
    this.achievements = const [],
    this.totalXpEarned = 0,
    this.totalGemsEarned = 0,
    this.isLoading = true,
    this.errorMessage,
  });

  LearningState copyWith({
    List<Stage> Function()? stages,
    int? gems,
    int? xp,
    int? currentLevel,
    int? lessonsCompleted,
    List<String> Function()? achievements,
    int? totalXpEarned,
    int? totalGemsEarned,
    bool? isLoading,
    String? Function()? errorMessage,
  }) {
    return LearningState(
      stages: stages != null ? stages() : this.stages,
      gems: gems ?? this.gems,
      xp: xp ?? this.xp,
      currentLevel: currentLevel ?? this.currentLevel,
      lessonsCompleted: lessonsCompleted ?? this.lessonsCompleted,
      achievements: achievements != null ? achievements() : this.achievements,
      totalXpEarned: totalXpEarned ?? this.totalXpEarned,
      totalGemsEarned: totalGemsEarned ?? this.totalGemsEarned,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
    );
  }

  double get overallProgress {
    if (stages.isEmpty) return 0;
    final total = stages.fold<int>(0, (s, stage) => s + stage.lessons.length);
    final done = stages.fold<int>(0, (s, stage) => s + stage.completedCount);
    if (total == 0) return 0;
    return done / total;
  }

  int get nextLevelXp => currentLevel * 100;
  double get levelProgress => totalXpEarned % nextLevelXp / nextLevelXp;
}

class LearningNotifier extends Notifier<LearningState> {
  late final LearningRepository _repo;

  static const _emotionalPhrases = [
    'Ya detectas riesgos más rápido.',
    'Tu hábito digital está mejorando.',
    'Cada día entiendes mejor cómo protegerte.',
    'Estás construyendo un instinto de seguridad.',
    'Tu criterio digital se está afilando.',
    'Estás aprendiendo a ver lo que otros no ven.',
    'Tu mundo digital está más seguro gracias a ti.',
  ];

  static List<Stage> get defaultStages => [
    Stage(
      id: 'stage_1',
      title: 'Fundamentos',
      subtitle: 'Conceptos básicos de seguridad digital',
      accent: PremiumColors.gradientActive[0],
      icon: Icons.shield_rounded,
      lessons: [
        Lesson(
          id: 's1_l1',
          title: '¿Qué es la seguridad digital?',
          subtitle: 'Introducción a los conceptos fundamentales',
          challenges: [],
          xpReward: 15,
          gemReward: 5,
          estimatedMinutes: 3,
        ),
        Lesson(
          id: 's1_l2',
          title: 'Tu huella digital',
          subtitle: 'Entiende tu presencia en línea',
          challenges: [],
          xpReward: 15,
          gemReward: 5,
          estimatedMinutes: 3,
        ),
        Lesson(
          id: 's1_l3',
          title: 'Riesgos comunes en Internet',
          subtitle: 'Identifica peligros cotidianos',
          challenges: [],
          xpReward: 15,
          gemReward: 5,
          estimatedMinutes: 3,
        ),
        Lesson(
          id: 's1_l4',
          title: 'Navegación privada',
          subtitle: 'Protege tu información al navegar',
          challenges: [],
          xpReward: 15,
          gemReward: 5,
          estimatedMinutes: 3,
        ),
        Lesson(
          id: 's1_l5',
          title: 'Actualizaciones de software',
          subtitle: 'Mantén tus dispositivos seguros',
          challenges: [],
          xpReward: 15,
          gemReward: 5,
          estimatedMinutes: 3,
        ),
        Lesson(
          id: 's1_l6',
          title: 'Evaluación de fundamentos',
          subtitle: 'Repaso y práctica',
          challenges: [],
          xpReward: 20,
          gemReward: 5,
          estimatedMinutes: 4,
        ),
      ],
    ),
    Stage(
      id: 'stage_2',
      title: 'Phishing',
      subtitle: 'Identifica intentos de engaño',
      accent: PremiumColors.gradientSuspicious[0],
      icon: Icons.shield_rounded,
      lessons: [
        Lesson(
          id: 's2_l1',
          title: '¿Qué es el phishing?',
          subtitle: 'Reconoce ataques de suplantación',
          challenges: [],
          xpReward: 15,
          gemReward: 5,
          estimatedMinutes: 3,
        ),
        Lesson(
          id: 's2_l2',
          title: 'Correos sospechosos',
          subtitle: 'Señales de alerta en tu bandeja',
          challenges: [],
          xpReward: 15,
          gemReward: 5,
          estimatedMinutes: 3,
        ),
        Lesson(
          id: 's2_l3',
          title: 'Enlaces engañosos',
          subtitle: 'Verifica antes de hacer clic',
          challenges: [],
          xpReward: 15,
          gemReward: 5,
          estimatedMinutes: 3,
        ),
        Lesson(
          id: 's2_l4',
          title: 'Phishing en redes sociales',
          subtitle: 'Mensajes fraudulentos en plataformas',
          challenges: [],
          xpReward: 15,
          gemReward: 5,
          estimatedMinutes: 3,
        ),
        Lesson(
          id: 's2_l5',
          title: 'Phishing por SMS',
          subtitle: 'Smishing y cómo evitarlo',
          challenges: [],
          xpReward: 15,
          gemReward: 5,
          estimatedMinutes: 3,
        ),
        Lesson(
          id: 's2_l6',
          title: 'Phishing telefónico',
          subtitle: 'Vishing y llamadas fraudulentas',
          challenges: [],
          xpReward: 15,
          gemReward: 5,
          estimatedMinutes: 3,
        ),
        Lesson(
          id: 's2_l7',
          title: 'Casos reales de phishing',
          subtitle: 'Ejemplos y consecuencias',
          challenges: [],
          xpReward: 20,
          gemReward: 5,
          estimatedMinutes: 4,
        ),
        Lesson(
          id: 's2_l8',
          title: 'Evaluación de phishing',
          subtitle: 'Pon a prueba tu detección',
          challenges: [],
          xpReward: 20,
          gemReward: 5,
          estimatedMinutes: 4,
        ),
      ],
    ),
    Stage(
      id: 'stage_3',
      title: 'Contraseñas',
      subtitle: 'Crea claves seguras y protégete',
      accent: PremiumColors.primary,
      icon: Icons.shield_rounded,
      lessons: [
        Lesson(
          id: 's3_l1',
          title: 'Características de una buena contraseña',
          subtitle: 'Longitud, complejidad y variedad',
          challenges: [],
          xpReward: 15,
          gemReward: 5,
          estimatedMinutes: 3,
        ),
        Lesson(
          id: 's3_l2',
          title: 'Errores comunes al elegir contraseñas',
          subtitle: 'Evita claves débiles y predecibles',
          challenges: [],
          xpReward: 15,
          gemReward: 5,
          estimatedMinutes: 3,
        ),
        Lesson(
          id: 's3_l3',
          title: 'Autenticación en dos pasos',
          subtitle: 'Activa 2FA en tus cuentas',
          challenges: [],
          xpReward: 15,
          gemReward: 5,
          estimatedMinutes: 3,
        ),
        Lesson(
          id: 's3_l4',
          title: 'Gestores de contraseñas',
          subtitle: 'Solo necesitas recordar una clave',
          challenges: [],
          xpReward: 15,
          gemReward: 5,
          estimatedMinutes: 3,
        ),
        Lesson(
          id: 's3_l5',
          title: 'Contraseñas únicas por servicio',
          subtitle: 'No repitas claves entre cuentas',
          challenges: [],
          xpReward: 15,
          gemReward: 5,
          estimatedMinutes: 3,
        ),
        Lesson(
          id: 's3_l6',
          title: 'Preguntas de seguridad',
          subtitle: 'Elige respuestas difíciles de adivinar',
          challenges: [],
          xpReward: 15,
          gemReward: 5,
          estimatedMinutes: 3,
        ),
        Lesson(
          id: 's3_l7',
          title: 'Rotación de contraseñas',
          subtitle: 'Cuándo y cómo cambiarlas',
          challenges: [],
          xpReward: 20,
          gemReward: 5,
          estimatedMinutes: 4,
        ),
        Lesson(
          id: 's3_l8',
          title: 'Evaluación de contraseñas',
          subtitle: 'Repaso y práctica',
          challenges: [],
          xpReward: 20,
          gemReward: 5,
          estimatedMinutes: 4,
        ),
      ],
    ),
    Stage(
      id: 'stage_4',
      title: 'Redes Sociales',
      subtitle: 'Protege tu privacidad en plataformas',
      accent: PremiumColors.gradientSage[0],
      icon: Icons.shield_rounded,
      lessons: [
        Lesson(
          id: 's4_l1',
          title: 'Privacidad en redes sociales',
          subtitle: 'Configura quién ve tu información',
          challenges: [],
          xpReward: 15,
          gemReward: 5,
          estimatedMinutes: 3,
        ),
        Lesson(
          id: 's4_l2',
          title: 'Información que no debes compartir',
          subtitle: 'Datos personales y ubicación',
          challenges: [],
          xpReward: 15,
          gemReward: 5,
          estimatedMinutes: 3,
        ),
        Lesson(
          id: 's4_l3',
          title: 'Aceptar solicitudes',
          subtitle: '¿Con quién te conectas?',
          challenges: [],
          xpReward: 15,
          gemReward: 5,
          estimatedMinutes: 3,
        ),
        Lesson(
          id: 's4_l4',
          title: 'Publicaciones y etiquetas',
          subtitle: 'Controla tu reputación digital',
          challenges: [],
          xpReward: 15,
          gemReward: 5,
          estimatedMinutes: 3,
        ),
        Lesson(
          id: 's4_l5',
          title: 'Mensajes privados',
          subtitle: 'Precauciones en conversaciones',
          challenges: [],
          xpReward: 15,
          gemReward: 5,
          estimatedMinutes: 3,
        ),
        Lesson(
          id: 's4_l6',
          title: 'Suplantación de identidad',
          subtitle: 'Perfiles falsos y cómo detectarlos',
          challenges: [],
          xpReward: 20,
          gemReward: 5,
          estimatedMinutes: 4,
        ),
        Lesson(
          id: 's4_l7',
          title: 'Ciberacoso',
          subtitle: 'Identifica y actúa contra el acoso',
          challenges: [],
          xpReward: 20,
          gemReward: 5,
          estimatedMinutes: 4,
        ),
        Lesson(
          id: 's4_l8',
          title: 'Configuración avanzada',
          subtitle: 'Ajusta cada plataforma',
          challenges: [],
          xpReward: 20,
          gemReward: 5,
          estimatedMinutes: 4,
        ),
        Lesson(
          id: 's4_l9',
          title: 'Huella digital en redes',
          subtitle: 'Lo que publicas queda para siempre',
          challenges: [],
          xpReward: 20,
          gemReward: 5,
          estimatedMinutes: 4,
        ),
        Lesson(
          id: 's4_l10',
          title: 'Evaluación de redes sociales',
          subtitle: 'Repaso y práctica',
          challenges: [],
          xpReward: 25,
          gemReward: 5,
          estimatedMinutes: 5,
        ),
      ],
    ),
    Stage(
      id: 'stage_5',
      title: 'Navegación Segura',
      subtitle: 'Desinformación y sitios confiables',
      accent: PremiumColors.gradientSafe[0],
      icon: Icons.shield_rounded,
      lessons: [
        Lesson(
          id: 's5_l1',
          title: 'Conexiones seguras',
          subtitle: 'HTTPS y candados verdes',
          challenges: [],
          xpReward: 15,
          gemReward: 5,
          estimatedMinutes: 3,
        ),
        Lesson(
          id: 's5_l2',
          title: 'Redes WiFi públicas',
          subtitle: 'Riesgos al conectarte',
          challenges: [],
          xpReward: 15,
          gemReward: 5,
          estimatedMinutes: 3,
        ),
        Lesson(
          id: 's5_l3',
          title: 'VPN y anonimato',
          subtitle: 'Navega de forma privada',
          challenges: [],
          xpReward: 15,
          gemReward: 5,
          estimatedMinutes: 3,
        ),
        Lesson(
          id: 's5_l4',
          title: 'Descargas seguras',
          subtitle: 'Solo desde fuentes oficiales',
          challenges: [],
          xpReward: 15,
          gemReward: 5,
          estimatedMinutes: 3,
        ),
        Lesson(
          id: 's5_l5',
          title: 'Extensiones del navegador',
          subtitle: 'Instala solo lo necesario',
          challenges: [],
          xpReward: 15,
          gemReward: 5,
          estimatedMinutes: 3,
        ),
        Lesson(
          id: 's5_l6',
          title: 'Noticias falsas',
          subtitle: 'Identifica desinformación',
          challenges: [],
          xpReward: 20,
          gemReward: 5,
          estimatedMinutes: 4,
        ),
        Lesson(
          id: 's5_l7',
          title: 'Fuentes confiables',
          subtitle: 'Verifica la información',
          challenges: [],
          xpReward: 20,
          gemReward: 5,
          estimatedMinutes: 4,
        ),
        Lesson(
          id: 's5_l8',
          title: 'Deepfakes y manipulación',
          subtitle: 'Contenido generado por IA',
          challenges: [],
          xpReward: 20,
          gemReward: 5,
          estimatedMinutes: 4,
        ),
        Lesson(
          id: 's5_l9',
          title: 'Códigos QR maliciosos',
          subtitle: 'Escanea con precaución',
          challenges: [],
          xpReward: 20,
          gemReward: 5,
          estimatedMinutes: 4,
        ),
        Lesson(
          id: 's5_l10',
          title: 'Evaluación de navegación',
          subtitle: 'Repaso y práctica',
          challenges: [],
          xpReward: 25,
          gemReward: 5,
          estimatedMinutes: 5,
        ),
      ],
    ),
    Stage(
      id: 'stage_6',
      title: 'Privacidad Digital',
      subtitle: 'Controla tus datos personales',
      accent: PremiumColors.gradientShieldCrystal[0],
      icon: Icons.shield_rounded,
      lessons: [
        Lesson(
          id: 's6_l1',
          title: '¿Qué son los datos personales?',
          subtitle: 'Información que te identifica',
          challenges: [],
          xpReward: 15,
          gemReward: 5,
          estimatedMinutes: 3,
        ),
        Lesson(
          id: 's6_l2',
          title: 'Permisos de aplicaciones',
          subtitle: 'Revisa qué acceden tus apps',
          challenges: [],
          xpReward: 15,
          gemReward: 5,
          estimatedMinutes: 3,
        ),
        Lesson(
          id: 's6_l3',
          title: 'Rastreo en línea',
          subtitle: 'Cookies y rastreadores',
          challenges: [],
          xpReward: 15,
          gemReward: 5,
          estimatedMinutes: 3,
        ),
        Lesson(
          id: 's6_l4',
          title: 'Publicidad dirigida',
          subtitle: 'Cómo te perfilan las empresas',
          challenges: [],
          xpReward: 15,
          gemReward: 5,
          estimatedMinutes: 3,
        ),
        Lesson(
          id: 's6_l5',
          title: 'Filtraciones de datos',
          subtitle: 'Qué hacer si tus datos se exponen',
          challenges: [],
          xpReward: 15,
          gemReward: 5,
          estimatedMinutes: 3,
        ),
        Lesson(
          id: 's6_l6',
          title: 'Derechos digitales',
          subtitle: 'Conoce tus derechos de privacidad',
          challenges: [],
          xpReward: 20,
          gemReward: 5,
          estimatedMinutes: 4,
        ),
        Lesson(
          id: 's6_l7',
          title: 'Navegación anónima',
          subtitle: 'Tor y navegadores privados',
          challenges: [],
          xpReward: 20,
          gemReward: 5,
          estimatedMinutes: 4,
        ),
        Lesson(
          id: 's6_l8',
          title: 'Borrado de datos',
          subtitle: 'Elimina información innecesaria',
          challenges: [],
          xpReward: 20,
          gemReward: 5,
          estimatedMinutes: 4,
        ),
        Lesson(
          id: 's6_l9',
          title: 'Gestión de identidad digital',
          subtitle: 'Construye una presencia positiva',
          challenges: [],
          xpReward: 20,
          gemReward: 5,
          estimatedMinutes: 4,
        ),
        Lesson(
          id: 's6_l10',
          title: 'Privacidad en el trabajo',
          subtitle: 'Protege datos profesionales',
          challenges: [],
          xpReward: 20,
          gemReward: 5,
          estimatedMinutes: 4,
        ),
        Lesson(
          id: 's6_l11',
          title: 'Cifrado de datos',
          subtitle: 'Protege tu información sensible',
          challenges: [],
          xpReward: 20,
          gemReward: 5,
          estimatedMinutes: 4,
        ),
        Lesson(
          id: 's6_l12',
          title: 'Evaluación de privacidad',
          subtitle: 'Repaso y práctica',
          challenges: [],
          xpReward: 25,
          gemReward: 5,
          estimatedMinutes: 5,
        ),
      ],
    ),
    Stage(
      id: 'stage_7',
      title: 'Ciberseguridad Avanzada',
      subtitle: 'Protección total para expertos',
      accent: PremiumColors.gradientShieldLegendary[0],
      icon: Icons.shield_rounded,
      lessons: [
        Lesson(
          id: 's7_l1',
          title: 'Malware y sus tipos',
          subtitle: 'Virus, troyanos, ransomware',
          challenges: [],
          xpReward: 20,
          gemReward: 5,
          estimatedMinutes: 3,
        ),
        Lesson(
          id: 's7_l2',
          title: 'Ransomware',
          subtitle: 'Secuestro de datos y protección',
          challenges: [],
          xpReward: 20,
          gemReward: 5,
          estimatedMinutes: 3,
        ),
        Lesson(
          id: 's7_l3',
          title: 'Ingeniería social',
          subtitle: ' Manipulación psicológica',
          challenges: [],
          xpReward: 20,
          gemReward: 5,
          estimatedMinutes: 3,
        ),
        Lesson(
          id: 's7_l4',
          title: 'Ataques de fuerza bruta',
          subtitle: 'Cómo protegerte',
          challenges: [],
          xpReward: 20,
          gemReward: 5,
          estimatedMinutes: 3,
        ),
        Lesson(
          id: 's7_l5',
          title: 'Seguridad en IoT',
          subtitle: 'Dispositivos inteligentes',
          challenges: [],
          xpReward: 20,
          gemReward: 5,
          estimatedMinutes: 3,
        ),
        Lesson(
          id: 's7_l6',
          title: 'Firewalls y antivirus',
          subtitle: 'Capas de protección',
          challenges: [],
          xpReward: 20,
          gemReward: 5,
          estimatedMinutes: 3,
        ),
        Lesson(
          id: 's7_l7',
          title: 'Redes privadas',
          subtitle: 'Segmentación y seguridad de red',
          challenges: [],
          xpReward: 20,
          gemReward: 5,
          estimatedMinutes: 3,
        ),
        Lesson(
          id: 's7_l8',
          title: 'Criptografía básica',
          subtitle: 'Fundamentos de cifrado',
          challenges: [],
          xpReward: 20,
          gemReward: 5,
          estimatedMinutes: 4,
        ),
        Lesson(
          id: 's7_l9',
          title: 'Seguridad en la nube',
          subtitle: 'Protege tus archivos en línea',
          challenges: [],
          xpReward: 20,
          gemReward: 5,
          estimatedMinutes: 4,
        ),
        Lesson(
          id: 's7_l10',
          title: 'Ethical hacking',
          subtitle: 'Piensa como un atacante',
          challenges: [],
          xpReward: 20,
          gemReward: 5,
          estimatedMinutes: 4,
        ),
        Lesson(
          id: 's7_l11',
          title: 'Análisis de vulnerabilidades',
          subtitle: 'Identifica puntos débiles',
          challenges: [],
          xpReward: 25,
          gemReward: 5,
          estimatedMinutes: 4,
        ),
        Lesson(
          id: 's7_l12',
          title: 'Evaluación avanzada',
          subtitle: 'Repaso y práctica',
          challenges: [],
          xpReward: 25,
          gemReward: 5,
          estimatedMinutes: 5,
        ),
      ],
    ),
    Stage(
      id: 'stage_8',
      title: 'Experto Digital',
      subtitle: 'Conviértete en un guardián digital',
      accent: PremiumColors.gradientAchievement[0],
      icon: Icons.shield_rounded,
      lessons: [
        Lesson(
          id: 's8_l1',
          title: 'Seguridad integral',
          subtitle: 'Visión completa de protección',
          challenges: [],
          xpReward: 20,
          gemReward: 5,
          estimatedMinutes: 3,
        ),
        Lesson(
          id: 's8_l2',
          title: 'Respuesta a incidentes',
          subtitle: 'Qué hacer ante un ataque',
          challenges: [],
          xpReward: 20,
          gemReward: 5,
          estimatedMinutes: 3,
        ),
        Lesson(
          id: 's8_l3',
          title: 'Recuperación de datos',
          subtitle: 'Backups y restauración',
          challenges: [],
          xpReward: 20,
          gemReward: 5,
          estimatedMinutes: 3,
        ),
        Lesson(
          id: 's8_l4',
          title: 'Seguridad familiar',
          subtitle: 'Protege a los tuyos',
          challenges: [],
          xpReward: 20,
          gemReward: 5,
          estimatedMinutes: 3,
        ),
        Lesson(
          id: 's8_l5',
          title: 'Ciberseguro laboral',
          subtitle: 'Prácticas en el trabajo',
          challenges: [],
          xpReward: 20,
          gemReward: 5,
          estimatedMinutes: 3,
        ),
        Lesson(
          id: 's8_l6',
          title: 'Donación digital',
          subtitle: 'Comparte tu conocimiento',
          challenges: [],
          xpReward: 20,
          gemReward: 5,
          estimatedMinutes: 3,
        ),
        Lesson(
          id: 's8_l7',
          title: 'Tendencias de seguridad',
          subtitle: 'Nuevas amenazas y soluciones',
          challenges: [],
          xpReward: 20,
          gemReward: 5,
          estimatedMinutes: 3,
        ),
        Lesson(
          id: 's8_l8',
          title: 'Criptomonedas y estafas',
          subtitle: 'Riesgos financieros digitales',
          challenges: [],
          xpReward: 20,
          gemReward: 5,
          estimatedMinutes: 4,
        ),
        Lesson(
          id: 's8_l9',
          title: 'Privacidad en IA',
          subtitle: 'Protege tus datos de asistentes',
          challenges: [],
          xpReward: 20,
          gemReward: 5,
          estimatedMinutes: 4,
        ),
        Lesson(
          id: 's8_l10',
          title: 'Seguridad en gaming',
          subtitle: 'Protege tu experiencia de juego',
          challenges: [],
          xpReward: 20,
          gemReward: 5,
          estimatedMinutes: 4,
        ),
        Lesson(
          id: 's8_l11',
          title: 'Cumplimiento normativo',
          subtitle: 'Regulaciones de protección',
          challenges: [],
          xpReward: 25,
          gemReward: 5,
          estimatedMinutes: 4,
        ),
        Lesson(
          id: 's8_l12',
          title: 'Auditoría personal',
          subtitle: 'Evalúa tu seguridad digital',
          challenges: [],
          xpReward: 25,
          gemReward: 5,
          estimatedMinutes: 4,
        ),
        Lesson(
          id: 's8_l13',
          title: 'Certificaciones digitales',
          subtitle: 'Acredita tus conocimientos',
          challenges: [],
          xpReward: 25,
          gemReward: 5,
          estimatedMinutes: 4,
        ),
        Lesson(
          id: 's8_l14',
          title: 'Comunidad digital',
          subtitle: 'Ayuda a otros a protegerse',
          challenges: [],
          xpReward: 25,
          gemReward: 5,
          estimatedMinutes: 4,
        ),
        Lesson(
          id: 's8_l15',
          title: 'Evaluación final',
          subtitle: 'Examen completo del curso',
          challenges: [],
          xpReward: 30,
          gemReward: 10,
          estimatedMinutes: 5,
        ),
      ],
    ),
  ];

  String get currentEmotionalPhrase {
    if (state.lessonsCompleted == 0) return 'Tu viaje digital comienza hoy.';
    final idx = (state.lessonsCompleted - 1) % _emotionalPhrases.length;
    return _emotionalPhrases[idx];
  }

  @override
  LearningState build() {
    final prefs = ref.watch(prefsProvider);
    final cloudSync = ref.watch(cloudSyncServiceProvider);
    _repo = LearningRepositoryImpl(
      prefs,
      cloudSync,
      const LearningStageService(),
    );
    Future.microtask(_init);
    return const LearningState();
  }

  Future<void> _init() async {
    try {
      await _load();

      final freshStages = await _repo.fetchStages();
      if (freshStages.isNotEmpty) {
        _mergeProgress(freshStages, state.stages);
        state = state.copyWith(stages: () => freshStages);
        _repo.saveStages(state.stages);
      }

      var currentStages = state.stages;
      if (currentStages.isEmpty) {
        currentStages = List.of(defaultStages);
        currentStages = _unlockFirstStage(currentStages);
        _repo.saveStages(currentStages);
        state = state.copyWith(stages: () => currentStages);
      }

      if (currentStages.isNotEmpty && !currentStages[0].unlocked) {
        currentStages = _unlockFirstStage(currentStages);
        state = state.copyWith(stages: () => currentStages);
      }

      state = state.copyWith(isLoading: false, errorMessage: () => null);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: () =>
            'No pudimos cargar tu progreso. Revisa tu conexión e intenta de nuevo.',
      );
    }
  }

  List<Stage> _unlockFirstStage(List<Stage> stages) {
    return stages
        .map((s) => s.id == stages[0].id ? s.copyWith(unlocked: true) : s)
        .toList();
  }

  void _mergeProgress(List<Stage> freshStages, List<Stage> cachedStages) {
    for (int i = 0; i < freshStages.length; i++) {
      final fresh = freshStages[i];
      final cached = cachedStages.where((s) => s.id == fresh.id).firstOrNull;
      if (cached == null) continue;
      final updatedLessons = fresh.lessons.map((freshLesson) {
        final cachedLesson = cached.lessons
            .where((l) => l.id == freshLesson.id)
            .firstOrNull;
        if (cachedLesson != null && cachedLesson.completed) {
          return freshLesson.copyWith(completed: true);
        }
        return freshLesson;
      }).toList();
      freshStages[i] = fresh.copyWith(
        unlocked: cached.unlocked,
        lessons: updatedLessons,
      );
    }
  }

  Future<void> _load() async {
    await _repo.load();
    state = state.copyWith(
      stages: () => List.from(_repo.stages),
      gems: _repo.gems,
      xp: _repo.xp,
      currentLevel: _repo.currentLevel,
      lessonsCompleted: _repo.lessonsCompleted,
      achievements: () => List.from(_repo.achievements),
      totalXpEarned: _repo.totalXpEarned,
      totalGemsEarned: _repo.totalGemsEarned,
    );
  }

  void _save() {
    final s = state;
    _repo.saveStages(s.stages);
    _repo.saveGems(s.gems);
    _repo.saveXp(s.xp);
    _repo.saveLevel(s.currentLevel);
    _repo.saveLessonsCompleted(s.lessonsCompleted);
    _repo.saveTotalXp(s.totalXpEarned);
    _repo.saveTotalGems(s.totalGemsEarned);
    _repo.saveAchievements(s.achievements);
    _repo.saveIntegrity();
  }

  void completeLesson(
    String stageId,
    String lessonId, {
    bool perfectLesson = false,
  }) {
    final stages = state.stages.map((s) {
      if (s.id != stageId) return s;
      final lessons = s.lessons.map((l) {
        if (l.id != lessonId || l.completed) return l;
        return l.copyWith(completed: true);
      }).toList();
      return s.copyWith(lessons: lessons);
    }).toList();

    final lesson = state.stages
        .firstWhere((s) => s.id == stageId)
        .lessons
        .firstWhere((l) => l.id == lessonId);
    if (lesson.completed) return;

    final newLessonsCompleted = state.lessonsCompleted + 1;
    final newGems = state.gems + lesson.gemReward;
    final newTotalGems = state.totalGemsEarned + lesson.gemReward;
    final newXp = state.xp + lesson.xpReward;
    final newTotalXp = state.totalXpEarned + lesson.xpReward;

    final newLevel = (newTotalXp / 100).floor() + 1;
    final finalCurrentLevel = newLevel > state.currentLevel
        ? newLevel
        : state.currentLevel;
    final finalXp = newLevel > state.currentLevel ? 0 : newXp;

    state = state.copyWith(
      stages: () => stages,
      lessonsCompleted: newLessonsCompleted,
      gems: newGems,
      totalGemsEarned: newTotalGems,
      xp: finalXp,
      totalXpEarned: newTotalXp,
      currentLevel: finalCurrentLevel,
    );

    AnalyticsService.instance.trackLessonComplete(lessonId);
    _checkUnlocks();
    _checkAchievements(perfectLesson);
    _save();

    _checkLessonChest();
    _scheduleStreakReminder();
  }

  void _scheduleStreakReminder() {
    final streak = StreakNotifier.currentStreakStatic;
    NotificationService.instance.scheduleStreakReminder(streak);
  }

  void _checkLessonChest() {
    if (!ChestSystem.shouldUnlockChest(state.lessonsCompleted)) return;

    final type = _chestTypeFor(state.lessonsCompleted);
    final reward = ChestRewardRoller.roll(type);

    if (reward.xp > 0) addXp(reward.xp);
    if (reward.gems > 0) addGems(reward.gems);

    ChestEventBus.instance.fire(
      ChestRewardData(
        type: type,
        xp: reward.xp,
        gems: reward.gems,
        streakShields: reward.streakShields,
        xpBoost: reward.xpBoost,
        gemMultiplier: reward.gemMultiplier,
        title: '¡${type.label}!',
        message: 'Sigue aprendiendo para más recompensas.',
        source: 'lesson',
      ),
    );
  }

  chest_model.ChestType _chestTypeFor(int lessons) {
    if (lessons % 10 == 0) return chest_model.ChestType.legendary;
    if (lessons % 5 == 0) return chest_model.ChestType.gold;
    if (lessons % 6 == 0) return chest_model.ChestType.silver;
    return chest_model.ChestType.bronze;
  }

  void _checkAchievements(bool perfectLesson) {
    final lc = state.lessonsCompleted;
    if (lc >= 1) { AchievementProvider.instance.unlockAchievement('first_lesson'); }
    if (lc >= 5) { AchievementProvider.instance.unlockAchievement('five_lessons'); }
    if (lc >= 10) { AchievementProvider.instance.unlockAchievement('ten_lessons'); }
    if (lc >= 25) {
      AchievementProvider.instance.unlockAchievement('twenty_five_lessons');
    }
    if (lc >= 50) {
      AchievementProvider.instance.unlockAchievement('fifty_lessons');
    }

    final firstComplete = state.stages.any((s) => s.isComplete);
    if (firstComplete) {
      AchievementProvider.instance.unlockAchievement('stage_complete');
    }

    final allComplete = state.stages.every((s) => s.isComplete);
    if (allComplete) {
      AchievementProvider.instance.unlockAchievement('all_stages');
    }

    if (perfectLesson) {
      AchievementProvider.instance.unlockAchievement('perfect_lesson');
    }
  }

  void _checkUnlocks() {
    var stages = state.stages;
    bool changed = false;
    for (int i = 1; i < stages.length; i++) {
      final prev = stages[i - 1];
      if (prev.isComplete && !stages[i].unlocked) {
        stages[i] = stages[i].copyWith(unlocked: true);
        changed = true;
      }
    }
    if (changed) {
      state = state.copyWith(stages: () => stages);
    }
  }

  bool isStageUnlocked(String stageId) {
    final idx = state.stages.indexWhere((s) => s.id == stageId);
    if (idx <= 0) return true;
    return state.stages[idx].unlocked;
  }

  void addGems(int amount) {
    state = state.copyWith(
      gems: state.gems + amount,
      totalGemsEarned: state.totalGemsEarned + amount,
    );
    _save();
  }

  bool spendGems(int amount) {
    if (state.gems < amount) return false;
    state = state.copyWith(gems: state.gems - amount);
    _save();
    return true;
  }

  /// Combined spend + execute with automatic rollback on failure.
  bool spendGemsAtomic(int amount, bool Function() purchaseAction) {
    if (state.gems < amount) return false;
    final before = state.gems;
    state = state.copyWith(gems: state.gems - amount);
    _save();
    try {
      if (!purchaseAction()) {
        state = state.copyWith(gems: before);
        _save();
        return false;
      }
      return true;
    } catch (_) {
      state = state.copyWith(gems: before);
      _save();
      return false;
    }
  }

  void addXp(int amount) {
    final newXp = state.xp + amount;
    final newTotalXp = state.totalXpEarned + amount;
    final newLevel = (newTotalXp / 100).floor() + 1;
    state = state.copyWith(
      xp: newLevel > state.currentLevel ? 0 : newXp,
      totalXpEarned: newTotalXp,
      currentLevel: newLevel > state.currentLevel
          ? newLevel
          : state.currentLevel,
    );
    _save();
  }

  void unlockAchievement(String name) {
    if (state.achievements.contains(name)) return;
    state = state.copyWith(achievements: () => [...state.achievements, name]);
    _save();
  }

  Future<void> reload() async {
    try {
      await _load();
      state = state.copyWith(errorMessage: () => null);
    } catch (e) {
      state = state.copyWith(
        errorMessage: () =>
            'No pudimos recargar tu progreso. Intenta de nuevo.',
      );
    }
  }
}
