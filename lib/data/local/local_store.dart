import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

enum AppThemePreference { system, dark, light }

enum DownloadQuality { standard, high }

class LocalStore {
  LocalStore(this._prefs);

  final SharedPreferences _prefs;

  static const _favoritesKey = 'favorites';
  static const _downloadsKey = 'downloads';
  static const _sharesKey = 'shares';
  static const _recentSearchesKey = 'recent_searches';
  static const _notificationsKey = 'notifications';
  static const _qualityKey = 'download_quality';
  static const _themeKey = 'theme_mode';
  static const _darkModeKey = 'dark_mode';
  static const _autoplayKey = 'autoplay_previews';

  List<String> get favoriteIds => _prefs.getStringList(_favoritesKey) ?? const [];

  Future<void> toggleFavorite(String id) async {
    final current = favoriteIds;
    final next = current.where((entry) => entry != id).toList();
    if (!current.contains(id)) next.insert(0, id);
    await _prefs.setStringList(_favoritesKey, next);
  }

  List<String> get downloads => _prefs.getStringList(_downloadsKey) ?? const [];

  bool isDownloaded(String id) => downloads.contains(id);

  Future<void> addDownload(String id) async {
    final next = [id, ...downloads.where((entry) => entry != id)];
    await _prefs.setStringList(_downloadsKey, next);
  }

  int get shareCount => _prefs.getInt(_sharesKey) ?? 0;

  Future<void> incrementShare() async {
    await _prefs.setInt(_sharesKey, shareCount + 1);
  }

  List<String> get recentSearches {
    final raw = _prefs.getString(_recentSearchesKey);
    if (raw == null || raw.isEmpty) return const [];
    final decoded = jsonDecode(raw);
    if (decoded is! List) return const [];
    return decoded.whereType<String>().toList();
  }

  Future<void> addRecentSearch(String query) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return;
    final next = [
      trimmed,
      ...recentSearches.where((entry) => entry.toLowerCase() != trimmed.toLowerCase()),
    ].take(8).toList();
    await _prefs.setString(_recentSearchesKey, jsonEncode(next));
  }

  Future<void> clearRecentSearches() => _prefs.remove(_recentSearchesKey);

  bool get notifications => _prefs.getBool(_notificationsKey) ?? true;

  Future<void> setNotifications(bool value) => _prefs.setBool(_notificationsKey, value);

  DownloadQuality get quality {
    final raw = _prefs.getString(_qualityKey);
    if (raw == 'standard') return DownloadQuality.standard;
    return DownloadQuality.high;
  }

  Future<void> setQuality(DownloadQuality value) {
    return _prefs.setString(_qualityKey, value == DownloadQuality.standard ? 'standard' : 'high');
  }

  AppThemePreference get theme {
    switch (_prefs.getString(_themeKey)) {
      case 'light':
        return AppThemePreference.light;
      case 'system':
        return AppThemePreference.system;
      case 'dark':
        return AppThemePreference.dark;
      default:
        final legacyDark = _prefs.getBool(_darkModeKey);
        if (legacyDark == false) return AppThemePreference.light;
        return AppThemePreference.dark;
    }
  }

  Future<void> setTheme(AppThemePreference value) {
    final raw = switch (value) {
      AppThemePreference.system => 'system',
      AppThemePreference.dark => 'dark',
      AppThemePreference.light => 'light',
    };
    return _prefs.setString(_themeKey, raw);
  }

  bool get autoplayPreviews => _prefs.getBool(_autoplayKey) ?? true;

  Future<void> setAutoplayPreviews(bool value) => _prefs.setBool(_autoplayKey, value);

  Future<void> clearPersonalData() async {
    await _prefs.remove(_favoritesKey);
    await _prefs.remove(_downloadsKey);
    await _prefs.remove(_sharesKey);
    await _prefs.remove(_recentSearchesKey);
  }
}
