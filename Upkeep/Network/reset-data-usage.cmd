@echo off
>nul fltmc || runas %0 &&exit
net stop dps
del /f/s/q "%SystemRoot%\system32\sru\*"
net start dps
