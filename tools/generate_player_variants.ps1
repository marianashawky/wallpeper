# Creates looks 002-005 for every player (001 stays as-is).
$ErrorActionPreference = "Stop"
Add-Type -AssemblyName System.Drawing

$srcRoot = "C:\Users\marin\.cursor\projects\c-Users-marin-WALLPEPER\assets"
$outDir = "c:\Users\marin\WALLPEPER\assets\images\wallpapers\players"
New-Item -ItemType Directory -Force -Path $outDir | Out-Null

function Get-Encoder([string]$mime) {
  foreach ($c in [System.Drawing.Imaging.ImageCodecInfo]::GetImageEncoders()) {
    if ($c.MimeType -eq $mime) { return $c }
  }
  return $null
}

function Save-Jpeg([System.Drawing.Bitmap]$bmp, [string]$path, [int]$quality) {
  $enc = Get-Encoder "image/jpeg"
  $ep = New-Object System.Drawing.Imaging.EncoderParameters 1
  $ep.Param[0] = New-Object System.Drawing.Imaging.EncoderParameter ([System.Drawing.Imaging.Encoder]::Quality, [long]$quality)
  $bmp.Save($path, $enc, $ep)
  $ep.Dispose()
}

function Draw-CoverBias([System.Drawing.Graphics]$g, [System.Drawing.Image]$img, [int]$w, [int]$h, [double]$bx, [double]$by) {
  $scale = [Math]::Max($w / [double]$img.Width, $h / [double]$img.Height) * 1.08
  $nw = [int]($img.Width * $scale)
  $nh = [int]($img.Height * $scale)
  $x = [int](($w - $nw) * $bx)
  $y = [int](($h - $nh) * $by)
  $g.DrawImage($img, $x, $y, $nw, $nh)
}

function Add-Caption([System.Drawing.Graphics]$g, [int]$w, [int]$h, [string]$title, [string]$sub) {
  $g.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::AntiAliasGridFit
  $fadeRect = New-Object System.Drawing.Rectangle 0, ([int]($h * 0.70)), $w, ([int]($h * 0.30))
  $fade = New-Object System.Drawing.Drawing2D.LinearGradientBrush $fadeRect, ([System.Drawing.Color]::FromArgb(0, 0, 0, 0)), ([System.Drawing.Color]::FromArgb(220, 0, 0, 0)), 90.0
  $g.FillRectangle($fade, $fadeRect)
  $fade.Dispose()
  $accent = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(255, 57, 255, 20))
  $g.FillRectangle($accent, 48, [int]($h * 0.76), 54, 5)
  $accent.Dispose()
  $titleFont = New-Object System.Drawing.Font "Segoe UI", 34, ([System.Drawing.FontStyle]::Bold)
  $subFont = New-Object System.Drawing.Font "Segoe UI", 16
  $white = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::White)
  $muted = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(210, 200, 210, 205))
  $g.DrawString($title.ToUpper(), $titleFont, $white, 48, [int]($h * 0.79))
  $g.DrawString($sub, $subFont, $muted, 48, [int]($h * 0.88))
  $titleFont.Dispose(); $subFont.Dispose(); $white.Dispose(); $muted.Dispose()
}

function Write-Look {
  param(
    [string]$Base,
    [string]$Overlay,
    [string]$Dest,
    [string]$Title,
    [string]$Sub,
    [double]$Bx = 0.5,
    [double]$By = 0.35,
    [double]$OverlayAlpha = 0.0,
    [int]$TintA = 70,
    [int]$TintR = 0,
    [int]$TintG = 0,
    [int]$TintB = 0,
    [int]$W = 1080,
    [int]$H = 1920
  )
  $basePath = Join-Path $srcRoot $Base
  if (-not (Test-Path $basePath)) { throw "Missing $basePath" }
  $baseImg = [System.Drawing.Image]::FromFile($basePath)
  $bmp = New-Object System.Drawing.Bitmap $W, $H
  $g = [System.Drawing.Graphics]::FromImage($bmp)
  $g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
  $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
  Draw-CoverBias $g $baseImg $W $H $Bx $By
  $baseImg.Dispose()

  if ($OverlayAlpha -gt 0 -and $Overlay) {
    $overPath = Join-Path $srcRoot $Overlay
    if (Test-Path $overPath) {
      $over = [System.Drawing.Image]::FromFile($overPath)
      $cm = New-Object System.Drawing.Imaging.ColorMatrix
      $cm.Matrix33 = [float]$OverlayAlpha
      $ia = New-Object System.Drawing.Imaging.ImageAttributes
      $ia.SetColorMatrix($cm)
      $destRect = New-Object System.Drawing.Rectangle 0, 0, $W, $H
      $g.DrawImage($over, $destRect, 0, 0, $over.Width, $over.Height, [System.Drawing.GraphicsUnit]::Pixel, $ia)
      $ia.Dispose()
      $over.Dispose()
    }
  }

  if ($TintA -gt 0) {
    $tint = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb($TintA, $TintR, $TintG, $TintB))
    $g.FillRectangle($tint, 0, 0, $W, $H)
    $tint.Dispose()
  }

  Add-Caption $g $W $H $Title $Sub
  $g.Dispose()
  Save-Jpeg $bmp $Dest 86
  $bmp.Dispose()
  Write-Host $Dest
}

$players = @(
  @{ slug = "messi"; title = "Messi"; club = "Inter Miami"; back = "player_messi_back.png" },
  @{ slug = "ronaldo"; title = "Ronaldo"; club = "Al Nassr"; back = "player_ronaldo_back.png" },
  @{ slug = "salah"; title = "Salah"; club = "Liverpool"; back = "player_salah_back.png" },
  @{ slug = "mbappe"; title = "Mbappe"; club = "Real Madrid"; back = "player_mbappe_back.png" },
  @{ slug = "haaland"; title = "Haaland"; club = "Man City"; back = "player_haaland_back.png" },
  @{ slug = "vinicius"; title = "Vinicius"; club = "Real Madrid"; back = "player_vinicius_back.png" },
  @{ slug = "bellingham"; title = "Bellingham"; club = "Real Madrid"; back = "player_bellingham_back.png" },
  @{ slug = "foden"; title = "Foden"; club = "Man City"; back = "player_haaland_back.png" },
  @{ slug = "yamal"; title = "Yamal"; club = "Barcelona"; back = "player_yamal_back.png" },
  @{ slug = "saka"; title = "Saka"; club = "Arsenal"; back = "player_saka_back.png" },
  @{ slug = "de_bruyne"; title = "De Bruyne"; club = "Man City"; back = "player_haaland_back.png" },
  @{ slug = "lewandowski"; title = "Lewandowski"; club = "Barcelona"; back = "player_yamal_back.png" },
  @{ slug = "kane"; title = "Kane"; club = "Bayern"; back = "player_ronaldo_back.png" },
  @{ slug = "neymar"; title = "Neymar"; club = "Santos"; back = "player_neymar_back.png" },
  @{ slug = "benzema"; title = "Benzema"; club = "Al Ittihad"; back = "player_mbappe_back.png" },
  @{ slug = "modric"; title = "Modric"; club = "Real Madrid"; back = "player_mbappe_back.png" },
  @{ slug = "rodri"; title = "Rodri"; club = "Man City"; back = "player_haaland_back.png" },
  @{ slug = "valverde"; title = "Valverde"; club = "Real Madrid"; back = "player_vinicius_back.png" },
  @{ slug = "pedri"; title = "Pedri"; club = "Barcelona"; back = "player_yamal_back.png" },
  @{ slug = "gavi"; title = "Gavi"; club = "Barcelona"; back = "player_yamal_back.png" },
  @{ slug = "osimhen"; title = "Osimhen"; club = "Galatasaray"; back = "player_haaland_back.png" },
  @{ slug = "courtois"; title = "Courtois"; club = "Real Madrid"; back = "player_mbappe_back.png" },
  @{ slug = "van_dijk"; title = "Van Dijk"; club = "Liverpool"; back = "player_salah_back.png" },
  @{ slug = "hakimi"; title = "Hakimi"; club = "PSG"; back = "national_france_back.png" },
  @{ slug = "griezmann"; title = "Griezmann"; club = "Atletico"; back = "national_france_back.png" },
  @{ slug = "son"; title = "Son"; club = "Tottenham"; back = "player_mbappe_back.png" },
  @{ slug = "musiala"; title = "Musiala"; club = "Bayern"; back = "player_ronaldo_back.png" },
  @{ slug = "rice"; title = "Rice"; club = "Arsenal"; back = "player_saka_back.png" },
  @{ slug = "palmer"; title = "Palmer"; club = "Chelsea"; back = "player_haaland_back.png" },
  @{ slug = "isak"; title = "Isak"; club = "Newcastle"; back = "player_ronaldo_back.png" }
)

foreach ($p in $players) {
  $slug = $p.slug
  $title = $p.title
  $club = $p.club
  $back = $p.back
  Write-Look -Base "hero_stadium_night.png" -Overlay $back -Dest "$outDir\player_${slug}_002.jpg" -Title $title -Sub "$club  •  Stadium Night" -Bx 0.4 -By 0.2 -OverlayAlpha 0.62 -TintA 80 -TintR 8 -TintG 18 -TintB 40
  Write-Look -Base "hero_tunnel.png" -Overlay $back -Dest "$outDir\player_${slug}_003.jpg" -Title $title -Sub "$club  •  Tunnel Walk" -Bx 0.6 -By 0.55 -OverlayAlpha 0.58 -TintA 90 -TintR 0 -TintG 0 -TintB 0
  Write-Look -Base "hero_crowd_wave.png" -Overlay $back -Dest "$outDir\player_${slug}_004.jpg" -Title $title -Sub "$club  •  Matchday" -Bx 0.3 -By 0.15 -OverlayAlpha 0.5 -TintA 70 -TintR 40 -TintG 0 -TintB 20
  Write-Look -Base $back -Overlay "hero_pitch_lines.png" -Dest "$outDir\player_${slug}_005.jpg" -Title $title -Sub "$club  •  Close-up" -Bx 0.5 -By 0.72 -OverlayAlpha 0.28 -TintA 55 -TintR 0 -TintG 40 -TintB 8
}

Write-Host "PLAYER_VARIANTS_OK"
