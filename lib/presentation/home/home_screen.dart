import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../data/models/wallpaper.dart';
import '../../state/app_scope.dart';
import '../category/category_screen.dart';
import '../widgets/ad_banner.dart';
import '../widgets/ui_bits.dart';
import '../widgets/wallpaper_cards.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.onOpenWallpaper, required this.onOpenSearch});

  final ValueChanged<Wallpaper> onOpenWallpaper;
  final VoidCallback onOpenSearch;

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 18) return 'Good Afternoon';
    return 'Good Evening';
  }

  @override
  Widget build(BuildContext context) {
    final state = AppStateScope.of(context);
    final repo = state.repository;
    final hero = repo.wallpaperOfTheDay;
    final trending = repo.trending;
    final players = repo.uniqueBySubject(WallpaperCategory.players).take(8).toList();
    final clubs = repo.byCategory(WallpaperCategory.clubs).take(8).toList();
    final newest = repo.newest;

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.only(bottom: 24),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
            child: GreetingHeader(
              kicker: _greeting(),
              title: 'Football Wallpaper',
              trailing: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: AppColors.card,
                    child: IconButton(onPressed: () {}, icon: const Icon(Icons.notifications_none, color: AppColors.textSecondary)),
                  ),
                  const SizedBox(width: 8),
                  const CircleAvatar(backgroundImage: AssetImage('assets/images/branding/app_icon.png')),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
            child: SearchFieldButton(hint: 'Search wallpapers, players, clubs...', onTap: onOpenSearch),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
            child: Row(
              children: [
                const Text('WALLPAPER OF THE DAY', style: TextStyle(color: AppColors.textMuted, letterSpacing: 1.4, fontSize: 11, fontWeight: FontWeight.w700)),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(color: const Color(0x3328A745), borderRadius: BorderRadius.circular(20), border: Border.all(color: AppColors.hot)),
                  child: const Row(
                    children: [
                      Icon(Icons.local_fire_department, size: 14, color: AppColors.hot),
                      SizedBox(width: 4),
                      Text('HOT', style: TextStyle(color: AppColors.hot, fontSize: 11, fontWeight: FontWeight.w800)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: HeroWallpaperCard(
              wallpaper: hero,
              favorite: state.isFavorite(hero.id),
              onTap: () => onOpenWallpaper(hero),
              onFavorite: () => state.toggleFavorite(hero),
              onShare: () => state.share(hero),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 16),
            child: AdBannerSlot(),
          ),
          SectionHeader(title: 'Trending Now', onSeeAll: () => _openCategory(context, WallpaperCategory.players, trending)),
          SizedBox(
            height: 210,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              scrollDirection: Axis.horizontal,
              itemCount: trending.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, i) => WallpaperCard(
                wallpaper: trending[i],
                rank: i + 1,
                onTap: () => onOpenWallpaper(trending[i]),
              ),
            ),
          ),
          SectionHeader(title: 'Popular Players', onSeeAll: () => _openCategory(context, WallpaperCategory.players, repo.byCategory(WallpaperCategory.players))),
          SizedBox(
            height: 120,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              scrollDirection: Axis.horizontal,
              itemCount: players.length,
              separatorBuilder: (_, __) => const SizedBox(width: 14),
              itemBuilder: (context, i) => PlayerChip(wallpaper: players[i], onTap: () => onOpenWallpaper(players[i])),
            ),
          ),
          SectionHeader(title: 'Top Clubs', onSeeAll: () => _openCategory(context, WallpaperCategory.clubs, clubs)),
          SizedBox(
            height: 108,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              scrollDirection: Axis.horizontal,
              itemCount: clubs.length,
              separatorBuilder: (_, __) => const SizedBox(width: 16),
              itemBuilder: (context, i) => ClubChip(wallpaper: clubs[i], onTap: () => onOpenWallpaper(clubs[i])),
            ),
          ),
          SectionHeader(title: 'Trophies & Finals', onSeeAll: () => _openCategory(context, WallpaperCategory.championsLeague, repo.tournaments)),
          SizedBox(
            height: 220,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              scrollDirection: Axis.horizontal,
              itemCount: repo.tournaments.take(8).length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, i) {
                final w = repo.tournaments[i];
                return WallpaperCard(wallpaper: w, width: 160, height: 220, onTap: () => onOpenWallpaper(w));
              },
            ),
          ),
          SectionHeader(title: 'New Wallpapers', onSeeAll: () => _openCategory(context, WallpaperCategory.stadiums, newest)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: newest.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.72,
              ),
              itemBuilder: (context, i) => WallpaperCard(
                wallpaper: newest[i],
                width: double.infinity,
                height: double.infinity,
                onTap: () => onOpenWallpaper(newest[i]),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _openCategory(BuildContext context, WallpaperCategory category, List<Wallpaper> items) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => CategoryScreen(category: category, wallpapers: items),
    ));
  }
}
