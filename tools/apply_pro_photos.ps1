$ErrorActionPreference = "Stop"
Add-Type -AssemblyName System.Drawing

$srcRoot = "C:\Users\marin\.cursor\projects\c-Users-marin-WALLPEPER\assets"
$outRoot = "c:\Users\marin\WALLPEPER\assets\images\wallpapers"

function Get-Encoder([string]$mime) {
  [System.Drawing.Imaging.ImageCodecInfo]::GetImageEncoders() | Where-Object { $_.MimeType -eq $mime } | Select-Object -First 1
}

function Save-Jpeg($bmp, $path, $quality) {
  $enc = Get-Encoder "image/jpeg"
  $ep = New-Object System.Drawing.Imaging.EncoderParameters 1
  $ep.Param[0] = New-Object System.Drawing.Imaging.EncoderParameter ([System.Drawing.Imaging.Encoder]::Quality, [long]$quality)
  $bmp.Save($path, $enc, $ep)
  $ep.Dispose()
}

function Draw-Cover($g, $img, $w, $h) {
  $scale = [Math]::Max($w / [double]$img.Width, $h / [double]$img.Height)
  $nw = [int]($img.Width * $scale)
  $nh = [int]($img.Height * $scale)
  $x = [int](($w - $nw) / 2)
  $y = [int](($h - $nh) / 2)
  $g.DrawImage($img, $x, $y, $nw, $nh)
}

function Write-Wall {
  param($Source, $Dest, $Title, $Sub, $W = 1080, $H = 1920, $Caption = $true)
  $path = Join-Path $srcRoot $Source
  if (-not (Test-Path $path)) { throw "Missing $path" }
  $img = [System.Drawing.Image]::FromFile($path)
  $bmp = New-Object System.Drawing.Bitmap $W, $H
  $g = [System.Drawing.Graphics]::FromImage($bmp)
  $g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
  $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
  $g.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::AntiAliasGridFit
  Draw-Cover $g $img $W $H
  $img.Dispose()
  if ($Caption) {
    $fadeRect = New-Object System.Drawing.Rectangle 0, ([int]($H * 0.72)), $W, ([int]($H * 0.28))
    $fade = New-Object System.Drawing.Drawing2D.LinearGradientBrush $fadeRect, ([System.Drawing.Color]::FromArgb(0, 0, 0, 0)), ([System.Drawing.Color]::FromArgb(210, 0, 0, 0)), 90.0
    $g.FillRectangle($fade, $fadeRect)
    $fade.Dispose()
    $accent = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(255, 57, 255, 20))
    $g.FillRectangle($accent, 48, [int]($H * 0.78), 54, 5)
    $accent.Dispose()
    $titleFont = New-Object System.Drawing.Font "Segoe UI", 36, ([System.Drawing.FontStyle]::Bold)
    $subFont = New-Object System.Drawing.Font "Segoe UI", 16
    $white = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::White)
    $muted = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(210, 200, 210, 205))
    $g.DrawString($Title.ToUpper(), $titleFont, $white, 48, [int]($H * 0.80))
    $g.DrawString($Sub, $subFont, $muted, 48, [int]($H * 0.88))
    $titleFont.Dispose(); $subFont.Dispose(); $white.Dispose(); $muted.Dispose()
  }
  $g.Dispose()
  $dir = Split-Path $Dest
  if (-not (Test-Path $dir)) { New-Item -ItemType Directory -Force -Path $dir | Out-Null }
  Save-Jpeg $bmp $Dest 86
  $bmp.Dispose()
  Write-Host $Dest
}

$P = Join-Path $outRoot "players"
$C = Join-Path $outRoot "clubs"
$N = Join-Path $outRoot "national_teams"
$L = Join-Path $outRoot "legends"
$S = Join-Path $outRoot "stadiums"
$D = Join-Path $outRoot "3d"

# Players — unique jersey-back photos where we have them
Write-Wall "player_messi_back.png" "$P\player_messi_001.jpg" "Messi" "Argentina  •  Inter Miami" 1440 2560
Write-Wall "player_ronaldo_back.png" "$P\player_ronaldo_001.jpg" "Ronaldo" "Portugal  •  Al Nassr" 1440 2560
Write-Wall "player_salah_back.png" "$P\player_salah_001.jpg" "Salah" "Egypt  •  Liverpool" 1440 2560
Write-Wall "player_mbappe_back.png" "$P\player_mbappe_001.jpg" "Mbappe" "France  •  Real Madrid"
Write-Wall "player_haaland_back.png" "$P\player_haaland_001.jpg" "Haaland" "Norway  •  Man City"
Write-Wall "player_vinicius_back.png" "$P\player_vinicius_001.jpg" "Vinicius" "Brazil  •  Real Madrid"
Write-Wall "player_bellingham_back.png" "$P\player_bellingham_001.jpg" "Bellingham" "England  •  Real Madrid"
Write-Wall "player_yamal_back.png" "$P\player_yamal_001.jpg" "Yamal" "Spain  •  Barcelona"
Write-Wall "player_saka_back.png" "$P\player_saka_001.jpg" "Saka" "England  •  Arsenal"
Write-Wall "player_neymar_back.png" "$P\player_neymar_001.jpg" "Neymar" "Brazil"
Write-Wall "player_haaland_back.png" "$P\player_foden_001.jpg" "Foden" "England  •  Man City"
Write-Wall "player_haaland_back.png" "$P\player_de_bruyne_001.jpg" "De Bruyne" "Belgium  •  Man City"
Write-Wall "player_yamal_back.png" "$P\player_lewandowski_001.jpg" "Lewandowski" "Poland  •  Barcelona"
Write-Wall "player_ronaldo_back.png" "$P\player_kane_001.jpg" "Kane" "England  •  Bayern"
Write-Wall "player_mbappe_back.png" "$P\player_benzema_001.jpg" "Benzema" "France  •  Al Ittihad"
Write-Wall "player_mbappe_back.png" "$P\player_modric_001.jpg" "Modric" "Croatia  •  Real Madrid"
Write-Wall "player_haaland_back.png" "$P\player_rodri_001.jpg" "Rodri" "Spain  •  Man City"
Write-Wall "player_vinicius_back.png" "$P\player_valverde_001.jpg" "Valverde" "Uruguay  •  Real Madrid"
Write-Wall "player_yamal_back.png" "$P\player_pedri_001.jpg" "Pedri" "Spain  •  Barcelona"
Write-Wall "player_yamal_back.png" "$P\player_gavi_001.jpg" "Gavi" "Spain  •  Barcelona"
Write-Wall "player_haaland_back.png" "$P\player_osimhen_001.jpg" "Osimhen" "Nigeria"
Write-Wall "player_mbappe_back.png" "$P\player_courtois_001.jpg" "Courtois" "Belgium  •  Real Madrid"
Write-Wall "player_salah_back.png" "$P\player_van_dijk_001.jpg" "Van Dijk" "Netherlands  •  Liverpool"
Write-Wall "national_france_back.png" "$P\player_hakimi_001.jpg" "Hakimi" "Morocco  •  PSG"
Write-Wall "national_france_back.png" "$P\player_griezmann_001.jpg" "Griezmann" "France  •  Atletico"
Write-Wall "player_mbappe_back.png" "$P\player_son_001.jpg" "Son" "Korea  •  Tottenham"
Write-Wall "player_ronaldo_back.png" "$P\player_musiala_001.jpg" "Musiala" "Germany  •  Bayern"
Write-Wall "player_saka_back.png" "$P\player_rice_001.jpg" "Rice" "England  •  Arsenal"
Write-Wall "player_haaland_back.png" "$P\player_palmer_001.jpg" "Palmer" "England  •  Chelsea"
Write-Wall "player_ronaldo_back.png" "$P\player_isak_001.jpg" "Isak" "Sweden  •  Newcastle"

# Clubs
Write-Wall "club_madrid_stadium.png" "$C\club_real_madrid_001.jpg" "Real Madrid" "Santiago Bernabeu" 1440 2560
Write-Wall "club_madrid_stadium.png" "$C\club_real_madrid_002.jpg" "Madrid Night" "Champions League"
Write-Wall "club_barca_stadium.png" "$C\club_barcelona_001.jpg" "Barcelona" "Spotify Camp Nou"
Write-Wall "club_liverpool_stadium.png" "$C\club_liverpool_001.jpg" "Liverpool" "Anfield"
Write-Wall "club_liverpool_stadium.png" "$C\club_liverpool_002.jpg" "Anfield Roar" "You'll Never Walk Alone"
Write-Wall "club_city_stadium.png" "$C\club_man_city_001.jpg" "Man City" "Etihad Stadium"
Write-Wall "club_liverpool_stadium.png" "$C\club_bayern_001.jpg" "Bayern" "Allianz Arena"
Write-Wall "national_france_back.png" "$C\club_psg_001.jpg" "PSG" "Parc des Princes"
Write-Wall "player_saka_back.png" "$C\club_arsenal_001.jpg" "Arsenal" "Emirates Stadium"
Write-Wall "club_city_stadium.png" "$C\club_chelsea_001.jpg" "Chelsea" "Stamford Bridge"
Write-Wall "club_madrid_stadium.png" "$C\club_juventus_001.jpg" "Juventus" "Allianz Stadium"
Write-Wall "club_city_stadium.png" "$C\club_inter_001.jpg" "Inter" "San Siro"
Write-Wall "club_liverpool_stadium.png" "$C\club_ac_milan_001.jpg" "AC Milan" "San Siro"
Write-Wall "club_barca_stadium.png" "$C\club_dortmund_001.jpg" "Dortmund" "Signal Iduna Park"
Write-Wall "club_city_stadium.png" "$C\club_ajax_001.jpg" "Ajax" "Johan Cruyff Arena"
Write-Wall "club_city_stadium.png" "$C\club_napoli_001.jpg" "Napoli" "Diego Maradona"
Write-Wall "club_liverpool_stadium.png" "$C\club_atletico_001.jpg" "Atletico" "Metropolitano"
Write-Wall "club_madrid_stadium.png" "$C\club_tottenham_001.jpg" "Tottenham" "Tottenham Hotspur Stadium"
Write-Wall "club_madrid_stadium.png" "$C\club_newcastle_001.jpg" "Newcastle" "St James' Park"
Write-Wall "player_ronaldo_back.png" "$C\club_benfica_001.jpg" "Benfica" "Estadio da Luz"
Write-Wall "club_city_stadium.png" "$C\club_porto_001.jpg" "Porto" "Dragao"
Write-Wall "club_city_stadium.png" "$C\club_sporting_001.jpg" "Sporting" "Alvalade"
Write-Wall "player_messi_back.png" "$C\club_river_plate_001.jpg" "River Plate" "El Monumental"
Write-Wall "club_barca_stadium.png" "$C\club_boca_001.jpg" "Boca" "La Bombonera"
Write-Wall "player_neymar_back.png" "$C\club_flamengo_001.jpg" "Flamengo" "Maracana"

# Nationals
Write-Wall "player_messi_back.png" "$N\national_argentina_001.jpg" "Argentina" "La Albiceleste" 1440 2560
Write-Wall "player_ronaldo_back.png" "$N\national_portugal_001.jpg" "Portugal" "Selecao das Quinas"
Write-Wall "player_neymar_back.png" "$N\national_brazil_001.jpg" "Brazil" "Selecao"
Write-Wall "national_france_back.png" "$N\national_france_001.jpg" "France" "Les Bleus"
Write-Wall "player_saka_back.png" "$N\national_england_001.jpg" "England" "Three Lions"
Write-Wall "player_yamal_back.png" "$N\national_spain_001.jpg" "Spain" "La Roja"
Write-Wall "player_ronaldo_back.png" "$N\national_germany_001.jpg" "Germany" "Die Mannschaft"
Write-Wall "club_city_stadium.png" "$N\national_italy_001.jpg" "Italy" "Azzurri"
Write-Wall "player_haaland_back.png" "$N\national_netherlands_001.jpg" "Netherlands" "Oranje"
Write-Wall "player_salah_back.png" "$N\national_egypt_001.jpg" "Egypt" "The Pharaohs"
Write-Wall "player_ronaldo_back.png" "$N\national_morocco_001.jpg" "Morocco" "Atlas Lions"
Write-Wall "club_city_stadium.png" "$N\national_japan_001.jpg" "Japan" "Samurai Blue"
Write-Wall "player_mbappe_back.png" "$N\national_croatia_001.jpg" "Croatia" "Vatreni"
Write-Wall "player_ronaldo_back.png" "$N\national_belgium_001.jpg" "Belgium" "Red Devils"
Write-Wall "club_city_stadium.png" "$N\national_uruguay_001.jpg" "Uruguay" "La Celeste"

# Legends
Write-Wall "player_messi_back.png" "$L\legend_maradona_001.jpg" "Maradona" "El Diego" 1440 2560
Write-Wall "player_neymar_back.png" "$L\legend_pele_001.jpg" "Pele" "O Rei"
Write-Wall "national_france_back.png" "$L\legend_zidane_001.jpg" "Zidane" "Zizou"
Write-Wall "player_neymar_back.png" "$L\legend_ronaldo_nazario_001.jpg" "Ronaldo" "Il Fenomeno"
Write-Wall "player_neymar_back.png" "$L\legend_ronaldinho_001.jpg" "Ronaldinho" "The Smile"
Write-Wall "player_haaland_back.png" "$L\legend_cruyff_001.jpg" "Cruyff" "Total Football"
Write-Wall "player_ronaldo_back.png" "$L\legend_beckenbauer_001.jpg" "Beckenbauer" "Der Kaiser"
Write-Wall "player_salah_back.png" "$L\legend_gerrard_001.jpg" "Gerrard" "Captain Fantastic"
Write-Wall "player_saka_back.png" "$L\legend_henry_001.jpg" "Henry" "Va Va Voom"
Write-Wall "player_yamal_back.png" "$L\legend_iniesta_001.jpg" "Iniesta" "Don Andres"

# Stadiums + iconic football moments
Write-Wall "trophy_ucl.png" "$S\stadium_001.jpg" "Champions Night" "UEFA Champions League" 1440 2560
Write-Wall "club_madrid_stadium.png" "$S\stadium_002.jpg" "Night Glory" "Floodlights"
Write-Wall "club_barca_stadium.png" "$S\stadium_003.jpg" "Sea of Light" "Matchday Crowd"
Write-Wall "club_liverpool_stadium.png" "$S\stadium_004.jpg" "Thunder Crowd" "Anfield Night"
Write-Wall "club_city_stadium.png" "$S\stadium_005.jpg" "Full House" "Sold Out"
Write-Wall "moment_penalty.png" "$S\stadium_006.jpg" "Green Cathedral" "The Pitch"
Write-Wall "club_madrid_stadium.png" "$S\stadium_007.jpg" "Twilight Bowl" "Kickoff"
Write-Wall "moment_penalty.png" "$S\stadium_008.jpg" "Corner Lights" "Set Piece"
Write-Wall "club_liverpool_stadium.png" "$S\stadium_009.jpg" "Tunnel Walk" "Players Entrance"
Write-Wall "moment_penalty.png" "$S\stadium_010.jpg" "Midnight Match" "Champions League Night"

# Important football moments / trophies in 3D folder (keep filenames, upgrade content)
Write-Wall "trophy_ucl.png" "$D\football_3d_001.jpg" "UCL Trophy" "Champions League" 1440 2560
Write-Wall "trophy_worldcup.png" "$D\football_3d_002.jpg" "World Cup" "The Greatest Prize"
Write-Wall "trophy_euros.png" "$D\football_3d_003.jpg" "EURO Trophy" "Nations of Europe"
Write-Wall "moment_goal_net.png" "$D\football_3d_004.jpg" "Goal" "Ball in the Net"
Write-Wall "moment_penalty.png" "$D\football_3d_005.jpg" "Penalty" "The Spot"
Write-Wall "moment_captain.png" "$D\football_3d_006.jpg" "Captain" "The Armband"
Write-Wall "trophy_ucl.png" "$D\football_3d_007.jpg" "Final Night" "European Glory"
Write-Wall "trophy_worldcup.png" "$D\football_3d_008.jpg" "Final Whistle" "World Champions"
Write-Wall "moment_goal_net.png" "$D\football_3d_009.jpg" "Top Corner" "Unstoppable"
Write-Wall "moment_penalty.png" "$D\football_3d_010.jpg" "Last Kick" "Sudden Death"

Write-Host "PRO ASSETS DONE"
