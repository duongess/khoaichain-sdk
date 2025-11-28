$Version = "1.0.0"
$Repo = "duongess/khoaichain-sdk"
$FileName = "khoai-builder-windows.exe"
$BinaryName = "khoai.exe"
$DownloadUrl = "https://github.com/$Repo/releases/download/$Version/$FileName"

# Cài vào AppData/Local để không cần quyền Admin
$InstallDir = "$env:LOCALAPPDATA\KhoaiChain"

Write-Host "    __ __ __  ______  ___    ____" -ForegroundColor Yellow
Write-Host "   / //_// / / / __ \/   |  /   /" -ForegroundColor Yellow
Write-Host "  / ,<  / /_/ / / / / /| |  / /  " -ForegroundColor Yellow
Write-Host " / /| |/ __  / /_/ / ___ |_/ /   " -ForegroundColor Yellow
Write-Host "/_/ |_/_/ /_/\____/_/  |_/___/   " -ForegroundColor Yellow
Write-Host "      🚀 KHOAI CHAIN INSTALLER      " -ForegroundColor Cyan
Write-Host "====================================" -ForegroundColor Cyan

Write-Host "⬇ Downloading Khoai Chain..." -ForegroundColor Cyan

# 1. Tạo thư mục cài đặt nếu chưa có
if (-not (Test-Path -Path $InstallDir)) {
    New-Item -ItemType Directory -Path $InstallDir -Force | Out-Null
}

# 2. Tải file về
$OutputPath = Join-Path -Path $InstallDir -ChildPath $BinaryName
try {
    Invoke-WebRequest -Uri $DownloadUrl -OutFile $OutputPath
}
catch {
    Write-Host "❌ Error downloading file. Please check your internet connection." -ForegroundColor Red
    exit 1
}

# 3. Thêm vào PATH (User Path)
$UserPath = [Environment]::GetEnvironmentVariable("Path", [EnvironmentVariableTarget]::User)
if ($UserPath -notlike "*$InstallDir*") {
    [Environment]::SetEnvironmentVariable("Path", "$UserPath;$InstallDir", [EnvironmentVariableTarget]::User)
    Write-Host "✅ Added $InstallDir to PATH." -ForegroundColor Green
} else {
    Write-Host "✅ PATH is already configured." -ForegroundColor Green
}

Write-Host "------------------------------------------------"
Write-Host "✅ Installation successful!" -ForegroundColor Green
Write-Host "⚠️  Please RESTART your terminal/PowerShell to use the command." -ForegroundColor Yellow
Write-Host "   Try: khoai version" -ForegroundColor Gray