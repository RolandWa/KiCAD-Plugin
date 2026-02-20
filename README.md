# RolandWa KiCAD Plugins Repository

Custom KiCAD plugins for PCB design, testing, and manufacturing

[![License](https://img.shields.io/badge/license-Various-blue)](LICENSE)
[![KiCAD](https://img.shields.io/badge/KiCAD-8.0%20%7C%209.0+-blue)](https://www.kicad.org/)

---

## 📦 Available Plugins

### 1. OpenFixture

Automated PCB test fixture generator

- ✅ Laser-cuttable fixture designs with DXF output
- ✅ Automatic pogo pin placement
- ✅ TOML configuration system
- ✅ OpenSCAD integration for 3D preview
- ✅ Support for SMD and PTH test points

[Documentation](packages/openfixture/README.md) | [GitHub](https://github.com/tinylabs/openfixture)

**Version**: 2.0.0 | **License**: CC-BY-SA-4.0

---

### 2. EMC Auditor (Custom DRC)

Advanced EMC and signal integrity design rule checker

- ✅ Via stitching analysis
- ✅ Decoupling capacitor placement verification
- ✅ Ground plane continuity checking
- ✅ IEC60664-1 clearance/creepage checking
- ✅ EMI filter validation
- ✅ Signal integrity framework

[Documentation](packages/emc_auditor/README.md) | [GitHub](https://github.com/RolandWa/KiCAD_Custom_DRC)

**Version**: 1.4.0 | **License**: MIT

---

## 🚀 Installation

### Step 1: Add Custom Repository

1. **Open KiCAD PCB Editor**
2. Go to: `Tools → Plugin and Content Manager` (Ctrl+Shift+M)
3. Click: **Manage** → **Preferences** (gear icon)
4. Click: **Add Repository**
5. Enter:
   - **Name**: `RolandWa Plugins`
   - **URL**: `https://raw.githubusercontent.com/RolandWa/KiCAD-Plugin/main/kicad-repository.json`
6. Click: **Add** → **OK**

### Step 2: Install Plugins

1. Search for the plugin you want (e.g., "OpenFixture" or "EMC Auditor")
2. Click: **Install**
3. Restart KiCAD
4. Access from: `Tools → External Plugins → [Plugin Name]`

---

## 📊 Plugin Comparison

| Feature     | OpenFixture             | EMC Auditor              |
| --------- | --------------------- | ---------------------- |
| **Purpose** | Test fixture generation | DRC / EMC compliance |
| **Primary Use** | Manufacturing | Design validation |
| **Output** | DXF files for laser cutting | Visual markers + HTML reports |
| **Configuration** | TOML-based | TOML-based |
| **External Tools** | OpenSCAD required | None |
| **Best For** | Production testing | EMC/SI compliance |

---

## 🛠️ Requirements

**All Plugins:**

- KiCAD 8.0 or 9.0+
- Python 3.8+

**OpenFixture Only:**

- OpenSCAD 2015.03+
- Laser cutter access (or service)

---

## 📚 Documentation

- [Repository Setup Guide](REPOSITORY_SETUP.md) - For maintainers
- [PCM Installation Guide](PCM_SETUP.md) - Detailed installation
- [Adding New Plugins](REPOSITORY_SETUP.md#adding-a-brand-new-plugin)

---

## 🔄 Updates

Plugins are **automatically updated** when source repositories release new versions!

**Automated Process:**

- 🤖 **GitHub Actions** monitors source repositories daily
- 📦 **Auto-builds** plugin packages when updates detected
- 🚀 **Auto-publishes** to KiCAD Plugin Manager
- 💡 **You get notified** in KiCAD when updates are available

**Update frequency:**

- Security fixes: As needed (automated within 24 hours)
- Feature updates: Following source repository releases
- Bug fixes: Automated deployment after source fix

See [AUTOMATION_GUIDE.md](AUTOMATION_GUIDE.md) for technical details.

---

## 🤝 Contributing

### Suggest a Plugin

Have a plugin to add? See [REPOSITORY_SETUP.md](REPOSITORY_SETUP.md#adding-a-brand-new-plugin)

### Report Issues

- **OpenFixture**: [GitHub Issues](https://github.com/tinylabs/openfixture/issues)
- **EMC Auditor**: [GitHub Issues](https://github.com/RolandWa/KiCAD_Custom_DRC/issues)
- **Repository**: [GitHub Issues](https://github.com/RolandWa/KiCAD-Plugin/issues)

---

## 📜 License

- **Repository structure**: MIT License
- **Individual plugins**: See respective licenses
  - OpenFixture: CC-BY-SA-4.0
  - EMC Auditor: MIT

---

## 🔗 Links

- **KiCAD**: <https://www.kicad.org/>
- **PCM Documentation**: <https://dev-docs.kicad.org/en/addons/>
- **OpenFixture**: <https://github.com/tinylabs/openfixture>
- **EMC Auditor**: <https://github.com/RolandWa/KiCAD_Custom_DRC>

---

## 📞 Contact

**Maintainer**: Roland W  
**GitHub**: [@RolandWa](https://github.com/RolandWa)

---

## ⭐ Star History

If these plugins help you, consider starring the repository!

[![Star History](https://img.shields.io/github/stars/RolandWa/KiCAD-Plugin?style=social)](https://github.com/RolandWa/KiCAD-Plugin/stargazers)

---

**Last Updated**: February 20, 2026
