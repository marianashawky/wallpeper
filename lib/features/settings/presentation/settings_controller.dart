import 'package:flutter/material.dart';

import '../../../data/local/local_store.dart';

class SettingsController extends ChangeNotifier {
  SettingsController(this._store);

  final LocalStore _store;

  AppThemePreference theme = AppThemePreference.dark;
  DownloadQuality quality = DownloadQuality.high;
  bool notifications = true;
  bool autoplayPreviews = true;

  ThemeMode get themeMode {
    switch (theme) {
      case AppThemePreference.system:
        return ThemeMode.system;
      case AppThemePreference.light:
        return ThemeMode.light;
      case AppThemePreference.dark:
        return ThemeMode.dark;
    }
  }

  bool get highQuality => quality == DownloadQuality.high;

  Future<void> load() async {
    theme = _store.theme;
    quality = _store.quality;
    notifications = _store.notifications;
    autoplayPreviews = _store.autoplayPreviews;
    notifyListeners();
  }

  Future<void> setTheme(AppThemePreference value) async {
    theme = value;
    notifyListeners();
    await _store.setTheme(value);
  }

  Future<void> setQuality(DownloadQuality value) async {
    quality = value;
    notifyListeners();
    await _store.setQuality(value);
  }

  Future<void> setNotifications(bool value) async {
    notifications = value;
    notifyListeners();
    await _store.setNotifications(value);
  }

  Future<void> setAutoplay(bool value) async {
    autoplayPreviews = value;
    notifyListeners();
    await _store.setAutoplayPreviews(value);
  }
}
