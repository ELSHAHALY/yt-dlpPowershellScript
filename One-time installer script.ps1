# =========================
# RUN AS ADMIN CHECK
# =========================
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()
    ).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "Restarting as Administrator..."
    Start-Process powershell "-ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    exit
}

Write-Host "=== Setup Started ==="

# =========================
# FOLDERS
# =========================
$toolsPath = "$env:USERPROFILE\Tools"
$ffmpegPath = "$toolsPath\ffmpeg"
$binPath = "$ffmpegPath\bin"

New-Item -ItemType Directory -Force -Path $toolsPath | Out-Null

# =========================
# 1. INSTALL yt-dlp
# =========================
if (-not (Get-Command yt-dlp -ErrorAction SilentlyContinue)) {
    Write-Host "Installing yt-dlp..."

    $url = "https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp.exe"
    Invoke-WebRequest -Uri $url -OutFile "$toolsPath\yt-dlp.exe"

    # Add to PATH (User)
    $envPath = [Environment]::GetEnvironmentVariable("Path", "User")
    if ($envPath -notlike "*yt-dlp*") {
        [Environment]::SetEnvironmentVariable("Path", "$envPath;$toolsPath", "User")
    }

    Write-Host "yt-dlp installed"
}
else {
    Write-Host "yt-dlp already installed"
}

# =========================
# 2. INSTALL FFMPEG
# =========================
if (-not (Get-Command ffmpeg -ErrorAction SilentlyContinue)) {
    Write-Host "Installing FFmpeg..."

    $ffmpegZip = "$toolsPath\ffmpeg.zip"
    $ffmpegUrl = "https://www.gyan.dev/ffmpeg/builds/ffmpeg-release-essentials.zip"

    Invoke-WebRequest -Uri $ffmpegUrl -OutFile $ffmpegZip

    Expand-Archive -Path $ffmpegZip -DestinationPath $toolsPath -Force

    # Move folder to stable name
    $extracted = Get-ChildItem $toolsPath | Where-Object { $_.Name -like "ffmpeg*" -and $_.PSIsContainer } | Select-Object -First 1
    Rename-Item $extracted.FullName $ffmpegPath -Force

    # Add to PATH
    $envPath = [Environment]::GetEnvironmentVariable("Path", "User")
    if ($envPath -notlike "*ffmpeg*") {
        [Environment]::SetEnvironmentVariable("Path", "$envPath;$binPath", "User")
    }

    Write-Host "FFmpeg installed"
}
else {
    Write-Host "FFmpeg already installed"
}

# =========================
# 3. INSTALL BURNTTOAST
# =========================
if (-not (Get-Module -ListAvailable -Name BurntToast)) {
    Write-Host "Installing BurntToast..."

    Install-Module BurntToast -Force -Scope CurrentUser
}
else {
    Write-Host "BurntToast already installed"
}

# =========================
# DONE
# =========================
Write-Host "=== Setup Complete ==="
Write-Host "Restart terminal to apply PATH changes"