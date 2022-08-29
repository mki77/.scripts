@echo off
set key=HKCU\Software\Microsoft\Windows\CurrentVersion\Applets\Regedit\Favorites
for %%I in (%key%) do (set n=%%~nxI)
reg export "%key%" "%n%.reg" /y
