import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../data/models/wallpaper.dart';
import '../preview/preview_screen.dart';
import '../widgets/wallpaper_cards.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key, required this.category, required this.wallpapers});

  final WallpaperCategory category;
  final List<Wallpaper> wallpapers;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: Text(category.label)),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: wallpapers.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 0.72,
        ),
        itemBuilder: (context, i) {
          final w = wallpapers[i];
          return WallpaperCard(
            wallpaper: w,
            width: double.infinity,
            height: double.infinity,
            onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => PreviewScreen(wallpaper: w))),
          );
        },
      ),
    );
  }
}
