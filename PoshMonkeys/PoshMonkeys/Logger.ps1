#
# Logger.ps1
#

class Logger
{
	[string] $LogFile;
	[EventsStorage] $Storage;

	Logger([string] $logPath)
	{
		if(($logPath -eq $null) -or ((Test-Path "$logPath") -eq $false))
		{
			Write-Error "Invalid log path!";
			$logPath = "$PSScriptRoot\";
		}

		$logNamePrefix = "PoshMonkeys"	

		$timestamp = Get-Date -Format MM.dd.yyyy;
		$logName = "$logNamePrefix $timestamp.log";

		$this.LogFile = "$logPath\$logName";

		#Check if file exists and delete if it does
		If((Test-Path -Path $this.LogFile))
		{
			Remove-Item -Path $this.LogFile -Force
		}

		#Create file and start logging
		New-Item -Path $this.LogFile -ItemType File

		Add-Content -Path $this.LogFile -Value "***************************************************************************************************"

		Add-Content -Path $this.LogFile -Value "Started processing at [$([DateTime]::Now)]."

		Add-Content -Path $this.LogFile -Value "***************************************************************************************************"

		Add-Content -Path $this.LogFile -Value ""

		#Add-Content -Path $this.LogFile -Value "Running script version [$($PSVersionTable.PSVersion.ToString())]."

		Add-Content -Path $this.LogFile -Value ""

		Add-Content -Path $this.LogFile -Value "***************************************************************************************************"

		Add-Content -Path $this.LogFile -Value ""

  

		#Write to screen for debug mode

		Write-Host "***************************************************************************************************"

		Write-Host "Started processing at [$([DateTime]::Now)]."

		Write-Host "***************************************************************************************************"

		Write-Host ""

		#Write-Host "Running script version [$($PSVersionTable.PSVersion.ToString())]."

		Write-Host ""

		Write-Host "***************************************************************************************************"

		Write-Host ""
	}

	[void] SetStorage([EventsStorage] $storage)
	{
		if($storage -ne $null)
		{
			$this.Storage = $storage;
			$this.Log("Azure storage table is ready for PoshMonkey activity logging.");
		}
		else
		{
			$this.Log("Warning: No Azure storage table ready for PoshMonkey activity logging.");
		}
	}

	[void] Log([string] $message)
	{
		Add-Content -Path $this.LogFile -Value "$message";
		Write-Host "$message"
	}

	[void] LogEvent([string] $message, [string] $logType, [string] $eventType)
	{
		$this.Log("[$logType][$eventType]: $message");

		if($this.Storage -ne $null)
		{
			$this.Storage.LogEvent($message, $logType, $eventType);
		}
	}
}