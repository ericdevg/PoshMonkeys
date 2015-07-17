#
# BurnCpuEvent.ps1
#

Param(
	[PersistentVMRoleListContext] $Instance,
	[Logger] $Logger,
	[PSCredential] $Credential
)

Simulate($Instance, $Logger, $Credential, "burncpu");