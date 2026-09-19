import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/theme/app_colors.dart';
import '../onboarding/onboarding_screen.dart';
import '../shell/main_shell.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key, required this.onboardingDone});

  final bool onboardingDone;

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1800))..repeat();

  @override
  void initState() {
    super.initState();
    Future<void>.delayed(const Duration(milliseconds: 2200), _go);
  }

  void _go() {
    if (!mounted) return;
    final next = widget.onboardingDone ? const MainShell() : const OnboardingScreen();
    Navigator.of(context).pushReplacement(PageRouteBuilder(
      pageBuilder: (_, a, __) => FadeTransition(opacity: a, child: next),
      transitionDuration: const Duration(milliseconds: 500),
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return Stack(
            fit: StackFit.expand,
            children: [
              CustomPaint(painter: _RingsPainter(_controller.value)),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Transform.translate(
                    offset: Offset(0, math.sin(_controller.value * math.pi * 2) * 6),
                    child: SvgPicture.asset('assets/images/branding/ball.svg', width: 120, height: 120),
                  ),
                  const SizedBox(height: 28),
                  Text('FOOTBALL', style: GoogleFonts.inter(fontSize: 34, fontWeight: FontWeight.w800, letterSpacing: 6)),
                  Container(margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 90), height: 2, color: AppColors.accent),
                  Text('W A L L P A P E R', style: GoogleFonts.inter(color: AppColors.textSecondary, letterSpacing: 6, fontSize: 13)),
                ],
              ),
              const Positioned(
                left: 0,
                right: 0,
                bottom: 56,
                child: Column(
                  children: [
                    SizedBox(width: 90, child: Divider(color: AppColors.stroke)),
                    SizedBox(height: 10),
                    Text('LOADING', style: TextStyle(color: AppColors.textMuted, letterSpacing: 4, fontSize: 11)),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _RingsPainter extends CustomPainter {
  _RingsPainter(this.t);
  final double t;

  @override
  void paint(Canvas canvas, Size size) {
    final c = Offset(size.width / 2, size.height / 2 - 40);
    for (var i = 1; i <= 4; i++) {
      final paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1
        ..color = AppColors.accent.withValues(alpha: 0.08 + i * 0.03);
      canvas.drawCircle(c, 70.0 + i * 42 + t * 8, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _RingsPainter oldDelegate) => oldDelegate.t != t;
}
