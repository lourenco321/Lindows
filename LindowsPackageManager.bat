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
echo Setting default media associations to mpv...
powershell -ExecutionPolicy Bypass -NoProfile -Command "& { [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/DanysysTeam/PS-SFTA/master/SFTA.ps1')); $mpvPath = \"$env:LOCALAPPDATA\Programs\mpv.net\mpvnet.exe\"; $exts = '.mp4','.mkv','.avi','.mov','.wmv','.flv','.webm','.m4v','.ts','.mts','.m2ts','.mp3','.flac','.wav','.aac','.ogg','.opus','.wma','.m4a'; foreach ($ext in $exts) { Register-FTA -ProgramPath $mpvPath -Extension $ext } }"

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





