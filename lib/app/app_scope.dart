import 'package:flutter/widgets.dart';

import '../core/ads/ad_service.dart';
import '../data/local/local_store.dart';
import '../features/favorites/presentation/favorites_controller.dart';
import '../features/search/presentation/search_history_controller.dart';
import '../features/settings/data/cache_cleaner.dart';
import '../features/settings/presentation/settings_controller.dart';
import '../features/wallpapers/data/download_service.dart';
import '../features/wallpapers/data/share_service.dart';
import '../features/wallpapers/domain/premium_gate.dart';
import '../features/wallpapers/domain/wallpaper_repository.dart';
import '../features/wallpapers/domain/wallpaper_setter.dart';

class AppDependencies {
  const AppDependencies({
    required this.repository,
    required this.favorites,
    required this.settings,
    required this.searchHistory,
    required this.downloads,
    required this.share,
    required this.setter,
    required this.ads,
    required this.premium,
    required this.cache,
    required this.store,
  });

  final WallpaperRepository repository;
  final FavoritesController favorites;
  final SettingsController settings;
  final SearchHistoryController searchHistory;
  final DownloadService downloads;
  final ShareService share;
  final WallpaperSetter setter;
  final AdService ads;
  final PremiumGate premium;
  final CacheCleaner cache;
  final LocalStore store;
}

class AppScope extends InheritedWidget {
  const AppScope({super.key, required this.deps, required super.child});

  final AppDependencies deps;

  static AppDependencies of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AppScope>();
    assert(scope != null, 'AppScope not found');
    return scope!.deps;
  }

  @override
  bool updateShouldNotify(AppScope oldWidget) => false;
}
