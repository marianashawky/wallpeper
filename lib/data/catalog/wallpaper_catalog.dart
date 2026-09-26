import '../models/wallpaper.dart';

Wallpaper _w({
  required String id,
  required String title,
  required WallpaperCategory category,
  required String subject,
  required String imagePath,
  required List<String> tags,
  String subtitle = '',
  String clubName = '',
  bool featured = false,
  bool trending = false,
  int downloads = 12000,
  int likes = 4200,
  int views = 88000,
}) {
  return Wallpaper(
    id: id,
    title: title,
    category: category,
    subject: subject,
    imagePath: imagePath,
    tags: tags,
    subtitle: subtitle,
    clubName: clubName,
    featured: featured,
    trending: trending,
    downloads: downloads,
    likes: likes,
    views: views,
  );
}

const _p = 'assets/images/wallpapers';

const _playerLooks = <(String, String, String)>[
  ('001', 'Kit Number', 'kit'),
  ('002', 'Neon City', 'city'),
  ('003', 'Tunnel Walk', 'tunnel'),
  ('004', 'Match Poster', 'poster'),
  ('005', 'Motion Cut', 'abstract'),
];

List<Wallpaper> _playerSet({
  required String slug,
  required String title,
  required String subject,
  required List<String> tags,
  required String subtitle,
  required String clubName,
  bool featured = false,
  bool trending = false,
  int downloads = 12000,
  int likes = 4200,
  int views = 88000,
}) {
  return [
    for (var i = 0; i < _playerLooks.length; i++)
      _w(
        id: 'player_${slug}_${_playerLooks[i].$1}',
        title: title,
        category: WallpaperCategory.players,
        subject: subject,
        imagePath: '$_p/players/player_${slug}_${_playerLooks[i].$1}.jpg',
        tags: [...tags, _playerLooks[i].$3],
        subtitle: i == 0 ? subtitle : _playerLooks[i].$2,
        clubName: clubName,
        featured: featured && i == 0,
        trending: trending && i < 2,
        downloads: (downloads * (1 - i * 0.08)).round(),
        likes: (likes * (1 - i * 0.08)).round(),
        views: (views * (1 - i * 0.08)).round(),
      ),
  ];
}

final List<Wallpaper> wallpaperCatalog = [
  ..._playerSet(slug: 'messi', title: 'Messi', subject: 'Lionel Messi', tags: ['messi', 'argentina', 'inter miami', 'goat'], subtitle: 'The Magician', clubName: 'Inter Miami', featured: true, trending: true, downloads: 84200, likes: 22100, views: 410000),
  ..._playerSet(slug: 'ronaldo', title: 'Ronaldo', subject: 'Cristiano Ronaldo', tags: ['ronaldo', 'cr7', 'portugal', 'al nassr'], subtitle: 'CR7 Legacy', clubName: 'Al Nassr', featured: true, trending: true, downloads: 91000, likes: 19800, views: 455000),
  ..._playerSet(slug: 'salah', title: 'Salah', subject: 'Mohamed Salah', tags: ['salah', 'liverpool', 'egypt'], subtitle: 'Egyptian King', clubName: 'Liverpool', featured: true, trending: true, downloads: 54000, likes: 13200, views: 210000),
  ..._playerSet(slug: 'mbappe', title: 'K. Mbappé', subject: 'Kylian Mbappé', tags: ['mbappe', 'real madrid', 'france', '4k'], subtitle: 'Lightning', clubName: 'Real Madrid', trending: true, downloads: 67300, likes: 15400, views: 289000),
  ..._playerSet(slug: 'haaland', title: 'E. Haaland', subject: 'Erling Haaland', tags: ['haaland', 'man city', 'celebration'], subtitle: 'The Machine', clubName: 'Man City', trending: true, downloads: 61200, likes: 14100, views: 266000),
  ..._playerSet(slug: 'vinicius', title: 'V. Júnior', subject: 'Vinícius Júnior', tags: ['vinicius', 'real madrid', 'brazil'], subtitle: 'Vini Jr', clubName: 'Real Madrid', trending: true, downloads: 49800, likes: 12100, views: 198000),
  ..._playerSet(slug: 'bellingham', title: 'J. Bellingham', subject: 'Jude Bellingham', tags: ['bellingham', 'real madrid', 'england'], subtitle: 'Jude 5', clubName: 'Real Madrid', trending: true, downloads: 52100, likes: 11800, views: 205000),
  ..._playerSet(slug: 'foden', title: 'P. Foden', subject: 'Phil Foden', tags: ['foden', 'man city', 'england'], subtitle: 'Sky Blue Spark', clubName: 'Man City', downloads: 30100, likes: 7600, views: 122000),
  ..._playerSet(slug: 'yamal', title: 'Yamal', subject: 'Lamine Yamal', tags: ['yamal', 'barcelona', 'spain'], subtitle: 'The Prodigy', clubName: 'Barcelona', trending: true, downloads: 44800, likes: 13200, views: 188000),
  ..._playerSet(slug: 'saka', title: 'Saka', subject: 'Bukayo Saka', tags: ['saka', 'arsenal', 'england'], subtitle: 'Starboy', clubName: 'Arsenal', downloads: 28600, likes: 7100, views: 109000),
  ..._playerSet(slug: 'de_bruyne', title: 'De Bruyne', subject: 'Kevin De Bruyne', tags: ['de bruyne', 'man city', 'belgium'], subtitle: 'The Visionary', clubName: 'Man City', downloads: 27400, likes: 6900, views: 101000),
  ..._playerSet(slug: 'lewandowski', title: 'Lewandowski', subject: 'Robert Lewandowski', tags: ['lewandowski', 'barcelona', 'poland'], subtitle: 'Lewy 9', clubName: 'Barcelona', downloads: 25900, likes: 6400, views: 98000),
  ..._playerSet(slug: 'kane', title: 'Kane', subject: 'Harry Kane', tags: ['kane', 'bayern', 'england'], subtitle: 'Captain Kane', clubName: 'Bayern', downloads: 24800, likes: 6100, views: 94000),
  ..._playerSet(slug: 'neymar', title: 'Neymar', subject: 'Neymar Jr', tags: ['neymar', 'brazil', 'santos'], subtitle: 'NJR Magic', clubName: 'Santos', downloads: 33200, likes: 8900, views: 141000),
  ..._playerSet(slug: 'benzema', title: 'Benzema', subject: 'Karim Benzema', tags: ['benzema', 'real madrid', 'france'], subtitle: 'The King', clubName: 'Al Ittihad', downloads: 22100, likes: 5400, views: 87000),
  ..._playerSet(slug: 'modric', title: 'Modric', subject: 'Luka Modrić', tags: ['modric', 'real madrid', 'croatia'], subtitle: 'The Maestro', clubName: 'Real Madrid', downloads: 19800, likes: 5100, views: 76000),
  ..._playerSet(slug: 'rodri', title: 'Rodri', subject: 'Rodri', tags: ['rodri', 'man city', 'spain'], subtitle: 'Midfield Anchor', clubName: 'Man City', downloads: 18700, likes: 4300, views: 71000),
  ..._playerSet(slug: 'valverde', title: 'Valverde', subject: 'Federico Valverde', tags: ['valverde', 'real madrid', 'uruguay'], subtitle: 'Fede Engine', clubName: 'Real Madrid', downloads: 17600, likes: 4100, views: 68000),
  ..._playerSet(slug: 'pedri', title: 'Pedri', subject: 'Pedri', tags: ['pedri', 'barcelona', 'spain'], subtitle: 'Pedri 8', clubName: 'Barcelona', downloads: 16900, likes: 3900, views: 64000),
  ..._playerSet(slug: 'gavi', title: 'Gavi', subject: 'Gavi', tags: ['gavi', 'barcelona', 'spain'], subtitle: 'Firestarter', clubName: 'Barcelona', downloads: 15400, likes: 3600, views: 59000),
  ..._playerSet(slug: 'osimhen', title: 'Osimhen', subject: 'Victor Osimhen', tags: ['osimhen', 'galatasaray', 'nigeria'], subtitle: 'Super Eagle', clubName: 'Galatasaray', downloads: 14800, likes: 3400, views: 56000),
  ..._playerSet(slug: 'courtois', title: 'Courtois', subject: 'Thibaut Courtois', tags: ['courtois', 'real madrid', 'belgium'], subtitle: 'The Wall', clubName: 'Real Madrid', downloads: 13900, likes: 3100, views: 52000),
  ..._playerSet(slug: 'van_dijk', title: 'Van Dijk', subject: 'Virgil van Dijk', tags: ['van dijk', 'liverpool', 'netherlands'], subtitle: 'VVD', clubName: 'Liverpool', downloads: 16200, likes: 3800, views: 61000),
  ..._playerSet(slug: 'hakimi', title: 'Hakimi', subject: 'Achraf Hakimi', tags: ['hakimi', 'psg', 'morocco'], subtitle: 'Turbo Wing', clubName: 'PSG', downloads: 12800, likes: 2900, views: 48000),
  ..._playerSet(slug: 'griezmann', title: 'Griezmann', subject: 'Antoine Griezmann', tags: ['griezmann', 'atletico', 'france'], subtitle: 'Grizi', clubName: 'Atlético', downloads: 12100, likes: 2700, views: 45000),
  ..._playerSet(slug: 'son', title: 'Son', subject: 'Son Heung-min', tags: ['son', 'tottenham', 'korea'], subtitle: 'Sonny', clubName: 'Tottenham', downloads: 17100, likes: 4000, views: 67000),
  ..._playerSet(slug: 'musiala', title: 'Musiala', subject: 'Jamal Musiala', tags: ['musiala', 'bayern', 'germany'], subtitle: 'Next Gen', clubName: 'Bayern', downloads: 13400, likes: 3200, views: 51000),
  ..._playerSet(slug: 'rice', title: 'Rice', subject: 'Declan Rice', tags: ['rice', 'arsenal', 'england'], subtitle: 'Declan Rice', clubName: 'Arsenal', downloads: 11800, likes: 2600, views: 43000),
  ..._playerSet(slug: 'palmer', title: 'Palmer', subject: 'Cole Palmer', tags: ['palmer', 'chelsea', 'england'], subtitle: 'Cold Palmer', clubName: 'Chelsea', downloads: 15700, likes: 4100, views: 62000),
  ..._playerSet(slug: 'isak', title: 'Isak', subject: 'Alexander Isak', tags: ['isak', 'newcastle', 'sweden'], subtitle: 'Clinical 14', clubName: 'Newcastle', downloads: 11200, likes: 2500, views: 41000),

  _w(id: 'club_real_madrid_001', title: 'Real Madrid', category: WallpaperCategory.clubs, subject: 'Real Madrid', imagePath: '$_p/clubs/club_real_madrid_001.jpg', tags: ['real madrid', 'champions league', 'night'], subtitle: 'Los Blancos', featured: true, trending: true, downloads: 72000, likes: 16000, views: 301000),
  _w(id: 'club_real_madrid_002', title: 'Madrid Night', category: WallpaperCategory.championsLeague, subject: 'Real Madrid', imagePath: '$_p/clubs/club_real_madrid_002.jpg', tags: ['real madrid', 'bernabeu', 'champions league'], subtitle: 'Bernabéu Glow', trending: true, downloads: 41000, likes: 9800, views: 166000),
  _w(id: 'club_barcelona_001', title: 'Barcelona', category: WallpaperCategory.clubs, subject: 'Barcelona', imagePath: '$_p/clubs/club_barcelona_001.jpg', tags: ['barcelona', 'el clasico', 'la liga'], subtitle: 'Blaugrana', trending: true, downloads: 56000, likes: 14000, views: 240000),
  _w(id: 'club_liverpool_001', title: 'Liverpool', category: WallpaperCategory.clubs, subject: 'Liverpool', imagePath: '$_p/clubs/club_liverpool_001.jpg', tags: ['liverpool', 'anfield', 'premier league'], subtitle: "You'll Never Walk Alone", downloads: 49000, likes: 12000, views: 199000),
  _w(id: 'club_liverpool_002', title: 'Anfield Roar', category: WallpaperCategory.clubs, subject: 'Liverpool', imagePath: '$_p/clubs/club_liverpool_002.jpg', tags: ['liverpool', 'anfield', 'tunnel'], subtitle: 'This Is Anfield', downloads: 28000, likes: 7200, views: 102000),
  _w(id: 'club_man_city_001', title: 'Man City', category: WallpaperCategory.clubs, subject: 'Manchester City', imagePath: '$_p/clubs/club_man_city_001.jpg', tags: ['man city', 'premier league', 'sky blue'], subtitle: 'Sky Blue', trending: true, downloads: 38000, likes: 9100, views: 151000),
  _w(id: 'club_bayern_001', title: 'Bayern', category: WallpaperCategory.clubs, subject: 'Bayern Munich', imagePath: '$_p/clubs/club_bayern_001.jpg', tags: ['bayern', 'bundesliga'], subtitle: 'Mia San Mia', downloads: 30000, likes: 7400, views: 118000),
  _w(id: 'club_psg_001', title: 'PSG', category: WallpaperCategory.clubs, subject: 'Paris Saint-Germain', imagePath: '$_p/clubs/club_psg_001.jpg', tags: ['psg', 'ligue 1', 'paris'], subtitle: 'Paris Nights', downloads: 27000, likes: 6800, views: 109000),
  _w(id: 'club_arsenal_001', title: 'Arsenal', category: WallpaperCategory.clubs, subject: 'Arsenal', imagePath: '$_p/clubs/club_arsenal_001.jpg', tags: ['arsenal', 'premier league'], subtitle: 'Gunners', downloads: 34000, likes: 8600, views: 132000),
  _w(id: 'club_chelsea_001', title: 'Chelsea', category: WallpaperCategory.clubs, subject: 'Chelsea', imagePath: '$_p/clubs/club_chelsea_001.jpg', tags: ['chelsea', 'premier league'], subtitle: 'The Blues', downloads: 25000, likes: 6100, views: 97000),
  _w(id: 'club_juventus_001', title: 'Juventus', category: WallpaperCategory.clubs, subject: 'Juventus', imagePath: '$_p/clubs/club_juventus_001.jpg', tags: ['juventus', 'serie a'], subtitle: 'Bianconeri', downloads: 21000, likes: 5200, views: 83000),
  _w(id: 'club_inter_001', title: 'Inter', category: WallpaperCategory.clubs, subject: 'Inter Milan', imagePath: '$_p/clubs/club_inter_001.jpg', tags: ['inter', 'serie a'], subtitle: 'Nerazzurri', downloads: 19800, likes: 4900, views: 77000),
  _w(id: 'club_ac_milan_001', title: 'AC Milan', category: WallpaperCategory.clubs, subject: 'AC Milan', imagePath: '$_p/clubs/club_ac_milan_001.jpg', tags: ['milan', 'serie a'], subtitle: 'Rossoneri', downloads: 20500, likes: 5100, views: 80000),
  _w(id: 'club_dortmund_001', title: 'Dortmund', category: WallpaperCategory.clubs, subject: 'Borussia Dortmund', imagePath: '$_p/clubs/club_dortmund_001.jpg', tags: ['dortmund', 'bundesliga', 'yellow wall'], subtitle: 'Yellow Wall', downloads: 22400, likes: 5800, views: 89000),
  _w(id: 'club_ajax_001', title: 'Ajax', category: WallpaperCategory.clubs, subject: 'Ajax', imagePath: '$_p/clubs/club_ajax_001.jpg', tags: ['ajax', 'eredivisie'], subtitle: 'Godenzonen', downloads: 14200, likes: 3300, views: 54000),
  _w(id: 'club_napoli_001', title: 'Napoli', category: WallpaperCategory.clubs, subject: 'Napoli', imagePath: '$_p/clubs/club_napoli_001.jpg', tags: ['napoli', 'serie a'], subtitle: 'Azzurri', downloads: 16800, likes: 4000, views: 64000),
  _w(id: 'club_atletico_001', title: 'Atletico', category: WallpaperCategory.clubs, subject: 'Atlético Madrid', imagePath: '$_p/clubs/club_atletico_001.jpg', tags: ['atletico', 'la liga'], subtitle: 'Simeone Fire', downloads: 15100, likes: 3600, views: 58000),
  _w(id: 'club_tottenham_001', title: 'Tottenham', category: WallpaperCategory.clubs, subject: 'Tottenham', imagePath: '$_p/clubs/club_tottenham_001.jpg', tags: ['tottenham', 'premier league'], subtitle: 'Lilywhites', downloads: 14700, likes: 3500, views: 56000),
  _w(id: 'club_newcastle_001', title: 'Newcastle', category: WallpaperCategory.clubs, subject: 'Newcastle United', imagePath: '$_p/clubs/club_newcastle_001.jpg', tags: ['newcastle', 'premier league'], subtitle: 'Magpies', downloads: 13900, likes: 3200, views: 51000),
  _w(id: 'club_benfica_001', title: 'Benfica', category: WallpaperCategory.clubs, subject: 'Benfica', imagePath: '$_p/clubs/club_benfica_001.jpg', tags: ['benfica', 'portugal'], subtitle: 'Eagles', downloads: 12100, likes: 2800, views: 45000),
  _w(id: 'club_porto_001', title: 'Porto', category: WallpaperCategory.clubs, subject: 'Porto', imagePath: '$_p/clubs/club_porto_001.jpg', tags: ['porto', 'portugal'], subtitle: 'Dragons', downloads: 11000, likes: 2500, views: 41000),
  _w(id: 'club_sporting_001', title: 'Sporting', category: WallpaperCategory.clubs, subject: 'Sporting CP', imagePath: '$_p/clubs/club_sporting_001.jpg', tags: ['sporting', 'portugal'], subtitle: 'Lions', downloads: 10400, likes: 2400, views: 39000),
  _w(id: 'club_river_plate_001', title: 'River Plate', category: WallpaperCategory.clubs, subject: 'River Plate', imagePath: '$_p/clubs/club_river_plate_001.jpg', tags: ['river plate', 'argentina'], subtitle: 'La Banda', downloads: 9800, likes: 2200, views: 36000),
  _w(id: 'club_boca_001', title: 'Boca', category: WallpaperCategory.clubs, subject: 'Boca Juniors', imagePath: '$_p/clubs/club_boca_001.jpg', tags: ['boca', 'argentina'], subtitle: 'Xeneize', downloads: 10200, likes: 2300, views: 38000),
  _w(id: 'club_flamengo_001', title: 'Flamengo', category: WallpaperCategory.clubs, subject: 'Flamengo', imagePath: '$_p/clubs/club_flamengo_001.jpg', tags: ['flamengo', 'brazil'], subtitle: 'Mengão', downloads: 11600, likes: 2700, views: 44000),

  _w(id: 'national_argentina_001', title: 'Argentina', category: WallpaperCategory.nationalTeams, subject: 'Argentina', imagePath: '$_p/national_teams/national_argentina_001.jpg', tags: ['argentina', 'world cup', 'messi'], subtitle: 'La Albiceleste', featured: true, trending: true, downloads: 61000, likes: 15000, views: 255000),
  _w(id: 'national_portugal_001', title: 'Portugal', category: WallpaperCategory.nationalTeams, subject: 'Portugal', imagePath: '$_p/national_teams/national_portugal_001.jpg', tags: ['portugal', 'ronaldo'], subtitle: 'Seleção das Quinas', downloads: 34000, likes: 8200, views: 129000),
  _w(id: 'national_brazil_001', title: 'Brazil', category: WallpaperCategory.nationalTeams, subject: 'Brazil', imagePath: '$_p/national_teams/national_brazil_001.jpg', tags: ['brazil', 'selecao'], subtitle: 'Seleção', downloads: 42000, likes: 11000, views: 171000),
  _w(id: 'national_france_001', title: 'France', category: WallpaperCategory.nationalTeams, subject: 'France', imagePath: '$_p/national_teams/national_france_001.jpg', tags: ['france', 'les bleus'], subtitle: 'Les Bleus', downloads: 36000, likes: 9000, views: 140000),
  _w(id: 'national_england_001', title: 'England', category: WallpaperCategory.nationalTeams, subject: 'England', imagePath: '$_p/national_teams/national_england_001.jpg', tags: ['england', 'three lions'], subtitle: 'Three Lions', downloads: 31000, likes: 7600, views: 118000),
  _w(id: 'national_spain_001', title: 'Spain', category: WallpaperCategory.nationalTeams, subject: 'Spain', imagePath: '$_p/national_teams/national_spain_001.jpg', tags: ['spain', 'la roja', 'euros'], subtitle: 'La Roja', downloads: 28000, likes: 6900, views: 108000),
  _w(id: 'national_germany_001', title: 'Germany', category: WallpaperCategory.nationalTeams, subject: 'Germany', imagePath: '$_p/national_teams/national_germany_001.jpg', tags: ['germany', 'die mannschaft'], subtitle: 'Die Mannschaft', downloads: 24000, likes: 5800, views: 91000),
  _w(id: 'national_italy_001', title: 'Italy', category: WallpaperCategory.nationalTeams, subject: 'Italy', imagePath: '$_p/national_teams/national_italy_001.jpg', tags: ['italy', 'azzurri'], subtitle: 'Azzurri', downloads: 22000, likes: 5400, views: 84000),
  _w(id: 'national_netherlands_001', title: 'Netherlands', category: WallpaperCategory.nationalTeams, subject: 'Netherlands', imagePath: '$_p/national_teams/national_netherlands_001.jpg', tags: ['netherlands', 'oranje'], subtitle: 'Oranje', downloads: 19000, likes: 4600, views: 72000),
  _w(id: 'national_egypt_001', title: 'Egypt', category: WallpaperCategory.nationalTeams, subject: 'Egypt', imagePath: '$_p/national_teams/national_egypt_001.jpg', tags: ['egypt', 'salah', 'pharaohs'], subtitle: 'The Pharaohs', downloads: 21000, likes: 5200, views: 80000),
  _w(id: 'national_morocco_001', title: 'Morocco', category: WallpaperCategory.nationalTeams, subject: 'Morocco', imagePath: '$_p/national_teams/national_morocco_001.jpg', tags: ['morocco', 'atlas lions'], subtitle: 'Atlas Lions', downloads: 17000, likes: 4100, views: 65000),
  _w(id: 'national_japan_001', title: 'Japan', category: WallpaperCategory.nationalTeams, subject: 'Japan', imagePath: '$_p/national_teams/national_japan_001.jpg', tags: ['japan', 'samurai blue'], subtitle: 'Samurai Blue', downloads: 16000, likes: 3900, views: 61000),
  _w(id: 'national_croatia_001', title: 'Croatia', category: WallpaperCategory.nationalTeams, subject: 'Croatia', imagePath: '$_p/national_teams/national_croatia_001.jpg', tags: ['croatia', 'vatreni'], subtitle: 'Vatreni', downloads: 15000, likes: 3600, views: 57000),
  _w(id: 'national_belgium_001', title: 'Belgium', category: WallpaperCategory.nationalTeams, subject: 'Belgium', imagePath: '$_p/national_teams/national_belgium_001.jpg', tags: ['belgium', 'red devils'], subtitle: 'Red Devils', downloads: 14000, likes: 3300, views: 53000),
  _w(id: 'national_uruguay_001', title: 'Uruguay', category: WallpaperCategory.nationalTeams, subject: 'Uruguay', imagePath: '$_p/national_teams/national_uruguay_001.jpg', tags: ['uruguay', 'celeste'], subtitle: 'La Celeste', downloads: 13000, likes: 3100, views: 49000),

  _w(id: 'legend_maradona_001', title: 'Maradona', category: WallpaperCategory.legends, subject: 'Diego Maradona', imagePath: '$_p/legends/legend_maradona_001.jpg', tags: ['maradona', 'legends', 'argentina'], subtitle: 'El Diego', featured: true, downloads: 39000, likes: 12000, views: 177000),
  _w(id: 'legend_pele_001', title: 'Pelé', category: WallpaperCategory.legends, subject: 'Pelé', imagePath: '$_p/legends/legend_pele_001.jpg', tags: ['pele', 'legends', 'brazil'], subtitle: 'O Rei', downloads: 36000, likes: 11000, views: 162000),
  _w(id: 'legend_zidane_001', title: 'Zidane', category: WallpaperCategory.legends, subject: 'Zinedine Zidane', imagePath: '$_p/legends/legend_zidane_001.jpg', tags: ['zidane', 'legends', 'france'], subtitle: 'Zizou', downloads: 28000, likes: 7400, views: 109000),
  _w(id: 'legend_ronaldo_nazario_001', title: 'Ronaldo', category: WallpaperCategory.legends, subject: 'Ronaldo Nazário', imagePath: '$_p/legends/legend_ronaldo_nazario_001.jpg', tags: ['ronaldo nazario', 'fenomeno', 'brazil'], subtitle: 'Il Fenomeno', downloads: 30000, likes: 8100, views: 121000),
  _w(id: 'legend_ronaldinho_001', title: 'Ronaldinho', category: WallpaperCategory.legends, subject: 'Ronaldinho', imagePath: '$_p/legends/legend_ronaldinho_001.jpg', tags: ['ronaldinho', 'brazil', 'barcelona'], subtitle: 'The Smile', downloads: 32000, likes: 9000, views: 134000),
  _w(id: 'legend_cruyff_001', title: 'Cruyff', category: WallpaperCategory.legends, subject: 'Johan Cruyff', imagePath: '$_p/legends/legend_cruyff_001.jpg', tags: ['cruyff', 'ajax', 'barcelona'], subtitle: 'Total Football', downloads: 21000, likes: 5600, views: 82000),
  _w(id: 'legend_beckenbauer_001', title: 'Beckenbauer', category: WallpaperCategory.legends, subject: 'Franz Beckenbauer', imagePath: '$_p/legends/legend_beckenbauer_001.jpg', tags: ['beckenbauer', 'bayern', 'germany'], subtitle: 'Der Kaiser', downloads: 19000, likes: 4900, views: 74000),
  _w(id: 'legend_gerrard_001', title: 'Gerrard', category: WallpaperCategory.legends, subject: 'Steven Gerrard', imagePath: '$_p/legends/legend_gerrard_001.jpg', tags: ['gerrard', 'liverpool', 'england'], subtitle: 'Captain Fantastic', downloads: 22000, likes: 6100, views: 88000),
  _w(id: 'legend_henry_001', title: 'Henry', category: WallpaperCategory.legends, subject: 'Thierry Henry', imagePath: '$_p/legends/legend_henry_001.jpg', tags: ['henry', 'arsenal', 'france'], subtitle: 'Va Va Voom', downloads: 24000, likes: 6700, views: 93000),
  _w(id: 'legend_iniesta_001', title: 'Iniesta', category: WallpaperCategory.legends, subject: 'Andrés Iniesta', imagePath: '$_p/legends/legend_iniesta_001.jpg', tags: ['iniesta', 'barcelona', 'spain'], subtitle: 'Don Andrés', downloads: 20000, likes: 5300, views: 79000),

  _w(id: 'stadium_001', title: 'Champions Night', category: WallpaperCategory.championsLeague, subject: 'Wembley', imagePath: '$_p/stadiums/stadium_001.jpg', tags: ['champions league', 'wembley', 'final', 'stadiums'], subtitle: 'Wembley Final', featured: true, trending: true, downloads: 63000, likes: 12400, views: 189000),
  _w(id: 'stadium_002', title: 'Night Glory', category: WallpaperCategory.stadiums, subject: 'Stadium Bowl', imagePath: '$_p/stadiums/stadium_002.jpg', tags: ['stadiums', 'night', 'floodlights'], subtitle: 'Floodlight Bowl', trending: true, downloads: 28000, likes: 6400, views: 101000),
  _w(id: 'stadium_003', title: 'Sea of Light', category: WallpaperCategory.stadiums, subject: 'Crowd', imagePath: '$_p/stadiums/stadium_003.jpg', tags: ['stadiums', 'crowd'], subtitle: 'Crowd Ocean', trending: true, downloads: 24000, likes: 5800, views: 90000),
  _w(id: 'stadium_004', title: 'Thunder Crowd', category: WallpaperCategory.stadiums, subject: 'Matchday', imagePath: '$_p/stadiums/stadium_004.jpg', tags: ['stadiums', 'crowd', 'night'], subtitle: 'Matchday Roar', downloads: 21000, likes: 4900, views: 78000),
  _w(id: 'stadium_005', title: 'Full House', category: WallpaperCategory.stadiums, subject: 'Sold Out', imagePath: '$_p/stadiums/stadium_005.jpg', tags: ['stadiums', 'sold out'], subtitle: 'Sold Out', downloads: 18000, likes: 4200, views: 67000),
  _w(id: 'stadium_006', title: 'Green Cathedral', category: WallpaperCategory.minimal, subject: 'Pitch', imagePath: '$_p/stadiums/stadium_006.jpg', tags: ['minimal', 'pitch', 'stadiums'], subtitle: 'Sacred Pitch', downloads: 16000, likes: 3800, views: 60000),
  _w(id: 'stadium_007', title: 'Twilight Bowl', category: WallpaperCategory.stadiums, subject: 'Twilight', imagePath: '$_p/stadiums/stadium_007.jpg', tags: ['stadiums', 'twilight'], subtitle: 'Purple Hour', downloads: 15000, likes: 3600, views: 57000),
  _w(id: 'stadium_008', title: 'Corner Lights', category: WallpaperCategory.stadiums, subject: 'Corner Flag', imagePath: '$_p/stadiums/stadium_008.jpg', tags: ['stadiums', 'corner'], subtitle: 'Flag Side', downloads: 14000, likes: 3300, views: 52000),
  _w(id: 'stadium_009', title: 'Tunnel Walk', category: WallpaperCategory.stadiums, subject: 'Tunnel', imagePath: '$_p/stadiums/stadium_009.jpg', tags: ['stadiums', 'tunnel'], subtitle: 'Into the Light', downloads: 17000, likes: 4000, views: 64000),
  _w(id: 'stadium_010', title: 'Midnight Match', category: WallpaperCategory.championsLeague, subject: 'Pitch Night', imagePath: '$_p/stadiums/stadium_010.jpg', tags: ['champions league', 'midnight', 'minimal'], subtitle: 'Emerald Field', trending: true, downloads: 19000, likes: 4500, views: 72000),

  _w(id: 'football_3d_001', title: 'UCL Trophy', category: WallpaperCategory.art3d, subject: 'Champions League', imagePath: '$_p/3d/football_3d_001.jpg', tags: ['live', 'animated', '3d', 'champions league', 'trophy', 'ucl'], subtitle: 'The Cup', featured: true, trending: true, downloads: 77000, likes: 17100, views: 312000),
  _w(id: 'football_3d_002', title: 'World Cup', category: WallpaperCategory.art3d, subject: 'World Cup', imagePath: '$_p/3d/football_3d_002.jpg', tags: ['live', 'animated', '3d', 'world cup', 'trophy', 'final'], subtitle: 'The Greatest Prize', trending: true, downloads: 65000, likes: 15000, views: 280000),
  _w(id: 'football_3d_003', title: 'EURO Trophy', category: WallpaperCategory.art3d, subject: 'European Championship', imagePath: '$_p/3d/football_3d_003.jpg', tags: ['live', 'animated', '3d', 'euros', 'trophy', 'uefa'], subtitle: 'Nations of Europe', downloads: 28000, likes: 7200, views: 119000),
  _w(id: 'football_3d_004', title: 'Goal', category: WallpaperCategory.art3d, subject: 'Goal Net', imagePath: '$_p/3d/football_3d_004.jpg', tags: ['live', 'animated', '3d', 'goal', 'net', 'moment'], subtitle: 'Ball in the Net', downloads: 22000, likes: 5400, views: 88000),
  _w(id: 'football_3d_005', title: 'Penalty', category: WallpaperCategory.art3d, subject: 'Penalty Spot', imagePath: '$_p/3d/football_3d_005.jpg', tags: ['live', 'animated', '3d', 'penalty', 'spot'], subtitle: 'The Spot', downloads: 18000, likes: 4300, views: 71000),
  _w(id: 'football_3d_006', title: 'Captain', category: WallpaperCategory.art3d, subject: 'Captain Armband', imagePath: '$_p/3d/football_3d_006.jpg', tags: ['live', 'animated', '3d', 'captain', 'armband'], subtitle: 'The Armband', downloads: 14000, likes: 3300, views: 54000),
  _w(id: 'football_3d_007', title: 'Final Night', category: WallpaperCategory.art3d, subject: 'UCL Final', imagePath: '$_p/3d/football_3d_007.jpg', tags: ['live', 'animated', '3d', 'champions league', 'final'], subtitle: 'European Glory', downloads: 26000, likes: 6100, views: 99000),
  _w(id: 'football_3d_008', title: 'World Champions', category: WallpaperCategory.art3d, subject: 'World Cup Final', imagePath: '$_p/3d/football_3d_008.jpg', tags: ['live', 'animated', '3d', 'world cup', 'final'], subtitle: 'Final Whistle', downloads: 24000, likes: 5800, views: 92000),
  _w(id: 'football_3d_009', title: 'Top Corner', category: WallpaperCategory.art3d, subject: 'Goal', imagePath: '$_p/3d/football_3d_009.jpg', tags: ['live', 'animated', '3d', 'goal', 'strike'], subtitle: 'Unstoppable', downloads: 16000, likes: 3900, views: 63000),
  _w(id: 'football_3d_010', title: 'Last Kick', category: WallpaperCategory.art3d, subject: 'Penalty', imagePath: '$_p/3d/football_3d_010.jpg', tags: ['live', 'animated', '3d', 'penalty'], subtitle: 'Sudden Death', trending: true, downloads: 15000, likes: 3600, views: 58000),
];

class WallpaperRepository {
  List<Wallpaper> get all => wallpaperCatalog;

  Wallpaper get wallpaperOfTheDay =>
      wallpaperCatalog.firstWhere((w) => w.id == 'player_messi_001');

  List<Wallpaper> get tournaments => wallpaperCatalog
      .where((w) =>
          w.tags.contains('trophy') ||
          w.tags.contains('champions league') ||
          w.tags.contains('world cup') ||
          w.tags.contains('euros'))
      .toList();

  List<Wallpaper> get featured => wallpaperCatalog.where((w) => w.featured).toList();

  List<Wallpaper> get trending => wallpaperCatalog.where((w) => w.trending).toList();

  List<Wallpaper> get newest => wallpaperCatalog.reversed.take(12).toList();

  List<Wallpaper> byCategory(WallpaperCategory category) {
    if (category == WallpaperCategory.art3d) {
      return wallpaperCatalog.where((w) => w.animated || w.tags.contains('live') || w.tags.contains('3d')).toList();
    }
    if (category == WallpaperCategory.leagues) {
      return wallpaperCatalog
          .where((w) => w.tags.any((t) => t.contains('league') || t.contains('liga') || t.contains('serie') || t.contains('bundesliga')))
          .toList();
    }
    if (category == WallpaperCategory.quotes) {
      return wallpaperCatalog.where((w) => w.category == WallpaperCategory.legends).toList();
    }
    if (category == WallpaperCategory.minimal) {
      return wallpaperCatalog.where((w) => w.category == WallpaperCategory.minimal || w.tags.contains('minimal')).toList();
    }
    if (category == WallpaperCategory.championsLeague) {
      return wallpaperCatalog
          .where((w) => w.category == WallpaperCategory.championsLeague || w.tags.contains('champions league'))
          .toList();
    }
    return wallpaperCatalog.where((w) => w.category == category || w.subject.toLowerCase().contains(category.label.toLowerCase())).toList();
  }

  List<Wallpaper> search(String query) => wallpaperCatalog.where((w) => w.matches(query)).toList();

  List<Wallpaper> uniqueBySubject(WallpaperCategory category) {
    final seen = <String>{};
    final out = <Wallpaper>[];
    for (final w in byCategory(category)) {
      if (seen.add(w.subject)) out.add(w);
    }
    return out;
  }

  List<Wallpaper> related(Wallpaper wallpaper) {
    final samePlayer = wallpaperCatalog
        .where((w) => w.id != wallpaper.id && w.subject == wallpaper.subject)
        .toList();
    final sameCategory = wallpaperCatalog.where(
      (w) => w.id != wallpaper.id && w.subject != wallpaper.subject && w.category == wallpaper.category,
    );
    return [...samePlayer, ...sameCategory].take(8).toList();
  }

  Wallpaper? byId(String id) {
    try {
      return wallpaperCatalog.firstWhere((w) => w.id == id);
    } catch (_) {
      return null;
    }
  }

  int countFor(WallpaperCategory category) => byCategory(category).length;
}
