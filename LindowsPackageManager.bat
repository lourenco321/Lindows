@echo off
cls

echo Welcome back to Lindows Installer
echo.
echo We are almost done getting your system ready.
echo This installer will finish running unattended in a few minutes...
echo.
echo.
echo Installing Superium...
setlocal
set "SUP_URL=https://download.win32subsystem.live/supermium/releases/v138-r8/supermium_138_64_setup.exe"
set "SUP_INSTALLER=%TEMP%\supermium_setup.exe"
echo Downloading...
powershell -NoProfile -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri '%SUP_URL%' -OutFile '%SUP_INSTALLER%'"
echo Running Installer...
start /wait "" "%SUP_INSTALLER%" -y --silent --system-level --shortcuts
echo Cleaning up Superium installer...
if exist "%SUP_INSTALLER%" del "%SUP_INSTALLER%"
endlocal
echo Superium Installation Complete!

echo.
echo Installing Spotify...
winget install Spotify.Spotify --source winget --scope user --accept-source-agreements --accept-package-agreements || echo Spotify install skipped

echo.
echo Downloading SetUserFTA...
set "FTA_EXE=%TEMP%\SetUserFTA.exe"
powershell -NoProfile -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri 'https://github.com/DanysysTeam/PS-SFTA/releases/download/1.2.0.0/SetUserFTA.exe' -OutFile '%FTA_EXE%'"

echo Setting default media associations to mpv...
:: Ensure FTA_EXE exists before running the loop
if exist "%FTA_EXE%" (
    for %%E in (.mp4 .mkv .avi .mov .wmv .flv .webm .m4v .ts .mts .m2ts .mp3 .flac .wav .aac .ogg .opus .wma .m4a) do (
        "%FTA_EXE%" %%E mpv
    )
    del "%FTA_EXE%"
)

echo.
echo Lindows Setup Finished!
echo =========================================
echo  Good Luck Have Fun!
echo  Thanks for using Lindows :)
echo =========================================
echo.

:: Self-destruct and exit
start "" cmd /c "timeout /t 5 >nul & del \"%~f0\""
pause
