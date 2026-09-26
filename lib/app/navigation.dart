import 'package:flutter/material.dart';

import '../features/categories/domain/wallpaper_category.dart';
import '../features/search/presentation/search_screen.dart';
import '../features/wallpapers/domain/wallpaper.dart';
import '../features/wallpapers/presentation/category_screen.dart';
import '../features/wallpapers/presentation/wallpaper_detail_screen.dart';

Future<void> openWallpaper(BuildContext context, Wallpaper wallpaper, {required String heroTag}) {
  return Navigator.of(context).push(
    PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 420),
      reverseTransitionDuration: const Duration(milliseconds: 320),
      pageBuilder: (context, animation, _) {
        return FadeTransition(
          opacity: animation,
          child: WallpaperDetailScreen(wallpaper: wallpaper, heroTag: heroTag),
        );
      },
    ),
  );
}

Future<void> openCategory(BuildContext context, WallpaperCategory category) {
  return Navigator.of(context).push(
    PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 280),
      pageBuilder: (context, animation, _) {
        return FadeTransition(
          opacity: animation,
          child: CategoryScreen(categoryId: category.id),
        );
      },
    ),
  );
}

Future<void> openSearch(BuildContext context) {
  return Navigator.of(context).push(
    PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 240),
      pageBuilder: (context, animation, _) {
        return FadeTransition(opacity: animation, child: const SearchScreen());
      },
    ),
  );
}
