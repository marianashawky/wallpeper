import 'package:animations/animations.dart';
import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../data/models/wallpaper.dart';
import '../../state/app_scope.dart';
import '../explore/explore_screen.dart';
import '../home/home_screen.dart';
import '../preview/preview_screen.dart';
import '../profile/profile_screen.dart';
import '../saved/saved_screen.dart';
import '../search/search_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key, this.initialIndex = 0});

  final int initialIndex;

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  late int _index = widget.initialIndex;

  void openWallpaper(Wallpaper wallpaper) {
    Navigator.of(context).push(PageRouteBuilder(
      pageBuilder: (_, a, __) => FadeTransition(opacity: a, child: PreviewScreen(wallpaper: wallpaper)),
      transitionDuration: const Duration(milliseconds: 280),
    ));
  }

  void openSearch() => setState(() => _index = 2);

  @override
  Widget build(BuildContext context) {
    AppStateScope.of(context);
    final Widget page;
    switch (_index) {
      case 1:
        page = ExploreScreen(onOpenWallpaper: openWallpaper);
      case 2:
        page = SearchScreen(onOpenWallpaper: openWallpaper);
      case 3:
        page = SavedScreen(onOpenWallpaper: openWallpaper, onExplore: () => setState(() => _index = 1));
      case 4:
        page = ProfileScreen(onOpenFavorites: () => setState(() => _index = 3));
      default:
        page = HomeScreen(onOpenWallpaper: openWallpaper, onOpenSearch: openSearch);
    }

    return Scaffold(
      body: PageTransitionSwitcher(
        duration: const Duration(milliseconds: 280),
        transitionBuilder: (child, animation, secondaryAnimation) {
          return FadeThroughTransition(
            animation: animation,
            secondaryAnimation: secondaryAnimation,
            fillColor: AppColors.background,
            child: child,
          );
        },
        child: KeyedSubtree(key: ValueKey(_index), child: page),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Color(0xF2020407),
          border: Border(top: BorderSide(color: AppColors.stroke)),
        ),
        child: SafeArea(
          child: SizedBox(
            height: 64,
            child: Row(
              children: [
                _NavItem(icon: Icons.home_rounded, label: 'Home', selected: _index == 0, onTap: () => setState(() => _index = 0)),
                _NavItem(icon: Icons.explore_outlined, label: 'Explore', selected: _index == 1, onTap: () => setState(() => _index = 1)),
                _NavItem(icon: Icons.search, label: 'Search', selected: _index == 2, onTap: () => setState(() => _index = 2)),
                _NavItem(icon: Icons.favorite_border, selectedIcon: Icons.favorite, label: 'Saved', selected: _index == 3, onTap: () => setState(() => _index = 3)),
                _NavItem(icon: Icons.person_outline, selectedIcon: Icons.person, label: 'Profile', selected: _index == 4, onTap: () => setState(() => _index = 4)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
    this.selectedIcon,
  });

  final IconData icon;
  final IconData? selectedIcon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppColors.accent : AppColors.navInactive;
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (selected) Container(width: 6, height: 6, decoration: const BoxDecoration(color: AppColors.accent, shape: BoxShape.circle)),
            if (selected) const SizedBox(height: 2),
            Icon(selected ? (selectedIcon ?? icon) : icon, color: color, size: selected ? 26 : 24),
            const SizedBox(height: 2),
            Text(label, style: TextStyle(color: color, fontSize: 11, fontWeight: selected ? FontWeight.w700 : FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}
