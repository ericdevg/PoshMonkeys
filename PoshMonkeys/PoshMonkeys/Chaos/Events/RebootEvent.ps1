#
# Reboot.ps1
#

Param(
	[object] $Instance,
	[object] $Logger,
	[PSCredential] $Credential
)

$Logger.LogEvent("Rebooting target Azure Instance name: {$Instance.Name}, service: {$Instance.ServiceName} ", "ChaosMonkey", "reboot");
Restart-AzureVM -Name $Instance.Name -ServiceName $Instance.ServiceName;