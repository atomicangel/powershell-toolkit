# Monitor Jobs in current session

sleep 1
$jobs = Get-Job -State Failed -HasMoreData $True
Write-Host "Listing all output from Failed Jobs."

ForEach ( $job in $jobs ) {
Write-Host $("Job id:" + $job.Id)
Receive-Job -Job $job
pause
clear
}

sleep 1
$jobs = Get-Job -State Running -HasMoreData $True
Write-Host "Listing all output from Running Jobs."

ForEach ( $job in $jobs ) {
Write-Host $("Job id:" + $job.Id)
Receive-Job -Job $job
pause
clear
}

sleep 1
$jobs = Get-Job -State Completed -HasMoreData $True
Write-Host "Listing all output from Completed Jobs."

ForEach ( $job in $jobs ) {
Write-Host $("Job id:" + $job.Id)
Receive-Job -Job $job
pause
clear
}

Main-Menu