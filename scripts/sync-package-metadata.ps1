<#
.SYNOPSIS
    Synchronizes packages.json and kicad-repository.json after a workflow auto-updates a plugin.

.DESCRIPTION
    This script automates the manual steps required after a GitHub Actions workflow
    updates a plugin:
    1. Pulls latest changes from the workflow
    2. Syncs the new version from metadata.json to packages.json
    3. Pushes packages.json to GitHub
    4. Downloads and hashes the GitHub version of packages.json
    5. Updates kicad-repository.json with new hash and timestamp
    6. Commits and pushes final changes

.PARAMETER PluginName
    The name of the plugin that was updated (e.g., "emc_auditor", "openfixture")

.PARAMETER SkipPull
    Skip the initial git pull (useful if already up to date)

.EXAMPLE
    .\scripts\sync-package-metadata.ps1 -PluginName "emc_auditor"
    
.EXAMPLE
    .\scripts\sync-package-metadata.ps1 -PluginName "openfixture" -SkipPull
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$PluginName,
    
    [Parameter(Mandatory = $false)]
    [switch]$SkipPull
)

$ErrorActionPreference = "Stop"

# Get repository root
$repoRoot = Split-Path -Parent $PSScriptRoot
Push-Location $repoRoot

try {
    Write-Host "=== Plugin Repository Metadata Sync ===" -ForegroundColor Cyan
    Write-Host "Plugin: $PluginName" -ForegroundColor Yellow
    Write-Host ""

    # Step 1: Pull latest changes
    if (-not $SkipPull) {
        Write-Host "[1/6] Pulling latest changes from GitHub..." -ForegroundColor Green
        git pull origin main
        if ($LASTEXITCODE -ne 0) {
            throw "Git pull failed"
        }
        Write-Host ""
    } else {
        Write-Host "[1/6] Skipping git pull" -ForegroundColor Gray
        Write-Host ""
    }

    # Step 2: Read metadata.json
    Write-Host "[2/6] Reading plugin metadata..." -ForegroundColor Green
    $metadataPath = "packages/$PluginName/metadata.json"
    
    if (-not (Test-Path $metadataPath)) {
        throw "Metadata file not found: $metadataPath"
    }

    $metadata = Get-Content $metadataPath -Raw | ConvertFrom-Json
    $latestVersion = $metadata.versions[0]
    
    Write-Host "  Plugin: $($metadata.name)" -ForegroundColor White
    Write-Host "  Latest Version: $($latestVersion.version)" -ForegroundColor White
    Write-Host "  SHA256: $($latestVersion.download_sha256)" -ForegroundColor White
    Write-Host ""

    # Step 3: Update packages.json
    Write-Host "[3/6] Updating packages.json..." -ForegroundColor Green
    $packagesPath = "packages.json"
    
    if (-not (Test-Path $packagesPath)) {
        throw "packages.json not found"
    }

    $packages = Get-Content $packagesPath -Raw | ConvertFrom-Json
    
    # Find the plugin in packages array
    $pluginIndex = -1
    for ($i = 0; $i -lt $packages.packages.Count; $i++) {
        if ($packages.packages[$i].identifier -eq $metadata.identifier) {
            $pluginIndex = $i
            break
        }
    }
    
    if ($pluginIndex -eq -1) {
        Write-Host "  Plugin not found in packages.json, adding it..." -ForegroundColor Yellow
        # Add new plugin to packages array
        $packages.packages += $metadata
        $packagesUpdated = $true
    } else {
        # Check if metadata changed
        $currentMetadata = $packages.packages[$pluginIndex] | ConvertTo-Json -Depth 10
        $newMetadata = $metadata | ConvertTo-Json -Depth 10
        
        if ($currentMetadata -eq $newMetadata) {
            Write-Host "  ✓ packages.json already up to date" -ForegroundColor Yellow
            Write-Host "  No changes needed" -ForegroundColor Yellow
            $packagesUpdated = $false
        } else {
            Write-Host "  Current version: $($packages.packages[$pluginIndex].versions[0].version)" -ForegroundColor White
            Write-Host "  Latest version: $($latestVersion.version)" -ForegroundColor White
            
            # Replace entire package entry with full metadata
            $packages.packages[$pluginIndex] = $metadata
            
            $packagesUpdated = $true
        }
    }
    
    if ($packagesUpdated) {
        # Save packages.json
        $packages | ConvertTo-Json -Depth 10 | Set-Content $packagesPath -Encoding UTF8
        Write-Host "  ✓ Updated packages.json" -ForegroundColor Green
    }
    Write-Host ""

    # Step 4: Commit and push packages.json (if updated)
    if ($packagesUpdated) {
        Write-Host "[4/6] Committing and pushing packages.json..." -ForegroundColor Green
        git add packages.json
        git commit -m "Sync $PluginName v$($latestVersion.version) to packages.json"
        git push origin main
        
        if ($LASTEXITCODE -ne 0) {
            throw "Git push failed"
        }
        
        Write-Host "  ✓ Pushed to GitHub" -ForegroundColor Green
        Write-Host ""
        
        # Wait for GitHub to process the push
        Write-Host "  Waiting 5 seconds for GitHub to update..." -ForegroundColor Gray
        Start-Sleep -Seconds 5
        Write-Host ""
    } else {
        Write-Host "[4/6] Skipping commit (no changes)" -ForegroundColor Gray
        Write-Host ""
    }

    # Step 5: Download and hash packages.json from GitHub
    Write-Host "[5/6] Calculating GitHub packages.json hash..." -ForegroundColor Green
    $tempFile = [System.IO.Path]::GetTempFileName()
    
    try {
        $url = "https://raw.githubusercontent.com/RolandWa/KiCAD-Plugin/main/packages.json"
        Invoke-WebRequest -Uri $url -OutFile $tempFile
        $githubHash = (Get-FileHash $tempFile -Algorithm SHA256).Hash.ToLower()
        Write-Host "  SHA256: $githubHash" -ForegroundColor White
    } finally {
        if (Test-Path $tempFile) {
            Remove-Item $tempFile
        }
    }
    Write-Host ""

    # Step 6: Update kicad-repository.json
    Write-Host "[6/6] Updating kicad-repository.json..." -ForegroundColor Green
    $repoJsonPath = "kicad-repository.json"
    
    if (-not (Test-Path $repoJsonPath)) {
        throw "kicad-repository.json not found"
    }

    $repoJson = Get-Content $repoJsonPath -Raw | ConvertFrom-Json
    $currentHash = $repoJson.packages.sha256
    
    if ($currentHash -eq $githubHash) {
        Write-Host "  ✓ kicad-repository.json already has correct hash" -ForegroundColor Yellow
        Write-Host "  No changes needed" -ForegroundColor Yellow
    } else {
        Write-Host "  Old hash: $currentHash" -ForegroundColor White
        Write-Host "  New hash: $githubHash" -ForegroundColor White
        
        # Update hash and timestamp
        $utcNow = [DateTime]::UtcNow
        $repoJson.packages.sha256 = $githubHash
        $repoJson.packages.update_time_utc = $utcNow.ToString("yyyy-MM-dd HH:mm:ss")
        $repoJson.packages.update_timestamp = [int][double]::Parse(($utcNow - (Get-Date "1970-01-01 00:00:00")).TotalSeconds)
        
        # Save kicad-repository.json
        $repoJson | ConvertTo-Json -Depth 10 | Set-Content $repoJsonPath -Encoding UTF8
        Write-Host "  ✓ Updated kicad-repository.json" -ForegroundColor Green
        Write-Host ""
        
        # Commit and push
        Write-Host "  Committing and pushing..." -ForegroundColor Green
        git add kicad-repository.json
        git commit -m "Update repository hash for $PluginName v$($latestVersion.version)"
        git push origin main
        
        if ($LASTEXITCODE -ne 0) {
            throw "Git push failed"
        }
        
        Write-Host "  ✓ Pushed to GitHub" -ForegroundColor Green
    }
    Write-Host ""

    # Summary
    Write-Host "=== Sync Complete! ===" -ForegroundColor Cyan
    Write-Host "Plugin: $($metadata.name) v$($latestVersion.version)" -ForegroundColor White
    Write-Host "Repository URL: https://raw.githubusercontent.com/RolandWa/KiCAD-Plugin/main/kicad-repository.json" -ForegroundColor White
    Write-Host ""
    Write-Host "✓ Your KiCAD Plugin Repository is now up to date!" -ForegroundColor Green
    Write-Host ""

} catch {
    Write-Host ""
    Write-Host "ERROR: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host ""
    exit 1
} finally {
    Pop-Location
}
