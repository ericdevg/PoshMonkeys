#
# ClientConfig.psm1
#

class ClientConfig
{
	[xml] $XmlConfig

	ClientConfig([string] $ConfigFilePath)
	{
		# Import azure client from config file
		$this.XmlConfig = Get-Content "$PSScriptRoot\Config\$ConfigFilePath";
	}
}

