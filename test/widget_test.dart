import 'package:flutter_test/flutter_test.dart';
import 'package:football_wallpaper/core/constants/app_info.dart';
import 'package:football_wallpaper/features/wallpapers/data/mock_wallpaper_repository.dart';
import 'package:football_wallpaper/features/wallpapers/domain/wallpaper.dart';

void main() {
  test('catalog has no football collection', () async {
    final repository = MockWallpaperRepository();
    final categories = await repository.loadCategories();
    expect(categories.map((category) => category.id), containsAll([
      CategoryIds.live,
      CategoryIds.anime,
      CategoryIds.nature,
      CategoryIds.cars,
      CategoryIds.gaming,
      CategoryIds.space,
      CategoryIds.abstract,
      CategoryIds.minimal,
      CategoryIds.technology,
      CategoryIds.dark,
    ]));
    expect(categories.any((category) => category.id == 'football'), isFalse);

    final all = await repository.search('messi');
    expect(all, isEmpty);

    final live = await repository.loadCategory(CategoryIds.live, limit: 100);
    expect(live.items, isNotEmpty);
    expect(live.items.every((wallpaper) => wallpaper.type != WallpaperType.static), isTrue);
  });
}