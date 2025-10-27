# Formula: AutoHotkey Screenshot Automation

## Overview
This formula provides AutoHotkey scripts for taking screenshots and automatically organizing them into folders of your choice.

## 🖼️ Basic Screenshot Formula

### Simple Screenshot to Folder
```ahk
; Hotkey: Win + S for screenshot
#s::
{
    ; Define your target folder
    ScreenshotFolder := "C:\Screenshots"
    
    ; Create folder if it doesn't exist
    FileCreateDir, %ScreenshotFolder%
    
    ; Generate timestamp filename
    FormatTime, TimeStr, , yyyy-MM-dd_HH-mm-ss
    FileName := ScreenshotFolder . "\" . "Screenshot_" . TimeStr . ".png"
    
    ; Take screenshot using Windows Snipping Tool
    Run, SnippingTool /clip
    
    ; Wait a moment for screenshot to be taken
    Sleep, 2000
    
    ; Save clipboard image to file
    SaveClipboardImage(FileName)
    
    ; Show confirmation
    TrayTip, Screenshot Saved, Saved to: %FileName%, 3
}

; Function to save clipboard image to file
SaveClipboardImage(FilePath) {
    ; Check if clipboard contains image
    if DllCall("IsClipboardFormatAvailable", "uint", 2) ; CF_BITMAP
    {
        ; Open clipboard
        DllCall("OpenClipboard", "ptr", 0)
        
        ; Get bitmap from clipboard
        hBitmap := DllCall("GetClipboardData", "uint", 2, "ptr")
        
        ; Save bitmap to file (requires additional GDI+ functions)
        SaveBitmapToFile(hBitmap, FilePath)
        
        ; Close clipboard
        DllCall("CloseClipboard")
    }
}
```

## 📁 Advanced Screenshot with Folder Selection

### Interactive Folder Selection
```ahk
; Hotkey: Ctrl + Win + S for screenshot with folder choice
^#s::
{
    ; Show folder selection dialog
    FileSelectFolder, SelectedFolder, , 3, Select Screenshot Destination Folder
    
    if (SelectedFolder = "")
    {
        MsgBox, No folder selected. Screenshot cancelled.
        return
    }
    
    ; Generate timestamp filename
    FormatTime, TimeStr, , yyyy-MM-dd_HH-mm-ss
    FileName := SelectedFolder . "\" . "Screenshot_" . TimeStr . ".png"
    
    ; Take screenshot
    TakeAndSaveScreenshot(FileName)
}
```

## 🎯 Predefined Folder Shortcuts

### Multiple Hotkeys for Different Folders
```ahk
; Screenshot to Projects folder: Ctrl + 1
^1::
{
    ScreenshotToFolder("C:\Projects\Screenshots")
}

; Screenshot to Work folder: Ctrl + 2  
^2::
{
    ScreenshotToFolder("C:\Work\Screenshots")
}

; Screenshot to Personal folder: Ctrl + 3
^3::
{
    ScreenshotToFolder("C:\Personal\Screenshots")
}

; Screenshot to Desktop: Ctrl + 4
^4::
{
    ScreenshotToFolder(A_Desktop . "\Screenshots")
}

; Generic function for folder-specific screenshots
ScreenshotToFolder(FolderPath) {
    ; Create folder if needed
    FileCreateDir, %FolderPath%
    
    ; Generate filename with project context
    InputBox, ProjectName, Project Name, Enter project name (optional):, , 300, 100
    if (ProjectName != "")
        ProjectName := "_" . ProjectName
    
    FormatTime, TimeStr, , yyyy-MM-dd_HH-mm-ss
    FileName := FolderPath . "\" . "Screenshot_" . TimeStr . ProjectName . ".png"
    
    ; Take and save screenshot
    TakeAndSaveScreenshot(FileName)
}
```

## 📸 Different Screenshot Methods

### Method 1: Using Windows Snipping Tool
```ahk
TakeScreenshotSnippingTool(SavePath) {
    ; Launch snipping tool in clipboard mode
    Run, SnippingTool /clip
    
    ; Wait for user to take screenshot
    WinWait, Snipping Tool, , 10
    WinWaitClose, Snipping Tool, , 30
    
    ; Save clipboard to file
    Sleep, 500
    SaveClipboardImage(SavePath)
}
```

### Method 2: Full Screen Capture
```ahk
TakeFullScreenshot(SavePath) {
    ; Capture entire screen to clipboard
    Send, {PrintScreen}
    Sleep, 500
    
    ; Save clipboard to file
    SaveClipboardImage(SavePath)
}
```

### Method 3: Active Window Capture
```ahk
TakeActiveWindowScreenshot(SavePath) {
    ; Capture active window to clipboard
    Send, !{PrintScreen}  ; Alt + PrintScreen
    Sleep, 500
    
    ; Save clipboard to file
    SaveClipboardImage(SavePath)
}
```

## 🔧 Complete Implementation with GDI+

### Full GDI+ Implementation
```ahk
; Include GDI+ library (download Gdip_All.ahk)
#Include Gdip_All.ahk

; Initialize GDI+ on script start
pToken := Gdip_Startup()

; Shutdown GDI+ when script exits
OnExit("GdipShutdown")

GdipShutdown() {
    Gdip_Shutdown(pToken)
}

; Complete screenshot function
TakeAndSaveScreenshot(FilePath) {
    ; Get screen dimensions
    SysGet, VirtualWidth, 78
    SysGet, VirtualHeight, 79
    
    ; Create bitmap from screen
    pBitmap := Gdip_BitmapFromScreen("0|0|" . VirtualWidth . "|" . VirtualHeight)
    
    ; Save bitmap to file
    Gdip_SaveBitmapToFile(pBitmap, FilePath)
    
    ; Cleanup
    Gdip_DisposeImage(pBitmap)
    
    ; Show notification
    TrayTip, Screenshot Saved, File saved: %FilePath%, 3, 1
}

; Advanced screenshot with area selection
#PrintScreen::
{
    ; Let user select area
    pBitmap := Gdip_BitmapFromHWND(GetDesktopWindow())
    
    ; Show selection GUI (implementation needed)
    SelectedArea := ShowAreaSelection()
    
    if (SelectedArea != "") {
        ; Crop bitmap to selected area
        pCroppedBitmap := Gdip_CloneBitmapArea(pBitmap, SelectedArea.x, SelectedArea.y, SelectedArea.w, SelectedArea.h)
        
        ; Save cropped image
        FormatTime, TimeStr, , yyyy-MM-dd_HH-mm-ss
        FilePath := "C:\Screenshots\Crop_" . TimeStr . ".png"
        Gdip_SaveBitmapToFile(pCroppedBitmap, FilePath)
        
        ; Cleanup
        Gdip_DisposeImage(pCroppedBitmap)
    }
    
    Gdip_DisposeImage(pBitmap)
}
```

## 📋 Configuration Options

### Settings INI File
```ahk
; Read settings from config file
IniRead, DefaultFolder, config.ini, Screenshots, DefaultFolder, C:\Screenshots
IniRead, FileFormat, config.ini, Screenshots, Format, PNG
IniRead, IncludeTimestamp, config.ini, Screenshots, IncludeTimestamp, 1
IniRead, ShowNotifications, config.ini, Screenshots, ShowNotifications, 1

; Example config.ini content:
; [Screenshots]
; DefaultFolder=C:\MyScreenshots
; Format=PNG
; IncludeTimestamp=1
; ShowNotifications=1
```

## 🚀 Usage Examples

### Basic Usage
1. **Quick Screenshot**: `Win + S` → Takes screenshot using snipping tool
2. **Folder Selection**: `Ctrl + Win + S` → Choose destination folder
3. **Project Screenshots**: `Ctrl + 1/2/3/4` → Save to predefined folders

### Advanced Features
- **Auto-naming**: Timestamps and project names
- **Multiple formats**: PNG, JPG, BMP support
- **Folder organization**: Automatic folder creation
- **Notifications**: Tray notifications on save

## 📦 Required Dependencies

### For GDI+ Implementation:
1. Download `Gdip_All.ahk` from AutoHotkey community
2. Place in same folder as your script or AutoHotkey Lib folder
3. Include in your script: `#Include Gdip_All.ahk`

### Alternative (Simpler) Implementation:
```ahk
; Simple version without GDI+ - uses external tools
TakeScreenshotSimple(SavePath) {
    ; Use NirCmd (free tool) for screenshot
    RunWait, nircmd.exe savescreenshot "%SavePath%", , Hide
    
    ; Or use PowerShell
    ; RunWait, powershell.exe -Command "Add-Type -AssemblyName System.Windows.Forms; [System.Windows.Forms.Screen]::PrimaryScreen.Bounds | ForEach-Object {$bmp = New-Object System.Drawing.Bitmap($_.Width, $_.Height); $graphics = [System.Drawing.Graphics]::FromImage($bmp); $graphics.CopyFromScreen($_.X, $_.Y, 0, 0, $_.Size); $bmp.Save('%SavePath%'); $graphics.Dispose(); $bmp.Dispose()}", , Hide
}
```

## 🔍 Troubleshooting

### Common Issues:
1. **GDI+ not found**: Download and include Gdip_All.ahk
2. **Permission errors**: Run as administrator
3. **File format issues**: Ensure proper file extensions (.png, .jpg)
4. **Folder creation fails**: Check write permissions

### Debug Mode:
```ahk
; Add to beginning of functions for debugging
DebugMode := true

if (DebugMode)
    MsgBox, Taking screenshot to: %FilePath%
```

---

*Last Updated: October 27, 2025*
*Compatible with: AutoHotkey v1.1+*