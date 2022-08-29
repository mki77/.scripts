@echo off
pushd "%Temp%"
curl.exe -L -o setup.exe https://download.macrium.com/reflect/v7/v7.3.6391/reflect_setup_free_x64.exe
setup.exe /silent
