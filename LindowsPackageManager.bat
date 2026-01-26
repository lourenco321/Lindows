@echo off
cls
echo Welcome back to Lindows Installer
echo.
echo We are almost done getting your system ready.
echo This installer will finish running unnatended in a few minutes...
echo.
echo.
echo.
echo.
echo.
echo.
echo Fixing Winget...
powershell -Command "Get-AppxPackage -AllUsers Microsoft.DesktopAppInstaller | ForEach {Add-AppxPackage -DisableDevelopmentMode -Register `$($_.InstallLocation)\AppXManifest.xml`}"

echo Installing 7zip...
winget install 7zip.7zip --accept-source-agreements --accept-package-agreements

echo Installing Git...
winget install --id Git.Git -e --accept-source-agreements --accept-package-agreements

echo Installing mpv...
winget install mpv.net --accept-source-agreements --accept-package-agreements
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
winget install OpenRGB.OpenRGB --accept-source-agreements --accept-package-agreements

echo Installing Steam...
winget install Valve.Steam --accept-source-agreements --accept-package-agreements

echo Installing Spotify...
winget install --id Spotify.Spotify -e --accept-source-agreements --accept-package-agreements

echo Installing BurntSushi...
echo Getting DLLs...
winget install --id Microsoft.VCRedist.2015+.x64 -e
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



REM === SET WALLPAPER ===
set "WALLPAPER_URL=https://raw.githubusercontent.com/lourenco321/Lindows/refs/heads/main/bg.png"
set "WALLPAPER_FILE=%TEMP%\lindows_bg.png"
echo Setting wallpaper...
powershell -Command ^
  "Invoke-WebRequest '%WALLPAPER_URL%' -OutFile '%WALLPAPER_FILE%'; ^
   Add-Type -TypeDefinition 'using System.Runtime.InteropServices; public class Wallpaper { [DllImport(\"user32.dll\", SetLastError=true)] public static extern bool SystemParametersInfo(int uAction, int uParam, string lpvParam, int fuWinIni); }'; ^
   [Wallpaper]::SystemParametersInfo(20, 0, '%WALLPAPER_FILE%', 3)"











echo.
echo.
echo.
echo.
echo Lindows Setup Finished!
echo =========================================
echo  The system will now restart
echo  Thanks for using Lindows :)
echo =========================================
echo.
start "" cmd /c "timeout /t 2 >nul & del \"%~f0\""
timeout /t 3 /nobreak >nul
shutdown /r /t 0
