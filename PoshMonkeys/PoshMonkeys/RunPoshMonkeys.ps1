#
# RunPoshMonkeys.ps1
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

# global config loading
$azureClient = [AzureClient]::new();
$monkeyConfig = [ClientConfig]::new("PoshMonkeys.Properties.xml");
$calendar = [MonkeyCalendar]::new($monkeyConfig);

# monkeys config loading
$chaosMonkeyConfig = [ChaosMonkeyConfig]::new();

# create all monkey instance
$monkey = [ChaosMonkey]::new($azureClient);

# locate all target availability sets
$crawler = [InstanceCrawler]::new($azureClient);

$selector = [InstanceSelector]::new($calendar, $chaosMonkeyConfig, $crawler);
$instances = $selector.Select("AS007");

if ($calendar.IsMonkeyBusinessTime())
{
	$monkey.DoBusiness();
}

Get-module | Remove-Module
