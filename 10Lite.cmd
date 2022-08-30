@echo off
:: Run as Administrator
reg query "HKU\S-1-5-19" >nul || ((
	echo Set UAC = CreateObject("Shell.Application"^)
	echo UAC.ShellExecute "%~s0", "%~dp0", "", "runas", 1
)>"%temp%\runas.vbs" &"%temp%\runas.vbs" &exit)
pushd "%~dp0"
goto Init

:Init
mode con:cols=70 lines=35
set "_=                   "
set sleep=echo Press any key to continue...^&pause^>nul^&cls
set strip=[7m %_%[ %~n0 //github.com/mki77 ]%_% [0m
set strip=cls^&echo:^&echo:%strip%^&echo:^&echo:^&title %~n0
set menu= ^
1:RmApps:"Remove Windows apps (fully)":"Does not remove apps installed from store" ^
2:RmPackages:"Remove Windows components (preset)":"Removes hidden ones, risky to run without a backup" ^
3:RmFod:"Remove Windows features (on demand)":"Removes languages, .NET, PS-ISE and other" ^
4:RmFeatures:"Disable optional features (any at once)":"Does not remove DirectPlay and NetFx" ^
5:FastBoot:"Tweaks for older PCs without SSD":"Enables fast boot, prefetching and more" ^
0:Exit:"Bye now!"
rem :CleanUp:"Remove Windows Update files (needs reboot)":"Free up space by cleaning the WinSxS folder" ^
goto Screen

:End
echo:&echo This script will close in seconds...
timeout /t 5 >nul
exit /b

:Screen
call %strip%
set "_=       "
for %%i in (%menu%) do (
	for /f "delims=: tokens=1-4" %%a in ("%%i") do echo:%_%[7m %%a [0m %%~c&echo:%_%    %%~d&echo:
)
echo Press a number to continue...
choice /n /c:1234567890 /m ">"
call set /a n=%errorlevel%
if %n% equ 10 exit /b
for %%i in (%menu%) do (
	for /f "tokens=1-2 delims=:" %%a in ("%%i") do (if %%a equ %n% call :%%b)
)
goto Screen

:RmApps
setlocal enableDelayedExpansion
if not exist Apps.txt (
for /f "tokens=2" %%a in ('DISM /Online /Get-ProvisionedAppxPackages ^| find "_"') do echo %%a>>Apps.txt
echo Edit Apps.txt as you like and press a key to continue.
pause >nul &cls
echo Removing apps...
for /f "tokens=*" %%a in (Apps.txt) do DISM /Online /Remove-ProvisionedAppxPackage /PackageName:%%a
)
endlocal
goto :eof

:RmFeatures
cls &echo Disabling features...
PowerShell "Get-WindowsOptionalFeature -Online | ? State -match 'Enabled' | ? FeatureName -notmatch 'Direct' | ? FeatureName -notmatch 'Legacy' | ? FeatureName -notmatch 'NetFx' | ForEach-Object {Disable-WindowsOptionalFeature -Online -FeatureName $_.FeatureName}"
rem PowerShell "Enable-WindowsOptionalFeature -Online -FeatureName DirectPlay -All"
goto :eof

:RmPackages
setlocal EnableDelayedExpansion
if not exist Packages.txt goto LsPackages
echo This removal can take a long time. Schedule shutdown? y/n
choice /n /c:YN /m ">"
set /a PowerOff=%ErrorLevel%
cls &echo Removing packages...
title 0%%

:: Loops are written this way to get better execution speed, do not modify
for /f %%p in (Packages.txt) do (for /f "tokens=*" %%a in ('REG query "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Component Based Servicing\Packages" /f "%%p" /k ^| find "-"') do (
>nul 2>&1 (
	reg add "%%a" /v Visibility /t REG_DWORD /d 1 /f
	reg add "%%a" /v DefVis /t REG_DWORD /d 2 /f
	reg delete "%%a\Owners" /f)
	set /a steps+=1
))
for /f "tokens=2 delims=:" %%a in ('DISM /Online /Get-Packages') do (set _=%%a
	for /f %%p in (Packages.txt) do (
		if not "!_:%%p=!"=="!_!" (
			DISM /Online /Remove-Package /PackageName:"!_:~1!" /NoRestart >nul && echo !_:~1!
			set /a step+=1
			set /a "progress=(!step!*100)/!steps!"
			title !progress!%%
)))
title 100%%

>nul 2>&1 (
	DISM /Online /Optimize-ProvisionedAppxPackages 
	DISM /Online /Remove-DefaultAppAssociations
	REG add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce" /v Cleanup /t REG_SZ /d "C:\Windows\DISMCleanup.cmd" /f
	REG add "HKLM\Software\Microsoft\Windows\CurrentVersion\SideBySide\Configuration" /v "DisableResetBase" /t "REG_DWORD" /d "0" /f
	echo:DISM /Online /Cleanup-Image /StartComponentCleanup /ResetBase >C:\Windows\DISMCleanup.cmd
)

if %PowerOff% equ 1 shutdown.exe /t 10 /s
endlocal
goto :eof

:LsPackages
setlocal EnableDelayedExpansion
for /f "tokens=*" %%a in ('REG query "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Component Based Servicing\Packages" /f "-" /k') do (
	set "_=%%~na"
	rem set _=!_:Microsoft-=!
	rem set _=!_:Windows-=!
	set _=!_:Package=^-!
	set _=!_:merged-=^-!
	set _=!_:WOW64-=!
	set _=!_:--= !
	for %%s in ("!_:* = !") do (set _=!_:%%~s=!)
	if not "!_!"=="" echo !_!
)>>Packages.txt
sort /unique Packages.txt /o Packages.txt
echo Edit Packages.txt as you like before removing.
endlocal
goto :eof

:RmFod
setlocal EnableDelayedExpansion
if not exist Features.txt (
for /f "tokens=2 delims=:" %%a in ('DISM /Online /Get-Capabilities /LimitAccess ^| find "~" ^| find /v "Language"') do set "_=%%a" &echo !_: =!>>Features.txt
echo Edit Features.txt as you like and press a key to continue.
pause >nul &cls
echo Removing features...
for /f "tokens=*" %%a in (Features.txt) do DISM /Online /Remove-Capability /CapabilityName:%%a
)
endlocal
goto :eof
::https://docs.microsoft.com/en-us/windows-hardware/manufacture/desktop/features-on-demand-v2--capabilities
rem Start-Service -Name "BITS"; Start-Service -Name "UsoSvc"
rem if (-not(Test-Path -Path $file -PathType Leaf)) {Get-WindowsCapability -Online | ? State -match 'Installed' | ForEach-Object {Set-Content -Path .\Fod.txt -Encoding Ascii -Value $_.Name}

:FastBoot
cls
:: Enable/disable boot menu
set yes_no=
if defined "%yes_no%" bcdedit /set {bootmgr} displaybootmenu %yes_no%
:: Boot using more cpu cores
for /f "tokens=* usebackq" %%n in (`wmic cpu get NumberOfLogicalProcessors ^| findstr /r "[0-9]"`) do (bcdedit /set {current} numproc %%n)
bcdedit /debug off
bcdedit /timeout 2

:: Disable BIOS logo, spinner
rem bcdedit /set bootuxdisabled on
:: Disable boot logo
rem bcdedit /set {globalsettings} custom:16000067 true
:: Disable loading circle
rem bcdedit /set {globalsettings} custom:16000069 true
:: Disable driver signature enforcement
rem bcdedit /set nointegritychecks on
rem bcdedit /set loadoptions DISABLE_INTEGRITY_CHECKS
:: Disable Hyper-V (default)
rem bcdedit /set hypervisorlaunchtype off
:: Enable F8 key menu
rem bcdedit /set bootmenupolicy Legacy
:: Set custom description
rem bcdedit /set {guid} description "Windows Lite"
:: Set custom  language
rem bcdboot c:\windows /l en-us

:: Check file system if needed
chkntfs /t:2
chkntfs /c c:
:: Optimize NTFS, values stored in HKLM\SYSTEM\CurrentControlSet\Control\Filesystem
fsutil behavior set disablecompression 0
fsutil behavior set disableencryption 1
fsutil behavior set disablelastaccess 1
fsutil behavior set encryptpagingfile 0
fsutil behavior set memoryusage 1
fsutil behavior set mftzone 1
:: Disable NTFS 8dot3names
fsutil behavior set allowextchar 0
fsutil behavior set disable8dot3 1
:: Strip filenames, older apps can no longer be started/uninstalled
rem fsutil 8dot3name strip /f /s c:

:: Enable fast boot and power plans in battery tray icon
powercfg /restoredefaultschemes
powercfg /h on
powercfg /h /size 0
powercfg /h /type reduced
rem powercfg /a

:: Set shutdown as default action for closing book
powercfg /setacvalueindex 381b4222-f694-41f0-9685-ff5bb260df2e 4f971e89-eebd-4455-a8de-9e59040e7347 5ca83367-6e45-459f-a27b-476b1d01c936 3
powercfg /setdcvalueindex 381b4222-f694-41f0-9685-ff5bb260df2e 4f971e89-eebd-4455-a8de-9e59040e7347 5ca83367-6e45-459f-a27b-476b1d01c936 3

:: Set shutdown as default action for power button
powercfg /setacvalueindex 381b4222-f694-41f0-9685-ff5bb260df2e 4f971e89-eebd-4455-a8de-9e59040e7347 7648efa3-dd9c-4e3e-b566-50f929386280 3
powercfg /setdcvalueindex 381b4222-f694-41f0-9685-ff5bb260df2e 4f971e89-eebd-4455-a8de-9e59040e7347 7648efa3-dd9c-4e3e-b566-50f929386280 3

:: Turn on fast boot and enable boot prefetch for better startup times
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Power" /V "HiberbootEnabled" /t REG_DWORD /d "1" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" /v "EnablePrefetcher" /t REG_DWORD /d "2" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" /v "EnableSuperfetch" /t REG_DWORD /d "3" /f

:: These services must be available
sc config defragsvc start=auto
sc config SysMain start=auto

:: Enable TRIM feature for SSDs and disable apps prefetching
set SolidState=
if "%SolidState%"=="y" (
	fsutil behavior set DisableDeleteNotify 0
	reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" /v "EnableSuperfetch" /t REG_DWORD /d "0" /f
)

:: Enable Diagnostic on demand
"DPS"
"PcaSvc"
"WdiServiceHost"
"WdiSystemHost"
"WerSvc"
) do (
sc config %%~s start=demand >nul
)

:: Disable Services
for %%s in (
"AxInstSV"
"AeLookupSvc"
"ALG"
"CDPSvc"
"DcpSvc"
"diagnosticshub.standardcollector.service"
"DiagTrack"
"dmwappushservice"
"DoSvc"
"DsSvc"
"ERSVC"
"HomeGroupListener"
"HomeGroupProvider"
"iphlpsvc"
"irmon"
"lfsvc"
"MapsBroker"
"MessagingService"
"MSiSCSI"
"Netlogon"
"NetTcpPortSharing"
"OneSyncSvc"
"PimIndexMaintenanceSvc"
"PrintNotify"
"RasAuto"
"RasMan"
"RemoteAccess"
"RemoteRegistry"
"RetailDemo"
"RpcLocator"
"SCPolicySvc"
"SDRSVC"
"SessionEnv"
"shpamsvc"
"SNMPTRAP"
"Spooler"
"TermService"
"TokenBroker"
"upnphost"
"WaaSMedicSvc"
"WbioSrvc"
"Wecsvc"
"WERSVC"
"WinRM"
"wscsvc"
"WSearch"
"wuauserv"
) do (
sc config %%~s start=disabled >nul && echo [Disable] %%~s
)
rem Get-ItemProperty 'HKLM:\SYSTEM\CurrentControlSet\Services\*' | ? ImagePath -notmatch 'drivers' | ? ImagePath -match 'system32' | ? Start -eq 4 | Select PSChildName

:: Disable Tasks
for %%t in (
"\Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser"
"\Microsoft\Windows\Application Experience\ProgramDataUpdater"
"\Microsoft\Windows\Customer Experience Improvement Program\Consolidator"
"\Microsoft\Windows\Customer Experience Improvement Program\UsbCeip"
"\Microsoft\Windows\DiskCleanup\SilentCleanup"
"\Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticDataCollector"
"\Microsoft\Windows\InstallService\ScanForUpdates"
"\Microsoft\Windows\InstallService\ScanForUpdatesAsUser"
"\Microsoft\Windows\Maintenance\WinSAT"
"\Microsoft\Windows\RecoveryEnvironment\VerifyWinRE"
"\Microsoft\Windows\SettingSync\BackgroundUploadTask"
"\Microsoft\Windows\SettingSync\NetworkStateChangeTask"
"\Microsoft\Windows\SystemRestore\SR"
"\Microsoft\Windows\Windows Defender\Windows Defender Scheduled Scan"
"\Microsoft\Windows\Windows Error Reporting\QueueReporting"
"\Microsoft\Windows\WindowsUpdate\Scheduled Start"
) do (
	schtasks /Change /TN %%t /Disable >nul 2>&1 && echo [Disabled] %%t
)
rem Get-ScheduledTask | ? State -eq Ready | Select TaskName, Description | Sort TaskName

timeout /nobreak /t 2 >nul
goto :eof
