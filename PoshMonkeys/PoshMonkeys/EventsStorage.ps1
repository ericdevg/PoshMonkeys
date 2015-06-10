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

	[void] LogEvent([string] $monkeyType, [string] $message)
	{
		$entity = New-Object Microsoft.WindowsAzure.Storage.Table.DynamicTableEntity $monkeyType, [System.DateTime]::Now.Ticks;

		$entity.Properties.Add("MonkeyType", $monkeyType);
		$entity.Properties.Add("Message", $message);

		#$this.Table.CloudTable.Execute([Microsoft.WindowsAzure.Storage.Table.TableOperation]::Insert($entity));
	}

	[object] QueryEvents([object] $list, [string] $filter, [int] $count)
	{
		$query = New-Object Microsoft.WindowsAzure.Storage.Table.TableQuery

		#Set query details.
		$query.FilterString = $filter;
		$query.SelectColumns = $list
		$query.TakeCount = $count;

		#Execute the query.
		$entities = $this.Table.CloudTable.ExecuteQuery($query)

		return $entities;
	}
}