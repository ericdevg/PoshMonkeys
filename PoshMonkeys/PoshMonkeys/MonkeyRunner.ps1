#
# Script.ps1
#

Param(
	[object][Parameter(Mandatory=$true)] $Monkey
)

$Monkey.DoBusiness();