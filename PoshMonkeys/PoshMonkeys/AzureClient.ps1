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
}

