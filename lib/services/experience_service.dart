import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'device_tier.dart';

class ExperienceService {
  static final ExperienceService instance = ExperienceService._();
  ExperienceService._();

  bool _soundEnabled = true;
  bool _hapticEnabled = true;
  bool _reduceAnimations = false;

  bool get soundEnabled => _soundEnabled;
  bool get hapticEnabled => _hapticEnabled;
  bool get reduceAnimations => _reduceAnimations || LowEndDeviceDetector.instance.reduceAnimations;
  bool get reduceBlur => LowEndDeviceDetector.instance.reduceBlur;
  bool get reduceShadows => LowEndDeviceDetector.instance.reduceShadows;
  bool get reduceGlow => LowEndDeviceDetector.instance.reduceGlow;

  Future<void> init() async {
    LowEndDeviceDetector.instance.init();
    final prefs = await SharedPreferences.getInstance();
    _soundEnabled = prefs.getBool('sound_enabled') ?? true;
    _hapticEnabled = prefs.getBool('haptic_enabled') ?? true;
    _reduceAnimations = prefs.getBool('reduce_animations') ?? false;
  }

  Future<void> setSoundEnabled(bool v) async {
    _soundEnabled = v;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('sound_enabled', v);
  }

  Future<void> setHapticEnabled(bool v) async {
    _hapticEnabled = v;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('haptic_enabled', v);
  }

  Future<void> setReduceAnimations(bool v) async {
    _reduceAnimations = v;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('reduce_animations', v);
  }

  // Haptic feedback methods
  void lightHaptic() {
    if (!_hapticEnabled) return;
    HapticFeedback.lightImpact();
  }

  void mediumHaptic() {
    if (!_hapticEnabled) return;
    HapticFeedback.mediumImpact();
  }

  void heavyHaptic() {
    if (!_hapticEnabled) return;
    HapticFeedback.heavyImpact();
  }

  void selectionHaptic() {
    if (!_hapticEnabled) return;
    HapticFeedback.selectionClick();
  }

  void successHaptic() {
    if (!_hapticEnabled) return;
    HapticFeedback.mediumImpact();
  }

  void errorHaptic() {
    if (!_hapticEnabled) return;
    HapticFeedback.heavyImpact();
  }

  void notificationHaptic() {
    if (!_hapticEnabled) return;
    HapticFeedback.heavyImpact();
  }

  void chestOpenHaptic() {
    if (!_hapticEnabled) return;
    HapticFeedback.mediumImpact();
    Future.delayed(const Duration(milliseconds: 100), () {
      HapticFeedback.heavyImpact();
    });
  }

  // Animation duration helpers
  Duration get fast => _reduceAnimations ? Duration.zero : const Duration(milliseconds: 150);
  Duration get normal => _reduceAnimations ? Duration.zero : const Duration(milliseconds: 300);
  Duration get medium => _reduceAnimations ? Duration.zero : const Duration(milliseconds: 500);
  Duration get slow => _reduceAnimations ? Duration.zero : const Duration(milliseconds: 800);
  Duration get celebration => _reduceAnimations ? const Duration(milliseconds: 200) : const Duration(milliseconds: 1200);
}
