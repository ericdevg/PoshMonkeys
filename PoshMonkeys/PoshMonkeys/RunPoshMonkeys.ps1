#
# RunPoshMonkeys.ps1
#

Param(
	[string][Parameter(Position=1,Mandatory=$true)] $ModulePath = $PSScriptRoot,
	[PSCredential][Parameter(Position=2,Mandatory=$true)] $cred,
	[switch][Parameter(ParameterSetName="p0")] $NullP,
	[switch][Parameter(ParameterSetName="p1",Mandatory=$true)] $Manual,
	[string][Parameter(ParameterSetName="p1",Mandatory=$true)][ValidateSet('Chaos')] $MonkeyType,
	[string][Parameter(ParameterSetName="p1",Mandatory=$true)] $InstanceName,
	[string][Parameter(ParameterSetName="p1",Mandatory=$true)] $ServiceName,
	[string][Parameter(ParameterSetName="p1",Mandatory=$true)] $Event
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
Import-Module "$PSScriptRoot\Chaos\EventSimulator.ps1"

if($cred -eq $null)
{
	$cred = Get-Credential -Message "Please enter the credential for accessing all remote instances you expect PoshMonkey to be able to reach:";
}

# global config loading
$azureClient = [AzureClient]::new();
$eventsStorage = [EventsStorage]::new($azureClient);
$monkeyConfig = [ClientConfig]::new("PoshMonkeys.Properties.xml");

# initantiate logger
$logger = [Logger]::new($monkeyConfig.XmlConfig.Configurations.LogFilePath, "PoshMonkeys", $eventsStorage);
$azureClient.Logger = $logger;

if($Manual -eq $false)
{
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

	# run all monkeys async
	$job = $scheduler.StartMonkeyJob($monkey, $cred);

	# wait for all of them to finish work
	if($job -ne $null)
	{
		$job.AsyncWaitHandle.WaitOne();
	}
}
else
{
	$monkey = [ChaosMonkey]::new($azureClient, $null, $null, $null, $logger);
	$monkey.DoTask($cred, $InstanceName, $ServiceName, $Event);
}

# clean all modules
Get-Module | Remove-Module