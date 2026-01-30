[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

function Download-WithProgress {
    param ([string]$url, [string]$destination)
    Write-Host "正在從 $url 下載..." -ForegroundColor Gray
    Import-Module BitsTransfer
    Start-BitsTransfer -Source $url -Destination $destination -Description "Downloading" -DisplayName "Downloading"
}

Write-Host "`n`n`n`n`n`n`n`n"

# Run as Administrator
Write-Host "===============================================" -ForegroundColor Cyan
Write-Host "        C/C++ 開發環境自動化部署工具           " -ForegroundColor Cyan
Write-Host "===============================================" -ForegroundColor Cyan

# 1. VSCode
if (!(Get-Command code -ErrorAction SilentlyContinue)) {
    Write-Host "`n[1/7] 正在安裝 Visual Studio Code..." -ForegroundColor Yellow
    $vscodeUrl = "https://code.visualstudio.com/sha/download?build=stable&os=win32-x64"
    $vscodeInstaller = "$env:TEMP\vscode_setup.exe"
    
	Download-WithProgress -url $vscodeUrl -destination $vscodeInstaller
	
	Write-Host "正在執行背景安裝..." -ForegroundColor Gray
    Start-Process $vscodeInstaller -ArgumentList "/VERYSILENT", "/MERGETASKS=!runcode,addtopath" -Wait
    Write-Host "`n✔  VSCode 安裝完成。" -ForegroundColor Green
} else {
    Write-Host "`n[1/7] 偵測到 VSCode 已存在，跳過安裝。" -ForegroundColor Gray
}

# 2. Extensions
Write-Host "`n[2/7] 正在安裝擴充套件 (C/C++ & Code Runner)..." -ForegroundColor Yellow

$env:Path = [System.Environment]::GetEnvironmentVariable("
Path","Machine") + ";" + `
            [System.Environment]::GetEnvironmentVariable("Path","User")

$codeCmd = if (Get-Command code -ErrorAction SilentlyContinue) { "code" } 
           else { "$env:LocalAppData\Programs\Microsoft VS Code\bin\code.cmd" }

if (!(Test-Path $codeCmd) -and $codeCmd -ne "code") {
    $codeCmd = "C:\Program Files\Microsoft VS Code\bin\code.cmd"
}

& $codeCmd --install-extension ms-vscode.cpptools
& $codeCmd --install-extension formulahendry.code-runner
Write-Host "`n✔  擴充套件配置成功!" -ForegroundColor Green

# 3. MSYS2
$msysPath = "C:\msys64"
$bashPath = "$msysPath\usr\bin\bash.exe"

if (!(Test-Path $bashPath)) {
    Write-Host "`n[3/7] 正在安裝 MSYS2 編譯環境..." -ForegroundColor Yellow
    
	$msysUrl = "https://github.com/msys2/msys2-installer/releases/download/2025-12-13/msys2-x86_64-20251213.exe"
    $msysInstaller = "$env:TEMP\msys2_setup.exe"
	
	Download-WithProgress -url $msysUrl -destination $msysInstaller
	
    Write-Host "`n請於彈出視窗中手動完成 MSYS2 安裝程序。(詳見簡報)" -ForegroundColor Magenta
    Start-Process $msysInstaller -Wait
}

# 4. GCC via MSYS2
if (Test-Path $bashPath) {
    Write-Host "`n[4/7] 正在安裝 GCC 編譯器..." -ForegroundColor Yellow
    & $bashPath -lc "pacman -S --noconfirm mingw-w64-x86_64-gcc"
    Write-Host "`n✔  GCC 工具鏈部署完成。" -ForegroundColor Green
} else {
    Write-Host "`n❌ 錯誤：無法找到 MSYS2 路徑。" -ForegroundColor Red
    exit
}

# 5. Environment Path
Write-Host "`n[5/7] 正在設定環境變數..." -ForegroundColor Yellow

$gccBin = "C:\msys64\mingw64\bin"
$oldPath = [Environment]::GetEnvironmentVariable("Path", "User")

if ($oldPath -notlike "*$gccBin*") {
    $newPath = "$oldPath;$gccBin"
    [Environment]::SetEnvironmentVariable("Path", $newPath, "User")
    Write-Host "`n✔  環境變數更新成功。" -ForegroundColor Green
}

# 6. VSCode Settings
Write-Host "`n[6/7] 正在調整 VSCode 設定..." -ForegroundColor Yellow
$sDir = "$env:APPDATA\Code\User"
if (!(Test-Path $sDir)) { New-Item -ItemType Directory $sDir -Force | Out-Null }
$sFile = "$sDir\settings.json"
$cfg = if (Test-Path $sFile) { Get-Content $sFile -Raw | ConvertFrom-Json } else { New-Object PSObject }

$cfg | Add-Member -MemberType NoteProperty -Name "code-runner.runInTerminal" -Value $true -Force
$cfg | Add-Member -MemberType NoteProperty -Name "code-runner.saveFileBeforeRun" -Value $true -Force
$cfg | Add-Member -MemberType NoteProperty -Name "code-runner.clearPreviousOutput" -Value $true -Force

$cfg | ConvertTo-Json -Depth 20 | Out-File $sFile -Encoding utf8
Write-Host "`n✔  設定完成。" -ForegroundColor Green

# 7. Hello World Example
Write-Host "`n[7/7] 正在建立測試專案..." -ForegroundColor Yellow

$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + `
            [System.Environment]::GetEnvironmentVariable("Path","User")

$projectPath = "$home\Desktop\hello-world"
New-Item -ItemType Directory -Path $projectPath -Force | Out-Null
Set-Location -Path $projectPath

$codeTemplate = @"
#include <iostream>

using namespace std;

int main() {
    cout << "Hello World! C++ 環境安裝成功！" << endl;
    return 0;
}
"@

$codeTemplate | Out-File -FilePath "main.cpp" -Encoding utf8

Write-Host "`n✔  專案已建立於桌面 hello-world 資料夾。" -ForegroundColor Green
Write-Host "`n安裝準備就緒！正在為您開啟 VSCode..." -ForegroundColor Cyan

& $codeCmd .

Read-Host "`n請按 Enter 鍵結束安裝並關閉視窗"

Stop-Process -Id $PID
