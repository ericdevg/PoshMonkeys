#
# ChaosMonkeyConfig.ps1
#

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

	[Logger] $Logger;

	ChaosMonkeyConfig([Logger] $logger)
	{
		$this.Logger = $logger;
		
		$this.Logger.LogEvent("Loading chaos monkey configuration ...", "ChaosMonkeyConfig", $null);
		$this.ChaosConfig = [ClientConfig]::new("PoshMonkeys.Chaos.Properties.xml");

		$this.Enabled = $this.ChaosConfig.XmlConfig.Configurations.Enabled;
		$this.Leashed = $this.ChaosConfig.XmlConfig.Configurations.Leashed;
		$this.DailyProbability = $this.ChaosConfig.XmlConfig.Configurations.DailyProbability;
		$this.MaxAffectedInstance = $this.ChaosConfig.XmlConfig.Configurations.MaxAffectedInstance;
		$this.NotificaitonEnalbed = $this.ChaosConfig.XmlConfig.Configurations.Notification.NotificaitonEnalbed;
		$this.ReceiverEmail = $this.ChaosConfig.XmlConfig.Configurations.Notification.ReceiverEmail;
		$this.SenderEmail = $this.ChaosConfig.XmlConfig.Configurations.Notification.SenderEmail;

		$this.InstanceGroupChaosConfig = @();

		$this.Logger.LogEvent("Loading local all scaling group from configuration ...", "ChaosMonkeyConfig", $null);
		$configGroups = $this.ChaosConfig.XmlConfig.SelectNodes("/Configurations/AvailabilitySets/AvailabilitySet");
		foreach ($as in $configGroups)
		{
			$this.Logger.LogEvent("$($as.Name) is found.", "ChaosMonkeyConfig", $null);
			$this.InstanceGroupChaosConfig += [ChaosInstanceGroupConfig]::new($this.ChaosConfig, $as.Name, $this.Logger);
		}
		
		$this.Logger.LogEvent("Finished loading Chaos monkey config", "ChaosMonkeyConfig", $null);
	}	
}

