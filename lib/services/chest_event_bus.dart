import 'dart:async';
import '../models/chest_type.dart';

class ChestRewardData {
  final ChestType type;
  final int xp;
  final int gems;
  final int? streakShields;
  final String? title;
  final String? message;
  final String source;
  final bool xpBoost;
  final bool gemMultiplier;

  const ChestRewardData({
    required this.type,
    this.xp = 0,
    this.gems = 0,
    this.streakShields,
    this.title,
    this.message,
    required this.source,
    this.xpBoost = false,
    this.gemMultiplier = false,
  });
}

class ChestEventBus {
  ChestEventBus._();
  static final ChestEventBus instance = ChestEventBus._();

  final List<ChestRewardData> _queue = [];
  final StreamController<ChestRewardData> _controller =
      StreamController<ChestRewardData>.broadcast();

  ChestRewardData? get pending => _queue.isNotEmpty ? _queue.first : null;

  Stream<ChestRewardData> get events => _controller.stream;

  void fire(ChestRewardData data) {
    _queue.add(data);
    _controller.add(data);
  }

  void consume() {
    if (_queue.isNotEmpty) _queue.removeAt(0);
  }

  void dispose() {
    _controller.close();
  }
}
