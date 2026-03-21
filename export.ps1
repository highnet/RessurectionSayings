# export.ps1
# Exports the addon folder as a zip with a proper root folder, excluding .git and export.ps1.
# Usage: .\export.ps1 [-Destination "C:\path\to\output"]

param(
    [string]$Destination = "$PSScriptRoot\.."
)

$Source    = $PSScriptRoot
$AddonName = Split-Path $Source -Leaf
$ZipPath   = Join-Path $Destination "$AddonName.zip"
$TempDir   = Join-Path $env:TEMP "RS_export_temp"
$StagingDir = Join-Path $TempDir $AddonName

# Copy into staging, excluding .git and export.ps1 from the start
if (Test-Path $TempDir) { Remove-Item -Recurse -Force $TempDir }
New-Item -ItemType Directory -Force -Path $StagingDir | Out-Null
robocopy $Source $StagingDir /E /XD ".git" /XF "export.ps1" | Out-Null

# Zip the named folder so the archive contains RessurectionSayings/ at the root
if (Test-Path $ZipPath) { Remove-Item -Force $ZipPath }
Compress-Archive -Path $StagingDir -DestinationPath $ZipPath

# Clean up
Remove-Item -Recurse -Force $TempDir

Write-Host "Export complete: $ZipPath"
