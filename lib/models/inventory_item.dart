enum InventoryItemType {
  focusElixir,
  phoenixFeather,
  sagesMonocle,
  titaniumShield;

  String get displayName {
    switch (this) {
      case InventoryItemType.focusElixir: return 'Elixir de Foco';
      case InventoryItemType.phoenixFeather: return 'Pluma de Fénix';
      case InventoryItemType.sagesMonocle: return 'Monóculo del Sabio';
      case InventoryItemType.titaniumShield: return 'Escudo de Titanio';
    }
  }

  String get description {
    switch (this) {
      case InventoryItemType.focusElixir:
        return 'Multiplica EXP y Gemas x2 durante 15 min';
      case InventoryItemType.phoenixFeather:
        return 'Revive tu racha si la perdiste hace menos de 24h';
      case InventoryItemType.sagesMonocle:
        return 'Elimina 2 respuestas incorrectas en un reto';
      case InventoryItemType.titaniumShield:
        return 'Protege tu racha automáticamente si faltas un día';
    }
  }

  String get iconAsset {
    switch (this) {
      case InventoryItemType.focusElixir: return '🧪';
      case InventoryItemType.phoenixFeather: return '🪶';
      case InventoryItemType.sagesMonocle: return '👁️';
      case InventoryItemType.titaniumShield: return '🛡️';
    }
  }
}

class InventoryItem {
  final InventoryItemType type;
  int quantity;

  InventoryItem({required this.type, this.quantity = 0});
}
