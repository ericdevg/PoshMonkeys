#
# EventSimulator.ps1
#

function Simulate
{
	Param(
		[PersistentVMRoleListContext] $Instance,
		[Logger] $Logger,
		[PSCredential] $Cred,
		[string] $ScriptName
	)

	if (($Instance.VM.ConfigurationSets[0].InputEndpoints | Where-Object {$_.Name -eq "SSH"}) -ne $null)
	{
		# linux machine
		$Logger.LogEvent("Using SSH to simulate event on instance $($instance.Name)", "ChaosMonkey", $ScriptName);
	}
	elseif (($Instance.VM.ConfigurationSets[0].InputEndpoints | Where-Object {$_.Name -eq "PowerShell"}) -ne $null)
	{
		# windows machine
		$Logger.LogEvent("Using PowerShell to simulate event on instance $($instance.Name)", "ChaosMonkey", $this.EventsList[$rand]);

		Invoke-Command -ComputerName $Instance.Name -FilePath "$PSScriptRoot\Scripts\$ScriptName.ps1" -Credential $cred
	}
}