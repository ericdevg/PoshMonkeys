#
# Instance.ps1
#

class Instance
{
	[string] $Name;
	[string] $ServiceName;

	Instance([string] $name, [string] $serviceName)
	{
		$this.Name = $name;
		$this.ServiceName = $serviceName;
	}
}