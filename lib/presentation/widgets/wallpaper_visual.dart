import 'package:flutter/material.dart';

import '../../data/models/wallpaper.dart';
import 'animated_3d_overlay.dart';

class WallpaperVisual extends StatelessWidget {
  const WallpaperVisual({
    super.key,
    required this.wallpaper,
    this.fit = BoxFit.cover,
  });

  final Wallpaper wallpaper;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(wallpaper.imagePath, fit: fit, gaplessPlayback: true),
        if (wallpaper.animated) IgnorePointer(child: Animated3dOverlay(seed: wallpaper.id.hashCode)),
      ],
    );
  }
}
