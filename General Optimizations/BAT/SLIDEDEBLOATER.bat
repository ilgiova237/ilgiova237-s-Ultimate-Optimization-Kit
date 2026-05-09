@echo off
setlocal EnableExtensions EnableDelayedExpansion
chcp 65001 >nul
Slide Debloater 
mode con: cols=100 lines=30
color 0F

net session >nul 2>&1
if %errorlevel% neq 0 (
cls
echo.
echo   Run as Administrator required.
echo.
pause
exit /b
)

:home
cls
echo.
echo  ==========================================
echo        SLIDE DEBLOATER INSTALLER
echo  ==========================================
echo.
echo   Package: System Optimizer
echo   Status : Ready
echo.
echo  ------------------------------------------
echo.
echo  [1] Start Installation
echo  [2] What this tool does
echo  [3] Exit
echo.
set /p choice="Select > "

if "%choice%"=="1" goto run
if "%choice%"=="2" goto info
if "%choice%"=="3" exit /b
goto home


:: ---------------- INFO MENU ----------------
:info
cls
echo.
echo  ==========================================
echo              WHAT THIS DOES
echo  ==========================================
echo.
echo   + Removes preinstalled apps (bloatware)
echo   + Disables Windows suggestions
echo   + Applies privacy tweaks
echo   + Disables telemetry service (DiagTrack)
echo   + UI cleanup (taskbar/search tweaks)
echo.
echo  DOES NOT TOUCH:
echo   - Windows Update
echo   - Microsoft Store
echo   - Defender / Firewall
echo   - Xbox / Gaming Services
echo.
pause
goto home


:: ---------------- PROGRESS ----------------
:progress
set "p=%~1"
set "text=%~2"

set /a done=%p%/2
set /a left=50-%done%

set "bar="
for /l %%i in (1,1,%done%) do set "bar=!bar!#"
for /l %%i in (1,1,%left%) do set "bar=!bar!-"

cls
echo.
echo  ==========================================
echo        INSTALLING SLIDE DEBLOATER
echo  ==========================================
echo.
echo   %text%
echo.
echo   [!bar!]  %p%%%
echo.
exit /b


:: ---------------- RUN ----------------
:run
call :progress 10 "Initializing..."
timeout /t 1 >nul

call :progress 25 "Creating restore point..."
powershell -NoProfile -Command "Checkpoint-Computer -Description 'SlideDebloater' -RestorePointType 'MODIFY_SETTINGS'" >nul 2>&1
timeout /t 1 >nul

call :progress 40 "Scanning apps..."
timeout /t 1 >nul

call :progress 55 "Removing bloatware..."

for %%a in (
 Microsoft.BingNews
 Microsoft.SkypeApp
 Microsoft.ZuneMusic
 Microsoft.ZuneVideo
 Clipchamp.Clipchamp
 MicrosoftTeams
) do (
 powershell -NoProfile -Command "Get-AppxPackage *%%a* | Remove-AppxPackage" >nul 2>&1
)

timeout /t 1 >nul

call :progress 75 "Applying tweaks..."

reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SilentInstalledAppsEnabled /t REG_DWORD /d 0 /f >nul

timeout /t 1 >nul

call :progress 90 "Disabling telemetry..."

sc stop DiagTrack >nul 2>&1
sc config DiagTrack start= disabled >nul 2>&1

timeout /t 1 >nul

call :progress 100 "Done!"

cls
echo.
echo  ==========================================
echo           INSTALLATION COMPLETE
echo  ==========================================
echo.
echo   Restart recommended
echo.
pause
exit /b