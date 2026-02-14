# c-env-bootstrap &mdash; A streamlined, one-click automation tool for deploying C/C++ environments on Windows.

<br>

[English | [繁體中文](docs/zh-TW/README.md)]

<br>

[![Platform: Windows](https://img.shields.io/badge/Platform-Windows-357EC7.svg?logo=windows)](https://www.microsoft.com/windows)
[![Shell: PowerShell](https://img.shields.io/badge/Shell-PowerShell-4477D0.svg?logo=powershell)](https://github.com/PowerShell/PowerShell)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](https://github.com/mellivorandy/c-env-bootstrap?tab=MIT-1-ov-file#readme)

This script eliminates manual configuration by orchestrating the installation of the compiler, IDE, extensions, and system pathing in one execution.

<br>

## Overview

Setting up a C++ environment on Windows often involves fragmented steps (installing MSYS2, configuring MinGW, manually editing Environment Variables, and setting up VSCode JSON files). This script automates the entire pipeline to ensure a consistent environment for students and developers.

<br>

### Key Features
- **Automatically Set Up**: Silent installation of Visual Studio Code and MSYS2.

- **Toolchain Provisioning**: Automated MSYS2 environment initialization and `mingw-w64-x86_64-gcc` synchronization.

- **Extension Management**: Auto-installs Essential C++ Tools and Code Runner.

- **Intelligent Pathing**: Dynamically updates the User `PATH` without requiring a system reboot.

- **Best-Practice Configuration**: Injects optimized `settings.json` (Integrated Terminal, Auto-save, Output clearing).

- **Sanity Test**: Automatically generates a "Hello World" project to verify toolchain integrity.

<br>

## Components Included

| Component | Version / Source | Purpose |
| :--- | :--- | :--- |
| **VSCode** | Latest Stable (x64) | IDE |
| **MSYS2** | Latest Rolling | Software Distribution & Package Management |
| **MinGW-w64** | GCC Toolchain | Compiler, Linker, and Debugger |
| **Extensions** | C/C++ Tools, Code Runner | IntelliSense & One-click Execution |

<br>

## Prerequisites

* **OS**: Windows 10 or 11 (64-bit).

* **Permissions**: You must run the scripts as **Administrator**.

* **Network**: Active internet connection for downloading components (~300MB+).

<br>

## Installation

### 1. Download the Release Package

1. Go to the repository [Releases](https://github.com/mellivorandy/c-env-bootstrap/releases) section.

2. Download the latest release ZIP file (`c-env-bootstrap.zip`).

<br>

### 2. Extract the ZIP File

> [!IMPORTANT]
> ⚠️ Do NOT drag the script file out of the ZIP and run it directly. This may cause encoding issues or corrupted output.

Instead:

1. Right-click the downloaded ZIP file.

2. Select **"Extract All..."**

3. Choose a destination folder.

4. Click **Extract**.

After extraction, open the extracted folder.

<br>

### 3. (If Required) Allow Script Execution for This Session

If you see an execution policy error, do:

1. Right-click the **Start** button.

2. Select **Terminal (Admin)** or **Windows PowerShell (Admin)**.

3. Click **Yes** if prompted by UAC.

Then run:

```powershell
Set-ExecutionPolicy RemoteSigned -Scope Process
```

<br>

### 4. Run the Installer (Administrator Required)

1. Inside the extracted folder, locate: `run_setup.bat`

2. Right-click it and select **"Run as administrator"**

3. Click **Yes** if prompted by UAC

The setup process will then start automatically.

<br>

## What the Installer Does

The installer will automatically:

- Install Visual Studio Code (if not installed)
- Install required extensions
- Install MSYS2
- Install GCC toolchain
- Configure environment variables
- Create a `Hello World` project on the Desktop

<br>

## Notes

- Administrator privileges are required.

- Do not run the script directly from inside the ZIP file.

- On some systems, PowerShell execution policy restrictions may apply.  

<br>

## License

This project is licensed under <a href="LICENSE">MIT license</a>, so feel free to use it for educational or professional purposes.
