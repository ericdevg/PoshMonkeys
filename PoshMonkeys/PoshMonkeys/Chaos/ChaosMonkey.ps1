#
# ChaosMonkey.ps1
#

class ChaosMonkey
{
	[AzureClient] $AzureClient;
	
	ChaosMonkey([AzureClient] $azureClient)
	{
		$this.AzureClient = $azureClient;
	}

	DoBusiness()
	{
		Write-Host "Entering Chaos Monkey";
		$vms = Get-AzureVM
		Write-Host "Exiting Chaos Monkey";
	}
}



