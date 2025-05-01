# Define the path to your GraalVM installation
$graalVMPath = "C:\SoftwareFiles\DownloadFromPowershell\graalvm-jdk-24+36.1"

# Check if the directory exists
if (!(Test-Path $graalVMPath)) {
    Write-Host "❌ GraalVM not found at $graalVMPath"
    exit 1
}

# Set JAVA_HOME to GraalVM
[System.Environment]::SetEnvironmentVariable("JAVA_HOME", $graalVMPath, [System.EnvironmentVariableTarget]::User)
Write-Host "✅ JAVA_HOME set to $graalVMPath"

# Update the PATH environment variable
$oldPath = [System.Environment]::GetEnvironmentVariable("Path", [System.EnvironmentVariableTarget]::Machine)

# Remove any previous Java paths
$cleanPath = ($oldPath -split ";") | Where-Object { $_ -notmatch "Java" -and $_ -notmatch "GraalVM" }

# Add GraalVM's bin directory
$newPath = ($cleanPath + "$graalVMPath\bin") -join ";"
[System.Environment]::SetEnvironmentVariable("Path", $newPath, [System.EnvironmentVariableTarget]::User)
Write-Host "✅ PATH updated with GraalVM bin"

# Confirm switch
Write-Host "🎉 Switched to GraalVM. You may need to restart your terminal or system for changes to apply."

