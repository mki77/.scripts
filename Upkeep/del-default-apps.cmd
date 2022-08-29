@echo off
set key=HKLM\SOFTWARE\RegisteredApplications
for %%I in (%key%) do (set n=%%~nxI)
reg export "%key%" "%n%.reg" /y
reg delete "%key%" /f
