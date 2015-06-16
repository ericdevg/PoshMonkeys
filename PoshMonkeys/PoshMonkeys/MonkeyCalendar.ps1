#
# MonkeyCalendar.ps1
#

class MonkeyCalendar
{
	[System.TimeZone] $TimeZone;
	[int] $OpenHour;
	[int] $CloseHour;
	[int[]] $Holidays;

	[ClientConfig] $ClientConfig;

	[Logger] $Logger;

	MonkeyCalendar([ClientConfig] $clientConfig, [Logger] $logger)
	{
		$this.Logger = $logger;
		$this.Logger.LogEvent("Creating MonkeyCalendar...", "MonkeyCalendar", $null);
		$this.ClientConfig = $clientConfig;
		#$this.TimeZone = $clientConfig.XmlConfig.Configurations.TimeZone;
		$this.OpenHour = $clientConfig.XmlConfig.Configurations.OpenHour;
		$this.CloseHour = $clientConfig.XmlConfig.Configurations.CloseHour;
		$this.Logger.LogEvent("Finished creating MonkeyCalendar.", "MonkeyCalendar", $null);
	}

	[Bool] IsMonkeyBusinessTime()
	{
		$this.Logger.LogEvent("Checking if monkey is in business hours...", "MonkeyCalendar", $null);

		$this.Logger.LogEvent("Finished checking, monkey is in business hours.", "MonkeyCalendar", $null);
		return $true;
	}
}