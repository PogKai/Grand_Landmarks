[CmdletBinding()]
param()

$ErrorActionPreference = "Stop"
$repoRoot = Split-Path -Parent $PSScriptRoot
$modRoot = Join-Path $repoRoot "GameData\SoysGrandLandmarks"
$required = @(
    "Configs",
    "Models",
    "PluginData",
    "Textures",
    "SoysGrandLandmarks.version"
)

if (-not (Test-Path -LiteralPath $modRoot -PathType Container)) {
    throw "Missing runtime mod folder: $modRoot"
}

foreach ($relativePath in $required) {
    $path = Join-Path $modRoot $relativePath
    if (-not (Test-Path -LiteralPath $path)) {
        throw "Missing required runtime path: $path"
    }
}

$versionFile = Join-Path $modRoot "SoysGrandLandmarks.version"
Get-Content -LiteralPath $versionFile -Raw | ConvertFrom-Json | Out-Null

$forbidden = Get-ChildItem -LiteralPath (Join-Path $repoRoot "GameData") -Recurse -File |
    Where-Object { $_.Extension -in @(".dll", ".log") }
if ($forbidden) {
    throw "GameData contains dependency binaries or logs that should not be committed: $($forbidden.FullName -join ', ')"
}

Write-Host "Repository structure is valid."

