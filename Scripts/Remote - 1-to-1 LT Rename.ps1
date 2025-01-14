
# Get an authorized user's credentials.
function replace-computer() {
# Enter in the computer we need to remove
#Write-Host "If you are finished, type Exit as the computer name."
$correctcomputername = Read-Host -Prompt "Enter new name of old computer e.g. NewNameLT01"
If ($correctcomputername -eq 'Exit'){
Main-Menu 
} 
# Pull that computer GUID from the domain and delete it.
$tempcomputername = Read-Host -Prompt "Enter current name of replacement computer e.g. OldNameLT99"

Rename-Computer -ComputerName $tempcomputername -NewName $correctcomputername -DomainCredential $global:creds -Force -Restart
Write-Host "Computer renamed"


sleep 5
$adcomputer = Get-ADComputer -Identity $correctcomputername -Credential $global:creds
# This will pull the GUID of the OU for the laptop and then move the specified computer to that OU.
Move-ADObject -Identity $adcomputer.ObjectGUID -TargetPath "OU=1-1 LTs,OU=Computers,DC=intranet,DC=qps,DC=org" -Credential $global:creds
Write-Host "Computer moved to correct OU"
replace-computer
}

replace-computer
Main-Menu