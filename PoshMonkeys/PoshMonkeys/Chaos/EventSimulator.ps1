#
# EventSimulator.ps1
#

class EventSimulator
{
	[object] $Instance;
	[object] $Logger;
	[PSCredential] $Cred;
	[string] $ScriptName;

	EventSimulator([object] $instance, [Logger] $logger)
	{
		$this.Instance = $instance;
		$this.Logger = $logger;
	}

	[void] ExecuteScript([string] $scriptName, [PSCredential] $cred)
	{
		if (($this.Instance.VM.ConfigurationSets[0].InputEndpoints | Where-Object {$_.Name -eq "SSH"}) -ne $null)
		{
			# linux machine
			if($this.Logger -ne $null)
			{
				$this.Logger.LogEvent("Using SSH to simulate event on instance $($this.Instance.Name)", "ChaosMonkey", $ScriptName);
			}
		}
		elseif (($this.Instance.VM.ConfigurationSets[0].InputEndpoints | Where-Object {$_.Name -eq "PowerShell"}) -ne $null)
		{
			if($this.Logger -ne $null)
			{
				# windows machine
				$this.Logger.LogEvent("Using PowerShell to simulate event on instance $($this.Instance.Name)", "ChaosMonkey", $ScriptName);
			}

			$endpoint = ($this.Instance.VM.ConfigurationSets[0].InputEndpoints | Where-Object {$_.Name -eq "PowerShell"}).Port;
			Invoke-Command -ComputerName "$($this.Instance.ServiceName).CloudApp.net" -FilePath "$PSScriptRoot\Scripts\Win\$ScriptName.ps1" -Credential $cred -UseSSL -Port $endpoint;
		}
	}
}