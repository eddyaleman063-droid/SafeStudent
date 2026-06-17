import 'package:flutter_riverpod/flutter_riverpod.dart';

enum ActiveEffect { focusElixir, infiniteEnergy }

final activeEffectsProvider = NotifierProvider<ActiveEffectsNotifier, Set<ActiveEffect>>(
  ActiveEffectsNotifier.new,
);

class ActiveEffectsNotifier extends Notifier<Set<ActiveEffect>> {
  @override
  Set<ActiveEffect> build() => {};

  void activate(ActiveEffect effect) {
    state = {...state, effect};
  }

  void deactivate(ActiveEffect effect) {
    state = {...state}..remove(effect);
  }

  bool isActive(ActiveEffect effect) => state.contains(effect);

  void toggle(ActiveEffect effect) {
    if (state.contains(effect)) {
      deactivate(effect);
    } else {
      activate(effect);
    }
  }
}
