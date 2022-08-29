@echo off
pushd "%Temp%"
curl.exe -L -o setup.exe https://www.iobit.com/downloadcenter.php?product=iobit-unlocker
start setup.exe /verysilent
