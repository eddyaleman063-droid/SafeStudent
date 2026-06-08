import 'dart:math';
import '../models/learning/challenge.dart';
import '../models/learning/lesson_type.dart';

class QuestionBank {
  static final QuestionBank instance = QuestionBank._();
  QuestionBank._();
  final _random = Random();

  List<Challenge> getQuestionsForLesson(String stageId, String lessonId, {int count = 5}) {
    final pool = _topicPools[lessonId] ?? _topicPools['default'] ?? [];
    final shuffled = List<Challenge>.from(pool)..shuffle(_random);
    return shuffled.take(min(count, shuffled.length)).toList();
  }

  Challenge randomForType(LessonType type) {
    final pool = _questionsByType[type] ?? _questionsByType[LessonType.multipleChoice]!;
    return pool[_random.nextInt(pool.length)];
  }

  static final _questionsByType = <LessonType, List<Challenge>>{
    LessonType.trueFalse: [
      const Challenge(id: 'tf_1', question: 'Una contraseña segura debe tener al menos 8 caracteres.', type: LessonType.trueFalse, options: ['Verdadero', 'Falso'], correctIndex: 0, explanation: 'Las contraseñas seguras tienen al menos 8 caracteres, combinando letras, números y símbolos.'),
      const Challenge(id: 'tf_2', question: 'El phishing solo ocurre por correo electrónico.', type: LessonType.trueFalse, options: ['Verdadero', 'Falso'], correctIndex: 1, explanation: 'El phishing puede ocurrir por correo, SMS, redes sociales, llamadas e incluso códigos QR.'),
      const Challenge(id: 'tf_3', question: 'Usar la misma contraseña en varios sitios es seguro si es fuerte.', type: LessonType.trueFalse, options: ['Verdadero', 'Falso'], correctIndex: 1, explanation: 'Cada servicio debe tener una contraseña única. Si un sitio es hackeado, todas tus cuentas quedarían expuestas.'),
      const Challenge(id: 'tf_4', question: 'El modo incógnito te hace invisible en internet.', type: LessonType.trueFalse, options: ['Verdadero', 'Falso'], correctIndex: 1, explanation: 'El modo incógnito solo evita que el historial se guarde en tu dispositivo. Tu ISP y los sitios web aún pueden rastrearte.'),
      const Challenge(id: 'tf_5', question: 'Las actualizaciones de software ayudan a proteger tu dispositivo.', type: LessonType.trueFalse, options: ['Verdadero', 'Falso'], correctIndex: 0, explanation: 'Las actualizaciones corrigen vulnerabilidades de seguridad conocidas. Mantener tu software actualizado es una de las mejores defensas.'),
      const Challenge(id: 'tf_6', question: 'Un enlace que comienza con "https://" es siempre seguro.', type: LessonType.trueFalse, options: ['Verdadero', 'Falso'], correctIndex: 1, explanation: 'HTTPS indica que la conexión está cifrada, pero no garantiza que el sitio sea legítimo. Los sitios de phishing también pueden tener HTTPS.'),
      const Challenge(id: 'tf_7', question: 'Compartir tu ubicación en tiempo real en redes sociales es seguro.', type: LessonType.trueFalse, options: ['Verdadero', 'Falso'], correctIndex: 1, explanation: 'Compartir tu ubicación en tiempo real informa a otros dónde estás. Es mejor publicar después de irte.'),
      const Challenge(id: 'tf_8', question: 'El 2FA (doble factor) añade una capa extra de seguridad.', type: LessonType.trueFalse, options: ['Verdadero', 'Falso'], correctIndex: 0, explanation: '2FA requiere dos formas de verificación, haciendo mucho más difícil que alguien acceda a tu cuenta incluso con tu contraseña.'),
    ],
    LessonType.multipleChoice: [
      const Challenge(id: 'mc_1', question: '¿Qué es un gestor de contraseñas?', type: LessonType.multipleChoice, options: ['Un programa que crea y guarda contraseñas seguras', 'Un antivirus', 'Un navegador web', 'Un tipo de firewall'], correctIndex: 0, explanation: 'Un gestor de contraseñas almacena todas tus contraseñas cifradas. Solo necesitas recordar una contraseña maestra.'),
      const Challenge(id: 'mc_2', question: '¿Cuál es la mejor manera de proteger tus datos en un WiFi público?', type: LessonType.multipleChoice, options: ['Usar una VPN', 'Navegar en modo incógnito', 'Desconectar el antivirus', 'Compartir tu contraseña'], correctIndex: 0, explanation: 'Una VPN cifra tu conexión, protegiendo tus datos en redes WiFi públicas donde otros podrían interceptarlos.'),
      const Challenge(id: 'mc_3', question: '¿Qué es el "ransomware"?', type: LessonType.multipleChoice, options: ['Un software que secuestra tus datos y pide rescate', 'Un tipo de firewall', 'Un gestor de contraseñas', 'Un navegador seguro'], correctIndex: 0, explanation: 'El ransomware cifra tus archivos y exige un pago para liberarlos. La mejor defensa es tener backups actualizados.'),
      const Challenge(id: 'mc_4', question: '¿Qué significa "phishing"?', type: LessonType.multipleChoice, options: ['Un ataque que suplanta a una entidad confiable para robar datos', 'Un tipo de virus', 'Un firewall', 'Un gestor de contraseñas'], correctIndex: 0, explanation: 'El phishing es una técnica de ingeniería social donde los atacantes se hacen pasar por entidades legítimas para engañarte.'),
      const Challenge(id: 'mc_5', question: '¿Con qué frecuencia deberías actualizar tus contraseñas?', type: LessonType.multipleChoice, options: ['Cuando haya indicios de violación de seguridad', 'Cada semana', 'Cada mes', 'Nunca'], correctIndex: 0, explanation: 'Cambiar contraseñas sin motivo puede llevar a contraseñas más débiles. Cámbialas solo cuando haya sospecha de violación.'),
      const Challenge(id: 'mc_6', question: '¿Qué es un "deepfake"?', type: LessonType.multipleChoice, options: ['Un video o audio generado por IA que parece real', 'Un tipo de virus', 'Un firewall', 'Una contraseña segura'], correctIndex: 0, explanation: 'Los deepfakes usan inteligencia artificial para crear contenido falso muy realista. Siempre verifica la fuente.'),
      const Challenge(id: 'mc_7', question: '¿Qué debes hacer si recibes un correo sospechoso de tu banco?', type: LessonType.multipleChoice, options: ['No hacer clic y reportarlo al banco', 'Hacer clic para verificar', 'Responder pidiendo más información', 'Reenviarlo a tus contactos'], correctIndex: 0, explanation: 'Nunca hagas clic en enlaces de correos no solicitados. Contacta a tu banco directamente por canales oficiales.'),
      const Challenge(id: 'mc_8', question: '¿Qué es la autenticación biométrica?', type: LessonType.multipleChoice, options: ['Usar huellas dactilares o reconocimiento facial', 'Una contraseña de texto', 'Un código PIN', 'Una pregunta de seguridad'], correctIndex: 0, explanation: 'La autenticación biométrica usa características físicas únicas como huellas o rostro para verificar tu identidad.'),
    ],
    LessonType.detectRisk: [
      const Challenge(id: 'dr_1', question: 'Identifica la situación de mayor riesgo:', type: LessonType.detectRisk, options: ['Conectarte a un WiFi abierto en un aeropuerto', 'Usar datos móviles en el metro', 'Usar WiFi de tu casa', 'Conectarte con cable Ethernet'], correctIndex: 0, explanation: 'Las redes WiFi abiertas en lugares públicos son vulnerables a ataques "man-in-the-middle". Usa una VPN si es necesario.'),
      const Challenge(id: 'dr_2', question: '¿Cuál de estas acciones es más riesgosa?', type: LessonType.detectRisk, options: ['Descargar un programa de una web no oficial', 'Actualizar tu sistema operativo', 'Usar un gestor de contraseñas', 'Activar 2FA'], correctIndex: 0, explanation: 'Descargar software de fuentes no oficiales puede instalar malware. Siempre usa tiendas oficiales o el sitio del desarrollador.'),
      const Challenge(id: 'dr_3', question: '¿Qué situación indica un posible ataque de phishing?', type: LessonType.detectRisk, options: ['Un correo que te urge a hacer clic en un enlace', 'Un newsletter semanal', 'Una notificación de una app', 'Un mensaje de un amigo conocido'], correctIndex: 0, explanation: 'Los atacantes crean urgencia falsa para que actúes sin pensar. "Tu cuenta será suspendida" es una táctica común.'),
      const Challenge(id: 'dr_4', question: '¿Cuál es la señal más clara de un enlace sospechoso?', type: LessonType.detectRisk, options: ['El dominio está mal escrito (ejem: g00gle.com)', 'El enlace usa HTTPS', 'El enlace es corto', 'El enlace tiene letras mayúsculas'], correctIndex: 0, explanation: 'Los atacantes usan dominios similares a los reales con errores sutiles. Siempre verifica la URL antes de hacer clic.'),
    ],
    LessonType.miniCase: [
      const Challenge(id: 'case_1', question: 'María recibe un mensaje de texto que dice ser de Netflix: "Tu cuenta será suspendida. Verifica aquí: n3tflix.com/verificar". ¿Qué debe hacer?', type: LessonType.miniCase, options: ['Ignorar el mensaje y reportarlo', 'Hacer clic en el enlace para verificar', 'Responder al mensaje', 'Reenviarlo a sus contactos'], correctIndex: 0, explanation: 'Netflix y servicios legítimos no piden datos por SMS. La URL n3tflix.com es un dominio falso. María debe reportar el mensaje.'),
      const Challenge(id: 'case_2', question: 'Carlos recibe una llamada de "soporte técnico de Microsoft" diciendo que su computadora tiene un virus. ¿Qué debe hacer?', type: LessonType.miniCase, options: ['Colgar y reportar la llamada', 'Seguir las instrucciones', 'Dar acceso remoto', 'Pagar por el servicio'], correctIndex: 0, explanation: 'Microsoft no realiza llamadas de soporte no solicitadas. Es una estafa clásica de soporte técnico. Cuelga y reporta.'),
      const Challenge(id: 'case_3', question: 'Ana encuentra un USB en la calle con la etiqueta "Confidencial". ¿Qué debe hacer?', type: LessonType.miniCase, options: ['No conectarlo y destruirlo', 'Conectarlo para ver el contenido', 'Llevarlo a la policía', 'Venderlo'], correctIndex: 0, explanation: 'Los USBs encontrados pueden contener malware. Nunca conectes dispositivos de almacenamiento desconocidos.'),
      const Challenge(id: 'case_4', question: 'Pedro recibe un mensaje de un "amigo" en redes sociales pidiendo dinero urgente. ¿Qué debe hacer?', type: LessonType.miniCase, options: ['Llamar a su amigo por otro medio para verificar', 'Transferir el dinero', 'Pedir más detalles', 'Compartir la publicación'], correctIndex: 0, explanation: 'Las cuentas pueden ser hackeadas o suplantadas. Siempre verifica por un medio diferente antes de actuar.'),
    ],
    LessonType.whatWouldYouDo: [
      const Challenge(id: 'wwyd_1', question: 'Tu banco te llama diciendo que detectaron actividad sospechosa y necesitan tu contraseña para verificar. ¿Qué haces?', type: LessonType.whatWouldYouDo, options: ['Cuelgas y llamas al número oficial del banco', 'Das tu contraseña para que verifiquen', 'Les pides que te envíen un correo', 'Les das tu número de cuenta'], correctIndex: 0, explanation: 'Los bancos nunca piden contraseñas por teléfono. Siempre cuelga y contacta al banco por canales oficiales.'),
      const Challenge(id: 'wwyd_2', question: 'Ves un anuncio en Instagram de una laptop con 90% de descuento. ¿Qué haces?', type: LessonType.whatWouldYouDo, options: ['Investigar la tienda antes de comprar', 'Comprar inmediatamente', 'Compartir el anuncio', 'Dar clic sin verificar'], correctIndex: 0, explanation: 'Las ofertas demasiado buenas para ser verdad suelen ser estafas. Verifica la reputación de la tienda antes de comprar.'),
      const Challenge(id: 'wwyd_3', question: 'Un compañero de trabajo te envía un archivo llamado "bonos.xlsx" por WhatsApp. ¿Qué haces?', type: LessonType.whatWouldYouDo, options: ['Verificar con él si realmente lo envió', 'Abrirlo para ver los bonos', 'Reenviarlo al grupo', 'Guardarlo en la nube'], correctIndex: 0, explanation: 'Los archivos inesperados pueden contener malware. Pregunta al remitente si realmente lo envió antes de abrirlo.'),
    ],
    LessonType.completePhrase: [
      const Challenge(id: 'cp_1', question: 'Completa la frase: "Para proteger tu privacidad en redes sociales, debes revisar los ___ de privacidad."', type: LessonType.completePhrase, options: ['Ajustes', 'Amigos', 'Mensajes', 'Fotos'], correctIndex: 0, explanation: 'Los ajustes de privacidad controlan quién puede ver tu información personal en cada plataforma.'),
      const Challenge(id: 'cp_2', question: 'Completa: "Una VPN ___ tu conexión a internet para proteger tus datos."', type: LessonType.completePhrase, options: ['Cifra', 'Ralentiza', 'Desconecta', 'Comparte'], correctIndex: 0, explanation: 'Una VPN (Red Privada Virtual) cifra todo tu tráfico de internet, haciéndolo ilegible para terceros.'),
      const Challenge(id: 'cp_3', question: 'Completa: "El ___ es un ataque donde los criminales se hacen pasar por una entidad de confianza."', type: LessonType.completePhrase, options: ['Phishing', 'Spam', 'Virus', 'Firewall'], correctIndex: 0, explanation: 'El phishing es una técnica de ingeniería social donde los atacantes suplantan identidades para engañarte.'),
    ],
  };

  Map<String, List<Challenge>> get _topicPools {
    return {
      'default': [
        ..._questionsByType[LessonType.multipleChoice]!,
        ..._questionsByType[LessonType.trueFalse]!,
        ..._questionsByType[LessonType.detectRisk]!,
      ],
      's1_l1': [
        const Challenge(id: 's1_l1_q1', question: '¿Qué es la seguridad digital?', type: LessonType.multipleChoice, options: ['Proteger tu información en línea', 'Solo usar antivirus', 'No usar internet', 'Tener contraseñas largas'], correctIndex: 0, explanation: 'La seguridad digital son las prácticas para proteger tu información, dispositivos y privacidad en el entorno digital.'),
        const Challenge(id: 's1_l1_q2', question: '¿Cuál es el primer paso para protegerte en línea?', type: LessonType.multipleChoice, options: ['Conocer los riesgos', 'Comprar un antivirus', 'Crear redes sociales', 'Compartir tu ubicación'], correctIndex: 0, explanation: 'Conocer los riesgos es fundamental para poder protegerte. La educación es la base de la seguridad digital.'),
      ],
      's2_l1': [
        const Challenge(id: 's2_l1_q1', question: '¿Qué es el phishing?', type: LessonType.multipleChoice, options: ['Una técnica de suplantación para robar datos', 'Un tipo de antivirus', 'Un navegador web', 'Una red social'], correctIndex: 0, explanation: 'El phishing es una técnica donde los atacantes se hacen pasar por entidades legítimas para engañarte y robar información.'),
        const Challenge(id: 's2_l1_q2', question: '¿Por qué es peligroso el phishing?', type: LessonType.multipleChoice, options: ['Porque puede robar contraseñas y datos bancarios', 'Porque ralentiza el internet', 'Porque ocupa espacio', 'Porque borra archivos'], correctIndex: 0, explanation: 'El phishing busca obtener información sensible como contraseñas, números de tarjeta y datos personales.'),
      ],
      's3_l1': [
        const Challenge(id: 's3_l1_q1', question: '¿Qué hace que una contraseña sea segura?', type: LessonType.multipleChoice, options: ['Longitud, variedad de caracteres y ser única', 'Solo números', 'El nombre de tu mascota', 'Tu fecha de nacimiento'], correctIndex: 0, explanation: 'Una contraseña segura tiene al menos 8 caracteres, combina mayúsculas, minúsculas, números y símbolos, y es única.'),
        const Challenge(id: 's3_l1_q2', question: '¿Cuál es la peor práctica al crear contraseñas?', type: LessonType.multipleChoice, options: ['Usar información personal como fechas o nombres', 'Usar caracteres especiales', 'Usar 12 caracteres', 'Usar un gestor de contraseñas'], correctIndex: 0, explanation: 'La información personal como fechas de nacimiento o nombres de familiares es fácil de adivinar o encontrar en redes sociales.'),
      ],
      's4_l1': [
        const Challenge(id: 's4_l1_q1', question: '¿Qué información NO deberías compartir en redes sociales?', type: LessonType.multipleChoice, options: ['Tu ubicación exacta en tiempo real', 'Tu comida favorita', 'Tu película preferida', 'El clima de tu ciudad'], correctIndex: 0, explanation: 'Compartir tu ubicación en tiempo real informa a otros dónde estás. Es mejor esperar a irte para publicar.'),
        const Challenge(id: 's4_l1_q2', question: '¿Cómo proteger tu privacidad en redes?', type: LessonType.multipleChoice, options: ['Revisando quién puede ver tus publicaciones', 'Compartiendo todo como público', 'Siguiendo a todos', 'Publicando 10 veces al día'], correctIndex: 0, explanation: 'Revisar la configuración de privacidad te permite controlar quién ve tu información.'),
      ],
      's6_l1': [
        const Challenge(id: 's6_l1_q1', question: '¿Qué son los datos personales?', type: LessonType.multipleChoice, options: ['Información que te identifica como nombre, dirección, DNI', 'Solo tu nombre', 'Tus fotos de mascotas', 'Las apps que usas'], correctIndex: 0, explanation: 'Los datos personales incluyen nombre, dirección, correo, teléfono, DNI, datos bancarios y cualquier información que pueda identificarte.'),
        const Challenge(id: 's6_l1_q2', question: '¿Por qué es importante proteger tus datos?', type: LessonType.multipleChoice, options: ['Para evitar robo de identidad y fraudes', 'Porque ocupan espacio', 'Para compartirlos con todos', 'No es importante'], correctIndex: 0, explanation: 'Tus datos personales pueden ser usados para robarte la identidad, cometer fraudes o chantajearte.'),
      ],
      's7_l1': [
        const Challenge(id: 's7_l1_q1', question: '¿Qué es el malware?', type: LessonType.multipleChoice, options: ['Software malicioso diseñado para dañar tu dispositivo', 'Un tipo de navegador', 'Una red social', 'Un gestor de contraseñas'], correctIndex: 0, explanation: 'Malware es cualquier software diseñado para causar daño, robar información o tomar control de tu dispositivo.'),
        const Challenge(id: 's7_l1_q2', question: '¿Cómo se propaga el malware comúnmente?', type: LessonType.multipleChoice, options: ['A través de descargas de sitios no confiables', 'Solo por Bluetooth', 'Por el clima', 'Usando WiFi'], correctIndex: 0, explanation: 'El malware a menudo se propaga a través de descargas de sitios no oficiales, enlaces en correos phishing o USBs infectados.'),
      ],
    };
  }

  Challenge? getById(String id) {
    for (final list in _questionsByType.values) {
      for (final c in list) {
        if (c.id == id) return c;
      }
    }
    for (final list in _topicPools.values) {
      for (final c in list) {
        if (c.id == id) return c;
      }
    }
    return null;
  }

  static int min(int a, int b) => a < b ? a : b;
}
