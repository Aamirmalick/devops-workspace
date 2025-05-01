# Define the path to your normal Java JVM installation
$normalJavaPath = "C:\Program Files\Java\jdk-24"

# Check if the directory exists
if (!(Test-Path $normalJavaPath)) {
    Write-Host "❌ Normal JVM not found at $normalJavaPath"
    exit 1
}

# Set JAVA_HOME back to normal JVM
[System.Environment]::SetEnvironmentVariable("JAVA_HOME", $normalJavaPath, [System.EnvironmentVariableTarget]::Machine)
Write-Host "✅ JAVA_HOME set back to $normalJavaPath"

# Update the system PATH (optional but recommended)
$oldPath = [System.Environment]::GetEnvironmentVariable("Path", [System.EnvironmentVariableTarget]::Machine)
$newPath = "$normalJavaPath\bin;" + ($oldPath -replace "(.*?GraalVM.*?;)", "")  # Remove any GraalVM bin path
[System.Environment]::SetEnvironmentVariable("Path", $newPath, [System.EnvironmentVariableTarget]::Machine)
Write-Host "✅ PATH updated to use normal JVM"

Write-Host "`n🚀 Done! You may need to restart your terminal or system for changes to take effect."
