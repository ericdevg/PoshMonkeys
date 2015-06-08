#
# ChaosInstanceGroupConfig.ps1
#

class ChaosInstanceGroupConfig
{
	[string] $Name;
	[bool] $Enabled;
	[double] $DailyProbability;
	[int] $MaxAffectedInstance;

	ChaosInstanceGroupConfig([ClientConfig] $chaosConfig, [string] $name)
	{
		$config = $chaosConfig.XmlConfig.SelectNodes("/Configurations/AvailabilitySets/AvailabilitySet") | ? {[string]$_.Name -eq "$name"};

		$this.Name = $name;
		$this.Enabled = $config.Enabled;
		$this.DailyProbability = $config.DailyProbability;
		$this.MaxAffectedInstance = $config.MaxAffectedInstance;
	}
}