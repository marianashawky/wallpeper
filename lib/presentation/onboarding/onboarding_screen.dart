import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/theme/app_colors.dart';
import '../../state/app_scope.dart';
import '../shell/main_shell.dart';
import '../widgets/ui_bits.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _controller = PageController();
  int _index = 0;

  static const _pages = [
    (
      image: 'assets/images/branding/onboarding_1.png',
      title: 'Discover Epic\nWallpapers',
      body: 'Thousands of cinematic football wallpapers in stunning 4K quality.',
    ),
    (
      image: 'assets/images/branding/onboarding_2.png',
      title: 'Your Favorites,\nAlways Ready',
      body: 'Save and organize your collection. Access anytime, instantly.',
    ),
    (
      image: 'assets/images/branding/onboarding_3.png',
      title: 'Set The Perfect\nMatch Night',
      body: 'Download, share, and set wallpapers without an account.',
    ),
  ];

  Future<void> _finish() async {
    await AppStateScope.of(context).store.setOnboardingDone();
    if (!mounted) return;
    Navigator.of(context).pushReplacement(PageRouteBuilder(
      pageBuilder: (_, a, __) => FadeTransition(opacity: a, child: const MainShell()),
      transitionDuration: const Duration(milliseconds: 400),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _controller,
            itemCount: _pages.length,
            onPageChanged: (i) => setState(() => _index = i),
            itemBuilder: (context, i) {
              final page = _pages[i];
              return Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(page.image, fit: BoxFit.cover),
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Color(0x33000000), Color(0xF2020407), Color(0xFF020407)],
                        stops: [0.2, 0.62, 1],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
          SafeArea(
            child: Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: _finish,
                child: const Text('Skip', style: TextStyle(color: AppColors.textSecondary, fontSize: 16)),
              ),
            ),
          ),
          Positioned(
            left: 24,
            right: 24,
            bottom: 36,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(_pages.length, (i) {
                    final active = i == _index;
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      height: 6,
                      width: active ? 22 : 6,
                      decoration: BoxDecoration(
                        color: active ? AppColors.accent : AppColors.stroke,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 22),
                Text(
                  _pages[_index].title,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(fontSize: 32, fontWeight: FontWeight.w800, height: 1.15),
                ),
                const SizedBox(height: 12),
                Text(
                  _pages[_index].body,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: AppColors.textSecondary, fontSize: 15, height: 1.4),
                ),
                const SizedBox(height: 28),
                GlowButton(
                  label: _index == _pages.length - 1 ? 'GET STARTED' : 'CONTINUE',
                  onPressed: () {
                    if (_index == _pages.length - 1) {
                      _finish();
                    } else {
                      _controller.nextPage(duration: const Duration(milliseconds: 350), curve: Curves.easeOut);
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
