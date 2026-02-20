# OpenFixture

**Automated laser-cuttable PCB test fixture generator**

[![License](https://img.shields.io/badge/license-CC--BY--SA--4.0-blue)](https://creativecommons.org/licenses/by-sa/4.0/)
[![KiCAD](https://img.shields.io/badge/KiCAD-8.0%20%7C%209.0+-blue)](https://www.kicad.org/)

---

## 📖 Overview

OpenFixture is a comprehensive PCB test fixture generator that integrates directly with KiCAD to automatically create laser-cuttable fixtures for your boards. The plugin analyzes your PCB design, identifies test points, and generates complete fixture designs including laser-cut top/bottom plates, pogo pin placement, mounting hardware specifications, and 3D preview renders.

## ✨ Features

- ✅ **Full KiCAD 9.0+ compatibility** - Works seamlessly with latest KiCAD versions
- ✅ **TOML configuration system** - Easy-to-edit configuration files
- ✅ **Multi-tab UI** - Intuitive interface with material presets
- ✅ **Laser-cuttable designs** - DXF output ready for manufacturing
- ✅ **Automatic pogo pin placement** - Intelligent test point detection
- ✅ **Support for SMD and PTH** - Works with both surface mount and through-hole test points
- ✅ **OpenSCAD integration** - Automatic DXF generation with 3D preview
- ✅ **Manufacturing-ready** - Complete specifications for production

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
4. **Search** for "OpenFixture"
5. Click: **Install**
6. **Restart** KiCAD PCB Editor

### Access the Plugin

After installation, find OpenFixture at:

**Menu**: `Tools → External Plugins → OpenFixture Generator`

## 🚀 Usage

1. **Open your PCB** in KiCAD PCB Editor
2. **Launch OpenFixture** from the menu
3. **Configure settings** in the multi-tab interface:
   - Material selection (acrylic, wood, etc.)
   - Fixture dimensions
   - Pogo pin specifications
   - Material thickness
4. **Generate fixture** - Creates DXF files for laser cutting
5. **Preview in OpenSCAD** - View 3D model before manufacturing

## ⚙️ Configuration

OpenFixture uses TOML configuration files for easy customization:

- `fixture_config.toml` - Main configuration file
- Preserved across updates (listed in `keep_on_update`)

## 🛠️ Requirements

- **KiCAD**: 8.0 or later (9.0+ recommended)
- **Python**: 3.8 or later
- **OpenSCAD**: 2015.03 or later (for DXF generation and 3D preview)
- **Laser cutter**: Access to laser cutting service or equipment

## 📋 Output Files

OpenFixture generates:

- **DXF files** - Laser-cuttable designs for top and bottom plates
- **3D preview** - OpenSCAD model for visualization
- **Pogo pin list** - Complete bill of materials
- **Assembly instructions** - Mounting and setup specifications

## 🔗 Links

- **Homepage**: <https://github.com/tinylabs/openfixture>
- **Original Project**: <https://tinylabs.io/openfixture>
- **Repository**: <https://github.com/tinylabs/openfixture.git>
- **Issues**: <https://github.com/tinylabs/openfixture/issues>

## 📜 License

CC-BY-SA-4.0

## 👥 Credits

- **Original Author**: Elliot Buller
- **Maintainer**: OpenFixture Community
- **Contributors**: Community contributors

## 🆘 Support

For issues, questions, or contributions:

- **GitHub Issues**: <https://github.com/tinylabs/openfixture/issues>
- **Repository Issues**: <https://github.com/RolandWa/KiCAD-Plugin/issues>

## 📝 Tags

`test` `fixture` `manufacturing` `pogo pins` `laser cutting` `testing` `production` `dxf` `openscad`

---

**Version**: 2.0.0  
**Status**: Stable  
**Last Updated**: February 20, 2026
