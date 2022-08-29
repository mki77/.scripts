@echo off
pushd "%Temp%"
curl.exe -L -o geek.zip https://geekuninstaller.com/geek.zip
PowerShell.exe "Expand-Archive geek.zip -DestinationPath ."
popd
move /y "%Temp%\geek.exe"
start geek.exe
