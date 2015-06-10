#
# AzureClient.ps1
#

class AzureClient {
	[string] $PublishSettingsFile;
	[string] $StorageAccountName;
	[string] $StorageAccountKey;
	[string] $StorageTableName;
	[ClientConfig] $AzureClientConfig;

	[void] ImportPublishSettings([string] $FilePath)
	{
		Write-Host "Importing publishsettings from $($this.PublishSettingsFile)";

		Import-AzurePublishSettingsFile -PublishSettingsFile "'$($this.PublishSettingsFile)'";
		
		Write-Host "Finished importing publishsettings from $($this.PublishSettingsFile)";
	}

	AzureClient()
	{
		Write-Host "Initializaing AzureClient";

		$this.AzureClientConfig = [ClientConfig]::new("PoshMonkeys.Client.Azure.Properties.xml");

		Write-Host "Loading configurations for AzureClient";
		$this.PublishSettingsFile = $this.AzureClientConfig.XmlConfig.Configurations.PublishSetting;
		$this.ImportPublishSettings($this.PublishSettingsFile);
		$this.StorageAccountName = $this.AzureClientConfig.XmlConfig.Configurations.StorageAccountName;
		$this.StorageAccountKey = $this.AzureClientConfig.XmlConfig.Configurations.StorageAccountKey;
		$this.StorageTableName = $this.AzureClientConfig.XmlConfig.Configurations.StorageTableName;

		Write-Host "Finished initializing AzureClient";
	}

	[array] GetAllAvailabilitySets() 
	{
		$AvailabilitySets = @();

        $UniqueList = Get-AzureVM | Select -Property AvailabilitySetName | Get-Unique

		foreach ($AS in $UniqueList)
		{
			$AvailabilitySets += $AS.AvailabilitySetName;
		}

		return $AvailabilitySets;
    }

	[array] GetAllInstances([string] $AvailabilitySetName) 
	{
		return Get-AzureVM | Where-Object {$_.AvailabilitySetName -eq "$AvailabilitySetName"};
    }
}

