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

	[void] StartMonkeyJob([Array] $monkeys, [PSCredential] $cred)
	{
		$this.Logger.LogEvent("Starting MonkeyRunner job to send monkey to work ...", "MonkeyScheduler", $null);

		try
		{
			if ($this.Calendar.IsMonkeyBusinessTime())
			{
				$script = {
					param($p1, $p2, $p3, $p4)
					. "$p1\MonkeyRunner.ps1" -Monkey $p2 -Logger $p3 -Cred $p4;
				};

				foreach($monkey in $monkeys)
				{
					& $PSScriptRoot\MonkeyRunner.ps1 $monkey $this.Logger $cred;

					#$p = [PowerShell]::Create();

					#$p.AddScript($script).AddArgument($PSScriptRoot).AddArgument($monkey).AddArgument($this.Logger).AddArgument($cred);

					## asynchonizely call monkey runner
					#$job = $p.BeginInvoke();
			
					#$this.Logger.LogEvent("Finished sending monkey to work ...", "MonkeyScheduler", $null);
				}
			}
			else
			{
				$this.Logger.LogEvent("This monkey is not in business hour accourding to calendar ...", "MonkeyScheduler", $null);
			}
		}
		catch
		{
			$this.Logger.LogEvent($_, "MonkeyScheduler", "Error");
			throw;
		}
	}

	[void] StopMonkeyJob()
	{
		$this.Logger.LogEvent("Removing all monkey runner jobs to stop monkey businesss ...", "MonkeyScheduler", $null);
		Get-Job | Remove-Job;
		$this.Logger.LogEvent("Finished removing all monkey runner jobs to stop monkey businesss.", "MonkeyScheduler", $null);
	}
}