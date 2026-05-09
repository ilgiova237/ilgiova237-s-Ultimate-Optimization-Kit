@echo off
title AVVIO PROJECT RONIN
:: Controllo privilegi Amministratore
net session >nul 2>&1 || (echo ESEGUI COME AMMINISTRATORE! & pause & exit)

echo Attendere... Avvio di Project Ronin in corso...
powershell -Command "Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; irm https://raw.githubusercontent.com/keiretrogaming/Project-Ronin/main/run.ps1 | iex"