@echo off
chkdsk /scan /perf /i c: || chkdsk /scan /perf /f /sdcleanup c:
vssadmin list providers && vssadmin list writers
timeout /t 10 >nul
exit /b
