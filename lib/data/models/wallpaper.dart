enum WallpaperCategory {
  players('Players', 'players', 'assets/images/categories/players.jpg'),
  clubs('Clubs', 'clubs', 'assets/images/categories/clubs.jpg'),
  nationalTeams('National Teams', 'national_teams', 'assets/images/categories/national_teams.jpg'),
  championsLeague('Champions League', 'champions_league', 'assets/images/categories/champions_league.jpg'),
  leagues('Leagues', 'leagues', 'assets/images/categories/leagues.jpg'),
  legends('Legends', 'legends', 'assets/images/categories/legends.jpg'),
  stadiums('Stadiums', 'stadiums', 'assets/images/categories/stadiums.jpg'),
  art3d('Live', '3d', 'assets/images/categories/3d.jpg'),
  minimal('Minimal', 'minimal', 'assets/images/categories/minimal.jpg'),
  quotes('Quotes', 'quotes', 'assets/images/categories/quotes.jpg');

  const WallpaperCategory(this.label, this.id, this.thumbnail);
  final String label;
  final String id;
  final String thumbnail;
}

class Wallpaper {
  const Wallpaper({
    required this.id,
    required this.title,
    required this.category,
    required this.subject,
    required this.imagePath,
    required this.tags,
    this.subtitle = '',
    this.clubName = '',
    this.featured = false,
    this.trending = false,
    this.downloads = 0,
    this.likes = 0,
    this.views = 0,
  });

  final String id;
  final String title;
  final WallpaperCategory category;
  final String subject;
  final String imagePath;
  final List<String> tags;
  final String subtitle;
  final String clubName;
  final bool featured;
  final bool trending;
  final int downloads;
  final int likes;
  final int views;

  bool get animated => imagePath.contains('/3d/') || category == WallpaperCategory.art3d;

  bool matches(String query) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return true;
    return title.toLowerCase().contains(q) ||
        subject.toLowerCase().contains(q) ||
        subtitle.toLowerCase().contains(q) ||
        category.label.toLowerCase().contains(q) ||
        tags.any((t) => t.toLowerCase().contains(q));
  }
}
