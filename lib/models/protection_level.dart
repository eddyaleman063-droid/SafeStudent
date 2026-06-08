class ProtectionTier {
  final int level;
  final String name;
  final String description;
  final int requiredScore;

  const ProtectionTier({
    required this.level,
    required this.name,
    required this.description,
    required this.requiredScore,
  });
}

const kProtectionTiers = [
  ProtectionTier(level: 1, name: 'Básico', description: 'Empiezas a protegerte', requiredScore: 0),
  ProtectionTier(level: 5, name: 'Protegido', description: 'Tus primeros hábitos digitales', requiredScore: 200),
  ProtectionTier(level: 10, name: 'Guardian', description: 'Defiendes tu identidad digital', requiredScore: 500),
  ProtectionTier(level: 20, name: 'Cyber Shield', description: 'Eres un escudo activo', requiredScore: 1200),
  ProtectionTier(level: 35, name: 'Secure Mind', description: 'La seguridad es parte de ti', requiredScore: 2500),
  ProtectionTier(level: 50, name: 'Elite Protection', description: 'Máximo nivel de protección', requiredScore: 5000),
];

int protectionLevelForScore(int score) {
  int level = 1;
  for (final tier in kProtectionTiers) {
    if (score >= tier.requiredScore) {
      level = tier.level;
    }
  }
  return level;
}

String protectionNameForLevel(int level) {
  String name = kProtectionTiers.first.name;
  for (final tier in kProtectionTiers) {
    if (level >= tier.level) name = tier.name;
  }
  return name;
}

double protectionProgress(int score, int level) {
  int currentRequired = 0;
  int nextRequired = kProtectionTiers.first.requiredScore;
  for (int i = 0; i < kProtectionTiers.length; i++) {
    if (level >= kProtectionTiers[i].level) {
      currentRequired = kProtectionTiers[i].requiredScore;
      nextRequired = i + 1 < kProtectionTiers.length
          ? kProtectionTiers[i + 1].requiredScore
          : kProtectionTiers[i].requiredScore;
    }
  }
  if (nextRequired <= currentRequired) return 1.0;
  return (score - currentRequired) / (nextRequired - currentRequired);
}
