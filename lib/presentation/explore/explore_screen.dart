import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../data/models/wallpaper.dart';
import '../../state/app_scope.dart';
import '../category/category_screen.dart';
import '../widgets/live_wallpaper_visual.dart';
import '../widgets/ui_bits.dart';
import '../widgets/wallpaper_cards.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key, required this.onOpenWallpaper});

  final ValueChanged<Wallpaper> onOpenWallpaper;


  @override
  Widget build(BuildContext context) {
    final state = AppStateScope.of(context);
    final cats = WallpaperCategory.values;

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        children: [
          const GreetingHeader(kicker: 'Discover', title: 'Explore'),
          const SizedBox(height: 8),
          const Text('Browse by league, club, player and trophy', style: TextStyle(color: AppColors.textSecondary)),
          const SizedBox(height: 18),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: cats.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.55,
            ),
            itemBuilder: (context, i) {
              final cat = cats[i];
              return GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => CategoryScreen(category: cat, wallpapers: state.repository.byCategory(cat)),
                  ));
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      DecoratedBox(
                        decoration: BoxDecoration(
                          color: AppColors.card,
                          image: DecorationImage(
                            image: AssetImage(cat.thumbnail),
                            fit: BoxFit.cover,
                            colorFilter: ColorFilter.mode(Colors.black.withValues(alpha: 0.55), BlendMode.darken),
                          ),
                        ),
                      ),
                      if (cat == WallpaperCategory.art3d)
                        const IgnorePointer(
                          child: LiveWallpaperVisual(
                            imagePath: 'assets/images/categories/3d.jpg',
                            seed: 42,
                            lite: true,
                          ),
                        ),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(cat.label, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                            Text('${state.repository.countFor(cat)} walls', style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 22),
          Text('Trending picks', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: state.repository.trending.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 0.72,
            ),
            itemBuilder: (context, i) => WallpaperCard(
              wallpaper: state.repository.trending[i],
              width: double.infinity,
              height: double.infinity,
              onTap: () => onOpenWallpaper(state.repository.trending[i]),
            ),
          ),
        ],
      ),
    );
  }
}
