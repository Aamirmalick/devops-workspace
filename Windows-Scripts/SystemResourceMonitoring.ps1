# Import iTextSharp DLLs
Add-Type -Path "itext7/lib/netstandard2.0/itext.kernel.dll"
Add-Type -Path "itext7/lib/netstandard2.0/itext.layout.dll"

# Function to Create PDF
function Create-PDFReport {
    param (
        [string]$filePath,
        [string]$content
    )

    # Create PDF Document
    $writer = New-Object iText.Kernel.Pdf.PdfWriter($filePath)
    $pdf = New-Object iText.Kernel.Pdf.PdfDocument($writer)
    $document = New-Object iText.Layout.Document($pdf)

    # Add content to PDF
    $paragraph = New-Object iText.Layout.Element.Paragraph($content)
    $document.Add($paragraph)

    # Close the document
    $document.Close()

    Write-Output "PDF Report Generated: $filePath"
}

# Gather System Data
$cpuUsage = Get-Counter '\\Processor(_Total)\\% Processor Time' | Select-Object -ExpandProperty CounterSamples | Select-Object -ExpandProperty CookedValue
$memoryUsage = (Get-CimInstance Win32_OperatingSystem).FreePhysicalMemory / 1MB
$diskUsage = Get-PSDrive -PSProvider FileSystem | Select-Object Name, Free, Used
$networkStatus = Test-Connection -ComputerName 8.8.8.8 -Count 1 -Quiet

# Generate Report Content
$reportContent = @"
System Health Report
=====================
CPU Usage: $([math]::Round($cpuUsage,2))%
Memory Usage: $([math]::Round($memoryUsage,2)) GB
Network Status: $(if ($networkStatus) {'Online'} else {'Offline'})

Disk Usage:
"@

$diskUsage | ForEach-Object { 
    $reportContent += "Drive $($_.Name): Free Space: $([math]::Round($_.Free/1GB,2)) GB, Used Space: $([math]::Round($_.Used/1GB,2)) GB`n"
}

# Save PDF Report
$reportPath = "SystemHealthReport.pdf"
Create-PDFReport -filePath $reportPath -content $reportContent
