import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Turns a still wallpaper into a looping live image (Ken Burns + light sweep).
class LiveWallpaperVisual extends StatefulWidget {
  const LiveWallpaperVisual({
    super.key,
    required this.imagePath,
    required this.seed,
    this.lite = false,
  });

  final String imagePath;
  final int seed;
  final bool lite;

  @override
  State<LiveWallpaperVisual> createState() => _LiveWallpaperVisualState();
}

class _LiveWallpaperVisualState extends State<LiveWallpaperVisual> with SingleTickerProviderStateMixin {
  late final AnimationController _c;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: widget.lite ? 7000 : 5600),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dir = widget.seed.isEven ? 1.0 : -1.0;
    return ClipRect(
      child: ColoredBox(
        color: Colors.black,
        child: AnimatedBuilder(
        animation: _c,
        builder: (context, _) {
          final t = Curves.easeInOut.transform(_c.value);
          final scale = 1.0 + 0.04 * t;
          final dx = dir * 0.02 * (t - 0.5);
          final dy = 0.015 * math.sin(t * math.pi);
          return Stack(
            fit: StackFit.expand,
            children: [
              Transform.scale(
                scale: scale,
                child: FractionalTranslation(
                  translation: Offset(dx, dy),
                  child: Image.asset(
                    widget.imagePath,
                    fit: BoxFit.contain,
                    gaplessPlayback: true,
                    filterQuality: FilterQuality.medium,
                  ),
                ),
              ),
              IgnorePointer(
                child: CustomPaint(
                  painter: _LiveLightPainter(t: t, seed: widget.seed, lite: widget.lite),
                ),
              ),
            ],
          );
        },
      ),
      ),
    );
  }
}

class _LiveLightPainter extends CustomPainter {
  _LiveLightPainter({required this.t, required this.seed, required this.lite});

  final double t;
  final int seed;
  final bool lite;

  @override
  void paint(Canvas canvas, Size size) {
    final sweepX = -0.4 + t * 1.8;
    canvas.drawRect(
      Offset.zero & size,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment(sweepX - 0.35, -1),
          end: Alignment(sweepX + 0.35, 1),
          colors: [
            Colors.transparent,
            Colors.white.withValues(alpha: lite ? 0.07 : 0.12),
            Colors.transparent,
          ],
        ).createShader(Offset.zero & size),
    );

    if (lite) return;
    final rnd = math.Random(seed);
    final spark = Paint()..color = Colors.white.withValues(alpha: 0.45 + 0.25 * math.sin(t * math.pi * 2));
    for (var i = 0; i < 14; i++) {
      final x = (rnd.nextDouble() + t * 0.15) % 1.0 * size.width;
      final y = (rnd.nextDouble() * size.height + t * 40) % size.height;
      canvas.drawCircle(Offset(x, y), 1.1 + (i % 3) * 0.4, spark);
    }
  }

  @override
  bool shouldRepaint(covariant _LiveLightPainter oldDelegate) => oldDelegate.t != t;
}
