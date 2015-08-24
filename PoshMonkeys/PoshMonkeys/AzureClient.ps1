#
# AzureClient.ps1
#

class AzureClient {
	[string] $PublishSettingsFile;
	[string] $StorageAccountName;
	[string] $StorageAccountKey;
	[string] $StorageTableName;
	[ClientConfig] $AzureClientConfig;
	[object] $Logger;

	[void] ImportPublishSettings()
	{
		$this.Logger.Log("Importing publishsettings from $($this.PublishSettingsFile)");

		Import-AzurePublishSettingsFile -PublishSettingsFile "'$($this.PublishSettingsFile)'";
		
		$this.Logger.Log("Finished importing publishsettings from $($this.PublishSettingsFile)");
	}

	AzureClient([object] $logger)
	{
		$this.Logger = $logger;

		$this.Logger.Log("Initializaing AzureClient");

		$this.AzureClientConfig = [ClientConfig]::new("PoshMonkeys.Client.Azure.Properties.xml");

		$this.Logger.Log("Loading configurations for AzureClient");
		try
		{
			$this.PublishSettingsFile = $this.AzureClientConfig.XmlConfig.Configurations.PublishSetting;
			$this.ImportPublishSettings();
			$this.StorageAccountName = $this.AzureClientConfig.XmlConfig.Configurations.StorageAccountName;
			$this.StorageAccountKey = $this.AzureClientConfig.XmlConfig.Configurations.StorageAccountKey;
			$this.StorageTableName = $this.AzureClientConfig.XmlConfig.Configurations.StorageTableName;
		}
		catch
		{
			$this.Logger.Log($_);
			throw;
		}
		$this.Logger.Log("Finished initializing AzureClient");
	}

	[array] GetAllAvailabilitySets() 
	{
		$this.Logger.LogEvent("Getting all availability sets ...", "AzureClient", $null);

		$AvailabilitySets = @();

		try
		{
			$UniqueList = Get-AzureVM | Select -Property AvailabilitySetName -Unique;

			foreach ($AS in $UniqueList)
			{
				$AvailabilitySets += $AS.AvailabilitySetName;
			}
		}
		catch
		{
			$this.Logger.LogEvent($_, "AzureClient", "Error");
			throw;
		}

		$this.Logger.LogEvent("Finish getting all availability sets ...", "AzureClient", $null);
		
		return $AvailabilitySets;
    }

	[array] GetAllInstances([string] $availabilitySetName) 
	{
		return Get-AzureVM | Where-Object {$_.AvailabilitySetName -eq "$availabilitySetName"};
    }

	[bool] IsPSEnabledInstance([string] $name, [string] $serviceName) 
	{
		$vm = Get-AzureVM -Name $name -ServiceName $serviceName;
		
		$psEndpoint = $vm.vm.ConfigurationSets | Where-Object {$_.InputEndpoints | Where-Object {$_.Name -eq "PowerShell"}};
		return $psEndpoint -ne $null;
    }
}

