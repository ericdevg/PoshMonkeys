#
# Script.ps1
#
Import-Module "$PSScriptRoot\Logger.ps1"
Import-Module "$PSScriptRoot\ClientConfig.ps1"
Import-Module "$PSScriptRoot\AzureClient.ps1"
Import-Module "$PSScriptRoot\MonkeyCalendar.ps1"
Import-Module "$PSScriptRoot\Chaos\ChaosMonkey.ps1"

$monkeyConfig = [ClientConfig]::new("PoshMonkeys.Properties.xml");
$calendar = [MonkeyCalendar]::new($monkeyConfig);

if ($calendar.IsMonkeyBusinessTime())
{
	$azureClient = [AzureClient]::new();
	$monkey = [ChaosMonkey]::new($azureClient);
	$monkey.DoBusiness();
}

Get-module | Remove-Module