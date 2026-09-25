import 'package:flutter/material.dart';

import '../../data/models/wallpaper.dart';
import 'live_wallpaper_visual.dart';

class WallpaperVisual extends StatelessWidget {
  const WallpaperVisual({
    super.key,
    required this.wallpaper,
    this.fit = BoxFit.cover,
    this.lite = false,
  });

  final Wallpaper wallpaper;
  final BoxFit fit;
  final bool lite;

  @override
  Widget build(BuildContext context) {
    if (wallpaper.animated) {
      return LiveWallpaperVisual(
        imagePath: wallpaper.imagePath,
        seed: wallpaper.id.hashCode,
        lite: lite,
      );
    }
    return Image.asset(wallpaper.imagePath, fit: fit, gaplessPlayback: true);
  }
}
