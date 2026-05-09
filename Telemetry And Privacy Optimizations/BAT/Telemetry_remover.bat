:: --- ADD TO SEZIONE 1: ADDITIONAL SCHEDULED TASKS ---
echo [1/4+] Additional Tasks... >> %L%
schtasks /change /tn "Microsoft\Windows\Maps\MapsUpdateTask" /disable >> %L% 2>&1
schtasks /change /tn "Microsoft\Windows\Maps\MapsToastTask" /disable >> %L% 2>&1
schtasks /change /tn "Microsoft\Windows\Speech\SpeechModelDownloadTask" /disable >> %L% 2>&1
schtasks /change /tn "Microsoft\Windows\Windows Error Reporting\QueueReporting" /disable >> %L% 2>&1
schtasks /change /tn "Microsoft\Office\OfficeTelemetryAgentFallBack2016" /disable >> %L% 2>&1
schtasks /change /tn "Microsoft\Office\OfficeTelemetryAgentLogOn2016" /disable >> %L% 2>&1

:: --- ADD TO SEZIONE 2: CONSUMER BLOAT & SUGGESTIONS ---
echo [2/4+] Consumer Tweaks... >> %L%
:: Disable "Consumer Features" (Automatic installation of Candy Crush/Disney+)
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v "DisableWindowsConsumerFeatures" /t REG_DWORD /d 1 /f >> %L% 2>&1
:: Disable Start Menu suggestions/ads
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SystemPaneSuggestionsEnabled" /t REG_DWORD /d 0 /f >> %L% 2>&1
:: Disable "Tailored Experiences" (Microsoft's internal tracking)
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Privacy" /v "TailoredExperiencesWithDiagnosticDataEnabled" /t REG_DWORD /d 0 /f >> %L% 2>&1
:: Disable Advertising ID
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo" /v "Enabled" /t REG_DWORD /d 0 /f >> %L% 2>&1

:: --- ADD TO SEZIONE 3: EXTRA SERVICES (DISK & RAM KILLERS) ---
echo [3/4+] Killing Disk/RAM Hogs... >> %L%
:: Disable SysMain (Superfetch) - This is MANDATORY for low-end HDDs
sc stop SysMain >> %L% 2>&1
sc config SysMain start= disabled >> %L% 2>&1
:: Disable Maps Broker (Background map updates)
sc stop MapsBroker >> %L% 2>&1
sc config MapsBroker start= disabled >> %L% 2>&1
:: Disable Wallet Service
sc stop WalletService >> %L% 2>&1
sc config WalletService start= disabled >> %L% 2>&1
:: Disable Retail Demo (Why was this ever on?)
sc stop RetailDemo >> %L% 2>&1
sc config RetailDemo start= disabled >> %L% 2>&1

:: --- NEW SEZIONE 5: HOSTS FILE TELEMETRY BLOCKING ---
echo [5/6] Blocking Telemetry Domains via Hosts... >> %L%
set "HOSTS=%windir%\System32\drivers\etc\hosts"
echo 0.0.0.0 telemetry.microsoft.com >> %HOSTS%
echo 0.0.0.0 statsfe1.ws.microsoft.com >> %HOSTS%
echo 0.0.0.0 diagnostics.microsoft.com >> %HOSTS%
echo 0.0.0.0 v10.events.data.microsoft.com >> %HOSTS%
echo 0.0.0.0 v20.events.data.microsoft.com >> %HOSTS%

:: --- NEW SEZIONE 6: EXPLORER SPEED TWEAKS ---
echo [6/6] Explorer Speed Injection... >> %L%
:: Disable "Recent Files" and "Frequent Folders" (Speed up folder loading)
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer" /v "ShowRecent" /t REG_DWORD /d 0 /f >> %L% 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer" /v "ShowFrequent" /t REG_DWORD /d 0 /f >> %L% 2>&1

:: --- SEZIONE 7: THE SEARCH & INDEXING KILLER ---
echo [7/10] Disabilitazione Search Indexer (Salva il Disco)... >> %L%
:: This stops Windows from constantly scanning files in the background
sc stop WSearch >> %L% 2>&1
sc config WSearch start= disabled >> %L% 2>&1
:: Disable Web Search in Start Menu (Stops the lag when searching for local apps)
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Search" /v "BingSearchEnabled" /t REG_DWORD /d 0 /f >> %L% 2>&1
reg add "HKCU\Software\Policies\Microsoft\Windows\Explorer" /v "DisableSearchBoxSuggestions" /t REG_DWORD /d 1 /f >> %L% 2>&1

:: --- SEZIONE 8: ONEDRIVE & CLOUD PURGE ---
echo [8/10] Rimozione OneDrive e Cloud... >> %L%
:: Kill the process first
taskkill /f /im OneDrive.exe >> %L% 2>&1
:: Prevent it from starting with Windows
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v "OneDrive" /t REG_SZ /d "" /f >> %L% 2>&1
:: Hide the OneDrive folder from File Explorer side-bar
reg add "HKCL\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" /v "System.IsPinnedToNameSpaceTree" /t REG_DWORD /d 0 /f >> %L% 2>&1

:: --- SEZIONE 9: DELIVERY OPTIMIZATION (BANDWIDTH SAVER) ---
echo [9/10] Disabilitazione Delivery Optimization... >> %L%
:: Stops Windows from using your PC to upload updates to other people on the internet
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeliveryOptimization" /v "DODownloadMode" /t REG_DWORD /d 0 /f >> %L% 2>&1
sc stop DOSVC >> %L% 2>&1
sc config DOSVC start= disabled >> %L% 2>&1

:: --- SEZIONE 10: UI & SHELL JUNK REMOVAL ---
echo [10/10] Pulizia Interfaccia... >> %L%
:: Disable "Aero Shake" (Stops a background listener that minimizes windows when you shake the mouse)
reg add "HKCU\Software\Policies\Microsoft\Windows\Explorer" /v "NoWindowMinimizingShortcuts" /t REG_DWORD /d 1 /f >> %L% 2>&1
:: Disable "Meet Now" icon in Taskbar
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "HideSCAMeetNow" /t REG_DWORD /d 1 /f >> %L% 2>&1
:: Disable "People" icon
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People" /v "PeopleBand" /t REG_DWORD /d 0 /f >> %L% 2>&1
:: Disable Background Apps (Global switch - HUGE RAM SAVER)
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" /v "GlobalUserPresence" /t REG_DWORD /d 0 /f >> %L% 2>&1