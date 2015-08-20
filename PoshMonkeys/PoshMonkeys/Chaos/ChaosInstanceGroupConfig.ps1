#
# ChaosInstanceGroupConfig.ps1
#

class ChaosInstanceGroupConfig
{
	[string] $Name;
	[bool] $Enabled;
	[double] $DailyProbability;
	[int] $MaxAffectedInstance;
	
	[Logger] $Logger

	ChaosInstanceGroupConfig([ClientConfig] $chaosConfig, [string] $name, [Logger] $logger)
	{
		$this.Logger = $logger;
		
		try
		{
			$this.Logger.LogEvent("Loading chaos configuration of each instance group ...", "ChaosInstanceGroupConfig", $null);
			$config = $chaosConfig.XmlConfig.SelectNodes("/Configurations/AvailabilitySets/AvailabilitySet") | ? {[string]$_.Name -eq "$name"};

			$this.Name = $name;
			$this.Enabled = $config.Enabled;
			$this.DailyProbability = $config.DailyProbability;
			$this.MaxAffectedInstance = $config.MaxAffectedInstance;

			$this.Logger.LogEvent("Finished loading chaos configuration of each instance group ...", "ChaosInstanceGroupConfig", $null);
		}
		catch
		{
			$this.Logger.LogEvent($_, "ChaosInstanceGroupConfig", "Error");
		}
	}
}