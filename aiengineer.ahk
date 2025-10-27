; aiengineer.ahk
; AutoHotkey (v1) script to expand the trigger "/aiengineer" into a greeting.
; Save this file and double-click it to run with AutoHotkey on Windows.

; When you type: /aiengineer followed by a terminating character (space, Enter, punctuation)
; it will be replaced with the greeting below.

::/aiengineer::
SendRaw, hello this is rifat erdem sahin. I am an ai engineer.
Return

; --- Notes ---
; - This is a simple hotstring replacement using AutoHotkey v1 hotstrings.
; - If you want case-insensitive matching, change the hotstring to:
;   :i:/aiengineer::
; - If you want to include an ending space automatically, you can append a space
;   in the SendRaw line like: SendRaw, hello ... engineer. 
;   But AutoHotkey will normally send the typed ending character for you.
