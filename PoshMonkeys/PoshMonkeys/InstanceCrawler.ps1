#
# InstanceCrawler.ps1
#

Import-Module "$PSScriptRoot\InstanceGroup.ps1"

class InstanceCrawler
{
    [AzureClient] $AzureClient;
	[System.Collections.Generic.List[InstanceGroup]] $AllInstanceGroups;

    InstanceCrawler([AzureClient] $Client)
	{
		$this.AzureClient = $Client;
		$AllAvailabilitySets = $Client.GetAllAvailabilitySets();
		
		foreach($AS in $AllAvailabilitySets)
		{
			$InstanceGroup = [InstanceGroup]::new($AS.AvailabilitySetName);
			
			$Instances = $Client.GetAllInstances($AS.AvailabilitySetName);
			foreach($Instance in $Instances)
			{
				$InstanceGroup.AddInstance($Instance);
			}

			$this.AllInstanceGroups.Add($InstanceGroup);
		}
    }
}