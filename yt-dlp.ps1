# Add the BurntToast module
Import-Module BurntToast

# Get the URL from clipboard
$url = Get-Clipboard

# Define log file path
$logFile = "$env:USERPROFILE\Scripts\Logs\download_log.txt"



if ($url -match "^(https?://)") {
    Write-Host "Downloading: $url"
    
    # Log the download initiation with timestamp
    Add-Content -Path $logFile -Value "$(Get-Date) - Started download: $url"
    
    # Run yt-dlp command
    yt-dlp -f "bestvideo+bestaudio" --merge-output-format mp4 --embed-thumbnail --add-metadata --force-overwrites -o "$env:USERPROFILE\Downloads\%(title)s.%(ext)s" $url

    # Log completion
    Add-Content -Path $logFile -Value "$(Get-Date) - Completed download: $url"

    # Send a toast notification
    New-BurntToastNotification -Text "Download Completed, Your video is ready in Downloads." 

    
} 
else {
    Write-Host "No valid YouTube URL found in clipboard."
    Add-Content -Path $logFile -Value "$(Get-Date) - No valid YouTube URL found in clipboard: $url"
    Start-Sleep -Seconds 3
}
