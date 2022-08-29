@echo off
pushd "%Temp%"
curl.exe -L -o setup.exe https://pxc-coding.com/dl/donotspy11/
start setup.exe /silent
set path=%ProgramFiles(x86)%\DoNotSpy11
start DoNotSpy11.exe
