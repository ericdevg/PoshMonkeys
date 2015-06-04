#
# MonkeyCalendar.ps1
#

Import-Module "$PSScriptRoot\ClientConfig.ps1"

class MonkeyCalendar
{
	[System.TimeZone] $TimeZone;
	[int] $OpenHour;
	[int] $CloseHour;
	[int[]] $Holidays;

	[ClientConfig] $ClientConfig;

	MonkeyCalendar([ClientConfig] $clientConfig)
	{
		$this.ClientConfig = $clientConfig;
		#$this.TimeZone = $clientConfig.XmlConfig.Configurations.TimeZone;
		$this.OpenHour = $clientConfig.XmlConfig.Configurations.OpenHour;
		$this.CloseHour = $clientConfig.XmlConfig.Configurations.CloseHour;
	}

	[Bool] IsMonkeyBusinessTime()
	{
		return $true;
	}
}