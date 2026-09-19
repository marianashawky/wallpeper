import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class LocalStore {
  LocalStore(this._prefs);

  final SharedPreferences _prefs;

  static const _favoritesKey = 'favorites';
  static const _downloadsKey = 'downloads';
  static const _sharesKey = 'shares';
  static const _recentSearchesKey = 'recent_searches';
  static const _onboardingKey = 'onboarding_done';
  static const _notificationsKey = 'notifications';
  static const _qualityKey = 'download_quality';
  static const _darkModeKey = 'dark_mode';
  static const _profileNameKey = 'profile_name';
  static const _profileHandleKey = 'profile_handle';
  static const _profileBioKey = 'profile_bio';

  Set<String> get favorites => (_prefs.getStringList(_favoritesKey) ?? const []).toSet();

  Future<void> toggleFavorite(String id) async {
    final next = favorites;
    if (!next.add(id)) next.remove(id);
    await _prefs.setStringList(_favoritesKey, next.toList());
  }

  List<String> get downloads => _prefs.getStringList(_downloadsKey) ?? const [];

  Future<void> addDownload(String id) async {
    final next = [id, ...downloads.where((e) => e != id)];
    await _prefs.setStringList(_downloadsKey, next);
  }

  int get shareCount => _prefs.getInt(_sharesKey) ?? 0;

  Future<void> incrementShare() async {
    await _prefs.setInt(_sharesKey, shareCount + 1);
  }

  List<String> get recentSearches {
    final raw = _prefs.getString(_recentSearchesKey);
    if (raw == null) return const ['Champions League Final', 'Haaland 4K', 'Real Madrid Night'];
    return (jsonDecode(raw) as List).cast<String>();
  }

  Future<void> addRecentSearch(String query) async {
    final q = query.trim();
    if (q.isEmpty) return;
    final next = [q, ...recentSearches.where((e) => e.toLowerCase() != q.toLowerCase())].take(8).toList();
    await _prefs.setString(_recentSearchesKey, jsonEncode(next));
  }

  bool get onboardingDone => _prefs.getBool(_onboardingKey) ?? false;
  Future<void> setOnboardingDone() => _prefs.setBool(_onboardingKey, true);

  bool get notifications => _prefs.getBool(_notificationsKey) ?? true;
  Future<void> setNotifications(bool value) => _prefs.setBool(_notificationsKey, value);

  String get quality => _prefs.getString(_qualityKey) ?? '4K Ultra HD';
  Future<void> setQuality(String value) => _prefs.setString(_qualityKey, value);

  bool get darkMode => _prefs.getBool(_darkModeKey) ?? true;
  Future<void> setDarkMode(bool value) => _prefs.setBool(_darkModeKey, value);

  String get profileName => _prefs.getString(_profileNameKey) ?? 'Alex Fernández';
  String get profileHandle => _prefs.getString(_profileHandleKey) ?? '@alexfutbol';
  String get profileBio => _prefs.getString(_profileBioKey) ?? 'Football Fanatic';

  Future<void> setProfile({String? name, String? handle, String? bio}) async {
    if (name != null) await _prefs.setString(_profileNameKey, name);
    if (handle != null) await _prefs.setString(_profileHandleKey, handle);
    if (bio != null) await _prefs.setString(_profileBioKey, bio);
  }

  Future<void> clearLocalData() async {
    await _prefs.remove(_favoritesKey);
    await _prefs.remove(_downloadsKey);
    await _prefs.remove(_sharesKey);
    await _prefs.remove(_recentSearchesKey);
  }
}
