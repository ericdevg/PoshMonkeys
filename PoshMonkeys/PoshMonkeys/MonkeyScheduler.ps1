#
# MonkeyScheduler.ps1
#

Import-Module "$PSScriptRoot\MonkeyCalendar.ps1"

class MonkeyScheduler
{
	[MonkeyCalendar] $Calendar;

	MonkeyScheduler([MonkeyCalendar] $calendar)
	{
		$this.Calendar = $calendar;
	}

	[void] StartMonkeyJob([object] $monkey)
	{
		if ($this.Calendar.IsMonkeyBusinessTime())
		{
			#Start-Job -Name $monkey.Type -FilePath "$PSScriptRoot\MonkeyRunner.ps1" -ArgumentList $monkey
			. C:\tip\PoshMonkeys\PoshMonkeys\PoshMonkeys\MonkeyRunner.ps1 $monkey
		}
	}

	[void] StopMonkeyJob()
	{
		Get-Job | Remove-Job;
	}
}