#
# EventsStorage.ps1
#

class EventsStorage
{
	[object] $Table;

	EventsStorage([AzureClient] $client)
	{
		$ctx = New-AzureStorageContext $client.StorageAccountName -StorageAccountKey $client.StorageAccountKey;
		$this.Table = Get-AzureStorageTable -Name $client.StorageTableName -Context $ctx;

		if($this.Table -eq $null)
		{
			$this.Table = New-AzureStorageTable -Name $client.StorageTableName -Context $ctx;
		}
	}

	[void] LogEvent([string] $message, [string] $logType, [string] $eventType)
	{
		$entity = New-Object Microsoft.WindowsAzure.Storage.Table.DynamicTableEntity($logType, [System.DateTime]::Now.Ticks.ToString());

		$entity.Properties.Add("EventType", $eventType);
		$entity.Properties.Add("Message", $message);
		$entity.Properties.Add("LogType", $logType);
		
		$this.Table.CloudTable.Execute([Microsoft.WindowsAzure.Storage.Table.TableOperation]::Insert($entity));
	}

	[object] QueryEvents([object] $list, [string] $filter, [int] $count)
	{
		$query = New-Object Microsoft.WindowsAzure.Storage.Table.TableQuery

		# set query details.
		$query.FilterString = $filter;
		$query.SelectColumns = $list
		$query.TakeCount = $count;

		# execute the query.
		$entities = $this.Table.CloudTable.ExecuteQuery($query)

		return $entities;
	}
}