# Rebuild clubs / nations / stadiums / legends / categories / 3D with unique cinematic sources. No Wikimedia.
$ErrorActionPreference = "Stop"
Add-Type -AssemblyName System.Drawing
$src = "C:\Users\marin\.cursor\projects\c-Users-marin-WALLPEPER\assets"
$out = "c:\Users\marin\WALLPEPER\assets\images"
$W = 1080; $H = 1920

function Get-Encoder([string]$mime) {
  foreach ($c in [System.Drawing.Imaging.ImageCodecInfo]::GetImageEncoders()) {
    if ($c.MimeType -eq $mime) { return $c }
  }
  return $null
}
function Save-Jpeg($bmp, $path) {
  $dir = Split-Path $path
  if (-not (Test-Path $dir)) { New-Item -ItemType Directory -Force -Path $dir | Out-Null }
  $enc = Get-Encoder "image/jpeg"
  $ep = New-Object System.Drawing.Imaging.EncoderParameters 1
  $ep.Param[0] = New-Object System.Drawing.Imaging.EncoderParameter ([System.Drawing.Imaging.Encoder]::Quality, [long]90)
  $bmp.Save($path, $enc, $ep)
  $ep.Dispose()
}
function Compose([string]$srcPath, [string]$dest, [string]$title, [string]$sub) {
  if (-not (Test-Path $srcPath)) { throw "missing $srcPath" }
  $img = [System.Drawing.Image]::FromFile($srcPath)
  $bmp = New-Object System.Drawing.Bitmap $W, $H
  $g = [System.Drawing.Graphics]::FromImage($bmp)
  $g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
  $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
  $g.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::AntiAliasGridFit
  $scale = [Math]::Max($W / [double]$img.Width, $H / [double]$img.Height) * 1.02
  $nw = [int]($img.Width * $scale); $nh = [int]($img.Height * $scale)
  $x = [int](($W - $nw) / 2); $y = [int](($H - $nh) / 2)
  $g.DrawImage($img, $x, $y, $nw, $nh)
  $img.Dispose()
  $fadeRect = New-Object System.Drawing.Rectangle 0, ([int]($H * 0.62)), $W, ([int]($H * 0.38))
  $c0 = [System.Drawing.Color]::FromArgb(0,0,0,0)
  $c1 = [System.Drawing.Color]::FromArgb(210,0,0,0)
  $fade = New-Object System.Drawing.Drawing2D.LinearGradientBrush $fadeRect, $c0, $c1, 90.0
  $g.FillRectangle($fade, $fadeRect); $fade.Dispose()
  $accent = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(255,57,255,20))
  $g.FillRectangle($accent, 48, [int]($H * 0.74), 54, 6); $accent.Dispose()
  $tf = New-Object System.Drawing.Font "Segoe UI", 32, ([System.Drawing.FontStyle]::Bold)
  $sf = New-Object System.Drawing.Font "Segoe UI", 14
  $white = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::White)
  $muted = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(210,200,210,205))
  $g.DrawString($title.ToUpper(), $tf, $white, 48, [int]($H * 0.78))
  $g.DrawString($sub, $sf, $muted, 48, [int]($H * 0.88))
  $tf.Dispose(); $sf.Dispose(); $white.Dispose(); $muted.Dispose(); $g.Dispose()
  Save-Jpeg $bmp $dest
  $bmp.Dispose()
  Write-Host $dest
}

$map = @(
  @{ r="wallpapers\clubs\club_real_madrid_001.jpg"; s="club_madrid_stadium.png"; t="REAL MADRID"; u="Los Blancos" },
  @{ r="wallpapers\clubs\club_real_madrid_002.jpg"; s="scene_madrid_night.png"; t="MADRID NIGHT"; u="Bernabeu Glow" },
  @{ r="wallpapers\clubs\club_barcelona_001.jpg"; s="club_barca_stadium.png"; t="BARCELONA"; u="Blaugrana" },
  @{ r="wallpapers\clubs\club_liverpool_001.jpg"; s="club_liverpool_stadium.png"; t="LIVERPOOL"; u="You'll Never Walk Alone" },
  @{ r="wallpapers\clubs\club_liverpool_002.jpg"; s="scene_anfield_night.png"; t="ANFIELD"; u="This Is Anfield" },
  @{ r="wallpapers\clubs\club_man_city_001.jpg"; s="club_city_stadium.png"; t="MAN CITY"; u="Sky Blue" },
  @{ r="wallpapers\clubs\club_bayern_001.jpg"; s="scene_red_stands.png"; t="BAYERN"; u="Mia San Mia" },
  @{ r="wallpapers\clubs\club_psg_001.jpg"; s="scene_paris_night.png"; t="PSG"; u="Paris Nights" },
  @{ r="wallpapers\clubs\club_arsenal_001.jpg"; s="scene_red_devils.png"; t="ARSENAL"; u="Gunners" },
  @{ r="wallpapers\clubs\club_chelsea_001.jpg"; s="scene_royal_blue.png"; t="CHELSEA"; u="The Blues" },
  @{ r="wallpapers\clubs\club_juventus_001.jpg"; s="scene_black_white.png"; t="JUVENTUS"; u="Bianconeri" },
  @{ r="wallpapers\clubs\club_inter_001.jpg"; s="scene_neroazzurro.png"; t="INTER"; u="Nerazzurri" },
  @{ r="wallpapers\clubs\club_ac_milan_001.jpg"; s="scene_rossoneri.png"; t="AC MILAN"; u="Rossoneri" },
  @{ r="wallpapers\clubs\club_dortmund_001.jpg"; s="scene_yellow_wall.png"; t="DORTMUND"; u="Yellow Wall" },
  @{ r="wallpapers\clubs\club_ajax_001.jpg"; s="scene_blaugrana_night.png"; t="AJAX"; u="Godenzonen" },
  @{ r="wallpapers\clubs\club_napoli_001.jpg"; s="scene_azzurri.png"; t="NAPOLI"; u="Azzurri" },
  @{ r="wallpapers\clubs\club_atletico_001.jpg"; s="hero_crowd_wave.png"; t="ATLETICO"; u="Simeone Fire" },
  @{ r="wallpapers\clubs\club_tottenham_001.jpg"; s="scene_lilywhite.png"; t="TOTTENHAM"; u="Lilywhites" },
  @{ r="wallpapers\clubs\club_newcastle_001.jpg"; s="scene_navy_stripes.png"; t="NEWCASTLE"; u="Magpies" },
  @{ r="wallpapers\clubs\club_benfica_001.jpg"; s="hero_club_gold.png"; t="BENFICA"; u="Eagles" },
  @{ r="wallpapers\clubs\club_porto_001.jpg"; s="scene_sky_blue_night.png"; t="PORTO"; u="Dragons" },
  @{ r="wallpapers\clubs\club_sporting_001.jpg"; s="scene_green_gold.png"; t="SPORTING"; u="Lions" },
  @{ r="wallpapers\clubs\club_river_plate_001.jpg"; s="hero_pitch_lines.png"; t="RIVER PLATE"; u="La Banda" },
  @{ r="wallpapers\clubs\club_boca_001.jpg"; s="scene_boca.png"; t="BOCA"; u="Xeneize" },
  @{ r="wallpapers\clubs\club_flamengo_001.jpg"; s="scene_mengao.png"; t="FLAMENGO"; u="Mengao" },
  @{ r="wallpapers\national_teams\national_argentina_001.jpg"; s="hero_argentina_abstract.png"; t="ARGENTINA"; u="La Albiceleste" },
  @{ r="wallpapers\national_teams\national_portugal_001.jpg"; s="hero_portugal_smoke.png"; t="PORTUGAL"; u="Selecao" },
  @{ r="wallpapers\national_teams\national_brazil_001.jpg"; s="hero_brazil_gold.png"; t="BRAZIL"; u="Selecao" },
  @{ r="wallpapers\national_teams\national_france_001.jpg"; s="hero_france_navy.png"; t="FRANCE"; u="Les Bleus" },
  @{ r="wallpapers\national_teams\national_england_001.jpg"; s="hero_england_navy.png"; t="ENGLAND"; u="Three Lions" },
  @{ r="wallpapers\national_teams\national_spain_001.jpg"; s="national_france_back.png"; t="SPAIN"; u="La Roja" },
  @{ r="wallpapers\national_teams\national_germany_001.jpg"; s="hero_stadium_night.png"; t="GERMANY"; u="Die Mannschaft" },
  @{ r="wallpapers\national_teams\national_italy_001.jpg"; s="scene_celeste.png"; t="ITALY"; u="Azzurri" },
  @{ r="wallpapers\national_teams\national_netherlands_001.jpg"; s="scene_oranje.png"; t="NETHERLANDS"; u="Oranje" },
  @{ r="wallpapers\national_teams\national_egypt_001.jpg"; s="scene_pharaohs.png"; t="EGYPT"; u="The Pharaohs" },
  @{ r="wallpapers\national_teams\national_morocco_001.jpg"; s="scene_atlas.png"; t="MOROCCO"; u="Atlas Lions" },
  @{ r="wallpapers\national_teams\national_japan_001.jpg"; s="scene_samurai_blue.png"; t="JAPAN"; u="Samurai Blue" },
  @{ r="wallpapers\national_teams\national_croatia_001.jpg"; s="scene_vatreni.png"; t="CROATIA"; u="Vatreni" },
  @{ r="wallpapers\national_teams\national_belgium_001.jpg"; s="scene_desert_gold.png"; t="BELGIUM"; u="Red Devils" },
  @{ r="wallpapers\national_teams\national_uruguay_001.jpg"; s="hero_twilight_bowl.png"; t="URUGUAY"; u="La Celeste" },
  @{ r="wallpapers\legends\legend_maradona_001.jpg"; s="scene_legends_gold.png"; t="MARADONA"; u="El Diego" },
  @{ r="wallpapers\legends\legend_pele_001.jpg"; s="hero_golden_strike.png"; t="PELE"; u="O Rei" },
  @{ r="wallpapers\legends\legend_zidane_001.jpg"; s="hero_legends_gold.png"; t="ZIDANE"; u="Zizou" },
  @{ r="wallpapers\legends\legend_ronaldo_nazario_001.jpg"; s="hero_3d_neon.png"; t="RONALDO"; u="Il Fenomeno" },
  @{ r="wallpapers\legends\legend_ronaldinho_001.jpg"; s="hero_3d_hologram.png"; t="RONALDINHO"; u="The Smile" },
  @{ r="wallpapers\legends\legend_cruyff_001.jpg"; s="hero_3d_liquid.png"; t="CRUYFF"; u="Total Football" },
  @{ r="wallpapers\legends\legend_beckenbauer_001.jpg"; s="hero_3d_shards.png"; t="BECKENBAUER"; u="Der Kaiser" },
  @{ r="wallpapers\legends\legend_gerrard_001.jpg"; s="moment_captain.png"; t="GERRARD"; u="Captain Fantastic" },
  @{ r="wallpapers\legends\legend_henry_001.jpg"; s="moment_goal_net.png"; t="HENRY"; u="Va Va Voom" },
  @{ r="wallpapers\legends\legend_iniesta_001.jpg"; s="moment_penalty.png"; t="INIESTA"; u="Don Andres" },
  @{ r="wallpapers\stadiums\stadium_001.jpg"; s="scene_wembley_final.png"; t="CHAMPIONS NIGHT"; u="Wembley Final" },
  @{ r="wallpapers\stadiums\stadium_002.jpg"; s="scene_aerial_pitch.png"; t="NIGHT GLORY"; u="Floodlight Bowl" },
  @{ r="wallpapers\stadiums\stadium_003.jpg"; s="scene_crowd_ocean.png"; t="SEA OF LIGHT"; u="Crowd Ocean" },
  @{ r="wallpapers\stadiums\stadium_004.jpg"; s="hero_tunnel.png"; t="THUNDER CROWD"; u="Matchday Roar" },
  @{ r="wallpapers\stadiums\stadium_005.jpg"; s="hero_ball_grass.png"; t="FULL HOUSE"; u="Sold Out" },
  @{ r="wallpapers\stadiums\stadium_006.jpg"; s="hero_minimal_ball.png"; t="GREEN CATHEDRAL"; u="Sacred Pitch" },
  @{ r="wallpapers\stadiums\stadium_007.jpg"; s="scene_twilight.png"; t="TWILIGHT BOWL"; u="Purple Hour" },
  @{ r="wallpapers\stadiums\stadium_008.jpg"; s="scene_corner.png"; t="CORNER LIGHTS"; u="Flag Side" },
  @{ r="wallpapers\stadiums\stadium_009.jpg"; s="scene_tunnel.png"; t="TUNNEL WALK"; u="Into the Light" },
  @{ r="wallpapers\stadiums\stadium_010.jpg"; s="hero_goal_net.png"; t="MIDNIGHT MATCH"; u="Emerald Field" },
  @{ r="wallpapers\3d\football_3d_001.jpg"; s="football_3d_001.png"; t="UCL TROPHY"; u="The Cup" },
  @{ r="wallpapers\3d\football_3d_002.jpg"; s="football_3d_002.png"; t="WORLD CUP"; u="The Greatest Prize" },
  @{ r="wallpapers\3d\football_3d_003.jpg"; s="football_3d_003.png"; t="EURO TROPHY"; u="Nations of Europe" },
  @{ r="wallpapers\3d\football_3d_004.jpg"; s="football_3d_004.png"; t="GOAL"; u="Ball in the Net" },
  @{ r="wallpapers\3d\football_3d_005.jpg"; s="football_3d_005.png"; t="PENALTY"; u="The Spot" },
  @{ r="wallpapers\3d\football_3d_006.jpg"; s="football_3d_006.png"; t="CAPTAIN"; u="The Armband" },
  @{ r="wallpapers\3d\football_3d_007.jpg"; s="football_3d_007.png"; t="FINAL NIGHT"; u="European Glory" },
  @{ r="wallpapers\3d\football_3d_008.jpg"; s="football_3d_008.png"; t="WORLD CHAMPIONS"; u="Final Whistle" },
  @{ r="wallpapers\3d\football_3d_009.jpg"; s="football_3d_009.png"; t="TOP CORNER"; u="Unstoppable" },
  @{ r="wallpapers\3d\football_3d_010.jpg"; s="football_3d_010.png"; t="LAST KICK"; u="Sudden Death" },
  @{ r="categories\players.jpg"; s="cat_players.png"; t="PLAYERS"; u="Stars" },
  @{ r="categories\clubs.jpg"; s="cat_clubs.png"; t="CLUBS"; u="Home Grounds" },
  @{ r="categories\national_teams.jpg"; s="cat_national.png"; t="NATIONS"; u="World Stage" },
  @{ r="categories\champions_league.jpg"; s="trophy_ucl.png"; t="UCL"; u="Europe Nights" },
  @{ r="categories\leagues.jpg"; s="trophy_worldcup.png"; t="LEAGUES"; u="The Game" },
  @{ r="categories\legends.jpg"; s="cat_legends.png"; t="LEGENDS"; u="Forever" },
  @{ r="categories\stadiums.jpg"; s="cat_stadiums.png"; t="STADIUMS"; u="Cathedrals" },
  @{ r="categories\3d.jpg"; s="cat_3d.png"; t="3D ART"; u="Live Motion" },
  @{ r="categories\minimal.jpg"; s="hero_corner_flag.png"; t="MINIMAL"; u="Clean Lines" },
  @{ r="categories\quotes.jpg"; s="trophy_euros.png"; t="QUOTES"; u="Words" }
)

$used = New-Object 'System.Collections.Generic.HashSet[string]'
foreach ($m in $map) {
  if (-not $used.Add($m.s)) { throw "duplicate source $($m.s)" }
  $srcPath = Join-Path $src $m.s
  $dest = Join-Path $out $m.r
  Compose $srcPath $dest $m.t $m.u
}
Write-Host "DONE $($map.Count)"
