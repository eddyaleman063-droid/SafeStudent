import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sagen/providers/providers.dart';
import '../../services/analytics_service.dart';
import '../../services/chest_event_bus.dart';
import '../../services/experience_service.dart';
import 'chest_reward_dialog.dart';

class ChestListener extends StatefulWidget {
  final Widget child;
  const ChestListener({super.key, required this.child});

  @override
  State<ChestListener> createState() => _ChestListenerState();
}

class _ChestListenerState extends State<ChestListener> {
  bool _dialogOpen = false;
  final _bus = ChestEventBus.instance;
  StreamSubscription<ChestRewardData>? _sub;

  @override
  void initState() {
    super.initState();
    _sub = _bus.events.listen(_onChestEvent);
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  void _onChestEvent(ChestRewardData data) {
    if (_dialogOpen || !mounted) return;

    _dialogOpen = true;
    ExperienceService.instance.chestOpenHaptic();

    ChestRewardDialog.show(context, data).then((_) {
      InventoryProvider.instance.recordChestOpened(data);
      AnalyticsService.instance.track(AnalyticEvent.chestOpened, properties: {
        'type': data.type.name,
        'source': data.source,
        'gems': data.gems,
        'xp': data.xp,
      });
      _bus.consume();
      if (mounted) _dialogOpen = false;
    });
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
