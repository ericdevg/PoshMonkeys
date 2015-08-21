#
# FailDnsEvent.ps1
#

Param(
	[object] $Instance,
	[object] $Logger,
	[PSCredential] $Credential
)

if($Credential -eq $null)
{
	$Credential = Get-Credential;
}

$sim = [EventSimulator]::new($Instance, $Logger);
$sim.ExecuteScript("faildns", $Credential);
