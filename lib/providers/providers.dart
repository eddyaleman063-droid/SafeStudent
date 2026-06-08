import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/admob_service.dart';
import '../services/share_service.dart';
import 'achievement_provider.dart';
import 'auth_provider.dart';
import 'dashboard_provider.dart';
import 'energy_provider.dart';
import 'inventory_provider.dart';
import 'language_provider.dart';
import 'learning_memory_provider.dart';
import 'mission_provider.dart';
import 'onboarding_wizard_provider.dart';
import 'protection_provider.dart';
import 'review_provider.dart';
import 'sage_ai_provider.dart';
import 'session_provider.dart';
import 'shop_provider.dart';
import 'streak_provider.dart';
import 'theme_provider.dart';
export 'first_lesson_provider.dart';
export 'gamification_provider.dart';
export 'hardware_tier_provider.dart';
export 'leaderboard_provider.dart';
export 'learning_provider.dart';
export 'prefs_provider.dart';
export 'registration_funnel_provider.dart';
export 'auth_provider.dart';
export 'inventory_provider.dart';
export 'onboarding_wizard_provider.dart';
export 'service_providers.dart';
export 'session_provider.dart';

final themeProvider = NotifierProvider<ThemeNotifier, ThemeState>(ThemeNotifier.new);

final authProvider = NotifierProvider<AuthNotifier, AuthState>(AuthNotifier.new);

final streakProvider = NotifierProvider<StreakNotifier, StreakState>(StreakNotifier.new);

final protectionProvider = NotifierProvider<ProtectionNotifier, ProtectionState>(ProtectionNotifier.new);

final achievementProvider = NotifierProvider<AchievementNotifier, AchievementState>(AchievementNotifier.new);



final inventoryProvider = NotifierProvider<InventoryNotifier, InventoryState>(InventoryNotifier.new);

final reviewProvider = NotifierProvider<ReviewNotifier, ReviewState>(ReviewNotifier.new);

final languageProvider = NotifierProvider<LanguageNotifier, LanguageState>(LanguageNotifier.new);

final learningMemoryProvider = NotifierProvider<LearningMemoryNotifier, LearningMemoryState>(LearningMemoryNotifier.new);

final missionProvider = NotifierProvider<MissionNotifier, MissionState>(MissionNotifier.new);

final shopProvider = NotifierProvider<ShopNotifier, ShopState>(ShopNotifier.new);

final energyProvider = NotifierProvider<EnergyNotifier, EnergyState>(EnergyNotifier.new);

final onboardingWizardProvider =
    NotifierProvider<OnboardingWizardNotifier, OnboardingWizardState>(
  OnboardingWizardNotifier.new,
);

final sageAiProvider = NotifierProvider<SageAiNotifier, SageAiChatState>(SageAiNotifier.new);

final dashboardProvider = NotifierProvider<DashboardNotifier, DashboardState>(DashboardNotifier.new);

final sessionProvider = NotifierProvider<SessionNotifier, SessionState>(SessionNotifier.new);

final assessmentLevelProvider = StateProvider.autoDispose<int?>((ref) => null);

final admobServiceProvider = Provider<AdMobService>((ref) {
  return AdMobService.instance;
});

final shareServiceProvider = Provider<ShareService>((ref) {
  return ShareService.instance;
});
