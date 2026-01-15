# Desktop Position Management

This folder contains all desktop icon position management tools and documentation.

## 📁 Folder Structure:

### 📊 **Position Documentation:**
- `Desktop_Icon_Positions_With_Coordinates_*.md` - Coordinate documentation files
- `icon_position_guide.html` - Visual HTML guide for manual positioning
- `Desktop_Position_Documents/` - Backup position documents

### 🎯 **Position Restoration Tools:**
- `persistent-desktop-icons-enhanced.sh` - Enhanced position persistence script
- `restore-desktop-icons-enhanced.desktop` - Desktop launcher for restoration

### 📍 **Target Position Files:**
- `.target_position_*.txt` - Individual position marker files for each icon

## 🔧 **Usage:**

### **For Position Restoration:**
```bash
# Use enhanced persistence script
./persistent-desktop-icons-enhanced.sh restore

# Or use desktop launcher
./restore-desktop-icons-enhanced.desktop
```

### **For Visual Guidance:**
```bash
# Open HTML guide in browser
firefox icon_position_guide.html
```

### **For Reference:**
```bash
# View coordinate documentation
cat Desktop_Icon_Positions_With_Coordinates_*.md
```

## 📋 **Integration:**

The safe desktop toggles are located in:
`../safe_desktop_toggles/`

These scripts work together with the position management tools in this folder.

---

**Created:** January 14, 2026  
**Purpose:** Centralized desktop position management  
**Status:** All files consolidated in workspace
