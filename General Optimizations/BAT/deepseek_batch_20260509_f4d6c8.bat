@echo off
title Deep System Clean
setlocal enabledelayedexpansion

:: ── Administrator check ─────────────────────────────
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo This script must be run as Administrator.
    pause
    exit /b 1
)

echo ==================================================
echo            DEEP SYSTEM CLEANUP
echo ==================================================
echo.
echo [!] Make sure you have saved all work before continuing.
echo [!] A reboot after the cleanup is recommended.
echo.
pause

echo [1/11] Stopping Windows Update services...
net stop wuauserv >nul 2>&1 && echo     [OK] Windows Update stopped. || echo     [FAIL] Could not stop Windows Update.
net stop bits >nul 2>&1 && echo     [OK] BITS stopped. || echo     [FAIL] Could not stop BITS.
net stop dosvc >nul 2>&1 && echo     [OK] Delivery Optimization stopped. || echo     [FAIL] Could not stop Delivery Optimization.
timeout /t 2 /nobreak >nul

echo [2/11] Clearing Windows Update cache...
set ERR=0
if exist "%SystemRoot%\SoftwareDistribution" (
    takeown /F "%SystemRoot%\SoftwareDistribution" /A /R /D Y >nul 2>&1
    icacls "%SystemRoot%\SoftwareDistribution" /grant Administrators:F /T >nul 2>&1
    del /F /S /Q "%SystemRoot%\SoftwareDistribution\DataStore\*.*" >nul 2>&1 || set ERR=1
    del /F /S /Q "%SystemRoot%\SoftwareDistribution\Download\*.*" >nul 2>&1 || set ERR=1
    if !ERR! equ 0 (echo     [OK] Update cache cleared.) else (echo     [WARN] Some files could not be removed.)
) else (
    echo     [SKIP] SoftwareDistribution folder not found.
)

if exist "%SystemRoot%\SoftwareDistribution.old" (
    takeown /F "%SystemRoot%\SoftwareDistribution.old" /A /R /D Y >nul 2>&1
    icacls "%SystemRoot%\SoftwareDistribution.old" /grant Administrators:F /T >nul 2>&1
    rd /s /q "%SystemRoot%\SoftwareDistribution.old" 2>nul && echo     [OK] SoftwareDistribution.old removed. || echo     [WARN] Could not remove SoftwareDistribution.old.
) else (
    echo     [SKIP] SoftwareDistribution.old not found.
)

echo [3/11] Cleaning crash dumps and error reports...
if exist "%SystemRoot%\Minidump\*.*" (
    del /F /S /Q "%SystemRoot%\Minidump\*.*" >nul 2>&1 && echo     [OK] Minidumps deleted. || echo     [FAIL] Unable to delete minidumps.
) else (echo     [SKIP] No minidumps found.)

if exist "%SystemRoot%\memory.dmp" (
    del /F /Q "%SystemRoot%\memory.dmp" >nul 2>&1 && echo     [OK] Memory dump deleted. || echo     [FAIL] Unable to delete memory dump.
) else (echo     [SKIP] No memory.dmp found.)

if exist "%SystemRoot%\LiveKernelReports\*.*" (
    del /F /S /Q "%SystemRoot%\LiveKernelReports\*.*" >nul 2>&1 && echo     [OK] Live kernel reports deleted. || echo     [WARN] Could not clear all live kernel reports.
) else (echo     [SKIP] No live kernel reports found.)

if exist "%ProgramData%\Microsoft\Windows\WER\*.*" (
    del /F /S /Q "%ProgramData%\Microsoft\Windows\WER\*.*" >nul 2>&1 && echo     [OK] ProgramData WER archives removed. || echo     [WARN] Could not fully clear ProgramData WER.
) else (echo     [SKIP] ProgramData WER folder empty/absent.)

if exist "%LocalAppData%\Microsoft\Windows\WER\*.*" (
    del /F /S /Q "%LocalAppData%\Microsoft\Windows\WER\*.*" >nul 2>&1 && echo     [OK] Local WER archives removed. || echo     [WARN] Could not fully clear local WER.
) else (echo     [SKIP] Local WER folder empty/absent.)

echo [4/11] Clearing event logs...
for /F "tokens=*" %%L in ('wevtutil.exe el') do (
    wevtutil.exe cl "%%L" >nul 2>&1
)
echo     [OK] All event logs cleared (errors suppressed).

echo [5/11] Purging system log files and cached data...
set ERR=0
del /F /S /Q "%SystemRoot%\Logs\CBS\*.*" >nul 2>&1 || echo     [WARN] Could not clear CBS logs.
del /F /S /Q "%SystemRoot%\Logs\DISM\*.*" >nul 2>&1 || echo     [WARN] Could not clear DISM logs.
del /F /S /Q "%SystemRoot%\Panther\*.*" >nul 2>&1 || echo     [WARN] Could not clear Panther logs.
del /F /S /Q "%SystemRoot%\inf\*.log" >nul 2>&1
echo     [OK] CBS, DISM, Panther, and driver logs cleaned (if accessible).

:: Font cache
if exist "%SystemRoot%\ServiceProfiles\LocalService\AppData\Local\FontCache\*.*" (
    del /F /S /Q "%SystemRoot%\ServiceProfiles\LocalService\AppData\Local\FontCache\*.*" >nul 2>&1 && echo     [OK] Font cache cleared. || echo     [WARN] Font cache could not be cleared.
) else (echo     [SKIP] Font cache folder not found.)

:: Delivery Optimization cache
if exist "%SystemRoot%\ServiceProfiles\NetworkService\AppData\Local\Microsoft\Windows\DeliveryOptimization\*.*" (
    del /F /S /Q "%SystemRoot%\ServiceProfiles\NetworkService\AppData\Local\Microsoft\Windows\DeliveryOptimization\*.*" >nul 2>&1 && echo     [OK] Delivery Optimization cache cleared. || echo     [WARN] Could not clear Delivery Optimization cache.
) else (echo     [SKIP] Delivery Optimization cache not found.)

:: Windows Defender scan history/backup
if exist "%ProgramData%\Microsoft\Windows Defender\Scans\*.*" (
    del /F /S /Q "%ProgramData%\Microsoft\Windows Defender\Scans\*.*" >nul 2>&1 && echo     [OK] Defender scan history removed. || echo     [WARN] Could not clear Defender scans.
) else (echo     [SKIP] Defender scans folder absent.)

if exist "%ProgramData%\Microsoft\Windows Defender\Support\*.*" (
    del /F /S /Q "%ProgramData%\Microsoft\Windows Defender\Support\*.*" >nul 2>&1 && echo     [OK] Defender support logs removed. || echo     [WARN] Could not clear Defender support logs.
) else (echo     [SKIP] Defender support logs absent.)

:: Windows Update history logs (Datastore.edb etc.)
if exist "%SystemRoot%\SoftwareDistribution\DataStore\Logs\*.log" (
    del /F /S /Q "%SystemRoot%\SoftwareDistribution\DataStore\Logs\*.log" >nul 2>&1
)
:: Pending.xml (pending update actions)
if exist "%SystemRoot%\WinSxS\pending.xml" (
    del /F /Q "%SystemRoot%\WinSxS\pending.xml" >nul 2>&1
)
echo     [OK] Additional update logs and pending files cleaned.

echo [6/11] Removing old Windows installations and rollout backups...
if exist "%SystemDrive%\Windows.old" (
    takeown /F "%SystemDrive%\Windows.old" /A /R /D Y >nul 2>&1
    icacls "%SystemDrive%\Windows.old" /grant Administrators:F /T >nul 2>&1
    rd /s /q "%SystemDrive%\Windows.old" >nul 2>&1 && echo     [OK] Windows.old removed. || echo     [WARN] Could not remove Windows.old.
) else (echo     [SKIP] No Windows.old found.)

if exist "%SystemDrive%\ESD" (
    takeown /F "%SystemDrive%\ESD" /A /R /D Y >nul 2>&1
    icacls "%SystemDrive%\ESD" /grant Administrators:F /T >nul 2>&1
    rd /s /q "%SystemDrive%\ESD" >nul 2>&1 && echo     [OK] ESD folder removed. || echo     [WARN] Could not remove ESD folder.
) else (echo     [SKIP] No ESD folder found.)

echo [7/11] Cleaning temporary files and empty folders...
:: User Temp - completely remove and recreate to kill locked files
if exist "%TEMP%" (
    del /F /S /Q "%TEMP%\*.*" >nul 2>&1
    rd /s /q "%TEMP%" >nul 2>&1
    mkdir "%TEMP%" >nul 2>&1
    echo     [OK] User Temp folder cleared.
) else (
    echo     [SKIP] User Temp folder missing.
)
:: System Temp
if exist "%SystemRoot%\Temp" (
    del /F /S /Q "%SystemRoot%\Temp\*.*" >nul 2>&1
    rd /s /q "%SystemRoot%\Temp" >nul 2>&1
    mkdir "%SystemRoot%\Temp" >nul 2>&1
    echo     [OK] System Temp folder cleared.
) else (
    echo     [SKIP] System Temp folder missing.
)
:: Prefetch
if exist "%SystemRoot%\Prefetch\*.*" (
    del /F /S /Q "%SystemRoot%\Prefetch\*.*" >nul 2>&1 && echo     [OK] Prefetch folder cleared. || echo     [WARN] Could not clear Prefetch.
) else (echo     [SKIP] Prefetch folder not found.)

echo [8/11] Emptying Recycle Bin on all drives...
set RECYCLE_DRIVES=C D E F G H I J K L M N O P Q R S T U V W X Y Z
for %%D in (%RECYCLE_DRIVES%) do (
    if exist "%%D:\$Recycle.Bin" (
        rd /s /q "%%D:\$Recycle.Bin" >nul 2>&1
    )
)
echo     [OK] Recycle Bin emptied on accessible drives.

echo [9/11] Flushing DNS cache, ARP table, and thumbnail caches...
ipconfig /flushdns >nul 2>&1 && echo     [OK] DNS cache flushed. || echo     [FAIL] Could not flush DNS.
arp -d * >nul 2>&1 && echo     [OK] ARP table cleared. || echo     [FAIL] Could not clear ARP table.
:: Thumbnail cache for current user
if exist "%LocalAppData%\Microsoft\Windows\Explorer\thumbcache_*.db" (
    del /F /S /Q "%LocalAppData%\Microsoft\Windows\Explorer\thumbcache_*.db" >nul 2>&1
)
if exist "%LocalAppData%\IconCache.db" (
    del /F /S /Q "%LocalAppData%\IconCache.db" >nul 2>&1
)
echo     [OK] Current user thumbnail cache cleared.
:: Thumbnail cache for all users (if accessible)
for /d %%U in (C:\Users\*) do (
    if exist "%%U\AppData\Local\Microsoft\Windows\Explorer\thumbcache_*.db" (
        del /F /S /Q "%%U\AppData\Local\Microsoft\Windows\Explorer\thumbcache_*.db" >nul 2>&1
    )
    if exist "%%U\AppData\Local\IconCache.db" (
        del /F /S /Q "%%U\AppData\Local\IconCache.db" >nul 2>&1
    )
)
echo     [OK] Thumbnail cache cleaned for all user profiles.

echo [10/11] Deep component store cleanup (DISM /ResetBase)...
echo     This may take several minutes... Please wait.
Dism.exe /Online /Cleanup-Image /StartComponentCleanup /ResetBase /Quiet
if %errorlevel% equ 0 (
    echo     [OK] Component store cleanup succeeded.
) else (
    echo     [WARN] Component store cleanup finished with warnings (this is often normal).
)

echo [11/11] Final cleanup and service restart...
net start wuauserv >nul 2>&1 && echo     [OK] Windows Update service restarted. || echo     [FAIL] Windows Update could not be restarted.
net start bits >nul 2>&1 && echo     [OK] BITS restarted. || echo     [FAIL] BITS could not be restarted.
net start dosvc >nul 2>&1 && echo     [OK] Delivery Optimization restarted. || echo     [FAIL] Delivery Optimization could not be restarted.

:: Run cleanmgr to catch remaining temporary files
start /wait cleanmgr /autoclean >nul 2>&1
echo     [OK] cleanmgr /autoclean finished.

echo.
echo ==================================================
echo        DEEP SYSTEM CLEANUP COMPLETE!
echo        Please restart your computer now.
echo ==================================================
pause