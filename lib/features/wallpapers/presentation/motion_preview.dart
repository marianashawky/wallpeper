import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../shared/widgets/wallpaper_image.dart';
import '../domain/wallpaper.dart';

/// In-app preview of the same slow pan the Android live wallpaper service draws.
/// Grids stay on still thumbnails so only the open preview animates.
class MotionPreview extends StatefulWidget {
  const MotionPreview({super.key, required this.wallpaper, required this.autoplay, this.showControls = true});

  final Wallpaper wallpaper;
  final bool autoplay;
  final bool showControls;

  @override
  State<MotionPreview> createState() => _MotionPreviewState();
}

class _MotionPreviewState extends State<MotionPreview> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 8000),
  );
  late bool _playing = widget.autoplay;

  @override
  void initState() {
    super.initState();
    if (_playing) _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() => _playing = !_playing);
    if (_playing) {
      _controller.repeat(reverse: true);
    } else {
      _controller.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final direction = widget.wallpaper.id.hashCode.isEven ? 1.0 : -1.0;
    return Stack(
      fit: StackFit.expand,
      children: [
        ClipRect(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              final t = Curves.easeInOut.transform(_controller.value);
              final scale = 1 + (0.06 * t);
              final dx = direction * 0.03 * (t - 0.5);
              final dy = 0.02 * math.sin(t * math.pi);
              return Transform.scale(
                scale: scale,
                child: FractionalTranslation(translation: Offset(dx, dy), child: child),
              );
            },
            child: WallpaperImage(wallpaper: widget.wallpaper, thumbnail: false),
          ),
        ),
        if (widget.showControls)
          Positioned(
            top: 64,
            right: 12,
            child: _PreviewButton(
              icon: _playing ? Icons.pause_rounded : Icons.play_arrow_rounded,
              tooltip: _playing ? 'Pause preview' : 'Play preview',
              onPressed: _toggle,
            ),
          ),
      ],
    );
  }
}

class _PreviewButton extends StatelessWidget {
  const _PreviewButton({required this.icon, required this.tooltip, required this.onPressed});

  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xB3101114),
      shape: const CircleBorder(),
      child: IconButton(
        onPressed: onPressed,
        tooltip: tooltip,
        icon: Icon(icon, color: Colors.white),
      ),
    );
  }
}
