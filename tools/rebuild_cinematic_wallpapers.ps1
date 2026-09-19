# Photoreal unique wallpapers. One source photo per output file.
$ErrorActionPreference = "Continue"
Add-Type -AssemblyName System.Drawing

$srcRoot = "C:\Users\marin\.cursor\projects\c-Users-marin-WALLPEPER\assets"
$outRoot = "c:\Users\marin\WALLPEPER\assets\images"
$W = 1080; $H = 1920
$ua = "FootballWallpaper/1.0 (local cinematic rebuild)"
$cache = Join-Path $env:TEMP "fw_photos"
New-Item -ItemType Directory -Force -Path $cache | Out-Null

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
  $ep.Param[0] = New-Object System.Drawing.Imaging.EncoderParameter ([System.Drawing.Imaging.Encoder]::Quality, [long]88)
  $bmp.Save($path, $enc, $ep)
  $ep.Dispose()
}
function Seed([string]$s) {
  $h = 2166136261L
  foreach ($ch in $s.ToCharArray()) { $h = (($h -bxor [int]$ch) * 16777619) -band 0x7fffffff }
  if ($h -eq 0) { return 1 }
  return [int]$h
}
function Compose([string]$src, [string]$dest, [string]$title, [string]$sub) {
  $img = [System.Drawing.Image]::FromFile($src)
  $bmp = New-Object System.Drawing.Bitmap $W, $H
  $g = [System.Drawing.Graphics]::FromImage($bmp)
  $g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
  $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
  $g.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::AntiAliasGridFit
  $rng = New-Object System.Random (Seed $dest)
  $scale = [Math]::Max($W / [double]$img.Width, $H / [double]$img.Height) * 1.04
  $nw = [int]($img.Width * $scale); $nh = [int]($img.Height * $scale)
  $x = [int](($W - $nw) * (0.2 + $rng.NextDouble() * 0.6))
  $y = [int](($H - $nh) * (0.15 + $rng.NextDouble() * 0.45))
  $g.DrawImage($img, $x, $y, $nw, $nh)
  $img.Dispose()
  $fadeRect = New-Object System.Drawing.Rectangle 0, ([int]($H * 0.62)), $W, ([int]($H * 0.38))
  $c0 = [System.Drawing.Color]::FromArgb(0,0,0,0)
  $c1 = [System.Drawing.Color]::FromArgb(215,0,0,0)
  $fade = New-Object System.Drawing.Drawing2D.LinearGradientBrush $fadeRect, $c0, $c1, 90.0
  $g.FillRectangle($fade, $fadeRect); $fade.Dispose()
  $accent = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(255,57,255,20))
  $g.FillRectangle($accent, 48, [int]($H * 0.74), 54, 6); $accent.Dispose()
  $tf = New-Object System.Drawing.Font "Segoe UI", 34, ([System.Drawing.FontStyle]::Bold)
  $sf = New-Object System.Drawing.Font "Segoe UI", 15
  $white = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::White)
  $muted = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(210,200,210,205))
  $g.DrawString($title.ToUpper(), $tf, $white, 48, [int]($H * 0.78))
  $g.DrawString($sub, $sf, $muted, 48, [int]($H * 0.88))
  $tf.Dispose(); $sf.Dispose(); $white.Dispose(); $muted.Dispose(); $g.Dispose()
  Save-Jpeg $bmp $dest
  $bmp.Dispose()
}

$unsplash = @(
  "1671631981648-94ccf5623255","1706675780107-7c43cc487928","1765130420895-57e4f9134b9f","1745997645080-941f962f1392",
  "1768861171882-9bbfed55b6f9","1517747614396-d21a78b850e8","1647118868186-70d38e10b0dc","1705593973313-75de7bf95b56",
  "1769859177914-f66488d71193","1665413811870-5b29a250f64a","1565483276060-e6730c0cc6a1","1556816214-fda351e4a7fb",
  "1556816214-6d16c62fbbf6","1564833592193-3270b5618e7f","1696542095251-2dff09ec6b5b","1550591901-94cca90aeab1",
  "1571754472834-677ab0a62ba7","1545525201-e1a5a2a18293","1665413813194-3b80d79b6421","1550591901-c036ab7c45f8",
  "1545558490-d4ca82897db4","1696542095242-53305aaa6d9c","1665413813191-3143ec934960","1746333253387-5aac26260c96",
  "1583558952124-8a5c7f29ab35","1579952363873-27f3bade9f55","1575361204480-aadea25e6e68","1766934824988-1fb59c99c320",
  "1574629810360-7efbbe195018","1508098682722-10791ee2ee18","1459865264687-595d452e9b1e","1431322156758-123d6d941ef5",
  "1517466787929-bc90951d0974","1577223625816-7546f13df25d","1526232761682-07aadd0b8fe4","1461896833973-e05f7d1131b8",
  "1543326727-cf6c39e8f84c","1570498839593-e626ace2ff74","1560272564-c83b66b1ad12","1489946419101-5c19c25c0c4e",
  "1518091043644-c1d4458609e6","1522778117-fd1e59eed53e","1471299904435-0263e0f46ca0","1553778263-73a95c2b2c1b"
)
$pexels = @(399187,274506,114296,1884574,46798,209977,47730,163444,1884576,3621104,47343,274422,3148452,3651674,1171084,40904,1594005,4772061,1142964,3621105)

$pool = New-Object System.Collections.Generic.List[string]
function Add-Local([string]$name) {
  $p = Join-Path $srcRoot $name
  if (Test-Path $p) { $pool.Add($p) }
}
# Unique local photoreal bases first (never reused)
@(
  "club_madrid_stadium.png","club_barca_stadium.png","club_liverpool_stadium.png","club_city_stadium.png",
  "hero_stadium_night.png","hero_tunnel.png","hero_crowd_wave.png","hero_goal_net.png","hero_ball_grass.png","hero_pitch_lines.png",
  "hero_corner_flag.png","hero_twilight_bowl.png","hero_golden_strike.png","hero_minimal_ball.png","hero_3d_neon.png",
  "hero_3d_hologram.png","hero_3d_liquid.png","hero_3d_shards.png","hero_club_gold.png","hero_legends_gold.png",
  "hero_argentina_abstract.png","hero_brazil_gold.png","hero_england_navy.png","hero_france_navy.png","hero_portugal_smoke.png",
  "trophy_ucl.png","trophy_worldcup.png","trophy_euros.png","moment_goal_net.png","moment_penalty.png","moment_captain.png",
  "national_france_back.png","cat_players.png","cat_clubs.png","cat_national.png","cat_legends.png","cat_stadiums.png","cat_3d.png"
) | ForEach-Object { Add-Local $_ }
foreach ($id in $unsplash) {
  $url = "https://images.unsplash.com/photo-${id}?auto=format&fit=crop&w=1080&h=1920&q=80"
  $pool.Add("URL:$url")
}
foreach ($id in $pexels) {
  $pool.Add("URL:https://images.pexels.com/photos/$id/pexels-photo-$id.jpeg?auto=compress&cs=tinysrgb&h=1920")
}

Write-Host "Collecting Wikimedia unique stadium photos..."
$usedWiki = New-Object 'System.Collections.Generic.HashSet[string]'
$offset = 0
while ($pool.Count -lt 280 -and $offset -lt 200) {
  $api = "https://commons.wikimedia.org/w/api.php?action=query&format=json&generator=search&gsrsearch=association%20football%20stadium&gsrnamespace=6&gsrlimit=20&gsroffset=$offset&prop=imageinfo&iiprop=url|mime|size&iiurlwidth=1080"
  $tmp = Join-Path $cache "wiki_$offset.json"
  & curl.exe -sS -L -A $ua -o $tmp $api | Out-Null
  try {
    $json = Get-Content -Raw $tmp | ConvertFrom-Json
    foreach ($prop in $json.query.pages.PSObject.Properties) {
      $ii = $prop.Value.imageinfo[0]
      if ($ii.mime -ne "image/jpeg") { continue }
      $u = [string]$ii.thumburl
      if ([string]::IsNullOrWhiteSpace($u)) { $u = [string]$ii.url }
      if ($usedWiki.Add($u)) { $pool.Add("URL:$u") }
    }
  } catch {}
  $offset += 20
}
Write-Host ("source pool=" + $pool.Count)

$jobs = New-Object System.Collections.Generic.List[object]
function J($rel,$title,$sub) { [void]$jobs.Add(@{ rel=$rel; title=$title; sub=$sub }) }

$players = @(
  @{s="messi";n="MESSI";k="Inter Miami #10"}, @{s="ronaldo";n="RONALDO";k="Al Nassr #7"}, @{s="salah";n="SALAH";k="Liverpool #11"},
  @{s="mbappe";n="MBAPPE";k="Real Madrid #10"}, @{s="haaland";n="HAALAND";k="Man City #9"}, @{s="vinicius";n="VINI JR";k="Real Madrid #7"},
  @{s="bellingham";n="BELLINGHAM";k="Real Madrid #5"}, @{s="foden";n="FODEN";k="Man City #47"}, @{s="yamal";n="YAMAL";k="Barcelona #10"},
  @{s="saka";n="SAKA";k="Arsenal #7"}, @{s="de_bruyne";n="DE BRUYNE";k="Man City #17"}, @{s="lewandowski";n="LEWANDOWSKI";k="Barcelona #9"},
  @{s="kane";n="KANE";k="Bayern #9"}, @{s="neymar";n="NEYMAR";k="Santos #10"}, @{s="benzema";n="BENZEMA";k="Al Ittihad #9"},
  @{s="modric";n="MODRIC";k="Real Madrid #10"}, @{s="rodri";n="RODRI";k="Man City #16"}, @{s="valverde";n="VALVERDE";k="Real Madrid #8"},
  @{s="pedri";n="PEDRI";k="Barcelona #8"}, @{s="gavi";n="GAVI";k="Barcelona #6"}, @{s="osimhen";n="OSIMHEN";k="Galatasaray #9"},
  @{s="courtois";n="COURTOIS";k="Real Madrid #1"}, @{s="van_dijk";n="VAN DIJK";k="Liverpool #4"}, @{s="hakimi";n="HAKIMI";k="PSG #2"},
  @{s="griezmann";n="GRIEZMANN";k="Atletico #7"}, @{s="son";n="SON";k="Tottenham #7"}, @{s="musiala";n="MUSIALA";k="Bayern #42"},
  @{s="rice";n="RICE";k="Arsenal #41"}, @{s="palmer";n="PALMER";k="Chelsea #20"}, @{s="isak";n="ISAK";k="Newcastle #14"}
)
$looks = @("Portrait","Stadium Night","Tunnel Walk","Matchday","Close-up")
foreach ($p in $players) {
  for ($i=0; $i -lt 5; $i++) {
    J ("wallpapers\players\player_{0}_{1:D3}.jpg" -f $p.s, ($i+1)) $p.n ($looks[$i] + " | " + $p.k)
  }
}
@(
  @("wallpapers\clubs\club_real_madrid_001.jpg","REAL MADRID","Los Blancos"),
  @("wallpapers\clubs\club_real_madrid_002.jpg","MADRID NIGHT","Bernabeu Glow"),
  @("wallpapers\clubs\club_barcelona_001.jpg","BARCELONA","Blaugrana"),
  @("wallpapers\clubs\club_liverpool_001.jpg","LIVERPOOL","You'll Never Walk Alone"),
  @("wallpapers\clubs\club_liverpool_002.jpg","ANFIELD","This Is Anfield"),
  @("wallpapers\clubs\club_man_city_001.jpg","MAN CITY","Sky Blue"),
  @("wallpapers\clubs\club_bayern_001.jpg","BAYERN","Mia San Mia"),
  @("wallpapers\clubs\club_psg_001.jpg","PSG","Paris Nights"),
  @("wallpapers\clubs\club_arsenal_001.jpg","ARSENAL","Gunners"),
  @("wallpapers\clubs\club_chelsea_001.jpg","CHELSEA","The Blues"),
  @("wallpapers\clubs\club_juventus_001.jpg","JUVENTUS","Bianconeri"),
  @("wallpapers\clubs\club_inter_001.jpg","INTER","Nerazzurri"),
  @("wallpapers\clubs\club_ac_milan_001.jpg","AC MILAN","Rossoneri"),
  @("wallpapers\clubs\club_dortmund_001.jpg","DORTMUND","Yellow Wall"),
  @("wallpapers\clubs\club_ajax_001.jpg","AJAX","Godenzonen"),
  @("wallpapers\clubs\club_napoli_001.jpg","NAPOLI","Azzurri"),
  @("wallpapers\clubs\club_atletico_001.jpg","ATLETICO","Simeone Fire"),
  @("wallpapers\clubs\club_tottenham_001.jpg","TOTTENHAM","Lilywhites"),
  @("wallpapers\clubs\club_newcastle_001.jpg","NEWCASTLE","Magpies"),
  @("wallpapers\clubs\club_benfica_001.jpg","BENFICA","Eagles"),
  @("wallpapers\clubs\club_porto_001.jpg","PORTO","Dragons"),
  @("wallpapers\clubs\club_sporting_001.jpg","SPORTING","Lions"),
  @("wallpapers\clubs\club_river_plate_001.jpg","RIVER PLATE","La Banda"),
  @("wallpapers\clubs\club_boca_001.jpg","BOCA","Xeneize"),
  @("wallpapers\clubs\club_flamengo_001.jpg","FLAMENGO","Mengao"),
  @("wallpapers\national_teams\national_argentina_001.jpg","ARGENTINA","La Albiceleste"),
  @("wallpapers\national_teams\national_portugal_001.jpg","PORTUGAL","Selecao"),
  @("wallpapers\national_teams\national_brazil_001.jpg","BRAZIL","Selecao"),
  @("wallpapers\national_teams\national_france_001.jpg","FRANCE","Les Bleus"),
  @("wallpapers\national_teams\national_england_001.jpg","ENGLAND","Three Lions"),
  @("wallpapers\national_teams\national_spain_001.jpg","SPAIN","La Roja"),
  @("wallpapers\national_teams\national_germany_001.jpg","GERMANY","Die Mannschaft"),
  @("wallpapers\national_teams\national_italy_001.jpg","ITALY","Azzurri"),
  @("wallpapers\national_teams\national_netherlands_001.jpg","NETHERLANDS","Oranje"),
  @("wallpapers\national_teams\national_egypt_001.jpg","EGYPT","The Pharaohs"),
  @("wallpapers\national_teams\national_morocco_001.jpg","MOROCCO","Atlas Lions"),
  @("wallpapers\national_teams\national_japan_001.jpg","JAPAN","Samurai Blue"),
  @("wallpapers\national_teams\national_croatia_001.jpg","CROATIA","Vatreni"),
  @("wallpapers\national_teams\national_belgium_001.jpg","BELGIUM","Red Devils"),
  @("wallpapers\national_teams\national_uruguay_001.jpg","URUGUAY","La Celeste"),
  @("wallpapers\legends\legend_maradona_001.jpg","MARADONA","El Diego"),
  @("wallpapers\legends\legend_pele_001.jpg","PELE","O Rei"),
  @("wallpapers\legends\legend_zidane_001.jpg","ZIDANE","Zizou"),
  @("wallpapers\legends\legend_ronaldo_nazario_001.jpg","RONALDO","Il Fenomeno"),
  @("wallpapers\legends\legend_ronaldinho_001.jpg","RONALDINHO","The Smile"),
  @("wallpapers\legends\legend_cruyff_001.jpg","CRUYFF","Total Football"),
  @("wallpapers\legends\legend_beckenbauer_001.jpg","BECKENBAUER","Der Kaiser"),
  @("wallpapers\legends\legend_gerrard_001.jpg","GERRARD","Captain Fantastic"),
  @("wallpapers\legends\legend_henry_001.jpg","HENRY","Va Va Voom"),
  @("wallpapers\legends\legend_iniesta_001.jpg","INIESTA","Don Andres"),
  @("wallpapers\stadiums\stadium_001.jpg","CHAMPIONS NIGHT","Wembley Final"),
  @("wallpapers\stadiums\stadium_002.jpg","NIGHT GLORY","Floodlight Bowl"),
  @("wallpapers\stadiums\stadium_003.jpg","SEA OF LIGHT","Crowd Ocean"),
  @("wallpapers\stadiums\stadium_004.jpg","THUNDER CROWD","Matchday Roar"),
  @("wallpapers\stadiums\stadium_005.jpg","FULL HOUSE","Sold Out"),
  @("wallpapers\stadiums\stadium_006.jpg","GREEN CATHEDRAL","Sacred Pitch"),
  @("wallpapers\stadiums\stadium_007.jpg","TWILIGHT BOWL","Purple Hour"),
  @("wallpapers\stadiums\stadium_008.jpg","CORNER LIGHTS","Flag Side"),
  @("wallpapers\stadiums\stadium_009.jpg","TUNNEL WALK","Into the Light"),
  @("wallpapers\stadiums\stadium_010.jpg","MIDNIGHT MATCH","Emerald Field"),
  @("wallpapers\3d\football_3d_001.jpg","UCL TROPHY","The Cup"),
  @("wallpapers\3d\football_3d_002.jpg","WORLD CUP","The Greatest Prize"),
  @("wallpapers\3d\football_3d_003.jpg","EURO TROPHY","Nations of Europe"),
  @("wallpapers\3d\football_3d_004.jpg","GOAL","Ball in the Net"),
  @("wallpapers\3d\football_3d_005.jpg","PENALTY","The Spot"),
  @("wallpapers\3d\football_3d_006.jpg","CAPTAIN","The Armband"),
  @("wallpapers\3d\football_3d_007.jpg","FINAL NIGHT","European Glory"),
  @("wallpapers\3d\football_3d_008.jpg","WORLD CHAMPIONS","Final Whistle"),
  @("wallpapers\3d\football_3d_009.jpg","TOP CORNER","Unstoppable"),
  @("wallpapers\3d\football_3d_010.jpg","LAST KICK","Sudden Death"),
  @("categories\players.jpg","PLAYERS","Stars"),
  @("categories\clubs.jpg","CLUBS","Home Grounds"),
  @("categories\national_teams.jpg","NATIONS","World Stage"),
  @("categories\champions_league.jpg","UCL","Europe Nights"),
  @("categories\leagues.jpg","LEAGUES","The Game"),
  @("categories\legends.jpg","LEGENDS","Forever"),
  @("categories\stadiums.jpg","STADIUMS","Cathedrals"),
  @("categories\3d.jpg","3D ART","Live Motion"),
  @("categories\minimal.jpg","MINIMAL","Clean Lines"),
  @("categories\quotes.jpg","QUOTES","Words")
) | ForEach-Object { J $_[0] $_[1] $_[2] }

Write-Host ("jobs=" + $jobs.Count)
$pi = 0
$ok = 0
function Resolve-Source([string]$rel) {
  $name = [IO.Path]::GetFileNameWithoutExtension($rel)
  if ($name -match '^player_(.+)_001$') {
    $back = Join-Path $srcRoot ("player_{0}_back.png" -f $Matches[1])
    if (Test-Path $back) { return $back }
  }
  if ($name -match '^football_3d_\d+$') {
    $png = Join-Path $srcRoot ($name + ".png")
    if (Test-Path $png) { return $png }
  }
  return $null
}
foreach ($job in $jobs) {
  $dest = Join-Path $outRoot $job.rel
  $got = $false
  $forced = Resolve-Source $job.rel
  $candidates = @()
  if ($forced) { $candidates += $forced }
  $candidates += ,@()
  try {
    if ($forced -and (Test-Path $forced)) {
      Compose $forced $dest $job.title $job.sub
      $got = $true; $ok++; Write-Host "fixed $($job.rel)"
      continue
    }
  } catch { Write-Host "forced fail $($job.rel) $_" }
  while ($pi -lt $pool.Count -and -not $got) {
    $src = $pool[$pi]; $pi++
    try {
      if ($src.StartsWith("URL:")) {
        $url = $src.Substring(4)
        $tmp = Join-Path $cache ([IO.Path]::GetFileNameWithoutExtension($job.rel) + ".jpg")
        & curl.exe -sS -L -A $ua --fail --max-time 20 -o $tmp $url | Out-Null
        if ($LASTEXITCODE -ne 0 -or -not (Test-Path $tmp) -or ((Get-Item $tmp).Length -lt 8000)) { continue }
        $src = $tmp
      }
      if (-not (Test-Path $src)) { continue }
      Compose $src $dest $job.title $job.sub
      $got = $true
      $ok++
    } catch { }
  }
  if (-not $got) { Write-Host "MISS $($job.rel)" }
  if (($ok % 25) -eq 0) { Write-Host "wrote $ok" }
}
Write-Host "DONE wrote=$ok / $($jobs.Count)"
