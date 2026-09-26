import 'package:flutter/material.dart';

import '../../../app/app_scope.dart';
import '../../../app/navigation.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/widgets/shimmer_box.dart';
import '../../../shared/widgets/state_views.dart';
import '../../../shared/widgets/wallpaper_masonry.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key, required this.onExplore});

  final VoidCallback onExplore;

  @override
  Widget build(BuildContext context) {
    final deps = AppScope.of(context);
    final padding = AppSpacing.page(MediaQuery.sizeOf(context).width);
    return ShimmerScope(
      child: SafeArea(
        child: ListenableBuilder(
          listenable: deps.favorites,
          builder: (context, _) {
            final items = deps.repository.byIds(deps.favorites.ids);
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(padding, AppSpacing.md, padding, AppSpacing.sm),
                  child: Text('Favorites', style: Theme.of(context).textTheme.headlineMedium),
                ),
                Expanded(
                  child: items.isEmpty
                      ? EmptyState(
                          icon: Icons.favorite_border,
                          title: 'No favorites yet',
                          message: 'Save wallpapers you want to come back to. They stay on this device.',
                          action: FilledButton(onPressed: onExplore, child: const Text('Explore')),
                        )
                      : WallpaperMasonry(
                          wallpapers: items,
                          heroPrefix: 'favorites',
                          padding: EdgeInsets.fromLTRB(padding, 0, padding, AppSpacing.xl),
                          onOpen: (wallpaper, tag) => openWallpaper(context, wallpaper, heroTag: tag),
                        ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
