# c-env-bootstrap &mdash; 專為 Windows 設計的一鍵 C/C++ 環境部署工具。

<br>

[[English](../../README.md) | 繁體中文]

<br>

[![Platform: Windows](https://img.shields.io/badge/Platform-Windows-357EC7.svg?logo=windows)](https://www.microsoft.com/windows)
[![Shell: PowerShell](https://img.shields.io/badge/Shell-PowerShell-4477D0.svg?logo=powershell)](https://github.com/PowerShell/PowerShell)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](https://github.com/mellivorandy/c-env-bootstrap?tab=MIT-1-ov-file#readme)

此腳本透過自動化編譯器、IDE、擴充功能安裝以及系統路徑配置，徹底消除手動設定的繁瑣步驟。

<br>

## 總覽

在 Windows 上設定 C++ 環境通常涉及多個零碎步驟（安裝 MSYS2、配置 MinGW、手動編輯環境變數以及設定 VSCode JSON 檔案等）。本腳本將整個流程自動化，確保學生與開發者能擁有一致且穩定的開發環境。

<br>

### 核心功能
- **自動化安裝**：靜默安裝 Visual Studio Code 與 MSYS2。

- **工具鏈配置**：自動初始化 MSYS2 環境並同步安裝 `mingw-w64-x86_64-gcc`。

- **擴充功能管理**：自動安裝必要的 C++ 工具（C/C++ Tools）與 Code Runner。

- **智慧路徑設定**：動態更新使用者 `PATH` 環境變數，無需重啟系統即可生效。

- **最佳實踐配置**：寫入優化後的 `settings.json`（包含整合終端機、自動儲存、輸出清理等設定）。

- **健全性測試**：自動產生 "Hello World" 專案以驗證工具鏈是否運作正常。

<br>

## 包含元件

| 元件名稱 | 版本 / 來源 | 用途 |
| :--- | :--- | :--- |
| **VSCode** | 最新穩定版 (x64) | 整合開發環境 (IDE) |
| **MSYS2** | 最新滾動更新版 | 軟體分發與套件管理系統 |
| **MinGW-w64** | GCC 工具鏈 | 編譯器、連結器與除錯器 |
| **Extensions** | C/C++ Tools, Code Runner | 程式碼補完 (IntelliSense) 與一鍵執行 |

<br>

## 系統需求

- **作業系統**：Windows 10 或 11 (64-bit)。

- **權限要求**：必須以 **系統管理員 (Administrator)** 身分執行腳本。

- **網路連線**：需具備網際網路連線以進行元件下載（約 300MB+）。

<br>

## 安裝步驟

### 1. 下載發布套件

1. 前往本專案的 [Releases](https://github.com/mellivorandy/c-env-bootstrap/releases) 頁面。

2. 下載最新的版本 ZIP 壓縮檔 (`Source code (zip)`)。

<br>

### 2. 解壓縮 ZIP 檔案

> [!IMPORTANT]
> ⚠️ 請勿直接從 ZIP 預覽視窗中將腳本拖出來執行。這可能會導致編碼錯誤或執行異常。

正確步驟：

1. 在下載的 ZIP 檔案上點擊右鍵。

2. 選擇 **「全部解壓縮...」**。

3. 選擇目標資料夾。

4. 點擊 **解壓縮**。

解壓縮完成後，請進入該資料夾。

<br>

### 3. (如有需要) 允許此工作階段執行腳本

如果您遇到執行原則錯誤（Execution Policy Error），請：

1. 右鍵點擊 **開始** 按鈕。

2. 選擇 **終端機 (管理員)** 或 **Windows PowerShell (系統管理員)**。

3. 若跳出使用者帳戶控制 (UAC) 視窗，請點擊 **「是」**。

接著執行以下指令：

```powershell
Set-ExecutionPolicy RemoteSigned -Scope Process
```

<br>

### 4. 執行安裝程式 (需管理員權限)

1. 在剛剛解壓縮後的資料夾中，找到：`run_setup.bat`。

2. 在該檔案上點擊右鍵，選擇 `「以系統管理員身分執行」`。

3. 若跳出 UAC 視窗，請點擊 `「是」`。

安裝程序隨即會自動開始運作。

<br>

## 安裝程式運作內容

本安裝程式將自動執行以下動作：

- 安裝 Visual Studio Code (若尚未安裝)
- 安裝必要的 VSCode 擴充功能
- 安裝 MSYS2
- 安裝 GCC 編譯工具鏈
- 配置系統環境變數
- 在桌面建立一個 `Hello World` 專案範例

<br>

## 注意事項

- 必須具備系統管理員權限。

- 請勿直接在 ZIP 壓縮檔內運行腳本。

- 在某些系統上，可能會受到 PowerShell 執行原則的限制。

<br>

## License

本專案採用 <a href="LICENSE">MIT license</a>，歡迎自由用於教學或專業用途。
