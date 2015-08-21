#
# Reboot.ps1
#

Param(
	[object] $Instance,
	[object] $Logger
)

$Logger.LogEvent("Rebooting target Azure Instance name: {$Instance.Name}, service: {$Instance.ServiceName} ");
Restart-AzureVM -Name $Instance.Name -ServiceName $Instance.ServiceName;