import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/ads/ad_service.dart';
import 'core/theme/app_theme.dart';
import 'data/local/local_store.dart';
import 'presentation/splash/splash_screen.dart';
import 'state/app_scope.dart';
import 'state/app_state.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
  ));

  final prefs = await SharedPreferences.getInstance();
  final store = LocalStore(prefs);
  final ads = AdService();
  try {
    await ads.initialize();
  } catch (_) {
    // Ads stay optional if Play services are missing.
  }

  final state = AppState(store: store, ads: ads);
  await state.load();

  runApp(FootballWallpaperApp(state: state));
}

class FootballWallpaperApp extends StatelessWidget {
  const FootballWallpaperApp({super.key, required this.state});

  final AppState state;

  @override
  Widget build(BuildContext context) {
    return AppStateScope(
      state: state,
      child: MaterialApp(
        title: 'Football Wallpaper',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.dark(),
        home: SplashScreen(onboardingDone: state.store.onboardingDone),
      ),
    );
  }
}
