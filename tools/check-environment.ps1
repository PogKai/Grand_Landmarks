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
Test-Command "Blender" "blender"

$envFile = Join-Path $repoRoot ".env"
if (Test-Path -LiteralPath $envFile) {
    Write-Host "[OK]      Local .env exists" -ForegroundColor Green
}
else {
    Write-Host "[TODO]    Copy .env.example to .env and set KSP_ROOT" -ForegroundColor Yellow
}

