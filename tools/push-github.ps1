# Push current repo to GitHub via HTTP proxy (does not change global git config).
param(
    [string]$Proxy = "http://127.0.0.1:1080",
    [string]$Remote = "origin",
    [string]$Branch = "main"
)

$ErrorActionPreference = "Stop"
$root = Split-Path -Parent $PSScriptRoot
Set-Location $root

$env:HTTP_PROXY = $Proxy
$env:HTTPS_PROXY = $Proxy

$gitArgs = @(
    "-c", "http.proxy=$Proxy",
    "-c", "https.proxy=$Proxy"
)

Write-Host "Pushing $Branch to $Remote (proxy $Proxy) ..."
& git @gitArgs push -u $Remote $Branch
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
Write-Host "Done: https://github.com/brainShake/ijkplayer-android"
