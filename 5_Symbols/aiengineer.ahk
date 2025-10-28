; aiengineer.ahk
; AutoHotkey (v1) script to expand the trigger "/aiengineer" into a greeting.
; Save this file and double-click it to run with AutoHotkey on Windows.

; When you type: /aiengineer followed by a terminating character (space, Enter, punctuation)
; it will instantly paste the content from ai-engineer.md file using clipboard method for speed.

::/aiengineer::
{
    ; Read content from ai-engineer.md file with UTF-8 encoding
    FileRead, MessageContent, *P65001 ai-engineer.md
    if ErrorLevel
    {
        ; Try reading without encoding specification as fallback
        FileRead, MessageContent, ai-engineer.md
        if ErrorLevel
        {
            ; Final fallback message if file cannot be read
            MessageContent := "ERROR: Could not read ai-engineer.md file. Please check if the file exists in the same directory as this script."
            MsgBox, FileRead Error: %ErrorLevel%`nFile: ai-engineer.md`nScript Dir: %A_ScriptDir%
        }
    }
    
    ; Debug: Uncomment the next line to see what content was read
    ; MsgBox, Content length: %StrLen(MessageContent)% chars`nFirst 200 chars: %MessageContent:~0,200%...
    
    ; Store original clipboard content
    ClipboardBackup := ClipboardAll
    
    ; Clear clipboard first to ensure clean state
    Clipboard := ""
    Sleep, 50
    
    ; Put message content in clipboard
    Clipboard := MessageContent
    
    ; Wait for clipboard to be ready with longer timeout
    ClipWait, 2
    if ErrorLevel
    {
        MsgBox, Clipboard operation failed!
        Clipboard := ClipboardBackup
        return
    }
    
    ; Paste instantly using Ctrl+V
    Send, ^v
    
    ; Restore original clipboard after a longer delay
    Sleep, 500
    Clipboard := ClipboardBackup
    ClipboardBackup := ""
}

; --- Notes ---
; - Uses clipboard method for instant pasting (much faster than SendRaw for large text)
; - Automatically backs up and restores your original clipboard content
; - Uses UTF-8 encoding (*P65001) to properly handle emoji and special characters
; - If you want case-insensitive matching, change the hotstring to: :i:/aiengineer::
; - The script waits for clipboard readiness and adds a small delay before restoring
