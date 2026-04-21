param(
    [string]$OutputRoot
)

. "$PSScriptRoot\SpeakLocalWebsite.Common.ps1"

function ConvertTo-SpeakLocalWebsiteRelationCoverage {
    param(
        [Parameter(Mandatory = $true)]
        [System.Collections.IEnumerable]$CoveredClusters,
        [Parameter(Mandatory = $true)]
        [int]$TotalFamilyCount
    )

    $clusterList = @($CoveredClusters)
    $coveredFamilyIds = @($clusterList | ForEach-Object { $_.familyId })
    $coveredClusterIds = @($clusterList | ForEach-Object { $_.clusterId })
    $coveredFamilyCount = @($coveredFamilyIds).Count

    $status = if ($coveredFamilyCount -eq 0) {
        'none'
    } elseif ($coveredFamilyCount -ge $TotalFamilyCount) {
        'full'
    } else {
        'partial'
    }

    return [ordered]@{
        status = $status
        advisoryOnly = $true
        coveredFamilyCount = $coveredFamilyCount
        coveredPhraseCount = $coveredFamilyCount
        totalFamilyCount = $TotalFamilyCount
        coveredFamilyIds = @($coveredFamilyIds)
        coveredClusterIds = @($coveredClusterIds)
    }
}

function ConvertTo-SpeakLocalWebsiteRelationContext {
    param(
        [Parameter(Mandatory = $true)]
        $Cluster,
        [Parameter(Mandatory = $true)]
        [hashtable]$ExportedFamilyIds,
        [Parameter(Mandatory = $true)]
        [hashtable]$ExportedPhraseIds
    )

    $filteredSignals = @(
        @($Cluster.youMayHearSignals) | Where-Object {
            $_.sourcePhraseId -and $ExportedPhraseIds.ContainsKey([string]$_.sourcePhraseId)
        } | ForEach-Object {
            [ordered]@{
                signalText = $_.signalText
                sourcePhraseId = $_.sourcePhraseId
                advisoryOnly = [bool]$_.advisoryOnly
            }
        }
    )

    $filteredResponses = @(
        @($Cluster.possibleTravelerResponses) | Where-Object {
            $_.familyId -and $ExportedFamilyIds.ContainsKey([string]$_.familyId)
        } | ForEach-Object {
            $response = [ordered]@{
                kind = $_.kind
                familyId = $_.familyId
                note = $_.note
            }

            if ($_.phraseId -and $ExportedPhraseIds.ContainsKey([string]$_.phraseId)) {
                $response.phraseId = $_.phraseId
            }

            $response
        }
    )

    $filteredRelations = @(
        @($Cluster.familyRelations) | Where-Object {
            $_.targetFamilyId -and $ExportedFamilyIds.ContainsKey([string]$_.targetFamilyId)
        } | ForEach-Object {
            [ordered]@{
                relationType = $_.relationType
                targetFamilyId = $_.targetFamilyId
                reason = $_.reason
            }
        }
    )

    return [ordered]@{
        sampleId = 'viet-relation-sample-v1'
        clusterId = $Cluster.clusterId
        coverageMoment = $Cluster.coverageMoment
        starterSafe = $true
        advisoryOnly = $true
        shortestFormPhraseId = $Cluster.shortestFormPhraseId
        clearerFormPhraseId = $Cluster.clearerFormPhraseId
        morePoliteFormPhraseId = $Cluster.morePoliteFormPhraseId
        youMayHearSignals = $filteredSignals
        possibleTravelerResponses = $filteredResponses
        familyRelations = $filteredRelations
    }
}

function ConvertTo-SpeakLocalWebsitePhrase {
    param(
        [Parameter(Mandatory = $true)]
        $Phrase,
        $RelationContext
    )

    $phraseExport = [ordered]@{
        phraseId = $Phrase.phraseId
        phraseSlug = $Phrase.phraseSlug
        id = $Phrase.id
        moduleId = $Phrase.moduleId
        destinationSlug = $Phrase.destinationSlug
        variant = $Phrase.variant
        language = $Phrase.language
        languageCode = $Phrase.languageCode
        country = $Phrase.country
        scenarioId = $Phrase.scenarioId
        scenarioSlug = $Phrase.scenarioSlug
        scenarioName = $Phrase.scenarioName
        familyId = $Phrase.familyId
        familySlug = $Phrase.familySlug
        familyTitle = $Phrase.familyTitle
        familySummary = $Phrase.familySummary
        accessTier = $Phrase.accessTier
        variantRole = $Phrase.variantRole
        variantLabel = $Phrase.variantLabel
        englishText = $Phrase.englishText
        sourceText = $Phrase.sourceText
        targetText = $Phrase.targetText
        canonicalTargetText = $Phrase.canonicalTargetText
        pronunciation = $Phrase.pronunciation
        context = $Phrase.context
    }

    $hasYouMayHear = $Phrase.PSObject.Properties.Name -contains 'youMayHear'
    if ($hasYouMayHear -and $null -ne $Phrase.youMayHear) {
        $phraseExport.youMayHear = $Phrase.youMayHear
    }

    $hasWarningNoteType = $Phrase.PSObject.Properties.Name -contains 'warningNoteType'
    if ($hasWarningNoteType -and $null -ne $Phrase.warningNoteType) {
        $phraseExport.warningNoteType = $Phrase.warningNoteType
    }

    if ($null -ne $RelationContext) {
        $phraseExport.relationContext = $RelationContext
    }

    $phraseExport.audioStatus = $Phrase.audioStatus
    $phraseExport.audioDelivery = $Phrase.audioDelivery
    $phraseExport.audioUrl = $Phrase.audioUrl
    $phraseExport.audioReference = $Phrase.audioReference
    $phraseExport.audioDurationMs = $Phrase.audioDurationMs
    $phraseExport.transcriptChecked = $Phrase.transcriptChecked
    $phraseExport.websiteReferences = $Phrase.websiteReferences

    return $phraseExport
}

function ConvertTo-SpeakLocalWebsiteModule {
    param(
        [Parameter(Mandatory = $true)]
        $Module,
        [Parameter(Mandatory = $true)]
        [hashtable]$ClusterByFamilyId,
        [Parameter(Mandatory = $true)]
        [hashtable]$ExportedFamilyIds,
        [Parameter(Mandatory = $true)]
        [hashtable]$ExportedPhraseIds
    )

    $coveredClusters = @()
    $phrases = @()

    foreach ($phrase in @($Module.phrases)) {
        $cluster = $null
        if ($ClusterByFamilyId.ContainsKey([string]$phrase.familyId)) {
            $cluster = $ClusterByFamilyId[[string]$phrase.familyId]
            $coveredClusters += $cluster
        }

        $relationContext = if ($null -ne $cluster) {
            ConvertTo-SpeakLocalWebsiteRelationContext -Cluster $cluster -ExportedFamilyIds $ExportedFamilyIds -ExportedPhraseIds $ExportedPhraseIds
        } else {
            $null
        }

        $phrases += ConvertTo-SpeakLocalWebsitePhrase -Phrase $phrase -RelationContext $relationContext
    }

    $relationCoverage = ConvertTo-SpeakLocalWebsiteRelationCoverage -CoveredClusters $coveredClusters -TotalFamilyCount ([int]$Module.familyCount)

    return [ordered]@{
        schemaVersion = $Module.schemaVersion
        exportType = $Module.exportType
        exportedAt = $Module.exportedAt
        moduleId = $Module.moduleId
        moduleSlug = $Module.moduleSlug
        destinationSlug = $Module.destinationSlug
        destinationName = $Module.destinationName
        variant = $Module.variant
        language = $Module.language
        languageCode = $Module.languageCode
        country = $Module.country
        scenarioId = $Module.scenarioId
        scenarioSlug = $Module.scenarioSlug
        scenarioName = $Module.scenarioName
        editorialStatus = $Module.editorialStatus
        appStatus = $Module.appStatus
        websiteAudioStatus = $Module.websiteAudioStatus
        audioStatus = $Module.audioStatus
        audioDelivery = $Module.audioDelivery
        audioCoverage = $Module.audioCoverage
        headline = $Module.headline
        summary = $Module.summary
        travelerStage = $Module.travelerStage
        difficulty = $Module.difficulty
        formality = $Module.formality
        audioDurationMs = $Module.audioDurationMs
        transcriptChecked = $Module.transcriptChecked
        phraseCount = $Module.phraseCount
        familyCount = $Module.familyCount
        relationCoverage = $relationCoverage
        articleReference = $Module.articleReference
        trust = $Module.trust
        cta = $Module.cta
        phrases = $phrases
    }
}

function ConvertTo-SpeakLocalWebsiteManifest {
    param(
        [Parameter(Mandatory = $true)]
        $Manifest,
        [Parameter(Mandatory = $true)]
        [System.Collections.IEnumerable]$Modules,
        [Parameter(Mandatory = $true)]
        [hashtable]$ClusterByFamilyId
    )

    $moduleList = @($Modules)
    $coveredModules = @($moduleList | Where-Object { [int]$_.relationCoverage.coveredFamilyCount -gt 0 } | ForEach-Object { $_.moduleId })
    $coveredFamilies = @($moduleList | ForEach-Object { $_.relationCoverage.coveredFamilyIds } | Sort-Object -Unique)
    $coveredClusters = @($moduleList | ForEach-Object { $_.relationCoverage.coveredClusterIds } | Sort-Object -Unique)
    $exportedFamilyIds = @($moduleList | ForEach-Object { $_.phrases } | ForEach-Object { $_.familyId } | Sort-Object -Unique)

    $surfacePlacementByModuleId = @{}
    foreach ($manifestModule in @($Manifest.modules)) {
        $surfacePlacementByModuleId[[string]$manifestModule.moduleId] = $manifestModule.surfacePlacement
    }

    $manifestModules = @(
        $moduleList | ForEach-Object {
            [ordered]@{
                exportedAt = $_.exportedAt
                moduleId = $_.moduleId
                moduleSlug = $_.moduleSlug
                path = "/data/phrase-previews/$($_.moduleId).json"
                destinationSlug = $_.destinationSlug
                destinationName = $_.destinationName
                variant = $_.variant
                language = $_.language
                languageCode = $_.languageCode
                country = $_.country
                scenarioId = $_.scenarioId
                scenarioName = $_.scenarioName
                editorialStatus = $_.editorialStatus
                appStatus = $_.appStatus
                websiteAudioStatus = $_.websiteAudioStatus
                audioStatus = $_.audioStatus
                audioDelivery = $_.audioDelivery
                audioCoverage = $_.audioCoverage
                headline = $_.headline
                summary = $_.summary
                travelerStage = $_.travelerStage
                difficulty = $_.difficulty
                formality = $_.formality
                audioDurationMs = $_.audioDurationMs
                transcriptChecked = $_.transcriptChecked
                phraseCount = $_.phraseCount
                familyCount = $_.familyCount
                relationCoverage = $_.relationCoverage
                surfacePlacement = $surfacePlacementByModuleId[[string]$_.moduleId]
                articleUrl = $_.articleReference.secondaryUrl
                trust = $_.trust
            }
        }
    )

    return [ordered]@{
        schemaVersion = $Manifest.schemaVersion
        exportType = $Manifest.exportType
        generatedFor = $Manifest.generatedFor
        exportedAt = $Manifest.exportedAt
        moduleCount = $Manifest.moduleCount
        surfaceContract = $Manifest.surfaceContract
        relationExport = [ordered]@{
            version = 1
            sampleId = 'viet-relation-sample-v1'
            sampleClusterCount = @($ClusterByFamilyId.Keys).Count
            minimumCoveredClusterCount = 12
            currentCoveredClusterCount = @($coveredClusters).Count
            coveredFamilyCount = @($coveredFamilies).Count
            exportedFamilyCount = @($exportedFamilyIds).Count
            coveredModuleCount = @($coveredModules).Count
            coveredModuleIds = @($coveredModules)
            advisoryOnly = $true
            starterOnly = $true
            edgeTargetRule = 'starter-safe and exported-target-only'
            phraseRelationFieldNames = @(
                'shortestFormPhraseId',
                'clearerFormPhraseId',
                'morePoliteFormPhraseId',
                'youMayHearSignals',
                'possibleTravelerResponses',
                'familyRelations'
            )
        }
        modules = $manifestModules
    }
}

$paths = Get-SpeakLocalWebsitePaths
$previewRoots = @(
    (Join-Path $paths.ArtifactRoot 'data\phrase-previews'),
    (Join-Path $paths.ArtifactRoot 'public\data\phrase-previews')
)

$relationPath = Join-Path $paths.RepoRoot 'content-draft\viet\relation-sample-v1.json'
if (-not (Test-Path -LiteralPath $relationPath -PathType Leaf)) {
    throw "Missing Viet relation sample: $relationPath"
}

$relationSample = Get-Content -Raw -LiteralPath $relationPath | ConvertFrom-Json
$clusterByFamilyId = @{}
foreach ($cluster in @($relationSample.clusters)) {
    $clusterByFamilyId[[string]$cluster.familyId] = $cluster
}

$sourcePreviewDir = $previewRoots[0]
$manifestPath = Join-Path $sourcePreviewDir 'manifest.json'
if (-not (Test-Path -LiteralPath $manifestPath -PathType Leaf)) {
    throw "Missing preview manifest: $manifestPath"
}

$sourceManifest = Get-Content -Raw -LiteralPath $manifestPath | ConvertFrom-Json
$sourceModuleFiles = @(
    Get-ChildItem -LiteralPath $sourcePreviewDir -Filter 'vietnam-*.json' -File |
        Sort-Object Name
)
$sourceModulesById = @{}
foreach ($moduleFile in $sourceModuleFiles) {
    $module = Get-Content -Raw -LiteralPath $moduleFile.FullName | ConvertFrom-Json
    $sourceModulesById[[string]$module.moduleId] = $module
}
$sourceModules = @(
    foreach ($manifestModule in @($sourceManifest.modules)) {
        $sourceModulesById[[string]$manifestModule.moduleId]
    }
)

$exportedFamilyIds = @{}
$exportedPhraseIds = @{}
foreach ($module in $sourceModules) {
    foreach ($phrase in @($module.phrases)) {
        $exportedFamilyIds[[string]$phrase.familyId] = $true
        $exportedPhraseIds[[string]$phrase.phraseId] = $true
    }
}

$updatedModules = @(
    foreach ($module in $sourceModules) {
        ConvertTo-SpeakLocalWebsiteModule -Module $module -ClusterByFamilyId $clusterByFamilyId -ExportedFamilyIds $exportedFamilyIds -ExportedPhraseIds $exportedPhraseIds
    }
)

$updatedManifest = ConvertTo-SpeakLocalWebsiteManifest -Manifest $sourceManifest -Modules $updatedModules -ClusterByFamilyId $clusterByFamilyId

if ($OutputRoot) {
    $previewRoots = @(
        (Join-Path $OutputRoot 'site-data'),
        (Join-Path $OutputRoot 'site-public')
    )

    foreach ($previewRoot in $previewRoots) {
        New-Item -ItemType Directory -Path $previewRoot -Force | Out-Null
    }
}

foreach ($previewRoot in $previewRoots) {
    foreach ($module in $updatedModules) {
        $modulePath = Join-Path $previewRoot "$($module.moduleId).json"
        ($module | ConvertTo-Json -Depth 100) + "`n" | Set-Content -LiteralPath $modulePath -Encoding UTF8
    }

    ($updatedManifest | ConvertTo-Json -Depth 100) + "`n" | Set-Content -LiteralPath (Join-Path $previewRoot 'manifest.json') -Encoding UTF8
}

$coveredClusterCount = [int]$updatedManifest.relationExport.currentCoveredClusterCount
Write-Host "Updated website relation export packet across $($previewRoots.Count) preview roots."
Write-Host "Covered starter-safe clusters: $coveredClusterCount"
