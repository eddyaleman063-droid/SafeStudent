import 'dart:math';
import '../models/chat_message.dart';
import 'ai_service.dart';

class LocalFallbackService implements AiService {
  final Random _random = Random();

  @override
  bool get isAvailable => true;

  @override
  void dispose() {}

  @override
  Future<String> generate(List<ChatMessage> messages, {int retryCount = 0}) async {
    final lastUser = messages.where((m) => m.role == ChatRole.user).lastOrNull;
    return _generateLocalResponse(lastUser?.text ?? '');
  }

  @override
  Stream<String> generateStream(List<ChatMessage> messages, {int retryCount = 0}) async* {
    final fullResponse = await generate(messages);
    for (int i = 0; i < fullResponse.length; i++) {
      yield fullResponse[i];
      await Future.delayed(const Duration(milliseconds: 10));
    }
  }

  String _generateLocalResponse(String userMessage) {
    final msg = _removeDiacritics(userMessage.toLowerCase());

    if (msg.contains('hola') || msg.contains('buenos') || msg.contains('buenas') ||
        msg.contains('hey') || msg.contains('que tal') || msg.contains('que hay') ||
        msg.contains('saludos') || msg.contains('alo') || msg.contains('ola') ||
        msg.contains('buen dia') || msg.contains('buena')) {
      return [
        '¡Hola! Soy Sage, tu tutor de ciberseguridad. ¿En qué puedo ayudarte hoy? Puedo explicarte sobre phishing, contraseñas seguras, privacidad en redes, malware, y mucho más. ¿Qué te gustaría aprender?',
        '¡Hey! Me alegra verte por aquí. ¿Listo para aprender algo nuevo sobre seguridad digital? Puedo ayudarte con cualquier duda que tengas.',
        '¡Buenas! Soy Sage, y estoy aquí para que aprendamos juntos sobre cómo protegerte en internet. ¿Por dónde quieres empezar?',
      ][_random.nextInt(3)];
    }

    if (msg.contains('gracias') || msg.contains('thank') || msg.contains('grax') ||
        msg.contains('graci') || msg.contains('te lo agradezco') || msg.contains('muy amable') ||
        msg.contains('de mucha ayuda') || msg.contains('mil gracias')) {
      return [
        '¡De nada! Para eso estoy aquí. Si en cualquier momento tienes otra duda sobre seguridad digital, no dudes en preguntar.',
        'Me alegra poder ayudar. Recuerda que la seguridad digital es un hábito que se construye día a día. ¿Hay algo más que quieras aprender?',
        '¡Un placer! Siempre que quieras saber más sobre cómo protegerte en internet, aquí estoy.',
      ][_random.nextInt(3)];
    }

    if (msg.contains('adios') || msg.contains('chao') || msg.contains('nos vemos') ||
        msg.contains('hasta luego') || msg.contains('bye') || msg.contains('hasta pronto') ||
        msg.contains('me voy') || msg.contains('luego') || msg.contains('cuidate') ||
        msg.contains('cuidese')) {
      return [
        '¡Hasta luego! Recuerda aplicar lo que aprendiste para mantenerte seguro en internet. Cuídate.',
        'Nos vemos pronto. Sigue protegiéndote y recuerda: cada clic cuenta. ¡Cuídate!',
        'Hasta la próxima. Si te surge cualquier duda sobre seguridad digital, aquí estaré para ayudarte.',
      ][_random.nextInt(3)];
    }

    if (msg.contains('no entiendo') || msg.contains('no comprendo') || msg.contains('no entendi') ||
        msg.contains('no comprendi') || msg.contains('explicate') || msg.contains('explicame') ||
        msg.contains('no me quedo claro') || msg.contains('mas simple') || msg.contains('mas claro') ||
        msg.contains('no me queda claro') || msg.contains('repite') || msg.contains('otra vez') ||
        msg.contains('dilo de nuevo') || msg.contains('no capto') || msg.contains('no pillo')) {
      return [
        'Claro, vamos a verlo de otra forma. Piensa en la ciberseguridad como las cerraduras de tu casa: cada medida de seguridad es una cerradura más que pones para proteger lo que más te importa. ¿Qué parte te gustaría que te explique con más calma?',
        'No te preocupes, estas cosas pueden ser confusas al principio. Vamos paso a paso. ¿Qué fue lo que no quedó claro? Podemos empezar desde el principio o enfocarnos en la parte que más te cueste.',
        'Entiendo, hay conceptos que pueden sonar complicados. Vamos a simplificarlo. La idea principal es que cada cosa que haces en internet tiene riesgos, y aprender a identificarlos es como aprender las reglas de seguridad vial antes de conducir. ¿Te ayuda esta explicación o prefieres que lo veamos de otra manera?',
      ][_random.nextInt(3)];
    }

    if (msg.contains('que haces') || msg.contains('como estas') || msg.contains('como andas') ||
        msg.contains('todo bien') || msg.contains('bien y tu') || msg.contains('que cuentas') ||
        msg.contains('como va') || msg.contains('en que andas') || msg.contains('que hay de nuevo')) {
      return _defaultResponses[_random.nextInt(_defaultResponses.length)];
    }

    if (msg.contains('phishing') || msg.contains('phising') || 
        msg.contains('correo falso') || msg.contains('engano') ||
        msg.contains('suplantacion') || msg.contains('suplantar')) {
      return _topicResponses['phishing']![_random.nextInt(_topicResponses['phishing']!.length)];
    }

    if (msg.contains('contrasena') || msg.contains('password') ||
        msg.contains('clave') || msg.contains('pin') ||
        msg.contains('2fa') || msg.contains('dos factores') ||
        msg.contains('doble factor') || msg.contains('autenticacion')) {
      return _topicResponses['passwords']![_random.nextInt(_topicResponses['passwords']!.length)];
    }

    if (msg.contains('navegacion') || msg.contains('navegar') ||
        msg.contains('internet') || msg.contains('sitio web') ||
        msg.contains('pagina web') || msg.contains('https') ||
        msg.contains('certificado') || msg.contains('peligroso') ||
        (msg.contains('descargar') && !msg.contains('malware'))) {
      return _topicResponses['safe browsing']![_random.nextInt(_topicResponses['safe browsing']!.length)];
    }

    if (msg.contains('red social') || msg.contains('instagram') ||
        msg.contains('facebook') || msg.contains('tiktok') ||
        msg.contains('twitter') || msg.contains('x ') ||
        msg.contains('whatsapp') || msg.contains('privacidad') ||
        msg.contains('publicar') || msg.contains('etiqueta') ||
        msg.contains('perfil')) {
      return _topicResponses['social media privacy']![_random.nextInt(_topicResponses['social media privacy']!.length)];
    }

    if (msg.contains('wifi') || msg.contains('wi-fi') ||
        msg.contains('router') || msg.contains('red inalambrica') ||
        msg.contains('vpn') || msg.contains('red publica') ||
        msg.contains('cafe internet') || msg.contains('conectar')) {
      return _topicResponses['wifi security']![_random.nextInt(_topicResponses['wifi security']!.length)];
    }

    if (msg.contains('virus') || msg.contains('malware') ||
        msg.contains('troyano') || msg.contains('ransomware') ||
        msg.contains('spyware') || msg.contains('antivirus') ||
        msg.contains('infectado') || msg.contains('infeccion')) {
      return _topicResponses['malware']![_random.nextInt(_topicResponses['malware']!.length)];
    }

    if (msg.contains('identidad') || msg.contains('robo de datos') ||
        msg.contains('robar identidad') || msg.contains('suplantacion de identidad') ||
        msg.contains('dni') || msg.contains('documento') ||
        msg.contains('tarjeta') || msg.contains('credito')) {
      return _topicResponses['identity theft']![_random.nextInt(_topicResponses['identity theft']!.length)];
    }

    if (msg.contains('estafa') || msg.contains('scam') ||
        msg.contains('fraude') || msg.contains('dinero facil') ||
        msg.contains('premio') || msg.contains('loteria') ||
        msg.contains('falso') || msg.contains('enganar')) {
      return _topicResponses['online scams']![_random.nextInt(_topicResponses['online scams']!.length)];
    }

    if (msg.contains('huella') || msg.contains('rastro') ||
        msg.contains('footprint') || msg.contains('permanente') ||
        msg.contains('buscar') || msg.contains('googlear') ||
        (msg.contains('buscador') && msg.contains('privado'))) {
      return _topicResponses['digital footprint']![_random.nextInt(_topicResponses['digital footprint']!.length)];
    }

    if (msg.contains('acoso') || msg.contains('bullying') ||
        msg.contains('ciberacoso') || msg.contains('cyberbullying') ||
        msg.contains('humillar') || msg.contains('amenaza') ||
        msg.contains('insulto') || msg.contains('molestar')) {
      return _topicResponses['cyberbullying']![_random.nextInt(_topicResponses['cyberbullying']!.length)];
    }

    return _defaultResponses[_random.nextInt(_defaultResponses.length)];
  }

  String _removeDiacritics(String input) {
    const diacritics = {
      'á': 'a', 'é': 'e', 'í': 'i', 'ó': 'o', 'ú': 'u',
      'ü': 'u', 'ñ': 'n',
      'Á': 'a', 'É': 'e', 'Í': 'i', 'Ó': 'o', 'Ú': 'u',
      'Ü': 'u', 'Ñ': 'n',
    };
    var result = input;
    diacritics.forEach((original, replacement) {
      result = result.replaceAll(original, replacement);
    });
    return result;
  }

  static final Map<String, List<String>> _topicResponses = {
    'phishing': [
      'El phishing es cuando los cibercriminales se hacen pasar por empresas o personas conocidas para robarte informacion como contrasenas o datos de tu tarjeta. Generalmente lo hacen a traves de correos electronicos, mensajes de texto o llamadas falsas. Como protegerte? Nunca hagas clic en enlaces de correos que no esperabas, verifica siempre la direccion de correo del remitente, y las empresas legitimas nunca te pediran tu contrasena por mensaje. Quieres saber mas sobre algun aspecto del phishing?',
      'Muy buena pregunta! El phishing es uno de los ataques mas comunes y peligrosos en internet. Imagina esto: recibes un correo que parece de tu banco, diciendo que alguien accedio a tu cuenta y pidiendo que hagas clic en un enlace para verificar tus datos. Pero ese enlace lleva a un sitio web falso, identico al real, que roba tu contrasena. Tip clave: mira siempre la URL - los sitios falsos suelen tener errores de escritura o dominios extranos. Tienes dudas sobre un correo o mensaje en especifico?',
      'El phishing es el arte del engano digital. Los atacantes usan ingenieria social para manipularte. Algunas senales de alerta: saludos genericos (Estimado cliente en vez de tu nombre), errores de ortografia y gramatica, enlaces acortados, o un sentido de urgencia (Tu cuenta se cerrara en 24 horas!). Lo mas importante: si algo te parece sospechoso, no respondas, no hagas clic, y contacta a la empresa directamente a traves de sus canales oficiales. Te gustaria practicar como identificar un correo de phishing?'
    ],
    'passwords': [
      'Tus contrasenas son la llave de tu vida digital, asi que hay que cuidarlas bien. Que hace a una contrasena segura? Debe ser larga (12 caracteres o mas), mezclar letras mayusculas, minusculas, numeros y simbolos, y NO usar informacion personal como tu nombre, fecha de nacimiento o 123456. Tip extra: usa un administrador de contrasenas para crear y guardar contrasenas unicas para cada cuenta. Nunca reutilices contrasenas! Quieres saber mas sobre administradores de contrasenas?',
      'Excelente tema! Aqui va un secreto: la longitud es mas importante que la complejidad. Una frase de contrasena como ElGatoDormilon@2024 es mucho mas segura que P@ssw0rd y mas facil de recordar. Otras reglas de oro: 1) Una contrasena diferente por cada sitio, 2) Nunca las compartas con nadie, 3) Activa la autenticacion de dos factores (2FA) siempre que puedas. Y recuerda: si recibes un correo diciendo que tu contrasena esta en riesgo, cambiala INMEDIATAMENTE. Sabes que es la autenticacion de dos factores?',
      'Las contrasenas debiles son como dejar la puerta de tu casa abierta. Los hackers usan programas que prueban millones de combinaciones por segundo. Las peores contrasenas del mundo siguen siendo: 123456, password, qwerty, 111111. No uses esas. Lo mejor que puedes hacer hoy: ve a la configuracion de tu correo y redes sociales, y activa la verificacion en dos pasos. Esa segunda capa de proteccion hace que sea muchisimo mas dificil que entren a tu cuenta. Quieres que te explique como funciona la verificacion en dos pasos?'
    ],
    'safe browsing': [
      'Navegar seguro es mas facil de lo que piensas. Aqui tienes mis consejos top: 1) Usa siempre HTTPS - mira que en la URL haya un candado, 2) Manten tu navegador y sistema operativo actualizados (las actualizaciones arreglan agujeros de seguridad), 3) Ten cuidado con lo que descargas - solo de sitios oficiales y de confianza, 4) Usa un bloqueador de anuncios para evitar anuncios maliciosos. Y recuerda: si algo en un sitio web te parece raro, confia en tu instinto y cierra la pagina. Hay algo especifico que quieras saber?',
      'La navegacion segura es fundamental! Aqui van tips practicos: Primero, aprende a leer URLs. El https:// significa que la conexion esta cifrada - la s es de seguro. Si solo dice http:// (sin la s), NO ingreses datos sensibles ahi. Segundo: las ventanas emergentes (pop-ups) que dicen Tu computadora tiene un virus! son casi siempre estafas. No hagas clic en ellas. Tercero: considera usar DNS seguro o una VPN cuando estes en redes publicas. Sabes que es una VPN y como te protege?',
      'Navegar por internet es como caminar por una ciudad - hay zonas seguras y zonas peligrosas. Como identificar las seguras? - Dominio que conoces y de confianza - Candado en la barra de direcciones - Diseno profesional, sin errores extranos - Sin anuncios excesivos o enganosos Las zonas rojas: - Sitios que prometen cosas demasiado buenas para ser verdad (peliculas recientes gratis, programas piratas, apuestas) - Anuncios que parpadean y dicen que ganaste un premio - URLs con errores de escritura (faceb0ok.com, netfflix.com) Te ha parecido sospechoso algun sitio ultimamente?'
    ],
    'social media privacy': [
      'Tu privacidad en redes sociales es tu tesoro digital. Aqui tienes como protegerla: 1) Revisa y ajusta la configuracion de privacidad regularmente - las plataformas cambian sus opciones, 2) Piensa DOS VECES antes de publicar: quieres que ese contenido sea publico para siempre? 3) No aceptes solicitudes de amistad de personas que no conoces, 4) Ten cuidado con los cuestionarios y juegos en redes que piden permisos excesivos. Sabias que lo que publicas hoy puede afectarte en una entrevista de trabajo en el futuro?',
      'Muy importante! Las redes sociales son fantasticas para conectar, pero hay que usarlas con cabeza. Consejo #1: Controla quien ve tus publicaciones. En casi todas las apps puedes poner tus publicaciones en solo amigos o mas privadas. Consejo #2: No compartas NUNCA tu ubicacion en tiempo real ni publiques fotos de tu colegio, casa o rutina diaria que puedan ser usadas para encontrarte. Consejo #3: La informacion que ponen en tu perfil (fecha de nacimiento, telefono, email) no deberia ser publica. Has revisado tu configuracion de privacidad ultimamente?',
      'Las empresas y los hackers pueden aprender MUCHO de ti por tus redes sociales. Cada me gusta, cada publicacion, cada ubicacion compartida crea un perfil detallado de quien eres, que te gusta y donde estas. Para protegerte: - Activa la autenticacion de dos factores en todas tus cuentas de redes - Usa contrasenas fuertes y diferentes para cada red - Piensa: Esto lo diria en voz alta delante de toda mi familia y mi colegio? Si la respuesta es no, mejor no lo publiques. - Desactiva los servicios de ubicacion para las apps que no los necesitan. Te gustaria saber como ver que datos tienen las redes sobre ti?'
    ],
    'wifi security': [
      'El WiFi es conveniente, pero puede ser peligroso si no te proteges. Aqui van mis tips: En casa: 1) Cambia la contrasena por defecto de tu router, 2) Usa WPA2 o WPA3 como tipo de seguridad (nunca WEP), 3) Nombra tu red de forma que no diga tu apellido o direccion. En redes publicas (cafeterias, centros comerciales): 1) NO hagas transacciones bancarias ni compras, 2) Considera usar una VPN, 3) Desactiva la conexion automatica a redes abiertas. Sabes que es una VPN?',
      'Excelente pregunta sobre seguridad WiFi! Aqui te explico: Una red WiFi abierta (sin contrasena) es como una conversacion en voz alta en un lugar publico - cualquiera puede escuchar. Los hackers en redes publicas pueden usar herramientas para ver lo que haces en internet, robar tus contrasenas o incluso crear redes falsas con nombres como WiFi Gratis para enganarte. Mis recomendaciones: - En tu casa: actualiza el firmware de tu router regularmente - En publico: asume que alguien esta mirando. Evita entrar a sitios importantes como tu banco - Si usas mucho WiFi publico, investiga sobre VPN - encripta tu conexion. Te gustaria saber mas sobre VPNs?',
      'El WiFi de tu casa es la puerta de entrada a todos tus dispositivos. Si alguien se conecta a tu red sin permiso, puede: - Ver todo lo que haces en internet - Acceder a tus archivos compartidos - Instalar malware en tus dispositivos Para proteger tu red hogarena: 1) Contrasena larga y unica para el WiFi 2) Nombre de red (SSID) que no revele tu identidad 3) Desactiva el WPS si no lo usas 4) Actualiza el router de vez en cuando. Y un tip extra: crea una red WiFi separada para visitantes o dispositivos inteligentes (camaras, bocinas). Asi si algo se ve comprometido, tu red principal sigue segura. Tienes dispositivos inteligentes conectados a tu WiFi?'
    ],
    'malware': [
      'Malware (mal + software) es cualquier programa disenado para danar o robar informacion de tu dispositivo. Hay muchos tipos: virus, troyanos, ransomware, spyware, adware... Como te infectas? Generalmente por: - Archivos adjuntos de correos sospechosos - Descargas de sitios no oficiales - Enlaces peligrosos - Pendrives USB de origen desconocido Como protegerte? 1) Ten un buen antivirus (y mantenlo actualizado) 2) No abras archivos de quien no conozcas 3) Manten tu sistema y apps actualizadas 4) Haz copias de seguridad (backup) regularmente. Quieres saber sobre algun tipo de malware en especifico?',
      'Muy buena pregunta! El malware es como un virus biologico pero para computadoras. Uno de los mas peligrosos hoy es el ransomware - encripta todos tus archivos y te pide un pago (rescate) para devolvertelos. Como prevenirlo: - Haz copias de seguridad CONSTANTEMENTE (en disco externo y/o nube) - No habilites macros de archivos Office que no esperabas - Ten cuidado con los archivos .zip, .exe, .bat de fuentes desconocidas Otro tipo comun es el spyware - programa que espia todo lo que haces y envia tus datos a un hacker. El mejor escudo: sentido comun y software de seguridad. Sabes que hacer si crees que tienes malware?',
      'Todo el mundo deberia saber esto sobre malware: 1) Tu computadora no se infecta sola - siempre hay una accion del usuario (un clic, una descarga) que permite la entrada. 2) Los antivirus gratis a veces SON el malware. Solo descarga software de desarrolladores reconocidos. 3) Los telefonos moviles tambien pueden tener malware - solo descarga apps de las tiendas oficiales (Google Play, App Store). 4) Si ves anuncios extranos apareciendo de la nada, o tu dispositivo va muy lento, o aparecen apps que no instalaste - podrias tener malware. Pasos: actualiza tu antivirus, haz un escaneo completo, y si no se quita, pide ayuda a un profesional. Te ha pasado algo raro con tu dispositivo ultimamente?'
    ],
    'identity theft': [
      'El robo de identidad es cuando alguien usa tus datos personales (nombre, DNI, tarjeta de credito, contrasenas) para hacerse pasar por ti. Pueden: abrir cuentas bancarias, sacar prestamos, hacer compras, incluso cometer delitos en tu nombre. Como te proteges? 1) Nunca compartas tu numero de documento completo, ni contrasenas, ni codigos de verificacion. 2) Revisa tus estados de cuenta bancarios y tarjetas regularmente buscando cargos que no reconozcas. 3) Usa contrasenas fuertes y autenticacion de dos factores. 4) Ten cuidado con donde ingresas tus datos - solo en sitios seguros con HTTPS. Quieres saber mas sobre alguna medida de proteccion?',
      'Tema super importante! El robo de identidad puede arruinar tu vida financiera y tardar anios en arreglarse. Senales de alerta de que algo anda mal: - Recibes facturas de cosas que no compraste - Te niegan credito sin razon aparente - Llaman de cobranzas para deudas que no son tuyas - Notas cambios en tus cuentas que no hiciste tu Si crees que eres victima: 1) Informa INMEDIATAMENTE a tu banco y las autoridades 2) Cambia TODAS tus contrasenas desde un dispositivo seguro 3) Guarda evidencia de todo (correos, mensajes, capturas) La prevencion es la clave. Sabes como los delincuentes roban identidades?',
      'Los ladrones de identidad usan muchas tacticas: Phishing: correos y mensajes que piden tus datos. Data breaches: cuando una empresa es hackeada y tus datos se filtran. Shoulder surfing: alguien mirando por encima de tu hombro cuando ingresas tu PIN. Malware: programas que roban tu informacion. Dumpster diving: revisando tu basura buscando documentos con datos. Como hacerte dificil la vida a los ladrones? - Destruye documentos con datos personales antes de tirarlos - No lleves tu DNI fisico a menos que sea estrictamente necesario - Nunca respondas preguntas de verificacion por telefono si no iniciaste tu la llamada - Monitorea tus cuentas regularmente. Te ha pasado que alguien intento usar tus datos sin permiso?'
    ],
    'online scams': [
      'Las estafas online enganan a miles de personas cada dia. Las mas comunes: 1) Ganaste la loteria/regalo - piden que pagues impuestos para recibir tu premio. 2) Amor en linea: personas que crean perfiles falsos para enamorarte y luego pedirte dinero. 3) Trabajos gana dinero facil y rapido desde casa - son piramides o formas de robar tu dinero. 4) Falsos servicios tecnicos que llaman diciendo que tu computadora tiene virus. Regla de oro: si algo suena demasiado bueno para ser verdad, PROBABLEMENTE es una estafa. Nunca pagues adelantado por premios u oportunidades increibles. Te han llegado mensajes de este tipo?',
      'Conocer las estafas es la mejor defensa! Aqui te cuento las mas modernas: - El estafador del familiar: llaman diciendo que es tu primo/tio/amigo en problemas y necesita dinero urgente (sin poder hablar mucho por telefono). - El falso empleo: te contratan sin entrevista, te piden que pagues materiales de trabajo o que abras una cuenta para transferencias. - Criptomonedas falsas: plataformas que parecen de inversion pero son fraude. - Estafas de compras: en Facebook Marketplace, Instagram, etc. - el vendedor pide pago por adelantado y desaparece. Mi consejo: siempre verifica la identidad de la otra persona. Googlea su nombre, su numero de telefono. Pide videollamada. Si se niega, bandera roja. Conoces a alguien que haya sido estafado en internet?',
      'Las estafas evolucionan, pero siempre siguen el mismo patron: crean URGENCIA o AVARICIA para que actues sin pensar. Tienes 24 horas para reclamar tu herencia. Ultimas plazas para este curso que te hara millonario. Tu paquete esta retenido, paga 50 para liberarlo. Que hacer cuando te llega algo sospechoso: 1) Para. No respondas inmediatamente. 2) Piensa. Tiene sentido? Lo estabas esperando? 3) Verifica. Busca en Google el texto del mensaje + estafa. 4) Consulta con alguien de confianza. Cuentale a un amigo o familiar lo que te llego. Y recuerda: NINGUNA empresa legitima te pedira que pagues con tarjetas de regalo, criptomonedas o transferencias Western Union. Esas son senales GARANTIZADAS de estafa. Te ha pasado que casi caes en alguna?'
    ],
    'digital footprint': [
      'Tu huella digital es TODO lo que haces, publicas y compartes en internet. Publicaciones en redes, comentarios, likes, busquedas que haces, fotos donde te etiquetan, compras online... TODO. Lo mas importante que debes saber: TU HUELLA DIGITAL ES PERMANENTE. Una vez que algo sale a internet, aunque lo borres despues, podria haber sido guardado por alguien. Consecuencias: universidades revisan perfiles sociales, empleadores hacen busquedas de candidatos, incluso relaciones futuras se pueden afectar por cosas que publicaste cuando eras mas joven. Consejo: antes de publicar algo, preguntate: Me gustaria que mi abuela, mi profesor o mi futuro jefe vean esto? Quieres saber como buscar tu propia huella digital?',
      'Concepto fundamental! Tu huella digital tiene dos partes: Activa: lo que TU publicas voluntariamente (fotos, estados, comentarios). Pasiva: lo que otros publican de ti (etiquetas, fotos), y lo que las empresas recolectan sobre ti (tus busquedas, tu ubicacion, cuanto tiempo pasas en cada app). Aqui va algo que te sorprendera: cada vez que usas un buscador gratuito, cada red social gratuita, cada app gratuita - TU ERES EL PRODUCTO. Tu atencion, tus datos, tus gustos... todo se vende a anunciantes. Que puedes hacer? - Usa buscadores que respetan tu privacidad (como DuckDuckGo) - Desactiva el seguimiento de ubicacion cuando no lo necesites - Piensa: Estoy dispuesto a cambiar mi privacidad por este servicio gratuito? Te gustaria saber mas sobre privacidad y datos?',
      'Gestionar tu huella digital es parte de ser un ciudadano digital responsable. Aqui tienes un ejercicio practico para hacer hoy: 1) Busca tu nombre completo (entre comillas) en Google. Ve que aparece. 2) Haz lo mismo en imagenes. 3) Ve a la configuracion de privacidad de cada red social y revisa que es publico. Si encuentras algo que no te gusta: - Puedes pedirle a la persona que lo publico que lo borre - Puedes reportarlo a la plataforma si es ofensivo - Para cosas que no puedes borrar de sitios ajenos, trata de enterrarlas creando contenido positivo y profesional (un perfil de LinkedIn bien hecho, por ejemplo). Y recuerda: internet NO olvida. Pero SI puedes decidir que huella dejas. Has buscado tu nombre en Google alguna vez?'
    ],
    'cyberbullying': [
      'El ciberacoso o cyberbullying es el acoso que ocurre a traves de tecnologias digitales: mensajes amenazantes, difusion de rumores por redes, creacion de perfiles falsos para humillar a alguien, exclusion intencional en grupos... A diferencia del acoso fisico, el ciberacoso puede seguirte A TODAS PARTES, 24 horas al dia, y sentirse imposible de escapar. Si eres victima: 1) NO es tu culpa 2) Tienes derecho a estar seguro/a 3) Cuentaselo a un adulto de confianza (padre, madre, profesor, orientador) 4) Bloquea y denuncia al acosador en la plataforma 5) GUARDA EVIDENCIA (capturas de pantalla, mensajes guardados) - te servira para demostrar lo que pasa. Te gustaria saber mas sobre que hacer si ves que le pasa a alguien?',
      'Es importantisimo hablar de esto! El cyberbullying puede tener efectos devastadores: ansiedad, depresion, aislamiento, incluso pensamientos suicidas. Aqui van datos que debes saber: - Puede ser peor que el acoso tradicional por ser siempre presente y publico - Las victimas muchas veces no hablan por verguenza o miedo a represalias - No hay que ser el agresor directo para ser parte del problema - reirse, compartir o dar me gusta a contenido humillante tambien contribuye. Si ves que alguien esta siendo acosado: 1) No seas espectador silencioso 2) Muestra apoyo a la victima 3) Reporta el contenido 4) Cuentaselo a un adulto. Y si TU eres el que esta acosando: para. Hay ayuda disponible. Habla con alguien que te guie. Sabes cuales son las senales de que alguien esta sufriendo ciberacoso?',
      'Nadie tiene derecho a hacerte sentir mal, y mucho menos a traves de internet. Aqui tienes una guia practica si sufres ciberacoso: PASO 1: No respondas. Los acosadores buscan reaccion. Darles atencion es lo que quieren. PASO 2: Bloquea. En todas las plataformas, juegos, apps. Bloquea sin dudar. PASO 3: Guarda TODO. Capturas de pantalla, mensajes, correos, fechas. Esto es EVIDENCIA. PASO 4: Reporta. Usa las herramientas de denuncia de cada app (Facebook, Instagram, TikTok, WhatsApp todas tienen). PASO 5: HABLA. Cuentaselo a alguien: mama, papa, profesor, orientador, psicologo. No estas solo/a. Y recuerda: el problema no eres TU, es el acosador/a. Hay algo especifico que te preocupa o que quieras compartir? Estoy aqui para escucharte sin juicio.'
    ],
  };

  static final List<String> _defaultResponses = [
    '¡Hola! Soy Sage, tu asistente de ciberseguridad. Estoy aquí para ayudarte a protegerte en internet. ¿De qué te gustaría hablar hoy? Puedo ayudarte con temas como: contraseñas seguras, phishing, malware, privacidad en redes sociales, seguridad WiFi, estafas online, y mucho más. ¿Qué tema te interesa más?',
    '¡Hey! Me alegra que estés aquí hablando de ciberseguridad. Es el mejor regalo que le puedes dar a tu yo digital. ¿Hay algo específico que te preocupe últimamente? O si prefieres, puedo sugerirte temas: - Cómo crear contraseñas que nadie descifre - Qué es el phishing y cómo evitarlo - Cómo configurar tu privacidad en Instagram - Por qué deberías activar la verificación en dos pasos ¿Qué te llama más la atención?',
    '¡Bienvenido/a a un espacio seguro para aprender! La ciberseguridad no es solo para expertos — es para todos los que usamos internet (o sea, casi todos). Cada clic, cada descarga, cada publicación... todo se puede hacer de forma más segura. ¿Te gustaría empezar por lo básico o tienes alguna situación específica que quieras resolver? Cuéntame y juntos encontramos la mejor forma de protegerte.',
    'Entiendo que estás preguntando sobre ciberseguridad. Es un tema amplio pero muy importante. ¿Podrías decirme más específicamente qué te gustaría saber? Puedo ayudarte con phishing, contraseñas, malware, privacidad en redes sociales, seguridad WiFi, y mucho más.',
    'Buena pregunta! La ciberseguridad puede parecer complicada al principio, pero voy a explicártela de forma sencilla. Dime sobre qué tema concreto quieres aprender y te doy toda la información que necesitas.',
    'Me encanta que tengas interés en protegerte en internet. Hay varios temas clave que deberías conocer: cómo crear contraseñas seguras, cómo detectar correos de phishing, cómo proteger tu privacidad en redes sociales, y más. ¿Por cuál te gustaría empezar?',
  ];
}
