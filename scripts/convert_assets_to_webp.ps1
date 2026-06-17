param(
  [string]$AssetDir = "assets",
  [int]$Quality = 85,
  [switch]$DryRun
)

$tools = @()
if (Get-Command "magick" -ErrorAction SilentlyContinue) { $tools += "ImageMagick" }
if (Get-Command "cwebp" -ErrorAction SilentlyContinue) { $tools += "libwebp" }
if (Get-Command "ffmpeg" -ErrorAction SilentlyContinue) { $tools += "ffmpeg" }

if ($tools.Count -eq 0) {
  Write-Host "No conversion tool found. Install one of:" -ForegroundColor Yellow
  Write-Host "  - ImageMagick: winget install ImageMagick.ImageMagick" -ForegroundColor Cyan
  Write-Host "  - libwebp:     winget install libwebp" -ForegroundColor Cyan
  Write-Host "  - FFmpeg:       winget install FFmpeg" -ForegroundColor Cyan
  exit 1
}

$tool = $tools[0]
Write-Host "Using $tool to convert PNGs to WebP (Q=$Quality)" -ForegroundColor Green

$pngs = Get-ChildItem -Recurse -Filter "*.png" $AssetDir
$total = $pngs.Count
$converted = 0
$skipped = 0

foreach ($png in $pngs) {
  $webp = [System.IO.Path]::ChangeExtension($png.FullName, ".webp")

  if (Test-Path $webp) {
    $pngSize = (Get-Item $png.FullName).Length
    $webpSize = (Get-Item $webp).Length
    if ($webpSize -lt $pngSize) {
      $skipped++
      continue
    }
  }

  if ($DryRun) {
    Write-Host "[DRY RUN] Would convert: $($png.Name) → $([System.IO.Path]::GetFileName($webp))"
    $converted++
    continue
  }

  switch ($tool) {
    "ImageMagick" {
      & magick convert $png.FullName -quality $Quality $webp 2>&1 | Out-Null
    }
    "libwebp" {
      & cwebp -q $Quality $png.FullName -o $webp 2>&1 | Out-Null
    }
    "ffmpeg" {
      & ffmpeg -i $png.FullName -q:v $Quality $webp 2>&1 | Out-Null
    }
  }

  if ($LASTEXITCODE -eq 0 -and (Test-Path $webp)) {
    $origSize = (Get-Item $png.FullName).Length
    $newSize = (Get-Item $webp).Length
    $saved = [math]::Round(($origSize - $newSize) / $origSize * 100)
    Write-Host "  ✓ $($png.Name) → $([System.IO.Path]::GetFileName($webp)) (saved $saved%)" -ForegroundColor Green
    $converted++
  } else {
    Write-Host "  ✗ Failed: $($png.Name)" -ForegroundColor Red
  }
}

Write-Host "`nDone: $converted converted, $skipped already optimized (of $total)" -ForegroundColor Cyan
