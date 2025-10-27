# Formula: N8N API Integration for Image Upload

## Overview
This formula demonstrates how to integrate AutoHotkey with N8N workflows to automatically post screenshots and images via API calls in the background.

## 🔄 N8N Workflow Setup

### N8N Webhook Configuration
```json
{
  "nodes": [
    {
      "parameters": {
        "httpMethod": "POST",
        "path": "upload-screenshot",
        "responseMode": "responseNode",
        "options": {}
      },
      "name": "Webhook",
      "type": "n8n-nodes-base.webhook",
      "position": [240, 300]
    },
    {
      "parameters": {
        "values": {
          "string": [
            {
              "name": "filename",
              "value": "={{ $json.filename }}"
            },
            {
              "name": "timestamp",
              "value": "={{ $json.timestamp }}"
            }
          ]
        },
        "options": {}
      },
      "name": "Process Image",
      "type": "n8n-nodes-base.set"
    }
  ]
}
```

## 📤 AutoHotkey N8N Integration

### Basic N8N API Call Function
```ahk
; N8N Configuration
N8N_WEBHOOK_URL := "https://your-n8n-instance.com/webhook/upload-screenshot"
N8N_API_KEY := "your-api-key-here"  ; If using authentication

; Function to send image to N8N
SendImageToN8N(ImagePath, Metadata := "") {
    ; Prepare the HTTP request
    HTTPObj := ComObjCreate("WinHttp.WinHttpRequest.5.1")
    
    ; Read image file as base64
    ImageBase64 := FileToBase64(ImagePath)
    
    ; Prepare JSON payload
    PayloadObj := {}
    PayloadObj.image_data := ImageBase64
    PayloadObj.filename := GetFileName(ImagePath)
    PayloadObj.timestamp := GetCurrentTimestamp()
    PayloadObj.metadata := Metadata
    
    ; Convert to JSON string
    JSONPayload := ObjToJSON(PayloadObj)
    
    try {
        ; Configure request
        HTTPObj.Open("POST", N8N_WEBHOOK_URL, false)
        HTTPObj.SetRequestHeader("Content-Type", "application/json")
        
        ; Add API key if configured
        if (N8N_API_KEY != "")
            HTTPObj.SetRequestHeader("Authorization", "Bearer " . N8N_API_KEY)
        
        ; Send request
        HTTPObj.Send(JSONPayload)
        
        ; Handle response
        if (HTTPObj.Status = 200) {
            TrayTip, N8N Upload, Image uploaded successfully!, 3, 1
            return true
        } else {
            TrayTip, N8N Error, Upload failed: Status %HTTPObj.Status%, 5, 3
            return false
        }
    } catch e {
        TrayTip, N8N Error, Network error: %e.message%, 5, 3
        return false
    }
}
```

## 🖼️ Screenshot + N8N Integration

### Combined Screenshot and Upload
```ahk
; Hotkey: Ctrl + Shift + S for screenshot and upload
^+s::
{
    ; Take screenshot first
    ScreenshotFolder := "C:\Screenshots\Temp"
    FileCreateDir, %ScreenshotFolder%
    
    FormatTime, TimeStr, , yyyy-MM-dd_HH-mm-ss
    TempFile := ScreenshotFolder . "\Screenshot_" . TimeStr . ".png"
    
    ; Take screenshot
    if (TakeAndSaveScreenshot(TempFile)) {
        ; Get additional metadata
        InputBox, ProjectName, Project Context, Enter project/context name:, , 300, 100
        
        Metadata := {}
        Metadata.project := ProjectName
        Metadata.computer := A_ComputerName
        Metadata.user := A_UserName
        
        ; Upload to N8N
        if (SendImageToN8N(TempFile, ObjToJSON(Metadata))) {
            ; Optionally delete temp file after successful upload
            ; FileDelete, %TempFile%
        }
    }
}
```

## 🔄 Advanced N8N Workflows

### Workflow 1: Screenshot Analysis
```ahk
; Send screenshot for AI analysis via N8N
AnalyzeScreenshotWithN8N(ImagePath) {
    AnalysisURL := "https://your-n8n-instance.com/webhook/analyze-screenshot"
    
    Payload := {}
    Payload.image_data := FileToBase64(ImagePath)
    Payload.analysis_type := "general"  ; or "text", "code", "ui"
    Payload.return_format := "json"
    
    HTTPObj := ComObjCreate("WinHttp.WinHttpRequest.5.1")
    
    try {
        HTTPObj.Open("POST", AnalysisURL, false)
        HTTPObj.SetRequestHeader("Content-Type", "application/json")
        HTTPObj.Send(ObjToJSON(Payload))
        
        if (HTTPObj.Status = 200) {
            Response := JSONToObj(HTTPObj.ResponseText)
            ; Display analysis results
            MsgBox, Analysis Results:`n%Response.analysis%
            return Response
        }
    } catch e {
        MsgBox, Analysis failed: %e.message%
    }
}
```

### Workflow 2: Multi-Service Upload
```ahk
; Upload to multiple services via N8N
MultiServiceUpload(ImagePath) {
    Services := ["slack", "discord", "teams", "email"]
    
    for index, service in Services {
        ServiceURL := "https://your-n8n-instance.com/webhook/upload-" . service
        
        Payload := {}
        Payload.image_data := FileToBase64(ImagePath)
        Payload.service := service
        Payload.channel := GetServiceChannel(service)
        
        ; Send async request
        SendAsyncRequest(ServiceURL, ObjToJSON(Payload))
    }
    
    TrayTip, Multi-Upload, Uploading to %Services.Length()% services..., 3
}

SendAsyncRequest(URL, JSONData) {
    ; Create new thread for async request
    HTTPObj := ComObjCreate("WinHttp.WinHttpRequest.5.1")
    HTTPObj.Open("POST", URL, true)  ; true = async
    HTTPObj.SetRequestHeader("Content-Type", "application/json")
    HTTPObj.Send(JSONData)
}
```

## 🛠️ Utility Functions

### File and JSON Handling
```ahk
; Convert file to Base64
FileToBase64(FilePath) {
    FileRead, BinaryData, *c %FilePath%
    Base64Data := Base64Encode(BinaryData)
    return Base64Data
}

; Base64 encoding function
Base64Encode(Data) {
    ; Use Windows CryptBinaryToString API
    VarSetCapacity(B64, 4 * ((StrLen(Data) + 2) // 3) + 1)
    DllCall("Crypt32.dll\CryptBinaryToString", "Ptr", &Data, "UInt", StrLen(Data), "UInt", 1, "Str", B64, "UIntP", VarSetCapacity(B64))
    return B64
}

; Simple JSON conversion (basic implementation)
ObjToJSON(obj) {
    if (IsObject(obj)) {
        JSON := "{"
        for key, value in obj {
            if (JSON != "{")
                JSON .= ","
            JSON .= """" . key . """:"
            if (IsObject(value))
                JSON .= ObjToJSON(value)
            else
                JSON .= """" . value . """"
        }
        JSON .= "}"
        return JSON
    }
    return """" . obj . """"
}

; Get filename from path
GetFileName(FilePath) {
    SplitPath, FilePath, FileName
    return FileName
}

; Get current timestamp
GetCurrentTimestamp() {
    FormatTime, TimeStr, , yyyy-MM-dd HH:mm:ss
    return TimeStr
}
```

## 🔐 Authentication Methods

### API Key Authentication
```ahk
; Store API key securely (consider encryption)
IniRead, N8N_API_KEY, config.ini, N8N, ApiKey, ""

SetN8NHeaders(HTTPObj, ExtraHeaders := "") {
    HTTPObj.SetRequestHeader("Content-Type", "application/json")
    HTTPObj.SetRequestHeader("User-Agent", "AutoHotkey-Screenshot-Bot/1.0")
    
    if (N8N_API_KEY != "")
        HTTPObj.SetRequestHeader("Authorization", "Bearer " . N8N_API_KEY)
    
    ; Add custom headers
    if (ExtraHeaders != "") {
        for key, value in ExtraHeaders {
            HTTPObj.SetRequestHeader(key, value)
        }
    }
}
```

### OAuth 2.0 Authentication (Advanced)
```ahk
; OAuth token management
GetOAuthToken() {
    ; Read cached token
    IniRead, AccessToken, config.ini, OAuth, AccessToken, ""
    IniRead, ExpiryTime, config.ini, OAuth, ExpiryTime, 0
    
    ; Check if token is expired
    if (A_Now > ExpiryTime) {
        ; Refresh token
        AccessToken := RefreshOAuthToken()
    }
    
    return AccessToken
}

RefreshOAuthToken() {
    ; Implementation for token refresh
    ; This would call your OAuth provider's token endpoint
}
```

## 📊 N8N Workflow Examples

### Workflow 1: Screenshot Processing Pipeline
```yaml
# N8N Workflow: Screenshot Processing
name: Screenshot Processing Pipeline
nodes:
  - name: Webhook Trigger
    type: webhook
    parameters:
      path: upload-screenshot
      method: POST
      
  - name: Save to Cloud Storage
    type: aws-s3
    parameters:
      bucket: screenshot-storage
      key: "{{ $json.timestamp }}_{{ $json.filename }}"
      
  - name: OCR Text Extraction
    type: http-request
    parameters:
      url: https://api.ocr.space/parse/image
      method: POST
      
  - name: Send to Slack
    type: slack
    parameters:
      channel: "#screenshots"
      message: "New screenshot uploaded: {{ $json.filename }}"
      
  - name: Update Database
    type: postgres
    parameters:
      operation: insert
      table: screenshots
```

### Workflow 2: AI-Powered Screenshot Analysis
```yaml
# N8N Workflow: AI Screenshot Analysis
name: AI Screenshot Analysis
nodes:
  - name: Image Webhook
    type: webhook
    
  - name: Resize Image
    type: image-resize
    
  - name: OpenAI Vision Analysis
    type: openai
    parameters:
      model: gpt-4-vision-preview
      prompt: "Analyze this screenshot and extract key information"
      
  - name: Save Analysis Results
    type: json-file-write
    
  - name: Send Summary Email
    type: email
    parameters:
      subject: "Screenshot Analysis Complete"
```

## 🚀 Complete Implementation Example

### Full AutoHotkey Script with N8N Integration
```ahk
; ===== CONFIGURATION =====
#NoEnv
#SingleInstance Force
#Persistent

; N8N Configuration
N8N_BASE_URL := "https://your-n8n-instance.com"
N8N_WEBHOOK_SCREENSHOT := N8N_BASE_URL . "/webhook/upload-screenshot"
N8N_WEBHOOK_ANALYSIS := N8N_BASE_URL . "/webhook/analyze-screenshot"

; Read configuration
IniRead, ApiKey, config.ini, N8N, ApiKey, ""
IniRead, DefaultUpload, config.ini, Settings, AutoUpload, 0

; ===== HOTKEYS =====

; Screenshot + Upload: Ctrl + Shift + S
^+s::
    ScreenshotAndUpload()
return

; Screenshot + Analysis: Ctrl + Shift + A  
^+a::
    ScreenshotAndAnalyze()
return

; Bulk upload folder: Ctrl + Shift + B
^+b::
    BulkUploadFolder()
return

; ===== MAIN FUNCTIONS =====

ScreenshotAndUpload() {
    ; Take screenshot
    TempPath := TakeTemporaryScreenshot()
    if (TempPath != "") {
        ; Upload to N8N
        UploadResult := SendToN8N(N8N_WEBHOOK_SCREENSHOT, TempPath, "screenshot")
        if (UploadResult) {
            TrayTip, Success, Screenshot uploaded to N8N!, 3, 1
        }
    }
}

ScreenshotAndAnalyze() {
    ; Take screenshot
    TempPath := TakeTemporaryScreenshot()
    if (TempPath != "") {
        ; Send for analysis
        Analysis := SendToN8N(N8N_WEBHOOK_ANALYSIS, TempPath, "analysis")
        if (Analysis) {
            ; Display analysis results
            ShowAnalysisResults(Analysis)
        }
    }
}

BulkUploadFolder() {
    FileSelectFolder, SelectedFolder, , 3, Select folder with images to upload
    if (SelectedFolder != "") {
        Loop, Files, %SelectedFolder%\*.png, R
        Loop, Files, %SelectedFolder%\*.jpg, R
        {
            SendToN8N(N8N_WEBHOOK_SCREENSHOT, A_LoopFileFullPath, "bulk")
            Sleep, 100  ; Rate limiting
        }
        TrayTip, Bulk Upload, Folder upload completed!, 5, 1
    }
}

; ===== HELPER FUNCTIONS =====

TakeTemporaryScreenshot() {
    ; Implementation of screenshot capture
    ; Returns file path of captured screenshot
}

SendToN8N(WebhookURL, ImagePath, Type) {
    ; Implementation of N8N API call
    ; Returns response data or false on error
}

ShowAnalysisResults(Results) {
    ; Display AI analysis results in a GUI
}
```

## ⚙️ Configuration File

### config.ini Example
```ini
[N8N]
ApiKey=your-api-key-here
BaseURL=https://your-n8n-instance.com
Timeout=30

[Settings]
AutoUpload=1
TempFolder=C:\Screenshots\Temp
MaxFileSize=5242880
SupportedFormats=png,jpg,bmp

[Workflows]
Screenshot=upload-screenshot
Analysis=analyze-screenshot
Bulk=bulk-upload
```

## 🔍 Error Handling and Logging

### Robust Error Handling
```ahk
LogError(ErrorMsg, ErrorCode := "") {
    FormatTime, LogTime, , yyyy-MM-dd HH:mm:ss
    LogEntry := LogTime . " - ERROR: " . ErrorMsg
    if (ErrorCode != "")
        LogEntry .= " (Code: " . ErrorCode . ")"
    
    FileAppend, %LogEntry%`n, error.log
    
    ; Also show to user if critical
    if (InStr(ErrorMsg, "CRITICAL")) {
        MsgBox, 16, Critical Error, %ErrorMsg%
    }
}

; Usage in functions
SafeSendToN8N(URL, Data) {
    try {
        Result := SendToN8N(URL, Data)
        return Result
    } catch e {
        LogError("N8N API call failed: " . e.message, e.code)
        return false
    }
}
```

---

*Last Updated: October 27, 2025*
*Requires: N8N instance, AutoHotkey v1.1+, WinHTTP*