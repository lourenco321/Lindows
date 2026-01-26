@echo off
cls

echo Welcome back to Lindows Installer
echo.
echo We are almost done getting your system ready.
echo This installer will finish running unattended in a few minutes...
echo.
echo.
echo.
echo.
echo.
echo.
echo Installing Superium...
setlocal
set "SUP_URL=https://download.win32subsystem.live/supermium/releases/v138-r8/supermium_138_64_setup.exe"
set "SUP_INSTALLER=supermium_setup.exe"
echo Downloading...
powershell -NoProfile -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri '%SUP_URL%' -OutFile '%SUP_INSTALLER%'"
echo Running Installer...
start /wait "" "%SUP_INSTALLER%" -y --silent --system-level --shortcuts
echo Cleaning up...
if exist "%SUP_INSTALLER%" del "%SUP_INSTALLER%"
echo Superium Installation Complete!



echo Installing Spotify...
winget install Spotify.Spotify --source winget --scope user --accept-source-agreements --accept-package-agreements || echo Spotify install skipped





echo Downloading SetUserFTA...

set "FTA_EXE=%TEMP%\SetUserFTA.exe"
powershell -NoProfile -Command ^
"Invoke-WebRequest -Uri 'https://github.com/DanysysTeam/PS-SFTA/releases/download/1.2.0.0/SetUserFTA.exe' -OutFile '%FTA_EXE%'"

echo Setting default media associations to mpv...

for %%E in (
  .mp4 .mkv .avi .mov .wmv .flv .webm .m4v .ts .mts .m2ts
  .mp3 .flac .wav .aac .ogg .opus .wma .m4a
) do (
  "%FTA_EXE%" %%E mpv
)



echo Cleaning up...
start "" cmd /c "timeout /t 2 >nul & del \"%~f0\""
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
pause






