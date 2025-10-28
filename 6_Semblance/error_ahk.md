# AutoHotkey Error Fix Documentation

## Error Description

**Error Message:**
```
Error: Function calls require a space or "(".  Use comma only between parameters.

Text: SendRaw, Thank you for your interest. I am linking my CV, which details my exper…
Line: 9
File: F:\cvclipboard\aiengineer.ahk
```

## Root Cause Analysis

The error occurred due to incorrect AutoHotkey v1 syntax on line 9. The issue was with the `SendRaw` command usage:

### ❌ Problematic Code:
```ahk
::/aiengineer::
SendRaw, Thank you for your interest. I am linking my CV, which details my experience...
```

### Problem Explanation:
- In AutoHotkey v1, when using `SendRaw` with a multi-line string or long text, the comma syntax is incorrect
- The comma after `SendRaw` made AutoHotkey interpret it as a function call rather than a command
- AutoHotkey expected either a space or parentheses for function calls

## Solution Implementation

### ✅ Fixed Code:
```ahk
::/aiengineer::
; Read content from ai-engineer.md file
FileRead, MessageContent, %A_ScriptDir%\ai-engineer.md
if ErrorLevel
{
    ; Fallback message if file cannot be read
    MessageContent := "Thank you for your interest. Please find my CV at: https://docs.google.com/document/d/1mEwGZ6GG9sPfphk0-0t6tq0MxgSVuoVS/edit"
}
; Send the content without comma after SendRaw
SendRaw %MessageContent%
Return
```

## Key Changes Made

### 1. **Syntax Correction**
- **Before:** `SendRaw, <text>`
- **After:** `SendRaw %MessageContent%`
- **Reason:** Proper AutoHotkey v1 syntax for sending variable content

### 2. **Dynamic File Reading**
- **Added:** `FileRead, MessageContent, %A_ScriptDir%\ai-engineer.md`
- **Benefit:** Content is now read from external file instead of hardcoded
- **Maintainability:** Can update message by editing markdown file

### 3. **Error Handling**
- **Added:** `if ErrorLevel` check with fallback message
- **Benefit:** Script won't crash if file is missing or unreadable

### 4. **Proper Variable Usage**
- **Used:** `%MessageContent%` for variable expansion
- **Reason:** AutoHotkey v1 requires percent signs around variable names in commands

## AutoHotkey Syntax Rules (v1)

### Command Syntax:
```ahk
; Correct ways to use SendRaw:
SendRaw, SingleLineText                    ; ✅ Comma for literal text
SendRaw %VariableName%                     ; ✅ Percent signs for variables
SendRaw, %VariableName%                    ; ❌ Don't mix comma with variable
```

### Function vs Command:
```ahk
; Command (traditional syntax):
SendRaw %MyText%                           ; ✅ Correct

; Function (expression syntax):
SendRaw(MyText)                           ; ✅ Also correct but different style
```

## Best Practices Applied

1. **External Configuration**: Moved content to `ai-engineer.md` for easy editing
2. **Path Safety**: Used `%A_ScriptDir%` for relative file paths
3. **Error Resilience**: Added fallback for file read failures
4. **Code Comments**: Added explanatory comments for future maintenance
5. **Proper Syntax**: Used correct AutoHotkey v1 command syntax

## Testing Recommendations

1. **File Presence Test**: Ensure `ai-engineer.md` exists in script directory
2. **Content Validation**: Verify markdown file contains expected content
3. **Hotstring Test**: Type `/aiengineer` to test expansion
4. **Error Simulation**: Temporarily rename markdown file to test fallback

## File Structure After Fix

```
f:\cvclipboard\
├── aiengineer.ahk          # Fixed AutoHotkey script
├── ai-engineer.md          # Content source file
├── error_ahk.md           # This documentation
└── README.md              # Project documentation
```

## Prevention Tips

1. **Always validate AutoHotkey syntax** using AutoHotkey documentation
2. **Test scripts incrementally** rather than writing large blocks
3. **Use external files** for content that may change frequently
4. **Implement error handling** for file operations
5. **Comment code thoroughly** for future maintenance

---

**Fix Date:** October 27, 2025  
**AutoHotkey Version:** v1.x  
**Status:** ✅ Resolved and Enhanced