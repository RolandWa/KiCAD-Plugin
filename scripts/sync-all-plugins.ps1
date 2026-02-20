<#
.SYNOPSIS
    Syncs all plugins that have metadata updates to packages.json and kicad-repository.json.

.DESCRIPTION
    This script checks all plugins in the packages/ directory and syncs any that have
    version updates in their metadata.json but not yet in packages.json. Useful after
    scheduled workflow runs that might have updated multiple plugins.

.EXAMPLE
    .\scripts\sync-all-plugins.ps1
    
.EXAMPLE
    .\scripts\sync-all-plugins.ps1 -WhatIf
#>

[CmdletBinding(SupportsShouldProcess)]
param(
    [Parameter(Mandatory = $false)]
    [switch]$WhatIf
)

$ErrorActionPreference = "Stop"

# Get repository root
$repoRoot = Split-Path -Parent $PSScriptRoot
Push-Location $repoRoot

try {
    Write-Host "=== Syncing All Plugins ===" -ForegroundColor Cyan
    Write-Host ""

    # Pull latest changes
    Write-Host "Pulling latest changes from GitHub..." -ForegroundColor Green
    git pull origin main
    if ($LASTEXITCODE -ne 0) {
        throw "Git pull failed"
    }
    Write-Host ""

    # Load packages.json
    $packagesPath = "packages.json"
    if (-not (Test-Path $packagesPath)) {
        throw "packages.json not found"
    }
    $packages = Get-Content $packagesPath -Raw | ConvertFrom-Json

    # Find all plugin directories
    $pluginDirs = Get-ChildItem "packages" -Directory
    $pluginsToSync = @()

    Write-Host "Checking plugins for updates..." -ForegroundColor Green
    Write-Host ""

    foreach ($pluginDir in $pluginDirs) {
        $pluginName = $pluginDir.Name
        $metadataPath = Join-Path $pluginDir.FullName "metadata.json"
        
        if (-not (Test-Path $metadataPath)) {
            Write-Host "  ⚠ $pluginName - No metadata.json found, skipping" -ForegroundColor Yellow
            continue
        }

        $metadata = Get-Content $metadataPath -Raw | ConvertFrom-Json
        $metadataVersion = $metadata.versions[0].version

        # Find plugin in packages.json
        $packagePlugin = $packages.packages | Where-Object { $_.identifier -eq $metadata.identifier }
        
        if (-not $packagePlugin) {
            Write-Host "  ⚠ $pluginName - Not found in packages.json, skipping" -ForegroundColor Yellow
            continue
        }

        $packagesVersion = $packagePlugin.versions[0].version

        if ($metadataVersion -ne $packagesVersion) {
            Write-Host "  ✓ $pluginName - Update available: v$packagesVersion → v$metadataVersion" -ForegroundColor Green
            $pluginsToSync += $pluginName
        } else {
            Write-Host "  • $pluginName - Up to date (v$packagesVersion)" -ForegroundColor Gray
        }
    }

    Write-Host ""

    if ($pluginsToSync.Count -eq 0) {
        Write-Host "✓ All plugins are already in sync!" -ForegroundColor Green
        Write-Host ""
        exit 0
    }

    Write-Host "Found $($pluginsToSync.Count) plugin(s) to sync:" -ForegroundColor Cyan
    foreach ($plugin in $pluginsToSync) {
        Write-Host "  - $plugin" -ForegroundColor White
    }
    Write-Host ""

    if ($WhatIf) {
        Write-Host "WhatIf: Would sync these plugins (run without -WhatIf to proceed)" -ForegroundColor Yellow
        Write-Host ""
        exit 0
    }

    # Sync each plugin
    foreach ($pluginName in $pluginsToSync) {
        Write-Host "----------------------------------------" -ForegroundColor Gray
        $syncScript = Join-Path $PSScriptRoot "sync-package-metadata.ps1"
        & $syncScript -PluginName $pluginName -SkipPull
        
        if ($LASTEXITCODE -ne 0) {
            Write-Host "ERROR: Failed to sync $pluginName" -ForegroundColor Red
            exit 1
        }
        Write-Host ""
    }

    Write-Host "========================================" -ForegroundColor Gray
    Write-Host ""
    Write-Host "✓ All plugins synced successfully!" -ForegroundColor Green
    Write-Host ""

} catch {
    Write-Host ""
    Write-Host "ERROR: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host ""
    exit 1
} finally {
    Pop-Location
}
