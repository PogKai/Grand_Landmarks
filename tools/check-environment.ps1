[CmdletBinding()]
param()

$ErrorActionPreference = "Continue"
$repoRoot = Split-Path -Parent $PSScriptRoot

function Test-Command {
    param([string]$Name, [string]$Command)
    $found = Get-Command $Command -ErrorAction SilentlyContinue
    if ($found) {
        Write-Host "[OK]      $Name - $($found.Source)" -ForegroundColor Green
    }
    else {
        Write-Host "[MISSING] $Name" -ForegroundColor Yellow
    }
}

Test-Command "Git" "git"
Test-Command "Git LFS" "git-lfs"
Test-Command "Python" "python"
Test-Command "PowerShell 7" "pwsh"

$portableBlender = Get-ChildItem -LiteralPath (Join-Path $repoRoot "local\tools") -Filter "blender.exe" -Recurse -ErrorAction SilentlyContinue |
    Select-Object -First 1
if ($portableBlender) {
    Write-Host "[OK]      Portable Blender - $($portableBlender.FullName)" -ForegroundColor Green
}
else {
    Test-Command "Blender" "blender"
}

$localCkan = Join-Path $repoRoot "local\tools\ckan\ckan.exe"
if (Test-Path -LiteralPath $localCkan) {
    Write-Host "[OK]      CKAN - $localCkan" -ForegroundColor Green
}

$venvPython = Join-Path $repoRoot ".venv\Scripts\python.exe"
if (Test-Path -LiteralPath $venvPython) {
    Write-Host "[OK]      Project Python environment - $venvPython" -ForegroundColor Green
}

$envFile = Join-Path $repoRoot ".env"
if (Test-Path -LiteralPath $envFile) {
    Write-Host "[OK]      Local .env exists" -ForegroundColor Green
    $setting = Get-Content -LiteralPath $envFile |
        Where-Object { $_ -match '^KSP_ROOT=' } |
        Select-Object -First 1
    $kspRoot = if ($setting) { $setting.Substring("KSP_ROOT=".Length).Trim() } else { $null }
    if ($kspRoot -and (Test-Path -LiteralPath (Join-Path $kspRoot "KSP_x64.exe"))) {
        Write-Host "[OK]      KSP test installation - $kspRoot" -ForegroundColor Green
    }
    else {
        Write-Host "[INVALID] KSP_ROOT does not identify a KSP installation" -ForegroundColor Red
    }
}
else {
    Write-Host "[TODO]    Copy .env.example to .env and set KSP_ROOT" -ForegroundColor Yellow
}

