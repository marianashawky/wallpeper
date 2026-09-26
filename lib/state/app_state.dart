import 'package:flutter/foundation.dart';

import '../core/ads/ad_service.dart';
import '../data/catalog/wallpaper_catalog.dart';
import '../data/local/local_store.dart';
import '../data/models/wallpaper.dart';
import '../services/wallpaper_actions.dart';

class AppState extends ChangeNotifier {
  AppState({
    required this.store,
    required this.ads,
    WallpaperRepository? repository,
    WallpaperActions? actions,
  })  : repository = repository ?? WallpaperRepository(),
        actions = actions ?? WallpaperActions();

  final LocalStore store;
  final AdService ads;
  final WallpaperRepository repository;
  final WallpaperActions actions;

  Set<String> favorites = {};
  List<String> downloads = [];
  List<String> recentSearches = [];
  int shareCount = 0;
  bool notifications = true;
  bool darkMode = true;
  String quality = '4K Ultra HD';
  String profileName = 'Alex Fernández';
  String profileHandle = '@alexfutbol';
  String profileBio = 'Football Fanatic';

  Future<void> load() async {
    favorites = store.favorites;
    downloads = store.downloads;
    recentSearches = store.recentSearches;
    shareCount = store.shareCount;
    notifications = store.notifications;
    darkMode = store.darkMode;
    quality = store.quality;
    profileName = store.profileName;
    profileHandle = store.profileHandle;
    profileBio = store.profileBio;
    notifyListeners();
  }

  bool isFavorite(String id) => favorites.contains(id);

  Future<void> toggleFavorite(Wallpaper wallpaper) async {
    await store.toggleFavorite(wallpaper.id);
    favorites = store.favorites;
    notifyListeners();
  }

  Future<String?> download(Wallpaper wallpaper) async {
    final ok = await actions.download(wallpaper);
    if (!ok) return 'Could not save wallpaper. Check gallery permission.';
    await store.addDownload(wallpaper.id);
    downloads = store.downloads;
    notifyListeners();
    await ads.maybeShowInterstitial();
    return null;
  }

  Future<void> share(Wallpaper wallpaper) async {
    await actions.share(wallpaper);
    await store.incrementShare();
    shareCount = store.shareCount;
    notifyListeners();
  }

  Future<String?> setWallpaper(Wallpaper wallpaper) async {
    final status = await actions.setWallpaper(wallpaper);
    if (status == 'fail') {
      return 'Could not set wallpaper. Try again from the system picker.';
    }
    await store.addDownload(wallpaper.id);
    downloads = store.downloads;
    notifyListeners();
    if (status == 'picker') {
      return 'On the next screen choose Football Live so it stays animated.';
    }
    return wallpaper.animated ? 'Live wallpaper updated.' : null;
  }

  Future<void> rememberSearch(String query) async {
    await store.addRecentSearch(query);
    recentSearches = store.recentSearches;
    notifyListeners();
  }

  Future<void> setNotifications(bool value) async {
    notifications = value;
    await store.setNotifications(value);
    notifyListeners();
  }

  Future<void> setDarkMode(bool value) async {
    darkMode = value;
    await store.setDarkMode(value);
    notifyListeners();
  }

  Future<void> setQuality(String value) async {
    quality = value;
    await store.setQuality(value);
    notifyListeners();
  }

  Future<void> updateProfile({String? name, String? handle, String? bio}) async {
    await store.setProfile(name: name, handle: handle, bio: bio);
    profileName = store.profileName;
    profileHandle = store.profileHandle;
    profileBio = store.profileBio;
    notifyListeners();
  }

  Future<void> resetLocal() async {
    await store.clearLocalData();
    await load();
  }

  List<Wallpaper> get favoriteWallpapers =>
      repository.all.where((w) => favorites.contains(w.id)).toList();

  List<Wallpaper> get downloadedWallpapers =>
      downloads.map(repository.byId).whereType<Wallpaper>().toList();
}
