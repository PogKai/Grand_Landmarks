[CmdletBinding()]
param(
    [string]$KspRoot,
    [string]$Version = "0.1.0-dev"
)

$ErrorActionPreference = "Stop"
$repoRoot = Split-Path -Parent $PSScriptRoot

if (-not $KspRoot) {
    $envFile = Join-Path $repoRoot ".env"
    if (Test-Path -LiteralPath $envFile) {
        $setting = Get-Content -LiteralPath $envFile |
            Where-Object { $_ -match '^KSP_ROOT=' } |
            Select-Object -First 1
        if ($setting) {
            $KspRoot = $setting.Substring("KSP_ROOT=".Length).Trim()
        }
    }
}

if (-not $KspRoot -or -not (Test-Path -LiteralPath (Join-Path $KspRoot "KSP_x64.exe"))) {
    throw "KSP_ROOT must identify a valid KSP installation. Pass -KspRoot or configure .env."
}

& (Join-Path $PSScriptRoot "build.ps1") -Version $Version

$source = Join-Path $repoRoot "build\GameData\SoysGrandLandmarks"
$target = Join-Path $KspRoot "GameData\SoysGrandLandmarks"
New-Item -ItemType Directory -Force -Path $target | Out-Null
Copy-Item -Path (Join-Path $source "*") -Destination $target -Recurse -Force
Get-ChildItem -LiteralPath $target -Filter ".gitkeep" -Recurse -File -ErrorAction SilentlyContinue |
    Remove-Item -Force

Write-Host "Deployed Soy's Grand Landmarks to $target"

