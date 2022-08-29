@echo off
for %%s in (
"VMAuthdService"
"VMnetDHCP"
"VMware NAT Service"
"VMUSBArbService"
) do (
sc config %%s start=delayed-auto >nul && echo [Delayed] %%~s
)
timeout /t 3 >nul
