#
# BurnCpu.ps1
#

for($i = 0; $i -lt 32; $i++)
{
	start-job -ScriptBlock{
		foreach ($loopnumber in 1..2147483647) 
		{
			$result = 1;
			foreach ($number in 1..2147483647) 
			{
				$result = $result * $number
			}
			$result;
		}
	}

}

Wait-Job *
Remove-job *