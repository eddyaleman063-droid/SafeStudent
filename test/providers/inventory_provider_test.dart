import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sagen/models/chest_type.dart';
import 'package:sagen/providers/providers.dart';
import 'package:sagen/services/chest_event_bus.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('InventoryState', () {
    test('initial state has correct defaults', () {
      const state = InventoryState();
      expect(state.chestsOpened, isEmpty);
      expect(state.xpBoostsCollected, 0);
      expect(state.gemMultipliersCollected, 0);
      expect(state.totalChestsOpened, 0);
      expect(state.totalGemsFromChests, 0);
    });

    test('copyWith updates only specified fields', () {
      const state = InventoryState();
      final updated = state.copyWith(
        totalChestsOpened: 5,
        totalGemsFromChests: 100,
      );
      expect(updated.totalChestsOpened, 5);
      expect(updated.totalGemsFromChests, 100);
      expect(updated.xpBoostsCollected, 0);
    });
  });

  group('InventoryNotifier', () {
    late ProviderContainer container;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      container = ProviderContainer(overrides: [
        prefsProvider.overrideWithValue(prefs),
      ]);
    });

    tearDown(() => container.dispose());

    test('build returns default state', () {
      final state = container.read(inventoryProvider);
      expect(state.totalChestsOpened, 0);
      expect(state.chestsOpened, isEmpty);
    });

    test('totalChestsAllTime is 0 initially', () {
      final notifier = container.read(inventoryProvider.notifier);
      expect(notifier.totalChestsAllTime, 0);
    });

    ChestRewardData bronzeReward(int gems) => ChestRewardData(
      type: ChestType.bronze, xp: 10, gems: gems,
      title: 'B', message: 'M', source: 'test',
    );
    ChestRewardData silverReward() => const ChestRewardData(
      type: ChestType.silver, xp: 20, gems: 10,
      title: 'S', message: 'M', source: 'test',
    );
    ChestRewardData goldReward() => const ChestRewardData(
      type: ChestType.gold, xp: 50, gems: 25,
      xpBoost: true, gemMultiplier: true,
      title: 'G', message: 'M', source: 'test',
    );

    test('recordChestOpened increments counters', () {
      final notifier = container.read(inventoryProvider.notifier);
      notifier.recordChestOpened(bronzeReward(5));
      final state = container.read(inventoryProvider);
      expect(state.totalChestsOpened, 1);
      expect(state.totalGemsFromChests, 5);
      expect(state.chestsOpened[ChestType.bronze], 1);
    });

    test('recordChestOpened tracks multiple chest types', () {
      final notifier = container.read(inventoryProvider.notifier);
      notifier.recordChestOpened(bronzeReward(5));
      notifier.recordChestOpened(silverReward());
      notifier.recordChestOpened(bronzeReward(5));
      final state = container.read(inventoryProvider);
      expect(state.totalChestsOpened, 3);
      expect(state.chestsOpened[ChestType.bronze], 2);
      expect(state.chestsOpened[ChestType.silver], 1);
      expect(notifier.totalChestsAllTime, 3);
    });

    test('recordChestOpened tracks xp boosts and multipliers', () {
      final notifier = container.read(inventoryProvider.notifier);
      notifier.recordChestOpened(goldReward());
      final state = container.read(inventoryProvider);
      expect(state.xpBoostsCollected, 1);
      expect(state.gemMultipliersCollected, 1);
    });

    test('recordChestOpened persists across rebuilds', () async {
      SharedPreferences.setMockInitialValues({
        'inv_chests_opened': 'bronze:2,silver:1',
        'inv_total_chests': 3,
        'inv_gems_from_chests': 15,
      });
      final prefs = await SharedPreferences.getInstance();
      final newContainer = ProviderContainer(overrides: [
        prefsProvider.overrideWithValue(prefs),
      ]);
      final state = newContainer.read(inventoryProvider);
      expect(state.totalChestsOpened, 3);
      expect(state.totalGemsFromChests, 15);
      expect(state.chestsOpened[ChestType.bronze], 2);
      expect(state.chestsOpened[ChestType.silver], 1);
      newContainer.dispose();
    });
  });
}
