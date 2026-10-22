[CmdletBinding()]
param(
    [string]$Version = "0.1.0-dev"
)

$ErrorActionPreference = "Stop"
$repoRoot = Split-Path -Parent $PSScriptRoot
$source = Join-Path $repoRoot "GameData\SoysGrandLandmarks"
$buildRoot = Join-Path $repoRoot "build"
$stageGameData = Join-Path $buildRoot "GameData"
$stageMod = Join-Path $stageGameData "SoysGrandLandmarks"
$dist = Join-Path $repoRoot "dist"
$archive = Join-Path $dist "SoysGrandLandmarks-$Version.zip"

& (Join-Path $PSScriptRoot "validate.ps1")

if (Test-Path -LiteralPath $buildRoot) {
    Remove-Item -LiteralPath $buildRoot -Recurse -Force
}

New-Item -ItemType Directory -Path $stageGameData -Force | Out-Null
New-Item -ItemType Directory -Path $dist -Force | Out-Null
Copy-Item -LiteralPath $source -Destination $stageMod -Recurse
Get-ChildItem -LiteralPath $stageMod -Recurse -Filter ".gitkeep" -File |
    Remove-Item -Force

if (Test-Path -LiteralPath $archive) {
    Remove-Item -LiteralPath $archive -Force
}

Compress-Archive -Path $stageGameData -DestinationPath $archive -CompressionLevel Optimal
Write-Host "Built $archive"

