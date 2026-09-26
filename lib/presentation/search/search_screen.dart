import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../../core/theme/app_colors.dart';
import '../../data/models/wallpaper.dart';
import '../../state/app_scope.dart';
import '../widgets/ui_bits.dart';
import '../widgets/wallpaper_cards.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key, required this.onOpenWallpaper});

  final ValueChanged<Wallpaper> onOpenWallpaper;

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _controller = TextEditingController();
  String _query = '';

  static const trending = [
    'Mbappé 4K',
    'Haaland Celebration',
    'Champions League',
    'El Clásico',
    'Real Madrid Night',
    'Wembley Stadium',
    'Ronaldo Legends',
    'Minimal Football',
  ];

  @override
  Widget build(BuildContext context) {
    final state = AppStateScope.of(context);
    final results = state.repository.search(_query);

    return Material(
      color: AppColors.background,
      child: SafeArea(
        child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        children: [
          const GreetingHeader(kicker: 'Find it', title: 'Search'),
          const SizedBox(height: 16),
          TextField(
            controller: _controller,
            onChanged: (v) => setState(() => _query = v),
            onSubmitted: (v) => state.rememberSearch(v),
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Players, clubs, stadiums…',
              hintStyle: const TextStyle(color: AppColors.textMuted),
              prefixIcon: const Icon(Icons.search, color: AppColors.textMuted),
              filled: true,
              fillColor: AppColors.card,
              contentPadding: const EdgeInsets.symmetric(vertical: 14),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(28), borderSide: const BorderSide(color: AppColors.stroke)),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(28), borderSide: const BorderSide(color: AppColors.stroke)),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(28), borderSide: const BorderSide(color: AppColors.accent)),
            ),
          ),
          if (_query.isEmpty) ...[
            const SizedBox(height: 22),
            const Row(
              children: [
                Icon(Icons.local_fire_department, color: AppColors.hot, size: 18),
                SizedBox(width: 6),
                Text('Trending Searches', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: trending
                  .map((t) => ActionChip(
                        label: Text(t),
                        backgroundColor: AppColors.chip,
                        side: const BorderSide(color: AppColors.stroke),
                        labelStyle: const TextStyle(color: Colors.white),
                        onPressed: () {
                          _controller.text = t;
                          setState(() => _query = t);
                          state.rememberSearch(t);
                        },
                      ))
                  .toList(),
            ),
            const SizedBox(height: 28),
            const Text('Recent Searches', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
            const SizedBox(height: 8),
            ...state.recentSearches.map(
              (s) => Material(
                color: Colors.transparent,
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(s),
                  trailing: const Icon(Icons.add, color: AppColors.textMuted),
                  onTap: () {
                    _controller.text = s;
                    setState(() => _query = s);
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text('Popular Right Now', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
            const SizedBox(height: 12),
            SizedBox(
              height: 210,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: state.repository.trending.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, i) {
                  final w = state.repository.trending[i];
                  return WallpaperCard(wallpaper: w, onTap: () => widget.onOpenWallpaper(w));
                },
              ),
            ),
          ] else ...[
            const SizedBox(height: 16),
            Text('${results.length} results', style: const TextStyle(color: AppColors.textSecondary)),
            const SizedBox(height: 12),
            MasonryGridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: results.length,
              itemBuilder: (context, i) {
                final w = results[i];
                return WallpaperCard(
                  wallpaper: w,
                  width: double.infinity,
                  height: i.isEven ? 230 : 190,
                  onTap: () => widget.onOpenWallpaper(w),
                );
              },
            ),
          ],
        ],
      ),
      ),
    );
  }
}
