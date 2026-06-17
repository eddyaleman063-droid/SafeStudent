#Requires -Version 5.1
Add-Type -AssemblyName System.Drawing

$ROOT = Resolve-Path "$PSScriptRoot\.."

# ── 9 states config ──────────────────────────────────────────────
$STATES = @(
    @{Name='default';  Grad=@(@(0x0D,0x57,0xC1),@(0x0A,0x37,0x81)); Sym='S'}
    @{Name='sleeping'; Grad=@(@(0x39,0x4B,0x6E),@(0x1A,0x2B,0x4A)); Sym='Zzz'}
    @{Name='curious';  Grad=@(@(0x5C,0x8A,0xC4),@(0x3A,0x68,0xA2)); Sym='?'}
    @{Name='annoyed';  Grad=@(@(0xF0,0x9C,0x3E),@(0xC4,0x7A,0x1E)); Sym='!'}
    @{Name='furious';  Grad=@(@(0xD3,0x2F,0x2F),@(0x9A,0x1A,0x1A)); Sym='!!'}
    @{Name='crying';   Grad=@(@(0x6B,0x8E,0xB5),@(0x4A,0x68,0x8A)); Sym=':('}
    @{Name='frozen';   Grad=@(@(0xA8,0xD8,0xEA),@(0x7B,0xB8,0xD0)); Sym='ICE'}
    @{Name='onfire';   Grad=@(@(0xFF,0x6B,0x35),@(0xD4,0x4A,0x1A)); Sym='FIRE'}
    @{Name='golden';   Grad=@(@(0xFF,0xB3,0x00),@(0xCC,0x80,0x00)); Sym='GOLD'}
)

$ANDROID_SIZES = @(
    @{Dir='mipmap-mdpi';    Size=48}
    @{Dir='mipmap-hdpi';    Size=72}
    @{Dir='mipmap-xhdpi';   Size=96}
    @{Dir='mipmap-xxhdpi';  Size=144}
    @{Dir='mipmap-xxxhdpi'; Size=192}
)

$IOS_SIZES = @(
    @{Suffix='@2x'; Size=120}
    @{Suffix='@3x'; Size=180}
)

function New-Icon {
    param([string]$name, $r1, $g1, $b1, $r2, $g2, $b2, [string]$sym, $sz, [string]$sfx)
    $S = $sz
    $cr = [Math]::Max(4, $S * 0.22)
    $fs = $S * 0.42
    $bmp = New-Object System.Drawing.Bitmap($S, $S)
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $g.SmoothingMode = 'HighQuality'
    $p = New-Object System.Drawing.Drawing2D.GraphicsPath
    $p.StartFigure()
    $p.AddArc($S-$cr-1, 0, $cr, $cr, 270, 90)
    $p.AddArc($S-$cr-1, $S-$cr-1, $cr, $cr, 0, 90)
    $p.AddArc(0, $S-$cr-1, $cr, $cr, 90, 90)
    $p.AddArc(0, 0, $cr, $cr, 180, 90)
    $p.CloseFigure()
    $pb = New-Object System.Drawing.Drawing2D.PathGradientBrush($p)
    $pb.CenterPoint = [System.Drawing.PointF]::new($S*0.35, $S*0.35)
    $pb.CenterColor = [System.Drawing.Color]::FromArgb(0xFF, $r1, $g1, $b1)
    $pb.SurroundColors = @([System.Drawing.Color]::FromArgb(0xFF, $r2, $g2, $b2))
    $g.FillPath($pb, $p)
    $pb.Dispose()
    $font = New-Object System.Drawing.Font('Segoe UI', $fs, [System.Drawing.FontStyle]::Bold)
    $fm = New-Object System.Drawing.StringFormat
    $fm.Alignment = 'Center'
    $fm.LineAlignment = 'Center'
    $tb = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::White)
    $g.DrawString($sym, $font, $tb, $S/2, $S/2, $fm)
    $tb.Dispose()
    $font.Dispose()
    $fm.Dispose()
    $p.Dispose()
    $g.Dispose()
    $ms = New-Object System.IO.MemoryStream
    $bmp.Save($ms, [System.Drawing.Imaging.ImageFormat]::Png)
    $bmp.Dispose()
    [System.IO.File]::WriteAllBytes($sfx, $ms.ToArray())
    $ms.Dispose()
}

# ── Generate Android ────────────────────────────────────────────
Write-Host '--- Android ---'
$resDir = "$ROOT\android\app\src\main\res"
foreach ($st in $STATES) {
    foreach ($sz in $ANDROID_SIZES) {
        $dir = Join-Path $resDir $sz.Dir
        $out = Join-Path $dir "ic_launcher_sage_$($st.Name).png"
        $g1 = $st.Grad[0]; $g2 = $st.Grad[1]
        New-Icon $st.Name $g1[0] $g1[1] $g1[2] $g2[0] $g2[1] $g2[2] $st.Sym $sz.Size $out
    }
    Write-Host "  $($st.Name)"
}

# ── Generate iOS ────────────────────────────────────────────────
Write-Host '--- iOS ---'
$iosDir = "$ROOT\ios\Runner"
foreach ($st in $STATES) {
    foreach ($sz in $IOS_SIZES) {
        $out = Join-Path $iosDir "$($st.Name)$($sz.Suffix).png"
        $g1 = $st.Grad[0]; $g2 = $st.Grad[1]
        New-Icon $st.Name $g1[0] $g1[1] $g1[2] $g2[0] $g2[1] $g2[2] $st.Sym $sz.Size $out
    }
    Write-Host "  $($st.Name)"
}

$cnt = $STATES.Count * ($ANDROID_SIZES.Count + $IOS_SIZES.Count)
Write-Host "Done! $cnt icons generated with gradient design." -ForegroundColor Green
Write-Host "Replace with real Sage character designs when ready." -ForegroundColor Yellow
