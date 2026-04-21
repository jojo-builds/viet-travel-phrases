param(
    [switch]$SkipValidation
)

. "$PSScriptRoot\SpeakLocalWebsite.Common.ps1"

$paths = Get-SpeakLocalWebsitePaths

if (-not $SkipValidation) {
    & (Join-Path $PSScriptRoot 'Test-SpeakLocalWebsiteArtifact.ps1')
}

New-Item -ItemType Directory -Path $paths.DeploymentRoot -Force | Out-Null
Copy-SpeakLocalDirectoryContents -Source $paths.ArtifactRoot -Destination $paths.StagingRoot
$manifestPath = Write-SpeakLocalDeploymentManifest -DestinationRoot $paths.StagingRoot -Surface 'staging' -SourceRoot $paths.ArtifactRoot

Write-Host "Published staging artifact to $($paths.StagingRoot)"
Write-Host "Review staging at:"
Write-Host "- $($paths.StagingUrl)"
Write-Host "- $($paths.StagingIpUrl)"
Write-Host "Deployment manifest: $manifestPath"

