:: This script correctly runs gptfdisk
:: https://sourceforge.net/projects/gptfdisk/
@echo off
reg query "HKU\S-1-5-19" >nul || ((
	echo Set UAC = CreateObject("Shell.Application"^)
	echo UAC.ShellExecute "%~s0", "%~dp0", "", "runas", 1
	)>runas.vbs
	runas.vbs &del runas.vbs &exit
)
pushd "%~dp0"
gdisk64.exe \\.\physicaldrive0
