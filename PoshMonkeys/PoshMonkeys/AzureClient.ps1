#
# AzureClient.ps1
#

class AzureClient {
	[string] $PublishSettingsFile;
	[ClientConfig] $AzureClientConfig;

	[void] ImportPublishSettings([string] $FilePath)
	{
		
		Write-Host "Importing publishsettings from $($this.PublishSettingsFile)";
		Write-Host "'$($this.PublishSettingsFile)'";
		Import-AzurePublishSettingsFile -PublishSettingsFile "'$($this.PublishSettingsFile)'";
	}

	AzureClient()
	{
		Write-Host "azureclient"
		$this.AzureClientConfig = [ClientConfig]::new("PoshMonkeys.Client.Azure.Properties.xml");

		$this.PublishSettingsFile = $this.AzureClientConfig.XmlConfig.Configurations.PublishSetting;

		$this.ImportPublishSettings($this.PublishSettingsFile);
	}

	[array] GetAllAvailabilitySets() 
	{
		$AailabilitySets = New-Object 'System.Collections.Generic.List[string]'

        $UniqueList = Get-AzureVM | Select -Property AvailabilitySetName | Get-Unique

		foreach($AS in $UniqueList)
		{
			$this.AailabilitySets.Add($AS.AvailabilitySetName);
		}

		return $AailabilitySets;
    }

	[array] GetAllInstances([string] $AvailabilitySetName) 
	{
		return Get-AzureVM | Where-Object {$_.AvailabilitySetName -eq "$AvailabilitySetName"};
    }
}

