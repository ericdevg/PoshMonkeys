#
# InstanceCrawler.ps1
#

Import-Module "$PSScriptRoot\InstanceGroup.ps1"

class InstanceCrawler
{
    [AzureClient] $AzureClient;
	[array] $AllInstanceGroups;

    InstanceCrawler([AzureClient] $azureClient)
	{
		$this.AzureClient = $azureClient;
		$allAvailabilitySets = $azureClient.GetAllAvailabilitySets();
		
		foreach($ASName in $allAvailabilitySets)
		{
			$InstanceGroup = [InstanceGroup]::new($ASName);
			
			$Instances = $azureClient.GetAllInstances($ASName);
			foreach($Instance in $Instances)
			{
				$InstanceGroup.AddInstance([Instance]::new($Instance.Name, $Instance.ServiceName));
			}

			$this.AllInstanceGroups += $InstanceGroup;
		}
    }
}