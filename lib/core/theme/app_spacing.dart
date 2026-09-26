abstract final class AppSpacing {
  static const xxs = 4.0;
  static const xs = 8.0;
  static const sm = 12.0;
  static const md = 16.0;
  static const lg = 24.0;
  static const xl = 32.0;
  static const xxl = 48.0;

  static double page(double width) {
    if (width >= 1000) return 32;
    if (width >= 700) return 24;
    return 16;
  }
}
