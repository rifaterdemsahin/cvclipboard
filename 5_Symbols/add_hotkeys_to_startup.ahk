; This script adds the AutoHotkey scripts for your CV snippets to the Windows startup sequence.
; By running this script once, shortcuts to your hotkey files will be placed in the Startup folder.
; This means your hotstrings (e.g., ]ai, ]devops, ]usp) will be active automatically every time you log into Windows.

; Get the directory where this script is located
scriptDir := A_ScriptDir

; Define the scripts to add to startup
hotkeyScripts := ["aiengineer.ahk", "devops_aiengineer.ahk", "usp.ahk"]

; Loop through the scripts and create a shortcut for each in the Startup folder
for index, scriptName in hotkeyScripts
{
    targetPath := scriptDir . "\" . scriptName
    shortcutPath := A_Startup . "\" . RegExReplace(scriptName, "\.ahk$", ".lnk") ; Create a .lnk file
    
    ; Check if the target script exists before creating a shortcut
    if (FileExist(targetPath))
    {
        FileCreateShortcut, %targetPath%, %shortcutPath%,, , % "Run " . scriptName . " at startup"
    }
}

MsgBox, 64, Startup Scripts, Shortcuts for the hotkey scripts have been created in your Startup folder. They will now run automatically when you log in.
