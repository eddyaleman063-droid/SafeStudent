import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/storage_service.dart';
import 'prefs_provider.dart';

class EnergyState {
  final int energy;
  final DateTime lastRegen;

  const EnergyState({
    required this.energy,
    required this.lastRegen,
  });

  EnergyState copyWith({
    int? energy,
    DateTime? lastRegen,
  }) {
    return EnergyState(
      energy: energy ?? this.energy,
      lastRegen: lastRegen ?? this.lastRegen,
    );
  }
}

class EnergyNotifier extends Notifier<EnergyState> {
  late final StorageService _storage;
  Timer? _regenTimer;

  static const _maxEnergy = 100;
  static const _lessonCost = 20;
  static const _regenInterval = Duration(minutes: 5);
  static const _regenAmount = 1;

  static const _keyEnergy = 'energy_current';
  static const _keyLastRegen = 'energy_last_regen';

  static int get maxEnergy => _maxEnergy;
  static int get lessonCost => _lessonCost;

  @override
  EnergyState build() {
    final prefs = ref.watch(prefsProvider);
    _storage = StorageService(prefs);
    final initial = _load();
    _startRegen();
    ref.onDispose(() => _regenTimer?.cancel());
    return initial;
  }

  EnergyState _load() {
    int energy = _storage.getInt(_keyEnergy, _maxEnergy).clamp(0, _maxEnergy);
    final last = _storage.getString(_keyLastRegen);
    if (last.isNotEmpty) {
      final lastRegen = DateTime.tryParse(last) ?? DateTime.now();
      final elapsed = DateTime.now().difference(lastRegen);
      final minutes = elapsed.inMinutes;
      if (minutes >= _regenInterval.inMinutes) {
        final regenCycles = minutes ~/ _regenInterval.inMinutes;
        energy = (energy + regenCycles * _regenAmount).clamp(0, _maxEnergy);
      }
    }
    return EnergyState(energy: energy, lastRegen: DateTime.now());
  }

  void _startRegen() {
    _regenTimer = Timer.periodic(_regenInterval, (_) {
      if (state.energy < _maxEnergy) {
        final next = (state.energy + _regenAmount).clamp(0, _maxEnergy);
        state = state.copyWith(energy: next);
        _save();
      }
    });
  }

  int get energy => state.energy;
  double get fraction => state.energy / _maxEnergy;
  bool get canDoLesson => state.energy >= _lessonCost;

  bool consumeForLesson() {
    if (state.energy < _lessonCost) return false;
    state = state.copyWith(energy: state.energy - _lessonCost);
    _save();
    return true;
  }

  void addEnergy(int amount) {
    final next = (state.energy + amount).clamp(0, _maxEnergy);
    state = state.copyWith(energy: next);
    _save();
  }

  void refill() {
    state = state.copyWith(energy: _maxEnergy);
    _save();
  }

  void _save() {
    _storage.setInt(_keyEnergy, state.energy);
    _storage.setString(_keyLastRegen, DateTime.now().toIso8601String());
  }
}
