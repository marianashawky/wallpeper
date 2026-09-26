# Lumina

Wallpaper app for stills, motion, and video. Categories include Live, Anime, Nature, Cars, Gaming, Space, Abstract, Minimal, Technology, and Dark.

No account. Favorites, settings, and search history stay on the device with `shared_preferences`.

## Run on Android

```bat
set PATH=C:\Users\marin\flutter\bin;%PATH%
flutter pub get
flutter run
```

Release APK:

```bat
flutter build apk --release
```

Replace the AdMob test IDs in `lib/core/constants/ads_constants.dart` and `android/app/src/main/AndroidManifest.xml` before publishing.
