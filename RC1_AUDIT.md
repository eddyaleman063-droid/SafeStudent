# Safe Student — RC1 Audit Report

## Build Status
- `dart analyze` → **0 errors, 0 warnings**
- `flutter build apk --release` → **56.3MB, success** (with R8 minification + shrinkResources)

## 1. Release Optimization
- ProGuard/R8: `proguard-rules.pro` with keep rules for Flutter, Firebase, Play Core, models
- `isMinifyEnabled = true`, `isShrinkResources = true`
- `getDefaultProguardFile("proguard-android-optimize.txt")` applied
- Font tree-shaking: MaterialIcons 1.6MB → 21KB (98.7% reduction)

## 2. Security Hardening
- Firebase Auth with Google Sign-In (guard via _AppGate)
- Firestore security rules: `firestore.rules` — uid-scoped, auth required, merge-only writes
- `key.properties.template` with keystore generation instructions
- API keys: Gemini API via `String.fromEnvironment()`, no hardcoded keys

## 3. Crashlytics & Analytics
- `firebase_crashlytics: ^4.3.2` added to pubspec.yaml
- `firebase_analytics: ^11.4.4` added to pubspec.yaml
- Crashlytics initialized in `main.dart` try block (graceful fallback if Firebase unavailable)
- `FlutterError.onError` → `FirebaseCrashlytics.instance.recordFlutterFatalError`
- `platformDispatcher.onError` → `FirebaseCrashlytics.instance.recordError`
- `FirebaseAnalyticsObserver` registered in MaterialApp navigatorObservers
- `setAnalyticsCollectionEnabled(true)` — no PII tracked

## 4. Educational Quality Pass
- **5 challenge explanations improved** (QC1, QC3, QC5, QC15, QC17): more specific, data-backed, teach mechanisms not just warnings
- **Daily tips expanded 7→17**: added tips on permissions, QR scams, AI deepfakes, SIM swapping, gesture managers, 2FA
- **File scan explanations removed**: VirusTotal/scan module purged pre-RC1
- **Sage prompt enhanced**: crisis protocol ("if user was victim, respond calmly with concrete steps"), comprehension check, source citation (INCIBE, OSI, Have I Been Pwned)
- **2 new challenges added**: SIM swapping (qc21), AI voice cloning scam (qc22)

## 5. Content Expansion
- 20 → **22 quick challenges** (SIM swapping + AI voice clone)
- 7 → **17 daily tips**

## 6. UX Polish
- `keyboardDismissBehavior: onDrag` on 5 scroll views
- `BouncingScrollPhysics` on settings ListView
- Removed unnecessary "Nueva conversación" confirmation dialog
- Session recovery banner with "Volver" action
- `onAppResume()` connectivity check

## 7. Battery & Performance
- Connectivity polling: 30s → 60s
- Duplicate `start()` guard
- ProGuard tree-shaking reduces APK size

## APK Analysis
- **Size**: 56.3MB (includes Firebase AI, Crashlytics, Analytics — ~2MB increase from Firebase)
- **Potential reduction**: Run `flutter build apk --split-per-abi` for ~40MB per ABI variant, remove unused assets

## Known Gaps for Beta
- [ ] Real `google-services.json` from Firebase Console (placeholder currently)
- [ ] Real `firebase_options.dart` from `flutterfire configure`
- [ ] Release keystore + `key.properties` (not committed)
- [ ] Firebase App Check enforcement
- [ ] CI/CD pipeline (GitHub Actions or similar)
- [ ] Unit tests (0% coverage)
- [ ] Play Store listing assets (screenshots, feature graphic, description)
