#
# ChaosMonkey.ps1
#

Import-Module "$PSScriptRoot\ClientConfig.ps1"
Import-Module "$PSScriptRoot\AzureClient.ps1"

Write-Host "Entering Chaos Monkey"

$azureClient = [AzureClient]::new();