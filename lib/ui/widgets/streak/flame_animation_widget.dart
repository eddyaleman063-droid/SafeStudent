import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum FlamePhase { idle, charge, explode, float, frozen, defrosting }

extension _FlamePhaseName on FlamePhase {
  String get channelName => name.toUpperCase();
}

class FlameAnimationWidget extends StatefulWidget {
  final FlamePhase? phase;

  const FlameAnimationWidget({
    super.key,
    this.phase,
  });

  @override
  State<FlameAnimationWidget> createState() => _FlameAnimationWidgetState();
}

class _FlameAnimationWidgetState extends State<FlameAnimationWidget> {
  static const _channel = MethodChannel('dev.sagen.app/flame_animation');

  @override
  void initState() {
    super.initState();
  }

  @override
  void didUpdateWidget(FlameAnimationWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.phase != widget.phase && widget.phase != null) {
      _sendPhase(widget.phase!);
    }
  }

  void _sendPhase(FlamePhase phase) {
    _channel.invokeMethod<void>('setPhase', {
      'phase': phase.channelName,
    });
  }

  @override
  Widget build(BuildContext context) {
    return AndroidView(
      viewType: 'com.sagen.app/flame_animation',
      creationParamsCodec: const StandardMessageCodec(),
      onPlatformViewCreated: (_) {
        if (widget.phase != null) {
          _sendPhase(widget.phase!);
        }
      },
    );
  }
}
