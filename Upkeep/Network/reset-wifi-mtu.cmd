@echo off
>nul fltmc || runas %0 &&exit
set "Name=" &set "NetConnectionID="
for /f delims^= %%G in ('%__APPDIR__%wbem\WMIC NIC Where ^
 "Not NetConnectionStatus Is Null And NetEnabled='TRUE'" ^
 Get Name^,NetConnectionID /Value 2^>nul') do set "%%G" 2>nul 1>&2
if not defined Name goto :EOF
setlocal EnableDelayedExpansion
set MTU=1473
set LASTGOOD=0
set LASTBAD=65536
ping -n 1 google.com || exit /b
call :seek
set ID=%NetConnectionID%
netsh int ipv4 set subinterface "%ID%" mtu=%MAXMTU% store=persistent
netsh int ipv6 set subinterface "%ID%" mtu=%MAXMTU% store=persistent
echo.
echo %ID%: %Name%
echo MaxMTU: %MAXMTU%
echo.
echo This script will close in seconds...
timeout /t 10 >nul
exit /b
:seek
ping -n 1 -l !MTU! -f -4 google.com 1>nul
if !ERRORLEVEL! EQU 0 (
  set /a LASTGOOD=!MTU!
  set /a "MTU=(!MTU!+!LASTBAD!) /2"
  if !MTU! NEQ !LASTGOOD! goto seek
) else (
  set /a LASTBAD=!MTU!  
  set /a "MTU=(!MTU!+!LASTGOOD!) /2"
  if !MTU! NEQ !LASTBAD! goto seek
)
set /a MAXMTU=!LASTGOOD!+28
exit /b
