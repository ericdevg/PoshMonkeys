#
# InstanceGroup.ps1
#

class InstanceGroup
{
	[string] $Name;

    [string] $Region;

	[System.Collections.Generic.List[string]] $Instances;

    InstanceGroup([string] $name) 
	{
        $this.Name = name;
		$this.Instances = New-Object 'System.Collections.Generic.List[string]';
    }

    [void] AddInstance([string] $instance) {
        $this.Instances.add($instance);
    }
}