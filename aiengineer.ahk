; aiengineer.ahk
; AutoHotkey (v1) script to expand the trigger "/aiengineer" into a greeting.
; Save this file and double-click it to run with AutoHotkey on Windows.

; When you type: /aiengineer followed by a terminating character (space, Enter, punctuation)
; it will be replaced with the content read from ai-engineer.md file.

::/aiengineer::
; Read content from ai-engineer.md file
FilePath := A_ScriptDir . "\ai-engineer.md"
FileRead, MessageContent, %FilePath%
if ErrorLevel
{
    ; Fallback message if file cannot be read
    MessageContent := "Thank you for your interest. Please find my CV at: https://docs.google.com/document/d/1mEwGZ6GG9sPfphk0-0t6tq0MxgSVuoVS/edit"
}
; Send the content without comma after SendRaw
SendRaw, %MessageContent%
Return

; --- Notes ---
; - This is a simple hotstring replacement using AutoHotkey v1 hotstrings.
; - If you want case-insensitive matching, change the hotstring to:
;   :i:/aiengineer::
; - If you want to include an ending space automatically, you can append a space
;   in the SendRaw line like: SendRaw, hello ... engineer. 
;   But AutoHotkey will normally send the typed ending character for you.
