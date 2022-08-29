@echo off
setlocal EnableDelayedExpansion
del Packages.txt 2>nul
set ROOT=HKLM\SOFTWARE
for /f "tokens=*" %%a in ('REG query "%ROOT%\Microsoft\Windows\CurrentVersion\Component Based Servicing\PackageIndex" /f "-" /k ') do (
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
pause