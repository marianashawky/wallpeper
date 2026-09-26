import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../../core/theme/app_colors.dart';
import '../../data/models/wallpaper.dart';
import '../../state/app_scope.dart';
import '../widgets/ui_bits.dart';
import '../widgets/wallpaper_cards.dart';

class SavedScreen extends StatelessWidget {
  const SavedScreen({super.key, required this.onOpenWallpaper, required this.onExplore});

  final ValueChanged<Wallpaper> onOpenWallpaper;
  final VoidCallback onExplore;

  @override
  Widget build(BuildContext context) {
    final state = AppStateScope.of(context);
    final items = state.favoriteWallpapers;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
        child: Column(
          children: [
            GreetingHeader(
              kicker: 'Your Collection',
              title: 'Favorites',
              trailing: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.stroke),
                ),
                child: Text('${items.length} saved', style: const TextStyle(color: AppColors.accent, fontWeight: FontWeight.w700)),
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: items.isEmpty
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const CircleAvatar(
                          radius: 42,
                          backgroundColor: AppColors.card,
                          child: Icon(Icons.favorite_border, size: 32, color: AppColors.textSecondary),
                        ),
                        const SizedBox(height: 18),
                        const Text('No favorites yet', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
                        const SizedBox(height: 8),
                        const Text('Tap the ❤ on any wallpaper to save it here', style: TextStyle(color: AppColors.textSecondary)),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: 220,
                          child: GlowButton(label: 'EXPLORE WALLPAPERS', onPressed: onExplore),
                        ),
                      ],
                    )
                  : MasonryGridView.count(
                      crossAxisCount: 2,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      itemCount: items.length,
                      itemBuilder: (context, i) {
                        final w = items[i];
                        return WallpaperCard(
                          wallpaper: w,
                          width: double.infinity,
                          height: i.isEven ? 240 : 200,
                          showHeart: true,
                          favorite: true,
                          onFavorite: () => state.toggleFavorite(w),
                          onTap: () => onOpenWallpaper(w),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
