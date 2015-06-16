#
# InstanceCrawler.ps1
#

class InstanceCrawler
{
    [AzureClient] $AzureClient;
	[array] $AllInstanceGroups;

	[Logger] $Logger;

    InstanceCrawler([AzureClient] $azureClient, [Logger] $logger)
	{
		$this.Logger = $logger;

		$this.Logger.LogEvent("Crawling all instance group under user subscription ...", "InstanceCrawler", $null);

		$this.AzureClient = $azureClient;
		$allAvailabilitySets = $azureClient.GetAllAvailabilitySets();
		
		foreach($ASName in $allAvailabilitySets)
		{
			$this.Logger.LogEvent("Found instance group $ASName, starting crawling for all its instances ...", "InstanceCrawler", $null);

			$InstanceGroup = [InstanceGroup]::new($ASName);
			
			$Instances = $azureClient.GetAllInstances($ASName);
			foreach($Instance in $Instances)
			{
				$this.Logger.LogEvent("Found instance $($instance.Name).", "InstanceCrawler", $null);
				$InstanceGroup.AddInstance([Instance]::new($Instance.Name, $Instance.ServiceName));
			}

			$this.AllInstanceGroups += $InstanceGroup;
		}

		$this.Logger.LogEvent("Finished crawling all instance group under user subscription ...", "InstanceCrawler", $null);
    }
}