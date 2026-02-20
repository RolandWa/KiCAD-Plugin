# Multi-Plugin Repository Deployment Guide

**Created**: February 20, 2026  
**Purpose**: Deploy unified KiCAD PCM repository hosting OpenFixture and EMC Auditor

---

## 📋 What Was Created

### Repository Structure Files

```text
✅ kicad-repository.json          - Main repository index (lists all plugins)
✅ REPOSITORY_README.md            - Repository documentation
✅ REPOSITORY_SETUP.md             - Complete setup and maintenance guide
✅ packages/openfixture/metadata.json    - OpenFixture plugin metadata
✅ packages/emc_auditor/metadata.json    - EMC Auditor plugin metadata
✅ scripts/add_new_plugin.ps1     - Helper script to add future plugins
```

### Build Scripts

```text
✅ build_pcm_package.ps1          - Build OpenFixture package
   (Need to create equivalent for EMC Auditor)
```

### Documentation

```text
✅ PCM_SETUP.md                   - PCM installation guide
✅ PCM_QUICKREF.md                - Quick reference
```

---

## 🚀 Step-by-Step Deployment

### Phase 1: Create GitHub Repository

#### Option A: New Repository (Recommended)

```bash
# 1. Create new repository on GitHub
# Name: KiCAD-Plugin
# Description: Custom KiCAD plugins for PCB design
# Public repository

# 2. Clone locally
git clone https://github.com/RolandWa/KiCAD-Plugin.git
cd KiCAD-Plugin

# 3. Copy repository files from openfixture project
Copy-Item kicad-repository.json ./
Copy-Item REPOSITORY_README.md ./README.md
Copy-Item REPOSITORY_SETUP.md ./
Copy-Item -Recurse packages ./
Copy-Item -Recurse scripts ./

# 4. Initialize and push
git add .
git commit -m "Initial repository setup with OpenFixture and EMC Auditor"
git push origin main
```

#### Option B: Use Existing OpenFixture Repository

```bash
# Add repository files to existing openfixture repo
# Users will add URL pointing to this repo
```

---

### Phase 2: Build OpenFixture Package

```powershell
# Navigate to OpenFixture project
cd path\to\openfixture

# Build package
.\build_pcm_package.ps1 -Version "2.0.0" -UpdateMetadata

# Output: dist/openfixture-2.0.0.zip
# Note the SHA256 hash displayed
```

**Package contains**:

- openfixture.py (plugin)
- GenFixture.py (core generator)
- openfixture.scad (OpenSCAD template)
- fixture_config.toml
- Documentation
- Icon

---

### Phase 3: Build EMC Auditor Package

**You need to create a build script for EMC Auditor similar to OpenFixture**:

```powershell
# In KiCAD_Custom_DRC project, create build_pcm_package.ps1
# Similar structure to OpenFixture build script

# Then build:
cd path\to\KiCAD_Custom_DRC
.\build_pcm_package.ps1 -Version "1.4.0" -UpdateMetadata

# Output: dist/emc_auditor-1.4.0.zip
```

**Package should contain**:

- emc_auditor_plugin.py
- via_stitching.py
- decoupling.py
- ground_plane.py
- clearance_creepage.py
- signal_integrity.py
- emi_filtering.py
- emc_rules.toml
- Documentation
- Icon

---

### Phase 4: Create GitHub Releases

#### For OpenFixture

```bash
# Tag release
git tag -a openfixture-v2.0.0 -m "OpenFixture v2.0.0 - KiCAD 9.0+ compatible"
git push origin openfixture-v2.0.0

# Create release on GitHub:
# 1. Go to https://github.com/RolandWa/KiCAD-Plugin/releases/new
# 2. Tag: openfixture-v2.0.0
# 3. Title: OpenFixture v2.0.0
# 4. Description: See release template below
# 5. Upload: dist/openfixture-2.0.0.zip
# 6. Publish
```

#### For EMC Auditor

```bash
# Tag release
git tag -a emc_auditor-v1.4.0 -m "EMC Auditor v1.4.0"
git push origin emc_auditor-v1.4.0

# Create release on GitHub (same process)
```

---

### Phase 5: Update Metadata with SHA256

#### OpenFixture

```powershell
# Get SHA256 (from build output or calculate)
$hash = (Get-FileHash -Path "dist\openfixture-2.0.0.zip" -Algorithm SHA256).Hash.ToLower()
$size = (Get-Item "dist\openfixture-2.0.0.zip").Length

Write-Host "SHA256: $hash"
Write-Host "Size: $size"
```

**Edit** `packages/openfixture/metadata.json`:

```json
{
  "version": "2.0.0",
  "download_sha256": "PASTE_SHA256_HERE",
  "download_size": 123456,
  "download_url": "https://github.com/RolandWa/KiCAD-Plugin/releases/download/openfixture-v2.0.0/openfixture-2.0.0.zip",
  "install_size": 123456
}
```

#### EMC Auditor

Same process - update `packages/emc_auditor/metadata.json`

---

### Phase 6: Commit Final Changes

```bash
# Add updated metadata
git add packages/openfixture/metadata.json
git add packages/emc_auditor/metadata.json
git commit -m "Update metadata with release URLs and SHA256 hashes"
git push origin main
```

---

### Phase 7: Test Installation

```text
1. Open KiCAD PCB Editor
2. Tools → Plugin and Content Manager
3. Manage → Preferences → Add Repository
4. Name: RolandWa Plugins
5. URL: https://raw.githubusercontent.com/RolandWa/KiCAD-Plugin/main/kicad-repository.json
6. Save → Search for plugins → Install
```

**Verify**:

- [ ] Both plugins appear in search
- [ ] Installation completes without errors
- [ ] Plugins appear in Tools → External Plugins menu
- [ ] Both plugins function correctly

---

## 📁 Final Repository Structure

```
KiCAD-Plugin/
├── README.md                     # Main documentation
├── REPOSITORY_SETUP.md          # Maintenance guide
├── kicad-repository.json        # PCM repository index
│
├── packages/
│   ├── openfixture/
│   │   ├── metadata.json       # ✅ SHA256 updated
│   │   ├── icon.png            # 64x64 PNG
│   │   └── README.md
│   │
│   └── emc_auditor/
│       ├── metadata.json       # ✅ SHA256 updated
│       ├── icon.png            # 64x64 PNG
│       └── README.md
│
├── scripts/
│   └── add_new_plugin.ps1      # Helper for future plugins
│
└── .github/
    └── workflows/
        └── validate.yml        # (Optional) CI validation
```

---

## 🔄 Adding Future Plugins

### Quick Process

```powershell
# Run helper script
.\scripts\add_new_plugin.ps1

# Follow prompts:
# - Plugin name
# - Identifier
# - Author
# - License
# - etc.

# Script creates:
# - packages/[plugin]/metadata.json
# - packages/[plugin]/README.md
# - Repository entry template
```

### Manual Process

See [REPOSITORY_SETUP.md](REPOSITORY_SETUP.md) for detailed instructions.

---

## 📝 Release Template

Use this for GitHub releases:

```markdown
# [Plugin Name] v[X.Y.Z]

[Short description]

## ✨ Features

- Feature 1
- Feature 2
- Feature 3

## 📦 Installation

### Via KiCAD PCM (Recommended)

1. Open KiCAD PCB Editor
2. Tools → Plugin and Content Manager
3. Add repository:
   - URL: `https://raw.githubusercontent.com/RolandWa/KiCAD-Plugin/main/kicad-repository.json`
4. Search: "[Plugin Name]"
5. Install

## 📋 Requirements

- KiCAD 8.0+
- Python 3.8+
- [Any other requirements]

## 🔗 Links

- [Documentation](URL)
- [Issues](URL)

## 📜 License

[LICENSE]
```

---

## 🧪 Testing Checklist

### Before Going Live

- [ ] **kicad-repository.json** is valid JSON
- [ ] **metadata.json** files are valid JSON
- [ ] All URLs are accessible
- [ ] SHA256 hashes are correct
- [ ] Download URLs point to real files
- [ ] Icons are present and valid PNG
- [ ] Repository URL works in browser
- [ ] Test installation in fresh KiCAD install

### After Going Live

- [ ] Monitor GitHub Issues
- [ ] Check download statistics
- [ ] Respond to user feedback
- [ ] Plan version updates

---

## 🔗 Important URLs

**Repository Index**:

```text
https://raw.githubusercontent.com/RolandWa/KiCAD-Plugin/main/kicad-repository.json
```

**Plugin Metadata**:

```text
https://raw.githubusercontent.com/RolandWa/KiCAD-Plugin/main/packages/openfixture/metadata.json
https://raw.githubusercontent.com/RolandWa/KiCAD-Plugin/main/packages/emc_auditor/metadata.json
```

**Releases**:

```text
https://github.com/RolandWa/KiCAD-Plugin/releases
```

---

## 🆘 Troubleshooting

### "Repository not found" in PCM

- Verify URL is correct
- Check repository is public
- Ensure kicad-repository.json exists at root

### "Invalid metadata" error

- Validate JSON syntax: <https://jsonlint.com>
- Check required fields are present
- Verify $schema URL

### "Download failed" error

- Verify release exists on GitHub
- Check download_url in metadata.json
- Ensure .zip file uploaded correctly

### SHA256 mismatch

- Recalculate hash from actual .zip file
- Update metadata.json
- Commit and push changes

---

## 📞 Support

**Issues**:

- Repository: <https://github.com/RolandWa/KiCAD-Plugin/issues>
- OpenFixture: <https://github.com/tinylabs/openfixture/issues>
- EMC Auditor: <https://github.com/RolandWa/KiCAD_Custom_DRC/issues>

---

## ✅ Deployment Complete

Once all steps are done:

1. ✅ Repository created and configured
2. ✅ Both plugins built and packaged
3. ✅ GitHub releases created
4. ✅ Metadata updated with SHA256
5. ✅ Installation tested
6. ✅ Documentation complete

**Users can now install with one click from PCM!** 🎉

---

**Next Steps**:

- Announce on KiCAD forums
- Share repository URL
- Monitor feedback
- Plan next updates
