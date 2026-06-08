import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/device_tier.dart';

final hardwareTierProvider = Provider<DeviceTier>((ref) {
  LowEndDeviceDetector.instance.init();
  return LowEndDeviceDetector.instance.tier;
});

final isLowEndDeviceProvider = Provider<bool>((ref) {
  return ref.watch(hardwareTierProvider) == DeviceTier.lowEnd;
});

final reduceAnimationsProvider = Provider<bool>((ref) {
  return LowEndDeviceDetector.instance.reduceAnimations;
});

final reduceBlurProvider = Provider<bool>((ref) {
  return LowEndDeviceDetector.instance.reduceBlur;
});

final reduceShadowsProvider = Provider<bool>((ref) {
  return LowEndDeviceDetector.instance.reduceShadows;
});

final reduceParticlesProvider = Provider<bool>((ref) {
  return LowEndDeviceDetector.instance.reduceParticles;
});
