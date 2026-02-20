# EMC Auditor (Custom DRC)

**Advanced EMC and signal integrity design rule checker**

[![License](https://img.shields.io/badge/license-MIT-blue)](https://opensource.org/licenses/MIT)
[![KiCAD](https://img.shields.io/badge/KiCAD-8.0%20%7C%209.0+-blue)](https://www.kicad.org/)

---

## 📖 Overview

EMC Auditor is a sophisticated Design Rule Check (DRC) plugin for KiCAD that performs automated electromagnetic compatibility (EMC), signal integrity, and electrical safety checks. It provides comprehensive analysis tools to ensure your PCB designs meet professional standards and regulatory requirements.

## ✨ Features

### EMC & Signal Integrity

- ✅ **Via stitching analysis** - Ground plane connectivity and EMI shielding verification
- ✅ **Decoupling capacitor placement** - Automatic verification of power supply filtering
- ✅ **Ground plane continuity** - Check for splits and discontinuities
- ✅ **EMI filter validation** - Verify electromagnetic interference filtering
- ✅ **Signal integrity framework** - Impedance control and trace analysis

### Safety & Compliance

- ✅ **IEC60664-1 compliance** - Clearance and creepage distance checking for safety isolation
- ✅ **IPC2221 verification** - Trace width and spacing per industry standards
- ✅ **Advanced pathfinding** - Spatial analysis algorithms for distance measurement

### Reporting & Visualization

- ✅ **Visual markers** - Highlight issues directly on PCB with grouping
- ✅ **Progress dialogs** - Real-time feedback during analysis
- ✅ **HTML reports** - Comprehensive, exportable analysis results
- ✅ **Modular architecture** - TOML-based configuration system

## 📦 Installation

### Via KiCAD Plugin Manager (Recommended)

1. **Open KiCAD PCB Editor**
2. Go to: `Tools → Plugin and Content Manager` (Ctrl+Shift+M)
3. Add custom repository (if not already added):
   - Click: `Manage` → `Preferences` (gear icon)
   - Click: `Add Repository`
   - Name: `RolandWa Plugins`
   - URL: `https://raw.githubusercontent.com/RolandWa/KiCAD-Plugin/main/kicad-repository.json`
   - Click: `Add` → `OK`
4. **Search** for "EMC Auditor"
5. Click: **Install**
6. **Restart** KiCAD PCB Editor

### Access the Plugin

After installation, find EMC Auditor at:

**Menu**: `Tools → External Plugins → EMC Auditor`

## 🚀 Usage

1. **Open your PCB** in KiCAD PCB Editor
2. **Launch EMC Auditor** from the menu
3. **Select checks to perform**:
   - Via stitching analysis
   - Decoupling capacitor verification
   - Ground plane continuity
   - Clearance/creepage distances
   - Signal integrity checks
   - EMI filter validation
4. **Run analysis** - Plugin performs selected checks
5. **Review results**:
   - Visual markers on PCB
   - Detailed HTML report
   - Issue summary and recommendations

## ⚙️ Configuration

EMC Auditor uses TOML configuration for customization:

- `emc_rules.toml` - Main configuration file
- **Configurable parameters**:
  - Via stitching spacing requirements
  - Decoupling capacitor placement rules
  - Clearance/creepage distance tables (IEC60664-1)
  - Trace width requirements (IPC2221)
  - Signal integrity thresholds
- Configuration preserved across updates

## 🛠️ Requirements

- **KiCAD**: 8.0 or later (9.0+ recommended)
- **Python**: 3.8 or later
- No external dependencies required

## 📋 Check Categories

### Via Stitching

- Ground plane connectivity verification
- Via spacing analysis
- Return path optimization
- EMI shielding effectiveness

### Decoupling Capacitors

- Power pin proximity checks
- Capacitor placement optimization
- Value verification
- ESR considerations

### Ground Plane Continuity

- Polygon connectivity analysis
- Split detection
- Return path verification
- Ground bounce prevention

### Clearance & Creepage (IEC60664-1)

- Safety isolation distances
- Pollution degree consideration
- Material group analysis
- Overvoltage category compliance

### Signal Integrity

- Trace impedance verification
- Length matching checks
- Termination validation
- High-speed routing analysis

### EMI Filtering

- Filter component placement
- Ground connection verification
- Component value validation
- Effectiveness analysis

## 📊 Output

- **Visual markers** - Color-coded issue indicators on PCB
- **HTML reports** - Comprehensive analysis with:
  - Issue summary
  - Severity levels
  - Recommendations
  - Compliance status
  - Detailed findings
- **Console output** - Real-time progress and summary

## 🔗 Links

- **Homepage**: <https://github.com/RolandWa/KiCAD_Custom_DRC>
- **Repository**: <https://github.com/RolandWa/KiCAD_Custom_DRC.git>
- **Issues**: <https://github.com/RolandWa/KiCAD_Custom_DRC/issues>

## 📜 License

MIT License

## 👥 Credits

- **Author**: Roland W
- **Maintainer**: Roland W

## 🆘 Support

For issues, questions, or contributions:

- **GitHub Issues**: <https://github.com/RolandWa/KiCAD_Custom_DRC/issues>
- **Repository Issues**: <https://github.com/RolandWa/KiCAD-Plugin/issues>

## 📝 Tags

`drc` `emc` `signal integrity` `compliance` `iec60664` `ipc2221` `safety` `via stitching` `decoupling` `ground plane` `clearance` `creepage`

## 🎓 Use Cases

- **Professional PCB design** - Meet industry standards
- **EMC compliance** - Regulatory certification preparation
- **Safety certification** - IEC60664-1 compliance verification
- **High-speed design** - Signal integrity validation
- **Manufacturing** - Reduce rework and failures
- **Quality assurance** - Automated design verification

---

**Version**: 1.4.0  
**Status**: Stable  
**Last Updated**: February 20, 2026
