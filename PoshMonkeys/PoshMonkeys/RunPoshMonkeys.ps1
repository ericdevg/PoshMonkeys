#
# RunPoshMonkeys.ps1
#

Import-Module "$PSScriptRoot\Logger.ps1"
Import-Module "$PSScriptRoot\ClientConfig.ps1"
Import-Module "$PSScriptRoot\AzureClient.ps1"
Import-Module "$PSScriptRoot\MonkeyCalendar.ps1"
Import-Module "$PSScriptRoot\InstanceGroup.ps1"
Import-Module "$PSScriptRoot\InstanceCrawler.ps1"
Import-Module "$PSScriptRoot\InstanceSelector.ps1"
Import-Module "$PSScriptRoot\MonkeyScheduler.ps1"
Import-Module "$PSScriptRoot\Chaos\ChaosInstanceGroupConfig.ps1"
Import-Module "$PSScriptRoot\Chaos\ChaosMonkeyConfig.ps1"
Import-Module "$PSScriptRoot\Chaos\ChaosMonkey.ps1"

# global config loading
$azureClient = [AzureClient]::new();
$monkeyConfig = [ClientConfig]::new("PoshMonkeys.Properties.xml");
$calendar = [MonkeyCalendar]::new($monkeyConfig);

# monkeys config loading
$chaosMonkeyConfig = [ChaosMonkeyConfig]::new();

# locate all target availability sets
$crawler = [InstanceCrawler]::new($azureClient);

# create all monkey instance
$monkey = [ChaosMonkey]::new($azureClient, $calendar, $chaosMonkeyConfig, $crawler);

$scheduler = [MonkeyScheduler]::new($calendar);

$scheduler.StartMonkeyJob($monkey);

Get-Module | Remove-Module