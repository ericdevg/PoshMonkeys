#
# ChaosMonkey.ps1
#

Import-Module "$PSScriptRoot\..\AzureClient.ps1"

class ChaosMonkey
{
	[AzureClient] $AzureClient;
	
	[void] doBusiness([AzureClient] $azureClient)
	{
		Write-Host "Entering Chaos Monkey"
	}
}



