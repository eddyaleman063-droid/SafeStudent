import 'package:freezed_annotation/freezed_annotation.dart';

part 'quick_challenge.freezed.dart';
part 'quick_challenge.g.dart';

@JsonEnum()
enum QuickChallengeType { trueFalse, detectRisk, safePassword, whatWouldYouDo, detectPhishing }

@freezed
class QuickChallenge with _$QuickChallenge {
  const QuickChallenge._();

  const factory QuickChallenge({
    required String id,
    required QuickChallengeType type,
    required String question,
    required String scenario,
    required List<String> options,
    required int correctIndex,
    required String explanation,
    @Default('') String consequenceCorrect,
    @Default('') String consequenceWrong,
    @Default(15) int xpReward,
    @Default(5) int gemReward,
  }) = _QuickChallenge;

  factory QuickChallenge.fromJson(Map<String, dynamic> json) => _$QuickChallengeFromJson(json);

  String get typeLabel {
    switch (type) {
      case QuickChallengeType.trueFalse: return 'Verdadero o Falso';
      case QuickChallengeType.detectRisk: return 'Detecta el riesgo';
      case QuickChallengeType.safePassword: return 'Contraseña segura';
      case QuickChallengeType.whatWouldYouDo: return '¿Qué harías?';
      case QuickChallengeType.detectPhishing: return 'Detecta phishing';
    }
  }
}
