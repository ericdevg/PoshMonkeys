#
# Script.ps1
#
Import-Module "$PSScriptRoot\Logger.ps1"
Import-Module "$PSScriptRoot\ClientConfig.ps1"
Import-Module "$PSScriptRoot\AzureClient.ps1"
Import-Module "$PSScriptRoot\MonkeyCalendar.ps1"
Import-Module "$PSScriptRoot\Chaos\ChaosMonkey.ps1"
Import-Module "$PSScriptRoot\InstanceGroup.ps1"
Import-Module "$PSScriptRoot\InstanceCrawler.ps1"


$monkeyConfig = [ClientConfig]::new("PoshMonkeys.Properties.xml");
$calendar = [MonkeyCalendar]::new($monkeyConfig);
$azureClient = [AzureClient]::new();
$monkey = [ChaosMonkey]::new($azureClient);

$crawler = [InstanceCrawler]::new($azureClient);

if ($calendar.IsMonkeyBusinessTime())
{
	$monkey.DoBusiness();
}

Get-module | Remove-Module