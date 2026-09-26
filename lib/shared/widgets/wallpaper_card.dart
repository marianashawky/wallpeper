import 'package:flutter/material.dart';

import '../../core/theme/app_radius.dart';
import '../../features/wallpapers/domain/wallpaper.dart';
import 'wallpaper_image.dart';

class WallpaperCard extends StatelessWidget {
  const WallpaperCard({
    super.key,
    required this.wallpaper,
    required this.heroTag,
    required this.onTap,
    this.width,
  });

  final Wallpaper wallpaper;
  final String heroTag;
  final VoidCallback onTap;
  final double? width;

  @override
  Widget build(BuildContext context) {
    final card = Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: Ink(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(AppRadius.lg)),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.lg),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Hero(
                  tag: heroTag,
                  child: WallpaperImage(wallpaper: wallpaper),
                ),
                const DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0x00000000), Color(0x99000000)],
                      stops: [0.55, 1],
                    ),
                  ),
                ),
                Positioned(
                  left: 10,
                  right: 10,
                  bottom: 10,
                  child: Text(
                    wallpaper.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13),
                  ),
                ),
                if (wallpaper.type != WallpaperType.static || wallpaper.isPremium)
                  Positioned(
                    top: 10,
                    left: 10,
                    child: _Badge(wallpaper: wallpaper),
                  ),
              ],
            ),
          ),
        ),
      ),
    );

    if (width == null) return card;
    return SizedBox(width: width, child: card);
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.wallpaper});

  final Wallpaper wallpaper;

  @override
  Widget build(BuildContext context) {
    final label = wallpaper.isPremium && wallpaper.type == WallpaperType.static ? 'Premium' : wallpaper.typeLabel();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xB3101114),
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Text(label, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600)),
    );
  }
}
