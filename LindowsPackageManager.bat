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
set "SUP_URL=https://github.com/superium/browser/releases/latest/download/superium-installer.exe"
set "SUP_EXE=%TEMP%\superium-installer.exe"
powershell -NoProfile -Command "Invoke-WebRequest -Uri '%SUP_URL%' -OutFile '%SUP_EXE%'"
start /wait "" "%SUP_EXE%" /silent || start /wait "" "%SUP_EXE%"
del "%SUP_EXE%"


echo Installing Spotify...
winget install Spotify.Spotify --source winget --scope user --accept-source-agreements --accept-package-agreements || echo Spotify install skipped


::------------------------------------------------------------Taskbar Pinning---------------------------------------------------------------------
echo Waiting for Explorer to be ready...
timeout /t 5 >nul

echo Pinning Steam to taskbar...
powershell -NoProfile -Command ^
"$p='%ProgramFiles(x86)%\Steam\Steam.exe'; ^
if (Test-Path $p) { ^
$s=(New-Object -ComObject Shell.Application).Namespace((Split-Path $p)); ^
$i=$s.ParseName((Split-Path $p -Leaf)); ^
$i.Verbs() | Where-Object {$_.Name -match 'taskbar'} | ForEach-Object {$_.DoIt()} }"

echo Pinning File Explorer to taskbar...
powershell -NoProfile -Command ^
"$s=(New-Object -ComObject Shell.Application).Namespace('shell:::{F02C1A0D-BE21-4350-88B0-7367FC96EF3C}'); ^
$i=$s.Self; ^
$i.Verbs() | Where-Object {$_.Name -match 'taskbar'} | ForEach-Object {$_.DoIt()}"

echo Pinning Superium to taskbar...
powershell -NoProfile -Command ^
"$p='$env:LOCALAPPDATA\Programs\Superium\superium.exe'; ^
if (Test-Path $p) { ^
$s=(New-Object -ComObject Shell.Application).Namespace((Split-Path $p)); ^
$i=$s.ParseName((Split-Path $p -Leaf)); ^
$i.Verbs() | Where-Object {$_.Name -match 'taskbar'} | ForEach-Object {$_.DoIt()} }"

echo Pinning mpv to taskbar...
powershell -NoProfile -Command ^
"$p='%ProgramFiles%\mpv\mpv.exe'; ^
if (Test-Path $p) { ^
$s=(New-Object -ComObject Shell.Application).Namespace((Split-Path $p)); ^
$i=$s.ParseName((Split-Path $p -Leaf)); ^
$i.Verbs() | Where-Object {$_.Name -match 'taskbar'} | ForEach-Object {$_.DoIt()} }"
::-------------------------------------------------------------------------------------------------------------------------------------------------

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





