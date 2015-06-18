#
# Start_PoshMonkeys.ps1
#

$trigger = New-JobTrigger -RepeatIndefinitely  -RepetitionInterval (New-TimeSpan -Minutes 5) -At "01/01/2015 00:00:00" -Once;
Register-ScheduledJob -Name "PoshMonkeys schedule run" -Trigger $trigger -FilePath "$PSScriptRoot\RunPoshMonkeys.ps1" -ArgumentList $PSScriptRoot;