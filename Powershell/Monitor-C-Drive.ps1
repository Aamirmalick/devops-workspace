# Define the path to monitor
$pathToMonitor = "C:\"
# Define the log file path (you can change the location if needed)
$logFilePath = "C:\FileSystem_Changes_Log.txt"

# Create log file if not exists
if (!(Test-Path $logFilePath)) {
    New-Item -Path $logFilePath -ItemType File | Out-Null
}

# Create a new FileSystemWatcher object
$watcher = New-Object System.IO.FileSystemWatcher
$watcher.Path = $pathToMonitor
$watcher.IncludeSubdirectories = $true
$watcher.EnableRaisingEvents = $true

# Format size in readable units
function Get-ReadableSize($bytes) {
    if ($bytes -ge 1GB) {
        return "{0:N2} GB" -f ($bytes / 1GB)
    } elseif ($bytes -ge 1MB) {
        return "{0:N2} MB" -f ($bytes / 1MB)
    } elseif ($bytes -ge 1KB) {
        return "{0:N2} KB" -f ($bytes / 1KB)
    } else {
        return "$bytes Bytes"
    }
}

# Log helper
function Log-Change($message) {
    $message | Out-File -FilePath $logFilePath -Append -Encoding UTF8
    Write-Host $message
}

# Common handler
function Handle-Event {
    param($eventType, $filePath, $oldPath = $null)

    $now = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

    if ($eventType -eq "RENAMED") {
        $logMsg = @"
[$now] $eventType
    From: $oldPath
    To:   $filePath
"@
    } else {
        if (Test-Path $filePath) {
            $fileInfo = Get-Item $filePath -ErrorAction SilentlyContinue
            $fileSize = Get-ReadableSize $fileInfo.Length
            $fileName = $fileInfo.Name
        } else {
            $fileSize = "N/A"
            $fileName = Split-Path $filePath -Leaf
        }

        $logMsg = @"
[$now] $eventType
    Path: $filePath
    Name: $fileName
    Size: $fileSize
"@
    }

    Log-Change $logMsg
}

# Register events
Register-ObjectEvent $watcher Created -SourceIdentifier FileCreated -Action {
    Handle-Event "CREATED" $Event.SourceEventArgs.FullPath
}

Register-ObjectEvent $watcher Deleted -SourceIdentifier FileDeleted -Action {
    Handle-Event "DELETED" $Event.SourceEventArgs.FullPath
}

Register-ObjectEvent $watcher Changed -SourceIdentifier FileChanged -Action {
    Handle-Event "CHANGED" $Event.SourceEventArgs.FullPath
}

Register-ObjectEvent $watcher Renamed -SourceIdentifier FileRenamed -Action {
    Handle-Event "RENAMED" $Event.SourceEventArgs.FullPath $Event.SourceEventArgs.OldFullPath
}

# Start monitoring
Write-Host "Monitoring C:\ for file changes. Logging to: $logFilePath"
Write-Host "Press Ctrl+C to stop."
while ($true) {
    Start-Sleep -Seconds 1
}
