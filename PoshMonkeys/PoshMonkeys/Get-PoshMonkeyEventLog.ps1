#
# Get_PoshMonkeyEventLog.ps1
#

Param(
	[string][ValidateSet('chaos')] $MonkeyType = 'chaos',
	[string][ValidateSet('error', 'event', 'info')] $EventType = 'info',
	[string][Parameter(ParameterSetName="p1")] [ValidateSet('today', 'yesterday', 'lastweek', 'lastmonth', 'all')] $TimeRange = 'lastweek',
	[int][Parameter(ParameterSetName="p2")] $Count = -1
)

try
{
	$ErrorActionPreference = "stop";

	Import-Module Azure

	Import-Module "$PSScriptRoot\ClientConfig.ps1"
	Import-Module "$PSScriptRoot\AzureClient.ps1"
	Import-Module "$PSScriptRoot\EventsStorage.ps1"
	Import-Module "$PSScriptRoot\Logger.ps1"

	# global config loading
	$monkeyConfig = [ClientConfig]::new("PoshMonkeys.Properties.xml");
	$logger = [Logger]::new($monkeyConfig.XmlConfig.Configurations.LogFilePath);

	$azureClient = [AzureClient]::new($logger);
	$eventsStorage = [EventsStorage]::new($azureClient, $logger);

	$columns = New-Object 'System.Collections.Generic.List[String]'
	$columns.Add("EventType");
	$columns.Add("Message");
	$columns.Add("Timestamp");

	$filterString = "";
	if($EventType -eq 'error')
	{
		$filterString = [Microsoft.WindowsAzure.Storage.Table.TableQuery]::GenerateFilterCondition(
			"EventType", [Microsoft.WindowsAzure.Storage.Table.QueryComparisons]::Equal, "Error");
	}
	elseif($EventType -eq 'event')
	{
		$filterString = [Microsoft.WindowsAzure.Storage.Table.TableQuery]::GenerateFilterCondition(
			"EventType", [Microsoft.WindowsAzure.Storage.Table.QueryComparisons]::NotEqual, "");
	}
	else
	{
		$filterString = [Microsoft.WindowsAzure.Storage.Table.TableQuery]::GenerateFilterCondition(
			"EventType", [Microsoft.WindowsAzure.Storage.Table.QueryComparisons]::NotEqual, " ");
	}

	$queryCount = -1;
	if($Count -gt 0)
	{
		$queryCount = $Count;
	}

	if($TimeRange -eq 'today')
	{
		$filterString = [Microsoft.WindowsAzure.Storage.Table.TableQuery]::CombineFilters(
			$filterString,
			[Microsoft.WindowsAzure.Storage.Table.TableOperators]::And,
			[Microsoft.WindowsAzure.Storage.Table.TableQuery]::GenerateFilterConditionForDate(
				"Timestamp", [Microsoft.WindowsAzure.Storage.Table.QueryComparisons]::GreaterThanOrEqual, [DateTime]::Today));
	}
	elseif($TimeRange -eq 'yesterday')
	{
		$filterString = [Microsoft.WindowsAzure.Storage.Table.TableQuery]::CombineFilters(
			$filterString,
			[Microsoft.WindowsAzure.Storage.Table.TableOperators]::And,
			[Microsoft.WindowsAzure.Storage.Table.TableQuery]::GenerateFilterConditionForDate(
				"Timestamp", [Microsoft.WindowsAzure.Storage.Table.QueryComparisons]::GreaterThanOrEqual, [DateTime]::Today.AddDays(-1)));
	}
	elseif($TimeRange -eq 'lastweek')
	{
		$filterString = [Microsoft.WindowsAzure.Storage.Table.TableQuery]::CombineFilters(
			$filterString,
			[Microsoft.WindowsAzure.Storage.Table.TableOperators]::And,
			[Microsoft.WindowsAzure.Storage.Table.TableQuery]::GenerateFilterConditionForDate(
				"Timestamp", [Microsoft.WindowsAzure.Storage.Table.QueryComparisons]::GreaterThanOrEqual, [DateTime]::Today.AddDays(-7)));
	}
	elseif($TimeRange -eq 'lastmonth')
	{
		$filterString = [Microsoft.WindowsAzure.Storage.Table.TableQuery]::CombineFilters(
			$filterString,
			[Microsoft.WindowsAzure.Storage.Table.TableOperators]::And,
			[Microsoft.WindowsAzure.Storage.Table.TableQuery]::GenerateFilterConditionForDate(
				"Timestamp", [Microsoft.WindowsAzure.Storage.Table.QueryComparisons]::GreaterThanOrEqual, [DateTime]::Today.AddDays(-30)));
	}

	Write-Host $filterString;

	$logs = $eventsStorage.QueryEvents($columns, $filterString, $queryCount);

	#foreach ($log in $logs)
	#{
	#	Write-Host $log.Properties["EventType"].StringValue +  "  |  " + $log.Properties["Message"].StringValue + "   |   " + $log.Timestamp;
	#}

	$ret = New-Object System.Collections.ArrayList($null)

	foreach ($log in $logs)
	{
		$props = @{
			EventType = $log.Properties["EventType"].StringValue
			Message = $log.Properties["Message"].StringValue
			Timestamp = $log.Timestamp.ToLocalTime()
		};

		$obj = new-object psobject -property $props;
		$ret.Add($obj) | Out-Null;
	}

	$ret | Sort-Object -Property Timestamp | Format-Table -AutoSize -Wrap -Property EventType, Timestamp, Message;
}
finally
{
	Get-Module | Remove-Module;
}