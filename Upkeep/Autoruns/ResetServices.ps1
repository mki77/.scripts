$ErrorActionPreference= 'silentlycontinue'
$Services = Get-WmiObject -Class Win32_Service

foreach ($Service in $Services) {

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

	New-Object -TypeName PSObject -Property @{
		Status = $Service.State
		Name = $Service.Name
		StartMode = $Service.StartMode
		DisplayName = $Service.DisplayName
	}
}

$Automatic = @(
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
"DPS"
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
foreach ($Service in $Automatic) {
	Set-Service -Name $Service -StartupType Automatic
}
