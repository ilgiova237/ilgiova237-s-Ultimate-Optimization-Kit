@echo off
setlocal enabledelayedexpansion
title MASTER OPTIMIZER - COMPLETE EDITION
color 0B

:: Check for Administrator Privileges
net session >nul 2>&1 || (
    echo [ERROR] Please run this script as Administrator.
    pause
    exit
)

:MENU
cls
echo ======================================================
echo           MASTER OPTIMIZER - ALL-IN-ONE
echo ======================================================
echo  [1] CLEANUP (Temp, Prefetch, Logs)
echo  [2] VISUAL PERFORMANCE (Disable Animations/Blur/Shake)
echo  [3] NETWORK REPAIR (Reset Stack/DNS/ARP/Adapters)
echo  [4] DEBLOAT (Services, Scheduled Tasks, Privacy)
echo  [5] SYSTEM TWEAKS (Memory, Power, Startup Delay)
echo  [6] RUN ALL (Complete Optimization)
echo  [0] EXIT
echo ======================================================
set /p choice="Select an option (0-6): "

if "%choice%"=="1" goto CLEAN
if "%choice%"=="2" goto VISUAL
if "%choice%"=="3" goto NETWORK
if "%choice%"=="4" goto DEBLOAT
if "%choice%"=="5" goto TWEAKS
if "%choice%"=="6" goto ALL
if "%choice%"=="0" exit
goto MENU

:CLEAN
echo.
echo [PROCESS] Cleaning temporary system files...
del /s /f /q %temp%\*.* >nul 2>&1
del /s /f /q C:\Windows\Temp\*.* >nul 2>&1
del /s /f /q C:\Windows\Prefetch\*.* >nul 2>&1
for /f "tokens=*" %%G in ('wevtutil.exe el') do (wevtutil.exe cl "%%G")
echo [SUCCESS] System deep clean completed.
pause
goto MENU

:VISUAL
echo.
echo [PROCESS] Disabling visual effects and GUI delays...
reg add "HKCU\Control Panel\Desktop" /v "UserPreferencesMask" /t REG_BINARY /d 9012038010000000 /f >nul
reg add "HKCU\Control Panel\Desktop\WindowMetrics" /v "MinAnimate" /t REG_SZ /d 0 /f >nul
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ListviewAlphaSelect" /t REG_DWORD /d 0 /f >nul
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "TaskbarAnimations" /t REG_DWORD /d 0 /f >nul
:: Custom added from REG file
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v "EnableTransparency" /t REG_DWORD /d 0 /f >nul
reg add "HKCU\Control Panel\Desktop" /v "MenuShowDelay" /t REG_SZ /d 0 /f >nul
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "DisallowShaking" /t REG_DWORD /d 1 /f >nul
taskkill /f /im explorer.exe >nul & start explorer.exe
echo [SUCCESS] Windows visual performance optimized.
pause
goto MENU

:NETWORK
echo.
echo [PROCESS] Resetting Network Stack and Adapters...
netsh int ip reset >nul
netsh winsock reset >nul
netsh int ipv4 reset >nul
netsh int ipv6 reset >nul
ipconfig /flushdns >nul
arp -d * >nul
echo Restarting Adapters to force handshake...
netsh interface set interface "Ethernet" disable >nul 2>&1
netsh interface set interface "Ethernet" enable >nul 2>&1
netsh interface set interface "Wi-Fi" disable >nul 2>&1
netsh interface set interface "Wi-Fi" enable >nul 2>&1
echo [SUCCESS] Network stack factory reset and refreshed.
pause
goto MENU

:DEBLOAT
echo.
echo [PROCESS] Disabling Telemetry, Maps & Hidden Tasks...
schtasks /change /tn "\Microsoft\Windows\Customer Experience Improvement Program\Consolidator" /disable >nul 2>&1
schtasks /change /tn "\Microsoft\Windows\Customer Experience Improvement Program\UsbCeip" /disable >nul 2>&1
schtasks /change /tn "\Microsoft\Windows\Power Efficiency Diagnostics\AnalyzeSystem" /disable >nul 2>&1
reg add "HKLM\SYSTEM\Maps" /v "AutoDownloadExternalData" /t REG_DWORD /d 0 /f >nul
reg add "HKCU\Software\Microsoft\Siuf\Rules" /v "NumberOfSIUFInPeriod" /t REG_DWORD /d 0 /f >nul
sc stop DiagTrack >nul 2>&1 & sc config DiagTrack start= disabled >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v "AllowTelemetry" /t REG_DWORD /d 0 /f >nul
echo [SUCCESS] Telemetry and background tasks disabled.
pause
goto MENU

:TWEAKS
echo.
echo [PROCESS] Applying System, Memory, and Power Tweaks...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Serialize" /v "StartupDelayInMSec" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "LargeSystemCache" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "DisablePagingExecutive" /t REG_DWORD /d 1 /f >nul
powercfg -h off >nul 2>&1
powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61 >nul 2>&1
powercfg -setactive e9a42b02-d5df-448d-aa00-03f14749eb61 >nul 2>&1
echo [SUCCESS] System tweaks applied (Memory, Power, Startup).
pause
goto MENU

:ALL
echo.
echo [PROCESS] Running full suite. This will take a moment...
call :CLEAN
call :VISUAL
call :NETWORK
call :DEBLOAT
call :TWEAKS
echo ======================================================
echo    ALL OPTIMIZATIONS APPLIED. PLEASE REBOOT.
echo ======================================================
pause
goto MENU