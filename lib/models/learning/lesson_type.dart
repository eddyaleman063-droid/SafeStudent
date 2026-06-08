import 'package:json_annotation/json_annotation.dart';

@JsonEnum()
enum LessonType {
  trueFalse,
  multipleChoice,
  completePhrase,
  detectRisk,
  createPassword,
  whatWouldYouDo,
  miniCase,
}

extension LessonTypeExtension on LessonType {
  String get label {
    switch (this) {
      case LessonType.trueFalse:
        return 'Verdadero / Falso';
      case LessonType.multipleChoice:
        return 'Opción múltiple';
      case LessonType.completePhrase:
        return 'Completa la frase';
      case LessonType.detectRisk:
        return 'Detectar riesgo';
      case LessonType.createPassword:
        return 'Crear contraseña';
      case LessonType.whatWouldYouDo:
        return '¿Qué harías aquí?';
      case LessonType.miniCase:
        return 'Caso real';
    }
  }
}
