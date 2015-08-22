#
# Start_PoshMonkeys.ps1
#

Param(
	[switch][Parameter(ParameterSetName="p0")] $IntervalInMinutes,
	[switch][Parameter(ParameterSetName="p1",Mandatory=$true)] $Manual,
	[string][Parameter(ParameterSetName="p1",Mandatory=$true)][ValidateSet('chaos')] $MonkeyType,
	[string][Parameter(ParameterSetName="p1",Mandatory=$true)] $InstanceName,
	[string][Parameter(ParameterSetName="p1",Mandatory=$true)] $ServiceName,
	[string][Parameter(ParameterSetName="p1",Mandatory=$true)] $Event
)

$cred = Get-Credential -Message "Please enter the credential for accessing all remote instances you expect PoshMonkey to be able to reach:";

if($cred -eq $null)
{
	Throw "Credential required for PoshMonkey to operate on remote instances."
}

if($Manual -eq $false)
{
	Write-Host "PoshMonkeys is being deployed and run according to its configuration."

	if($IntervalInMinutes -ne $null)
	{
		$trigger = New-JobTrigger -RepeatIndefinitely  -RepetitionInterval (New-TimeSpan -Minutes $IntervalInMinutes) -At "01/01/2015 00:00:00" -Once;
	}
	else
	{
		$trigger = New-JobTrigger -RepeatIndefinitely  -RepetitionInterval (New-TimeSpan -Hours 1) -At "01/01/2015 00:00:00" -Once;
	}

	Register-ScheduledJob -Name "PoshMonkeysActiveRun" -Trigger $trigger -FilePath "$PSScriptRoot\RunPoshMonkeys.ps1" -ArgumentList $PSScriptRoot, $cred;

	#& $PSScriptRoot\RunPoshMonkeys.ps1 $PSScriptRoot $cred
	
	Write-Host "PoshMonkeys were just deployed, it will be triggered to run according to its configuration. You can use Stop-PoshMonkeys to recall all PoshMonkeys."
}
else
{
	Write-Host "PoshMonkeys is being assigned to run specific task: $Event."
	
	& $PSScriptRoot\RunPoshMonkeys.ps1 -ModulePath $PSScriptRoot -Cred $cred -Manual -MonkeyType $MonkeyType -InstanceName $InstanceName -ServiceName $ServiceName -Event $Event;
	
	Write-Host "PoshMonkeys were just finished run the task: $Event."
}
