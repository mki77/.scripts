if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) { Start-Process PowerShell.exe "-File `"$PSCommandPath`"" -Verb runas -WindowStyle hidden; exit}

$ErrorActionPreference = 'silentlycontinue'
$Services = @(
"AudioEndpointBuilder"
"Audiosrv"
"BFE"
"BITS"
"BrokerInfrastructure"
"CoreMessagingRegistrar"
"CryptSvc"
"DcomLaunch"
"defragsvc"
"Dhcp"
"Dnscache"
"dot3svc"
"DusmSvc"
"EventLog"
"EventSystem"
"gpsvc"
"LSM"
"mpssvc"
"Netman"
"netprofm"
"NlaSvc"
"nsi"
"PlugPlay"
"Power"
"ProfSvc"
"RpcEptMapper"
"RpcSs"
"SamSs"
"Schedule"
"SecurityHealthService"
"ShellHWDetection"
"SysMain"
"SystemEventsBroker"
"Themes"
"TrkWks"
"UsoSvc"
"WlanSvc"
"WpnUserService"
"WwanSvc"
)
foreach ($Service in $Services) {
	Set-Service -Name $Service -StartupType Automatic
}


$ErrorActionPreference = 'silentlycontinue'
$Services = Get-WmiObject -Class Win32_Service

$List = foreach ($Service in $Services) {

	# Exclude if Delayed
	$ItemProperty = Get-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\$($Service.Name)"
	if ($ItemProperty.Start -eq 2 -and $ItemProperty.DelayedAutoStart -eq 1) {
		Set-Service -Name $Service.Name -StartupType Automatic
		continue
	}

	# Exclude if Triggered
	if (Test-Path -Path "HKLM:\SYSTEM\CurrentControlSet\Services\$($Service.Name)\TriggerInfo\") {
		Set-Service -Name $Service.Name -StartupType Manual
		continue
	}

	[PSCustomObject] @{
		DisplayName = $Service.DisplayName
		Name = $Service.Name
		StartMode = $Service.StartMode
		Status = $Service.State
	}
}

$List | Out-GridView -Title "Services" -Wait
