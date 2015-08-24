#
# Script.ps1
#

Param(
	[object][Parameter(Mandatory=$true, Position=1)] $Monkey,
	[object][Parameter(Mandatory=$true, Position=2)] $Logger,
	[PSCredential][Parameter(Mandatory=$true, Position=3)] $Cred
)

try
{
	$ErrorActionPreference = "stop"

	Import-Module Azure

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
	Import-Module "$PSScriptRoot\Chaos\EventSimulator.ps1"

	$Logger.LogEvent("Starting to run monkey", "MonkeyRunner", "");

	$Monkey.DoBusiness($Cred);
}
catch
{
	$Logger.LogEvent($_, "MonkeyRunner", "Error");
}

$Logger.LogEvent("Monkey finished his work", "MonkeyRunner", "");
