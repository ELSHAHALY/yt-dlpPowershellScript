# Add the BurntToast module
Import-Module BurntToast

# Init variables
$url = Get-Clipboard
$audioOnly = $false
$logFile = "$env:USERPROFILE\Scripts\Logs\download_log.txt"


# Menu
Write-Host "1: Best Quality video + audio"
Write-Host "2: 720p"
Write-Host "3: 480p"
Write-Host "4: 144p"
Write-Host "5: Best Audio only"

# Wait for input (execution pauses here)
$choice = Read-Host "Choose option"

# Decision
switch ($choice) {
    "1" { $format = "bestvideo+bestaudio"; $quality = "Best" }
    "2" { $format = "bestvideo[height<=720]+bestaudio"; $quality = "720p" }
    "3" { $format = "bestvideo[height<=480]+bestaudio"; $quality = "480p" }
    "4" { $format = "bestvideo[height<=144]+bestaudio"; $quality = "144p" }
    "5" { $audioOnly = $true; $quality = "Audio" }
    default { 
        $format = "bestvideo[height<=720]+bestaudio"
        $quality = "720p (default)"
    }
}

# Validate URL
if (-not ($url -match "^(https?://)")) {
    Write-Host "Invalid URL"
    New-BurntToastNotification -Text "Download Failed", "Invalid URL in clipboard"
    exit
}

# Get metadata FIRST
$meta = yt-dlp --print "%(title)s|%(duration_string)s|%(ext)s" $url
$title, $duration, $ext = $meta -split "\|"

# Log start
Add-Content $logFile "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') - START: $url | $title [$quality]"

# Run download and capture output
if ($audioOnly) {
    $output = yt-dlp -x --audio-format m4a --embed-thumbnail --add-metadata --force-overwrites `
        -o "$env:USERPROFILE\Downloads\%(title)s.%(ext)s" $url 2>&1
}
else {
    $output = yt-dlp -f $format --merge-output-format mp4 --embed-thumbnail --add-metadata --force-overwrites `
        -o "$env:USERPROFILE\Downloads\%(title)s.%(ext)s" $url 2>&1
}

# Check success
if ($LASTEXITCODE -eq 0) {
    Add-Content $logFile "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') - DONE: $title | $ext | $duration | $quality"

    # Open Downloads folder
    Start-Process "$env:USERPROFILE\Downloads"

    New-BurntToastNotification -Text "Download Complete", "$title [$quality]"
}
else {
    $errorMessage = ($output | Select-String "ERROR").Line

    Add-Content $logFile "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') - FAILED: $url"
    Add-Content $logFile "Error: $errorMessage"

    New-BurntToastNotification -Text "Download Failed", "Check log for reason"

}