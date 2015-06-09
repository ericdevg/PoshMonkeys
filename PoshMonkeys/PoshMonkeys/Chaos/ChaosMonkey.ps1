#
# ChaosMonkey.ps1
#

Import-Module "$PSScriptRoot\ChaosMonkeyConfig.ps1"
Import-Module "$PSScriptRoot\..\InstanceCrawler.ps1"
Import-Module "$PSScriptRoot\..\InstanceSelector.ps1"

class ChaosMonkey
{
	[AzureClient] $AzureClient;
	[string] $Type;
	[MonkeyCalendar] $Calendar;
	[ChaosMonkeyConfig] $Config;
	[InstanceCrawler] $Crawler;
	
	ChaosMonkey([AzureClient] $azureClient, [MonkeyCalendar] $calendar, [ChaosMonkeyConfig] $config, [InstanceCrawler] $crawler)
	{
		$this.AzureClient = $azureClient;
		$this.Type = "chaos";
		$this.Calendar = $calendar;
		$this.Config = $config;
		$this.Crawler = $crawler;
	}

	[void] DoBusiness()
	{
		Write-Host "Entering Chaos Monkey";
		$selector = [InstanceSelector]::new($this.Calendar, $this.Config, $this.Crawler);
		$instances = $selector.Select("AS007");

		Write-Host "Exiting Chaos Monkey";
	}
}



