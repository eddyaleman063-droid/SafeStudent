# Safe Student — Firebase Production Setup

## Prerequisites
- FlutterFire CLI: `dart pub global activate flutterfire_cli`
- Firebase project created at https://console.firebase.google.com
- Android app registered in Firebase Console with package name `com.example.safestudentapp`

## Step 1: Configure Firebase project

1. Go to Firebase Console → Project settings → General
2. Add Android app with package name `com.example.safestudentapp`
3. Download `google-services.json` and place in `android/app/`
4. Register SHA-1 fingerprint (needed for Google Sign-In):
   ```
   keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android
   ```
   Add the SHA-1 to Firebase Console → Android app settings

## Step 2: Run FlutterFire configure

```bash
flutterfire configure \
  --project=YOUR_FIREBASE_PROJECT_ID \
  --out=lib/firebase_options.dart \
  --yes
```

This generates `lib/firebase_options.dart` with real platform configs.

## Step 3: Enable Authentication

1. Firebase Console → Authentication → Sign-in method
2. Enable **Google** provider
3. Add support email
4. (Optional) Enable **Anonymous** for offline-first fallback

## Step 4: Enable Firestore

1. Firebase Console → Firestore Database → Create database
2. Start in test mode, then apply rules from `firestore.rules`
3. Choose location closest to your users

## Step 5: Deploy Firestore rules

```bash
firebase deploy --only firestore:rules
```

Rules are in `firestore.rules` (uid-scoped auth, merge-only writes).

## Step 6: Enable Crashlytics

1. Firebase Console → Crashlytics → Enable (Android)
2. No additional code needed — already initialized in `main.dart`

## Step 7: Enable Analytics

Already initialized in `main.dart` with `FirebaseAnalyticsObserver`.
No PII tracked — only screen views and crash-free rate.

## Step 8: Generate release keystore

```bash
keytool -genkey -v -keystore android/app/release.keystore \
  -alias safe_student -keyalg RSA -keysize 2048 -validity 10000
```

Create `android/key.properties` from `android/key.properties.template`.

## Step 9: Verify production build

```bash
flutter build apk --release
# Verify Google Sign-In works with release signing
# Verify Crashlytics reports appear in Firebase Console
```

## Environment variables

Set these in your CI/CD or `.env`:
- `GEMINI_API_KEY` — for Gemini AI (Sage tutor, challenges)
