; aiengineer.ahk
; AutoHotkey (v1) script to expand the trigger "/aiengineer" into a greeting.
; Save this file and double-click it to run with AutoHotkey on Windows.

; When you type: /aiengineer followed by a terminating character (space, Enter, punctuation)
; it will instantly paste the content from ai-engineer.md file using clipboard method for speed.

::/aiengineer::
{
    ; Read content from ai-engineer.md file
    FileRead, MessageContent, ai-engineer.md
    if ErrorLevel
    {
        ; Fallback message if file cannot be read
        MessageContent := "Thank you for your interest. Please find my CV at: https://docs.google.com/document/d/1mEwGZ6GG9sPfphk0-0t6tq0MxgSVuoVS/edit"
    }
    
    ; Store original clipboard content
    ClipboardBackup := ClipboardAll
    
    ; Put message content in clipboard
    Clipboard := MessageContent
    
    ; Wait for clipboard to be ready
    ClipWait, 1
    
    ; Paste instantly using Ctrl+V
    Send, ^v
    
    ; Restore original clipboard after a short delay
    Sleep, 100
    Clipboard := ClipboardBackup
    ClipboardBackup := ""
}

; --- Notes ---
; - Uses clipboard method for instant pasting (much faster than SendRaw for large text)
; - Automatically backs up and restores your original clipboard content
; - If you want case-insensitive matching, change the hotstring to: :i:/aiengineer::
; - The script waits for clipboard readiness and adds a small delay before restoring
