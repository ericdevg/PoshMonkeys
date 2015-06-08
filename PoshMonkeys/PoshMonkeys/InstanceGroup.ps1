#
# InstanceGroup.ps1
#

class InstanceGroup
{
	[string] $Name;

    [string] $Region;

	[array] $Instances;

    InstanceGroup([string] $name) 
	{
        $this.Name = $name;
		$this.Instances = @();
    }

    [void] AddInstance([string] $instanceName) {
        $this.Instances += $instanceName;
    }
}