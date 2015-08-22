#
# RunPoshMonkeys.ps1
#

Param(
	[string][Parameter(Position=1)] $ModulePath = "C:\tip\PoshMonkeys\PoshMonkeys\PoshMonkeys",
	[PSCredential][Parameter(Position=2,Mandatory=$true)] $Cred,
	[switch][Parameter(ParameterSetName="p0")] $NullP,
	[switch][Parameter(ParameterSetName="p1",Mandatory=$true)] $Manual,
	[string][Parameter(ParameterSetName="p1",Mandatory=$true)][ValidateSet('Chaos')] $MonkeyType,
	[string][Parameter(ParameterSetName="p1",Mandatory=$true)] $InstanceName,
	[string][Parameter(ParameterSetName="p1",Mandatory=$true)] $ServiceName,
	[string][Parameter(ParameterSetName="p1",Mandatory=$true)] $Event
)

try
{
	$ErrorActionPreference = "stop";

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
	Import-Module "$ModulePath\Chaos\EventSimulator.ps1"

	if($Cred -eq $null)
	{
		$Cred = Get-Credential -Message "Please enter the credential for accessing all remote instances you expect PoshMonkey to be able to reach:";
	}

	# global config loading
	$monkeyConfig = [ClientConfig]::new("PoshMonkeys.Properties.xml");
	$logger = [Logger]::new($monkeyConfig.XmlConfig.Configurations.LogFilePath);

	$azureClient = [AzureClient]::new($logger);
	$eventsStorage = [EventsStorage]::new($azureClient, $logger);

	# initantiate storage logger
	$logger.SetStorage($eventsStorage);

	if($Manual -eq $false)
	{
		# create monkey calendar
		$calendar = [MonkeyCalendar]::new($monkeyConfig, $logger);

		# monkeys config loading
		$chaosMonkeyConfig = [ChaosMonkeyConfig]::new($logger);

		# crawl for all target availability sets
		$crawler = [InstanceCrawler]::new($azureClient, $logger);

		# create all monkey instance
		$monkeys = @([ChaosMonkey]::new($azureClient, $calendar, $chaosMonkeyConfig, $crawler, $logger));

		# create monkey scheduler
		$scheduler = [MonkeyScheduler]::new($calendar, $logger);

		# run all monkeys async
		$scheduler.StartMonkeyJob($monkeys, $cred);

		# wait for all of them to finish work
		#if($job -ne $null)
		#{
		#	$job.AsyncWaitHandle.WaitOne();
		#}
	}
	else
	{
		if($MonkeyType -eq "chaos")
		{
			$monkey = [ChaosMonkey]::new($azureClient, $null, $null, $null, $logger);
			$monkey.DoTask($Cred, $InstanceName, $ServiceName, $Event);
		}
	}
}
finally
{
	# clean all modules
	Get-Module | Remove-Module
}