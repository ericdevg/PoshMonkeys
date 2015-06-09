#
# Start_PoshMonkeys.ps1
#

Import-Module "$PSScriptRoot\Logger.ps1"
Import-Module "$PSScriptRoot\PoshMonkeys.ps1"

$poshMonkeys = [PoshMonkeys]::new();
$poshMonkeys.Start();