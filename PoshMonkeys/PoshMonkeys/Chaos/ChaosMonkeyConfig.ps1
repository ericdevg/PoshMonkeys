#
# ChaosMonkeyConfig.ps1
#

Import-Module "$PSScriptRoot\ChaosInstanceGroupConfig.ps1"

class ChaosMonkeyConfig {
	[bool] $Enabled;
	[bool] $Leashed;
	[double] $DailyProbability;
	[int] $MaxAffectedInstance;
	[bool] $NotificaitonEnalbed;
	[string] $ReceiverEmail;
	[string] $SenderEmail;

	[ClientConfig] $ChaosConfig;

	[array] $InstanceGroupChaosConfig;

	ChaosMonkeyConfig()
	{
		Write-Host "Loading Chaos monkey config"
		$this.ChaosConfig = [ClientConfig]::new("PoshMonkeys.Chaos.Properties.xml");

		$this.Enabled = $this.ChaosConfig.XmlConfig.Configurations.Enabled;
		$this.Leashed = $this.ChaosConfig.XmlConfig.Configurations.Leashed;
		$this.DailyProbability = $this.ChaosConfig.XmlConfig.Configurations.DailyProbability;
		$this.MaxAffectedInstance = $this.ChaosConfig.XmlConfig.Configurations.MaxAffectedInstance;
		$this.NotificaitonEnalbed = $this.ChaosConfig.XmlConfig.Configurations.Notification.NotificaitonEnalbed;
		$this.ReceiverEmail = $this.ChaosConfig.XmlConfig.Configurations.Notification.ReceiverEmail;
		$this.SenderEmail = $this.ChaosConfig.XmlConfig.Configurations.Notification.SenderEmail;

		$this.InstanceGroupChaosConfig = @();

		$configGroups = $this.ChaosConfig.XmlConfig.SelectNodes("/Configurations/AvailabilitySets/AvailabilitySet");
		foreach ($as in $configGroups)
		{
			$this.InstanceGroupChaosConfig += [ChaosInstanceGroupConfig]::new($this.ChaosConfig, $as.Name);
		}
		
		Write-Host "Finished loading Chaos monkey config"
	}	
}

