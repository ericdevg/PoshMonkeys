#
# Start_PoshMonkeys.ps1
#

Write-Host "Please enter one credential for accessing all remote instances."
$cred = Get-Credential;
$trigger = New-JobTrigger -RepeatIndefinitely  -RepetitionInterval (New-TimeSpan -Minutes 5) -At "01/01/2015 00:00:00" -Once;
Register-ScheduledJob -Name "PoshMonkeys schedule run" -Trigger $trigger -FilePath "$PSScriptRoot\RunPoshMonkeys.ps1" -ArgumentList $PSScriptRoot, $cred;