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
	[array] $EventsList;

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

		$this.EventsList = Get-Item $PSScriptRoot\Events\*.ps1 | Select-Object Name | ForEach-Object {$_.Name.Substring(0, $_.Name.LastIndexOf('.'))};
	}

	[void] DoBusiness([PSCredential] $cred)
	{
		$this.Logger.LogEvent("Chaos Monkey start sworking on his business ...", "ChaosMonkey", $null);
		$this.Logger.LogEvent("Instance selector starts picking up instance ...", "ChaosMonkey", $null);

		$selector = [InstanceSelector]::new($this.Calendar, $this.Config, $this.Crawler, $this.Logger);
		
		foreach($instancGroup in $this.Crawler.AllInstanceGroups)
		{
			$this.Logger.LogEvent("Instance group $($instancGroup.Name) is found", "ChaosMonkey", $null);
			$instances = $selector.Select($instancGroup.Name);

			$this.Logger.LogEvent("$($instances.Count) instances was randomly selected", "ChaosMonkey", $null);
			foreach($instance in $instances)
			{
				$this.Logger.LogEvent("Simulating the failure event on instance $($instance.Name)", "ChaosMonkey", $null);

				[int] $rand = 0;
				if($this.EventsList.Count > 1)
				{
					$rand = Get-Random -Minimum 0 -Maximum ($this.EventsList.Count - 1);
				}

				$this.Logger.LogEvent("Event $($this.EventsList[$rand]) is randomly selected for instance $($instance.Name)", "ChaosMonkey", $this.EventsList[$rand]);
				$this.Logger.LogEvent("Simulating $($this.EventsList[$rand]) on instance $($instance.Name)", "ChaosMonkey", $this.EventsList[$rand]);

				$vmInstance = Get-AzureVM -Name $instance.Name -ServiceName $instance.ServiceName;

				# you cannot dot sourcing script from class method
				& $PSScriptRoot\Events\$($this.EventsList[$rand]).ps1 -Instance $vmInstance -Logger $this.Logger -Credential $cred;

				$this.Logger.LogEvent("Finished to simulating $($this.EventsList[$rand]) on instance $($instance.Name)", "ChaosMonkey", $this.EventsList[$rand]);
			}
		}
		
		
		$this.Logger.LogEvent("Chaos Monkey finished his business ...", "ChaosMonkey", $null);
	}
}



