<#
Made this due to the policy change by Microsoft regarding AD Object Ownership.
We have had on occasion devices that needed to be added manually to the Domain instead of through the SCCM deployment.
This will allow us to rip out the object and then once it's manually joined again it will put it back into it's previous OU.
This is typically for the computer models that have problems with the SCCM deployment.
#>

$server = <server ip or hostname>
# Enter in the computer we need to remove
$correctcomputername = Read-Host -Prompt "Enter name of old computer e.g. SHTEACHLT01"

# Pull that computer GUID from the domain and delete it.
$adcomputer = Get-ADComputer -Server $server -Identity $correctcomputername -Credential $global:creds
$original_OU = $($adcomputer.DistinguishedName -Split ',' ,2)[1]
Write-Output $original_OU
Remove-ADComputer -Server $server -Identity $adcomputer.ObjectGUID -Credential $global:creds -Confirm:$false
Write-Host "Computer removed"
Read-Host -Prompt "Press Enter once machine has been re-joined to the domain."
$adcomputer = Get-ADComputer -Server $server -Identity $correctcomputername -Credential $global:creds
# This will pull the GUID of the OU for the laptop and then move the specified computer to that OU.
Move-ADObject -Server $server -Identity $adcomputer.ObjectGUID -TargetPath $original_OU -Credential $global:creds
Write-Host "Computer moved to correct OU"
pause
Main-Menu
