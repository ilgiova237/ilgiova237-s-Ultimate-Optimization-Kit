@echo off
title AVVIO CHRIS TITUS TECH TOOL
:: Controllo privilegi Amministratore
net session >nul 2>&1 || (echo ESEGUI COME AMMINISTRATORE! & pause & exit)

echo Attendere... Apertura del Windows Utility in corso...
powershell -Command "Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://christitus.com/win'))"