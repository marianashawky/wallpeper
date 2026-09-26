import 'package:flutter/material.dart';

import '../../app/main_shell.dart';
import '../../core/constants/app_info.dart';
import '../../shared/widgets/app_logo.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future<void>.delayed(const Duration(milliseconds: 900), () {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 400),
          pageBuilder: (_, animation, __) => FadeTransition(opacity: animation, child: const MainShell()),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const AppLogo(size: 64),
            const SizedBox(height: 16),
            Text(AppInfo.name, style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 6),
            Text(AppInfo.tagline, style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}
