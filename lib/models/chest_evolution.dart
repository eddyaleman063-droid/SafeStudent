import 'dart:math';
import 'chest_type.dart';

class EvolutionAttempt {
  final int index;
  final ChestType typeBefore;
  final ChestType typeAfter;
  final bool upgraded;
  final bool isFinal;

  const EvolutionAttempt({
    required this.index,
    required this.typeBefore,
    required this.typeAfter,
    required this.upgraded,
    required this.isFinal,
  });
}

class ChestEvolutionResult {
  final ChestType finalType;
  final List<EvolutionAttempt> attempts;

  const ChestEvolutionResult({
    required this.finalType,
    required this.attempts,
  });
}

class ChestEvolutionService {
  ChestEvolutionService._();
  static final ChestEvolutionService instance = ChestEvolutionService._();
  final _random = Random();

  ChestEvolutionResult runGacha(ChestType initialType) {
    final attempts = <EvolutionAttempt>[];
    var currentType = initialType;

    for (int i = 0; i < 3; i++) {
      final typeBefore = currentType;
      if (currentType == ChestType.legendary) {
        attempts.add(EvolutionAttempt(
          index: i,
          typeBefore: typeBefore,
          typeAfter: currentType,
          upgraded: false,
          isFinal: i == 2,
        ));
        continue;
      }
      final upgraded = _attemptUpgrade(currentType);
      if (upgraded) currentType = _nextType(currentType);
      attempts.add(EvolutionAttempt(
        index: i,
        typeBefore: typeBefore,
        typeAfter: currentType,
        upgraded: upgraded,
        isFinal: i == 2,
      ));
    }

    return ChestEvolutionResult(finalType: currentType, attempts: attempts);
  }

  bool _attemptUpgrade(ChestType current) {
    switch (current) {
      case ChestType.bronze:
        return _random.nextDouble() < 0.45;
      case ChestType.silver:
        return _random.nextDouble() < 0.20;
      case ChestType.gold:
        return _random.nextDouble() < 0.03;
      case ChestType.legendary:
        return false;
    }
  }

  ChestType _nextType(ChestType current) {
    switch (current) {
      case ChestType.bronze:
        return ChestType.silver;
      case ChestType.silver:
        return ChestType.gold;
      case ChestType.gold:
        return ChestType.legendary;
      case ChestType.legendary:
        return current;
    }
  }
}
