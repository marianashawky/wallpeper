# Football Wallpaper

Offline Flutter Android app based on the [Figma Make prototype](https://beta-gadget-20020822.figma.site/).

No backend, no login. Favorites, settings, search history, and download history are stored with `shared_preferences`.

## Run on Android

Flutter SDK used while generating this project: `C:\Users\marin\flutter`

```bat
set PATH=C:\Users\marin\flutter\bin;%PATH%
flutter pub get
flutter run
```

Release APK:

```bat
flutter build apk --release
```

Replace AdMob test IDs in `lib/core/constants/ads_constants.dart` and `android/app/src/main/AndroidManifest.xml` before publishing.

## Content

- 100 original local wallpapers (30 players, 25 clubs, 15 national teams, 10 legends, 10 stadiums, 10 3D/abstract)
- Category thumbnails in `assets/images/categories/`
- Branding in `assets/images/branding/`
