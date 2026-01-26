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
winget install Superium.Superium --source winget --accept-source-agreements --accept-package-agreements

echo Installing Spotify...
winget install Spotify.Spotify --source winget --scope user --accept-source-agreements --accept-package-agreements || echo Spotify install skipped

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




