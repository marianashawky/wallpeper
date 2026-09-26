import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../core/constants/app_info.dart';
import '../core/theme/app_theme.dart';
import '../features/splash/splash_screen.dart';
import 'app_scope.dart';

class LumenApp extends StatelessWidget {
  const LumenApp({super.key, required this.deps});

  final AppDependencies deps;

  @override
  Widget build(BuildContext context) {
    return AppScope(
      deps: deps,
      child: ListenableBuilder(
        listenable: deps.settings,
        builder: (context, _) {
          return MaterialApp(
            title: AppInfo.name,
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light(),
            darkTheme: AppTheme.dark(),
            themeMode: deps.settings.themeMode,
            builder: (context, child) {
              final dark = Theme.of(context).brightness == Brightness.dark;
              return AnnotatedRegion<SystemUiOverlayStyle>(
                value: SystemUiOverlayStyle(
                  statusBarColor: Colors.transparent,
                  statusBarIconBrightness: dark ? Brightness.light : Brightness.dark,
                  systemNavigationBarColor: Theme.of(context).scaffoldBackgroundColor,
                  systemNavigationBarIconBrightness: dark ? Brightness.light : Brightness.dark,
                ),
                child: child ?? const SizedBox.shrink(),
              );
            },
            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}
