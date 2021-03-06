#
# InstanceSelector.ps1
#

# Select. Pick random instances out of the group with provided probability. Chaos will draw a random number and if
# that random number is lower than probability then it will proceed to select an instance (at random) out of the
# group. If the random number is higher than the provided probability then no instance will be selected and
# <b>null</b> will be returned.
#
# When the daily probability value(say M) is bigger than the open hours for that day(say N), it will just select 
# random numbers of instance(less than MaxAffectedInstance) to operate on
#
# The probability is the run probability. If Chaos is running hourly between 9am and 3pm with an overall configured
# probability of "1.0" then the probability provided to this routine would be 1.0/6 (6 hours in 9am-3pm). So the
# typical probability here would be .1666. For Chaos to select an instance it will pick a random number between 0
# and 1. If that random number is less than the .1666 it will proceed to select an instance and return it,
# otherwise it will return null. Over 6 runs it is likely that the random number be less than .1666, but it is not
# certain. 
#
# To make Chaos select an instance with 100% certainty it would have to be configured to run only once a day and
# the instance group would have to be configured for "1.0" daily probability.
#
# @param group
#            the group
# @param probability
#            the probability per run that an instance should be terminated.
# @return the instance

class InstanceSelector
{
	[MonkeyCalendar] $Calendar;
	[ChaosMonkeyConfig] $ChaosConfig;
	[InstanceCrawler] $Crawler;

	[Logger] $Logger;

	InstanceSelector([MonkeyCalendar] $calendar, [ChaosMonkeyConfig] $chaosConfig, [InstanceCrawler] $crawler, [Logger] $logger)
	{
		$this.Logger = $logger;

		$this.Logger.LogEvent("Instantiating instance selector ...", "InstanceSelector", $null);
		$this.Calendar = $calendar;
		$this.ChaosConfig = $chaosConfig;
		$this.Crawler = $crawler;
		$this.Logger.LogEvent("Finished instantiating instance selector ...", "InstanceSelector", $null);
	}
	
	[array] Select([string] $instanceGroupName)
	{
		$this.Logger.LogEvent("Selecting instance(s) under group $instanceGroupName ...", "InstanceSelector", $null);

		$selectedInstances = @();

		try
		{
			[InstanceGroup] $group = $this.Crawler.AllInstanceGroups | Where-Object {$_.Name -eq "$instanceGroupName"};

			if($group -ne $null)
			{
				$this.Logger.LogEvent("Group $instanceGroupName was found.", "InstanceSelector", $null);

				$this.Logger.LogEvent("Calculating possibilities ...", "InstanceSelector", $null);
				[int] $openHours = $this.Calendar.CloseHour - $this.Calendar.OpenHour;
				[ChaosInstanceGroupConfig] $groupConfig = $this.ChaosConfig.InstanceGroupChaosConfig | Where-Object {$_.Name -eq "$instanceGroupName"};
				[int] $dailyProbability = $groupConfig.DailyProbability;
				[double] $hourlyProbability = $dailyProbability / $openHours;
				$this.Logger.LogEvent("DailyProbability = $dailyProbability, HourlyProbability = $hourlyProbability", "InstanceSelector", $null);

				if($hourlyProbability -gt 1)
				{
					$hourlyProbability = 1;
				}
		
				[int] $rand1 = Get-Random -Minimum 0 -Maximum 100;
		
				if($rand1 / 100 -lt $hourlyProbability)
				{
					$this.Logger.LogEvent("Hourly probability hit. Randomly picking up instances ...", "InstanceSelector", $null);
					[int] $rand2 = 1;
					if($groupConfig.MaxAffectedInstance -gt 1)
					{
						$rand2 = Get-Random -Minimum 1 -Maximum $groupConfig.MaxAffectedInstance;
					}
					$selectedInstances = $group.Instances | Get-Random -Count $rand2;
					$this.Logger.LogEvent("Hourly probability hit. Finished randomly picking up instances ...", "InstanceSelector", $null);
				}
			}
			else
			{
				$this.Logger.LogEvent("Group $instanceGroupName was not found.", "InstanceSelector", $null);
			}
		}
		catch
		{
			$this.Logger.LogEvent($_, "InstanceSelector", "Error");
			throw;
		}

		$this.Logger.LogEvent("Finished selecting instances under group $instanceGroupName.", "InstanceSelector", $null);
		return $selectedInstances;
	}
}