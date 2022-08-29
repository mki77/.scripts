@echo off
:: Run as Administrator
reg query "HKU\S-1-5-19" >nul || ((
	echo Set UAC = CreateObject("Shell.Application"^)
	echo UAC.ShellExecute "%~s0", "%~dp0", "", "runas", 1
)>"%temp%\runas.vbs" &"%temp%\runas.vbs" &exit)
pushd %SystemRoot%\System32
title %~n0
cscript //nologo slmgr.vbs /xpr
timeout /t 3 /nobreak >nul

::https://docs.microsoft.com/en-us/windows-server/get-started/kms-client-activation-keys
set keys=^
1:TX9XD-98N7V-6WMQ6-BX7FG-H8Q99:Home: ^
2:3KHY7-WNT83-DGQKR-F7HPR-844BM:Home-N: ^
3:W269N-WFGWX-YVC9B-4J6C9-T83GX:Professional: ^
4:MH37W-N47XK-V7XM9-C7227-GCQG9:Professional-N: ^
5:NRG8B-VKK3Q-CXVCJ-9G2XF-6Q84J:Professional-Workstation: ^
6:9FNHH-K3HBT-3W4TD-6383H-6XYWF:Professional-Workstation-N: ^
7:NPPR9-FWDCX-D2C8J-H872K-2YT43:Enterprise: ^
8:DPH2V-TTNVB-4X9Q3-TJR4H-KHJW4:Enterprise-N: ^
9:.:Exit:

cls
echo [7m  KmsActivator //github.com/mki77  [0m
echo.
for %%k in (%keys%) do (for /f "delims=: tokens=1-3" %%a in ("%%k") do (
echo  [7m %%a [0m %%c
))
echo.
echo Press a number to continue...
choice /n /c:123456789 /m ">"
set /a n=%errorlevel%
if %n% equ 9 exit
cls
for %%k in (%keys%) do (
	for /f "tokens=1-2 delims=:" %%a in ("%%k") do (
		if "%%a"=="%n%" (
			cscript //nologo slmgr.vbs /upk
			cscript //nologo slmgr.vbs /ipk %%b
)))
set servers= ^
kms9.msguides.com ^
kms8.msguides.com ^
kms7.msguides.com ^
kms.loli.beer ^
kms.digiboy.ir ^
keeems.library.hk ^
kms.jm33.me ^
kms.cangshui.net
for %%s in (%servers%) do (
	ping -n 1 -w 500 %%s | findstr /r /c:"=[0-9]*ms" && (
		cscript //nologo slmgr.vbs /skms %%s:1688
		cscript //nologo slmgr.vbs /ato
		timeout /t 10 >nul &exit
))
