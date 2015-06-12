#
# BurnCpuEvent.ps1
#

class BurnCpuEvent
{
	[Instance] $Instance;
	[AzureClient] $AzureClient;
	[string] $ScriptName = "burncpu";

	BurnCpuEvent([Instance] $instance, [AzureClient] $client)
	{
		$this.Instance = $instance;
		$this.AzureClient = $client;
	}

	[void] Simulate()
	{
		if($this.AzureClient.IsPSEnabledInstance($this.Instance.Name, $this.Instance.ServiceName))
		{
			# win
			Invoke-Command -ComputerName $this.Instance.Name -FilePath "$PSScriptRoot/../Scripts/$($this.ScriptName).ps1";
		}
		else
		{
			# linux
			# plink -m *.sh
		}
	}
}