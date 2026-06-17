#Requires -Version 5.1
Add-Type -AssemblyName System.Drawing

$ROOT = Resolve-Path "$PSScriptRoot\.."
$STATES = @(
    @{Name='default'; Color=[System.Drawing.Color]::FromArgb(0xFF, 0x0D, 0x47, 0xA1); Label='Sage'}
    @{Name='sleeping'; Color=[System.Drawing.Color]::FromArgb(0xFF, 0x39, 0x4B, 0x6E); Label='Zzz'}
    @{Name='curious'; Color=[System.Drawing.Color]::FromArgb(0xFF, 0x5C, 0x8A, 0xC4); Label='?'}
    @{Name='annoyed'; Color=[System.Drawing.Color]::FromArgb(0xFF, 0xE6, 0x8A, 0x2E); Label='>'}
    @{Name='furious'; Color=[System.Drawing.Color]::FromArgb(0xFF, 0xD3, 0x2F, 0x2F); Label='!!'}
    @{Name='crying'; Color=[System.Drawing.Color]::FromArgb(0xFF, 0x6B, 0x8E, 0xB5); Label=':('}
    @{Name='frozen'; Color=[System.Drawing.Color]::FromArgb(0xFF, 0xA8, 0xD8, 0xEA); Label='ICE'}
    @{Name='onfire'; Color=[System.Drawing.Color]::FromArgb(0xFF, 0xFF, 0x6B, 0x35); Label='FIRE'}
    @{Name='golden'; Color=[System.Drawing.Color]::FromArgb(0xFF, 0xFF, 0xB3, 0x00); Label='GOLD'}
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

function New-IconBitmap {
    param([int]$Size, [System.Drawing.Color]$Color, [string]$Label)
    $bmp = New-Object System.Drawing.Bitmap($Size, $Size)
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
    $g.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::AntiAliasGridFit
    $brush = New-Object System.Drawing.SolidBrush($Color)
    $g.FillEllipse($brush, 0, 0, $Size-1, $Size-1)
    $brush.Dispose()
    $pen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(80, 0, 0, 0), [Math]::Max(1, $Size/48))
    $g.DrawEllipse($pen, 0, 0, $Size-1, $Size-1)
    $pen.Dispose()
    $fontSize = [Math]::Max(10, $Size * 0.4)
    $font = New-Object System.Drawing.Font('Segoe UI', $fontSize, [System.Drawing.FontStyle]::Bold)
    $fmt = New-Object System.Drawing.StringFormat
    $fmt.Alignment = [System.Drawing.StringAlignment]::Center
    $fmt.LineAlignment = [System.Drawing.StringAlignment]::Center
    $textBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::White)
    $g.DrawString($Label, $font, $textBrush, $Size/2, $Size/2, $fmt)
    $textBrush.Dispose()
    $font.Dispose()
    $fmt.Dispose()
    $g.Dispose()
    return $bmp
}

Write-Host '--- Android mipmap icons ---'
$resDir = "$ROOT\android\app\src\main\res"
foreach ($state in $STATES) {
    foreach ($sz in $ANDROID_SIZES) {
        $dir = Join-Path $resDir $sz.Dir
        $path = Join-Path $dir "ic_launcher_sage_$($state.Name).png"
        $bmp = New-IconBitmap -Size $sz.Size -Color $state.Color -Label $state.Label
        $bmp.Save($path, [System.Drawing.Imaging.ImageFormat]::Png)
        $bmp.Dispose()
    }
    Write-Host "  sage_$($state.Name) done"
}
Write-Host "Total: $($STATES.Count) states x $($ANDROID_SIZES.Count) densities = $($STATES.Count * $ANDROID_SIZES.Count) files"

Write-Host '--- iOS Runner icons ---'
$iosDir = "$ROOT\ios\Runner"
foreach ($state in $STATES) {
    foreach ($sz in $IOS_SIZES) {
        $path = Join-Path $iosDir "$($state.Name)$($sz.Suffix).png"
        $bmp = New-IconBitmap -Size $sz.Size -Color $state.Color -Label $state.Label
        $bmp.Save($path, [System.Drawing.Imaging.ImageFormat]::Png)
        $bmp.Dispose()
    }
    Write-Host "  sage_$($state.Name) done"
}
Write-Host "Total: $($STATES.Count) states x $($IOS_SIZES.Count) sizes = $($STATES.Count * $IOS_SIZES.Count) files"

$cnt = ($STATES.Count * $ANDROID_SIZES.Count) + ($STATES.Count * $IOS_SIZES.Count)
Write-Host "Done! $cnt placeholder icons generated. Replace with real Sage designs when ready." -ForegroundColor Green
