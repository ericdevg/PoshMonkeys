#
# RunPoshMonkeys.ps1
#

Import-Module Azure
Add-Type -Path "$PSScriptRoot\Reference\Microsoft.WindowsAzure.Storage.dll";

Import-Module "$PSScriptRoot\ClientConfig.ps1"
Import-Module "$PSScriptRoot\AzureClient.ps1"
Import-Module "$PSScriptRoot\EventsStorage.ps1"
Import-Module "$PSScriptRoot\Logger.ps1"
Import-Module "$PSScriptRoot\MonkeyCalendar.ps1"
Import-Module "$PSScriptRoot\Instance.ps1"
Import-Module "$PSScriptRoot\InstanceGroup.ps1"
Import-Module "$PSScriptRoot\InstanceCrawler.ps1"
Import-Module "$PSScriptRoot\Chaos\ChaosInstanceGroupConfig.ps1"
Import-Module "$PSScriptRoot\Chaos\ChaosMonkeyConfig.ps1"
Import-Module "$PSScriptRoot\InstanceSelector.ps1"
Import-Module "$PSScriptRoot\MonkeyScheduler.ps1"
Import-Module "$PSScriptRoot\Chaos\ChaosMonkey.ps1"
Import-Module "$PSScriptRoot\Chaos\Events\BurnCpuEvent.ps1"


# global config loading
$azureClient = [AzureClient]::new();
$eventsStorage = [EventsStorage]::new($azureClient);
$monkeyConfig = [ClientConfig]::new("PoshMonkeys.Properties.xml");

# initantiate logger
$logger = [Logger]::new($monkeyConfig.XmlConfig.Configurations.LogFilePath, "PoshMonkeys", $eventsStorage);
$azureClient.Logger = $logger;

# create monkey calendar
$calendar = [MonkeyCalendar]::new($monkeyConfig, $logger);

# monkeys config loading
$chaosMonkeyConfig = [ChaosMonkeyConfig]::new($logger);

# crawl for all target availability sets
$crawler = [InstanceCrawler]::new($azureClient, $logger);

# create all monkey instance
$monkey = [ChaosMonkey]::new($azureClient, $calendar, $chaosMonkeyConfig, $crawler, $logger);

# create monkey scheduler
$scheduler = [MonkeyScheduler]::new($calendar, $logger);

# run all monkeys
$scheduler.StartMonkeyJob($monkey);

# clean all modules
Get-Module | Remove-Module