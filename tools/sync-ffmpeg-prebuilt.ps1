# Import FFmpeg build output into prebuilt/ffmpeg/ (optional one-time migration).
# Usage:
#   .\tools\sync-ffmpeg-prebuilt.ps1 -SourceRoot "D:\build\contrib\build"
param(
    [Parameter(Mandatory = $true)]
    [string]$SourceRoot
)

$ErrorActionPreference = "Stop"
$dstRoot = Join-Path $PSScriptRoot "..\prebuilt\ffmpeg"
New-Item -ItemType Directory -Force -Path $dstRoot | Out-Null

$map = @(
    @{ Src = "ffmpeg-arm64";   Dst = "arm64" },
    @{ Src = "ffmpeg-armv5";   Dst = "armv5" },
    @{ Src = "ffmpeg-armv7a";  Dst = "armv7a" },
    @{ Src = "ffmpeg-x86";     Dst = "x86" },
    @{ Src = "ffmpeg-x86_64";  Dst = "x86_64" }
)

foreach ($m in $map) {
    $from = Join-Path $SourceRoot "$($m.Src)\output"
    $to = Join-Path $dstRoot $m.Dst
    if (-not (Test-Path $from)) {
        Write-Warning "Skip $($m.Dst): missing $from"
        continue
    }
    if (Test-Path $to) { Remove-Item $to -Recurse -Force }
    robocopy $from $to /E /NFL /NDL /NJH /NJS /nc /ns /np | Out-Null
    if ($LASTEXITCODE -ge 8) { throw "robocopy failed for $($m.Dst) (exit $LASTEXITCODE)" }
    Write-Host "Synced $($m.Dst)"
}

# x86_64 output may be headers-only; reuse module libs if present.
$x64So = Join-Path $PSScriptRoot "..\ijkplayer-x86_64\src\main\libs\x86_64\libijkffmpeg.so"
$x64Prebuilt = Join-Path $dstRoot "x86_64\libijkffmpeg.so"
if (-not (Test-Path $x64Prebuilt) -and (Test-Path $x64So)) {
    Copy-Item $x64So $x64Prebuilt -Force
    Write-Host "Copied x86_64 libijkffmpeg.so from ijkplayer-x86_64 libs"
}

Write-Host "Done -> $dstRoot"
