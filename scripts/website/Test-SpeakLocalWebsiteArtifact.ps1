. "$PSScriptRoot\SpeakLocalWebsite.Common.ps1"

function Normalize-SpeakLocalText {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Text
    )

    return ($Text -replace "`r`n", "`n").Trim()
}

function ConvertTo-SpeakLocalJson {
    param(
        [Parameter(Mandatory = $true)]
        $Value
    )

    return ($Value | ConvertTo-Json -Depth 100 -Compress)
}

function Assert-SpeakLocalFileParity {
    param(
        [Parameter(Mandatory = $true)]
        [string]$LeftPath,
        [Parameter(Mandatory = $true)]
        [string]$RightPath
    )

    if (-not (Test-Path -LiteralPath $LeftPath -PathType Leaf)) {
        throw "Missing route-pair file: $LeftPath"
    }

    if (-not (Test-Path -LiteralPath $RightPath -PathType Leaf)) {
        throw "Missing route-pair file: $RightPath"
    }

    $left = Normalize-SpeakLocalText -Text (Get-Content -Raw -LiteralPath $LeftPath)
    $right = Normalize-SpeakLocalText -Text (Get-Content -Raw -LiteralPath $RightPath)

    if ($left -ne $right) {
        throw "Route-pair drift detected between:`n- $LeftPath`n- $RightPath"
    }
}

function Resolve-SpeakLocalUrlTargets {
    param(
        [Parameter(Mandatory = $true)]
        [string]$SiteRoot,
        [Parameter(Mandatory = $true)]
        [string]$DocumentPath,
        [Parameter(Mandatory = $true)]
        [string]$Url
    )

    $normalized = ($Url -split '[?#]', 2)[0]
    if ([string]::IsNullOrWhiteSpace($normalized)) {
        return @()
    }

    if ($normalized.StartsWith('/')) {
        $relative = $normalized.TrimStart('/').Replace('/', [System.IO.Path]::DirectorySeparatorChar)
        $basePath = if ($relative) { Join-Path $SiteRoot $relative } else { $SiteRoot }
    } else {
        $relative = $normalized.Replace('/', [System.IO.Path]::DirectorySeparatorChar)
        $basePath = [System.IO.Path]::GetFullPath((Join-Path (Split-Path $DocumentPath -Parent) $relative))
        $siteRootFull = [System.IO.Path]::GetFullPath($SiteRoot)
        if (-not $basePath.StartsWith($siteRootFull, [System.StringComparison]::OrdinalIgnoreCase)) {
            throw "Relative URL escapes site root in $DocumentPath : $Url"
        }
    }

    $targets = New-Object System.Collections.Generic.List[string]
    if ([System.IO.Path]::HasExtension($basePath)) {
        $targets.Add($basePath) | Out-Null
    } else {
        $targets.Add($basePath) | Out-Null
        $targets.Add("$basePath.html") | Out-Null
        $targets.Add((Join-Path $basePath 'index.html')) | Out-Null
    }

    return $targets | Select-Object -Unique
}

function Test-SpeakLocalRoutePairs {
    $paths = Get-SpeakLocalWebsitePaths
    $siteRoot = $paths.ArtifactRoot

    $indexPages = Get-ChildItem -LiteralPath $siteRoot -Recurse -Filter index.html -File |
        Where-Object { $_.DirectoryName -ne $siteRoot }

    foreach ($indexPage in $indexPages) {
        $pageDir = Split-Path $indexPage.FullName -Parent
        $pageName = Split-Path $pageDir -Leaf
        $flatPage = Join-Path (Split-Path $pageDir -Parent) "$pageName.html"
        if (Test-Path -LiteralPath $flatPage -PathType Leaf) {
            Assert-SpeakLocalFileParity -LeftPath $indexPage.FullName -RightPath $flatPage
        }
    }

    $flatPages = Get-ChildItem -LiteralPath $siteRoot -Recurse -Filter *.html -File |
        Where-Object {
            $_.Name -notin @('index.html', '404.html')
        }

    foreach ($flatPage in $flatPages) {
        $pairedIndex = Join-Path (Join-Path (Split-Path $flatPage.FullName -Parent) ([System.IO.Path]::GetFileNameWithoutExtension($flatPage.Name))) 'index.html'
        if (Test-Path -LiteralPath $pairedIndex -PathType Leaf) {
            Assert-SpeakLocalFileParity -LeftPath $flatPage.FullName -RightPath $pairedIndex
        }
    }

    Write-Host "Route-pair parity passed."
}

function Test-SpeakLocalInternalLinks {
    $paths = Get-SpeakLocalWebsitePaths
    $siteRoot = $paths.ArtifactRoot
    $htmlFiles = Get-ChildItem -LiteralPath $siteRoot -Recurse -Filter *.html -File
    $linkPattern = '(?i)(?:href|src)\s*=\s*["'']([^"'']+)["'']'

    foreach ($htmlFile in $htmlFiles) {
        $body = Get-Content -Raw -LiteralPath $htmlFile.FullName
        $matches = [System.Text.RegularExpressions.Regex]::Matches($body, $linkPattern)

        foreach ($match in $matches) {
            $target = $match.Groups[1].Value.Trim()

            if ([string]::IsNullOrWhiteSpace($target)) { continue }
            if ($target.StartsWith('#')) { continue }
            if ($target -match '^(?i)(https?:|mailto:|tel:|javascript:|data:|//)') { continue }

            $candidatePaths = @(Resolve-SpeakLocalUrlTargets -SiteRoot $siteRoot -DocumentPath $htmlFile.FullName -Url $target)
            if (-not $candidatePaths.Count) {
                throw "Could not resolve internal URL in $($htmlFile.FullName) : $target"
            }

            $resolved = $false
            foreach ($candidatePath in $candidatePaths) {
                if (Test-Path -LiteralPath $candidatePath) {
                    $resolved = $true
                    break
                }
            }

            if (-not $resolved) {
                throw "Broken internal URL in $($htmlFile.FullName) : $target"
            }
        }
    }

    Write-Host "Internal link integrity passed."
}

function Test-SpeakLocalPreviewParity {
    $paths = Get-SpeakLocalWebsitePaths
    $siteDataDir = Join-Path $paths.ArtifactRoot 'data\phrase-previews'
    $publicDataDir = Join-Path $paths.ArtifactRoot 'public\data\phrase-previews'

    foreach ($dataDir in @($siteDataDir, $publicDataDir)) {
        if (-not (Test-Path -LiteralPath $dataDir -PathType Container)) {
            throw "Preview data directory missing: $dataDir"
        }
    }

    $siteFiles = Get-ChildItem -LiteralPath $siteDataDir -File | Sort-Object Name
    $publicFiles = Get-ChildItem -LiteralPath $publicDataDir -File | Sort-Object Name

    $siteNames = @($siteFiles.Name)
    $publicNames = @($publicFiles.Name)

    if ((Compare-Object -ReferenceObject $siteNames -DifferenceObject $publicNames)) {
        throw "Preview JSON file lists differ between site/data and site/public/data."
    }

    foreach ($fileName in $siteNames) {
        $siteContent = Normalize-SpeakLocalText -Text (Get-Content -Raw -LiteralPath (Join-Path $siteDataDir $fileName))
        $publicContent = Normalize-SpeakLocalText -Text (Get-Content -Raw -LiteralPath (Join-Path $publicDataDir $fileName))

        if ($siteContent -ne $publicContent) {
            throw "Preview JSON drift detected for $fileName between direct-serve and public copies."
        }
    }

    $manifest = Get-Content -Raw -LiteralPath (Join-Path $siteDataDir 'manifest.json') | ConvertFrom-Json
    if ($manifest.schemaVersion -lt 3) {
        throw "Preview manifest schemaVersion must be at least 3 for the current website-safe phrase/audio seam."
    }

    if ($manifest.exportType -ne 'website-phrase-audio-manifest') {
        throw "Preview manifest exportType is missing or unexpected."
    }

    $manifestModuleIds = @($manifest.modules | ForEach-Object { $_.moduleId })
    $manifestPaths = @($manifest.modules | ForEach-Object { $_.path })
    $actualModuleIds = @($siteFiles | Where-Object { $_.Name -ne 'manifest.json' } | ForEach-Object { [System.IO.Path]::GetFileNameWithoutExtension($_.Name) })

    if ((Compare-Object -ReferenceObject ($manifestModuleIds | Sort-Object) -DifferenceObject ($actualModuleIds | Sort-Object))) {
        throw "Preview manifest module IDs do not match the exported JSON files."
    }

    foreach ($moduleId in $manifestModuleIds) {
        $expectedPath = "/data/phrase-previews/$moduleId.json"
        if ($manifestPaths -notcontains $expectedPath) {
            throw "Preview manifest is missing expected path entry: $expectedPath"
        }
    }

    $vietConfigPath = Join-Path $paths.RepoRoot 'content-draft\viet\website-preview.json'
    if (-not (Test-Path -LiteralPath $vietConfigPath -PathType Leaf)) {
        throw "Vietnam website preview config is missing: $vietConfigPath"
    }

    $vietConfig = Get-Content -Raw -LiteralPath $vietConfigPath | ConvertFrom-Json
    $expectedModulePairs = @($vietConfig.modules | ForEach-Object { '{0}|{1}' -f $_.moduleId, $_.scenarioId } | Sort-Object)
    $actualModulePairs = @($manifest.modules | ForEach-Object { '{0}|{1}' -f $_.moduleId, $_.scenarioId } | Sort-Object)

    if (@($manifest.modules).Count -ne @($vietConfig.modules).Count) {
        throw "Preview manifest module count does not match content-draft/viet/website-preview.json."
    }

    if ((Compare-Object -ReferenceObject $expectedModulePairs -DifferenceObject $actualModulePairs)) {
        throw "Preview manifest module/scenario pairs do not match content-draft/viet/website-preview.json."
    }

    if ([int]$manifest.moduleCount -ne @($manifest.modules).Count) {
        throw "Preview manifest moduleCount does not match the manifest modules array."
    }

    $docPath = Join-Path $paths.RepoRoot 'docs\website\PHRASE_AUDIO_DELIVERY.md'
    if (-not (Test-Path -LiteralPath $docPath -PathType Leaf)) {
        throw "Website delivery doc is missing: $docPath"
    }

    $docContent = Get-Content -Raw -LiteralPath $docPath
    $docContractStartMarker = '<!-- canonical-vietnam-surface-contract:start -->'
    $docContractEndMarker = '<!-- canonical-vietnam-surface-contract:end -->'
    $docContractStartIndex = $docContent.IndexOf($docContractStartMarker)
    $docContractEndIndex = $docContent.IndexOf($docContractEndMarker)

    if ($docContractStartIndex -lt 0 -or $docContractEndIndex -lt 0 -or $docContractEndIndex -le $docContractStartIndex) {
        throw "Website delivery doc is missing the canonical Vietnam surface contract block."
    }

    $docContractSectionStart = $docContractStartIndex + $docContractStartMarker.Length
    $docContractSection = $docContent.Substring($docContractSectionStart, $docContractEndIndex - $docContractSectionStart)
    $docSurfaceContractMatch = [System.Text.RegularExpressions.Regex]::Match($docContractSection, '(?s)```json\s*(\{.*?\})\s*```')
    if (-not $docSurfaceContractMatch.Success) {
        throw "Website delivery doc canonical Vietnam surface contract block is not valid fenced JSON."
    }

    $docSurfaceContract = $docSurfaceContractMatch.Groups[1].Value | ConvertFrom-Json
    $expectedHubModuleOrder = @($docSurfaceContract.approvedHubModuleOrder)
    $expectedOffHubModuleIds = @($docSurfaceContract.approvedOffHubModuleIds)

    if (-not $manifest.surfaceContract) {
        throw "Preview manifest surfaceContract is missing."
    }

    if ([int]$manifest.surfaceContract.version -lt 1) {
        throw "Preview manifest surfaceContract.version must be at least 1."
    }

    if ([int]$manifest.surfaceContract.version -ne [int]$docSurfaceContract.version) {
        throw "Preview manifest surfaceContract.version drifted from the canonical website delivery doc contract."
    }

    if ($manifest.surfaceContract.destinationSlug -ne $docSurfaceContract.destinationSlug) {
        throw "Preview manifest surfaceContract.destinationSlug drifted from the canonical website delivery doc contract."
    }

    if ([int]$manifest.moduleCount -ne [int]$docSurfaceContract.moduleCount) {
        throw "Preview manifest moduleCount drifted from the canonical website delivery doc contract."
    }

    if ([int]$manifest.surfaceContract.starterModuleCount -ne @($manifest.modules).Count) {
        throw "Preview manifest surfaceContract.starterModuleCount must match the manifest module count."
    }

    if ([int]$manifest.surfaceContract.starterModuleCount -ne [int]$docSurfaceContract.moduleCount) {
        throw "Preview manifest surfaceContract.starterModuleCount drifted from the canonical website delivery doc contract."
    }

    if ([int]$manifest.surfaceContract.hubModuleCount -ne [int]$docSurfaceContract.hubModuleCount) {
        throw "Preview manifest surfaceContract.hubModuleCount drifted from the canonical website delivery doc contract."
    }

    if ([int]$manifest.surfaceContract.offHubModuleCount -ne [int]$docSurfaceContract.offHubModuleCount) {
        throw "Preview manifest surfaceContract.offHubModuleCount drifted from the canonical website delivery doc contract."
    }

    $actualHubModuleOrder = @($manifest.surfaceContract.approvedHubModuleOrder)
    $actualOffHubModuleIds = @($manifest.surfaceContract.approvedOffHubModuleIds)
    $allSurfaceModuleIds = @($actualHubModuleOrder + $actualOffHubModuleIds)
    $distinctSurfaceModuleIds = @($allSurfaceModuleIds | Sort-Object -Unique)

    if ($distinctSurfaceModuleIds.Count -ne $allSurfaceModuleIds.Count) {
        throw "Preview manifest surfaceContract lists duplicate module ids across the hub/off-hub contract."
    }

    if ((Compare-Object -ReferenceObject $expectedHubModuleOrder -DifferenceObject $actualHubModuleOrder)) {
        throw "Preview manifest approvedHubModuleOrder drifted from the approved Vietnam hub subset."
    }

    if ((Compare-Object -ReferenceObject ($expectedOffHubModuleIds | Sort-Object) -DifferenceObject ($actualOffHubModuleIds | Sort-Object))) {
        throw "Preview manifest approvedOffHubModuleIds drifted from the approved Vietnam off-hub starter modules."
    }

    $expectedSurfaceModuleIds = @($expectedHubModuleOrder + $expectedOffHubModuleIds | Sort-Object)
    $actualSurfaceModuleIds = @($distinctSurfaceModuleIds | Sort-Object)

    if ((Compare-Object -ReferenceObject $expectedSurfaceModuleIds -DifferenceObject $actualSurfaceModuleIds)) {
        throw "Preview manifest surfaceContract does not resolve to the approved 7-module Vietnam export surface."
    }

    foreach ($moduleEntry in @($manifest.modules)) {
        foreach ($propertyName in @('moduleId', 'path', 'destinationSlug', 'scenarioId', 'scenarioName', 'headline', 'phraseCount', 'familyCount', 'articleUrl', 'surfacePlacement')) {
            if (-not $moduleEntry.$propertyName) {
                throw "Preview manifest entry is missing required property '$propertyName'."
            }
        }

        $expectedSurfacePlacement = if ($expectedHubModuleOrder -contains $moduleEntry.moduleId) {
            'country-hub'
        } elseif ($expectedOffHubModuleIds -contains $moduleEntry.moduleId) {
            'off-hub'
        } else {
            throw "Preview manifest module $($moduleEntry.moduleId) is not listed in the approved Vietnam surface contract."
        }

        if ($moduleEntry.surfacePlacement -ne $expectedSurfacePlacement) {
            throw "Preview manifest module $($moduleEntry.moduleId) surfacePlacement drifted from the approved Vietnam surface contract."
        }

        $modulePath = Join-Path $paths.ArtifactRoot ($moduleEntry.path.TrimStart('/').Replace('/', '\'))
        if (-not (Test-Path -LiteralPath $modulePath -PathType Leaf)) {
            throw "Preview manifest path does not resolve to a file: $($moduleEntry.path)"
        }

        $module = Get-Content -Raw -LiteralPath $modulePath | ConvertFrom-Json
        if ($module.schemaVersion -lt 3) {
            throw "Preview module $($moduleEntry.moduleId) schemaVersion must be at least 3."
        }

        if ($module.exportType -ne 'website-phrase-audio-module') {
            throw "Preview module $($moduleEntry.moduleId) exportType is missing or unexpected."
        }

        if ($module.moduleId -ne $moduleEntry.moduleId) {
            throw "Preview module $($moduleEntry.moduleId) does not match its manifest entry."
        }

        if (@($module.phrases).Count -ne [int]$module.phraseCount) {
            throw "Preview module $($moduleEntry.moduleId) phraseCount does not match its phrases array."
        }

        if ([int]$module.familyCount -ne [int]$moduleEntry.familyCount) {
            throw "Preview module $($moduleEntry.moduleId) familyCount does not match its manifest entry."
        }

        if (-not $module.articleReference.secondaryUrl) {
            throw "Preview module $($moduleEntry.moduleId) is missing articleReference.secondaryUrl."
        }

        if (-not $module.cta.secondaryUrl) {
            throw "Preview module $($moduleEntry.moduleId) is missing cta.secondaryUrl."
        }

        if ($module.articleReference.secondaryUrl -ne $moduleEntry.articleUrl) {
            throw "Preview module $($moduleEntry.moduleId) articleReference.secondaryUrl does not match its manifest articleUrl."
        }

        if ($module.cta.secondaryUrl -ne $moduleEntry.articleUrl) {
            throw "Preview module $($moduleEntry.moduleId) cta.secondaryUrl does not match its manifest articleUrl."
        }

        foreach ($propertyName in @('travelerStage', 'difficulty', 'formality')) {
            $value = $module.$propertyName
            if ($null -ne $value -and [string]::IsNullOrWhiteSpace([string]$value)) {
                throw "Preview module $($moduleEntry.moduleId) has blank optional metadata '$propertyName'."
            }
        }

        if ($null -ne $module.audioDurationMs -and ([int]$module.audioDurationMs -lt 0)) {
            throw "Preview module $($moduleEntry.moduleId) has invalid audioDurationMs metadata."
        }

        if ($null -ne $module.transcriptChecked -and $module.transcriptChecked -isnot [bool]) {
            throw "Preview module $($moduleEntry.moduleId) has invalid transcriptChecked metadata."
        }

        if ([int]$module.audioCoverage.totalPhraseCount -ne @($module.phrases).Count) {
            throw "Preview module $($moduleEntry.moduleId) audio coverage totals do not match its phrases array."
        }

        foreach ($phrase in @($module.phrases)) {
            foreach ($propertyName in @('phraseId', 'moduleId', 'familyId', 'familyTitle', 'englishText', 'targetText', 'pronunciation', 'audioStatus')) {
                if (-not $phrase.$propertyName) {
                    throw "Preview module $($moduleEntry.moduleId) contains a phrase missing required property '$propertyName'."
                }
            }

            if ($phrase.moduleId -ne $module.moduleId) {
                throw "Preview module $($moduleEntry.moduleId) contains a phrase with the wrong moduleId."
            }

            if ($phrase.accessTier -ne 'starter') {
                throw "Preview module $($moduleEntry.moduleId) exports non-starter phrase $($phrase.phraseId) into the website preview seam."
            }

            if (-not $phrase.websiteReferences) {
                throw "Preview module $($moduleEntry.moduleId) phrase $($phrase.phraseId) is missing websiteReferences."
            }

            if ($phrase.websiteReferences.moduleId -ne $module.moduleId) {
                throw "Preview module $($moduleEntry.moduleId) phrase $($phrase.phraseId) websiteReferences.moduleId drifted from its moduleId."
            }

            if ($phrase.websiteReferences.articleUrl -ne $moduleEntry.articleUrl) {
                throw "Preview module $($moduleEntry.moduleId) phrase $($phrase.phraseId) websiteReferences.articleUrl does not match the manifest articleUrl."
            }

            if ($phrase.audioStatus -eq 'ready') {
                if (-not $phrase.audioUrl) {
                    throw "Preview module $($moduleEntry.moduleId) marks phrase $($phrase.phraseId) as ready without an audioUrl."
                }

                if ($phrase.audioUrl -notmatch '^/data/phrase-audio/') {
                    throw "Preview module $($moduleEntry.moduleId) exports ready phrase $($phrase.phraseId) outside the site-owned audio path."
                }

                $audioTargets = @(Resolve-SpeakLocalUrlTargets -SiteRoot $paths.ArtifactRoot -DocumentPath $modulePath -Url $phrase.audioUrl)
                if (-not $audioTargets.Count) {
                    throw "Preview module $($moduleEntry.moduleId) could not resolve audio path for phrase $($phrase.phraseId)."
                }

                $resolvedAudio = $false
                foreach ($audioTarget in $audioTargets) {
                    if (Test-Path -LiteralPath $audioTarget -PathType Leaf) {
                        $resolvedAudio = $true
                        break
                    }
                }

                if (-not $resolvedAudio) {
                    throw "Preview module $($moduleEntry.moduleId) exports missing audio asset for phrase $($phrase.phraseId)."
                }
            } elseif ($phrase.audioUrl) {
                throw "Preview module $($moduleEntry.moduleId) exports an audioUrl for non-ready phrase $($phrase.phraseId)."
            }
        }
    }

    Write-Host "Preview JSON parity and phrase/audio schema checks passed."
}

function Test-SpeakLocalPreviewRelationExport {
    $paths = Get-SpeakLocalWebsitePaths
    $siteDataDir = Join-Path $paths.ArtifactRoot 'data\phrase-previews'
    $manifestPath = Join-Path $siteDataDir 'manifest.json'
    $relationPath = Join-Path $paths.RepoRoot 'content-draft\viet\relation-sample-v1.json'
    $docPath = Join-Path $paths.RepoRoot 'docs\PHRASE_RELATIONSHIP_MODEL.md'

    if (-not (Test-Path -LiteralPath $manifestPath -PathType Leaf)) {
        throw "Preview manifest is missing for relation export checks: $manifestPath"
    }

    if (-not (Test-Path -LiteralPath $relationPath -PathType Leaf)) {
        throw "Viet relation sample is missing for relation export checks: $relationPath"
    }

    if (-not (Test-Path -LiteralPath $docPath -PathType Leaf)) {
        throw "Phrase relationship model doc is missing for relation export checks: $docPath"
    }

    $manifest = Get-Content -Raw -LiteralPath $manifestPath | ConvertFrom-Json
    $relationSample = Get-Content -Raw -LiteralPath $relationPath | ConvertFrom-Json
    $docContent = Get-Content -Raw -LiteralPath $docPath
    $docContractStartMarker = '<!-- canonical-viet-website-relation-export:start -->'
    $docContractEndMarker = '<!-- canonical-viet-website-relation-export:end -->'
    $docContractStartIndex = $docContent.IndexOf($docContractStartMarker)
    $docContractEndIndex = $docContent.IndexOf($docContractEndMarker)

    if ($docContractStartIndex -lt 0 -or $docContractEndIndex -lt 0 -or $docContractEndIndex -le $docContractStartIndex) {
        throw "Phrase relationship model doc is missing the canonical Viet website relation export block."
    }

    $docContractSectionStart = $docContractStartIndex + $docContractStartMarker.Length
    $docContractSection = $docContent.Substring($docContractSectionStart, $docContractEndIndex - $docContractSectionStart)
    $docContractMatch = [System.Text.RegularExpressions.Regex]::Match($docContractSection, '(?s)```json\s*(\{.*?\})\s*```')
    if (-not $docContractMatch.Success) {
        throw "Phrase relationship model canonical Viet website relation export block is not valid fenced JSON."
    }

    $docRelationExport = $docContractMatch.Groups[1].Value | ConvertFrom-Json

    if (-not $manifest.relationExport) {
        throw "Preview manifest relationExport is missing."
    }

    foreach ($propertyName in @('version', 'sampleId', 'sampleClusterCount', 'minimumCoveredClusterCount', 'currentCoveredClusterCount', 'coveredFamilyCount', 'exportedFamilyCount', 'coveredModuleCount', 'coveredModuleIds', 'advisoryOnly', 'starterOnly', 'edgeTargetRule', 'phraseRelationFieldNames')) {
        if (-not ($manifest.relationExport.PSObject.Properties.Name -contains $propertyName)) {
            throw "Preview manifest relationExport is missing required property '$propertyName'."
        }
    }

    if ([int]$manifest.relationExport.version -ne [int]$docRelationExport.version) {
        throw "Preview manifest relationExport.version drifted from the canonical relation export doc block."
    }

    if ($manifest.relationExport.sampleId -ne $docRelationExport.sampleId) {
        throw "Preview manifest relationExport.sampleId drifted from the canonical relation export doc block."
    }

    if ([int]$manifest.relationExport.sampleClusterCount -ne [int]$docRelationExport.sampleClusterCount) {
        throw "Preview manifest relationExport.sampleClusterCount drifted from the canonical relation export doc block."
    }

    if ([int]$manifest.relationExport.minimumCoveredClusterCount -ne [int]$docRelationExport.minimumCoveredClusterCount) {
        throw "Preview manifest relationExport.minimumCoveredClusterCount drifted from the canonical relation export doc block."
    }

    if ([int]$manifest.relationExport.currentCoveredClusterCount -ne [int]$docRelationExport.currentCoveredClusterCount) {
        throw "Preview manifest relationExport.currentCoveredClusterCount drifted from the canonical relation export doc block."
    }

    if ([bool]$manifest.relationExport.advisoryOnly -ne [bool]$docRelationExport.advisoryOnly) {
        throw "Preview manifest relationExport.advisoryOnly drifted from the canonical relation export doc block."
    }

    if ([bool]$manifest.relationExport.starterOnly -ne [bool]$docRelationExport.starterOnly) {
        throw "Preview manifest relationExport.starterOnly drifted from the canonical relation export doc block."
    }

    if ($manifest.relationExport.edgeTargetRule -ne $docRelationExport.edgeTargetRule) {
        throw "Preview manifest relationExport.edgeTargetRule drifted from the canonical relation export doc block."
    }

    if ((Compare-Object -ReferenceObject @($docRelationExport.coveredModuleIds) -DifferenceObject @($manifest.relationExport.coveredModuleIds))) {
        throw "Preview manifest relationExport.coveredModuleIds drifted from the canonical relation export doc block."
    }

    if ((Compare-Object -ReferenceObject @($docRelationExport.phraseRelationFieldNames) -DifferenceObject @($manifest.relationExport.phraseRelationFieldNames))) {
        throw "Preview manifest relationExport.phraseRelationFieldNames drifted from the canonical relation export doc block."
    }

    if ([int]$manifest.relationExport.currentCoveredClusterCount -lt [int]$manifest.relationExport.minimumCoveredClusterCount) {
        throw "Preview manifest relationExport.currentCoveredClusterCount is below the required minimum coverage."
    }

    if ($relationSample.sampleId -ne $manifest.relationExport.sampleId) {
        throw "Preview manifest relationExport.sampleId drifted from content-draft/viet/relation-sample-v1.json."
    }

    $relationSampleClusterCount = @($relationSample.clusters).Count
    if ([int]$relationSample.clusterCount -ne $relationSampleClusterCount) {
        throw "content-draft/viet/relation-sample-v1.json clusterCount does not match its clusters array."
    }

    if ([int]$manifest.relationExport.sampleClusterCount -ne [int]$relationSample.clusterCount) {
        throw "Preview manifest relationExport.sampleClusterCount drifted from content-draft/viet/relation-sample-v1.json."
    }

    if ([int]$docRelationExport.sampleClusterCount -ne [int]$relationSample.clusterCount) {
        throw "Canonical Viet website relation export doc block sampleClusterCount drifted from content-draft/viet/relation-sample-v1.json."
    }

    $clusterByFamilyId = @{}
    foreach ($cluster in @($relationSample.clusters)) {
        $clusterByFamilyId[[string]$cluster.familyId] = $cluster
    }

    $modulePayloads = @{}
    $exportedFamilyIds = @{}
    $exportedPhraseIds = @{}

    foreach ($moduleEntry in @($manifest.modules)) {
        $modulePath = Join-Path $paths.ArtifactRoot ($moduleEntry.path.TrimStart('/').Replace('/', '\'))
        $module = Get-Content -Raw -LiteralPath $modulePath | ConvertFrom-Json
        $modulePayloads[[string]$module.moduleId] = $module

        foreach ($phrase in @($module.phrases)) {
            $exportedFamilyIds[[string]$phrase.familyId] = $true
            $exportedPhraseIds[[string]$phrase.phraseId] = $true
        }
    }

    $coveredClusterIds = @{}
    $coveredFamilyIds = @{}
    $coveredModuleIds = @{}

    foreach ($moduleEntry in @($manifest.modules)) {
        $module = $modulePayloads[[string]$moduleEntry.moduleId]
        if (-not $module.relationCoverage) {
            throw "Preview module $($module.moduleId) is missing relationCoverage."
        }

        if (-not $moduleEntry.relationCoverage) {
            throw "Preview manifest entry $($module.moduleId) is missing relationCoverage."
        }

        $expectedCoveredClusters = @(
            foreach ($phrase in @($module.phrases)) {
                if ($clusterByFamilyId.ContainsKey([string]$phrase.familyId)) {
                    $clusterByFamilyId[[string]$phrase.familyId]
                }
            }
        )
        $expectedCoveredFamilyIds = @($expectedCoveredClusters | ForEach-Object { $_.familyId })
        $expectedCoveredClusterIds = @($expectedCoveredClusters | ForEach-Object { $_.clusterId })
        $expectedCoveredFamilyCount = @($expectedCoveredFamilyIds).Count
        $expectedStatus = if ($expectedCoveredFamilyCount -eq 0) {
            'none'
        } elseif ($expectedCoveredFamilyCount -ge [int]$module.familyCount) {
            'full'
        } else {
            'partial'
        }

        if ($module.relationCoverage.status -ne $expectedStatus) {
            throw "Preview module $($module.moduleId) relationCoverage.status drifted from the relation sample."
        }

        if ([int]$module.relationCoverage.coveredFamilyCount -ne $expectedCoveredFamilyCount) {
            throw "Preview module $($module.moduleId) relationCoverage.coveredFamilyCount drifted from the relation sample."
        }

        if ([int]$module.relationCoverage.coveredPhraseCount -ne $expectedCoveredFamilyCount) {
            throw "Preview module $($module.moduleId) relationCoverage.coveredPhraseCount drifted from the relation sample."
        }

        if ([int]$module.relationCoverage.totalFamilyCount -ne [int]$module.familyCount) {
            throw "Preview module $($module.moduleId) relationCoverage.totalFamilyCount does not match module.familyCount."
        }

        if ((Compare-Object -ReferenceObject $expectedCoveredFamilyIds -DifferenceObject @($module.relationCoverage.coveredFamilyIds))) {
            throw "Preview module $($module.moduleId) relationCoverage.coveredFamilyIds drifted from the relation sample."
        }

        if ((Compare-Object -ReferenceObject $expectedCoveredClusterIds -DifferenceObject @($module.relationCoverage.coveredClusterIds))) {
            throw "Preview module $($module.moduleId) relationCoverage.coveredClusterIds drifted from the relation sample."
        }

        if ((ConvertTo-SpeakLocalJson -Value $module.relationCoverage) -ne (ConvertTo-SpeakLocalJson -Value $moduleEntry.relationCoverage)) {
            throw "Preview module $($module.moduleId) relationCoverage does not match its manifest entry."
        }

        if ($expectedCoveredFamilyCount -gt 0) {
            $coveredModuleIds[[string]$module.moduleId] = $true
        }

        foreach ($familyId in $expectedCoveredFamilyIds) {
            $coveredFamilyIds[[string]$familyId] = $true
        }

        foreach ($clusterId in $expectedCoveredClusterIds) {
            $coveredClusterIds[[string]$clusterId] = $true
        }

        foreach ($phrase in @($module.phrases)) {
            $expectedCluster = if ($clusterByFamilyId.ContainsKey([string]$phrase.familyId)) {
                $clusterByFamilyId[[string]$phrase.familyId]
            } else {
                $null
            }

            $hasRelationContext = $phrase.PSObject.Properties.Name -contains 'relationContext'

            if ($null -eq $expectedCluster) {
                if ($hasRelationContext -and $null -ne $phrase.relationContext) {
                    throw "Preview module $($module.moduleId) exports relationContext for uncovered family $($phrase.familyId)."
                }
                continue
            }

            if (-not $hasRelationContext -or $null -eq $phrase.relationContext) {
                throw "Preview module $($module.moduleId) is missing relationContext for covered family $($phrase.familyId)."
            }

            if ($phrase.relationContext.sampleId -ne $manifest.relationExport.sampleId) {
                throw "Preview module $($module.moduleId) phrase $($phrase.phraseId) relationContext.sampleId drifted."
            }

            if ($phrase.relationContext.clusterId -ne $expectedCluster.clusterId) {
                throw "Preview module $($module.moduleId) phrase $($phrase.phraseId) relationContext.clusterId drifted."
            }

            if ($phrase.relationContext.coverageMoment -ne $expectedCluster.coverageMoment) {
                throw "Preview module $($module.moduleId) phrase $($phrase.phraseId) relationContext.coverageMoment drifted."
            }

            if (-not [bool]$phrase.relationContext.starterSafe) {
                throw "Preview module $($module.moduleId) phrase $($phrase.phraseId) relationContext.starterSafe must stay true."
            }

            if (-not [bool]$phrase.relationContext.advisoryOnly) {
                throw "Preview module $($module.moduleId) phrase $($phrase.phraseId) relationContext.advisoryOnly must stay true."
            }

            if ($phrase.relationContext.shortestFormPhraseId -ne $expectedCluster.shortestFormPhraseId) {
                throw "Preview module $($module.moduleId) phrase $($phrase.phraseId) shortestFormPhraseId drifted from the relation sample."
            }

            if ($phrase.relationContext.clearerFormPhraseId -ne $expectedCluster.clearerFormPhraseId) {
                throw "Preview module $($module.moduleId) phrase $($phrase.phraseId) clearerFormPhraseId drifted from the relation sample."
            }

            if ($phrase.relationContext.morePoliteFormPhraseId -ne $expectedCluster.morePoliteFormPhraseId) {
                throw "Preview module $($module.moduleId) phrase $($phrase.phraseId) morePoliteFormPhraseId drifted from the relation sample."
            }

            $expectedSignals = @(
                @($expectedCluster.youMayHearSignals) | Where-Object {
                    $_.sourcePhraseId -and $exportedPhraseIds.ContainsKey([string]$_.sourcePhraseId)
                } | ForEach-Object {
                    [ordered]@{
                        signalText = $_.signalText
                        sourcePhraseId = $_.sourcePhraseId
                        advisoryOnly = [bool]$_.advisoryOnly
                    }
                }
            )
            $expectedResponses = @(
                @($expectedCluster.possibleTravelerResponses) | Where-Object {
                    $_.familyId -and $exportedFamilyIds.ContainsKey([string]$_.familyId)
                } | ForEach-Object {
                    $response = [ordered]@{
                        kind = $_.kind
                        familyId = $_.familyId
                        note = $_.note
                    }

                    if ($_.phraseId -and $exportedPhraseIds.ContainsKey([string]$_.phraseId)) {
                        $response.phraseId = $_.phraseId
                    }

                    $response
                }
            )
            $expectedRelations = @(
                @($expectedCluster.familyRelations) | Where-Object {
                    $_.targetFamilyId -and $exportedFamilyIds.ContainsKey([string]$_.targetFamilyId)
                } | ForEach-Object {
                    [ordered]@{
                        relationType = $_.relationType
                        targetFamilyId = $_.targetFamilyId
                        reason = $_.reason
                    }
                }
            )

            if ((ConvertTo-SpeakLocalJson -Value @($phrase.relationContext.youMayHearSignals)) -ne (ConvertTo-SpeakLocalJson -Value $expectedSignals)) {
                throw "Preview module $($module.moduleId) phrase $($phrase.phraseId) youMayHearSignals drifted from the website-safe relation export contract."
            }

            if ((ConvertTo-SpeakLocalJson -Value @($phrase.relationContext.possibleTravelerResponses)) -ne (ConvertTo-SpeakLocalJson -Value $expectedResponses)) {
                throw "Preview module $($module.moduleId) phrase $($phrase.phraseId) possibleTravelerResponses drifted from the website-safe relation export contract."
            }

            if ((ConvertTo-SpeakLocalJson -Value @($phrase.relationContext.familyRelations)) -ne (ConvertTo-SpeakLocalJson -Value $expectedRelations)) {
                throw "Preview module $($module.moduleId) phrase $($phrase.phraseId) familyRelations drifted from the website-safe relation export contract."
            }
        }
    }

    if ([int]$manifest.relationExport.coveredFamilyCount -ne $coveredFamilyIds.Count) {
        throw "Preview manifest relationExport.coveredFamilyCount drifted from the actual module payload coverage."
    }

    if ([int]$manifest.relationExport.exportedFamilyCount -ne $exportedFamilyIds.Count) {
        throw "Preview manifest relationExport.exportedFamilyCount drifted from the actual module payload coverage."
    }

    if ([int]$manifest.relationExport.coveredModuleCount -ne $coveredModuleIds.Count) {
        throw "Preview manifest relationExport.coveredModuleCount drifted from the actual module payload coverage."
    }

    if ([int]$manifest.relationExport.currentCoveredClusterCount -ne $coveredClusterIds.Count) {
        throw "Preview manifest relationExport.currentCoveredClusterCount drifted from the actual module payload coverage."
    }

    if ((Compare-Object -ReferenceObject @($manifest.relationExport.coveredModuleIds) -DifferenceObject @($coveredModuleIds.Keys))) {
        throw "Preview manifest relationExport.coveredModuleIds drifted from the actual module payload coverage."
    }

    Write-Host "Preview relation export checks passed."
}

function Test-SpeakLocalPreviewAudioParity {
    $paths = Get-SpeakLocalWebsitePaths
    $siteAudioDir = Join-Path $paths.ArtifactRoot 'data\phrase-audio'
    $publicAudioDir = Join-Path $paths.ArtifactRoot 'public\data\phrase-audio'

    foreach ($audioDir in @($siteAudioDir, $publicAudioDir)) {
        if (-not (Test-Path -LiteralPath $audioDir -PathType Container)) {
            throw "Preview audio directory missing: $audioDir"
        }
    }

    $siteFiles = Get-ChildItem -LiteralPath $siteAudioDir -File -Recurse | Sort-Object FullName
    $publicFiles = Get-ChildItem -LiteralPath $publicAudioDir -File -Recurse | Sort-Object FullName

    $sitePrefix = [System.IO.Path]::GetFullPath($siteAudioDir).TrimEnd('\') + '\'
    $publicPrefix = [System.IO.Path]::GetFullPath($publicAudioDir).TrimEnd('\') + '\'
    $siteRelative = @($siteFiles | ForEach-Object {
        $_.FullName.Substring($sitePrefix.Length).Replace('\', '/')
    })
    $publicRelative = @($publicFiles | ForEach-Object {
        $_.FullName.Substring($publicPrefix.Length).Replace('\', '/')
    })

    if ((Compare-Object -ReferenceObject $siteRelative -DifferenceObject $publicRelative)) {
        throw "Preview audio file lists differ between site/data and site/public/data."
    }

    foreach ($relativePath in $siteRelative) {
        $sitePath = Join-Path $siteAudioDir ($relativePath.Replace('/', '\'))
        $publicPath = Join-Path $publicAudioDir ($relativePath.Replace('/', '\'))

        $siteHash = (Get-FileHash -LiteralPath $sitePath -Algorithm SHA256).Hash
        $publicHash = (Get-FileHash -LiteralPath $publicPath -Algorithm SHA256).Hash

        if ($siteHash -ne $publicHash) {
            throw "Preview audio drift detected for $relativePath between direct-serve and public copies."
        }
    }

    Write-Host "Preview audio parity passed."
}

function Test-SpeakLocalPhrasePlaybackScope {
    $paths = Get-SpeakLocalWebsitePaths
    $siteRoot = $paths.ArtifactRoot
    $playbackAttributePattern = 'data-phrase-audio-mode\s*=\s*["'']playback["'']'
    $allowedPlaybackFiles = @(
        'blog\phrases-tourists-actually-need-in-vietnam.html'
        'blog\phrases-tourists-actually-need-in-vietnam\index.html'
        'blog\vietnam-first-24-hours.html'
        'blog\vietnam-first-24-hours\index.html'
        'blog\vietnam-grab-taxi-confusion.html'
        'blog\vietnam-grab-taxi-confusion\index.html'
        'blog\vietnam-sim-esim-offline-setup.html'
        'blog\vietnam-sim-esim-offline-setup\index.html'
    ) | ForEach-Object {
        [System.IO.Path]::GetFullPath((Join-Path $siteRoot $_))
    }

    $htmlFiles = Get-ChildItem -LiteralPath $siteRoot -Recurse -Filter *.html -File
    $playbackFiles = New-Object System.Collections.Generic.List[string]

    foreach ($htmlFile in $htmlFiles) {
        $body = Get-Content -Raw -LiteralPath $htmlFile.FullName
        if ($body -match $playbackAttributePattern) {
            $playbackFiles.Add([System.IO.Path]::GetFullPath($htmlFile.FullName)) | Out-Null
        }
    }

    $actualPlaybackFiles = @($playbackFiles | Sort-Object -Unique)
    $expectedPlaybackFiles = @($allowedPlaybackFiles | Sort-Object -Unique)

    if ((Compare-Object -ReferenceObject $expectedPlaybackFiles -DifferenceObject $actualPlaybackFiles)) {
        throw "Phrase playback scope drift detected. Only the approved Viet phrase/article surfaces may opt into embedded playback."
    }

    Write-Host "Phrase playback scope passed."
}

$paths = Get-SpeakLocalWebsitePaths

if (-not (Test-Path -LiteralPath $paths.ArtifactRoot -PathType Container)) {
    throw "Website artifact root does not exist: $($paths.ArtifactRoot)"
}

Test-SpeakLocalRoutePairs
Test-SpeakLocalInternalLinks
Test-SpeakLocalPreviewParity
Test-SpeakLocalPreviewRelationExport
Test-SpeakLocalPreviewAudioParity
Test-SpeakLocalPhrasePlaybackScope

Write-Host "SpeakLocal website artifact validation passed for $($paths.ArtifactRoot)"
