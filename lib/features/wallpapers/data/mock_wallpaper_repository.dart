import '../../../core/constants/app_info.dart';
import '../../categories/data/category_directory.dart';
import '../../categories/domain/wallpaper_category.dart';
import '../domain/wallpaper.dart';
import '../domain/wallpaper_repository.dart';
import 'platform_catalog.dart';

class MockWallpaperRepository implements WallpaperRepository {
  MockWallpaperRepository() {
    _all = [...platformCatalog];
    for (final wallpaper in _all) {
      _byId[wallpaper.id] = wallpaper;
    }
    _home = _buildHome();
    _categories = _buildCategories();
  }

  late final List<Wallpaper> _all;
  final Map<String, Wallpaper> _byId = {};
  late final HomeFeed _home;
  late final List<WallpaperCategory> _categories;

  @override
  HomeFeed? get cachedHome => _home;

  @override
  List<WallpaperCategory>? get cachedCategories => _categories;

  @override
  Future<HomeFeed> loadHome() async => _home;

  @override
  Future<List<WallpaperCategory>> loadCategories() async => _categories;

  @override
  Wallpaper? peek(String id) => _byId[id];

  @override
  CategoryPage? peekCategory(String categoryId, {String? tag, int offset = 0, int limit = 24}) {
    return _page(categoryId, tag: tag, offset: offset, limit: limit);
  }

  @override
  Future<CategoryPage> loadCategory(String categoryId, {String? tag, int offset = 0, int limit = 24}) async {
    return _page(categoryId, tag: tag, offset: offset, limit: limit);
  }

  @override
  Future<List<Wallpaper>> search(String query) async {
    final trimmed = query.trim().toLowerCase();
    if (trimmed.isEmpty) return const [];
    final categoryIds = _categories
        .where((category) => category.name.toLowerCase().contains(trimmed) || category.id.contains(trimmed))
        .map((category) => category.id)
        .toSet();
    return _all
        .where((wallpaper) => wallpaper.matches(trimmed) || categoryIds.contains(wallpaper.categoryId))
        .take(80)
        .toList();
  }

  @override
  Future<List<WallpaperCategory>> searchCategories(String query) async {
    final trimmed = query.trim().toLowerCase();
    if (trimmed.isEmpty) return const [];
    return _categories
        .where((category) => category.name.toLowerCase().contains(trimmed) || category.id.contains(trimmed))
        .toList();
  }

  @override
  Future<List<Wallpaper>> related(Wallpaper wallpaper, {int limit = 8}) async {
    final pool = _all.where((item) => item.id != wallpaper.id && item.categoryId == wallpaper.categoryId).toList();
    pool.sort((a, b) {
      final aScore = a.tags.where(wallpaper.tags.contains).length;
      final bScore = b.tags.where(wallpaper.tags.contains).length;
      return bScore.compareTo(aScore);
    });
    return pool.take(limit).toList();
  }

  @override
  List<Wallpaper> byIds(Iterable<String> ids) {
    final resolved = <Wallpaper>[];
    for (final id in ids) {
      final wallpaper = _byId[id];
      if (wallpaper != null) resolved.add(wallpaper);
    }
    return resolved;
  }

  CategoryPage _page(String categoryId, {String? tag, int offset = 0, int limit = 24}) {
    final category = _categories.firstWhere(
      (item) => item.id == categoryId,
      orElse: () => WallpaperCategory(id: categoryId, name: categoryId, coverUrl: '', filters: const []),
    );
    final filtered = _forCategory(categoryId).where((wallpaper) {
      if (tag == null || tag.isEmpty) return true;
      return wallpaper.tags.contains(tag);
    }).toList();
    final slice = filtered.skip(offset).take(limit).toList();
    final next = offset + slice.length;
    return CategoryPage(
      category: category,
      items: slice,
      hasMore: next < filtered.length,
      nextOffset: next,
    );
  }

  List<Wallpaper> _forCategory(String categoryId) {
    if (categoryId == CategoryIds.live) {
      return _all.where((wallpaper) => wallpaper.type != WallpaperType.static).toList();
    }
    return _all.where((wallpaper) => wallpaper.categoryId == categoryId).toList();
  }

  List<WallpaperCategory> _buildCategories() {
    return [
      for (final category in categoryDirectory)
        category.copyWith(
          wallpaperCount: _forCategory(category.id).length,
          coverUrl: category.coverUrl,
        ),
    ];
  }

  HomeFeed _buildHome() {
    final hero = _byId['motion_stars'] ?? _all.first;
    final live = _forCategory(CategoryIds.live).where((wallpaper) => wallpaper.id != hero.id).take(12).toList();
    final anime = _forCategory(CategoryIds.anime).take(12).toList();
    final nature = _orderedNature().take(12).toList();
    final cars = _forCategory(CategoryIds.cars).take(12).toList();
    final trending = _all.where((wallpaper) => wallpaper.isTrending).take(12).toList();
    final recent = [..._all]..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return HomeFeed(
      hero: hero,
      live: live,
      anime: anime,
      nature: nature,
      cars: cars,
      trending: trending,
      recent: recent.take(10).toList(),
    );
  }

  List<Wallpaper> _orderedNature() {
    final items = _forCategory(CategoryIds.nature);
    final motion = items.where((wallpaper) => wallpaper.type != WallpaperType.static);
    final still = items.where((wallpaper) => wallpaper.type == WallpaperType.static);
    return [...motion, ...still];
  }

}
