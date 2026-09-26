import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/theme/app_colors.dart';
import '../../data/models/wallpaper.dart';
import '../../state/app_scope.dart';
import '../widgets/ui_bits.dart';
import '../widgets/wallpaper_cards.dart';
import '../widgets/wallpaper_visual.dart';
import 'fullscreen_screen.dart';

class PreviewScreen extends StatelessWidget {
  const PreviewScreen({super.key, required this.wallpaper});

  final Wallpaper wallpaper;

  @override
  Widget build(BuildContext context) {
    final state = AppStateScope.of(context);
    final related = state.repository.related(wallpaper);

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          children: [
            Row(
              children: [
                _round(Icons.arrow_back, () => Navigator.pop(context)),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.stroke),
                    color: AppColors.card,
                  ),
                  child: Text(wallpaper.category.label),
                ),
                const Spacer(),
                _round(Icons.ios_share, () => state.share(wallpaper)),
              ],
            ),
            const SizedBox(height: 18),
            Center(
              child: GestureDetector(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => FullscreenScreen(wallpaper: wallpaper))),
                child: Container(
                  width: 210,
                  height: 390,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(36),
                    border: Border.all(color: const Color(0xFF3A4250), width: 6),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: WallpaperVisual(wallpaper: wallpaper),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: TextButton.icon(
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => FullscreenScreen(wallpaper: wallpaper))),
                icon: const Icon(Icons.open_in_full, size: 16, color: AppColors.textSecondary),
                label: const Text('Fullscreen', style: TextStyle(color: AppColors.textSecondary)),
              ),
            ),
            Text(wallpaper.title, textAlign: TextAlign.center, style: GoogleFonts.inter(fontSize: 32, fontWeight: FontWeight.w800)),
            Text(
              [
                wallpaper.subtitle,
                if (wallpaper.clubName.isNotEmpty) wallpaper.clubName,
                wallpaper.subject,
              ].where((e) => e.isNotEmpty).toSet().join('  •  '),
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.textSecondary, fontSize: 15),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _metric(formatCount(wallpaper.downloads), 'Downloads'),
                const SizedBox(width: 8),
                _metric(formatCount(wallpaper.likes), 'Likes'),
                const SizedBox(width: 8),
                _metric(formatCount(wallpaper.views), 'Views'),
              ],
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              children: wallpaper.tags
                  .take(4)
                  .map((t) => Chip(
                        label: Text(t, style: const TextStyle(fontSize: 12)),
                        backgroundColor: AppColors.chip,
                        side: BorderSide.none,
                      ))
                  .toList(),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _action(Icons.favorite, 'Saved', () => state.toggleFavorite(wallpaper), filled: state.isFavorite(wallpaper.id)),
                _action(Icons.download, 'Download', () async {
                  final err = await state.download(wallpaper);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(err ?? 'Saved to gallery')));
                  }
                }),
                _action(Icons.wallpaper, 'Set Wall', () async {
                  final err = await state.setWallpaper(wallpaper);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(err ?? 'Wallpaper set')));
                  }
                }),
                _action(Icons.ios_share, 'Share', () => state.share(wallpaper)),
              ],
            ),
            const SizedBox(height: 12),
            GlowButton(
              label: '⬇  DOWNLOAD FREE',
              onPressed: () async {
                final err = await state.download(wallpaper);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(err ?? 'Saved to gallery')));
                }
              },
            ),
            const SizedBox(height: 24),
            const Text('More Like This', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
            const SizedBox(height: 12),
            SizedBox(
              height: 210,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: related.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, i) => WallpaperCard(
                  wallpaper: related[i],
                  onTap: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => PreviewScreen(wallpaper: related[i]))),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _round(IconData icon, VoidCallback onTap) {
    return CircleAvatar(
      backgroundColor: AppColors.card,
      child: IconButton(onPressed: onTap, icon: Icon(icon, color: Colors.white)),
    );
  }

  Widget _metric(String value, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.stroke)),
        child: Column(
          children: [
            Text(value, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
            Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Widget _action(IconData icon, String label, VoidCallback onTap, {bool filled = false}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Column(
          children: [
            IconButton.filledTonal(
              onPressed: onTap,
              style: IconButton.styleFrom(backgroundColor: filled ? AppColors.heart.withValues(alpha: 0.2) : AppColors.card),
              icon: Icon(icon, color: filled ? AppColors.heart : Colors.white),
            ),
            Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
          ],
        ),
      ),
    );
  }
}
