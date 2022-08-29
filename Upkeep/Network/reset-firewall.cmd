@echo off
>nul fltmc || runas %0 &&exit
netsh advfirewall set currentprofile state on
netsh advfirewall set currentprofile firewallpolicy blockinboundalways,allowoutbound
netsh advfirewall firewall delete rule name=all dir=in
rem netsh advfirewall reset
rem netsh advfirewall import|export policy.wfw
rem PowerShell "Get-NetFirewallRule -All | ? Direction -eq Inbound | Remove-NetFirewallRule"
