#
# MonkeyScheduler.ps1
#

class MonkeyScheduler
{
	[MonkeyCalenar] $Calendar;

	MonkeyScheduler([MonkeyCalendar] $calendar)
	{
		$this.Calendar = $calendar;
	}

	[int] $frequency;

	[void] StartMonkeyJob([object] $monkey)
	{
		if ($this.Calendar.IsMonkeyBusinessType)
		{
			Start-Job -Name $monkey.Type -FilePath "$PSScriptRoot\MonkeyRunner.ps1" -ArgumentList $monkey
		}
	}

	[void] StopMonkeyJob()
	{
		Get-Job | Remove-Job;
	}
}