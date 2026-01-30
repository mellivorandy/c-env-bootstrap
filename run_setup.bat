@echo off

pushd "%~dp0"

set "RED=[91m"
set "GREEN=[92m"
set "RESET=[0m"

net session >nul 2>&1
if %errorLevel% == 0 (
    echo %GREEN%[OK] Installing...%RESET%
) else (
    echo %RED%[!] ERROR: Administrative privileges required.%RESET%
    echo Please right-click this file and select "Run as Administrator".
	echo.
	pause
    exit
)

powershell.exe -NoProfile -ExecutionPolicy Bypass -File "setup.ps1"

if %errorLevel% neq 0 (
    echo.
    echo %RED%[!] Process terminated. (Error Code: %errorLevel%)%RESET%
    pause
)

popd
