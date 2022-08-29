@echo off
if not exist %SystemRoot%\contig.exe (
	pushd "%Temp%"
	curl.exe -L -o contig.zip https://download.sysinternals.com/files/Contig.zip
	PowerShell "Expand-Archive contig.zip -DestinationPath ."
	move /y Contig64.exe %SystemRoot%\contig.exe
	popd
)
:: Defrag MFT
contig c:\$Mft
contig c:\$LogFile
contig c:\$Volume
contig c:\$AttrDef
contig c:\$Bitmap
contig c:\$Boot
contig c:\$BadClus
contig c:\$Secure
contig c:\$UpCase
contig -s c:\$Extend
:: Defrag WINDOWS
contig -q -s c:\Windows\*
exit /b
