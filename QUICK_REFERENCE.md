# GitHub Actions Quick Reference Card

**KiCAD Plugin Repository Automation**

---

## 🚀 Quick Commands

### Trigger Manual Update

**OpenFixture**:
```bash
gh workflow run update-openfixture.yml -f version=2.0.1 -f source_tag=v2.0.1
```

**EMC Auditor**:
```bash
gh workflow run update-emc-auditor.yml -f version=1.4.1 -f source_tag=v1.4.1
```

**Validate Repository**:
```bash
gh workflow run validate.yml
```

---

## 📊 Monitoring

**List recent runs**:
```bash
gh run list --limit 10
```

**View specific run**:
```bash
gh run view <run-id>
```

**View logs**:
```bash
gh run view <run-id> --log
```

**Watch run**:
```bash
gh run watch
```

---

## ⚙️ Configuration Locations

| Setting | File | Line |
| --- | --- | --- |
| OpenFixture source repo | `.github/workflows/update-openfixture.yml` | Line 19 |
| EMC Auditor source repo | `.github/workflows/update-emc-auditor.yml` | Line 19 |
| Update schedule | Both workflow files | Line 16 |
| Package build logic | Both workflow files | Line ~85 |

---

## 🔄 Update Schedule

**Current**: Daily at 2 AM UTC

**Change schedule**:
```yaml
schedule:
  - cron: '0 2 * * *'      # Daily at 2 AM
  # - cron: '0 */6 * * *'  # Every 6 hours
  # - cron: '0 0 * * 1'    # Weekly Monday
```

---

## ✅ Setup Checklist

- [ ] Enable GitHub Actions (Settings → Actions → General)
- [ ] Set "Read and write permissions" (Settings → Actions → Workflow permissions)
- [ ] Test validation: `gh workflow run validate.yml`
- [ ] Commit workflows to repository
- [ ] Push to GitHub
- [ ] Verify workflows appear in Actions tab
- [ ] Test manual trigger with real version
- [ ] Monitor first automatic run

---

## 📖 Documentation

- **Full Guide**: [AUTOMATION_GUIDE.md](AUTOMATION_GUIDE.md)
- **Setup Summary**: [AUTOMATION_SETUP_COMPLETE.md](AUTOMATION_SETUP_COMPLETE.md)
- **Repository Setup**: [REPOSITORY_SETUP.md](REPOSITORY_SETUP.md)

---

## 🆘 Common Issues

**"Workflow not found"**:
- Ensure .yml files are in `.github/workflows/`
- Check files are committed and pushed

**"Permission denied"**:
- Settings → Actions → Workflow permissions
- Enable "Read and write permissions"

**"No version change"**:
- Normal - means already up-to-date
- No action taken (expected behavior)

**"Build failed"**:
- Check source repository is accessible
- Verify file paths match source structure
- Review workflow logs for details

---

## 🔗 Useful Links

- **Actions Tab**: `https://github.com/OWNER/REPO/actions`
- **Workflow Runs**: `https://github.com/OWNER/REPO/actions/workflows/FILE.yml`
- **GitHub Actions Docs**: <https://docs.github.com/actions>

---

**Last Updated**: February 20, 2026
