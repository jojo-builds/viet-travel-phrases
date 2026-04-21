Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Get-SpeakLocalWebsitePaths {
    $repoRoot = (Resolve-Path (Join-Path $PSScriptRoot '..\..')).Path
    $deploymentRoot = 'E:\AI\Shared\Deployments\speaklocal-site'

    return [pscustomobject]@{
        RepoRoot = $repoRoot
        ArtifactRoot = Join-Path $repoRoot 'site'
        DeploymentRoot = $deploymentRoot
        StagingRoot = Join-Path $deploymentRoot 'staging-current'
        LiveRoot = Join-Path $deploymentRoot 'live-current'
        BackupRoot = 'E:\AI\Shared\Backups\speaklocal-site'
        StagingUrl = 'http://speaklocal.app:8081/'
        StagingIpUrl = 'http://38.247.143.2:8081/'
        LiveUrl = 'https://speaklocal.app/'
        DeploymentManifestName = '__deployment.json'
        CaddyfilePath = 'C:\Users\Administrator\Caddyfile'
    }
}

function Assert-SpeakLocalManagedPath {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Path
    )

    $paths = Get-SpeakLocalWebsitePaths
    $resolved = [System.IO.Path]::GetFullPath($Path)
    $managedRoots = @(
        [System.IO.Path]::GetFullPath($paths.DeploymentRoot),
        [System.IO.Path]::GetFullPath($paths.BackupRoot)
    )

    foreach ($root in $managedRoots) {
        if ($resolved.StartsWith($root, [System.StringComparison]::OrdinalIgnoreCase)) {
            return
        }
    }

    throw "Refusing to modify unmanaged path: $resolved"
}

function Reset-SpeakLocalDirectory {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Path
    )

    Assert-SpeakLocalManagedPath -Path $Path

    if (Test-Path -LiteralPath $Path) {
        Remove-Item -LiteralPath $Path -Recurse -Force
    }

    New-Item -ItemType Directory -Path $Path -Force | Out-Null
}

function Copy-SpeakLocalDirectoryContents {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Source,
        [Parameter(Mandatory = $true)]
        [string]$Destination
    )

    if (-not (Test-Path -LiteralPath $Source -PathType Container)) {
        throw "Source directory does not exist: $Source"
    }

    Reset-SpeakLocalDirectory -Path $Destination

    foreach ($child in Get-ChildItem -LiteralPath $Source -Force) {
        Copy-Item -LiteralPath $child.FullName -Destination $Destination -Recurse -Force
    }
}

function Test-SpeakLocalDirectoryHasContent {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Path
    )

    if (-not (Test-Path -LiteralPath $Path -PathType Container)) {
        return $false
    }

    return [bool](Get-ChildItem -LiteralPath $Path -Force | Select-Object -First 1)
}

function Get-SpeakLocalGitValue {
    param(
        [Parameter(Mandatory = $true)]
        [string[]]$Arguments
    )

    $paths = Get-SpeakLocalWebsitePaths

    try {
        $value = (& git -C $paths.RepoRoot @Arguments 2>$null)
        if ($LASTEXITCODE -eq 0) {
            return ($value | Out-String).Trim()
        }
    } catch {
    }

    return $null
}

function New-SpeakLocalDeploymentManifest {
    param(
        [Parameter(Mandatory = $true)]
        [ValidateSet('staging', 'live')]
        [string]$Surface,
        [Parameter(Mandatory = $true)]
        [string]$SourceRoot,
        [string]$PromotedFromManifestPath
    )

    $paths = Get-SpeakLocalWebsitePaths
    $commit = Get-SpeakLocalGitValue -Arguments @('rev-parse', 'HEAD')
    $branch = Get-SpeakLocalGitValue -Arguments @('rev-parse', '--abbrev-ref', 'HEAD')
    $status = Get-SpeakLocalGitValue -Arguments @('status', '--short', '--untracked-files=normal', '--', 'site', 'docs', 'scripts')

    $manifest = [ordered]@{
        schemaVersion = 1
        surface = $Surface
        deployedAtUtc = (Get-Date).ToUniversalTime().ToString('o')
        repoRoot = $paths.RepoRoot
        sourceArtifactRoot = $SourceRoot
        commit = $commit
        branch = $branch
        hasUncommittedWebsiteChanges = [bool]$status
        workingTreeSummary = if ($status) { $status -split "`r?`n" } else { @() }
        stagingUrl = $paths.StagingUrl
        stagingIpUrl = $paths.StagingIpUrl
        liveUrl = $paths.LiveUrl
        reviewContract = 'Publish to staging first, review there, then promote the staged artifact to live.'
    }

    if ($PromotedFromManifestPath -and (Test-Path -LiteralPath $PromotedFromManifestPath)) {
        $manifest.promotedFrom = Get-Content -Raw -LiteralPath $PromotedFromManifestPath | ConvertFrom-Json
    }

    return $manifest
}

function Write-SpeakLocalDeploymentManifest {
    param(
        [Parameter(Mandatory = $true)]
        [string]$DestinationRoot,
        [Parameter(Mandatory = $true)]
        [ValidateSet('staging', 'live')]
        [string]$Surface,
        [Parameter(Mandatory = $true)]
        [string]$SourceRoot,
        [string]$PromotedFromManifestPath
    )

    $paths = Get-SpeakLocalWebsitePaths
    $manifestPath = Join-Path $DestinationRoot $paths.DeploymentManifestName
    $manifest = New-SpeakLocalDeploymentManifest -Surface $Surface -SourceRoot $SourceRoot -PromotedFromManifestPath $PromotedFromManifestPath
    ($manifest | ConvertTo-Json -Depth 8) + "`n" | Set-Content -LiteralPath $manifestPath -Encoding UTF8
    return $manifestPath
}

