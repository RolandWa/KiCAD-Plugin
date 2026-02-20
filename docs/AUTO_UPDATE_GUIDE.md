# Repository Auto-Update System

Complete guide to the automated plugin management system for the KiCAD Plugin Repository.

---

## 🎯 Overview

Your repository uses a **semi-automated** workflow system:

- **Automatic**: Workflows detect updates, build packages, create releases
- **Manual**: You sync metadata changes to the repository index files

This two-step approach ensures you control what gets published while automating the heavy lifting.

---

## 📋 How It Works

### Step 1: Automatic (GitHub Actions)

**Triggers:**
- ⏰ **Scheduled**: Daily at 2 AM UTC
- 🔘 **Manual**: Via GitHub Actions web UI
- 🔔 **Dispatch**: From source repository webhooks (future)

**What Happens:**
1. Workflow checks source repository for new version
2. Compares with current version in `packages/[plugin]/metadata.json`
3. If different:
   - Downloads source code
   - Builds plugin package (.zip)
   - Calculates SHA256 hash
   - Creates GitHub release
   - Updates `packages/[plugin]/metadata.json`
   - Commits back to repository

**Result**: New plugin package published at:
```
https://github.com/RolandWa/KiCAD-Plugin/releases/tag/[plugin]-v[version]
```

---

### Step 2: Manual (PowerShell Scripts)

After workflow completes, you run:

```powershell
.\scripts\sync-package-metadata.ps1 -PluginName "plugin_name"
```

**What This Does:**
1. Pulls workflow changes from GitHub
2. Reads new version from `packages/[plugin]/metadata.json`
3. Updates `packages.json` with the new version
4. Pushes `packages.json` to GitHub
5. Downloads GitHub version and calculates hash
6. Updates `kicad-repository.json` with:
   - New `sha256` hash
   - Updated timestamp
7. Commits and pushes final changes

**Result**: Repository index updated, users can install new version via KiCAD PCM.

---

## 🚀 Usage Examples

### Scenario 1: After Manual Workflow Run

You manually triggered a workflow for EMC Auditor:

```bash
# Trigger via GitHub CLI
gh workflow run update-emc-auditor.yml -f version=1.5.0 -f source_tag=v1.5.0

# Wait for workflow to complete (check Actions tab)
# Then sync:
.\scripts\sync-package-metadata.ps1 -PluginName "emc_auditor"
```

### Scenario 2: After Scheduled Run

Morning after 2 AM UTC, check if workflows ran:

```powershell
# Check all plugins for updates
.\scripts\sync-all-plugins.ps1 -WhatIf

# If updates found, sync them
.\scripts\sync-all-plugins.ps1
```

### Scenario 3: Multiple Plugins Updated

Both workflows ran overnight:

```powershell
# Sync all at once
.\scripts\sync-all-plugins.ps1
```

---

## 📂 File Structure

```
KiCAD-Plugin/
├── kicad-repository.json       # Main index (users add this URL to KiCAD)
├── packages.json               # Full package definitions
├── packages/
│   ├── emc_auditor/
│   │   ├── metadata.json       # Updated by workflow
│   │   ├── README.md
│   │   └── icon.png
│   └── openfixture/
│       ├── metadata.json       # Updated by workflow
│       ├── README.md
│       └── icon.png
├── .github/workflows/
│   ├── update-emc-auditor.yml  # Auto-build workflow
│   ├── update-openfixture.yml  # Auto-build workflow
│   └── validate.yml            # Repository validation
└── scripts/
    ├── sync-package-metadata.ps1  # Sync single plugin
    ├── sync-all-plugins.ps1       # Sync all plugins
    └── add_new_plugin.ps1         # Add new plugin
```

---

## 🔄 Update Flow Diagram

```
Source Repo Update
       ↓
[Workflow Triggers]
       ↓
┌─────────────────────┐
│ GitHub Actions      │
│ 1. Detect version   │
│ 2. Build package    │
│ 3. Create release   │
│ 4. Update metadata  │
└─────────────────────┘
       ↓
   [You Run Script]
       ↓
┌─────────────────────┐
│ PowerShell Script   │
│ 1. Sync to packages │
│ 2. Update repo hash │
│ 3. Push changes     │
└─────────────────────┘
       ↓
Users can install!
```

---

## 📊 Monitoring Workflows

### Check Workflow Status

**Via GitHub Web**:
1. Go to: https://github.com/RolandWa/KiCAD-Plugin/actions
2. View recent runs
3. Click run to see logs

**Via GitHub CLI**:
```bash
# List recent runs
gh run list --limit 10

# View specific run
gh run view <run-id>

# View logs
gh run view <run-id> --log

# Watch real-time
gh run watch
```

### Workflow Outcomes

| Output | Meaning | Action Needed |
|--------|---------|---------------|
| `should_release=true` | New version detected | Run sync script |
| `should_release=false` | Already up-to-date | No action needed |
| `✓ Release ready` | Package published | Run sync script |
| `❌ Build failed` | Error occurred | Check logs |

---

## 🛠️ Script Reference

### sync-package-metadata.ps1

**Purpose**: Sync a single plugin after workflow update

**Parameters**:
- `-PluginName` (required): Plugin folder name
- `-SkipPull`: Skip git pull (if already pulled)

**Example**:
```powershell
.\scripts\sync-package-metadata.ps1 -PluginName "emc_auditor"
```

**Output**:
```
=== Plugin Repository Metadata Sync ===
Plugin: emc_auditor

[1/6] Pulling latest changes from GitHub...
[2/6] Reading plugin metadata...
[3/6] Updating packages.json...
[4/6] Committing and pushing packages.json...
[5/6] Calculating GitHub packages.json hash...
[6/6] Updating kicad-repository.json...

=== Sync Complete! ===
```

---

### sync-all-plugins.ps1

**Purpose**: Check and sync all plugins that need updates

**Parameters**:
- `-WhatIf`: Preview changes without applying

**Example**:
```powershell
# Check what would be synced
.\scripts\sync-all-plugins.ps1 -WhatIf

# Actually sync
.\scripts\sync-all-plugins.ps1
```

**Output**:
```
=== Syncing All Plugins ===

Checking plugins for updates...
  ✓ emc_auditor - Update available: v1.0.0 → v1.5.0
  • openfixture - Up to date (v2.0.0)

Found 1 plugin(s) to sync:
  - emc_auditor

[Runs sync-package-metadata.ps1 for each]
```

---

## ⚙️ Configuration

### Workflow Settings

**Change update schedule** (`.github/workflows/update-*.yml`):
```yaml
schedule:
  - cron: '0 2 * * *'      # Daily at 2 AM UTC
  # - cron: '0 */6 * * *'  # Every 6 hours
  # - cron: '0 0 * * 1'    # Weekly Monday midnight
```

**Change source repository**:
```yaml
env:
  SOURCE_REPO: RolandWa/openfixture  # Change this
```

**Change default branch**:
```yaml
ref: ${{ github.event.inputs.source_tag || 'master' }}  # Change 'master'
```

---

## 🆘 Troubleshooting

### Issue: "Workflow failed with exit code 1"

**Cause**: Source repository branch doesn't exist

**Solution**: Check workflow branch setting matches source repo:
```bash
# Check source repo branches
git ls-remote https://github.com/USER/REPO.git

# Update workflow ref to match (main, master, etc.)
```

---

### Issue: "Plugin 'xyz' not found in packages.json"

**Cause**: Plugin not added to packages.json yet

**Solution**: 
```powershell
# Add plugin first
.\scripts\add_new_plugin.ps1 -PluginName "xyz" -Identifier "com.example.xyz" -SourceRepo "user/repo"
```

---

### Issue: "Hash mismatch in KiCAD PCM"

**Cause**: Local vs. GitHub line ending differences

**Solution**: Script automatically downloads from GitHub to get correct hash. If still fails:
```powershell
# Force re-sync
git pull origin main
.\scripts\sync-package-metadata.ps1 -PluginName "plugin_name"
```

---

### Issue: "No version change detected"

**Cause**: Workflow sees same version in source and metadata

**Solution**: This is normal! It means:
- Source repo hasn't released new version
- Already up-to-date
- No action needed

---

## 🎓 Best Practices

### Daily Workflow

1. **Morning Check** (after 2 AM UTC):
   ```powershell
   git pull origin main
   .\scripts\sync-all-plugins.ps1 -WhatIf
   ```

2. **If Updates Found**:
   ```powershell
   .\scripts\sync-all-plugins.ps1
   ```

3. **Verify**:
   - Check GitHub releases exist
   - Test in KiCAD PCM (optional)

### Manual Updates

1. **Trigger Workflow**:
   - Go to Actions tab
   - Select workflow
   - Click "Run workflow"
   - Enter version & tag

2. **Wait for Completion** (2-5 minutes)

3. **Sync Metadata**:
   ```powershell
   .\scripts\sync-package-metadata.ps1 -PluginName "plugin_name"
   ```

### Adding New Plugins

1. **Add to Repository**:
   ```powershell
   .\scripts\add_new_plugin.ps1 -PluginName "new_plugin" -Identifier "com.example.new" -SourceRepo "user/repo"
   ```

2. **Create Workflow** (copy and modify existing)

3. **Test Manually**:
   ```bash
   gh workflow run update-new-plugin.yml -f version=1.0.0 -f source_tag=v1.0.0
   ```

---

## 📖 Related Documentation

- **Setup Guide**: [AUTOMATION_SETUP_COMPLETE.md](AUTOMATION_SETUP_COMPLETE.md)
- **Quick Reference**: [QUICK_REFERENCE.md](QUICK_REFERENCE.md)
- **Repository Setup**: [REPOSITORY_SETUP.md](REPOSITORY_SETUP.md)
- **Full Automation Guide**: [AUTOMATION_GUIDE.md](AUTOMATION_GUIDE.md)

---

## 🔗 Repository URL

Add this to KiCAD Plugin Manager:
```
https://raw.githubusercontent.com/RolandWa/KiCAD-Plugin/main/kicad-repository.json
```

---

**Last Updated**: February 20, 2026
