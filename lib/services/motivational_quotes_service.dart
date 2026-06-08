import 'dart:math';

class MotivationalQuotesService {
  MotivationalQuotesService._();
  static final MotivationalQuotesService instance = MotivationalQuotesService._();

  final List<String> _all = [
    // Seguridad digital
    'Las contraseñas son como los cepillos de dientes: no se comparten.',
    'Tu mejor antivirus eres tú mismo.',
    'En la web, la curiosidad puede más que al gato.',
    'No es paranoia si realmente te están rastreando.',
    'La seguridad no es un producto, es un hábito.',
    'Cierra sesión. Siempre.',
    'Las actualizaciones no son opcionales, son tu escudo.',
    'El eslabón más débil de la seguridad siempre es el humano.',
    'Desconfía de lo que no pediste.',
    'Tu huella digital dura para siempre.',
    'Un clic puede cambiarlo todo.',
    'La mejor defensa es la prevención.',
    'Piensa antes de hacer clic.',
    'La seguridad empieza por ti.',
    'Navega seguro, vive tranquilo.',

    // Inspiradoras
    'No puedes elegir dónde iniciar tu mundo, pero sí dónde terminarlo.',
    'Incluso la antorcha más pequeña ilumina la cueva más grande.',
    'La grandeza nace de pequeños comienzos.',
    'Entre más negra la noche, más brillan las estrellas.',
    'No elimines tu mundo por un mal momento.',
    'Hoy seremos mejores.',
    'No sientas la presión. Sé la presión.',
    'Todos fallamos. Lo importante es levantarse.',
    'El que persevera, alcanza.',
    'Un paso a la vez.',
    'El momento es ahora.',
    'Tú puedes con esto y más.',
    'No te rindas, aún no ves lo que viene.',
    'La disciplina vence a la inteligencia.',
    'El cambio empieza hoy.',

    // Minecraft-style
    'Hasta una antorcha puede iluminar más que el propio corazón.',
    'Mientras más encantamientos tenga una herramienta, más dolerá perderla.',
    'Si el gato quiere convertirse en león, debe dejar el apetito por las ratas.',
    'No construyas tu casa de madera en un mundo de lava.',
    'Incluso un pico de piedra rompe el netherite si le dedicas tiempo.',
    'Cava profundo, encuentra diamantes.',
    'El sol siempre sale después de la tormenta de rayos.',
    'Las camas explotan en el nether, pero te enseñan a no rendirte.',
    'No temas a la oscuridad, lleva una antorcha.',
    'Los creepers explotan, pero tú renaces.',
    'El agua y la lava juntas crean piedra. Hasta lo opuesto construye.',
    'Las estrellas del end son infinitas, como tus posibilidades.',
    'Cae del end, pero siempre vuelves a tu cama.',
    'El dragón no es el final, es el inicio de la aventura.',
    'Tus bloques, tu mundo, tus reglas.',

    // Guerrero / disciplina
    'Levántate y lucha como el guerrero que eres.',
    'Un verdadero guerrero no abandona el campo de batalla.',
    'La disciplina es el puente entre metas y logros.',
    'El dolor es temporal, la gloria es para siempre.',
    'Un guerrero no llora por lo que pierde, agradece lo que tuvo.',
    'No cuentes los días, haz que los días cuenten.',
    'La suerte es para los que no se preparan.',
    'El guerrero sabe que la victoria empieza en la mente.',
    'Caer está permitido, levantarse es obligatorio.',
    'El silencio del entrenamiento se escucha en la batalla.',
    'Forja tu carácter antes de que las circunstancias te forjen.',
    'Primero ellos te ignoran, luego se ríen, luego te vencen.',
    'El guerrero más fuerte no es el que siempre gana, sino el que nunca se rinde.',
    'Si Dios está conmigo, ¿quién contra mí?',
    'Levántate, que el mundo aún te espera.',
  ];

  final Set<int> _recent = {};
  int _maxRecent = 8;

  void setMaxRecent(int n) => _maxRecent = n.clamp(2, 20);

  String random() {
    final available = List.generate(_all.length, (i) => i)
      ..removeWhere((i) => _recent.contains(i));

    if (available.isEmpty) {
      _recent.clear();
      return _all[Random().nextInt(_all.length)];
    }

    final idx = available[Random().nextInt(available.length)];
    _recent.add(idx);
    if (_recent.length > _maxRecent) {
      _recent.remove(_recent.first);
    }
    return _all[idx];
  }
}
