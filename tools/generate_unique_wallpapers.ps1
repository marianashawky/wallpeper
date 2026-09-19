# Unique wallpaper set: one original composition per file. No shared kit-back composites.
# Player looks are 5 different layouts. Clubs/nationals/stadiums use unique Wikimedia photos (CC).
$ErrorActionPreference = "Stop"
Add-Type -AssemblyName System.Drawing

$root = "c:\Users\marin\WALLPEPER\assets\images"
$W = 720
$H = 1280
$ua = "FootballWallpaper/1.0 (local unique asset rebuild)"

function Get-Encoder([string]$mime) {
  foreach ($c in [System.Drawing.Imaging.ImageCodecInfo]::GetImageEncoders()) {
    if ($c.MimeType -eq $mime) { return $c }
  }
  return $null
}

function Save-Jpeg([System.Drawing.Bitmap]$bmp, [string]$path, [int]$quality = 88) {
  $dir = Split-Path $path
  if (-not (Test-Path $dir)) { New-Item -ItemType Directory -Force -Path $dir | Out-Null }
  $enc = Get-Encoder "image/jpeg"
  $ep = New-Object System.Drawing.Imaging.EncoderParameters 1
  $ep.Param[0] = New-Object System.Drawing.Imaging.EncoderParameter ([System.Drawing.Imaging.Encoder]::Quality, [long]$quality)
  $bmp.Save($path, $enc, $ep)
  $ep.Dispose()
}

function C([int]$r, [int]$g, [int]$b, [int]$a = 255) {
  return [System.Drawing.Color]::FromArgb($a, $r, $g, $b)
}

function New-Gfx([System.Drawing.Bitmap]$bmp) {
  $g = [System.Drawing.Graphics]::FromImage($bmp)
  $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
  $g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
  $g.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::AntiAliasGridFit
  return $g
}

function Seed-From([string]$s) {
  $h = 2166136261
  foreach ($ch in $s.ToCharArray()) { $h = (($h -bxor [int]$ch) * 16777619) -band 0x7fffffff }
  if ($h -eq 0) { return 1 }
  return [int]$h
}

function Draw-Cover([System.Drawing.Graphics]$g, [System.Drawing.Image]$img, [int]$w, [int]$h, [double]$bx, [double]$by) {
  $scale = [Math]::Max($w / [double]$img.Width, $h / [double]$img.Height) * 1.02
  $nw = [int]($img.Width * $scale)
  $nh = [int]($img.Height * $scale)
  $x = [int](($w - $nw) * $bx)
  $y = [int](($h - $nh) * $by)
  $g.DrawImage($img, $x, $y, $nw, $nh)
}

function Add-Caption([System.Drawing.Graphics]$g, [int]$w, [int]$h, [string]$title, [string]$sub) {
  $fadeRect = New-Object System.Drawing.Rectangle 0, ([int]($h * 0.68)), $w, ([int]($h * 0.32))
  $c0 = C 0 0 0 0
  $c1 = C 0 0 0 230
  $fade = New-Object System.Drawing.Drawing2D.LinearGradientBrush $fadeRect, $c0, $c1, 90.0
  $g.FillRectangle($fade, $fadeRect)
  $fade.Dispose()
  $accent = New-Object System.Drawing.SolidBrush (C 57 255 20)
  $g.FillRectangle($accent, 36, [int]($h * 0.74), 48, 5)
  $accent.Dispose()
  $tf = New-Object System.Drawing.Font "Segoe UI", 28, ([System.Drawing.FontStyle]::Bold)
  $sf = New-Object System.Drawing.Font "Segoe UI", 13
  $white = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::White)
  $muted = New-Object System.Drawing.SolidBrush (C 200 210 205 220)
  $g.DrawString($title.ToUpper(), $tf, $white, 36, [int]($h * 0.78))
  $g.DrawString($sub, $sf, $muted, 36, [int]($h * 0.88))
  $tf.Dispose(); $sf.Dispose(); $white.Dispose(); $muted.Dispose()
}

function Draw-LookKit($g, $w, $h, $p, $rng) {
  $rect = New-Object System.Drawing.Rectangle 0, 0, $w, $h
  $cA = C $p.r1 $p.g1 $p.b1
  $cB = C $p.r2 $p.g2 $p.b2
  $bg = New-Object System.Drawing.Drawing2D.LinearGradientBrush $rect, $cA, $cB, 90.0
  $g.FillRectangle($bg, 0, 0, $w, $h); $bg.Dispose()
  $kit = New-Object System.Drawing.SolidBrush (C $p.r2 $p.g2 $p.b2)
  $pts = @(
    (New-Object System.Drawing.Point ($w/2-210), 220),
    (New-Object System.Drawing.Point ($w/2+210), 220),
    (New-Object System.Drawing.Point ($w/2+250), 340),
    (New-Object System.Drawing.Point ($w/2+190), 1100),
    (New-Object System.Drawing.Point ($w/2-190), 1100),
    (New-Object System.Drawing.Point ($w/2-250), 340)
  )
  $g.FillPolygon($kit, $pts)
  $kit.Dispose()
  $stripe = New-Object System.Drawing.SolidBrush (C $p.r1 $p.g1 $p.b1)
  $g.FillRectangle($stripe, [int]($w/2-28), 360, 56, 680)
  $stripe.Dispose()
  $nf = New-Object System.Drawing.Font "Segoe UI", 92, ([System.Drawing.FontStyle]::Bold)
  $white = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::White)
  $sz = $g.MeasureString($p.num, $nf)
  $g.DrawString($p.num, $nf, $white, ($w - $sz.Width)/2, 520)
  $lf = New-Object System.Drawing.Font "Segoe UI", 22, ([System.Drawing.FontStyle]::Bold)
  $lsz = $g.MeasureString($p.name, $lf)
  $g.DrawString($p.name, $lf, $white, ($w - $lsz.Width)/2, 470)
  $nf.Dispose(); $lf.Dispose(); $white.Dispose()
}

function Draw-LookCity($g, $w, $h, $p, $rng) {
  $g.Clear((C 4 8 18))
  for ($i=0; $i -lt 80; $i++) {
    $star = New-Object System.Drawing.SolidBrush (C 255 255 255 ($rng.Next(40,180)))
    $g.FillEllipse($star, $rng.Next(0,$w), $rng.Next(0,[int]($h*0.45)), 2, 2)
    $star.Dispose()
  }
  $horizon = New-Object System.Drawing.SolidBrush (C $p.r2 $p.g2 $p.b2 80)
  $g.FillEllipse($horizon, -80, [int]($h*0.38), $w+160, 220)
  $horizon.Dispose()
  $bldg = New-Object System.Drawing.SolidBrush (C 8 12 22)
  $win = New-Object System.Drawing.SolidBrush (C $p.r2 $p.g2 $p.b2 180)
  $x = 0
  while ($x -lt $w) {
    $bw = $rng.Next(36, 90)
    $bh = $rng.Next(180, 520)
    $g.FillRectangle($bldg, $x, $h - $bh - 80, $bw, $bh)
    for ($yy = $h - $bh; $yy -lt $h-100; $yy += 18) {
      if ($rng.NextDouble() -gt 0.45) { $g.FillRectangle($win, $x+8, $yy, 8, 8) }
    }
    $x += $bw + 6
  }
  $bldg.Dispose(); $win.Dispose()
  $neon = New-Object System.Drawing.SolidBrush (C 57 255 20)
  $nf = New-Object System.Drawing.Font "Segoe UI", 36, ([System.Drawing.FontStyle]::Bold)
  $g.DrawString($p.name, $nf, $neon, 40, [int]($h*0.22))
  $nf.Dispose(); $neon.Dispose()
}

function Draw-LookTunnel($g, $w, $h, $p, $rng) {
  $g.Clear((C 6 6 8))
  for ($i=18; $i -ge 1; $i--) {
    $t = $i / 18.0
    $rw = [int]($w * $t)
    $rh = [int]($h * $t * 0.55)
    $col = C ([int]($p.r1*$t+10)) ([int]($p.g1*$t)) ([int]($p.b1*$t+8))
    $br = New-Object System.Drawing.SolidBrush $col
    $g.FillRectangle($br, ($w-$rw)/2, ($h-$rh)/2 - 80, $rw, $rh)
    $br.Dispose()
  }
  $light = New-Object System.Drawing.SolidBrush (C 255 240 200 40)
  $g.FillEllipse($light, $w/2-90, 80, 180, 90)
  $light.Dispose()
  $nf = New-Object System.Drawing.Font "Segoe UI", 26, ([System.Drawing.FontStyle]::Bold)
  $white = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::White)
  $g.DrawString($p.name, $nf, $white, 40, $h-180)
  $g.DrawString("TUNNEL  #" + $p.num, $nf, $white, 40, $h-140)
  $nf.Dispose(); $white.Dispose()
}

function Draw-LookPoster($g, $w, $h, $p, $rng) {
  $g.Clear((C 236 228 210))
  $bar = New-Object System.Drawing.SolidBrush (C $p.r1 $p.g1 $p.b1)
  $g.FillRectangle($bar, 0, 0, $w, 90)
  $g.FillRectangle($bar, 0, $h-90, $w, 90)
  $bar.Dispose()
  $ink = New-Object System.Drawing.SolidBrush (C 20 20 20)
  $big = New-Object System.Drawing.Font "Segoe UI", 48, ([System.Drawing.FontStyle]::Bold)
  $mid = New-Object System.Drawing.Font "Segoe UI", 18
  $g.DrawString("MATCHDAY", $mid, $ink, 40, 120)
  $g.DrawString($p.name, $big, $ink, 36, 170)
  $g.DrawString("#" + $p.num, $big, $ink, 36, 260)
  $box = New-Object System.Drawing.SolidBrush (C $p.r2 $p.g2 $p.b2)
  $g.FillRectangle($box, 48, 420, $w-96, 420)
  $box.Dispose()
  $white = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::White)
  $g.DrawString("KICK-OFF", $mid, $white, 72, 460)
  $g.DrawString("POSTER LOOK", $mid, $white, 72, 510)
  $g.DrawString($p.club, $mid, $white, 72, 560)
  $big.Dispose(); $mid.Dispose(); $ink.Dispose(); $white.Dispose()
}

function Draw-LookMotion($g, $w, $h, $p, $rng) {
  $g.Clear((C 2 4 10))
  for ($i=0; $i -lt 14; $i++) {
    $br = New-Object System.Drawing.SolidBrush (C $p.r2 $p.g2 $p.b2 ($rng.Next(40,140)))
    $g.FillEllipse($br, $rng.Next(-80,$w), $rng.Next(-40,$h), $rng.Next(80,320), $rng.Next(80,320))
    $br.Dispose()
  }
  $penC = C 57 255 20 180
  $pen = New-Object System.Drawing.Pen $penC, 8.0
  for ($i=0; $i -lt 7; $i++) {
    $g.DrawLine($pen, 0, 80+$i*160, $w, 20+$i*140 + $rng.Next(-40,40))
  }
  $pen.Dispose()
  $nf = New-Object System.Drawing.Font "Segoe UI", 34, ([System.Drawing.FontStyle]::Bold)
  $white = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::White)
  $g.DrawString($p.name, $nf, $white, 40, $h-220)
  $g.DrawString("MOTION  " + $p.num, $nf, $white, 40, $h-160)
  $nf.Dispose(); $white.Dispose()
}

function Write-PlayerLook($p, [int]$look, [string]$dest) {
  $bmp = New-Object System.Drawing.Bitmap $W, $H
  $g = New-Gfx $bmp
  $rng = New-Object System.Random (Seed-From ($p.slug + "-$look"))
  switch ($look) {
    0 { Draw-LookKit $g $W $H $p $rng }
    1 { Draw-LookCity $g $W $H $p $rng }
    2 { Draw-LookTunnel $g $W $H $p $rng }
    3 { Draw-LookPoster $g $W $H $p $rng }
    4 { Draw-LookMotion $g $W $H $p $rng }
  }
  $subs = @("Kit Number","Neon City","Tunnel Walk","Match Poster","Motion Cut")
  Add-Caption $g $W $H $p.name $subs[$look]
  $g.Dispose()
  Save-Jpeg $bmp $dest
  $bmp.Dispose()
}

function Draw-ProceduralScene($g, $w, $h, [int]$seed, [int]$r, [int]$gg, [int]$b) {
  $rng = New-Object System.Random $seed
  $mode = $seed % 4
  $rect = New-Object System.Drawing.Rectangle 0, 0, $w, $h
  $cA = C ($rng.Next(2, 18)) ($rng.Next(4, 24)) ($rng.Next(10, 40))
  $cB = C $r $gg $b
  $sky = New-Object System.Drawing.Drawing2D.LinearGradientBrush $rect, $cA, $cB, (30.0 + ($mode * 20))
  $g.FillRectangle($sky, 0, 0, $w, $h); $sky.Dispose()
  if ($mode -eq 0) {
    $pitch = New-Object System.Drawing.SolidBrush (C ($rng.Next(10,40)) ($rng.Next(70,140)) ($rng.Next(20,60)))
    $g.FillEllipse($pitch, -40, [int]($h*0.52), $w+80, [int]($h*0.55))
    $pitch.Dispose()
  } elseif ($mode -eq 1) {
    $pitch = New-Object System.Drawing.SolidBrush (C ($rng.Next(10,40)) ($rng.Next(70,140)) ($rng.Next(20,60)))
    $g.FillRectangle($pitch, 0, [int]($h*0.45), $w, [int]($h*0.55))
    $pitch.Dispose()
    $lineC = C 230 230 230 160
    $line = New-Object System.Drawing.Pen $lineC, 3.0
    $g.DrawLine($line, [int]($w/2), [int]($h*0.45), [int]($w/2), $h)
    $line.Dispose()
  } elseif ($mode -eq 2) {
    for ($i=0; $i -lt 9; $i++) {
      $br = New-Object System.Drawing.SolidBrush (C $r $gg $b (40 + $i*8))
      $g.FillEllipse($br, [int]($w/2 - 200 + $i*8), [int](180+$i*70), 400-$i*30, 90)
      $br.Dispose()
    }
  } else {
    for ($i=0; $i -lt 22; $i++) {
      $br = New-Object System.Drawing.SolidBrush (C $r $gg $b ($rng.Next(30,90)))
      $g.FillEllipse($br, $rng.Next(-40,$w), $rng.Next([int]($h*0.4), $h), $rng.Next(20,90), $rng.Next(20,90))
      $br.Dispose()
    }
  }
  $st = New-Object System.Drawing.SolidBrush (C 12 16 28 200)
  for ($i=0; $i -lt 16; $i++) {
    $x1 = [int]($i * 48 - 20)
    $x2 = [int]($i * 48 + 40)
    $x3 = [int]($i * 48 + 24)
    $y1 = [int]($h * (0.38 + ($mode * 0.04)))
    $y3 = [int]($h * 0.16 + $rng.Next(0, 90))
    $p1 = New-Object System.Drawing.Point $x1, $y1
    $p2 = New-Object System.Drawing.Point $x2, $y1
    $p3 = New-Object System.Drawing.Point $x3, $y3
    $g.FillPolygon($st, [System.Drawing.Point[]]@($p1, $p2, $p3))
  }
  $st.Dispose()
}

function Write-Procedural([string]$dest, [string]$title, [string]$sub, [int]$seed, [int]$r, [int]$gg, [int]$b) {
  $bmp = New-Object System.Drawing.Bitmap $W, $H
  $g = New-Gfx $bmp
  Draw-ProceduralScene $g $W $H $seed $r $gg $b
  Add-Caption $g $W $H $title $sub
  $g.Dispose()
  Save-Jpeg $bmp $dest
  $bmp.Dispose()
}

function Write-3dStill([string]$dest, [string]$title, [string]$sub, [int]$seed) {
  $bmp = New-Object System.Drawing.Bitmap $W, $H
  $g = New-Gfx $bmp
  $rng = New-Object System.Random $seed
  $g.Clear((C 2 6 14))
  $style = $seed % 5
  for ($i=0; $i -lt 12; $i++) {
    $br = New-Object System.Drawing.SolidBrush (C ($rng.Next(20,80)) 255 ($rng.Next(20,90)) 50)
    $g.FillEllipse($br, $rng.Next(-60,$W), $rng.Next(-60,$H), $rng.Next(120,380), $rng.Next(120,380))
    $br.Dispose()
  }
  $gold = New-Object System.Drawing.SolidBrush (C 255 213 74)
  $white = New-Object System.Drawing.SolidBrush (C 240 244 250)
  if ($style -eq 0) {
    $g.FillEllipse($gold, [int]($W/2-90), 380, 180, 180)
    $g.FillRectangle($gold, [int]($W/2-40), 540, 80, 160)
    $g.FillRectangle($gold, [int]($W/2-70), 700, 140, 24)
  } elseif ($style -eq 1) {
    $g.FillEllipse($white, [int]($W/2-110), 420, 220, 220)
    $g.FillEllipse($gold, [int]($W/2-40), 490, 80, 80)
  } elseif ($style -eq 2) {
    $g.FillPie($gold, [int]($W/2-120), 360, 240, 240, 200, 140)
    $g.FillRectangle($gold, [int]($W/2-20), 560, 40, 180)
  } elseif ($style -eq 3) {
    $g.FillEllipse($white, 80, 520, 560, 220)
    $g.FillEllipse($gold, [int]($W/2-50), 470, 100, 100)
  } else {
    $g.FillRectangle($gold, [int]($W/2-130), 500, 260, 40)
    $g.FillEllipse($white, [int]($W/2-70), 400, 140, 140)
  }
  $gold.Dispose(); $white.Dispose()
  Add-Caption $g $W $H $title $sub
  $g.Dispose()
  Save-Jpeg $bmp $dest
  $bmp.Dispose()
}

function Get-WikiUrls([string]$query, [int]$need, $used) {
  $urls = New-Object System.Collections.Generic.List[string]
  $offset = 0
  while ($urls.Count -lt $need -and $offset -lt 120) {
    $q = [uri]::EscapeDataString($query)
    $api = "https://commons.wikimedia.org/w/api.php?action=query&format=json&generator=search&gsrsearch=$q&gsrnamespace=6&gsrlimit=20&gsroffset=$offset&prop=imageinfo&iiprop=url|mime|size&iiurlwidth=1280"
    $tmp = Join-Path $env:TEMP ("wiki_" + $offset + ".json")
    try {
      & curl.exe -sS -L -A $ua -o $tmp $api
      $json = Get-Content -Raw $tmp | ConvertFrom-Json
      if (-not $json.query.pages) { break }
      foreach ($prop in $json.query.pages.PSObject.Properties) {
        $info = $prop.Value.imageinfo
        if (-not $info) { continue }
        $ii = $info[0]
        if ($ii.mime -ne "image/jpeg") { continue }
        $u = [string]$ii.thumburl
        if ([string]::IsNullOrWhiteSpace($u)) { $u = [string]$ii.url }
        if ([string]::IsNullOrWhiteSpace($u)) { continue }
        if ($used.Contains($u)) { continue }
        [void]$used.Add($u)
        $urls.Add($u)
        if ($urls.Count -ge $need) { break }
      }
    } catch { }
    $offset += 20
  }
  return $urls
}

function Write-PhotoCover([string]$url, [string]$dest, [string]$title, [string]$sub, [int]$tintR, [int]$tintG, [int]$tintB) {
  $tmp = Join-Path $env:TEMP ("wp_" + [Guid]::NewGuid().ToString("N") + ".jpg")
  & curl.exe -sS -L -A $ua --fail --retry 3 --retry-delay 2 -o $tmp $url
  if ($LASTEXITCODE -ne 0) { throw "download failed $LASTEXITCODE" }
  if (-not (Test-Path $tmp) -or ((Get-Item $tmp).Length -lt 4000)) { throw "download failed" }
  $img = [System.Drawing.Image]::FromFile($tmp)
  $bmp = New-Object System.Drawing.Bitmap $W, $H
  $g = New-Gfx $bmp
  $rng = New-Object System.Random (Seed-From $dest)
  Draw-Cover $g $img $W $H (0.25 + $rng.NextDouble()*0.5) (0.2 + $rng.NextDouble()*0.4)
  $img.Dispose()
  $tint = New-Object System.Drawing.SolidBrush (C $tintR $tintG $tintB 55)
  $g.FillRectangle($tint, 0, 0, $W, $H)
  $tint.Dispose()
  Add-Caption $g $W $H $title $sub
  $g.Dispose()
  Save-Jpeg $bmp $dest
  $bmp.Dispose()
  Remove-Item $tmp -Force -ErrorAction SilentlyContinue
}

$players = @(
  @{ slug="messi"; name="MESSI"; num="10"; club="INTER MIAMI"; r1=15; g1=23; b1=42; r2=247; g2=181; b2=205 },
  @{ slug="ronaldo"; name="RONALDO"; num="7"; club="AL NASSR"; r1=12; g1=40; b1=28; r2=255; g2=214; b2=10 },
  @{ slug="salah"; name="SALAH"; num="11"; club="LIVERPOOL"; r1=140; g1=16; b1=28; r2=246; g2=246; b2=246 },
  @{ slug="mbappe"; name="MBAPPE"; num="10"; club="REAL MADRID"; r1=20; g1=24; b1=40; r2=255; g2=255; b2=255 },
  @{ slug="haaland"; name="HAALAND"; num="9"; club="MAN CITY"; r1=10; g1=42; b1=82; r2=108; g2=196; b2=232 },
  @{ slug="vinicius"; name="VINI JR"; num="7"; club="REAL MADRID"; r1=18; g1=22; b1=38; r2=245; g2=200; b2=70 },
  @{ slug="bellingham"; name="BELLINGHAM"; num="5"; club="REAL MADRID"; r1=24; g1=24; b1=28; r2=220; g2=220; b2=220 },
  @{ slug="foden"; name="FODEN"; num="47"; club="MAN CITY"; r1=8; g1=70; b1=140; r2=180; g2=230; b2=255 },
  @{ slug="yamal"; name="YAMAL"; num="10"; club="BARCELONA"; r1=10; g1=40; b1=110; r2=166; g2=25; b2=46 },
  @{ slug="saka"; name="SAKA"; num="7"; club="ARSENAL"; r1=160; g1=20; b1=40; r2=255; g2=255; b2=255 },
  @{ slug="de_bruyne"; name="DE BRUYNE"; num="17"; club="MAN CITY"; r1=12; g1=90; b1=160; r2=255; g2=255; b2=255 },
  @{ slug="lewandowski"; name="LEWANDOWSKI"; num="9"; club="BARCELONA"; r1=165; g1=25; b1=48; r2=10; g2=70; b2=150 },
  @{ slug="kane"; name="KANE"; num="9"; club="BAYERN"; r1=140; g1=20; b1=40; r2=220; g2=200; b2=40 },
  @{ slug="neymar"; name="NEYMAR"; num="10"; club="SANTOS"; r1=20; g1=90; b1=50; r2=255; g2=220; b2=40 },
  @{ slug="benzema"; name="BENZEMA"; num="9"; club="AL ITTIHAD"; r1=20; g1=40; b1=30; r2=255; g2=200; b2=40 },
  @{ slug="modric"; name="MODRIC"; num="10"; club="REAL MADRID"; r1=30; g1=40; b1=70; r2=255; g2=255; b2=255 },
  @{ slug="rodri"; name="RODRI"; num="16"; club="MAN CITY"; r1=6; g1=50; b1=110; r2=140; g2=210; b2=240 },
  @{ slug="valverde"; name="VALVERDE"; num="8"; club="REAL MADRID"; r1=16; g1=20; b1=32; r2=255; g2=215; b2=0 },
  @{ slug="pedri"; name="PEDRI"; num="8"; club="BARCELONA"; r1=8; g1=30; b1=90; r2=200; g2=30; b2=50 },
  @{ slug="gavi"; name="GAVI"; num="6"; club="BARCELONA"; r1=180; g1=20; b1=40; r2=20; g2=50; b2=120 },
  @{ slug="osimhen"; name="OSIMHEN"; num="9"; club="GALATASARAY"; r1=180; g1=30; b1=40; r2=255; g2=200; b2=20 },
  @{ slug="courtois"; name="COURTOIS"; num="1"; club="REAL MADRID"; r1=20; g1=30; b1=70; r2=240; g2=240; b2=240 },
  @{ slug="van_dijk"; name="VAN DIJK"; num="4"; club="LIVERPOOL"; r1=120; g1=10; b1=20; r2=245; g2=245; b2=245 },
  @{ slug="hakimi"; name="HAKIMI"; num="2"; club="PSG"; r1=10; g1=20; b1=50; r2=200; g2=20; b2=70 },
  @{ slug="griezmann"; name="GRIEZMANN"; num="7"; club="ATLETICO"; r1=180; g1=20; b1=40; r2=20; g2=40; b2=90 },
  @{ slug="son"; name="SON"; num="7"; club="TOTTENHAM"; r1=16; g1=20; b1=32; r2=255; g2=255; b2=255 },
  @{ slug="musiala"; name="MUSIALA"; num="42"; club="BAYERN"; r1=150; g1=20; b1=40; r2=220; g2=180; b2=30 },
  @{ slug="rice"; name="RICE"; num="41"; club="ARSENAL"; r1=140; g1=18; b1=32; r2=240; g2=240; b2=240 },
  @{ slug="palmer"; name="PALMER"; num="20"; club="CHELSEA"; r1=10; g1=30; b1=90; r2=255; g2=255; b2=255 },
  @{ slug="isak"; name="ISAK"; num="14"; club="NEWCASTLE"; r1=20; g1=20; b1=24; r2=230; g2=230; b2=230 }
)

Write-Host "Generating unique player looks..."
$playerDir = Join-Path $root "wallpapers\players"
New-Item -ItemType Directory -Force -Path $playerDir | Out-Null
foreach ($p in $players) {
  for ($look=0; $look -lt 5; $look++) {
    $id = "{0:D3}" -f ($look+1)
    $dest = Join-Path $playerDir ("player_{0}_{1}.jpg" -f $p.slug, $id)
    if (-not (Test-Path $dest)) { Write-PlayerLook $p $look $dest }
  }
  Write-Host ("  " + $p.slug)
}

$photoJobs = @(
  @{ rel="wallpapers\clubs\club_real_madrid_001.jpg"; title="REAL MADRID"; sub="Los Blancos"; r=20; g=40; b=90 },
  @{ rel="wallpapers\clubs\club_real_madrid_002.jpg"; title="MADRID NIGHT"; sub="Bernabeu Glow"; r=10; g=20; b=50 },
  @{ rel="wallpapers\clubs\club_barcelona_001.jpg"; title="BARCELONA"; sub="Blaugrana"; r=140; g=20; b=40 },
  @{ rel="wallpapers\clubs\club_liverpool_001.jpg"; title="LIVERPOOL"; sub="You'll Never Walk Alone"; r=140; g=10; b=20 },
  @{ rel="wallpapers\clubs\club_liverpool_002.jpg"; title="ANFIELD ROAR"; sub="This Is Anfield"; r=120; g=10; b=18 },
  @{ rel="wallpapers\clubs\club_man_city_001.jpg"; title="MAN CITY"; sub="Sky Blue"; r=20; g=90; b=160 },
  @{ rel="wallpapers\clubs\club_bayern_001.jpg"; title="BAYERN"; sub="Mia San Mia"; r=140; g=20; b=40 },
  @{ rel="wallpapers\clubs\club_psg_001.jpg"; title="PSG"; sub="Paris Nights"; r=20; g=20; b=80 },
  @{ rel="wallpapers\clubs\club_arsenal_001.jpg"; title="ARSENAL"; sub="Gunners"; r=160; g=20; b=40 },
  @{ rel="wallpapers\clubs\club_chelsea_001.jpg"; title="CHELSEA"; sub="The Blues"; r=10; g=40; b=110 },
  @{ rel="wallpapers\clubs\club_juventus_001.jpg"; title="JUVENTUS"; sub="Bianconeri"; r=20; g=20; b=20 },
  @{ rel="wallpapers\clubs\club_inter_001.jpg"; title="INTER"; sub="Nerazzurri"; r=10; g=30; b=90 },
  @{ rel="wallpapers\clubs\club_ac_milan_001.jpg"; title="AC MILAN"; sub="Rossoneri"; r=140; g=10; b=20 },
  @{ rel="wallpapers\clubs\club_dortmund_001.jpg"; title="DORTMUND"; sub="Yellow Wall"; r=200; g=180; b=20 },
  @{ rel="wallpapers\clubs\club_ajax_001.jpg"; title="AJAX"; sub="Godenzonen"; r=160; g=20; b=30 },
  @{ rel="wallpapers\clubs\club_napoli_001.jpg"; title="NAPOLI"; sub="Azzurri"; r=20; g=80; b=170 },
  @{ rel="wallpapers\clubs\club_atletico_001.jpg"; title="ATLETICO"; sub="Simeone Fire"; r=150; g=20; b=40 },
  @{ rel="wallpapers\clubs\club_tottenham_001.jpg"; title="TOTTENHAM"; sub="Lilywhites"; r=20; g=20; b=30 },
  @{ rel="wallpapers\clubs\club_newcastle_001.jpg"; title="NEWCASTLE"; sub="Magpies"; r=20; g=20; b=24 },
  @{ rel="wallpapers\clubs\club_benfica_001.jpg"; title="BENFICA"; sub="Eagles"; r=140; g=20; b=30 },
  @{ rel="wallpapers\clubs\club_porto_001.jpg"; title="PORTO"; sub="Dragons"; r=20; g=40; b=110 },
  @{ rel="wallpapers\clubs\club_sporting_001.jpg"; title="SPORTING"; sub="Lions"; r=20; g=90; b=40 },
  @{ rel="wallpapers\clubs\club_river_plate_001.jpg"; title="RIVER PLATE"; sub="La Banda"; r=200; g=200; b=210 },
  @{ rel="wallpapers\clubs\club_boca_001.jpg"; title="BOCA"; sub="Xeneize"; r=20; g=40; b=120 },
  @{ rel="wallpapers\clubs\club_flamengo_001.jpg"; title="FLAMENGO"; sub="Mengao"; r=140; g=10; b=20 },
  @{ rel="wallpapers\national_teams\national_argentina_001.jpg"; title="ARGENTINA"; sub="La Albiceleste"; r=100; g=180; b=220 },
  @{ rel="wallpapers\national_teams\national_portugal_001.jpg"; title="PORTUGAL"; sub="Selecao das Quinas"; r=80; g=20; b=40 },
  @{ rel="wallpapers\national_teams\national_brazil_001.jpg"; title="BRAZIL"; sub="Selecao"; r=30; g=140; b=70 },
  @{ rel="wallpapers\national_teams\national_france_001.jpg"; title="FRANCE"; sub="Les Bleus"; r=20; g=40; b=120 },
  @{ rel="wallpapers\national_teams\national_england_001.jpg"; title="ENGLAND"; sub="Three Lions"; r=180; g=20; b=40 },
  @{ rel="wallpapers\national_teams\national_spain_001.jpg"; title="SPAIN"; sub="La Roja"; r=160; g=20; b=30 },
  @{ rel="wallpapers\national_teams\national_germany_001.jpg"; title="GERMANY"; sub="Die Mannschaft"; r=20; g=20; b=20 },
  @{ rel="wallpapers\national_teams\national_italy_001.jpg"; title="ITALY"; sub="Azzurri"; r=20; g=70; b=150 },
  @{ rel="wallpapers\national_teams\national_netherlands_001.jpg"; title="NETHERLANDS"; sub="Oranje"; r=220; g=90; b=20 },
  @{ rel="wallpapers\national_teams\national_egypt_001.jpg"; title="EGYPT"; sub="The Pharaohs"; r=180; g=140; b=40 },
  @{ rel="wallpapers\national_teams\national_morocco_001.jpg"; title="MOROCCO"; sub="Atlas Lions"; r=140; g=20; b=30 },
  @{ rel="wallpapers\national_teams\national_japan_001.jpg"; title="JAPAN"; sub="Samurai Blue"; r=20; g=40; b=110 },
  @{ rel="wallpapers\national_teams\national_croatia_001.jpg"; title="CROATIA"; sub="Vatreni"; r=180; g=20; b=40 },
  @{ rel="wallpapers\national_teams\national_belgium_001.jpg"; title="BELGIUM"; sub="Red Devils"; r=150; g=10; b=20 },
  @{ rel="wallpapers\national_teams\national_uruguay_001.jpg"; title="URUGUAY"; sub="La Celeste"; r=80; g=170; b=210 },
  @{ rel="wallpapers\legends\legend_maradona_001.jpg"; title="MARADONA"; sub="El Diego"; r=80; g=160; b=210 },
  @{ rel="wallpapers\legends\legend_pele_001.jpg"; title="PELE"; sub="O Rei"; r=30; g=120; b=60 },
  @{ rel="wallpapers\legends\legend_zidane_001.jpg"; title="ZIDANE"; sub="Zizou"; r=20; g=40; b=110 },
  @{ rel="wallpapers\legends\legend_ronaldo_nazario_001.jpg"; title="RONALDO"; sub="Il Fenomeno"; r=220; g=180; b=40 },
  @{ rel="wallpapers\legends\legend_ronaldinho_001.jpg"; title="RONALDINHO"; sub="The Smile"; r=20; g=90; b=50 },
  @{ rel="wallpapers\legends\legend_cruyff_001.jpg"; title="CRUYFF"; sub="Total Football"; r=220; g=90; b=20 },
  @{ rel="wallpapers\legends\legend_beckenbauer_001.jpg"; title="BECKENBAUER"; sub="Der Kaiser"; r=180; g=20; b=40 },
  @{ rel="wallpapers\legends\legend_gerrard_001.jpg"; title="GERRARD"; sub="Captain Fantastic"; r=140; g=10; b=20 },
  @{ rel="wallpapers\legends\legend_henry_001.jpg"; title="HENRY"; sub="Va Va Voom"; r=160; g=20; b=40 },
  @{ rel="wallpapers\legends\legend_iniesta_001.jpg"; title="INIESTA"; sub="Don Andres"; r=10; g=40; b=110 },
  @{ rel="wallpapers\stadiums\stadium_001.jpg"; title="CHAMPIONS NIGHT"; sub="Wembley Final"; r=20; g=40; b=90 },
  @{ rel="wallpapers\stadiums\stadium_002.jpg"; title="NIGHT GLORY"; sub="Floodlight Bowl"; r=20; g=30; b=70 },
  @{ rel="wallpapers\stadiums\stadium_003.jpg"; title="SEA OF LIGHT"; sub="Crowd Ocean"; r=40; g=20; b=70 },
  @{ rel="wallpapers\stadiums\stadium_004.jpg"; title="THUNDER CROWD"; sub="Matchday Roar"; r=90; g=20; b=30 },
  @{ rel="wallpapers\stadiums\stadium_005.jpg"; title="FULL HOUSE"; sub="Sold Out"; r=20; g=80; b=50 },
  @{ rel="wallpapers\stadiums\stadium_006.jpg"; title="GREEN CATHEDRAL"; sub="Sacred Pitch"; r=20; g=90; b=40 },
  @{ rel="wallpapers\stadiums\stadium_007.jpg"; title="TWILIGHT BOWL"; sub="Purple Hour"; r=70; g=20; b=90 },
  @{ rel="wallpapers\stadiums\stadium_008.jpg"; title="CORNER LIGHTS"; sub="Flag Side"; r=30; g=70; b=40 },
  @{ rel="wallpapers\stadiums\stadium_009.jpg"; title="TUNNEL WALK"; sub="Into the Light"; r=20; g=20; b=24 },
  @{ rel="wallpapers\stadiums\stadium_010.jpg"; title="MIDNIGHT MATCH"; sub="Emerald Field"; r=10; g=60; b=40 },
  @{ rel="categories\players.jpg"; title="PLAYERS"; sub="Stars"; r=20; g=90; b=40 },
  @{ rel="categories\clubs.jpg"; title="CLUBS"; sub="Home Grounds"; r=20; g=40; b=90 },
  @{ rel="categories\national_teams.jpg"; title="NATIONS"; sub="World Stage"; r=20; g=70; b=140 },
  @{ rel="categories\champions_league.jpg"; title="UCL"; sub="Europe Nights"; r=20; g=30; b=90 },
  @{ rel="categories\leagues.jpg"; title="LEAGUES"; sub="The Game"; r=140; g=90; b=20 },
  @{ rel="categories\legends.jpg"; title="LEGENDS"; sub="Forever"; r=180; g=140; b=40 },
  @{ rel="categories\stadiums.jpg"; title="STADIUMS"; sub="Cathedrals"; r=20; g=50; b=40 },
  @{ rel="categories\3d.jpg"; title="3D ART"; sub="Live Motion"; r=40; g=255; b=80 },
  @{ rel="categories\minimal.jpg"; title="MINIMAL"; sub="Clean Lines"; r=20; g=80; b=60 },
  @{ rel="categories\quotes.jpg"; title="QUOTES"; sub="Words"; r=90; g=90; b=90 }
)

Write-Host "Writing unique club / nation / stadium / category scenes..."
foreach ($job in $photoJobs) {
  $dest = Join-Path $root $job.rel
  Write-Procedural $dest $job.title $job.sub (Seed-From $job.rel) $job.r $job.g $job.b
}

Write-Host "Generating unique 3D stills..."
$td = @(
  @{ f="football_3d_001.jpg"; t="UCL TROPHY"; s="The Cup" },
  @{ f="football_3d_002.jpg"; t="WORLD CUP"; s="The Greatest Prize" },
  @{ f="football_3d_003.jpg"; t="EURO TROPHY"; s="Nations of Europe" },
  @{ f="football_3d_004.jpg"; t="GOAL"; s="Ball in the Net" },
  @{ f="football_3d_005.jpg"; t="PENALTY"; s="The Spot" },
  @{ f="football_3d_006.jpg"; t="CAPTAIN"; s="The Armband" },
  @{ f="football_3d_007.jpg"; t="FINAL NIGHT"; s="European Glory" },
  @{ f="football_3d_008.jpg"; t="WORLD CHAMPIONS"; s="Final Whistle" },
  @{ f="football_3d_009.jpg"; t="TOP CORNER"; s="Unstoppable" },
  @{ f="football_3d_010.jpg"; t="LAST KICK"; s="Sudden Death" }
)
foreach ($item in $td) {
  Write-3dStill (Join-Path $root ("wallpapers\3d\" + $item.f)) $item.t $item.s (Seed-From $item.f)
}

Write-Host "Done unique assets."
