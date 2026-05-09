@echo off
title MANUS PRO OPTIMIZER - MASTER KIT
setlocal

:: Controllo Privilegi Admin
net session >nul 2>&1 || (echo AVVIA COME AMMINISTRATORE! & pause & exit)

echo ======================================================
echo PULIZIA PROFONDA E OTTIMIZZAZIONE LATENZA
echo ======================================================

:: 1. PULIZIA AVANZATA
echo Pulizia cache e log in corso...
del /s /f /q %temp%\*.* >nul 2>&1
del /s /f /q C:\Windows\Temp\*.* >nul 2>&1
del /s /f /q C:\Windows\Prefetch\*.* >nul 2>&1
wsreset -i && echo Cache Store pulita.

:: 2. OTTIMIZZAZIONE TIMER DI SISTEMA (Riduce Input Lag)
echo Ottimizzazione Timer BCDedit...
bcdedit /set disabledynamictick yes
bcdedit /set useplatformtick yes
bcdedit /set tscsyncpolicy Enhanced

:: 3. ENERGIA (Crea profilo se non esiste)
echo Attivazione Prestazioni Massime...
powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61
powercfg -setactive e9a42b02-d5df-448d-aa00-03f14749eb61

:: 4. DISABILITAZIONE TELEMETRIA VELOCE
echo Stop servizi tracciamento...
sc stop DiagTrack
sc config DiagTrack start= disabled

echo ======================================================
echo OPERAZIONE COMPLETATA!
echo ======================================================
pause