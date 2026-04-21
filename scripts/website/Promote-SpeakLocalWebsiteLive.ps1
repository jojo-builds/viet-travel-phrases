param(
    [switch]$SkipValidation
)

. "$PSScriptRoot\SpeakLocalWebsite.Common.ps1"

$paths = Get-SpeakLocalWebsitePaths
$stagingManifestPath = Join-Path $paths.StagingRoot $paths.DeploymentManifestName

if (-not (Test-Path -LiteralPath $paths.StagingRoot -PathType Container)) {
    throw "Staging deployment root does not exist: $($paths.StagingRoot)"
}

if (-not (Test-SpeakLocalDirectoryHasContent -Path $paths.StagingRoot)) {
    throw "Staging deployment root is empty: $($paths.StagingRoot)"
}

if (-not (Test-Path -LiteralPath $stagingManifestPath -PathType Leaf)) {
    throw "Staging deployment manifest is missing: $stagingManifestPath"
}

if (-not $SkipValidation) {
    & (Join-Path $PSScriptRoot 'Test-SpeakLocalWebsiteArtifact.ps1')
}

$backupDir = $null
if (Test-SpeakLocalDirectoryHasContent -Path $paths.LiveRoot) {
    $timestamp = Get-Date -Format 'yyyy-MM-ddTHH-mm-ssZ'
    $backupDir = Join-Path $paths.BackupRoot $timestamp
    Copy-SpeakLocalDirectoryContents -Source $paths.LiveRoot -Destination $backupDir
}

New-Item -ItemType Directory -Path $paths.DeploymentRoot -Force | Out-Null
Copy-SpeakLocalDirectoryContents -Source $paths.StagingRoot -Destination $paths.LiveRoot
$manifestPath = Write-SpeakLocalDeploymentManifest -DestinationRoot $paths.LiveRoot -Surface 'live' -SourceRoot $paths.StagingRoot -PromotedFromManifestPath $stagingManifestPath

Write-Host "Promoted staged artifact to live deployment root $($paths.LiveRoot)"
Write-Host "Live URL: $($paths.LiveUrl)"
if ($backupDir) {
    Write-Host "Previous live backup: $backupDir"
}
Write-Host "Deployment manifest: $manifestPath"

