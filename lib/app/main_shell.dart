import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../features/explore/presentation/explore_screen.dart';
import '../features/favorites/presentation/favorites_screen.dart';
import '../features/home/presentation/home_screen.dart';
import '../features/settings/presentation/settings_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;
  final Set<int> _built = {0};

  void _select(int index) {
    setState(() {
      _index = index;
      _built.add(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final pages = <int, Widget>{
      0: HomeScreen(onFavorites: () => _select(2)),
      1: const ExploreScreen(),
      2: FavoritesScreen(onExplore: () => _select(1)),
      3: const SettingsScreen(),
    };
    return Scaffold(
      body: Stack(
        children: [
          for (final index in _built)
            Offstage(
              offstage: _index != index,
              child: TickerMode(
                enabled: _index == index,
                child: pages[index]!,
              ),
            ),
        ],
      ),
      bottomNavigationBar: _BottomNav(index: _index, onSelect: _select),
    );
  }
}

class _BottomNav extends StatelessWidget {
  const _BottomNav({required this.index, required this.onSelect});

  final int index;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final background = dark ? const Color(0xF20B0C10) : Colors.white;
    final inactive = dark ? AppColors.navInactive : AppColors.lightNavInactive;
    final active = dark ? AppColors.accent : AppColors.lightText;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: background,
        border: Border(top: BorderSide(color: Theme.of(context).dividerColor)),
      ),
      child: SafeArea(
        child: SizedBox(
          height: 64,
          child: Row(
            children: [
              _Item(icon: Icons.home_outlined, selectedIcon: Icons.home_rounded, label: 'Home', selected: index == 0, active: active, inactive: inactive, onTap: () => onSelect(0)),
              _Item(icon: Icons.explore_outlined, selectedIcon: Icons.explore, label: 'Explore', selected: index == 1, active: active, inactive: inactive, onTap: () => onSelect(1)),
              _Item(icon: Icons.favorite_border, selectedIcon: Icons.favorite, label: 'Favorites', selected: index == 2, active: active, inactive: inactive, onTap: () => onSelect(2)),
              _Item(icon: Icons.settings_outlined, selectedIcon: Icons.settings, label: 'Settings', selected: index == 3, active: active, inactive: inactive, onTap: () => onSelect(3)),
            ],
          ),
        ),
      ),
    );
  }
}

class _Item extends StatelessWidget {
  const _Item({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    required this.selected,
    required this.active,
    required this.inactive,
    required this.onTap,
  });

  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final bool selected;
  final Color active;
  final Color inactive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? active : inactive;
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: selected ? 18 : 0,
              height: 3,
              margin: const EdgeInsets.only(bottom: 4),
              decoration: BoxDecoration(color: active, borderRadius: BorderRadius.circular(99)),
            ),
            Icon(selected ? selectedIcon : icon, color: color, size: 24),
            const SizedBox(height: 2),
            Text(label, style: TextStyle(color: color, fontSize: 11, fontWeight: selected ? FontWeight.w700 : FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}
