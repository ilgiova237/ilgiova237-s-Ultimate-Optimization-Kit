@echo off
setlocal enabledelayedexpansion
title NETWORK MULTI-SERVER DIAGNOSTIC
echo ======================================================
echo ANALISI DI RETE MULTI-SERVER IN CORSO...
echo Questo test durera' circa 2 minuti.
echo ======================================================

set LOGFILE="%userprofile%\Desktop\Full_Network_Report.txt"
echo REPORT DIAGNOSTICO RETE - DATA: %date% %time% > %LOGFILE%
echo ------------------------------------------------------ >> %LOGFILE%

:: 1. TEST GATEWAY LOCALE (Controlla il tuo Router/Cavo)
echo [1/4] Verifica connessione interna (Router)...
for /f "tokens=2 delims=:" %%a in ('ipconfig ^| findstr "Gateway predefinito"') do set GATEWAY=%%a
set GATEWAY=%GATEWAY: =%
if "%GATEWAY%"=="" (
    echo ERRORE: Gateway non trovato! >> %LOGFILE%
) else (
    echo Test Gateway locale (%GATEWAY%)... >> %LOGFILE%
    ping %GATEWAY% -n 20 >> %LOGFILE%
)

:: 2. TEST CLOUDFLARE (Performance Gaming/DNS)
echo [2/4] Verifica Cloudflare (1.1.1.1)...
echo. >> %LOGFILE%
echo Test Cloudflare (1.1.1.1)... >> %LOGFILE%
ping 1.1.1.1 -n 20 >> %LOGFILE%

:: 3. TEST GOOGLE (Affidabilita' Globale)
echo [3/4] Verifica Google (8.8.8.8)...
echo. >> %LOGFILE%
echo Test Google (8.8.8.8)... >> %LOGFILE%
ping 8.8.8.8 -n 20 >> %LOGFILE%

:: 4. TEST QUAD9 (Sicurezza e Latenza)
echo [4/4] Verifica Quad9 (9.9.9.9)...
echo. >> %LOGFILE%
echo Test Quad9 (9.9.9.9)... >> %LOGFILE%
ping 9.9.9.9 -n 20 >> %LOGFILE%

echo ------------------------------------------------------ >> %LOGFILE%
echo FINE REPORT >> %LOGFILE%

echo ======================================================
echo ANALISI COMPLETATA!
echo.
echo RISULTATI RAPIDI (Media Ping):
echo ------------------------------------------------------
findstr /C:"Media =" %LOGFILE%
echo ------------------------------------------------------
echo.
echo Il report completo e' stato salvato sul Desktop: 
echo "Full_Network_Report.txt"
echo ======================================================
pause