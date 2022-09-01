@echo off
pushd "%Temp%"
curl.exe -L -o gu5setup.exe https://download.glarysoft.com/gu5setup.exe
start gu5setup.exe
