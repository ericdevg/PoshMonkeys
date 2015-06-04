#
# AzureClient.psm1
#

#Import-Module Azure

Import-Module "$PSScriptRoot\ClientConfig.ps1"

class AzureClient {
	[string] $PublishSettingsFile;

	[void] ImportPublishSettings([string] $FilePath)
	{
		Import-AzurePublishSettingsFile -PublishSettingsFile $this.PublishSettingsFile;
	}

	AzureClient()
	{
		Write-Host "azureclient"
		$AzureConfig = [ClientConfig]::new("PoshMonkeys.Client.Azure.xml");

		$this.PublishSettingsFile = $AzureConfig.XmlConfig.Configurations.PublishSetting;

		ImportPublishSettings($this.PublishSettingsFile);
	}
}

