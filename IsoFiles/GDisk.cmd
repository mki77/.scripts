:: This script correctly runs gptfdisk
:: https://sourceforge.net/projects/gptfdisk/
@echo off
>nul reg add HKCU\Software\Classes\.Admin\shell\runas\command /f /ve /d "cmd /x /d /r set \"f0=%%2\"&call \"%%2\" %%3"&set _= %*
>nul fltmc || if "%f0%" neq "%~f0" (cd.>"%temp%\runas.Admin" &start "%~n0" /high "%temp%\runas.Admin" "%~f0" "%_:"=""%" &exit /b)
pushd "%~dp0"
gdisk64.exe \\.\physicaldrive0
