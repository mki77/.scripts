@echo off
setlocal EnableDelayedExpansion
set "dv==::"
if defined !dv! (PowerShell "Start-Process -FilePath '%0' -Verb RunAs" & exit)

rd /s /q %SystemRoot%\System32\GroupPolicyUsers
rd /s /q %SystemRoot%\System32\GroupPolicy
gpupdate /force
