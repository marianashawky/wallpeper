import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../data/models/wallpaper.dart';
import 'ui_bits.dart';
import 'wallpaper_visual.dart';

class WallpaperCard extends StatelessWidget {
  const WallpaperCard({
    super.key,
    required this.wallpaper,
    required this.onTap,
    this.width = 148,
    this.height = 210,
    this.showHeart = false,
    this.favorite = false,
    this.onFavorite,
    this.rank,
  });

  final Wallpaper wallpaper;
  final VoidCallback onTap;
  final double width;
  final double height;
  final bool showHeart;
  final bool favorite;
  final VoidCallback? onFavorite;
  final int? rank;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: width,
        height: height,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            fit: StackFit.expand,
            children: [
              WallpaperVisual(wallpaper: wallpaper, lite: true),
              const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Color(0xCC000000)],
                  ),
                ),
              ),
              if (wallpaper.animated)
                Positioned(
                  top: 8,
                  left: rank == null ? 8 : 34,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(color: AppColors.accent, borderRadius: BorderRadius.circular(10)),
                    child: const Text('LIVE', style: TextStyle(color: Colors.black, fontSize: 10, fontWeight: FontWeight.w800)),
                  ),
                ),
              if (rank != null)
                Positioned(
                  top: 8,
                  left: 8,
                  child: CircleAvatar(
                    radius: 11,
                    backgroundColor: AppColors.accent,
                    child: Text('$rank', style: const TextStyle(color: Colors.black, fontSize: 11, fontWeight: FontWeight.w800)),
                  ),
                ),
              if (showHeart)
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: onFavorite,
                    child: CircleAvatar(
                      radius: 16,
                      backgroundColor: Colors.black45,
                      child: Icon(favorite ? Icons.favorite : Icons.favorite_border, color: favorite ? AppColors.heart : Colors.white, size: 16),
                    ),
                  ),
                ),
              Positioned(
                left: 10,
                right: 10,
                bottom: 10,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(wallpaper.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13)),
                    Text(wallpaper.category.label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 11)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HeroWallpaperCard extends StatelessWidget {
  const HeroWallpaperCard({
    super.key,
    required this.wallpaper,
    required this.favorite,
    required this.onTap,
    required this.onFavorite,
    required this.onShare,
  });

  final Wallpaper wallpaper;
  final bool favorite;
  final VoidCallback onTap;
  final VoidCallback onFavorite;
  final VoidCallback onShare;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 280,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.45), blurRadius: 24, offset: const Offset(0, 12))],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Stack(
            fit: StackFit.expand,
            children: [
              WallpaperVisual(wallpaper: wallpaper, lite: true),
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0x33000000), Color(0xCC000000)],
                ),
              ),
            ),
            Positioned(
              top: 14,
              left: 14,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(color: AppColors.accent, borderRadius: BorderRadius.circular(20)),
                child: Text('#${wallpaper.tags.first}', style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w800, fontSize: 12)),
              ),
            ),
            Positioned(
              top: 10,
              right: 10,
              child: IconButton.filledTonal(
                onPressed: onFavorite,
                style: IconButton.styleFrom(backgroundColor: Colors.black45),
                icon: Icon(favorite ? Icons.favorite : Icons.favorite_border, color: favorite ? AppColors.heart : Colors.white),
              ),
            ),
            Positioned(
              left: 16,
              right: 16,
              bottom: 16,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(wallpaper.title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800)),
                        Text(wallpaper.subtitle, style: const TextStyle(color: AppColors.textSecondary)),
                        const SizedBox(height: 6),
                        Text(
                          '${formatCount(wallpaper.downloads)} downloads   ❤ ${formatCount(wallpaper.likes)}',
                          style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  IconButton.filledTonal(
                    onPressed: onShare,
                    style: IconButton.styleFrom(backgroundColor: Colors.white24),
                    icon: const Icon(Icons.ios_share, color: Colors.white),
                  ),
                ],
              ),
            ),
          ],
        ),
        ),
      ),
    );
  }
}

class PlayerChip extends StatelessWidget {
  const PlayerChip({super.key, required this.wallpaper, required this.onTap});

  final Wallpaper wallpaper;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 86,
        child: Column(
          children: [
            CircleAvatar(
              radius: 36,
              backgroundColor: AppColors.accent.withValues(alpha: 0.25),
              child: CircleAvatar(radius: 33, backgroundImage: AssetImage(wallpaper.imagePath)),
            ),
            const SizedBox(height: 8),
            Text(wallpaper.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
            Text(
              wallpaper.clubName.isNotEmpty ? wallpaper.clubName : wallpaper.subtitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: AppColors.textMuted, fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }
}

class ClubChip extends StatelessWidget {
  const ClubChip({super.key, required this.wallpaper, required this.onTap});

  final Wallpaper wallpaper;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(radius: 30, backgroundImage: AssetImage(wallpaper.imagePath)),
          const SizedBox(height: 8),
          Text(wallpaper.title, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
