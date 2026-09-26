import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../features/wallpapers/domain/wallpaper.dart';
import 'shimmer_box.dart';

class WallpaperImage extends StatelessWidget {
  const WallpaperImage({
    super.key,
    required this.wallpaper,
    this.thumbnail = true,
    this.fit = BoxFit.cover,
  });

  final Wallpaper wallpaper;
  final bool thumbnail;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    final url = thumbnail ? wallpaper.thumbnailUrl : wallpaper.imageUrl;
    final cacheWidth = _cacheWidth(context);
    if (wallpaper.source == MediaSource.asset) {
      return Image.asset(
        url,
        fit: fit,
        width: double.infinity,
        height: double.infinity,
        cacheWidth: cacheWidth,
        gaplessPlayback: true,
        filterQuality: thumbnail ? FilterQuality.low : FilterQuality.medium,
        frameBuilder: (context, child, frame, loaded) {
          if (loaded || frame != null) return child;
          return const ShimmerBox();
        },
        errorBuilder: (_, __, ___) => const _ImageFallback(),
      );
    }
    return CachedNetworkImage(
      imageUrl: url,
      fit: fit,
      width: double.infinity,
      height: double.infinity,
      memCacheWidth: cacheWidth,
      fadeInDuration: const Duration(milliseconds: 220),
      placeholder: (_, __) => const ShimmerBox(),
      errorWidget: (_, __, ___) => const _ImageFallback(),
    );
  }

  int _cacheWidth(BuildContext context) {
    final dpr = MediaQuery.devicePixelRatioOf(context);
    final logical = thumbnail ? 200.0 : MediaQuery.sizeOf(context).width;
    final width = (logical * dpr).round();
    if (thumbnail && width > 720) return 720;
    if (!thumbnail && width > 1440) return 1440;
    if (width < 1) return 1;
    return width;
  }
}

class _ImageFallback extends StatelessWidget {
  const _ImageFallback();

  @override
  Widget build(BuildContext context) {
    return const ColoredBox(
      color: AppColors.card,
      child: Center(
        child: Icon(Icons.image_not_supported_outlined, color: AppColors.textMuted),
      ),
    );
  }
}
