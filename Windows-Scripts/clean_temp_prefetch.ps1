# Run as Administrator
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Start-Process powershell.exe -ArgumentList "-File `"$PSCommandPath`"" -Verb RunAs
    exit
}

# Maximize PowerShell Window
$signature = @'
[DllImport("user32.dll")] public static extern bool ShowWindow(IntPtr hWnd, int nCmdShow);
[DllImport("user32.dll")] public static extern IntPtr GetForegroundWindow();
'@
$WinAPI = Add-Type -MemberDefinition $signature -Name "WinAPI" -Namespace WinAPI -PassThru
$WinAPI::ShowWindow($WinAPI::GetForegroundWindow(), 3) # 3 = SW_MAXIMIZE

# Set Console Color
$host.UI.RawUI.ForegroundColor = "Green"
Clear-Host

# Display Banner from "banner.txt" (if exists)
$bannerFile = ".\banner.txt"
if (Test-Path $bannerFile) {
    Get-Content $bannerFile | ForEach-Object { Write-Host $_ -ForegroundColor Green }
} else {
    Write-Host "BANNER FILE MISSING!" -ForegroundColor Red
}

# Define Paths
$TempPath = "C:\Users\CIPL\AppData\Local\Temp"
$PrefetchPath = "C:\Windows\Prefetch"

# Cleanup Temp Folder (Files Only)
Write-Host "`nCleaning Temp Folder..."
Get-ChildItem -Path $TempPath -Recurse -Force -ErrorAction SilentlyContinue | Remove-Item -Force -Recurse -ErrorAction SilentlyContinue
Write-Host "Temp Folder Cleaned.`n"

# Cleanup Prefetch Folder (Files Only)
Write-Host "Cleaning Prefetch Folder..."
Get-ChildItem -Path $PrefetchPath -Recurse -Force -ErrorAction SilentlyContinue | Remove-Item -Force -Recurse -ErrorAction SilentlyContinue
Write-Host "Prefetch Folder Cleaned.`n"

# Check for Errors
$ErrorLog = "$env:TEMP\clean_error_log.txt"
if ($Error) {
    $Error | Out-File -FilePath $ErrorLog
    Write-Host "`n[ERRORS DETECTED] - Check $ErrorLog for details.`n"
}

# Blinking "Cleaning Complete!" Text in Center
$text = "CLEANING COMPLETE!"
$width = [console]::WindowWidth
$padding = " " * (($width - $text.Length) / 2)

for ($i = 0; $i -lt 10; $i++) {
    Clear-Host
    if (Test-Path $bannerFile) { Get-Content $bannerFile | ForEach-Object { Write-Host $_ -ForegroundColor Green } }
    Write-Host "$padding$text" -ForegroundColor Green
    Start-Sleep -Milliseconds 500
    Clear-Host
    Start-Sleep -Milliseconds 500
}

# Final Message
Write-Host "$padding$text" -ForegroundColor Green
Write-Host "`nPress any key to exit..."
[System.Console]::ReadKey() | Out-Null
