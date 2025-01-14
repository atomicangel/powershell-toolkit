<# This does an installation of the Latitude 3189 BIOS. #>

# Functions go here.

$ErrorActionPreference= 'silentlycontinue'

$list = [System.Collections.ArrayList]@()
$list.Clear()

function get-computers ($designation,$range) {
If ($range -ne 0 ) { 
$range = Invoke-Expression $range
Foreach($item in $range) {
If ($item -lt 10) { $reference = $designation + "0" + $item 
} Else { 
$reference = $designation + $item 
}
$computer = Get-ADComputer -Filter "Name -like '$reference'" -Properties *

$list.Add($computer)
}
} Else {
$reference = $designation + "*"
$computer = Get-ADComputer -Filter "Name -like '$reference'" -Properties *
ForEach ( $item in $computer) {
$list.Add($item) | Out-Null
}
}
Write-Host " "
Write-Host " "
}

function install() {
ForEach ($computer in $list) {
Write-Output $computer.name

$biosargs = '\\' + $computer.name + ' -accepteula -u example\admin_user -p <password> -w C:\Windows\Temp\ -d -h -n 4 cmd /c "\\location\of\Firmware\lat3189_1220.exe" /forceit /s /f /r /p=flash /l=c:\install\biosup.log '

Start-Process \\location\of\psexec $biosargs -NoNewWindow -Wait


}

}



#Variables go here.

$list.Clear()
Write-Output "The desgination has been redesigned to work more efficiently."
Write-Output "You can do the following: UserLT as the designation."
Write-Output "When asking for the range the syntax is x..y e.g. 1..30 or whatever range you need."

$designation = Read-Host -Prompt "Enter designation"
$range = Read-Host -Prompt "Enter a number range or put 0 to do all machines in designation."

get-computers $designation $range
Write-Output "Starting install..."
install

sleep 1

[console]::beep(400,500)
pause
Main-Menu