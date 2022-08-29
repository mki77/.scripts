:: Set svchost.exe split threshold
@echo off
for /f "tokens=2 delims==" %%i in ('wmic os get TotalVisibleMemorySize /format:value') do set mem=%%i
set /a ram=%mem%+1024000
reg add "HKLM\System\CurrentControlSet\Control" /v "SvcHostSplitThresholdInKB" /t REG_DWORD /d "%ram%" /f > nul
