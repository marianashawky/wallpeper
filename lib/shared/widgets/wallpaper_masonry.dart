import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../../core/theme/app_spacing.dart';
import '../../core/utils/layout.dart';
import '../../features/wallpapers/domain/wallpaper.dart';
import 'wallpaper_card.dart';

class WallpaperMasonry extends StatelessWidget {
  const WallpaperMasonry({
    super.key,
    required this.wallpapers,
    required this.onOpen,
    required this.heroPrefix,
    this.padding = EdgeInsets.zero,
    this.shrinkWrap = false,
    this.physics,
    this.controller,
  });

  final List<Wallpaper> wallpapers;
  final void Function(Wallpaper wallpaper, String heroTag) onOpen;
  final String heroPrefix;
  final EdgeInsets padding;
  final bool shrinkWrap;
  final ScrollPhysics? physics;
  final ScrollController? controller;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        return MasonryGridView.count(
          controller: controller,
          shrinkWrap: shrinkWrap,
          physics: physics,
          padding: padding,
          crossAxisCount: AppLayout.gridColumns(width),
          mainAxisSpacing: AppSpacing.sm,
          crossAxisSpacing: AppSpacing.sm,
          itemCount: wallpapers.length,
          itemBuilder: (context, index) {
            final wallpaper = wallpapers[index];
            final heroTag = '$heroPrefix-${wallpaper.id}-$index';
            return RepaintBoundary(
              child: AspectRatio(
                aspectRatio: AppLayout.tileAspect(index),
                child: WallpaperCard(
                  wallpaper: wallpaper,
                  heroTag: heroTag,
                  onTap: () => onOpen(wallpaper, heroTag),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class WallpaperCarousel extends StatelessWidget {
  const WallpaperCarousel({
    super.key,
    required this.wallpapers,
    required this.onOpen,
    required this.heroPrefix,
  });

  final List<Wallpaper> wallpapers;
  final void Function(Wallpaper wallpaper, String heroTag) onOpen;
  final String heroPrefix;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cardWidth = AppLayout.carouselCardWidth(constraints.maxWidth);
        final height = cardWidth * 1.45;
        return SizedBox(
          height: height,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: wallpapers.length,
            separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.sm),
            itemBuilder: (context, index) {
              final wallpaper = wallpapers[index];
              final heroTag = '$heroPrefix-${wallpaper.id}';
              return WallpaperCard(
                wallpaper: wallpaper,
                heroTag: heroTag,
                width: cardWidth,
                onTap: () => onOpen(wallpaper, heroTag),
              );
            },
          ),
        );
      },
    );
  }
}
