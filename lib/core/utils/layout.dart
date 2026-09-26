abstract final class AppLayout {
  static int gridColumns(double width) {
    if (width >= 1100) return 4;
    if (width >= 700) return 3;
    return 2;
  }

  static double carouselCardWidth(double width) {
    if (width >= 1000) return 230;
    if (width >= 700) return 200;
    return width * 0.42;
  }

  static double heroHeight(double width) {
    final raw = width * 0.78;
    if (raw < 340) return 340;
    if (raw > 560) return 560;
    return raw;
  }

  static double tileAspect(int index) {
    const ratios = <double>[0.72, 0.86, 0.66, 0.92];
    return ratios[index % ratios.length];
  }
}
