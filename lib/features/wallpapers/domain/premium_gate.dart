import 'wallpaper.dart';

/// Entitlement check for premium wallpapers.
/// This build allows every wallpaper. A subscription backend can replace the body.
class PremiumGate {
  const PremiumGate();

  bool canApply(Wallpaper wallpaper) => true;
}
