enum UpdateType { feature, improvement, fix }

class UpdateEntry {
  final DateTime date;
  final String title;
  final String description;
  final UpdateType type;
  final String version;
  final bool isNew;

  const UpdateEntry({
    required this.date,
    required this.title,
    required this.description,
    this.type = UpdateType.improvement,
    required this.version,
    this.isNew = false,
  });

  static List<UpdateEntry> all() => _entries;

  static List<UpdateEntry> newEntries() => _entries.where((e) => e.isNew).toList();
}

final _entries = <UpdateEntry>[
  UpdateEntry(
    date: _june(13),
    title: 'Sistema de Energía',
    description: 'Ahora cada lección consume energía. Responde bien para gastar solo 1,'
        ' fallar cuesta 2. Los combos de aciertos regeneran energía.'
        ' Al llegar a 0 no puedes continuar la lección.',
    type: UpdateType.feature,
    version: '1.5.0',
    isNew: true,
  ),
  UpdateEntry(
    date: _june(13),
    title: 'Energía Infinita',
    description: 'Nuevo objeto especial en la tienda que otorga energía ilimitada'
        ' por tiempo limitado. Actívalo desde tu inventario.',
    type: UpdateType.feature,
    version: '1.5.0',
    isNew: true,
  ),
  UpdateEntry(
    date: _june(13),
    title: 'Iconos de objetos mejorados',
    description: 'Todos los objetos especiales ahora tienen iconos'
        ' personalizados y más llamativos en la tienda y el inventario.',
    version: '1.5.0',
    isNew: true,
  ),
  UpdateEntry(
    date: _june(12),
    title: 'Rutas tipadas con GoRouter Builder',
    description: 'Las rutas de splash y welcome ahora son tipadas,'
        ' detectando errores en tiempo de compilación.',
    version: '1.4.1',
    isNew: true,
  ),
  UpdateEntry(
    date: _june(10),
    title: 'Mascota programática',
    description: 'La mascota ahora se dibuja con CustomPainter.'
        ' 29 emociones, sin assets, transiciones suaves entre emociones.',
    type: UpdateType.feature,
    version: '1.4.0',
  ),
  UpdateEntry(
    date: _june(8),
    title: 'Actualizaciones y novedades',
    description: 'Nueva pantalla en la barra inferior que muestra'
        ' el historial de cambios y novedades de la app.',
    type: UpdateType.feature,
    version: '1.4.0',
  ),
  UpdateEntry(
    date: _june(5),
    title: 'Mercado Pago integrado',
    description: 'Pagos directos con Mercado Pago para paquetes de gemas y bundles.'
        ' También disponible el pago por WhatsApp.',
    type: UpdateType.feature,
    version: '1.3.0',
  ),
  UpdateEntry(
    date: _may(30),
    title: 'Protector de racha mejorado',
    description: 'Límite máximo de 2 protectores. Al alcanzarlo,'
        ' se muestran offertas de potenciadores en su lugar.',
    version: '1.2.1',
  ),
  UpdateEntry(
    date: _may(25),
    title: 'Potenciadores de lección',
    description: 'Nuevos objetos: Boost de XP (2x), Multiplicador de gemas (2x en cofres),'
        ' Boost de suerte (2x probabilidades). Se compran y activan desde la tienda.',
    type: UpdateType.feature,
    version: '1.2.0',
  ),
  UpdateEntry(
    date: _may(15),
    title: 'Corrección de pruebas unitarias',
    description: 'Se corrigieron 7 pruebas fallidas. Ahora todas las pruebas'
        ' pasan correctamente (419 tests). 0 issues de análisis.',
    type: UpdateType.fix,
    version: '1.1.3',
  ),
  UpdateEntry(
    date: _april(20),
    title: 'Cofres de racha y lección',
    description: 'Nuevo sistema de cofres: cofre diario por racha,'
        ' cofre de lección cada 3/5/6/10 lecciones completadas.',
    type: UpdateType.feature,
    version: '1.1.0',
  ),
  UpdateEntry(
    date: _april(10),
    title: 'Misiones diarias',
    description: 'Sistema de misiones diarias con recompensas en gemas y experiencia.',
    type: UpdateType.feature,
    version: '1.0.2',
  ),
  UpdateEntry(
    date: _march(28),
    title: 'Primera versión',
    description: 'Lanzamiento inicial con lecciones interactivas, racha diaria,'
        ' gemas, tienda y perfil de usuario.',
    type: UpdateType.feature,
    version: '1.0.0',
  ),
];

DateTime _march(int day) => DateTime(2026, 3, day);
DateTime _april(int day) => DateTime(2026, 4, day);
DateTime _may(int day) => DateTime(2026, 5, day);
DateTime _june(int day) => DateTime(2026, 6, day);
