# Multi-Plugin KiCAD Repository Setup Guide

**RolandWa KiCAD Plugins Repository**  
**Date**: February 20, 2026

---

## 📖 Overview

This repository hosts multiple KiCAD plugins in a unified Plugin and Content Manager (PCM) repository, making it easy to install and manage all plugins from a single source.

**Currently hosted plugins:**

1. **OpenFixture** - PCB test fixture generator
2. **EMC Auditor** - Advanced DRC with EMC/signal integrity checks

---

## 🎯 For Users: Installing Plugins

### Method 1: Add Custom Repository (One-Time Setup)

1. **Open KiCAD PCB Editor**
2. **Go to**: `Tools → Plugin and Content Manager` (Ctrl+Shift+M)
3. **Click**: Manage → Preferences (gear icon)
4. **Add Custom Repository**:
   - Name: `RolandWa Plugins`
   - URL: `https://raw.githubusercontent.com/RolandWa/KiCAD-Plugin/main/kicad-repository.json`
   - Click `Add` → `OK`

### Method 2: Install Individual Plugins

Once the repository is added, you can install any plugin:

1. **Search** for the plugin name (e.g., "OpenFixture" or "EMC Auditor")
2. **Click**: `Install`
3. **Restart** KiCAD PCB Editor
4. **Access** the plugin from the appropriate menu

**Plugin Locations:**

- **OpenFixture**: `Tools → External Plugins → OpenFixture Generator`
- **EMC Auditor**: `Tools → External Plugins → EMC Auditor`

---

## 🗂️ Repository Structure

```
KiCAD-Plugin/
├── kicad-repository.json              # Main repository index
├── README.md                          # Repository documentation
├── REPOSITORY_SETUP.md               # This file
│
├── packages/
│   ├── openfixture/
│   │   ├── metadata.json            # OpenFixture plugin metadata
│   │   ├── icon.png                 # Plugin icon (64x64 recommended)
│   │   └── README.md                # Plugin-specific readme
│   │
│   ├── emc_auditor/
│   │   ├── metadata.json            # EMC Auditor plugin metadata
│   │   ├── icon.png                 # Plugin icon
│   │   └── README.md                # Plugin-specific readme
│   │
│   └── [future_plugin]/
│       ├── metadata.json
│       ├── icon.png
│       └── README.md
│
├── releases/                         # Plugin releases (.zip files)
│   ├── openfixture-2.0.0.zip
│   ├── emc_auditor-1.4.0.zip
│   └── ...
│
└── scripts/
    ├── build_openfixture.ps1        # Build script for OpenFixture
    ├── build_emc_auditor.ps1        # Build script for EMC Auditor
    └── add_new_plugin.ps1           # Helper script to add new plugins
```

---

## 🛠️ For Maintainers: Managing the Repository

### Initial Setup

1. **Create a new GitHub repository** (or use existing):

   ```bash
   # Example: https://github.com/RolandWa/KiCAD-Plugin
   git clone https://github.com/RolandWa/KiCAD-Plugin.git
   cd KiCAD-Plugin
   ```

2. **Copy repository structure**:

   ```powershell
   # Copy from openfixture project
   Copy-Item kicad-repository.json ./
   Copy-Item -Recurse packages ./
   Copy-Item REPOSITORY_SETUP.md ./
   ```

3. **Enable GitHub Releases** in repository settings

### Adding a New Plugin

#### Step 1: Create Plugin Package

For **OpenFixture**:

```powershell
cd path/to/openfixture
.\build_pcm_package.ps1 -Version "2.0.0" -UpdateMetadata
```

For **EMC Auditor**:

```powershell
cd path/to/KiCAD_Custom_DRC
.\build_pcm_package.ps1 -Version "1.4.0" -UpdateMetadata
```

#### Step 2: Create GitHub Release

```bash
# Tag the specific plugin version
git tag -a openfixture-v2.0.0 -m "OpenFixture v2.0.0"
git push origin openfixture-v2.0.0

# Or for EMC Auditor
git tag -a emc_auditor-v1.4.0 -m "EMC Auditor v1.4.0"
git push origin emc_auditor-v1.4.0
```

**Create Release on GitHub**:

1. Go to: `https://github.com/RolandWa/KiCAD-Plugin/releases/new`
2. Select tag: `openfixture-v2.0.0` (or appropriate tag)
3. Title: `OpenFixture v2.0.0` (or appropriate)
4. Upload: `dist/openfixture-2.0.0.zip`
5. Publish release

#### Step 3: Update Plugin Metadata

```powershell
# Get SHA256 hash
$hash = (Get-FileHash -Path dist/openfixture-2.0.0.zip -Algorithm SHA256).Hash.ToLower()
$size = (Get-Item dist/openfixture-2.0.0.zip).Length

Write-Host "SHA256: $hash"
Write-Host "Size: $size bytes"
```

**Edit** `packages/openfixture/metadata.json`:

```json
{
  "version": "2.0.0",
  "download_sha256": "YOUR_SHA256_HERE",
  "download_size": 123456,
  "download_url": "https://github.com/RolandWa/KiCAD-Plugin/releases/download/openfixture-v2.0.0/openfixture-2.0.0.zip",
  "install_size": 123456
}
```

#### Step 4: Commit and Push

```bash
git add packages/openfixture/metadata.json
git add kicad-repository.json  # if modified
git commit -m "Update OpenFixture to v2.0.0"
git push origin main
```

### Adding a BRAND NEW Plugin

#### Step 1: Create Plugin Directory

```powershell
# Create structure
New-Item -ItemType Directory -Path "packages/new_plugin" -Force
```

#### Step 2: Create metadata.json

```json
{
  "$schema": "https://go.kicad.org/pcm/schemas/v1",
  "name": "Your Plugin Name",
  "description": "Short description",
  "description_full": "Detailed description...",
  "identifier": "com.yourname.plugin_identifier",
  "type": "plugin",
  "author": {
    "name": "Your Name",
    "contact": {
      "web": "https://yourwebsite.com"
    }
  },
  "license": "MIT",
  "resources": {
    "homepage": "https://github.com/YourName/your-plugin",
    "repository": "https://github.com/YourName/your-plugin.git"
  },
  "tags": ["tag1", "tag2"],
  "versions": [
    {
      "version": "1.0.0",
      "status": "stable",
      "kicad_version": "8.0",
      "kicad_version_max": "9.99",
      "download_sha256": "",
      "download_size": 0,
      "download_url": "https://github.com/RolandWa/KiCAD-Plugin/releases/download/plugin-v1.0.0/plugin-1.0.0.zip",
      "install_size": 0,
      "platforms": ["linux", "macos", "windows"],
      "python_requires": ">=3.8"
    }
  ]
}
```

#### Step 3: Add to Repository Index

**Edit** `kicad-repository.json`:
```json
{
  "packages": [
    {
      "name": "Your Plugin Name",
      "description": "Short description",
      "identifier": "com.yourname.plugin_identifier",
      "type": "plugin",
      "author": "Your Name",
      "license": "MIT",
      "resources": {
        "homepage": "https://github.com/YourName/your-plugin"
      },
      "tags": ["tag1", "tag2"],
      "versions_url": "https://raw.githubusercontent.com/RolandWa/KiCAD-Plugin/main/packages/new_plugin/metadata.json"
    }
  ]
}
```

#### Step 4: Build and Release

Follow the standard release process (Steps 1-4 above).

---

## 📋 Plugin Development Checklist

### Before Adding to Repository

- [ ] Plugin works in KiCAD 8.0+
- [ ] Python 3.8+ compatible
- [ ] All dependencies documented
- [ ] README.md with usage instructions
- [ ] LICENSE file included
- [ ] Icon created (64x64 PNG recommended)
- [ ] Build script creates proper .zip structure
- [ ] Tested installation via PCM

### Repository Files to Update

- [ ] `packages/[plugin_name]/metadata.json` - Plugin metadata
- [ ] `kicad-repository.json` - Add to packages list
- [ ] `packages/[plugin_name]/icon.png` - Plugin icon
- [ ] `packages/[plugin_name]/README.md` - Plugin documentation
- [ ] GitHub Release created with .zip file
- [ ] SHA256 hash calculated and added to metadata
- [ ] Download URL updated in metadata

### After Addition

- [ ] Test installation from custom repository
- [ ] Verify plugin appears in PCM
- [ ] Test plugin functionality
- [ ] Update repository README with new plugin
- [ ] Announce on KiCAD forums (optional)

---

## 🔄 Update Workflow

### Updating Existing Plugin

1. **Build new version**:
   ```powershell
   .\build_pcm_package.ps1 -Version "2.1.0" -UpdateMetadata
   ```

2. **Create GitHub release** with new tag

3. **Update metadata.json**:
   - Add new version to `versions` array (keep old versions)
   - Update SHA256 and download URL

4. **Commit and push**

5. **Users see update** in PCM automatically

### Version Strategy

**Recommended approach**: Keep 2-3 recent versions in metadata
```json
"versions": [
  {
    "version": "2.1.0",
    "status": "stable",
    ...
  },
  {
    "version": "2.0.0",
    "status": "stable",
    ...
  }
]
```

---

## 🧪 Testing

### Test Local Repository

```powershell
# Start a local HTTP server
python -m http.server 8000

# Add repository in KiCAD PCM:
# URL: http://localhost:8000/kicad-repository.json
```

### Test Remote Repository

Use GitHub Pages or GitHub raw URLs:
```
https://raw.githubusercontent.com/RolandWa/KiCAD-Plugin/main/kicad-repository.json
```

---

## 📊 Repository Statistics

| Plugin | Version | Status | Downloads | Last Update |
|--------|---------|--------|-----------|-------------|
| OpenFixture | 2.0.0 | ✅ Stable | - | 2026-02-20 |
| EMC Auditor | 1.4.0 | ✅ Stable | - | 2026-02-20 |

---

## 🤝 Contributing

To suggest a new plugin for this repository:

1. **Fork** this repository
2. **Add** your plugin following the structure above
3. **Test** installation via PCM
4. **Submit** pull request with:
   - Plugin metadata
   - Icon (64x64 PNG)
   - README
   - Test results

---

## 📚 Resources

- **KiCAD PCM Documentation**: https://dev-docs.kicad.org/en/addons/
- **PCM Schema**: https://go.kicad.org/pcm/schemas/v1
- **Bouni's Repository (Example)**: https://github.com/Bouni/bouni-kicad-repository
- **Official KiCAD Addons**: https://github.com/kicad/kicad-addons

---

## 📝 License

This repository structure: MIT License  
Individual plugins: See respective LICENSE files

---

## 🐛 Troubleshooting

### Repository Not Showing in PCM

- Verify JSON is valid (use https://jsonlint.com)
- Check URL is accessible (test in browser)
- Ensure CORS headers allow access

### Plugin Not Installing

- Verify download URL is correct
- Check SHA256 hash matches
- Confirm `kicad_version` compatibility
- Review KiCAD console for error messages

### Updates Not Appearing

- Clear PCM cache: Delete `~/.kicad/[version]/pcm/cache/`
- Restart KiCAD
- Re-add repository

---

**Questions?** Open an issue: https://github.com/RolandWa/KiCAD-Plugin/issues
