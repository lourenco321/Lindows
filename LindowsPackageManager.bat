@echo off
cls

echo Welcome back to Lindows Installer
echo.
echo We are almost done getting your system ready.
echo This installer will finish running unattended in a few minutes...
echo.
echo.


echo.
echo Installing Spotify...
winget install Spotify.Spotify --source winget --scope user --accept-source-agreements --accept-package-agreements || echo Spotify install skipped

echo.
echo Downloading SetUserFTA...
set "FTA_EXE=%TEMP%\SetUserFTA.exe"
set "FTA_URL=https://raw.githubusercontent.com/qis/windows/master/setup/SetUserFTA/SetUserFTA.exe"

echo Downloading SetUserFTA mirror...
powershell -NoProfile -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; $web = New-Object System.Net.WebClient; $web.Headers.Add('User-Agent', 'Mozilla/5.0'); $web.DownloadFile('%FTA_URL%', '%FTA_EXE%')"

echo Setting default media associations to mpv...
if exist "%FTA_EXE%" (
    echo Applying associations to mpv...
    for %%E in (.mp4 .mkv .avi .mov .wmv .flv .webm .m4v .ts .mts .m2ts .mp3 .flac .wav .aac .ogg .opus .wma .m4a) do (
        "%FTA_EXE%" %%E mpv
    )
    del "%FTA_EXE%"
    echo Associations updated.
) else (
    echo [ERROR] SetUserFTA could not be prepared. Skipping.
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


