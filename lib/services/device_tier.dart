import 'dart:io';
import 'package:flutter/foundation.dart';

enum DeviceTier {
  lowEnd,
  midRange,
  highEnd,
}

class LowEndDeviceDetector {
  static final LowEndDeviceDetector instance = LowEndDeviceDetector._();
  LowEndDeviceDetector._();

  DeviceTier _tier = DeviceTier.highEnd;
  bool _initialized = false;

  DeviceTier get tier => _tier;
  bool get isLowEnd => _tier == DeviceTier.lowEnd;
  bool get isMidRange => _tier == DeviceTier.midRange;

  bool get reduceAnimations => _tier == DeviceTier.lowEnd;
  bool get reduceBlur => _tier != DeviceTier.highEnd;
  bool get reduceShadows => _tier == DeviceTier.lowEnd;
  bool get reduceGlow => _tier != DeviceTier.highEnd;
  bool get reduceParticles => _tier == DeviceTier.lowEnd;
  bool get reduceTransparency => _tier != DeviceTier.highEnd;
  bool get useSimpleAnimations => _tier != DeviceTier.highEnd;
  bool get disableParallax => _tier == DeviceTier.lowEnd;

  void init() {
    if (_initialized) return;
    _initialized = true;

    if (kIsWeb) {
      _tier = DeviceTier.highEnd;
      return;
    }

    try {
      _tier = _detectTier();
    } catch (_) {
      _tier = DeviceTier.midRange;
    }
  }

  DeviceTier _detectTier() {
    if (Platform.isIOS) return DeviceTier.highEnd;
    final ramKB = _readMemTotalKB();
    if (ramKB > 0) {
      final ramMB = ramKB ~/ 1024;
      if (ramMB < 2048) return DeviceTier.lowEnd;
      if (ramMB < 4096) return DeviceTier.midRange;
      if (ramMB < 6144) return DeviceTier.midRange;
      return DeviceTier.highEnd;
    }

    final cpuCores = _readCpuCores();
    if (cpuCores > 0 && cpuCores <= 4) return DeviceTier.lowEnd;
    if (cpuCores > 4 && cpuCores <= 6) return DeviceTier.midRange;

    return DeviceTier.midRange;
  }

  int _readMemTotalKB() {
    try {
      final file = File('/proc/meminfo');
      if (!file.existsSync()) return 0;
      final lines = file.readAsLinesSync();
      for (final line in lines) {
        if (line.startsWith('MemTotal:')) {
          final parts = line.split(RegExp(r'\s+'));
          if (parts.length >= 2) return int.tryParse(parts[1]) ?? 0;
        }
      }
    } catch (_) {}
    return 0;
  }

  int _readCpuCores() {
    try {
      final cpus = <int>[];
      final dir = Directory('/sys/devices/system/cpu/');
      if (!dir.existsSync()) return 0;
      for (final entity in dir.listSync()) {
        final name = entity.uri.pathSegments.last;
        final match = RegExp(r'^cpu(\d+)$').firstMatch(name);
        if (match != null) {
          cpus.add(int.parse(match.group(1)!));
        }
      }
      return cpus.isNotEmpty ? cpus.length : 0;
    } catch (_) {
      return 0;
    }
  }
}
