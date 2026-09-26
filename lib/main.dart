import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/app_scope.dart';
import 'app/lumen_app.dart';
import 'core/ads/ad_service.dart';
import 'data/local/local_store.dart';
import 'features/favorites/presentation/favorites_controller.dart';
import 'features/search/presentation/search_history_controller.dart';
import 'features/settings/data/cache_cleaner.dart';
import 'features/settings/presentation/settings_controller.dart';
import 'features/wallpapers/data/download_service.dart';
import 'features/wallpapers/data/mock_wallpaper_repository.dart';
import 'features/wallpapers/data/share_service.dart';
import 'features/wallpapers/data/wallpaper_setter_impl.dart';
import 'features/wallpapers/domain/premium_gate.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  final prefs = await SharedPreferences.getInstance();
  final store = LocalStore(prefs);
  final ads = AdService();
  try {
    await ads.initialize();
  } catch (_) {
    // Ads stay optional when Play services are missing.
  }

  final favorites = FavoritesController(store);
  final settings = SettingsController(store);
  final searchHistory = SearchHistoryController(store);
  await Future.wait([
    favorites.load(),
    settings.load(),
    searchHistory.load(),
  ]);

  final deps = AppDependencies(
    repository: MockWallpaperRepository(),
    favorites: favorites,
    settings: settings,
    searchHistory: searchHistory,
    downloads: DownloadService(store: store),
    share: ShareService(),
    setter: PlatformWallpaperSetter(),
    ads: ads,
    premium: const PremiumGate(),
    cache: CacheCleaner(),
    store: store,
  );

  runApp(LumenApp(deps: deps));
}
