import 'dart:async';
import 'package:flutter/material.dart';

enum SageEmotion {
  calm,
  happy,
  curious,
  thinking,
  reading,
  serious,
  neutral,
  excited,
  confused,
  worried,
  sadSoft,
  crying,
  depressed,
  dead,
  angry,
  furious,
  shocked,
  sleepy,
  whistling,
  pointLeft,
  pointRight,
  wink,
  shy,
  laughing,
  singing,
  scared,
  embarrassed,
  annoyed,
  unmotivated,
  knockedOut,
  distressed,
  aggressive,
  lol,
  happyWings,
  excitedWave,
  surprisedWings,
}

extension SageEmotionX on SageEmotion {
  String get assetPath => 'assets/mascot/emotions/$_fileName.png';

  String get _fileName {
    switch (this) {
      case SageEmotion.calm: return 'sage_calm';
      case SageEmotion.happy: return 'sage_neutral';
      case SageEmotion.curious: return 'sage_curious';
      case SageEmotion.thinking: return 'sage_thinking';
      case SageEmotion.reading: return 'sage_reading';
      case SageEmotion.serious: return 'sage_serious';
      case SageEmotion.neutral: return 'sage_neutral';
      case SageEmotion.excited: return 'sage_excited_wave';
      case SageEmotion.confused: return 'sage_confused';
      case SageEmotion.worried: return 'sage_worried';
      case SageEmotion.sadSoft: return 'sage_sad_soft';
      case SageEmotion.crying: return 'sage_crying';
      case SageEmotion.depressed: return 'sage_depressed';
      case SageEmotion.dead: return 'sage_dead';
      case SageEmotion.angry: return 'sage_angry';
      case SageEmotion.furious: return 'sage_furious_1';
      case SageEmotion.shocked: return 'sage_shocked';
      case SageEmotion.sleepy: return 'sage_sleeping';
      case SageEmotion.whistling: return 'sage_whistling';
      case SageEmotion.pointLeft: return 'sage_point_left';
      case SageEmotion.pointRight: return 'sage_point_right';
      case SageEmotion.wink: return 'sage_wink';
      case SageEmotion.shy: return 'sage_shy';
      case SageEmotion.laughing: return 'sage_laughing';
      case SageEmotion.singing: return 'sage_singing';
      case SageEmotion.scared: return 'sage_scared';
      case SageEmotion.embarrassed: return 'sage_embarrassed';
      case SageEmotion.annoyed: return 'sage_annoyed';
      case SageEmotion.unmotivated: return 'sage_unmotivated';
      case SageEmotion.knockedOut: return 'sage_knocked_out';
      case SageEmotion.distressed: return 'sage_distressed';
      case SageEmotion.aggressive: return 'sage_aggressive';
      case SageEmotion.lol: return 'sage_lol';
      case SageEmotion.happyWings: return 'sage_happy_wings';
      case SageEmotion.excitedWave: return 'sage_excited_wave';
      case SageEmotion.surprisedWings: return 'sage_surprised_wings';
    }
  }
}

class SageContext {
  final SageEmotion emotion;
  final String? message;

  const SageContext({required this.emotion, this.message});
}

class SageEmotionService {
  SageEmotionService._();
  static final instance = SageEmotionService._();

  final Set<SageEmotion> _precached = {};
  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) return;
    _initialized = true;
    await precacheCore();
  }

  Future<void> precacheCore() async {
    final core = {
      SageEmotion.calm,
      SageEmotion.happy,
      SageEmotion.curious,
      SageEmotion.thinking,
      SageEmotion.reading,
      SageEmotion.serious,
      SageEmotion.excited,
      SageEmotion.worried,
      SageEmotion.sadSoft,
    };
    for (final e in core) {
      await _precache(e);
    }
  }

  Future<void> _precache(SageEmotion emotion) async {
    if (_precached.contains(emotion)) return;
    final provider = AssetImage(emotion.assetPath);
    await provider.evict();
    final stream = provider.resolve(ImageConfiguration.empty);
    final completer = Completer<void>();
    final listener = ImageStreamListener(
      (image, sync) => completer.complete(),
      onError: (exception, stackTrace) => completer.complete(),
    );
    stream.addListener(listener);
    await completer.future;
    stream.removeListener(listener);
    _precached.add(emotion);
  }

  SageContext forHome() {
    return const SageContext(emotion: SageEmotion.calm, message: '¡Bienvenido de vuelta!');
  }

  SageContext forTaskComplete() {
    return const SageContext(emotion: SageEmotion.excited, message: '¡Excelente trabajo!');
  }

  SageContext forXpGain() {
    return const SageContext(emotion: SageEmotion.happy, message: 'Sigues avanzando');
  }

  SageContext forLearningQuestion() {
    return const SageContext(emotion: SageEmotion.thinking, message: '¿Qué crees que es correcto?');
  }

  SageContext forOnboarding() {
    return const SageContext(emotion: SageEmotion.curious, message: 'Cuéntame más de ti');
  }

  SageContext forExplanation() {
    return const SageContext(emotion: SageEmotion.serious, message: 'Esto es muy importante');
  }

  SageContext forLoading() {
    return const SageContext(emotion: SageEmotion.thinking, message: 'Dame un segundo...');
  }

  SageContext forInitializing() {
    return const SageContext(emotion: SageEmotion.calm, message: 'Preparando todo para ti');
  }

  SageContext forHighStreak() {
    return const SageContext(emotion: SageEmotion.excited, message: '¡Racha impresionante!');
  }

  SageContext forStreakAtRisk() {
    return const SageContext(emotion: SageEmotion.worried, message: '¡No pierdas tu racha!');
  }

  SageContext forStreakLost() {
    return const SageContext(emotion: SageEmotion.sadSoft, message: 'La racha se ha perdido');
  }

  SageContext forAchievement() {
    return const SageContext(emotion: SageEmotion.excited, message: '¡Logro desbloqueado!');
  }

  SageContext forCelebration() {
    return const SageContext(emotion: SageEmotion.excitedWave, message: '¡Felicidades!');
  }

  SageContext forError(String? detail) {
    return SageContext(
      emotion: SageEmotion.worried,
      message: detail ?? 'Algo salió mal',
    );
  }

  SageContext forCriticalError() {
    return const SageContext(emotion: SageEmotion.serious, message: 'Error crítico');
  }

  SageContext forEasterEgg() {
    return const SageContext(emotion: SageEmotion.wink, message: '¿Viste eso?');
  }

  SageContext forEmptyState() {
    return const SageContext(emotion: SageEmotion.calm, message: 'No hay nada aquí todavía');
  }

  SageContext forRetry() {
    return const SageContext(emotion: SageEmotion.curious, message: '¿Intentamos de nuevo?');
  }

  SageContext forSuccess() {
    return const SageContext(emotion: SageEmotion.happy, message: '¡Perfecto!');
  }

  SageContext forReading() {
    return const SageContext(emotion: SageEmotion.reading, message: 'Lee con atención');
  }

  double emotionSize(SageEmotion emotion) {
    if (emotion == SageEmotion.reading || emotion == SageEmotion.thinking) return 100;
    if (emotion == SageEmotion.excited || emotion == SageEmotion.excitedWave || emotion == SageEmotion.happyWings) return 110;
    return 90;
  }

  bool shouldAnimateEmotionChange(SageEmotion old, SageEmotion next) {
    if (old == next) return false;
    if (old == SageEmotion.dead || next == SageEmotion.dead) return true;
    if (old == SageEmotion.crying || next == SageEmotion.crying) return true;
    if (old == SageEmotion.furious || next == SageEmotion.furious) return true;
    final neutralSet = {SageEmotion.calm, SageEmotion.neutral, SageEmotion.happy};
    if (neutralSet.contains(old) && neutralSet.contains(next)) return false;
    final closeSet = {
      SageEmotion.happy, SageEmotion.happyWings, SageEmotion.excited, SageEmotion.excitedWave,
      SageEmotion.laughing, SageEmotion.lol,
    };
    if (closeSet.contains(old) && closeSet.contains(next)) return false;
    final negativeSet = {
      SageEmotion.worried, SageEmotion.sadSoft, SageEmotion.crying,
      SageEmotion.depressed, SageEmotion.angry, SageEmotion.annoyed,
    };
    if (negativeSet.contains(old) && negativeSet.contains(next)) return false;
    return true;
  }

  bool canIdleBreathe(SageEmotion emotion) {
    switch (emotion) {
      case SageEmotion.calm:
      case SageEmotion.neutral:
      case SageEmotion.thinking:
      case SageEmotion.reading:
      case SageEmotion.curious:
      case SageEmotion.serious:
      case SageEmotion.sleepy:
      case SageEmotion.whistling:
        return true;
      default:
        return false;
    }
  }
}
