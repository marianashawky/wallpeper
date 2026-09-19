import 'dart:math' as math;

import 'package:flutter/material.dart';

class Animated3dOverlay extends StatefulWidget {
  const Animated3dOverlay({super.key, required this.seed});

  final int seed;

  @override
  State<Animated3dOverlay> createState() => _Animated3dOverlayState();
}

class _Animated3dOverlayState extends State<Animated3dOverlay> with SingleTickerProviderStateMixin {
  late final AnimationController _c;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 4200))..repeat();
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _c,
        builder: (_, __) => CustomPaint(
          painter: _ThreeDPainter(t: _c.value, seed: widget.seed),
          child: const SizedBox.expand(),
        ),
      ),
    );
  }
}

class _ThreeDPainter extends CustomPainter {
  _ThreeDPainter({required this.t, required this.seed});

  final double t;
  final int seed;

  @override
  void paint(Canvas canvas, Size size) {
    final rnd = math.Random(seed);
    final style = seed.abs() % 5;
    final hue = (seed.abs() % 360).toDouble();
    final accent = HSVColor.fromAHSV(1, (hue + 90) % 360, 0.85, 1).toColor();
    final gold = const Color(0xFFFFD54A);
    final w = size.width;
    final h = size.height;
    final cx = w * 0.5 + math.sin(t * math.pi * 2) * w * 0.07;
    final cy = h * 0.42 + math.cos(t * math.pi * 2 * 1.15) * h * 0.035;
    final r = math.min(w, h) * (0.18 + 0.02 * math.sin(t * math.pi * 2));

    for (var i = 0; i < 18; i++) {
      final a = (i / 18 + t) * math.pi * 2;
      final px = cx + math.cos(a) * r * (1.55 + 0.12 * math.sin(t * 8 + i));
      final py = cy + math.sin(a) * r * 0.55;
      canvas.drawCircle(
        Offset(px, py),
        1.6 + (i % 3),
        Paint()..color = accent.withValues(alpha: 0.35 + 0.35 * ((math.sin(t * 6 + i) + 1) / 2)),
      );
    }

    final glow = Paint()
      ..shader = RadialGradient(
        colors: [accent.withValues(alpha: 0.45), Colors.transparent],
      ).createShader(Rect.fromCircle(center: Offset(cx, cy), radius: r * 2.4));
    canvas.drawCircle(Offset(cx, cy), r * 2.4, glow);

    if (style == 0 || style == 2) {
      _ball(canvas, Offset(cx, cy), r, t, accent);
    } else if (style == 1) {
      _trophy(canvas, Offset(cx, cy + r * 0.1), r * 1.25, t, gold, accent);
    } else if (style == 3) {
      _ring(canvas, Offset(cx, cy), r * 1.35, t, accent);
      _ball(canvas, Offset(cx, cy), r * 0.72, t, gold);
    } else {
      _trophy(canvas, Offset(cx, cy), r, t, gold, accent);
      _ball(canvas, Offset(cx + r * 1.1, cy + r * 0.4), r * 0.42, t + 0.3, accent);
    }

    final sweep = Paint()
      ..shader = LinearGradient(
        begin: Alignment(-1 + 2 * t, -1),
        end: Alignment(1 * t, 1),
        colors: [Colors.transparent, Colors.white.withValues(alpha: 0.14), Colors.transparent],
      ).createShader(Offset.zero & size);
    canvas.drawRect(Offset.zero & size, sweep);

    final spark = Paint()..color = Colors.white.withValues(alpha: 0.55);
    for (var i = 0; i < 10; i++) {
      final sx = rnd.nextDouble() * w;
      final sy = (rnd.nextDouble() * h + t * h * 0.35) % h;
      canvas.drawCircle(Offset(sx, sy), 1.2, spark);
    }
  }

  void _ball(Canvas canvas, Offset c, double r, double t, Color accent) {
    final rect = Rect.fromCircle(center: c, radius: r);
    canvas.drawOval(
      rect,
      Paint()
        ..shader = RadialGradient(
          center: const Alignment(-0.35, -0.4),
          colors: [const Color(0xFFF5F7FA), const Color(0xFF9AA3B2), const Color(0xFF1B2430)],
        ).createShader(rect),
    );
    final pent = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = math.max(1.5, r * 0.06)
      ..color = const Color(0xFF111418).withValues(alpha: 0.85);
    for (var i = 0; i < 5; i++) {
      final a = t * math.pi * 2 + i * math.pi * 2 / 5;
      canvas.drawArc(rect.deflate(r * 0.18), a, 1.1, false, pent);
    }
    canvas.drawCircle(c, r * 0.18, Paint()..color = accent.withValues(alpha: 0.9));
    canvas.drawOval(
      Rect.fromCenter(center: c.translate(-r * 0.22, -r * 0.28), width: r * 0.55, height: r * 0.28),
      Paint()..color = Colors.white.withValues(alpha: 0.28),
    );
  }

  void _trophy(Canvas canvas, Offset c, double r, double t, Color gold, Color accent) {
    final path = Path()
      ..moveTo(c.dx - r * 0.42, c.dy - r * 0.15)
      ..quadraticBezierTo(c.dx - r * 0.7, c.dy - r * 0.7, c.dx, c.dy - r * 0.95)
      ..quadraticBezierTo(c.dx + r * 0.7, c.dy - r * 0.7, c.dx + r * 0.42, c.dy - r * 0.15)
      ..lineTo(c.dx + r * 0.22, c.dy + r * 0.15)
      ..lineTo(c.dx + r * 0.16, c.dy + r * 0.55)
      ..lineTo(c.dx - r * 0.16, c.dy + r * 0.55)
      ..lineTo(c.dx - r * 0.22, c.dy + r * 0.15)
      ..close();
    canvas.save();
    canvas.translate(c.dx, c.dy);
    canvas.rotate(math.sin(t * math.pi * 2) * 0.18);
    canvas.translate(-c.dx, -c.dy);
    canvas.drawPath(
      path,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [gold, const Color(0xFFB8860B), gold],
        ).createShader(Rect.fromCircle(center: c, radius: r)),
    );
    canvas.drawRect(
      Rect.fromCenter(center: Offset(c.dx, c.dy + r * 0.72), width: r * 0.7, height: r * 0.12),
      Paint()..color = gold,
    );
    canvas.drawCircle(Offset(c.dx, c.dy - r * 0.55), r * 0.12, Paint()..color = accent);
    canvas.restore();
  }

  void _ring(Canvas canvas, Offset c, double r, double t, Color accent) {
    final p = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = r * 0.08
      ..shader = SweepGradient(
        startAngle: t * math.pi * 2,
        colors: [accent, Colors.white, accent.withValues(alpha: 0.1), accent],
      ).createShader(Rect.fromCircle(center: c, radius: r));
    canvas.drawOval(Rect.fromCenter(center: c, width: r * 2, height: r * 0.7), p);
  }

  @override
  bool shouldRepaint(covariant _ThreeDPainter oldDelegate) => oldDelegate.t != t;
}
