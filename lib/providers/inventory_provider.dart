import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/chest_type.dart';
import '../services/chest_event_bus.dart';
import '../services/storage_service.dart';
import 'prefs_provider.dart';

class InventoryState {
  final Map<ChestType, int> chestsOpened;
  final int xpBoostsCollected;
  final int gemMultipliersCollected;
  final int totalChestsOpened;
  final int totalGemsFromChests;

  const InventoryState({
    this.chestsOpened = const {},
    this.xpBoostsCollected = 0,
    this.gemMultipliersCollected = 0,
    this.totalChestsOpened = 0,
    this.totalGemsFromChests = 0,
  });

  InventoryState copyWith({
    Map<ChestType, int>? chestsOpened,
    int? xpBoostsCollected,
    int? gemMultipliersCollected,
    int? totalChestsOpened,
    int? totalGemsFromChests,
  }) {
    return InventoryState(
      chestsOpened: chestsOpened ?? this.chestsOpened,
      xpBoostsCollected: xpBoostsCollected ?? this.xpBoostsCollected,
      gemMultipliersCollected: gemMultipliersCollected ?? this.gemMultipliersCollected,
      totalChestsOpened: totalChestsOpened ?? this.totalChestsOpened,
      totalGemsFromChests: totalGemsFromChests ?? this.totalGemsFromChests,
    );
  }
}

class InventoryNotifier extends Notifier<InventoryState> {
  StorageService? _storage;

  static const _keyChests = 'inv_chests_opened';
  static const _keyTotal = 'inv_total_chests';
  static const _keyGems = 'inv_gems_from_chests';
  static const _keyBoosts = 'inv_xp_boosts';
  static const _keyMultipliers = 'inv_gem_multipliers';

  @override
  InventoryState build() {
    InventoryProvider.recordDelegate = (data) => recordChestOpened(data);
    final prefs = ref.watch(prefsProvider);
    _storage = StorageService(prefs);
    return _load();
  }

  InventoryState _load() {
    final Map<ChestType, int> chestsOpened = {};
    final raw = _storage?.getString(_keyChests) ?? '';
    if (raw.isNotEmpty) {
      for (final entry in raw.split(',')) {
        final parts = entry.split(':');
        if (parts.length == 2) {
          final ct = ChestType.values.where((t) => t.name == parts[0]).firstOrNull;
          if (ct != null) chestsOpened[ct] = int.tryParse(parts[1]) ?? 0;
        }
      }
    }
    return InventoryState(
      chestsOpened: chestsOpened,
      totalChestsOpened: _storage?.getInt(_keyTotal) ?? 0,
      totalGemsFromChests: _storage?.getInt(_keyGems) ?? 0,
      xpBoostsCollected: _storage?.getInt(_keyBoosts) ?? 0,
      gemMultipliersCollected: _storage?.getInt(_keyMultipliers) ?? 0,
    );
  }

  void _save(InventoryState current) {
    final encoded = current.chestsOpened.entries.map((e) => '${e.key.name}:${e.value}').join(',');
    _storage?.setString(_keyChests, encoded);
    _storage?.setInt(_keyTotal, current.totalChestsOpened);
    _storage?.setInt(_keyGems, current.totalGemsFromChests);
    _storage?.setInt(_keyBoosts, current.xpBoostsCollected);
    _storage?.setInt(_keyMultipliers, current.gemMultipliersCollected);
  }

  int get totalChestsAllTime => state.chestsOpened.values.fold(0, (a, b) => a + b);

  void recordChestOpened(ChestRewardData data) {
    final updated = Map<ChestType, int>.from(state.chestsOpened);
    updated[data.type] = (updated[data.type] ?? 0) + 1;
    final next = state.copyWith(
      chestsOpened: updated,
      totalChestsOpened: state.totalChestsOpened + 1,
      totalGemsFromChests: state.totalGemsFromChests + data.gems,
      xpBoostsCollected: state.xpBoostsCollected + (data.xpBoost ? 1 : 0),
      gemMultipliersCollected: state.gemMultipliersCollected + (data.gemMultiplier ? 1 : 0),
    );
    _save(next);
    state = next;
  }
}

// Backward-compat wrapper for non-Riverpod consumers (chest_listener, main.dart)
class InventoryProvider {
  InventoryProvider._();

  static InventoryProvider? _instance;
  static InventoryProvider get instance {
    _instance ??= InventoryProvider._();
    return _instance!;
  }

  void recordChestOpened(ChestRewardData data) => _recordDelegate?.call(data);

  void init(SharedPreferences prefs) {
    // No-op: handled by InventoryNotifier.build()
  }

  static void Function(ChestRewardData)? _recordDelegate;
  static set recordDelegate(void Function(ChestRewardData)? fn) => _recordDelegate = fn;
}
