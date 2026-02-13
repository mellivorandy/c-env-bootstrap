[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

function Download-WithProgress {
    param ([string]$url, [string]$destination)
    Write-Host "Downloading from $url..." -ForegroundColor Gray
    Import-Module BitsTransfer
    Start-BitsTransfer -Source $url -Destination $destination -Description "Downloading" -DisplayName "Downloading"
}

Write-Host "`n`n`n`n`n`n`n`n"

# Run as Administrator
Write-Host "===============================================" -ForegroundColor Cyan
Write-Host "   C/C++ Programming Environment Auto-Setup   " -ForegroundColor Cyan
Write-Host "===============================================" -ForegroundColor Cyan

# 1. VSCode
if (!(Get-Command code -ErrorAction SilentlyContinue)) {
    Write-Host "`n[1/7] VSCode binary not detected. Downloading..." -ForegroundColor Yellow
    
    $vscodeUrl = "https://code.visualstudio.com/sha/download?build=stable&os=win32-x64"
    $vscodeInstaller = "$env:TEMP\vscode_setup.exe"
    
	Download-WithProgress -url $vscodeUrl -destination $vscodeInstaller
	
	Write-Host "Executing silent background installation..." -ForegroundColor Gray

    Start-Process $vscodeInstaller -ArgumentList "/VERYSILENT", "/MERGETASKS=!runcode,addtopath" -Wait
    
    Write-Host "`nVSCode installation successfully completed." -ForegroundColor Green
} else {
    Write-Host "`n[1/7] Existing VSCode installation detected; skipping..." -ForegroundColor Gray
}

# 2. Extensions
Write-Host "`n[2/7] Installing extensions (C/C++ Tools & Code Runner)..." -ForegroundColor Yellow

$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + `
            [System.Environment]::GetEnvironmentVariable("Path","User")

$codeCmd = if (Get-Command code -ErrorAction SilentlyContinue) { "code" } 
           else { "$env:LocalAppData\Programs\Microsoft VS Code\bin\code.cmd" }

if (!(Test-Path $codeCmd) -and $codeCmd -ne "code") {
    $codeCmd = "C:\Program Files\Microsoft VS Code\bin\code.cmd"
}

& $codeCmd --install-extension ms-vscode.cpptools
& $codeCmd --install-extension formulahendry.code-runner

Write-Host "`nExtension profiles successfully configured." -ForegroundColor Green

# 3. MSYS2
$msysPath = "C:\msys64"
$bashPath = "$msysPath\usr\bin\bash.exe"
$tarPath  = "$env:SystemRoot\System32\tar.exe"

if (!(Test-Path $bashPath)) {
    Write-Host "`n[3/7] Initializing MSYS2 toolchain environment..." -ForegroundColor Yellow
    
	$msysUrl = "https://repo.msys2.org/distrib/msys2-x86_64-latest.tar.zst"
    $archive = "$env:TEMP\msys2.tar.zst"
	
	Download-WithProgress -url $msysUrl -destination $archive
	
    Write-Host "Extracting archive..." -ForegroundColor Gray
    & $tarPath -xf $archive -C C:\

    Write-Host "Initializing MSYS2 keyring..." -ForegroundColor Gray
    & $bashPath -lc "pacman-key --init"
    & $bashPath -lc "pacman-key --populate"

    Write-Host "Updating base system..." -ForegroundColor Gray
    & $bashPath -lc "pacman -Syuu --noconfirm"

    Write-Host "`nMSYS2 installation completed." -ForegroundColor Green
}

# 4. GCC via MSYS2
if (Test-Path $bashPath) {
    Write-Host "`n[4/7] Synchronizing GCC toolchain via pacman..." -ForegroundColor Yellow
    & $bashPath -lc "pacman -S --noconfirm mingw-w64-x86_64-gcc"
    Write-Host "`nGCC toolchain synchronization completed." -ForegroundColor Green
} else {
    Write-Host "`nERROR: MSYS2 root directory not found." -ForegroundColor Red
    exit
}

# 5. Environment Variables
Write-Host "`n[5/7] Configuring environment variables..." -ForegroundColor Yellow

$gccBin = "C:\msys64\mingw64\bin"
$oldPath = [Environment]::GetEnvironmentVariable("Path", "User")

if ($oldPath -notlike "*$gccBin*") {
    $newPath = "$oldPath;$gccBin"
    [Environment]::SetEnvironmentVariable("Path", $newPath, "User")
    Write-Host "`nEnvironment variables updated successfully." -ForegroundColor Green
}

# 6. VSCode Settings
Write-Host "`n[6/7] Applying optimized VSCode configuration profiles..." -ForegroundColor Yellow
$sDir = "$env:APPDATA\Code\User"
if (!(Test-Path $sDir)) { New-Item -ItemType Directory $sDir -Force | Out-Null }
$sFile = "$sDir\settings.json"
$cfg = if (Test-Path $sFile) { Get-Content $sFile -Raw | ConvertFrom-Json } else { New-Object PSObject }

$cfg | Add-Member -MemberType NoteProperty -Name "code-runner.runInTerminal" -Value $true -Force
$cfg | Add-Member -MemberType NoteProperty -Name "code-runner.saveFileBeforeRun" -Value $true -Force
$cfg | Add-Member -MemberType NoteProperty -Name "code-runner.clearPreviousOutput" -Value $true -Force

$cfg | ConvertTo-Json -Depth 20 | Out-File $sFile -Encoding utf8
Write-Host "`nConfigurations applied." -ForegroundColor Green

# 7. Hello World Example
Write-Host "`n[7/7] Initializing test workspace..." -ForegroundColor Yellow

$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + `
            [System.Environment]::GetEnvironmentVariable("Path","User")

$projectPath = "$home\Desktop\hello-world"
New-Item -ItemType Directory -Path $projectPath -Force | Out-Null
Set-Location -Path $projectPath

$codeTemplate = @"
#include <iostream>

using namespace std;

int main() {
    cout << "Hello World! C++ Environment Ready!" << endl;
    return 0;
}
"@

$codeTemplate | Out-File -FilePath "main.cpp" -Encoding utf8

Write-Host "`nWorkspace initialized at Desktop\hello-world." -ForegroundColor Green
Write-Host "`nDeployment finalized. Launching Visual Studio Code..." -ForegroundColor Cyan

& $codeCmd .

Read-Host "`nPress Enter to finalize deployment and terminate the process"

Stop-Process -Id $PID
