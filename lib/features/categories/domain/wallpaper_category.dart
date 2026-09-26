class CategoryFilter {
  const CategoryFilter({required this.tag, required this.label});

  final String tag;
  final String label;
}

class WallpaperCategory {
  const WallpaperCategory({
    required this.id,
    required this.name,
    required this.coverUrl,
    required this.filters,
    this.wallpaperCount = 0,
  });

  final String id;
  final String name;
  final String coverUrl;
  final List<CategoryFilter> filters;
  final int wallpaperCount;

  WallpaperCategory copyWith({int? wallpaperCount, String? coverUrl}) {
    return WallpaperCategory(
      id: id,
      name: name,
      coverUrl: coverUrl ?? this.coverUrl,
      filters: filters,
      wallpaperCount: wallpaperCount ?? this.wallpaperCount,
    );
  }
}
