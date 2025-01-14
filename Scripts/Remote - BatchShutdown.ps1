<# Version 1.0 03/02/2022 (dd/mm/yyyy)
Initial version of Batch Shutdown as a free script.
#>
Write-Host "Can be used to shutdown or restart the local machine, but it's primary"
Write-Host "use is to manage other computers. You have been warned."

Prompt-List
$restartprompt = Read-Host -Prompt "Restart instead of shutdown?[y/N]"
ForEach ($computer in $list) {
ping $computer.name -n 1 | Out-Null
    If ($LASTEXITCODE -eq 0) {
        If ( $restartprompt -eq 'y') {
            Write-Host $computer.name "is restarting."
            Restart-Computer -ComputerName $computer.name -Force -AsJob | Out-Null
        } Else {
            Write-Host $computer.name "is shutting down."
            Stop-Computer -ComputerName $computer.name -Force -AsJob | Out-Null
        }
    } Else {
    Write-Host $computer.name "is not online."
    }
}
pause
Main-Menu