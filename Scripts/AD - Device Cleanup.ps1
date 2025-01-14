<# Version 1.0 06-03-2024

Making this so it will be easier to ensure a device is deleted from the AD and/or SCCM. 
Also making it easier to do a batch of devices.

#>
$server = <server ip or hostname>
$search_base = "OU=Computers,DC=example,DC=com"
function Manual_Removal{

$computer = $null
$computername = Read-Host -Prompt "Enter name of computer to be removed from AD."
Set-Clipboard -Value $computername									# So we can paste in the name in the later Remove SCCM Computer.exe tool.
Write-Host $("Copied " + $computername + " to clipboard.")
$computer = Get-ADComputer -Server 10.21.2.1 -Credential $global:creds -SearchBase "OU=Objects,DC=intranet,DC=qps,DC=org" -Filter "Name -like '$computername'" -Properties *
If ($computer -ne $null) {
Write-Output "Removing computer from AD..."
Remove-ADComputer -Identity $computer.ObjectGUID -Credential $global:creds -Confirm:$False
}
& '\\location\of\Remove SCCM Computer.exe'							# We have this in our domain because technicians do not have direct access to SCCM from a prompt. If I had written this I would have added parameters to allow passing the name directly into it.
clear
Menu
}

function batch_removal{
$list.Clear()
Write-Host "We can do a 'batch' removal from SCCM by pulling a list of devices and copying each one to the clipboard."
$temp_query = Read-Host -Prompt "To do a removal from SCCM, just hit Enter. For AD, type AD and press Enter."
If ( $temp_query -eq "AD" ) {
$computername = Read-Host -Prompt "Enter designation of computers to be removed from AD"
$computername_confirm = Read-Host -Prompt "Re-enter designation of computers to be removed from AD"
If ($computername -eq $computername_confirm) {
Get-Computers $computername *

Write-Output $list[0..9] | Format-Table -AutoSize -Property Name,'ms-Mcs-AdmPwd',Description,OperatingSystemVersion,CanonicalName
Write-Host -ForegroundColor DarkRed -BackgroundColor Black "This action is IRREVERSABLE!!!!"
Write-Host -ForegroundColor DarkRed -BackgroundColor Black "Please for the love the maker confirm these are the right machines before continuing."
$temp_query = Read-Host -Prompt "Press Y to confirm the selection, otherwise press N to abort."
If ($temp_query -eq 'y') {
$index=0
While ($index -le '9' -AND $index -lt $list.Count) {
Write-Host $("Removing " + $list[$index].name + " from the domain...")
If ( $list[$index].name -ne $Null ){
$computerObjectGUID = $list[$index].ObjectGUID
#Write-Host $computerObjectGUID                        # For debugging purposes
Remove-ADComputer -Identity $computerObjectGUID -Credential $global:creds -Confirm:$false
$index++
sleep 1
}
}
pause
$list.Clear()
clear
#Menu
} Else {
clear
Write-Host -ForegroundColor DarkYellow "Aborting procedure. Exiting to menu."
#Menu
}
} Else {
Write-Output "The designations didn't match!"
Read-Host -Prompt "Press Enter to try again."
batch_removal
}
} Else {
$list.Clear()
$temp_query = ""
$computername = Read-Host -Prompt "Enter designation of computers to be removed from SCCM"
Write-Output "When asking for the range the syntax is x..y e.g. 1..30 or whatever range you need."
Write-Output "Example: Designation: StaffLT    Range: 1..10"
$range = Read-Host -Prompt "Enter a number range or put * to do all machines in designation"
Get-Computers $computername $range
Write-Output $list | Format-Table -AutoSize -Property Name,'ms-Mcs-AdmPwd',Description,OperatingSystemVersion,CanonicalName		# The mc-Mcs-AdmPwd field is the LAPS password for the local admin account.
$temp_query = Read-Host -Prompt "Press Y to confirm the selection, otherwise press N to abort."
If ($temp_query -eq 'y') {
ForEach ( $computer in $list ) { 
If ( $computer.name -ne $Null ){
Set-Clipboard $computer.name
Write-Host $($computer.name + " copied to clipboard.")
& '\\haze\Technology\_HelpDeskTechs\Remove SCCM Computer.exe'				# We have this in our domain because technicians do not have direct access to SCCM from a prompt. If I had written this I would have added parameters to allow passing the name directly into it.
}
}
}
}
pause
clear
Menu
}

function Menu(){
 $menu = Read-Host -Prompt "Select a removal method.
 1) Manual Removal
 2) Batch Removal
 3) Exit
 Selection"

 switch($menu){
    '1' {
            Write-Host "Manual Removal"
            manual_removal
        }

    '2' {
            Write-Host "Batch Removal"
            batch_removal
        }
    '3' {
            Main-Menu
        }

    default {
            Write-Host "Did you just hit enter?!"
            Write-Host "Exiting to Main Menu..."
            Pause
            Main-Menu
        }
}
}

menu