[CmdletBinding()]
param(
    [string]$BlenderVersion = "3.6.22"
)

$ErrorActionPreference = "Stop"
$ProgressPreference = "SilentlyContinue"
$repoRoot = Split-Path -Parent $PSScriptRoot
$localRoot = Join-Path $repoRoot "local"
$downloads = Join-Path $localRoot "downloads"
$toolsRoot = Join-Path $localRoot "tools"
$blenderRoot = Join-Path $toolsRoot "blender-$BlenderVersion"
$ckanRoot = Join-Path $toolsRoot "ckan"
$venvRoot = Join-Path $repoRoot ".venv"

New-Item -ItemType Directory -Force -Path $downloads, $toolsRoot, $ckanRoot | Out-Null

$blenderArchive = Join-Path $downloads "blender-$BlenderVersion-windows-x64.zip"
$blenderUrl = "https://download.blender.org/release/Blender3.6/blender-$BlenderVersion-windows-x64.zip"
if (-not (Test-Path -LiteralPath $blenderArchive)) {
    Write-Host "Downloading Blender $BlenderVersion..."
    Invoke-WebRequest -Uri $blenderUrl -OutFile $blenderArchive
}

if (-not (Test-Path -LiteralPath (Join-Path $blenderRoot "blender.exe"))) {
    $extractRoot = Join-Path $downloads "blender-extract"
    if (Test-Path -LiteralPath $extractRoot) {
        Remove-Item -LiteralPath $extractRoot -Recurse -Force
    }
    Expand-Archive -LiteralPath $blenderArchive -DestinationPath $extractRoot -Force
    $expanded = Get-ChildItem -LiteralPath $extractRoot -Directory | Select-Object -First 1
    Move-Item -LiteralPath $expanded.FullName -Destination $blenderRoot
    Remove-Item -LiteralPath $extractRoot -Recurse -Force
}

$addonArchive = Join-Path $downloads "io_object_mu-master.zip"
if (-not (Test-Path -LiteralPath $addonArchive)) {
    Write-Host "Downloading io_object_mu..."
    Invoke-WebRequest -Uri "https://github.com/taniwha/io_object_mu/archive/refs/heads/master.zip" -OutFile $addonArchive
}

$addonRoot = Join-Path $blenderRoot "$($BlenderVersion.Substring(0, 3))\scripts\addons\io_object_mu"
if (-not (Test-Path -LiteralPath (Join-Path $addonRoot "__init__.py"))) {
    $addonExtract = Join-Path $downloads "io-object-mu-extract"
    if (Test-Path -LiteralPath $addonExtract) {
        Remove-Item -LiteralPath $addonExtract -Recurse -Force
    }
    Expand-Archive -LiteralPath $addonArchive -DestinationPath $addonExtract -Force
    New-Item -ItemType Directory -Force -Path (Split-Path -Parent $addonRoot) | Out-Null
    Move-Item -LiteralPath (Join-Path $addonExtract "io_object_mu-master") -Destination $addonRoot
    Remove-Item -LiteralPath $addonExtract -Recurse -Force
}

$blenderExe = Join-Path $blenderRoot "blender.exe"
& $blenderExe --background --python-expr "import bpy; bpy.ops.preferences.addon_enable(module='io_object_mu'); bpy.ops.wm.save_userpref(); print('io_object_mu enabled')"
if ($LASTEXITCODE -ne 0) {
    throw "Blender could not enable io_object_mu."
}

$release = Invoke-RestMethod -Uri "https://api.github.com/repos/KSP-CKAN/CKAN/releases/latest" -Headers @{ "User-Agent" = "SoysGrandLandmarks-Setup" }
$ckanAsset = $release.assets | Where-Object { $_.name -eq "ckan-windows.exe" } | Select-Object -First 1
if (-not $ckanAsset) {
    throw "The latest CKAN release does not contain ckan-windows.exe."
}
$ckanExe = Join-Path $ckanRoot "ckan.exe"
if (-not (Test-Path -LiteralPath $ckanExe)) {
    Write-Host "Downloading CKAN $($release.tag_name)..."
    Invoke-WebRequest -Uri $ckanAsset.browser_download_url -OutFile $ckanExe -Headers @{ "User-Agent" = "SoysGrandLandmarks-Setup" }
}

if (-not (Test-Path -LiteralPath (Join-Path $venvRoot "Scripts\python.exe"))) {
    python -m venv $venvRoot
}
$venvPython = Join-Path $venvRoot "Scripts\python.exe"
& $venvPython -m pip install --upgrade pip
& $venvPython -m pip install -r (Join-Path $repoRoot "requirements-dev.txt")

Write-Host ""
Write-Host "Installed authoring tools:"
Write-Host "  Blender: $blenderExe"
Write-Host "  io_object_mu: $addonRoot"
Write-Host "  CKAN: $ckanExe"
Write-Host "  Python environment: $venvRoot"

