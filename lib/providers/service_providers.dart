import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repositories/auth_repository.dart';
import '../services/ai_service.dart';
import '../services/auth_service.dart';
import '../services/cloud_sync_service.dart';
import '../services/gemini_api_client.dart';
import '../services/storage_service.dart';
import '../services/streak_service.dart';
import '../services/app_logger.dart';
import 'prefs_provider.dart';

final loggerProvider = Provider<AppLogger>((ref) {
  return AppLogger();
});

final storageServiceProvider = Provider<StorageService>((ref) {
  final prefs = ref.watch(prefsProvider);
  return StorageService(prefs);
});

final streakServiceProvider = Provider<StreakService>((ref) {
  final storage = ref.watch(storageServiceProvider);
  return StreakService(storage);
});

final authServiceProvider = Provider<AuthService>((ref) {
  final logger = ref.watch(loggerProvider);
  return AuthService(logger: logger);
});

final cloudSyncServiceProvider = Provider<CloudSyncService>((ref) {
  final authService = ref.watch(authServiceProvider);
  final logger = ref.watch(loggerProvider);
  return CloudSyncService(authService: authService, logger: logger);
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final authService = ref.watch(authServiceProvider);
  return AuthRepositoryImpl(authService);
});

final geminiApiClientProvider = Provider<GeminiApiClient>((ref) {
  return GeminiApiClient();
});

final aiServiceProvider = Provider<AiService>((ref) {
  final client = ref.watch(geminiApiClientProvider);
  return GeminiAiService(client);
});
