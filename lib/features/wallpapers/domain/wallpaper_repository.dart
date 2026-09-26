import '../../categories/domain/wallpaper_category.dart';
import 'wallpaper.dart';

class HomeFeed {
  const HomeFeed({
    required this.hero,
    required this.live,
    required this.anime,
    required this.nature,
    required this.cars,
    required this.trending,
    required this.recent,
  });

  final Wallpaper hero;
  final List<Wallpaper> live;
  final List<Wallpaper> anime;
  final List<Wallpaper> nature;
  final List<Wallpaper> cars;
  final List<Wallpaper> trending;
  final List<Wallpaper> recent;
}

class CategoryPage {
  const CategoryPage({
    required this.category,
    required this.items,
    required this.hasMore,
    required this.nextOffset,
  });

  final WallpaperCategory category;
  final List<Wallpaper> items;
  final bool hasMore;
  final int nextOffset;
}

/// Catalog contract. Presentation depends on this type only.
/// [peek] and [cachedHome] are in-memory snapshots so a local catalog can paint
/// immediately. A future API repository can return null until the first fetch.
abstract class WallpaperRepository {
  HomeFeed? get cachedHome => null;

  List<WallpaperCategory>? get cachedCategories => null;

  Future<HomeFeed> loadHome();

  Future<List<WallpaperCategory>> loadCategories();

  Wallpaper? peek(String id) => null;

  CategoryPage? peekCategory(String categoryId, {String? tag, int offset = 0, int limit = 24}) => null;

  Future<CategoryPage> loadCategory(String categoryId, {String? tag, int offset = 0, int limit = 24});

  Future<List<Wallpaper>> search(String query);

  Future<List<WallpaperCategory>> searchCategories(String query);

  Future<List<Wallpaper>> related(Wallpaper wallpaper, {int limit = 8});

  List<Wallpaper> byIds(Iterable<String> ids);
}
