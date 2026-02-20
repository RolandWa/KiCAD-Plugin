# OpenFixture PCM Installation - Quick Reference

## 🚀 For Users

### Install from KiCAD Plugin Manager

```
1. Open KiCAD PCB Editor
2. Tools → Plugin and Content Manager (Ctrl+Shift+M)
3. Search: "OpenFixture"
4. Click: Install
5. Restart KiCAD
```

**Plugin Location**: `Tools → External Plugins → OpenFixture Generator`

### Add Custom Repository

If installing from a fork or development version:

```
1. Plugin and Content Manager → Manage (gear icon)
2. Add Repository:
   - Name: OpenFixture Repository
   - URL: https://raw.githubusercontent.com/YOUR_USERNAME/openfixture/main/repository.json
3. Save → Search for OpenFixture → Install
```

---

## 🛠️ For Maintainers

### Build & Release Workflow

```powershell
# 1. Build package
.\build_pcm_package.ps1 -Version "2.0.0" -UpdateMetadata

# 2. Create GitHub release
git tag -a v2.0.0 -m "Release v2.0.0"
git push origin v2.0.0

# Upload dist/openfixture-2.0.0.zip to GitHub release

# 3. Update metadata.json
# - Add download_url from GitHub release
# - Verify SHA256 hash (from build script output)
# - Verify download_size

# 4. Commit and push
git add metadata.json repository.json
git commit -m "Update PCM metadata for v2.0.0"
git push origin main
```

### Files Created

```
metadata.json        - Plugin metadata for PCM
repository.json      - Repository index
build_pcm_package.ps1 - Build script
resources/icon.png   - Plugin icon
PCM_SETUP.md        - Full documentation
```

---

## 📋 Checklist

**Before Release:**
- [ ] Version number updated in metadata.json
- [ ] All tests pass
- [ ] Documentation updated
- [ ] CHANGELOG.md updated

**Release Process:**
- [ ] Build package with build_pcm_package.ps1
- [ ] Create GitHub tag and release
- [ ] Upload .zip file
- [ ] Update metadata.json with SHA256 and URL
- [ ] Commit and push metadata.json
- [ ] Test installation via PCM

**After Release:**
- [ ] Announce on KiCAD forums
- [ ] Update README with new features
- [ ] Close resolved issues

---

## 🔗 Links

- **PCM Schema**: https://go.kicad.org/pcm/schemas/v1
- **KiCAD Docs**: https://dev-docs.kicad.org/en/addons/
- **Example Repo**: https://github.com/Bouni/bouni-kicad-repository

---

See [PCM_SETUP.md](PCM_SETUP.md) for complete documentation.
