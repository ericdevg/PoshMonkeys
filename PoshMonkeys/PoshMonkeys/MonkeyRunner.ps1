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
Import-Module "$PSScriptRoot\Chaos\ChaosInstanceGroupConfig.ps1"
Import-Module "$PSScriptRoot\Chaos\ChaosMonkeyConfig.ps1"
Import-Module "$PSScriptRoot\InstanceSelector.ps1"

$monkeyConfig = [ClientConfig]::new("PoshMonkeys.Properties.xml");
$chaosMonkeyConfig = [ChaosMonkeyConfig]::new();
$calendar = [MonkeyCalendar]::new($monkeyConfig);
$azureClient = [AzureClient]::new();
$monkey = [ChaosMonkey]::new($azureClient);

$crawler = [InstanceCrawler]::new($azureClient);

$scheduler = [InstanceSelector]::new($calendar, $chaosMonkeyConfig, $crawler);
$instances = $scheduler.Select("AS007");

if ($calendar.IsMonkeyBusinessTime())
{
	$monkey.DoBusiness();
}

Get-module | Remove-Module