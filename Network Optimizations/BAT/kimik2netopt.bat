@echo off
title NETWORK MASTER OPTIMIZER
net session >nul 2>&1 || (exit)

echo --- Configurazione Stack TCP/IP ---
netsh int tcp set global autotuninglevel=normal
netsh int tcp set global rss=enabled
netsh int tcp set global rsc=disabled
netsh int tcp set global ecncapability=disabled
netsh int tcp set global timestamps=disabled
netsh int tcp set global initialrto=2000
netsh int tcp set global nonsackthreshold=0
netsh int tcp set supplemental template=custom congestionprovider=cubic

echo --- Reset e Pulizia ---
ipconfig /flushdns
netsh winsock reset >nul
netsh int ip reset >nul

echo Ottimizzazione Rete completata.
pause