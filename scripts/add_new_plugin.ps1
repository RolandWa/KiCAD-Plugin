# Add New Plugin to KiCAD Repository
# Interactive script to help add a new plugin to the repository
#
# Date: February 20, 2026

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "Add New Plugin to Repository" -ForegroundColor Cyan
Write-Host "========================================`n" -ForegroundColor Cyan

# Get plugin information with validation
Write-Host "Enter plugin information:" -ForegroundColor Yellow

do {
    $PluginName = Read-Host "Plugin Name (e.g., 'My Awesome Plugin')"
    if ([string]::IsNullOrWhiteSpace($PluginName)) {
        Write-Host "  Error: Plugin name cannot be empty" -ForegroundColor Red
    }
} while ([string]::IsNullOrWhiteSpace($PluginName))

do {
    $PluginIdentifier = Read-Host "Plugin Identifier (e.g., 'com.myname.myplugin')"
    if ([string]::IsNullOrWhiteSpace($PluginIdentifier) -or $PluginIdentifier -notmatch '^com\.[a-z0-9_]+\.[a-z0-9_]+$') {
        Write-Host "  Error: Identifier must match format 'com.name.plugin' (lowercase, no spaces)" -ForegroundColor Red
    }
} while ([string]::IsNullOrWhiteSpace($PluginIdentifier) -or $PluginIdentifier -notmatch '^com\.[a-z0-9_]+\.[a-z0-9_]+$')

do {
    $ShortDesc = Read-Host "Short Description (one line)"
    if ([string]::IsNullOrWhiteSpace($ShortDesc)) {
        Write-Host "  Error: Description cannot be empty" -ForegroundColor Red
    }
} while ([string]::IsNullOrWhiteSpace($ShortDesc))

do {
    $Author = Read-Host "Author Name"
    if ([string]::IsNullOrWhiteSpace($Author)) {
        Write-Host "  Error: Author name cannot be empty" -ForegroundColor Red
    }
} while ([string]::IsNullOrWhiteSpace($Author))

do {
    $License = Read-Host "License (e.g., MIT, GPL-3.0, CC-BY-SA-4.0)"
    if ([string]::IsNullOrWhiteSpace($License)) {
        Write-Host "  Error: License cannot be empty" -ForegroundColor Red
    }
} while ([string]::IsNullOrWhiteSpace($License))

do {
    $Homepage = Read-Host "Homepage URL"
    if ([string]::IsNullOrWhiteSpace($Homepage) -or $Homepage -notmatch '^https?://') {
        Write-Host "  Error: Homepage must be a valid URL starting with http:// or https://" -ForegroundColor Red
    }
} while ([string]::IsNullOrWhiteSpace($Homepage) -or $Homepage -notmatch '^https?://')

do {
    $Version = Read-Host "Initial Version (e.g., 1.0.0)"
    if ([string]::IsNullOrWhiteSpace($Version) -or $Version -notmatch '^\d+\.\d+\.\d+$') {
        Write-Host "  Error: Version must match format X.Y.Z (e.g., 1.0.0)" -ForegroundColor Red
    }
} while ([string]::IsNullOrWhiteSpace($Version) -or $Version -notmatch '^\d+\.\d+\.\d+$')

# Create safe directory name
$DirName = $PluginIdentifier -replace '^com\.', '' -replace '\.', '_'

Write-Host "`nCreating plugin structure..." -ForegroundColor Yellow

# Create directory
$PluginDir = "packages\$DirName"

# Check if directory already exists
if (Test-Path $PluginDir) {
    Write-Host "`n  Warning: Directory '$PluginDir' already exists" -ForegroundColor Yellow
    $response = Read-Host "  Overwrite existing files? (y/N)"
    if ($response -ne 'y' -and $response -ne 'Y') {
        Write-Host "`n  Operation cancelled by user" -ForegroundColor Yellow
        exit 0
    }
}

try {
    New-Item -ItemType Directory -Path $PluginDir -Force -ErrorAction Stop | Out-Null
    Write-Host "  ✅ Created directory: $PluginDir" -ForegroundColor Green
} catch {
    Write-Host "  ❌ Error creating directory: $_" -ForegroundColor Red
    exit 1
}

# Create metadata.json template
$MetadataTemplate = @"
{
  "`$schema": "https://go.kicad.org/pcm/schemas/v1",
  "name": "$PluginName",
  "description": "$ShortDesc",
  "description_full": "TODO: Add detailed description here...",
  "identifier": "$PluginIdentifier",
  "type": "plugin",
  "author": {
    "name": "$Author",
    "contact": {
      "web": "$Homepage"
    }
  },
  "maintainer": {
    "name": "$Author",
    "contact": {
      "web": "$Homepage"
    }
  },
  "license": "$License",
  "resources": {
    "homepage": "$Homepage",
    "repository": "$Homepage.git"
  },
  "tags": [
    "TODO",
    "add",
    "tags"
  ],
  "versions": [
    {
      "version": "$Version",
      "status": "stable",
      "kicad_version": "8.0",
      "kicad_version_max": "9.99",
      "download_sha256": "",
      "download_size": 0,
      "download_url": "https://github.com/RolandWa/KiCAD-Plugin/releases/download/$DirName-v$Version/$DirName-$Version.zip",
      "install_size": 0,
      "platforms": [
        "linux",
        "macos",
        "windows"
      ],
      "python_requires": ">=3.8",
      "keep_on_update": []
    }
  ]
}
"@

# Write metadata.json
$MetadataPath = "$PluginDir\metadata.json"
try {
    $MetadataTemplate | Set-Content $MetadataPath -Encoding UTF8 -ErrorAction Stop
    Write-Host "  ✅ Created: $MetadataPath" -ForegroundColor Green
} catch {
    Write-Host "  ❌ Error creating metadata.json: $_" -ForegroundColor Red
    exit 1
}

# Create README template
$ReadmeTemplate = @"
# $PluginName

$ShortDesc

## Installation

Install via KiCAD Plugin Manager:

1. Add custom repository:
   - URL: \`https://raw.githubusercontent.com/RolandWa/KiCAD-Plugin/main/kicad-repository.json\`
2. Search for "$PluginName"
3. Click Install

## Usage

TODO: Add usage instructions

## Requirements

- KiCAD 8.0+
- Python 3.8+

## License

$License

## Author

$Author
"@

$ReadmePath = "$PluginDir\README.md"
try {
    $ReadmeTemplate | Set-Content $ReadmePath -Encoding UTF8 -ErrorAction Stop
    Write-Host "  ✅ Created: $ReadmePath" -ForegroundColor Green
} catch {
    Write-Host "  ❌ Error creating README.md: $_" -ForegroundColor Red
    exit 1
}

# Note about icon (don't create fake file)
$IconPath = "$PluginDir\icon.png"
Write-Host "  ⚠️  Icon placeholder: $IconPath (add 64x64 PNG manually)" -ForegroundColor Yellow

# Generate entry for kicad-repository.json
Write-Host "`n📋 Repository Entry (add to kicad-repository.json):" -ForegroundColor Cyan
$RepositoryEntry = @"

    {
      "name": "$PluginName",
      "description": "$ShortDesc",
      "identifier": "$PluginIdentifier",
      "type": "plugin",
      "author": "$Author",
      "license": "$License",
      "resources": {
        "homepage": "$Homepage"
      },
      "tags": ["TODO", "add", "tags"],
      "versions_url": "https://raw.githubusercontent.com/RolandWa/KiCAD-Plugin/main/packages/$DirName/metadata.json"
    }
"@

Write-Host $RepositoryEntry -ForegroundColor White

# Save to file
$EntryPath = "$PluginDir\repository_entry.json"
try {
    $RepositoryEntry | Set-Content $EntryPath -Encoding UTF8 -ErrorAction Stop
    Write-Host "`n  Saved to: $EntryPath" -ForegroundColor Gray
} catch {
    Write-Host "`n  ❌ Error saving repository entry: $_" -ForegroundColor Red
}

# Next steps
Write-Host "`n📝 Next Steps:" -ForegroundColor Cyan
Write-Host "  1. Edit $MetadataPath - Add detailed description and tags" -ForegroundColor White
Write-Host "  2. Create $IconPath - Add a real 64x64 PNG icon" -ForegroundColor White
Write-Host "  3. Add the content of $EntryPath to kicad-repository.json" -ForegroundColor White
Write-Host "  4. Build your plugin package (.zip)" -ForegroundColor White
Write-Host "  5. Create GitHub release with tag: $DirName-v$Version" -ForegroundColor White
Write-Host "  6. Update metadata.json with SHA256 and download URL" -ForegroundColor White
Write-Host "  7. Commit and push to repository" -ForegroundColor White

Write-Host "`n✅ Plugin structure created successfully!" -ForegroundColor Green
Write-Host ""
