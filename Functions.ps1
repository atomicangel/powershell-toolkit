<# Updated 03/02/2022
Doing a cleanup and refactoring.
#>
<# Update on 09/06/2020 (dd/mm/yyyy): 
Added Get-Users function to list user properties from the AD. Used Format-List as it allowed for more information to be shown.

#>
$list = [System.Collections.ArrayList]@()
$list.Clear()

function Get-SystemInfo () {
            
$global:wmi = gwmi win32_operatingsystem
$global:cpu = $(Get-CimInstance CIM_Processor | select name | Format-Wide | Out-String)
$global:cpu = $cpu -replace "`n|`r"
            
$global:Disk = get-wmiobject Win32_LogicalDisk -computername localhost -Filter "DriveType = 3"
$global:CDriveFree = 100-(($Disk.freespace/$Disk.size) * 100); $CDriveFree = [math]::round($CDriveFree)
$global:TotalRAM = Get-CimInstance Win32_PhysicalMemory | Measure-Object -Property capacity -Sum | Foreach {"{0:N2}" -f ([math]::round(($_.Sum / 1GB),2))}

$global:OSBuild = (Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion" -Name ReleaseId).ReleaseId
}

# This function grabs all the computers in the AD based on input gathered previously.
function Get-Computers ($designation,$range) {
# Function vars go here
$server = <server ip or hostname>
$search_base = "OU=Computers,DC=example,DC=com"
$disabled_ou = "OU=Disabled Computers,DC=example,DC=com"				# The systems administrator will move a disabled machine into this OU so we can keep the object intact.
If ($range -ne '*' ) { 
$range = Invoke-Expression $range
Foreach($item in $range) {
If ($item -lt 10) {
$reference = $designation + "0" + $item 
} Else { 
$reference = $designation + $item 
}
$computer_Objects = Get-ADComputer -Server $server -Credential $global:creds -SearchBase $search_base -Filter "Name -like '$reference'" -Properties *
$computer_Disabled = Get-ADComputer -Server $server -Credential $global:creds -SearchBase $disabled_ou -Filter "Name -like '$reference'" -Properties *

$list.Add($computer_Objects) | Out-Null
$list.Add($computer_Disabled) | Out-Null
}
} Else {
$reference = $designation + "*"
$computer_Objects = Get-ADComputer -Server $server -Credential $global:creds -SearchBase $search_base -Filter "Name -like '$reference'" -Properties *
$computer_Disabled = Get-ADComputer -Server $server -Credential $global:creds -SearchBase $disabled_ou -Filter "Name -like '$reference'" -Properties *
ForEach ( $item in $computer_Objects) {
$list.Add($item) | Out-Null
}
ForEach ( $item in $computer_Disabled) {
$list.Add($item) | Out-Null
}
}
Write-Host " "
}

# This function grabs all computers matching input parameters and lists the requested output.

# Wrote the prompt as a function to reduce code waste.
function Prompt-List {

$list.Clear()
Write-Output "This can work with both ranges and single stations/laptops."
Write-Output "When doing a single station, enter in it's full name as the designation, and a * for the 'range'."
Write-Output "When doing a range or series, enter in the designation in the following format: StaffLT or StaffWS etc."
Write-Output "When asking for the range the syntax is x..y e.g. 1..30 or whatever range you need."
Write-Output "Example: Designation: LoanerLT    Range: 1..10"
Write-Output "In that example, it will search for all machines matching that range."

$designation = Read-Host -Prompt "Enter the full name or a part of the name to search a range"
$range = Read-Host -Prompt "Enter a number range or put * to do all machines in designation"


Get-Computers $designation $range
}

<# 
This is the main thing here. This will pull all .ps1 files from a directory and list them in a numbered list.
It dynamically generates a list with the resulting files and the user then can pick whatever script they want to run.
If the script is coded correctly you can call this function again to reload the menu.
This was designed so that the main program could be made into an EXE and not need recompiled each time a script was updated or a new one added.
#>
Function File-Menu($path) {
$files = Get-ChildItem $($path + "*.ps1")
$list_number = 0
ForEach ($script in $files){
Write-Host $("$list_number" + ") " + $script.name)
$list_number++
}
Write-Host $("$list_number" + ") " + "Exit")
$selection = Read-Host -Prompt "Select item to run"
If ($selection -eq $list_number) {
exit 0
} else {
clear
& $($path + $files[$selection].name)
}
}

# Made this for application installers so the console will beep at the technician indicating the install has completed.
function AppInstall-Complete() {
                   [console]::beep(500,300) ; [console]::beep(600,300)
                   Write-Host "Application installed!"
                   Pause
                   AppInstall-Menu
}