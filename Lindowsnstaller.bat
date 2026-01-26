@echo off
cls
echo Welcome to Lindows Instaler!
echo.
echo Please make sure to disable Windows Defender before proceding.
echo WARNING: AFTER THIS STAGE THE INSTALL WILL RUN WITHOUT ANY OPTION OF STOPING.
pause
cls
echo Starting Lindows Install
:: === Admin check ===
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Requesting administrator privileges...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

echo Downloading post-install script...

set "INSTALL_DIR=%ProgramData%\Lindows"
set "POST_BAT=%INSTALL_DIR%\LindowsPackageManager.bat"
set "POST_URL=https://raw.githubusercontent.com/lourenco321/Lindows/main/LindowsPackageManager.bat"

if not exist "%INSTALL_DIR%" mkdir "%INSTALL_DIR%"

powershell -NoProfile -Command ^
"Invoke-WebRequest -Uri '%POST_URL%' -OutFile '%POST_BAT%'"

echo Registering scheduled task...

schtasks /create ^
 /tn "LindowsInstaller" ^
 /tr "\"%POST_BAT%\"" ^
 /sc onstart ^
 /rl highest ^
 /f

echo LindowsPackageManager configured.
echo Disabling Windows Defender...
echo.
:: Disable real-time protection
powershell -Command "Set-MpPreference -DisableRealtimeMonitoring $true"
:: Disable cloud-based protection
powershell -Command "Set-MpPreference -MAPSReporting Disabled"
powershell -Command "Set-MpPreference -SubmitSamplesConsent NeverSend"
:: Disable behavior monitoring
powershell -Command "Set-MpPreference -DisableBehaviorMonitoring $true"
:: Disable IOAV protection
powershell -Command "Set-MpPreference -DisableIOAVProtection $true"
:: Attempt to stop Defender services
sc stop WinDefend >nul 2>&1
sc stop WdNisSvc >nul 2>&1
echo.
echo Windows Defender protections have been disabled (temporarily).
echo A reboot may re-enable them.
echo.

echo Starting setup for debloat...
setlocal
REM === CONFIG ===
set "ZIP_URL=https://example.com/Talon.zip"
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
start "" "%WORK_DIR%\%EXE_NAME%" --headless

echo Cleaning up....
echo Deleting temporary files...
del "%ZIP_FILE%"
echo Self Termination...
start "" cmd /c "timeout /t 2 >nul & del \"%~f0\""
exit
