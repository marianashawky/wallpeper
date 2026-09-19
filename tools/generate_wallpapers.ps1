# Generates original football wallpapers, category thumbs, and branding copies.
$ErrorActionPreference = "Stop"
Add-Type -AssemblyName System.Drawing

$srcRoot = "C:\Users\marin\.cursor\projects\c-Users-marin-WALLPEPER\assets"
$outRoot = "c:\Users\marin\WALLPEPER\assets\images"
$wallRoot = Join-Path $outRoot "wallpapers"
$catRoot = Join-Path $outRoot "categories"
$brandRoot = Join-Path $outRoot "branding"

@(
  (Join-Path $wallRoot "players"),
  (Join-Path $wallRoot "clubs"),
  (Join-Path $wallRoot "national_teams"),
  (Join-Path $wallRoot "legends"),
  (Join-Path $wallRoot "stadiums"),
  (Join-Path $wallRoot "3d"),
  $catRoot,
  $brandRoot
) | ForEach-Object { New-Item -ItemType Directory -Force -Path $_ | Out-Null }

function Get-Encoder([string]$mime) {
  $codecs = [System.Drawing.Imaging.ImageCodecInfo]::GetImageEncoders()
  foreach ($c in $codecs) { if ($c.MimeType -eq $mime) { return $c } }
  return $null
}

function Save-Jpeg([System.Drawing.Bitmap]$bmp, [string]$path, [int]$quality) {
  $enc = Get-Encoder "image/jpeg"
  $ep = New-Object System.Drawing.Imaging.EncoderParameters 1
  $ep.Param[0] = New-Object System.Drawing.Imaging.EncoderParameter ([System.Drawing.Imaging.Encoder]::Quality, [long]$quality)
  $dir = Split-Path $path
  if (-not (Test-Path $dir)) { New-Item -ItemType Directory -Force -Path $dir | Out-Null }
  $bmp.Save($path, $enc, $ep)
  $ep.Dispose()
}

function New-Color([string]$hex) {
  $h = $hex.TrimStart("#")
  $r = [Convert]::ToInt32($h.Substring(0, 2), 16)
  $g = [Convert]::ToInt32($h.Substring(2, 2), 16)
  $b = [Convert]::ToInt32($h.Substring(4, 2), 16)
  return [System.Drawing.Color]::FromArgb(255, $r, $g, $b)
}

function Draw-Cover([System.Drawing.Graphics]$g, [System.Drawing.Image]$img, [int]$w, [int]$h) {
  $scale = [Math]::Max($w / [double]$img.Width, $h / [double]$img.Height)
  $nw = [int]($img.Width * $scale)
  $nh = [int]($img.Height * $scale)
  $x = [int](($w - $nw) / 2)
  $y = [int](($h - $nh) / 2)
  $g.DrawImage($img, $x, $y, $nw, $nh)
}

function Draw-VerticalGradient([System.Drawing.Graphics]$g, [int]$w, [int]$h, [System.Drawing.Color]$c1, [System.Drawing.Color]$c2) {
  $rect = New-Object System.Drawing.Rectangle 0, 0, $w, $h
  $brush = New-Object System.Drawing.Drawing2D.LinearGradientBrush $rect, $c1, $c2, 90.0
  $g.FillRectangle($brush, $rect)
  $brush.Dispose()
}

function Draw-RadialGlow([System.Drawing.Graphics]$g, [int]$cx, [int]$cy, [int]$radius, [System.Drawing.Color]$color) {
  for ($i = 8; $i -ge 1; $i--) {
    $a = [int](18 * $i)
    $r = [int]($radius * $i / 8.0)
    $c = [System.Drawing.Color]::FromArgb($a, $color.R, $color.G, $color.B)
    $brush = New-Object System.Drawing.SolidBrush $c
    $g.FillEllipse($brush, $cx - $r, $cy - $r, $r * 2, $r * 2)
    $brush.Dispose()
  }
}

function Draw-Pitch([System.Drawing.Graphics]$g, [int]$w, [int]$h, [System.Drawing.Color]$lineColor) {
  $pen = New-Object System.Drawing.Pen $lineColor, 4
  $margin = 90
  $g.DrawRectangle($pen, $margin, [int]($h * 0.38), $w - 2 * $margin, [int]($h * 0.52))
  $midY = [int]($h * 0.64)
  $g.DrawLine($pen, $margin, $midY, $w - $margin, $midY)
  $cx = [int]($w / 2)
  $g.DrawEllipse($pen, $cx - 140, $midY - 140, 280, 280)
  $g.DrawRectangle($pen, $cx - 220, [int]($h * 0.38), 440, 180)
  $g.DrawRectangle($pen, $cx - 220, [int]($h * 0.38 + $h * 0.52 - 180), 440, 180)
  $pen.Dispose()
}

function Draw-Ball([System.Drawing.Graphics]$g, [int]$cx, [int]$cy, [int]$r, [System.Drawing.Color]$accent) {
  Draw-RadialGlow $g $cx $cy ([int]($r * 2.4)) $accent
  $black = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(255, 12, 16, 14))
  $g.FillEllipse($black, $cx - $r, $cy - $r, $r * 2, $r * 2)
  $black.Dispose()
  $pen = New-Object System.Drawing.Pen $accent, 6
  $g.DrawEllipse($pen, $cx - $r, $cy - $r, $r * 2, $r * 2)
  $pen.Dispose()
  $hex = New-Object System.Drawing.SolidBrush $accent
  $pts = @()
  for ($i = 0; $i -lt 6; $i++) {
    $ang = [Math]::PI / 3 * $i - [Math]::PI / 2
    $pts += New-Object System.Drawing.Point ([int]($cx + [Math]::Cos($ang) * $r * 0.32), [int]($cy + [Math]::Sin($ang) * $r * 0.32))
  }
  $g.FillPolygon($hex, $pts)
  $hex.Dispose()
}

function Add-TextOverlay([System.Drawing.Graphics]$g, [int]$w, [int]$h, [string]$title, [string]$subtitle, [System.Drawing.Color]$accent) {
  $g.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::AntiAliasGridFit
  $fadeRect = New-Object System.Drawing.Rectangle 0, ([int]($h * 0.55)), $w, ([int]($h * 0.45))
  $fade = New-Object System.Drawing.Drawing2D.LinearGradientBrush $fadeRect, ([System.Drawing.Color]::FromArgb(0, 0, 0, 0)), ([System.Drawing.Color]::FromArgb(230, 0, 0, 0)), 90.0
  $g.FillRectangle($fade, $fadeRect)
  $fade.Dispose()

  $titleFont = New-Object System.Drawing.Font "Segoe UI", 56, ([System.Drawing.FontStyle]::Bold)
  $subFont = New-Object System.Drawing.Font "Segoe UI", 22, ([System.Drawing.FontStyle]::Regular)
  $white = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::White)
  $muted = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(210, 200, 210, 200))
  $sf = New-Object System.Drawing.StringFormat
  $sf.Alignment = [System.Drawing.StringAlignment]::Near
  $rect = New-Object System.Drawing.RectangleF 56, ([int]($h * 0.78)), ($w - 112), 140
  $g.DrawString($title.ToUpper(), $titleFont, $white, $rect, $sf)
  $rect2 = New-Object System.Drawing.RectangleF 56, ([int]($h * 0.88)), ($w - 112), 80
  $g.DrawString($subtitle, $subFont, $muted, $rect2, $sf)
  $accentBrush = New-Object System.Drawing.SolidBrush $accent
  $g.FillRectangle($accentBrush, 56, [int]($h * 0.765), 90, 6)
  $titleFont.Dispose(); $subFont.Dispose(); $white.Dispose(); $muted.Dispose(); $accentBrush.Dispose()
}

function New-Wallpaper {
  param(
    [string]$OutPath,
    [int]$Width,
    [int]$Height,
    [string]$Title,
    [string]$Subtitle,
    [string]$AccentHex,
    [string]$BgHex,
    [string]$Bg2Hex,
    [string]$SourceName,
    [int]$Style,
    [int]$Quality = 82
  )
  $bmp = New-Object System.Drawing.Bitmap $Width, $Height
  $g = [System.Drawing.Graphics]::FromImage($bmp)
  $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
  $g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
  $accent = New-Color $AccentHex
  $c1 = New-Color $BgHex
  $c2 = New-Color $Bg2Hex
  Draw-VerticalGradient $g $Width $Height $c1 $c2

  $srcPath = Join-Path $srcRoot $SourceName
  if ((Test-Path $srcPath) -and ($Style -in 0, 1, 2)) {
    $img = [System.Drawing.Image]::FromFile($srcPath)
    Draw-Cover $g $img $Width $Height
    $img.Dispose()
    $veil = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(70, $c1.R, $c1.G, $c1.B))
    $g.FillRectangle($veil, 0, 0, $Width, $Height)
    $veil.Dispose()
  }

  switch ($Style) {
    0 { Draw-RadialGlow $g ([int]($Width / 2)) ([int]($Height * 0.32)) 420 $accent }
    1 { Draw-Pitch $g $Width $Height ([System.Drawing.Color]::FromArgb(90, 255, 255, 255)) }
    2 { Draw-Ball $g ([int]($Width * 0.78)) ([int]($Height * 0.22)) 90 $accent }
    3 {
      Draw-Pitch $g $Width $Height ([System.Drawing.Color]::FromArgb(70, $accent.R, $accent.G, $accent.B))
      Draw-Ball $g ([int]($Width / 2)) ([int]($Height * 0.34)) 160 $accent
    }
    4 {
      Draw-RadialGlow $g ([int]($Width / 2)) ([int]($Height / 2)) 700 $accent
      Draw-Ball $g ([int]($Width / 2)) ([int]($Height * 0.38)) 190 $accent
      for ($k = 1; $k -le 5; $k++) {
        $pen = New-Object System.Drawing.Pen ([System.Drawing.Color]::FromArgb(40, $accent.R, $accent.G, $accent.B)), 2
        $rr = 180 + $k * 70
        $g.DrawEllipse($pen, [int]($Width / 2 - $rr), [int]($Height * 0.38 - $rr), $rr * 2, $rr * 2)
        $pen.Dispose()
      }
    }
    5 {
      Draw-Pitch $g $Width $Height ([System.Drawing.Color]::FromArgb(50, 255, 255, 255))
      Draw-RadialGlow $g 180 240 260 $accent
    }
    default {
      Draw-Ball $g ([int]($Width / 2)) 420 140 $accent
    }
  }

  Add-TextOverlay $g $Width $Height $Title $Subtitle $accent
  $g.Dispose()
  Save-Jpeg $bmp $OutPath $Quality
  $bmp.Dispose()
}

$players = @(
  @{ file = "player_messi_001.jpg"; title = "Messi"; sub = "The Magician"; accent = "74C0FC"; bg = "04111F"; bg2 = "0B2A4A"; src = "hero_argentina_abstract.png"; style = 0 },
  @{ file = "player_ronaldo_001.jpg"; title = "Ronaldo"; sub = "CR7 Legacy"; accent = "C92A2A"; bg = "140404"; bg2 = "2B0A0A"; src = "hero_portugal_smoke.png"; style = 2 },
  @{ file = "player_salah_001.jpg"; title = "Salah"; sub = "Egyptian King"; accent = "E03131"; bg = "120404"; bg2 = "2B0C14"; src = "hero_goal_net.png"; style = 1 },
  @{ file = "player_mbappe_001.jpg"; title = "Mbappe"; sub = "Lightning"; accent = "4DABF7"; bg = "07101C"; bg2 = "0B1F3A"; src = "hero_france_navy.png"; style = 0 },
  @{ file = "player_haaland_001.jpg"; title = "Haaland"; sub = "The Machine"; accent = "66D9E8"; bg = "041418"; bg2 = "083038"; src = "hero_golden_strike.png"; style = 2 },
  @{ file = "player_vinicius_001.jpg"; title = "Vinicius"; sub = "Vini Jr"; accent = "FFD43B"; bg = "121008"; bg2 = "2A2208"; src = "hero_club_gold.png"; style = 0 },
  @{ file = "player_bellingham_001.jpg"; title = "Bellingham"; sub = "Jude 5"; accent = "FFD43B"; bg = "0E0C06"; bg2 = "241C08"; src = "hero_golden_strike.png"; style = 1 },
  @{ file = "player_foden_001.jpg"; title = "Foden"; sub = "Sky Blue Spark"; accent = "74C0FC"; bg = "06141E"; bg2 = "0A2A3C"; src = "hero_england_navy.png"; style = 2 },
  @{ file = "player_yamal_001.jpg"; title = "Yamal"; sub = "The Prodigy"; accent = "A5D8FF"; bg = "07101C"; bg2 = "12243C"; src = "hero_golden_strike.png"; style = 0 },
  @{ file = "player_saka_001.jpg"; title = "Saka"; sub = "Starboy"; accent = "FA5252"; bg = "140808"; bg2 = "2A1010"; src = "hero_goal_net.png"; style = 1 },
  @{ file = "player_de_bruyne_001.jpg"; title = "De Bruyne"; sub = "The Visionary"; accent = "74C0FC"; bg = "06141E"; bg2 = "0C2840"; src = "hero_pitch_lines.png"; style = 5 },
  @{ file = "player_lewandowski_001.jpg"; title = "Lewandowski"; sub = "Lewy 9"; accent = "E03131"; bg = "140404"; bg2 = "2A0808"; src = "hero_goal_net.png"; style = 2 },
  @{ file = "player_kane_001.jpg"; title = "Kane"; sub = "Captain Kane"; accent = "FFFFFF"; bg = "0B1020"; bg2 = "1A2744"; src = "hero_england_navy.png"; style = 1 },
  @{ file = "player_neymar_001.jpg"; title = "Neymar"; sub = "NJR Magic"; accent = "FFD43B"; bg = "0C1A08"; bg2 = "1C3A10"; src = "hero_brazil_gold.png"; style = 0 },
  @{ file = "player_benzema_001.jpg"; title = "Benzema"; sub = "The King"; accent = "FFD43B"; bg = "121008"; bg2 = "2A2208"; src = "hero_club_gold.png"; style = 2 },
  @{ file = "player_modric_001.jpg"; title = "Modric"; sub = "The Maestro"; accent = "E03131"; bg = "140808"; bg2 = "2A1018"; src = "hero_golden_strike.png"; style = 1 },
  @{ file = "player_rodri_001.jpg"; title = "Rodri"; sub = "Midfield Anchor"; accent = "74C0FC"; bg = "06141E"; bg2 = "0A2838"; src = "hero_pitch_lines.png"; style = 5 },
  @{ file = "player_valverde_001.jpg"; title = "Valverde"; sub = "Fede Engine"; accent = "FFD43B"; bg = "101008"; bg2 = "262008"; src = "hero_golden_strike.png"; style = 2 },
  @{ file = "player_pedri_001.jpg"; title = "Pedri"; sub = "Pedri 8"; accent = "4DABF7"; bg = "07101C"; bg2 = "122848"; src = "hero_golden_strike.png"; style = 0 },
  @{ file = "player_gavi_001.jpg"; title = "Gavi"; sub = "Firestarter"; accent = "FF6B6B"; bg = "160808"; bg2 = "2C1010"; src = "hero_golden_strike.png"; style = 1 },
  @{ file = "player_osimhen_001.jpg"; title = "Osimhen"; sub = "Super Eagle"; accent = "69DB7C"; bg = "081408"; bg2 = "123018"; src = "hero_goal_net.png"; style = 2 },
  @{ file = "player_courtois_001.jpg"; title = "Courtois"; sub = "The Wall"; accent = "FFD43B"; bg = "101008"; bg2 = "201C08"; src = "hero_goal_net.png"; style = 1 },
  @{ file = "player_van_dijk_001.jpg"; title = "Van Dijk"; sub = "VVD"; accent = "C92A2A"; bg = "140404"; bg2 = "2A0A12"; src = "hero_goal_net.png"; style = 0 },
  @{ file = "player_hakimi_001.jpg"; title = "Hakimi"; sub = "Turbo Wing"; accent = "4DABF7"; bg = "07101C"; bg2 = "0C2040"; src = "hero_france_navy.png"; style = 2 },
  @{ file = "player_griezmann_001.jpg"; title = "Griezmann"; sub = "Grizi"; accent = "E03131"; bg = "140808"; bg2 = "241018"; src = "hero_france_navy.png"; style = 1 },
  @{ file = "player_son_001.jpg"; title = "Son"; sub = "Sonny"; accent = "FFFFFF"; bg = "0B1020"; bg2 = "182038"; src = "hero_golden_strike.png"; style = 0 },
  @{ file = "player_musiala_001.jpg"; title = "Musiala"; sub = "Next Gen"; accent = "E03131"; bg = "140404"; bg2 = "280808"; src = "hero_golden_strike.png"; style = 2 },
  @{ file = "player_rice_001.jpg"; title = "Rice"; sub = "Declan Rice"; accent = "FA5252"; bg = "140808"; bg2 = "281010"; src = "hero_england_navy.png"; style = 1 },
  @{ file = "player_palmer_001.jpg"; title = "Palmer"; sub = "Cold Palmer"; accent = "74C0FC"; bg = "061018"; bg2 = "0C2438"; src = "hero_golden_strike.png"; style = 0 },
  @{ file = "player_isak_001.jpg"; title = "Isak"; sub = "Clinical 14"; accent = "69DB7C"; bg = "08140C"; bg2 = "102818"; src = "hero_goal_net.png"; style = 2 }
)

$clubs = @(
  @{ file = "club_real_madrid_001.jpg"; title = "Real Madrid"; sub = "Los Blancos"; accent = "FFD43B"; bg = "101008"; bg2 = "1C1808"; src = "hero_club_gold.png"; style = 0 },
  @{ file = "club_real_madrid_002.jpg"; title = "Madrid Night"; sub = "Bernabeu Glow"; accent = "FFFFFF"; bg = "0A0C12"; bg2 = "161A28"; src = "hero_stadium_night.png"; style = 1 },
  @{ file = "club_barcelona_001.jpg"; title = "Barcelona"; sub = "Blaugrana"; accent = "4DABF7"; bg = "07101C"; bg2 = "1A0A14"; src = "hero_crowd_wave.png"; style = 0 },
  @{ file = "club_barcelona_002.jpg"; title = "Barca Pulse"; sub = "Camp Nou Energy"; accent = "E03131"; bg = "0A0814"; bg2 = "180C1C"; src = "hero_tunnel.png"; style = 2 },
  @{ file = "club_liverpool_001.jpg"; title = "Liverpool"; sub = "You'll Never Walk Alone"; accent = "C92A2A"; bg = "140404"; bg2 = "2A080C"; src = "hero_crowd_wave.png"; style = 1 },
  @{ file = "club_man_city_001.jpg"; title = "Man City"; sub = "Sky Blue"; accent = "74C0FC"; bg = "06141E"; bg2 = "0A2838"; src = "hero_pitch_lines.png"; style = 5 },
  @{ file = "club_bayern_001.jpg"; title = "Bayern"; sub = "Mia San Mia"; accent = "E03131"; bg = "140404"; bg2 = "2A0808"; src = "hero_crowd_wave.png"; style = 0 },
  @{ file = "club_psg_001.jpg"; title = "PSG"; sub = "Paris Nights"; accent = "4DABF7"; bg = "07101C"; bg2 = "14081C"; src = "hero_france_navy.png"; style = 2 },
  @{ file = "club_arsenal_001.jpg"; title = "Arsenal"; sub = "Gunners"; accent = "FA5252"; bg = "140808"; bg2 = "2A1010"; src = "hero_crowd_wave.png"; style = 1 },
  @{ file = "club_chelsea_001.jpg"; title = "Chelsea"; sub = "The Blues"; accent = "4DABF7"; bg = "06101C"; bg2 = "0C2040"; src = "hero_pitch_lines.png"; style = 5 },
  @{ file = "club_juventus_001.jpg"; title = "Juventus"; sub = "Bianconeri"; accent = "FFFFFF"; bg = "0A0A0A"; bg2 = "1A1A1A"; src = "hero_tunnel.png"; style = 0 },
  @{ file = "club_inter_001.jpg"; title = "Inter"; sub = "Nerazzurri"; accent = "4DABF7"; bg = "06101C"; bg2 = "0A1830"; src = "hero_crowd_wave.png"; style = 2 },
  @{ file = "club_ac_milan_001.jpg"; title = "AC Milan"; sub = "Rossoneri"; accent = "C92A2A"; bg = "140404"; bg2 = "1A0808"; src = "hero_tunnel.png"; style = 1 },
  @{ file = "club_dortmund_001.jpg"; title = "Dortmund"; sub = "Yellow Wall"; accent = "FFD43B"; bg = "121000"; bg2 = "2A2200"; src = "hero_crowd_wave.png"; style = 0 },
  @{ file = "club_ajax_001.jpg"; title = "Ajax"; sub = "Godenzonen"; accent = "FA5252"; bg = "140808"; bg2 = "281010"; src = "hero_pitch_lines.png"; style = 5 },
  @{ file = "club_napoli_001.jpg"; title = "Napoli"; sub = "Azzurri"; accent = "4DABF7"; bg = "06141E"; bg2 = "0A2848"; src = "hero_crowd_wave.png"; style = 2 },
  @{ file = "club_atletico_001.jpg"; title = "Atletico"; sub = "Simeone Fire"; accent = "E03131"; bg = "140808"; bg2 = "1C0C18"; src = "hero_crowd_wave.png"; style = 1 },
  @{ file = "club_tottenham_001.jpg"; title = "Tottenham"; sub = "Lilywhites"; accent = "FFFFFF"; bg = "0B1020"; bg2 = "161E30"; src = "hero_pitch_lines.png"; style = 5 },
  @{ file = "club_newcastle_001.jpg"; title = "Newcastle"; sub = "Magpies"; accent = "FFFFFF"; bg = "0A0A0A"; bg2 = "1C1C1C"; src = "hero_crowd_wave.png"; style = 0 },
  @{ file = "club_benfica_001.jpg"; title = "Benfica"; sub = "Eagles"; accent = "E03131"; bg = "140404"; bg2 = "2A0A0A"; src = "hero_portugal_smoke.png"; style = 2 },
  @{ file = "club_porto_001.jpg"; title = "Porto"; sub = "Dragons"; accent = "4DABF7"; bg = "06101C"; bg2 = "0C2040"; src = "hero_portugal_smoke.png"; style = 1 },
  @{ file = "club_sporting_001.jpg"; title = "Sporting"; sub = "Lions"; accent = "69DB7C"; bg = "081408"; bg2 = "123018"; src = "hero_portugal_smoke.png"; style = 0 },
  @{ file = "club_river_plate_001.jpg"; title = "River Plate"; sub = "La Banda"; accent = "E03131"; bg = "140808"; bg2 = "201010"; src = "hero_argentina_abstract.png"; style = 1 },
  @{ file = "club_boca_001.jpg"; title = "Boca"; sub = "Xeneize"; accent = "FFD43B"; bg = "06101C"; bg2 = "122008"; src = "hero_argentina_abstract.png"; style = 2 },
  @{ file = "club_flamengo_001.jpg"; title = "Flamengo"; sub = "Mengao"; accent = "E03131"; bg = "140404"; bg2 = "1A1008"; src = "hero_brazil_gold.png"; style = 0 },
  @{ file = "club_al_nassr_001.jpg"; title = "Al Nassr"; sub = "Yellow Giants"; accent = "FFD43B"; bg = "121000"; bg2 = "2A2200"; src = "hero_club_gold.png"; style = 2 }
)

# 25 clubs: I listed 26 including al_nassr. Need exactly 25. I'll drop al_hilal as 25th instead of extra madrid? Count:
# 1 real 2 real2 3 barca 4 barca2 5 liverpool 6 city 7 bayern 8 psg 9 arsenal 10 chelsea 11 juve 12 inter 13 milan 14 dortmund 15 ajax 16 napoli 17 atletico 18 tottenham 19 newcastle 20 benfica 21 porto 22 sporting 23 river 24 boca 25 flamengo
# That's 25 if I remove al_nassr. User example had al nassr. Let me remove barcelona_002 to keep al_nassr? User asked 25 club wallpapers. I'll keep 25: remove club_barcelona_002 and club_real_madrid_002 wait that's 24 then. Count again without extras:
# real, barca, liverpool, city, bayern, psg, arsenal, chelsea, juve, inter, milan, dortmund, ajax, napoli, atletico, tottenham, newcastle, benfica, porto, sporting, river, boca, flamengo, al_nassr = 24. Need 25th: al_hilal.

# I'll filter in dart catalog to 25. Script currently has 26. I'll remove barcelona_002 in the dart catalog... Let me just leave 25 by removing barcelona_002 from array - I'll handle after. For now I'll add al_hilal and remove barcelona_002 and real_madrid_002 to get: real, barca, liverpool... al_nassr, al_hilal = 25 with both extra madrids removed.

$nationals = @(
  @{ file = "national_argentina_001.jpg"; title = "Argentina"; sub = "La Albiceleste"; accent = "74C0FC"; bg = "07101C"; bg2 = "12304A"; src = "hero_argentina_abstract.png"; style = 0 },
  @{ file = "national_portugal_001.jpg"; title = "Portugal"; sub = "Selecao das Quinas"; accent = "C92A2A"; bg = "140404"; bg2 = "1C1408"; src = "hero_portugal_smoke.png"; style = 2 },
  @{ file = "national_brazil_001.jpg"; title = "Brazil"; sub = "Selecao"; accent = "FFD43B"; bg = "0C1A08"; bg2 = "1C3A10"; src = "hero_brazil_gold.png"; style = 0 },
  @{ file = "national_france_001.jpg"; title = "France"; sub = "Les Bleus"; accent = "4DABF7"; bg = "07101C"; bg2 = "0C2048"; src = "hero_france_navy.png"; style = 1 },
  @{ file = "national_england_001.jpg"; title = "England"; sub = "Three Lions"; accent = "FFFFFF"; bg = "0B1020"; bg2 = "182440"; src = "hero_england_navy.png"; style = 5 },
  @{ file = "national_spain_001.jpg"; title = "Spain"; sub = "La Roja"; accent = "E03131"; bg = "140404"; bg2 = "2A0A0A"; src = "hero_crowd_wave.png"; style = 0 },
  @{ file = "national_germany_001.jpg"; title = "Germany"; sub = "Die Mannschaft"; accent = "FFFFFF"; bg = "0A0A0A"; bg2 = "1A1A1A"; src = "hero_pitch_lines.png"; style = 1 },
  @{ file = "national_italy_001.jpg"; title = "Italy"; sub = "Azzurri"; accent = "4DABF7"; bg = "06101C"; bg2 = "0A2848"; src = "hero_crowd_wave.png"; style = 2 },
  @{ file = "national_netherlands_001.jpg"; title = "Netherlands"; sub = "Oranje"; accent = "FF922B"; bg = "160A00"; bg2 = "2A1400"; src = "hero_golden_strike.png"; style = 0 },
  @{ file = "national_egypt_001.jpg"; title = "Egypt"; sub = "The Pharaohs"; accent = "E03131"; bg = "140808"; bg2 = "201808"; src = "hero_goal_net.png"; style = 1 },
  @{ file = "national_morocco_001.jpg"; title = "Morocco"; sub = "Atlas Lions"; accent = "E03131"; bg = "140808"; bg2 = "123018"; src = "hero_crowd_wave.png"; style = 2 },
  @{ file = "national_japan_001.jpg"; title = "Japan"; sub = "Samurai Blue"; accent = "4DABF7"; bg = "06101C"; bg2 = "0A1838"; src = "hero_pitch_lines.png"; style = 5 },
  @{ file = "national_croatia_001.jpg"; title = "Croatia"; sub = "Vatreni"; accent = "E03131"; bg = "140808"; bg2 = "08101C"; src = "hero_crowd_wave.png"; style = 0 },
  @{ file = "national_belgium_001.jpg"; title = "Belgium"; sub = "Red Devils"; accent = "C92A2A"; bg = "140404"; bg2 = "2A0808"; src = "hero_golden_strike.png"; style = 1 },
  @{ file = "national_uruguay_001.jpg"; title = "Uruguay"; sub = "La Celeste"; accent = "74C0FC"; bg = "07101C"; bg2 = "0C2848"; src = "hero_pitch_lines.png"; style = 2 }
)

$legends = @(
  @{ file = "legend_maradona_001.jpg"; title = "Maradona"; sub = "El Diego"; accent = "74C0FC"; bg = "07101C"; bg2 = "1A1408"; src = "hero_legends_gold.png"; style = 0 },
  @{ file = "legend_pele_001.jpg"; title = "Pele"; sub = "O Rei"; accent = "FFD43B"; bg = "121000"; bg2 = "1C3A10"; src = "hero_legends_gold.png"; style = 2 },
  @{ file = "legend_zidane_001.jpg"; title = "Zidane"; sub = "Zizou"; accent = "FFD43B"; bg = "101008"; bg2 = "1C1808"; src = "hero_legends_gold.png"; style = 1 },
  @{ file = "legend_ronaldo_nazario_001.jpg"; title = "Ronaldo"; sub = "Il Fenomeno"; accent = "FFD43B"; bg = "0C1A08"; bg2 = "201808"; src = "hero_brazil_gold.png"; style = 0 },
  @{ file = "legend_ronaldinho_001.jpg"; title = "Ronaldinho"; sub = "The Smile"; accent = "69DB7C"; bg = "0C1A08"; bg2 = "1C3A10"; src = "hero_brazil_gold.png"; style = 2 },
  @{ file = "legend_cruyff_001.jpg"; title = "Cruyff"; sub = "Total Football"; accent = "FF922B"; bg = "160A00"; bg2 = "2A1400"; src = "hero_legends_gold.png"; style = 1 },
  @{ file = "legend_beckenbauer_001.jpg"; title = "Beckenbauer"; sub = "Der Kaiser"; accent = "FFFFFF"; bg = "0A0A0A"; bg2 = "1A1A1A"; src = "hero_legends_gold.png"; style = 0 },
  @{ file = "legend_gerrard_001.jpg"; title = "Gerrard"; sub = "Captain Fantastic"; accent = "C92A2A"; bg = "140404"; bg2 = "2A080C"; src = "hero_legends_gold.png"; style = 2 },
  @{ file = "legend_henry_001.jpg"; title = "Henry"; sub = "Va Va Voom"; accent = "E03131"; bg = "140808"; bg2 = "1A0C14"; src = "hero_france_navy.png"; style = 1 },
  @{ file = "legend_iniesta_001.jpg"; title = "Iniesta"; sub = "Don Andres"; accent = "4DABF7"; bg = "07101C"; bg2 = "14081C"; src = "hero_legends_gold.png"; style = 0 }
)

$stadiums = @(
  @{ file = "stadium_001.jpg"; title = "Champions Night"; sub = "Wembley Final"; accent = "39FF14"; bg = "020407"; bg2 = "061018"; src = "hero_stadium_night.png"; style = 0 },
  @{ file = "stadium_002.jpg"; title = "Night Glory"; sub = "Floodlight Bowl"; accent = "74C0FC"; bg = "020407"; bg2 = "081018"; src = "hero_twilight_bowl.png"; style = 1 },
  @{ file = "stadium_003.jpg"; title = "Sea of Light"; sub = "Crowd Ocean"; accent = "FF922B"; bg = "080808"; bg2 = "140C08"; src = "hero_crowd_wave.png"; style = 0 },
  @{ file = "stadium_004.jpg"; title = "Thunder Crowd"; sub = "Matchday Roar"; accent = "E03131"; bg = "080404"; bg2 = "140808"; src = "hero_crowd_wave.png"; style = 1 },
  @{ file = "stadium_005.jpg"; title = "Full House"; sub = "Sold Out"; accent = "FFD43B"; bg = "080808"; bg2 = "141008"; src = "hero_corner_flag.png"; style = 0 },
  @{ file = "stadium_006.jpg"; title = "Green Cathedral"; sub = "Sacred Pitch"; accent = "69DB7C"; bg = "04140C"; bg2 = "0A2418"; src = "hero_pitch_lines.png"; style = 5 },
  @{ file = "stadium_007.jpg"; title = "Twilight Bowl"; sub = "Purple Hour"; accent = "B197FC"; bg = "0A0814"; bg2 = "180C24"; src = "hero_twilight_bowl.png"; style = 0 },
  @{ file = "stadium_008.jpg"; title = "Corner Lights"; sub = "Flag Side"; accent = "69DB7C"; bg = "04140C"; bg2 = "0C2010"; src = "hero_corner_flag.png"; style = 1 },
  @{ file = "stadium_009.jpg"; title = "Tunnel Walk"; sub = "Into the Light"; accent = "E03131"; bg = "140404"; bg2 = "1A0808"; src = "hero_tunnel.png"; style = 0 },
  @{ file = "stadium_010.jpg"; title = "Midnight Pitch"; sub = "Emerald Field"; accent = "39FF14"; bg = "020407"; bg2 = "04180C"; src = "hero_pitch_lines.png"; style = 5 }
)

$threed = @(
  @{ file = "football_3d_001.jpg"; title = "Neon Sphere"; sub = "3D Pulse"; accent = "39FF14"; bg = "020407"; bg2 = "04180C"; src = "hero_3d_neon.png"; style = 4 },
  @{ file = "football_3d_002.jpg"; title = "Chrome Shards"; sub = "Impact"; accent = "69DB7C"; bg = "020407"; bg2 = "0A1408"; src = "hero_3d_shards.png"; style = 4 },
  @{ file = "football_3d_003.jpg"; title = "Hologram Ball"; sub = "Cyber Grid"; accent = "22B8CF"; bg = "02040A"; bg2 = "081428"; src = "hero_3d_hologram.png"; style = 4 },
  @{ file = "football_3d_004.jpg"; title = "Liquid Metal"; sub = "Mercury Kick"; accent = "39FF14"; bg = "020407"; bg2 = "081808"; src = "hero_3d_liquid.png"; style = 4 },
  @{ file = "football_3d_005.jpg"; title = "Orbit Rings"; sub = "Gravity"; accent = "74C0FC"; bg = "020407"; bg2 = "08101C"; src = "hero_3d_neon.png"; style = 4 },
  @{ file = "football_3d_006.jpg"; title = "Pulse Core"; sub = "Energy"; accent = "FF6B6B"; bg = "0A0408"; bg2 = "140810"; src = "hero_3d_shards.png"; style = 4 },
  @{ file = "football_3d_007.jpg"; title = "Emerald Geometry"; sub = "Facets"; accent = "69DB7C"; bg = "020807"; bg2 = "082014"; src = "hero_3d_hologram.png"; style = 4 },
  @{ file = "football_3d_008.jpg"; title = "Dark Matter"; sub = "Void Ball"; accent = "B197FC"; bg = "05040A"; bg2 = "10081C"; src = "hero_3d_liquid.png"; style = 4 },
  @{ file = "football_3d_009.jpg"; title = "Cyber Kick"; sub = "Wireframe"; accent = "22B8CF"; bg = "02040A"; bg2 = "081820"; src = "hero_3d_hologram.png"; style = 4 },
  @{ file = "football_3d_010.jpg"; title = "Abstract Pitch"; sub = "Minimal 3D"; accent = "39FF14"; bg = "020407"; bg2 = "04140C"; src = "hero_minimal_ball.png"; style = 4 }
)

# Fix club list to 25
$clubs = @(
  @{ file = "club_real_madrid_001.jpg"; title = "Real Madrid"; sub = "Los Blancos"; accent = "FFD43B"; bg = "101008"; bg2 = "1C1808"; src = "hero_club_gold.png"; style = 0 },
  @{ file = "club_real_madrid_002.jpg"; title = "Madrid Night"; sub = "Bernabeu Glow"; accent = "FFFFFF"; bg = "0A0C12"; bg2 = "161A28"; src = "hero_stadium_night.png"; style = 1 },
  @{ file = "club_barcelona_001.jpg"; title = "Barcelona"; sub = "Blaugrana"; accent = "4DABF7"; bg = "07101C"; bg2 = "1A0A14"; src = "hero_crowd_wave.png"; style = 0 },
  @{ file = "club_liverpool_001.jpg"; title = "Liverpool"; sub = "You'll Never Walk Alone"; accent = "C92A2A"; bg = "140404"; bg2 = "2A080C"; src = "hero_crowd_wave.png"; style = 1 },
  @{ file = "club_liverpool_002.jpg"; title = "Anfield Roar"; sub = "This Is Anfield"; accent = "E03131"; bg = "140404"; bg2 = "220808"; src = "hero_tunnel.png"; style = 2 },
  @{ file = "club_man_city_001.jpg"; title = "Man City"; sub = "Sky Blue"; accent = "74C0FC"; bg = "06141E"; bg2 = "0A2838"; src = "hero_pitch_lines.png"; style = 5 },
  @{ file = "club_bayern_001.jpg"; title = "Bayern"; sub = "Mia San Mia"; accent = "E03131"; bg = "140404"; bg2 = "2A0808"; src = "hero_crowd_wave.png"; style = 0 },
  @{ file = "club_psg_001.jpg"; title = "PSG"; sub = "Paris Nights"; accent = "4DABF7"; bg = "07101C"; bg2 = "14081C"; src = "hero_france_navy.png"; style = 2 },
  @{ file = "club_arsenal_001.jpg"; title = "Arsenal"; sub = "Gunners"; accent = "FA5252"; bg = "140808"; bg2 = "2A1010"; src = "hero_crowd_wave.png"; style = 1 },
  @{ file = "club_chelsea_001.jpg"; title = "Chelsea"; sub = "The Blues"; accent = "4DABF7"; bg = "06101C"; bg2 = "0C2040"; src = "hero_pitch_lines.png"; style = 5 },
  @{ file = "club_juventus_001.jpg"; title = "Juventus"; sub = "Bianconeri"; accent = "FFFFFF"; bg = "0A0A0A"; bg2 = "1A1A1A"; src = "hero_tunnel.png"; style = 0 },
  @{ file = "club_inter_001.jpg"; title = "Inter"; sub = "Nerazzurri"; accent = "4DABF7"; bg = "06101C"; bg2 = "0A1830"; src = "hero_crowd_wave.png"; style = 2 },
  @{ file = "club_ac_milan_001.jpg"; title = "AC Milan"; sub = "Rossoneri"; accent = "C92A2A"; bg = "140404"; bg2 = "1A0808"; src = "hero_tunnel.png"; style = 1 },
  @{ file = "club_dortmund_001.jpg"; title = "Dortmund"; sub = "Yellow Wall"; accent = "FFD43B"; bg = "121000"; bg2 = "2A2200"; src = "hero_crowd_wave.png"; style = 0 },
  @{ file = "club_ajax_001.jpg"; title = "Ajax"; sub = "Godenzonen"; accent = "FA5252"; bg = "140808"; bg2 = "281010"; src = "hero_pitch_lines.png"; style = 5 },
  @{ file = "club_napoli_001.jpg"; title = "Napoli"; sub = "Azzurri"; accent = "4DABF7"; bg = "06141E"; bg2 = "0A2848"; src = "hero_crowd_wave.png"; style = 2 },
  @{ file = "club_atletico_001.jpg"; title = "Atletico"; sub = "Simeone Fire"; accent = "E03131"; bg = "140808"; bg2 = "1C0C18"; src = "hero_crowd_wave.png"; style = 1 },
  @{ file = "club_tottenham_001.jpg"; title = "Tottenham"; sub = "Lilywhites"; accent = "FFFFFF"; bg = "0B1020"; bg2 = "161E30"; src = "hero_pitch_lines.png"; style = 5 },
  @{ file = "club_newcastle_001.jpg"; title = "Newcastle"; sub = "Magpies"; accent = "FFFFFF"; bg = "0A0A0A"; bg2 = "1C1C1C"; src = "hero_crowd_wave.png"; style = 0 },
  @{ file = "club_benfica_001.jpg"; title = "Benfica"; sub = "Eagles"; accent = "E03131"; bg = "140404"; bg2 = "2A0A0A"; src = "hero_portugal_smoke.png"; style = 2 },
  @{ file = "club_porto_001.jpg"; title = "Porto"; sub = "Dragons"; accent = "4DABF7"; bg = "06101C"; bg2 = "0C2040"; src = "hero_portugal_smoke.png"; style = 1 },
  @{ file = "club_sporting_001.jpg"; title = "Sporting"; sub = "Lions"; accent = "69DB7C"; bg = "081408"; bg2 = "123018"; src = "hero_portugal_smoke.png"; style = 0 },
  @{ file = "club_river_plate_001.jpg"; title = "River Plate"; sub = "La Banda"; accent = "E03131"; bg = "140808"; bg2 = "201010"; src = "hero_argentina_abstract.png"; style = 1 },
  @{ file = "club_boca_001.jpg"; title = "Boca"; sub = "Xeneize"; accent = "FFD43B"; bg = "06101C"; bg2 = "122008"; src = "hero_argentina_abstract.png"; style = 2 },
  @{ file = "club_flamengo_001.jpg"; title = "Flamengo"; sub = "Mengao"; accent = "E03131"; bg = "140404"; bg2 = "1A1008"; src = "hero_brazil_gold.png"; style = 0 }
)

$folderMap = @{
  players = "players"
  clubs = "clubs"
  national = "national_teams"
  legends = "legends"
  stadiums = "stadiums"
  "3d" = "3d"
}

function Emit-Set($items, $folder) {
  $i = 0
  foreach ($it in $items) {
    $i++
    $w = 1080; $h = 1920; $q = 82
    $featured = $false
    if ($it.file -in @("stadium_001.jpg", "football_3d_001.jpg", "player_messi_001.jpg", "player_ronaldo_001.jpg", "club_real_madrid_001.jpg", "national_argentina_001.jpg", "legend_maradona_001.jpg", "player_salah_001.jpg")) {
      $w = 1440; $h = 2560; $q = 80; $featured = $true
    }
    $path = Join-Path (Join-Path $wallRoot $folder) $it.file
    Write-Host "Generating $($it.file) ($w x $h)"
    New-Wallpaper -OutPath $path -Width $w -Height $h -Title $it.title -Subtitle $it.sub -AccentHex $it.accent -BgHex $it.bg -Bg2Hex $it.bg2 -SourceName $it.src -Style ([int]$it.style) -Quality $q
  }
  Write-Host "$folder count=$i"
}

Emit-Set $players "players"
Emit-Set $clubs "clubs"
Emit-Set $nationals "national_teams"
Emit-Set $legends "legends"
Emit-Set $stadiums "stadiums"
Emit-Set $threed "3d"

# Category thumbs 600x800
$thumbs = @(
  @{ src = "cat_players.png"; out = "players.jpg" },
  @{ src = "cat_clubs.png"; out = "clubs.jpg" },
  @{ src = "cat_national.png"; out = "national_teams.jpg" },
  @{ src = "cat_legends.png"; out = "legends.jpg" },
  @{ src = "cat_stadiums.png"; out = "stadiums.jpg" },
  @{ src = "cat_3d.png"; out = "3d.jpg" },
  @{ src = "hero_club_gold.png"; out = "champions_league.jpg" },
  @{ src = "hero_pitch_lines.png"; out = "leagues.jpg" },
  @{ src = "hero_minimal_ball.png"; out = "minimal.jpg" },
  @{ src = "hero_legends_gold.png"; out = "quotes.jpg" }
)
foreach ($t in $thumbs) {
  $img = [System.Drawing.Image]::FromFile((Join-Path $srcRoot $t.src))
  $bmp = New-Object System.Drawing.Bitmap 600, 800
  $g = [System.Drawing.Graphics]::FromImage($bmp)
  $g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
  Draw-Cover $g $img 600 800
  $g.Dispose(); $img.Dispose()
  Save-Jpeg $bmp (Join-Path $catRoot $t.out) 85
  $bmp.Dispose()
}

# Branding
Copy-Item (Join-Path $srcRoot "app_icon.png") (Join-Path $brandRoot "app_icon.png") -Force
Copy-Item (Join-Path $srcRoot "hero_3d_neon.png") (Join-Path $brandRoot "splash_ball.png") -Force

# Extra onboarding backgrounds
Copy-Item (Join-Path $srcRoot "hero_stadium_night.png") (Join-Path $brandRoot "onboarding_1.png") -Force
Copy-Item (Join-Path $srcRoot "hero_goal_net.png") (Join-Path $brandRoot "onboarding_2.png") -Force
Copy-Item (Join-Path $srcRoot "hero_golden_strike.png") (Join-Path $brandRoot "onboarding_3.png") -Force

Write-Host "DONE"
Get-ChildItem $wallRoot -Recurse -File | Measure-Object | Select-Object Count
