#
# PoshMonkeys.ps1
#

Import-Module "$PSScriptRoot\Logger.ps1"

class PoshMonkeys
{
	PoshMonkeys()
	{}

	[void] Start()
	{
		$trigger = New-JobTrigger -RepeatIndefinitely  -RepetitionInterval "1:00:00";
		Register-ScheduledJob -Name "PoshMonkeys schedule run" -Trigger $trigger -FilePath "$PSScriptRoot\RunPoshMonkeys.ps1"
	}

	[void] Stop()
	{
		Unregister-ScheduledJob -Name "PoshMonkeys schedule run" -Force
	}
}