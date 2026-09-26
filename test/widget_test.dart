import 'package:flutter_test/flutter_test.dart';
import 'package:football_wallpaper/data/catalog/wallpaper_catalog.dart';
import 'package:football_wallpaper/data/models/wallpaper.dart';

void main() {
  test('each player has 5 wallpapers', () {
    final players = wallpaperCatalog.where((w) => w.category == WallpaperCategory.players);
    final bySubject = <String, int>{};
    for (final w in players) {
      bySubject[w.subject] = (bySubject[w.subject] ?? 0) + 1;
    }
    expect(bySubject.length, 30);
    expect(bySubject.values.every((count) => count == 5), isTrue);
    expect(players.length, 150);
  });

  test('every wallpaper file path is unique', () {
    final paths = wallpaperCatalog.map((w) => w.imagePath).toList();
    expect(paths.toSet().length, paths.length);
  });
}
