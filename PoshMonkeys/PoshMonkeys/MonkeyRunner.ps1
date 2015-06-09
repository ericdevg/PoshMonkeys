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

Param(
	[object][Parameter(Mandatory=$true)] $Monkey
)

$monkey.DoBusiness();