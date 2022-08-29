:: AIO Repack for latest Microsoft Visual C++ Redistributable Runtimes
:: https://github.com/abbodi1406/vcredist
:: https://kutt.it/vcppredist
:: https://rebrand.ly/vcredist
@echo off
set exe=VisualCppRedist_AIO_x86_x64.exe
pushd "%Temp%"
dir /b VisualCppRedist*.exe || (
	curl.exe -L -o vcppredist.zip https://kutt.it/vcppredist
	PowerShell "Expand-Archive vcppredist.zip -DestinationPath ."
)
rem %exe% /?
start %exe% /aiT
popd
