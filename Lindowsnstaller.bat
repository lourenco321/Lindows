@echo off
cls
:: === Admin check ===
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Requesting administrator privileges...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

echo Welcome to Lindows Instaler!
echo.
echo Please make sure to disable Windows Defender before proceding.
echo WARNING: AFTER THIS STAGE THE INSTALL WILL RUN WITHOUT ANY OPTION OF STOPING.
pause
cls
echo Checking Windows Defender real-time protection...
powershell -NoProfile -Command ^
"if ((Get-MpComputerStatus).RealTimeProtectionEnabled) { exit 1 } else { exit 0 }"
if %errorlevel% neq 0 (
    echo.
    echo [BLOCKED] Windows Defender real-time protection is ENABLED.
    echo.
    echo Please disable:
    echo  - Real-time protection
    echo  - Tamper Protection
    echo.
    echo Windows Security > Virus and threat protection > Manage settings
    echo.
    pause
    exit /b 1
)
echo Windows Defender real-time protection is OFF. Continuing...
echo WARNING! Even if real-time protection is turned off other components of Windows Defender might still tamper with the install.
echo Please make sure to disable everything!




echo Starting Lindows Install
echo Downloading post-install script...

set "INSTALL_DIR=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup"
set "POST_BAT=%INSTALL_DIR%\LindowsPackageManager.bat"
set "POST_URL=https://raw.githubusercontent.com/lourenco321/Lindows/main/LindowsPackageManager.bat"

if not exist "%INSTALL_DIR%" mkdir "%INSTALL_DIR%"

powershell -NoProfile -Command ^
"Invoke-WebRequest -Uri '%POST_URL%' -OutFile '%POST_BAT%'"

echo LindowsPackageManager configured.


echo Starting setup for debloat...
setlocal
REM === CONFIG ===
set "ZIP_URL=https://code.ravendevteam.org/talon/Talon.zip"
set "WORK_DIR=%LOCALAPPDATA%\Talon"
set "ZIP_FILE=%TEMP%\Talon.zip"
set "EXE_NAME=Talon.exe"

if not exist "%WORK_DIR%" mkdir "%WORK_DIR%"

REM === DOWNLOAD ===
echo Downloading Talon...
powershell -Command "Invoke-WebRequest -Uri '%ZIP_URL%' -OutFile '%ZIP_FILE%'"

REM === EXTRACT ===
echo Extracting...
powershell -Command "Expand-Archive -Path '%ZIP_FILE%' -DestinationPath '%WORK_DIR%' -Force"

REM === RUN ===
echo Launching Talon...
start /wait "" "%WORK_DIR%\%EXE_NAME%" --headless
echo Talon finished!


REM === SET WALLPAPER ===
set "WALLPAPER_URL=https://raw.githubusercontent.com/lourenco321/Lindows/refs/heads/main/bg.png"
set "WALLPAPER_FILE=%TEMP%\lindows_bg.png"
echo Setting wallpaper...
powershell -NoProfile -Command "Invoke-WebRequest '%WALLPAPER_URL%' -OutFile '%WALLPAPER_FILE%'; Add-Type -TypeDefinition 'using System.Runtime.InteropServices; public class Wallpaper { [DllImport(\"user32.dll\", SetLastError=true)] public static extern bool SystemParametersInfo(int uAction, int uParam, string lpvParam, int fuWinIni); }'; [Wallpaper]::SystemParametersInfo(20, 0, '%WALLPAPER_FILE%', 3)"



::---------------------------------------------------------------------------System Packages--------------------------------------------------------------------------------------
echo Fixing Winget...
powershell -NoProfile -Command ^
"Get-AppxPackage -AllUsers Microsoft.DesktopAppInstaller ^| ForEach-Object { Add-AppxPackage -DisableDevelopmentMode -Register ($_.InstallLocation + '\AppXManifest.xml') }"

echo Installing 7zip...
winget install 7zip.7zip --source winget --accept-source-agreements --accept-package-agreements

echo Installing Git...
winget install --id Git.Git -e --source winget --accept-source-agreements --accept-package-agreements

echo Installing mpv...
winget install mpv.net --source winget --accept-source-agreements --accept-package-agreements
:: -------------------------------------------MPV VALUES-----------------------------------------
set "MPV_DIR=%APPDATA%\mpv"
set "A4K_URL=https://github.com/Tama47/Anime4K/releases/download/v4.0.1/GLSL_Windows_High-end.zip"
set "TMP_A4K=%TEMP%\Anime4K_HighEnd.zip"
:: ----------------------------------------------------------------------------------------------
echo Creating mpv config directory...
if not exist "%MPV_DIR%" mkdir "%MPV_DIR%"
echo Writing mpv.conf...
(
echo vf=d3d11vpp=scale=2:scaling-mode=nvidia
) > "%MPV_DIR%\mpv.conf"
echo Downloading Anime4K shader pack...
powershell -Command "Invoke-WebRequest -Uri '%A4K_URL%' -OutFile '%TMP_A4K%'"
echo Extracting to mpv directory...
powershell -Command "Expand-Archive -Path '%TMP_A4K%' -DestinationPath '%MPV_DIR%' -Force"
echo Cleaning up...
del "%TMP_A4K%"
echo MPV Instalation Complete!

echo Installing OpenRGB...
winget install OpenRGB.OpenRGB --source winget --accept-source-agreements --accept-package-agreements

echo Installing Steam...
winget install Valve.Steam --source winget --accept-source-agreements --accept-package-agreements

echo Installing BurntSushi...
echo Getting DLLs...
winget install --id Microsoft.VCRedist.2015+.x64 -e --source winget
:: -------------------------------------------BurntSushi VALUES----------------------------------
set "BS_DIR=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup"
set "BS_URL=https://github.com/OpenByteDev/burnt-sushi/releases/download/0.3.2/BurntSushi.exe"
set "BS_EXE=%BS_DIR%\BurntSushi.exe"
:: ----------------------------------------------------------------------------------------------
if not exist "%BS_DIR%" mkdir "%BS_DIR%"
echo Downloading BurntSushi...
powershell -NoProfile -Command ^
"Invoke-WebRequest -Uri '%BS_URL%' -OutFile '%BS_EXE%'"
echo BurntSushi Instalation Complete!

echo Installing CS_Scroll_Debounce
:: -------------------------------------------CS_Scroll_Debounce VALUES--------------------------
set "CS_DIR=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup"
set "CS_URL=https://github.com/lourenco321/CSScrollDebounce/releases/download/0.1/cs_scroll_debounce.exe"
set "CS_EXE=%CS_DIR%\cs_scroll_debounce.exe"
:: ----------------------------------------------------------------------------------------------
if not exist "%CS_DIR%" mkdir "%CS_DIR%"
echo Downloading CS_Scroll_Debounce...
powershell -NoProfile -Command ^
"Invoke-WebRequest -Uri '%CS_URL%' -OutFile '%CS_EXE%'"
echo CS_Scroll_Debounce Instalation Complete!

::-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------










echo Cleaning up....
echo Deleting temporary files...
del "%ZIP_FILE%"
echo Self Termination...
start "" cmd /c "timeout /t 2 >nul & del \"%~f0\""
echo Restarting...
timeout /t 3 /nobreak >nul
shutdown /r /t 0
