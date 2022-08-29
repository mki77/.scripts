if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) { Start-Process PowerShell.exe "-File `"$PSCommandPath`"" -Verb RunAs; exit}

New-Item -Path $profile.AllUsersAllHosts -Type File -Force
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope LocalMachine

if((Test-Path -LiteralPath "HKCU:\SOFTWARE\Classes\Microsoft.PowerShellScript.1\DefaultIcon") -ne $true) {  New-Item "HKCU:\SOFTWARE\Classes\Microsoft.PowerShellScript.1\DefaultIcon" -force};
New-ItemProperty -LiteralPath 'HKCU:\SOFTWARE\Classes\Microsoft.PowerShellScript.1\DefaultIcon' -Name '(default)' -Value '%SystemRoot%\System32\imageres.dll,311' -PropertyType String -Force;

if((Test-Path -LiteralPath "HKCU:\SOFTWARE\Classes\Microsoft.PowerShellScript.1\Shell\Edit\Command") -ne $true) {  New-Item "HKCU:\SOFTWARE\Classes\Microsoft.PowerShellScript.1\Shell\Edit\Command" -force};
New-ItemProperty -LiteralPath 'HKCU:\SOFTWARE\Classes\Microsoft.PowerShellScript.1\Shell\Edit\Command' -Name '(default)' -Value 'notepad.exe "%1"' -PropertyType String -Force;

if((Test-Path -LiteralPath "HKCU:\SOFTWARE\Classes\Microsoft.PowerShellScript.1\Shell\Open\Command") -ne $true) {  New-Item "HKCU:\SOFTWARE\Classes\Microsoft.PowerShellScript.1\Shell\Open\Command" -force};
New-ItemProperty -LiteralPath 'HKCU:\SOFTWARE\Classes\Microsoft.PowerShellScript.1\Shell\Open\Command' -Name '(default)' -Value 'PowerShell.exe -NoLogo -ExecutionPolicy Unrestricted -File "%1" %*' -PropertyType ExpandString -Force;

clear
. (Join-Path ([Runtime.InteropServices.RuntimeEnvironment]::GetRuntimeDirectory()) ngen.exe) update
sleep -s 10
