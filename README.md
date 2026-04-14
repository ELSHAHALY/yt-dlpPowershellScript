# 🎬 Smart Video Downloader (yt-dlp Automation)

## 🚀 Overview

A PowerShell-based automation tool that:

* Downloads videos/audio from any supported site (YouTube, Instagram, etc.)
* Uses clipboard URL (no manual paste)
* Lets you choose quality (1–5 menu)
* Sends Windows notifications
* Logs downloads + errors
* Opens Downloads folder automatically

---

## 🧰 Requirements

Make sure these are installed:

### 1. Install dependencies (run once)

```powershell
winget install -e --id yt-dlp.yt-dlp
winget install -e --id Gyan.FFmpeg
Install-Module BurntToast -Scope CurrentUser -Force
```

---

## 📂 Project Structure

```
Scripts/
 ├── DownloadAnyVideo.ps1
 ├── Logs/
 │    └── download_log.txt
```

---

## ▶️ How It Works

1. Copy a video URL
2. Run the script (via shortcut)
3. Choose option:

| Option | Action       |
| ------ | ------------ |
| 1      | Best quality |
| 2      | 720p         |
| 3      | 480p         |
| 4      | 144p         |
| 5      | Audio only   |

4. Download starts automatically
5. Notification appears when done
6. Downloads folder opens

---

## 📊 Features

* ✅ Clipboard automation
* ✅ Multiple quality options
* ✅ MP4 video output
* ✅ M4A audio output (fast + high quality)
* ✅ BurntToast notifications
* ✅ Error logging (real failure reasons)
* ✅ Auto open Downloads folder

---

## 🔄 Updating Tools

```powershell
winget upgrade --all
```

---

## ⚠️ Notes

* Restart terminal after installing tools
* Make sure PowerShell execution policy allows scripts:

```powershell
Set-ExecutionPolicy -Scope CurrentUser Bypass
```

---

## 👨‍💻 Author

Built as a personal automation tool 🚀
