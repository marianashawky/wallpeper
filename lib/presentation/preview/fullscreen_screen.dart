import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

import '../../core/theme/app_colors.dart';
import '../../data/models/wallpaper.dart';
import '../../state/app_scope.dart';
import '../widgets/wallpaper_visual.dart';

class FullscreenScreen extends StatelessWidget {
  const FullscreenScreen({super.key, required this.wallpaper});

  final Wallpaper wallpaper;

  @override
  Widget build(BuildContext context) {
    final state = AppStateScope.of(context);
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          if (wallpaper.animated)
            WallpaperVisual(wallpaper: wallpaper)
          else
            PhotoView(
              imageProvider: AssetImage(wallpaper.imagePath),
              minScale: PhotoViewComputedScale.contained,
              maxScale: PhotoViewComputedScale.covered * 2.4,
              backgroundDecoration: const BoxDecoration(color: Colors.black),
            ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.black45,
                    child: IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_back, color: Colors.white)),
                  ),
                  const Spacer(),
                  Text(wallpaper.title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                  const Spacer(),
                  CircleAvatar(
                    backgroundColor: Colors.black45,
                    child: IconButton(
                      onPressed: () => state.toggleFavorite(wallpaper),
                      icon: Icon(state.isFavorite(wallpaper.id) ? Icons.favorite : Icons.favorite_border, color: state.isFavorite(wallpaper.id) ? AppColors.heart : Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 16,
            right: 16,
            bottom: 28,
            child: Row(
              children: [
                _btn(Icons.favorite_border, 'Favorite', () => state.toggleFavorite(wallpaper)),
                _btn(Icons.download, 'Download', () async {
                  final err = await state.download(wallpaper);
                  if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(err ?? 'Saved to gallery')));
                }),
                _btn(Icons.smartphone, 'Set Wallpaper', () async {
                  final err = await state.setWallpaper(wallpaper);
                  if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(err ?? 'Wallpaper set')));
                }),
                _btn(Icons.ios_share, 'Share', () => state.share(wallpaper)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _btn(IconData icon, String label, VoidCallback onTap) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Material(
          color: Colors.black45,
          borderRadius: BorderRadius.circular(16),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 14),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, color: Colors.white),
                  const SizedBox(height: 6),
                  Text(label, style: const TextStyle(fontSize: 11)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
