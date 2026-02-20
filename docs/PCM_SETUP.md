# KiCAD Plugin and Content Manager (PCM) Setup Guide

**OpenFixture - PCM Installation Instructions**  
**Last Updated**: February 20, 2026

---

## 📖 Overview

OpenFixture can be installed via the **KiCAD Plugin and Content Manager (PCM)**, which provides one-click installation directly from within KiCAD. This is the recommended installation method for most users.

---

## 🎯 For Users: Installing via PCM

### Method 1: Official KiCAD PCM (Recommended)

Once OpenFixture is published to the official KiCAD repository:

1. **Open KiCAD PCB Editor**
2. **Go to**: `Plugin and Content Manager` (PCM)
   - Menu: `Tools → Plugin and Content Manager`
   - Or press `Ctrl+Shift+M` (Windows/Linux) or `Cmd+Shift+M` (macOS)
3. **Search for**: `OpenFixture`
4. **Click**: `Install`
5. **Restart KiCAD** PCB Editor
6. **Access plugin**: `Tools → External Plugins → OpenFixture Generator`

### Method 2: Custom Repository (Development/Testing)

To install from a custom repository (useful for testing or forks):

1. **Open KiCAD PCB Editor**
2. **Go to**: `Plugin and Content Manager`
3. **Click**: `Manage` → `Preferences` (gear icon)
4. **Add Custom Repository**:
   - Name: `OpenFixture Repository`
   - URL: `https://raw.githubusercontent.com/YOUR_USERNAME/openfixture/main/repository.json`
   - Click `Add` → `OK`
5. **Find OpenFixture** in the plugin list
6. **Click**: `Install`
7. **Restart KiCAD**

---

## 🛠️ For Maintainers: Publishing to PCM

### Prerequisites

- GitHub repository with releases enabled
- OpenSCAD installed (runtime dependency)
- PowerShell 5.0+ (for build script on Windows)

### Step 1: Prepare Package

```powershell
# Build PCM package
.\build_pcm_package.ps1 -Version "2.0.0" -UpdateMetadata

# This creates:
# - dist/openfixture-2.0.0.zip (plugin package)
# - Updated metadata.json with SHA256 hash
```

**What the script does**:
- ✅ Creates plugin directory structure
- ✅ Copies all required files (Python, OpenSCAD, configs, docs)
- ✅ Creates .zip archive
- ✅ Calculates SHA256 hash
- ✅ Updates metadata.json (if -UpdateMetadata flag used)

### Step 2: Create GitHub Release

1. **Tag the release**:
   ```bash
   git tag -a v2.0.0 -m "Release v2.0.0 - KiCAD 9.0+ compatible"
   git push origin v2.0.0
   ```

2. **Create GitHub Release**:
   - Go to: `https://github.com/YOUR_USERNAME/openfixture/releases/new`
   - Tag: `v2.0.0`
   - Title: `OpenFixture v2.0.0`
   - Description: See `RELEASE_NOTES.md` template below
   - Upload: `dist/openfixture-2.0.0.zip`
   - Click: `Publish release`

3. **Get the download URL**:
   - Right-click the uploaded .zip file
   - Copy link address (should be): 
     ```
     https://github.com/YOUR_USERNAME/openfixture/releases/download/v2.0.0/openfixture-2.0.0.zip
     ```

### Step 3: Update Metadata

Edit `metadata.json` and update the version entry:

```json
{
  "version": "2.0.0",
  "status": "stable",
  "kicad_version": "8.0",
  "kicad_version_max": "9.99",
  "download_sha256": "YOUR_SHA256_HASH_HERE",
  "download_size": 123456,
  "download_url": "https://github.com/YOUR_USERNAME/openfixture/releases/download/v2.0.0/openfixture-2.0.0.zip",
  "install_size": 123456,
  "platforms": ["linux", "macos", "windows"],
  "python_requires": ">=3.8"
}
```

**Get SHA256 hash**:
```powershell
# PowerShell
(Get-FileHash -Path dist\openfixture-2.0.0.zip -Algorithm SHA256).Hash.ToLower()

# Linux/macOS
shasum -a 256 dist/openfixture-2.0.0.zip
```

### Step 4: Commit and Push

```bash
git add metadata.json repository.json
git commit -m "Update PCM metadata for v2.0.0"
git push origin main
```

### Step 5: Test Installation

1. Add your repository to KiCAD PCM (see Method 2 above)
2. Install the plugin
3. Verify all files are present
4. Test with a sample board

### Step 6: Submit to Official KiCAD Repository

Once tested and stable:

1. **Fork** the official KiCAD repository:
   - https://github.com/kicad/kicad-addons

2. **Add your plugin**:
   - Create `packages/com.tinylabs.openfixture.json`
   - Copy your `metadata.json` content

3. **Submit Pull Request**:
   - Follow KiCAD submission guidelines
   - Include screenshots and testing notes
   - Wait for review

---

## 📁 PCM Package Structure

When installed via PCM, OpenFixture is extracted to:

```
KiCAD plugins directory/
└── com.tinylabs.openfixture/
    ├── plugins/
    │   ├── openfixture.py          # Main KiCAD plugin
    │   ├── GenFixture.py           # Core generator
    │   ├── __init__.py             # Python package init
    │   ├── openfixture.scad        # OpenSCAD template
    │   ├── fixture_config.toml     # Configuration template
    │   ├── osh_logo.dxf            # Logo file
    │   └── glaser-stencil-d.ttf    # Font for labels
    ├── resources/
    │   └── icon.png                # Plugin icon
    ├── README.md
    ├── LICENSE.md
    ├── MIGRATION_GUIDE.md
    ├── SECURITY.md
    ├── POGO_PINS.md
    └── metadata.json
```

**Plugin directory locations**:
- **Windows**: `%APPDATA%\kicad\9.0\3rdparty\plugins\`
- **Linux**: `~/.local/share/kicad/9.0/3rdparty/plugins/`
- **macOS**: `~/Library/Application Support/kicad/9.0/3rdparty/plugins/`

---

## 🔄 Updating the Plugin

### For Users

1. Open PCM in KiCAD
2. Check for updates (automatic or manual)
3. Click `Update` next to OpenFixture
4. Restart KiCAD

**Files preserved on update**:
- `fixture_config.toml` (your project-specific settings)
- `sync_to_kicad_config.ps1` (your personal paths)

### For Maintainers

1. Update version in `metadata.json` → add new version entry
2. Build new package: `.\build_pcm_package.ps1 -Version "2.1.0"`
3. Create new GitHub release with new .zip
4. Update metadata.json with new SHA256 and URL
5. Commit and push

---

## 🧪 Testing Checklist

Before releasing a new version:

- [ ] Package builds without errors
- [ ] SHA256 hash matches
- [ ] Plugin installs via PCM
- [ ] All files present in install directory
- [ ] Plugin shows in KiCAD menu
- [ ] Test point extraction works
- [ ] DXF generation succeeds
- [ ] OpenSCAD integration works
- [ ] Configuration files load properly
- [ ] Uninstall/reinstall works
- [ ] Update from previous version works

---

## 📝 Release Notes Template

Use this template for GitHub releases:

```markdown
# OpenFixture v2.0.0

**KiCAD 8.0 / 9.0+ Compatible PCB Test Fixture Generator**

## ✨ What's New

- Full KiCAD 9.0+ API compatibility
- Backward compatible with KiCAD 8.0
- Modern Python 3 codebase with type hints
- TOML configuration system
- Enhanced multi-tab UI
- Comprehensive error handling

## 📦 Installation

### Via KiCAD PCM (Recommended)
1. Open KiCAD PCB Editor
2. Tools → Plugin and Content Manager
3. Search for "OpenFixture"
4. Click Install

### Manual Installation
Download `openfixture-2.0.0.zip` and extract to your KiCAD plugins directory.

## 📋 Requirements

- **KiCAD** 8.0 or 9.0+
- **Python** 3.8+
- **OpenSCAD** 2015.03+

## 🔗 Documentation

- [User Guide](https://github.com/tinylabs/openfixture/blob/main/README.md)
- [Migration Guide](https://github.com/tinylabs/openfixture/blob/main/MIGRATION_GUIDE.md)
- [Pogo Pin Guide](https://github.com/tinylabs/openfixture/blob/main/POGO_PINS.md)

## 📜 License

CC-BY-SA-4.0

---

**Full Changelog**: https://github.com/tinylabs/openfixture/compare/v1.0.0...v2.0.0
```

---

## 🐛 Troubleshooting

### Plugin Not Showing in KiCAD

1. Verify installation directory
2. Check KiCAD version (8.0+ required)
3. Look for Python errors in KiCAD console
4. Verify OpenSCAD is installed

### PCM Installation Fails

1. Check internet connection
2. Verify repository URL
3. Check KiCAD version compatibility
4. Try manual installation

### Update Doesn't Work

1. Uninstall old version
2. Restart KiCAD
3. Install new version
4. Restore your config files

---

## 📚 Additional Resources

- **KiCAD PCM Documentation**: https://dev-docs.kicad.org/en/addons/
- **PCM Schema**: https://go.kicad.org/pcm/schemas/v1
- **Example Repository**: https://github.com/Bouni/bouni-kicad-repository

---

## 🤝 Contributing

To contribute improvements:

1. Fork the repository
2. Create feature branch
3. Test thoroughly
4. Submit pull request

---

**Questions?** Open an issue on GitHub: https://github.com/tinylabs/openfixture/issues
