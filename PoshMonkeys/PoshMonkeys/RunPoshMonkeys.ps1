#
# RunPoshMonkeys.ps1
#

Param(
	[string] $ModulePath = $PSScriptRoot,
	[PSCredential] $cred
)

Import-Module Azure

Import-Module "$ModulePath\ClientConfig.ps1"
Import-Module "$ModulePath\AzureClient.ps1"
Import-Module "$ModulePath\EventsStorage.ps1"
Import-Module "$ModulePath\Logger.ps1"
Import-Module "$ModulePath\MonkeyCalendar.ps1"
Import-Module "$ModulePath\Instance.ps1"
Import-Module "$ModulePath\InstanceGroup.ps1"
Import-Module "$ModulePath\InstanceCrawler.ps1"
Import-Module "$ModulePath\Chaos\ChaosInstanceGroupConfig.ps1"
Import-Module "$ModulePath\Chaos\ChaosMonkeyConfig.ps1"
Import-Module "$ModulePath\InstanceSelector.ps1"
Import-Module "$ModulePath\MonkeyScheduler.ps1"
Import-Module "$ModulePath\Chaos\ChaosMonkey.ps1"

if($cred -eq $null)
{
	$cred = Get-Credential;
}

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
$job = $scheduler.StartMonkeyJob($monkey, $cred);

# wait for all of them to finish work
if($job -ne $null)
{
	$job.AsyncWaitHandle.WaitOne();
}

# clean all modules
Get-Module | Remove-Module