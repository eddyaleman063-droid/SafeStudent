import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/storage_service.dart';
import 'prefs_provider.dart';

class ShopItem {
  final String id;
  final String name;
  final String description;
  final int cost;
  final String iconAsset;
  final bool isOwned;

  const ShopItem({
    required this.id,
    required this.name,
    required this.description,
    required this.cost,
    this.iconAsset = 'shield',
    this.isOwned = false,
  });

  ShopItem copyWith({bool? isOwned}) => ShopItem(
    id: id, name: name, description: description, cost: cost,
    iconAsset: iconAsset, isOwned: isOwned ?? this.isOwned,
  );
}

class ShopState {
  final List<ShopItem> items;
  final int streakShields;
  final bool xpBoostActive;

  const ShopState({
    this.items = const [],
    this.streakShields = 0,
    this.xpBoostActive = false,
  });

  ShopState copyWith({List<ShopItem>? items, int? streakShields, bool? xpBoostActive}) =>
      ShopState(
        items: items ?? this.items,
        streakShields: streakShields ?? this.streakShields,
        xpBoostActive: xpBoostActive ?? this.xpBoostActive,
      );

  static const _maxShields = 2;
  static const _shieldCost = 150;

  int get maxShields => _maxShields;
  int get shieldCost => _shieldCost;
  bool get canBuyShield => streakShields < _maxShields;
}

class ShopNotifier extends Notifier<ShopState> {
  late StorageService _storage;

  static const _keyShields = 'shop_streak_shields';
  static const _keyXpBoost = 'shop_xp_boost';

  @override
  ShopState build() {
    final prefs = ref.watch(prefsProvider);
    _storage = StorageService(prefs);
    return _load();
  }

  ShopState _load() {
    final streakShields = _storage.getInt(_keyShields).clamp(0, ShopState._maxShields);
    final xpBoostActive = _storage.getBool(_keyXpBoost);
    return ShopState(
      streakShields: streakShields,
      xpBoostActive: xpBoostActive,
      items: [
        const ShopItem(id: 'xp_boost', name: 'Boost de XP', description: '2x XP en tu próxima lección', cost: 100),
        const ShopItem(id: 'theme_blue', name: 'Tema azul profundo', description: 'Apariencia premium azul', cost: 150, iconAsset: 'palette'),
        const ShopItem(id: 'theme_purple', name: 'Tema púrpura', description: 'Apariencia premium púrpura', cost: 150, iconAsset: 'palette'),
        const ShopItem(id: 'gold_frame', name: 'Marco dorado', description: 'Marco exclusivo en tu perfil', cost: 200, iconAsset: 'frame'),
      ],
    );
  }

  void activateXpBoost() {
    _storage.setBool(_keyXpBoost, true);
    state = state.copyWith(xpBoostActive: true);
  }

  void deactivateXpBoost() {
    _storage.setBool(_keyXpBoost, false);
    state = state.copyWith(xpBoostActive: false);
  }

  bool buyItem(String id) {
    final item = state.items.firstWhere((i) => i.id == id);
    if (item.isOwned) return false;
    final newItems = [
      for (final i in state.items)
        if (i.id == id) i.copyWith(isOwned: true) else i,
    ];
    state = state.copyWith(items: newItems);
    _save();
    return true;
  }

  bool buyStreakShield() {
    if (state.streakShields >= ShopState._maxShields) return false;
    final newCount = state.streakShields + 1;
    _storage.setInt(_keyShields, newCount);
    state = state.copyWith(streakShields: newCount);
    return true;
  }

  bool useStreakShield() {
    if (state.streakShields <= 0) return false;
    final newCount = state.streakShields - 1;
    _storage.setInt(_keyShields, newCount);
    state = state.copyWith(streakShields: newCount);
    return true;
  }

  void _save() {
    _storage.setInt(_keyShields, state.streakShields);
  }
}
