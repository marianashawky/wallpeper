import 'package:flutter/material.dart';

import '../../app/app_scope.dart';
import '../../core/theme/app_colors.dart';

class FavoriteButton extends StatelessWidget {
  const FavoriteButton({super.key, required this.wallpaperId, this.size = 22});

  final String wallpaperId;
  final double size;

  @override
  Widget build(BuildContext context) {
    final favorites = AppScope.of(context).favorites;
    return ListenableBuilder(
      listenable: favorites,
      builder: (context, _) {
        return _Heart(
          selected: favorites.isFavorite(wallpaperId),
          size: size,
          onPressed: () => favorites.toggle(wallpaperId),
        );
      },
    );
  }
}

class _Heart extends StatefulWidget {
  const _Heart({required this.selected, required this.onPressed, required this.size});

  final bool selected;
  final VoidCallback onPressed;
  final double size;

  @override
  State<_Heart> createState() => _HeartState();
}

class _HeartState extends State<_Heart> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 280),
  );

  @override
  void didUpdateWidget(_Heart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selected != oldWidget.selected) {
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final t = _controller.value;
        final scale = 1 + (0.22 * (t < 0.5 ? t * 2 : (1 - t) * 2));
        return Transform.scale(scale: scale, child: child);
      },
      child: IconButton(
        onPressed: widget.onPressed,
        tooltip: widget.selected ? 'Remove favorite' : 'Add favorite',
        icon: Icon(
          widget.selected ? Icons.favorite : Icons.favorite_border,
          color: widget.selected ? AppColors.heart : Colors.white,
          size: widget.size,
        ),
      ),
    );
  }
}
