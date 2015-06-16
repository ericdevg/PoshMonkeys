#
# ChaosMonkey.ps1
#

class ChaosMonkey
{
	[AzureClient] $AzureClient;
	[string] $Type;
	[MonkeyCalendar] $Calendar;
	[ChaosMonkeyConfig] $Config;
	[InstanceCrawler] $Crawler;

	[Logger] $Logger;
	
	ChaosMonkey([AzureClient] $azureClient, [MonkeyCalendar] $calendar, [ChaosMonkeyConfig] $config, [InstanceCrawler] $crawler, [Logger] $logger)
	{
		$this.Logger = $logger;

		$this.Logger.LogEvent("Creating chaos monkey ...", "ChaoMonkey", $null);
		$this.AzureClient = $azureClient;
		$this.Type = "chaos";
		$this.Calendar = $calendar;
		$this.Config = $config;
		$this.Crawler = $crawler;
		$this.Logger.LogEvent("Finished creating chaos monkey ...", "ChaoMonkey", $null);
	}

	[void] DoBusiness()
	{
		$this.Logger.LogEvent("Chaos Monkey working on his business ...", "ChaosMonkey", $null);
		$this.Logger.LogEvent("Instance selector start picking up instance ...", "ChaosMonkey", $null);

		$selector = [InstanceSelector]::new($this.Calendar, $this.Config, $this.Crawler, $this.Logger);
		$instances = $selector.Select("AS007");
		
		$this.Logger.LogEvent("Chaos Monkey finished his business ...", "ChaosMonkey", $null);
	}
}



