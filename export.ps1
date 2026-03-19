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

# Copy the whole folder into a named staging subfolder, then remove excluded items
if (Test-Path $TempDir) { Remove-Item -Recurse -Force $TempDir }
Copy-Item -Path $Source -Destination $StagingDir -Recurse

Remove-Item -Recurse -Force (Join-Path $StagingDir ".git") -ErrorAction SilentlyContinue
Remove-Item -Force (Join-Path $StagingDir "export.ps1") -ErrorAction SilentlyContinue

# Zip the named folder so the archive contains RessurectionSayings/ at the root
if (Test-Path $ZipPath) { Remove-Item -Force $ZipPath }
Compress-Archive -Path $StagingDir -DestinationPath $ZipPath

# Clean up
Remove-Item -Recurse -Force $TempDir

Write-Host "Export complete: $ZipPath"
