#
# MonkeyScheduler.ps1
#

class MonkeyScheduler
{
	[MonkeyCalendar] $Calendar;

	[Logger] $Logger;

	MonkeyScheduler([MonkeyCalendar] $calendar, [Logger] $logger)
	{
		$this.Logger = $logger;

		$this.Logger.LogEvent("Instantiating MonkeyScheduler ...", "MonkeyScheduler", $null);
		$this.Calendar = $calendar;
		$this.Logger.LogEvent("Finished instantiating MonkeyScheduler ...", "MonkeyScheduler", $null);
	}

	[void] StartMonkeyJob([object] $monkey)
	{
		$this.Logger.LogEvent("Starting MonkeyRunner job to send monkey to work ...", "MonkeyScheduler", $null);
		if ($this.Calendar.IsMonkeyBusinessTime())
		{
			Start-Job -Name $monkey.Type -FilePath "$PSScriptRoot\MonkeyRunner.ps1" -ArgumentList $monkey
			#. C:\tip\PoshMonkeys\PoshMonkeys\PoshMonkeys\MonkeyRunner.ps1 $monkey
			$this.Logger.LogEvent("Finished sending monkey to work ...", "MonkeyScheduler", $null);
		}
		else
		{
			$this.Logger.LogEvent("This monkey is not in business hour accourding to calendar ...", "MonkeyScheduler", $null);
		}
	}

	[void] StopMonkeyJob()
	{
		$this.Logger.LogEvent("Removing all monkey runner jobs to stop monkey businesss ...", "MonkeyScheduler", $null);
		Get-Job | Remove-Job;
		$this.Logger.LogEvent("Finished removing all monkey runner jobs to stop monkey businesss.", "MonkeyScheduler", $null);
	}
}